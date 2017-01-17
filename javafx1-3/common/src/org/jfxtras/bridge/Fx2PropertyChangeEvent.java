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
import com.sun.javafx.runtime.annotation.Public;

import java.beans.PropertyChangeEvent;
import java.beans.PropertyChangeListener;
import java.beans.PropertyChangeSupport;
import java.util.HashMap;
import java.util.Map;

/**
 * This is a bridge that connects a PropertyChangeSupport to one or more JavaFX vars.
 * <p/>
 * This bridge does use reflection only to set things up! Whenever a var is updated there no(!) reflection is used!
 * Therefore the performance is quite good.
 * <p/>
 * <p/>
 * The Code might look like that:
 * <pre>
 * FXObject fxObject = ...
 * Fx2PropertyChangeEvent bridge = Fx2PropertyChangeEvent.bindProperties( "name", "id" ).to( fxObject );
 * bridge.addPropertyChangeListener( "name", new PropertyChangeListener(){...} );
 * </pre>
 */
@Public
public class Fx2PropertyChangeEvent extends AbstractFX2Java {
    private final PropertyChangeSupport pcs;
    private final Map<FXVar, Object> oldValues = new HashMap<FXVar, Object>();

    public Fx2PropertyChangeEvent(FXObject bindee) {
        this(bindee, null);
    }

    public Fx2PropertyChangeEvent(FXObject bindee, PropertyChangeSupport pcs) {
        super(bindee);
        this.pcs = pcs == null ? new PropertyChangeSupport(this) : pcs;
    }

    private Object popOldValue(FXVar fxVar) {
        return oldValues.remove(fxVar);
    }

    private void storeOldValue(FXVar fxVar, Object oldValue) {
        oldValues.put(fxVar, oldValue);
    }

    public void addPropertyChangeListener(PropertyChangeListener listener) {
        pcs.addPropertyChangeListener(listener);
    }

    public void removePropertyChangeListener(PropertyChangeListener listener) {
        pcs.removePropertyChangeListener(listener);
    }

    public void addPropertyChangeListener(String propertyName, PropertyChangeListener listener) {
        pcs.addPropertyChangeListener(propertyName, listener);
    }

    public void removePropertyChangeListener(String propertyName, PropertyChangeListener listener) {
        pcs.removePropertyChangeListener(propertyName, listener);
    }


    public PropertyChangeSupport getPcs() {
        return pcs;
    }

    @Override
    protected void commitInitially(JavaProperty property, Object initialValue) {
        pcs.firePropertyChange(new PropertyChangeEvent(bindee, property.getPropertyName(), null, initialValue));
    }

    @Override
    protected void commit(FXVar fxVar, JavaProperty property, Object newValue) {
        Object oldValue = converterSupport.convertIfNecessary(fxVar, popOldValue(fxVar));
        pcs.firePropertyChange(new PropertyChangeEvent(bindee, property.getPropertyName(), oldValue, newValue));
    }

    @Override
    protected void prepareForUpdate(FXVar fxVar) {
        Object oldValue = bindee.get$(fxVar.getVarNumField());
        storeOldValue(fxVar, oldValue);
    }

    /**
     * Binds the given property names
     *
     * @param propertyNames the property names
     * @return the fluent factory used to create a Fx2PropertyChangeEvent
     */

    public static FluentFactory bindProperties(String... propertyNames) {
        return new FluentFactory(propertyNames);
    }

    /**
     * Binds the given property names
     *
     * @param propertyNames the property names
     * @return the fluent factory used to create a Fx2PropertyChangeEvent
     */

    public static FluentFactory bind(String... propertyNames) {
        return bindProperties(propertyNames);
    }

    /**
     * Fluent factory implementation
     */
    public static class FluentFactory {

        private final String[] propertyNames;

        private FluentFactory(String[] propertyNames) {
            //noinspection AssignmentToCollectionOrArrayFieldFromParameter
            this.propertyNames = propertyNames;
        }

        /**
         * Binds the property names to the given bindee
         *
         * @param bindee the bindee the properties are bound to
         * @return the bridge
         * @noinspection InstanceMethodNamingConvention
         */

        public Fx2PropertyChangeEvent to(FXObject bindee) throws NoSuchFieldException, IllegalAccessException {
            if (propertyNames.length == 0) {
                throw new IllegalArgumentException("Need at least one property to bind to");
            }

            Fx2PropertyChangeEvent bridge = new Fx2PropertyChangeEvent(bindee);
            for (String propertyName : propertyNames) {
                bridge.bind(propertyName);
            }
            return bridge;
        }
    }
}


