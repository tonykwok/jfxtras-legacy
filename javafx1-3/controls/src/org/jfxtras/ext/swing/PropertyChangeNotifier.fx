/*
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

package org.jfxtras.ext.swing;

import java.beans.PropertyChangeEvent;
import java.beans.PropertyChangeListener;
import javax.swing.event.SwingPropertyChangeSupport;

/**
 * A simple mixin providing delegation to {@code javax.swing.event.SwingPropertyChangeSupport}.
 *
 * @profile desktop
 * @see javax.swing.event.SwingPropertyChangeSupport
 * @author John Freeman
 */
public mixin class PropertyChangeNotifier {
    def propertyChangeSupport = new SwingPropertyChangeSupport(this);

    /**
     * Add a PropertyChangeListener.
     */
    public function addPropertyChangeListener(listener:PropertyChangeListener):Void {
        propertyChangeSupport.addPropertyChangeListener(listener);
    }

    /**
     * Add a PropertyChangeListener for a specific property.
     */
    public function addPropertyChangeListener(propertyName:String, listener:PropertyChangeListener):Void {
        propertyChangeSupport.addPropertyChangeListener(propertyName, listener);
    }

    /**
     * Report a bound indexed property update to any registered listeners.
     */
    protected function fireIndexedPropertyChange(propertyName:String, index:Integer, oldValue:Object, newValue:Object):Void {
        propertyChangeSupport.fireIndexedPropertyChange(propertyName, index, oldValue, newValue);
    }

    /**
     * Fire an existing PropertyChangeEvent to any registered listeners.
     */
    protected function firePropertyChange(evt:PropertyChangeEvent):Void {
        propertyChangeSupport.firePropertyChange(evt);
    }

    /**
     * Report a bound property update to any registered listeners.
     */
    protected function firePropertyChange(propertyName:String, oldValue:Object, newValue:Object):Void {
        propertyChangeSupport.firePropertyChange(propertyName, oldValue, newValue);
    }

    /**
     * Returns an array of the currently registered listeners.
     */
    protected function getPropertyChangeListeners():PropertyChangeListener[] {
        return propertyChangeSupport.getPropertyChangeListeners();
    }


    /**
     * Returns an array of the currently registered listeners which have been associated with the named property.
     */
    protected function getPropertyChangeListeners(propertyName:String):PropertyChangeListener[] {
        return propertyChangeSupport.getPropertyChangeListeners(propertyName);
    }

    /**
     * Check if there are any listeners for a specific property, including those registered on all properties.
     */
    protected function hasListeners(propertyName:String):Boolean {
        return propertyChangeSupport.hasListeners(propertyName);
    }

    /**
     * Remove a PropertyChangeListener.
     */
    public function removePropertyChangeListener(listener:PropertyChangeListener):Void {
        propertyChangeSupport.removePropertyChangeListener(listener);
    }

    /**
     * Remove a PropertyChangeListener for a specific property.
     */
    public function removePropertyChangeListener(propertyName:String, listener:PropertyChangeListener):Void {
        propertyChangeSupport.removePropertyChangeListener(propertyName, listener);
    }

}
