/**
 * Copyright (c) 2008-2010, JFXtras Group
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 * 1. Redistributions of source code must retain the above copyright notice,
 *    this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 * 3. Neither the name of JFXtras nor the names of its contributors may be used
 *    to endorse or promote products derived from this software without
 *    specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */

package org.jfxtras.bridge;

import com.sun.javafx.runtime.FXObject;


/**
 * Factory to create a bridge between java and fx objects.
 * <p/>
 * Usage example:
 * <pre>
 * JavaFxBridge.bridge( javaCustomer ).to( fxCustomer ).connecting(
 *  JavaFxBridge.bind( &quot;name&quot; ).to( &quot;name&quot; ).withInverse().initialValue( javaCustomer.getName() ),
 *  JavaFxBridge.bind( &quot;address&quot; ).to( &quot;address&quot; ).withInverse(),
 *  JavaFxBridge.bind( &quot;mail&quot; ).to( &quot;mail&quot; ).
 *    usingConverter( new EmailConverter.Java2Fx() ).
 *    withInverse().usingConverter( new EmailConverter.Fx2Java() )
 * );
 * <p/>
 * </pre>
 */
public class JavaFxBridge {
    public static FluentJavaObject bridge(Object javaObject) {
        return new FluentJavaObject(javaObject);
    }

    public static FluentJavaPropertySource bind(String propertyName) {
        return new FluentJavaPropertySource(propertyName);
    }

    public static class FluentJavaObject {

        private final Object javaObject;

        public FluentJavaObject(Object javaObject) {
            this.javaObject = javaObject;
        }


        public FluentFxObject to(FXObject fxObject) {
            return new FluentFxObject(this, fxObject);
        }
    }

    public static class FluentFxObject {
        private final FluentJavaObject fluentJavaObject;
        private final FXObject fxObject;

        private Java2FxStrategy java2FxStrategy = Java2FxStrategy.PROPERTY_CHANGE_EVENTS;
        private Fx2JavaStrategy fx2JavaStrategy = Fx2JavaStrategy.SETTER;

        public FluentFxObject(FluentJavaObject fluentJavaObject, FXObject fxObject) {
            this.fluentJavaObject = fluentJavaObject;
            this.fxObject = fxObject;
        }

        public void connecting(PropertyBridgeStatement... statements) throws NoSuchFieldException, IllegalAccessException {
            if (statements.length == 0) {
                throw new IllegalArgumentException("Need at least one bridging statement");
            }

            //Java --> FX
            AbstractJava2Fx java2fxBridge = createJava2FxBridge();

            for (PropertyBridgeStatement statement : statements) {
                JavaProperty property = new JavaProperty(statement.propertyName);
                FXVar fxVar = new FXVar(fxObject.getClass(), statement.varName);

                if (statement.initialValueSet) {
                    java2fxBridge.bind(property, fxVar, statement.java2FxConverter, statement.initialValue);
                } else {
                    java2fxBridge.bind(property, fxVar, statement.java2FxConverter);
                }

                if (statement.withInverse) {
                    getOrCreateFx2JavaBridge().bind(fxVar, property, statement.fx2javaConverter);
                }
            }
        }

        private AbstractJava2Fx createJava2FxBridge() throws NoSuchFieldException, IllegalAccessException {
            if (java2FxBridge == null) {
                java2FxBridge = java2FxStrategy.create(fluentJavaObject.javaObject, fxObject);
            }
            return java2FxBridge;
        }

        private AbstractJava2Fx java2FxBridge;
        private AbstractFX2Java fx2JavaBridge;

        /**
         * Return the fx to java bridge (or creates it if necessary)
         *
         * @return the fx to java bridge
         */
        private AbstractFX2Java getOrCreateFx2JavaBridge() {
            if (fx2JavaBridge == null) {
                fx2JavaBridge = fx2JavaStrategy.create(fxObject, fluentJavaObject.javaObject);
            }
            return fx2JavaBridge;
        }

        /**
         * @noinspection ParameterHidesMemberVariable
         */
        public FluentFxObject using(Java2FxStrategy java2FxStrategy, Fx2JavaStrategy fx2JavaStrategy) {
            this.java2FxStrategy = java2FxStrategy;
            this.fx2JavaStrategy = fx2JavaStrategy;
            return this;
        }

        /**
         * @noinspection ParameterHidesMemberVariable
         */
        public FluentFxObject using(AbstractJava2Fx java2FxBridge, AbstractFX2Java fx2JavaBridge) {
            this.java2FxBridge = java2FxBridge;
            this.fx2JavaBridge = fx2JavaBridge;
            return this;
        }
    }

    public static class FluentJavaPropertySource {
        private final String propertyName;

        public FluentJavaPropertySource(String propertyName) {
            this.propertyName = propertyName;
        }

        public PropertyBridgeStatement to(String varName) {
            return new PropertyBridgeStatement(propertyName, varName);
        }
    }

    public static class PropertyBridgeStatement {
        private final String propertyName;

        private final String varName;
        private boolean withInverse;

        private Converter<?, ?> java2FxConverter;
        private Converter<?, ?> fx2javaConverter;

        private Object initialValue;
        private boolean initialValueSet;

        public PropertyBridgeStatement(String propertyName, String varName) {
            this.propertyName = propertyName;
            this.varName = varName;
        }


        public PropertyBridgeStatement usingConverter(Converter<?, ?> converter) {
            if (withInverse) {
                if (fx2javaConverter != null) {
                    throw new IllegalStateException("There has still been set a fx2javaConverter: <" + java2FxConverter + ">");
                }
                if (java2FxConverter == null) {
                    throw new IllegalStateException("No java2FxConverter has been set.");
                }
                fx2javaConverter = converter;
                return this;
            } else {
                if (java2FxConverter != null) {
                    throw new IllegalStateException("There has still been set a java2fxConverter: <" + java2FxConverter + ">");
                }
                java2FxConverter = converter;
                return this;
            }
        }


        public PropertyBridgeStatement withInverse() {
            withInverse = true;
            return this;
        }

        /**
         * @noinspection ParameterHidesMemberVariable
         */

        public PropertyBridgeStatement initialValue(Object initialValue) {
            if (initialValueSet) {
                throw new IllegalStateException("Initial value has still been set!");
            }
            this.initialValue = initialValue;
            initialValueSet = true;
            return this;
        }
    }

}
