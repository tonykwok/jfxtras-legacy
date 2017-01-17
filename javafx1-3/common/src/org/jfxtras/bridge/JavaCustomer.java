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


import java.beans.PropertyChangeEvent;
import java.beans.PropertyChangeListener;
import java.beans.PropertyChangeSupport;

/**
 *
 */
public class JavaCustomer implements PropertyChangeListener {
    private static final String PROPERTY_NAME = "name";
    private static final String PROPERTY_ADDRESS = "address";
    private static final String PROPERTY_MAIL = "mail";

    private String name = "";
    private String address = "";
    private Email mail;

    public JavaCustomer() {
    }

    public JavaCustomer(String name, String address, Email mail) {
        this.name = name;
        this.address = address;
        this.mail = mail;
    }

    public void setName(String name) {
        pcs.firePropertyChange(PROPERTY_NAME, this.name, this.name = name);
    }

    public void setAddress(String address) {
        pcs.firePropertyChange(PROPERTY_ADDRESS, this.address, this.address = address);
    }

    public void setMail(Email mail) {
        pcs.firePropertyChange(PROPERTY_MAIL, this.mail, this.mail = mail);
    }

    public String getName() {
        return name;
    }

    public String getAddress() {
        return address;
    }

    public Email getMail() {
        return mail;
    }

    final PropertyChangeSupport pcs = new PropertyChangeSupport(this);

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

    public static class Email {
        private final String mail;

        public Email(String mail) {
            this.mail = mail;
        }

        public String getMail() {
            return mail;
        }
    }

    public void propertyChange(PropertyChangeEvent evt) {
        if (evt.getPropertyName().equals(PROPERTY_NAME)) {
            setName((String) evt.getNewValue());
        }
        if (evt.getPropertyName().equals(PROPERTY_ADDRESS)) {
            setAddress((String) evt.getNewValue());
        }
        if (evt.getPropertyName().equals(PROPERTY_MAIL)) {
            setMail((Email) evt.getNewValue());
        }
    }
}
