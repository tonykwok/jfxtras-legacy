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

import java.beans.PropertyChangeEvent;
import java.beans.PropertyChangeListener;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;

/**
 * Java to FX synchronization based on PropertyChangeEvents.
 * This bridge registers a property change listener to the Java object.
 */
public class PropertyChangeEvent2Fx extends AbstractJava2Fx {
    private static final String ADD_PROP_CHANGE_LISTENER_METHOD_NAME = "addPropertyChangeListener";

    public PropertyChangeEvent2Fx(Object bindee, FXObject binder) {
        super(bindee, binder);

        try {
            Method method = bindee.getClass().getMethod(ADD_PROP_CHANGE_LISTENER_METHOD_NAME, PropertyChangeListener.class);
            method.invoke(bindee, new FxUpdatingPropertyChangeListener());
        } catch (NoSuchMethodException e) {
            throw new IllegalArgumentException("Invalid bindee <" + bindee + "> - does not have <addPropertyChangeListener> method", e);
        } catch (IllegalAccessException e) {
            throw new RuntimeException(e);
        } catch (InvocationTargetException e) {
            throw new RuntimeException(e.getTargetException());
        }
    }

    @Override
    protected Object getInitialValue(JavaProperty property) throws NoSuchFieldException, IllegalAccessException {
        return getValueByReflection(property);
    }

    /**
     * Property change listener that updates the vars on a fx object
     */
    private class FxUpdatingPropertyChangeListener implements PropertyChangeListener {
        public void propertyChange(PropertyChangeEvent evt) {
            String propertyName = evt.getPropertyName();
            Object value = evt.getNewValue();
            setVar(new JavaProperty(propertyName), value);
        }
    }
}
