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
import org.apache.commons.beanutils.PropertyUtilsBean;

import java.lang.reflect.InvocationTargetException;

/**
 * Binder that calls setters using a given strategy on a java object.
 * <p/>
 * This bridge offers a way to updated java objects when JavaFX objects are updated.
 */
public class Fx2Setter extends AbstractFX2Java {
    private final Object binder;
    private final SetterStrategy setterStrategy;

    public Fx2Setter(FXObject bindee, Object binder, SetterStrategy setterStrategy) {
        super(bindee);
        this.binder = binder;
        this.setterStrategy = setterStrategy;
    }

    @Override
    protected void commitInitially(JavaProperty property, Object initialValue) {
        set(property, initialValue);
    }

    @Override
    protected void commit(FXVar fxVar, JavaProperty property, Object newValue) {
        set(property, newValue);
    }

    @Override
    protected void prepareForUpdate(FXVar fxVar) {
        //do nothing...
    }

    protected void set(JavaProperty property, Object value) {
        setterStrategy.set(binder, property, value);
    }

    /**
     * Setter strategy that is used to call the setters on the java objects.
     * For performance reasons this strategy can be implemented using if/else cascades instead of using reflection.
     */
    public interface SetterStrategy {
        /**
         * Sets the value for the given property name
         *
         * @param object   the object
         * @param property the property
         * @param value    the new value
         */
        void set(Object object, JavaProperty property, Object value);
    }

    /**
     * This strategy uses reflection to call the setters.
     * It is necessary to add a dependency to "commons-beanutils" to use this class properly:
     * <pre>
     * &lt;dependency&gt;
     *  &lt;groupId&gt;commons-beanutils&lt;/groupId&gt;
     *  &lt;artifactId&gt;commons-beanutils&lt;/artifactId&gt;
     * &lt;/dependency&gt;
     * <p/>
     * </pre>
     */
    public static class ReflectionSetterStrategy implements SetterStrategy {
        private final PropertyUtilsBean propertyUtilsBean = new PropertyUtilsBean();

        public void set(Object object, JavaProperty property, Object value) {
            try {
                propertyUtilsBean.setSimpleProperty(object, property.getPropertyName(), value);
            } catch (InvocationTargetException e) {
                throw new RuntimeException(e.getTargetException());
            } catch (Exception e) {
                throw new RuntimeException(e);
            }
        }

    }
}
