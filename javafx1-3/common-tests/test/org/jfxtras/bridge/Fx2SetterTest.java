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



import org.junit.Test;

import static org.junit.Assert.*;

/**
 *
 */
public class Fx2SetterTest {
    @Test
    public void testReflection() throws NoSuchFieldException, IllegalAccessException {
        Customer fxCustomer = new Customer();
        fxCustomer.set$name("fxName");
        fxCustomer.set$address("fxAddress");

        JavaCustomer javaCustomer = new JavaCustomer();
        assertEquals("", javaCustomer.getName());
        assertEquals("", javaCustomer.getAddress());

        Fx2Setter bridge = new Fx2Setter(fxCustomer, javaCustomer, new Fx2Setter.ReflectionSetterStrategy());
        bridge.bind("name");
        bridge.bind("address");

        assertEquals("fxName", javaCustomer.getName());
        assertEquals("fxAddress", javaCustomer.getAddress());

        fxCustomer.set$name("newName");
        assertEquals("newName", javaCustomer.getName());
        fxCustomer.set$address("newAddress");
        assertEquals("newAddress", javaCustomer.getAddress());
    }

    @Test
    public void testDifferentNames() throws NoSuchFieldException, IllegalAccessException {
        Customer fxCustomer = new Customer();
        fxCustomer.set$name("fxName");
        fxCustomer.set$address("fxAddress");

        JavaCustomer javaCustomer = new JavaCustomer();
        assertEquals("", javaCustomer.getName());
        assertEquals("", javaCustomer.getAddress());

        Fx2Setter bridge = new Fx2Setter(fxCustomer, javaCustomer, new Fx2Setter.ReflectionSetterStrategy());
        bridge.bind(new FXVar(fxCustomer.getClass(), "name"), new JavaProperty("address"));

        assertEquals("", javaCustomer.getName());
        assertEquals("fxName", javaCustomer.getAddress());

        fxCustomer.set$name("newName");
        assertEquals("newName", javaCustomer.getAddress());
        fxCustomer.set$address("newAddress");
        assertEquals("newName", javaCustomer.getAddress());
    }

    @Test
    public void testManually() throws NoSuchFieldException, IllegalAccessException {
        Customer fxCustomer = new Customer();
        fxCustomer.set$name("fxName");
        fxCustomer.set$address("fxAddress");

        JavaCustomer javaCustomer = new JavaCustomer();
        assertEquals("", javaCustomer.getName());
        assertEquals("", javaCustomer.getAddress());

        Fx2Setter bridge = new Fx2Setter(fxCustomer, javaCustomer, new Fx2Setter.SetterStrategy() {
            public void set(Object object, JavaProperty property, Object value) {
                if (property.getPropertyName().equals("name")) {
                    ((JavaCustomer) object).setName((String) value);
                } else if (property.getPropertyName().equals("address")) {
                    ((JavaCustomer) object).setAddress((String) value);
                } else {
                    throw new IllegalArgumentException(property.getPropertyName());
                }
            }
        });
        bridge.bind("name");
        bridge.bind("address");

        assertEquals("fxName", javaCustomer.getName());
        assertEquals("fxAddress", javaCustomer.getAddress());

        fxCustomer.set$name("newName");
        assertEquals("newName", javaCustomer.getName());
        fxCustomer.set$address("newAddress");
        assertEquals("newAddress", javaCustomer.getAddress());
    }
}
