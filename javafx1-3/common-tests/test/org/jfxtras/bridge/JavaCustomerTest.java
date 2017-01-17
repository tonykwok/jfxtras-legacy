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

import org.fest.swing.edt.GuiActionRunner;
import org.fest.swing.edt.GuiTask;

import org.junit.Before;
import org.junit.Test;

import static org.junit.Assert.*;


/**
 *
 */
public class JavaCustomerTest {
    private Customer fxCustomer;
    private JavaCustomer javaCustomer;

    @Before
    public void setUp() throws Exception {
        fxCustomer = new Customer();
        javaCustomer = new JavaCustomer();

        assertEquals("", fxCustomer.get$name());
        assertEquals("", fxCustomer.get$address());
        assertNull(fxCustomer.get$mail());

        assertEquals("", javaCustomer.getName());
        assertEquals("", javaCustomer.getAddress());
        assertNull(javaCustomer.getMail());
    }

    @Test
    public void testIt() throws NoSuchFieldException, IllegalAccessException {
        GuiActionRunner.execute(new GuiTask() {
            @Override
            protected void executeInEDT() throws Throwable {


                PropertyChangeEvent2Fx bridge = new PropertyChangeEvent2Fx(javaCustomer, fxCustomer);
                bridge.bind("name");
                bridge.bind("address");
                bridge.bind("mail", new EmailConverter.Java2Fx());

                javaCustomer.setName("MyName");
                javaCustomer.setAddress("MyAddress");
                javaCustomer.setMail(new JavaCustomer.Email("MyMail"));

                assertEquals("MyName", fxCustomer.get$name());
                assertEquals("MyAddress", fxCustomer.get$address());
                assertEquals("MyMail", fxCustomer.get$mail().get$mail());
            }
        });
    }

    @Test
    public void testIntitialUpdate() throws NoSuchFieldException, IllegalAccessException {
        GuiActionRunner.execute(new GuiTask() {
            @Override
            protected void executeInEDT() throws Throwable {

                javaCustomer.setName("initName");
                javaCustomer.setAddress("initAddress");
                javaCustomer.setMail(new JavaCustomer.Email("initMail"));

                assertEquals("initName", javaCustomer.getName());
                assertEquals("initAddress", javaCustomer.getAddress());
                assertEquals("initMail", javaCustomer.getMail().getMail());

                PropertyChangeEvent2Fx bridge = new PropertyChangeEvent2Fx(javaCustomer, fxCustomer);
                bridge.bind("name");

                assertEquals("initName", fxCustomer.get$name());
                assertEquals("", fxCustomer.get$address());
                assertNull(fxCustomer.get$mail());

                bridge.bind("address");
                assertEquals("initName", fxCustomer.get$name());
                assertEquals("initAddress", fxCustomer.get$address());
                assertNull(fxCustomer.get$mail());

                bridge.bind("mail", new EmailConverter.Java2Fx());
                assertEquals("initName", fxCustomer.get$name());
                assertEquals("initAddress", fxCustomer.get$address());
                assertEquals("initMail", fxCustomer.get$mail().get$mail());
            }
        });
    }
}
