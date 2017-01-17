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

import javax.swing.*;
import java.lang.reflect.Field;
import java.util.HashMap;
import java.util.Map;

/**
 * Abstract base class for Java to FX synchronization
 */
public abstract class AbstractJava2Fx {
    protected final Object bindee;
    protected final FXObject binder;
    protected final Map<JavaProperty, FXVar> boundVars = new HashMap<JavaProperty, FXVar>();
    protected final ConverterSupport<FXVar> converterSupport = new ConverterSupport<FXVar>();

    protected AbstractJava2Fx(Object bindee, FXObject binder) {
        this.bindee = bindee;
        this.binder = binder;
    }

    /**
     * Returns the bound vor the given property name
     *
     * @param property the property
     * @return the bound var (null if there is no bound var for that property name)
     */

    protected FXVar getBoundVar(JavaProperty property) {
        return boundVars.get(property);
    }

    /**
     * Binds a property.
     * This method uses reflection to get the initial value of the property. If you want to set the initial value manually use
     * {@link #bind(String, Converter, Object)} instead.
     *
     * @param propertyName the name of the property
     * @throws NoSuchFieldException
     * @throws IllegalAccessException
     */
    public void bind(String propertyName) throws NoSuchFieldException, IllegalAccessException {
        bind(propertyName, null);
    }

    /**
     * Binds a property.
     * This method uses reflection to get the initial value of the property. Use {@link #bind(String, Converter, Object)} to avoid
     * the usage of reflection.
     *
     * @param propertyName the name of the property
     * @param converter    the (optional) converter
     * @param <J>          the property type on the Java side
     * @param <X>          the property type on the JavaFX side
     * @throws NoSuchFieldException
     * @throws IllegalAccessException
     */
    public <J, X> void bind(String propertyName, Converter<J, X> converter) throws NoSuchFieldException, IllegalAccessException {
        bind(propertyName, converter, (J) getInitialValue(new JavaProperty(propertyName)));
    }

    /**
     * Binds a property
     *
     * @param propertyName the name of the property
     * @param converter    the (optional) converter
     * @param initialValue the initial value (unconverted). This parameter may be used to avoid the usage of reflection
     * @param <J>          the property type on the Java side
     * @param <X>          the property type on the JavaFX side
     * @throws NoSuchFieldException
     * @throws IllegalAccessException
     */
    public <J, X> void bind(String propertyName, Converter<J, X> converter, J initialValue) throws NoSuchFieldException, IllegalAccessException {
        FXVar fxVar = new FXVar(binder.getClass(), propertyName);
        JavaProperty javaProperty = new JavaProperty(propertyName);
        bind(javaProperty, fxVar, converter, initialValue);
    }

    public <J, X> void bind(JavaProperty javaProperty, FXVar fxVar) throws NoSuchFieldException, IllegalAccessException {
        bind(javaProperty, fxVar, null);
    }

    public <J, X> void bind(JavaProperty javaProperty, FXVar fxVar, Converter<J, X> converter) throws NoSuchFieldException, IllegalAccessException {
        bind(javaProperty, fxVar, converter, getInitialValue(javaProperty));
    }

    /**
     * Binds a property
     *
     * @param javaProperty the java property
     * @param fxVar        the fx var
     * @param converter    the optional converter
     * @param initialValue the initial value
     * @param <J>          the property type on the Java side
     * @param <X>          the property type on the JavaFX side
     */
    public <J, X> void bind(JavaProperty javaProperty, FXVar fxVar, Converter<J, X> converter, Object initialValue) {
        boundVars.put(javaProperty, fxVar);

        converterSupport.store(fxVar, converter);

        //Set the initial value
        setVar(fxVar, initialValue);
    }

    /**
     * Returns the initial value of the property of the bindee.
     *
     * @param property the property
     * @return the initial value
     * @throws NoSuchFieldException
     * @throws IllegalAccessException
     */

    protected abstract Object getInitialValue(JavaProperty property) throws NoSuchFieldException, IllegalAccessException;

    /**
     * Returns the initial value of the property using reflection.
     * It is expected to contain a field with given name
     *
     * @param property the property
     * @return the initial value
     */

    protected Object getValueByReflection(JavaProperty property) throws NoSuchFieldException, IllegalAccessException {
        Field field = bindee.getClass().getDeclaredField(property.getPropertyName());
        field.setAccessible(true);
        return field.get(bindee);
    }

    /**
     * This method must only be called from EDT!
     *
     * @param property the property
     * @param value    the value
     */
    protected void setVar(JavaProperty property, Object value) {
        FXVar fxVar = getBoundVar(property);
        if (fxVar == null) {
            return;
        }

        setVar(fxVar, value);
    }

    /**
     * This method must only be called from EDT
     *
     * @param fxVar the fxVar
     * @param value the new value
     */
    protected void setVar(FXVar fxVar, Object value) {
        assert SwingUtilities.isEventDispatchThread();

        Object convertedValue = converterSupport.convertIfNecessary(fxVar, value);
        binder.set$(fxVar.getVarNumField(), convertedValue);
    }


    public Object getBindee() {
        return bindee;
    }


    public FXObject getBinder() {
        return binder;
    }
}
