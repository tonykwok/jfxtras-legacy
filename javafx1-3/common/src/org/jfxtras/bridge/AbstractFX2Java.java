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

import com.sun.javafx.runtime.DependentsManager;
import com.sun.javafx.runtime.FXBase;
import com.sun.javafx.runtime.FXObject;

import java.util.ArrayList;
import java.util.List;

/**
 * Abstract base class for synchronization from FX to Java.
 * Use the {@link #bind(FXVar, JavaProperty, Converter, boolean)} method to bind vars to java properties.
 * <p/>
 * There is also a factory ({@link JavaFxBridge}) that can be used to create mappings.
 *
 * @noinspection AbstractClassExtendsConcreteClass
 */
public abstract class AbstractFX2Java extends FXBase {
    protected final FXObject bindee;
    protected final List<FXVar> fxVars = new ArrayList<FXVar>();
    protected final List<JavaProperty> javaProperties = new ArrayList<JavaProperty>();
    protected final ConverterSupport<FXVar> converterSupport = new ConverterSupport<FXVar>();

    /**
     * Creates a new bridge
     *
     * @param bindee the bindee (the FX source)
     */
    protected AbstractFX2Java(FXObject bindee) {
        super(false);
        initialize$(true);

        this.bindee = bindee;
    }

    /**
     * Binds the given var
     *
     * @param varName the name of the var
     */
    public void bind(String varName) throws NoSuchFieldException, IllegalAccessException {
        bind(varName, null);
    }

    /**
     * Binds the given var
     *
     * @param varName   the name of the var
     * @param converter the (optional) converter
     * @param <X>       the property type on the JavaFX side
     * @param <J>       the property type on the Java side
     * @throws NoSuchFieldException
     * @throws IllegalAccessException
     */
    public <X, J> void bind(String varName, Converter<X, J> converter) throws NoSuchFieldException, IllegalAccessException {
        bind(varName, converter, true);
    }

    /**
     * Binds the given property name.
     *
     * @param propertyName    the property name
     * @param converter       the (optional) converter
     * @param commitInitially whether to commit the action initially
     * @param <X>             the JavaFX type of the property
     * @param <J>             the Java type of the property
     * @throws NoSuchFieldException
     * @throws IllegalAccessException
     */
    public <X, J> void bind(String propertyName, Converter<X, J> converter, boolean commitInitially) throws NoSuchFieldException, IllegalAccessException {
        FXVar fxVar = new FXVar(bindee.getClass(), propertyName);
        JavaProperty javaProperty = new JavaProperty(propertyName);
        bind(fxVar, javaProperty, converter, commitInitially);
    }

    public <X, J> void bind(FXVar fxVar, JavaProperty javaProperty) {
        bind(fxVar, javaProperty, null);
    }

    public <X, J> void bind(FXVar fxVar, JavaProperty javaProperty, Converter<X, J> converter) {
        bind(fxVar, javaProperty, converter, true);
    }

    public <X, J> void bind(FXVar fxVar, JavaProperty javaProperty, Converter<X, J> converter, boolean commitInitially) {
        int index = addEntry(fxVar, javaProperty);

        converterSupport.store(fxVar, converter);
        DependentsManager.addDependent(bindee, fxVar.getVarNumField(), this, index);

        //fire the event for the initial value
        if (commitInitially) {
            Object initialValue = bindee.get$(fxVar.getVarNumField());
            commitInitially(javaProperty, converterSupport.convertIfNecessary(fxVar, initialValue));
        }
    }

    /**
     * Adds an entry
     *
     * @param fxVar        the var
     * @param javaProperty the property
     * @return the index of this entry
     */
    protected int addEntry(FXVar fxVar, JavaProperty javaProperty) {
        int index = fxVars.size();
        fxVars.add(fxVar);
        javaProperties.add(javaProperty);
        return index;
    }


    private FXVar getEntry(int depNum) {
        return fxVars.get(depNum);
    }


    private JavaProperty getProperty(int depNum) {
        return javaProperties.get(depNum);
    }

    /**
     * Commits initially
     *
     * @param property     the java property
     * @param initialValue the initial value (that has been converted if necessary)
     */
    protected abstract void commitInitially(JavaProperty property, Object initialValue);

    /**
     * @noinspection DollarSignInName
     */
    @Override
    public boolean update$(FXObject src, int depNum, int startPos, int endPos, int newLength, int phase) {
        FXVar fxVar = getEntry(depNum);
        if (phase == PHASE_TRANS$CASCADE_INVALIDATE) {
            prepareForUpdate(fxVar);
        } else if (phase == PHASE_TRANS$CASCADE_TRIGGER) {
            Object newValue = src.get$(fxVar.getVarNumField());
            JavaProperty property = getProperty(depNum);
            commit(fxVar, property, converterSupport.convertIfNecessary(fxVar, newValue));
        } else {
            throw new IllegalStateException("Invalid phase: " + phase);
        }

        super.update$(src, depNum, startPos, endPos, newLength, phase);
        return true;
    }

    /**
     * Commits the value
     *
     * @param fxVar    the fx var
     * @param property the java property
     * @param newValue the new value (that has been converted if necessary)
     */
    protected abstract void commit(FXVar fxVar, JavaProperty property, Object newValue);

    /**
     * Is called before a var is updated
     *
     * @param fxVar the fx var
     */
    protected abstract void prepareForUpdate(FXVar fxVar);

    public FXObject getBindee() {
        return bindee;
    }
}
