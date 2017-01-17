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
import org.junit.Test;

import javax.swing.*;
import java.lang.reflect.InvocationTargetException;

import static org.junit.Assert.*;

/**
 *
 */
public class JavaFxBridgeTest {
    @Test
    public void testApi() throws NoSuchFieldException, IllegalAccessException {
        final Customer fxCustomer = new Customer();
        final JavaCustomer javaCustomer = new JavaCustomer();

        GuiActionRunner.execute(new GuiTask() {
            @Override
            protected void executeInEDT() throws Throwable {
                JavaFxBridge.bridge(javaCustomer).to(fxCustomer).connecting(
                    JavaFxBridge.bind("name").to("name").withInverse().initialValue(javaCustomer.getName()),
                    JavaFxBridge.bind("address").to("address").withInverse(),
                    JavaFxBridge.bind("mail").to("mail").
                        usingConverter(new EmailConverter.Java2Fx()).
                        withInverse().usingConverter(new EmailConverter.Fx2Java())
                );

                javaCustomer.setName("newName");
                assertEquals("newName", fxCustomer.get$name());
                fxCustomer.set$name("fxNewName");
                assertEquals("fxNewName", javaCustomer.getName());

                javaCustomer.setAddress("newAddress");
                assertEquals("newAddress", fxCustomer.get$address());

                Customer.Email fxMail = new Customer.Email();
                fxMail.set$mail("hey");
                fxCustomer.set$mail(fxMail);

                assertEquals("hey", javaCustomer.getMail().getMail());
            }
        });
    }

    @Test
    public void testApi2() throws NoSuchFieldException, IllegalAccessException {
        final Customer fxCustomer = new Customer();
        final JavaCustomer javaCustomer = new JavaCustomer();

        GuiActionRunner.execute(new GuiTask() {
            @Override
            protected void executeInEDT() throws Throwable {
                JavaFxBridge.bridge(javaCustomer).to(fxCustomer).using(new PropertyChangeEvent2Fx(javaCustomer, fxCustomer), new Fx2Setter(fxCustomer, javaCustomer, new Fx2Setter.SetterStrategy() {
                    public void set(Object object, JavaProperty property, Object value) {
                        if (property.getPropertyName().equals("name")) {
                            ((JavaCustomer) object).setName((String) value);
                        }
                        if (property.getPropertyName().equals("address")) {
                            ((JavaCustomer) object).setAddress((String) value);
                        }
                        if (property.getPropertyName().equals("mail")) {
                            ((JavaCustomer) object).setMail((JavaCustomer.Email) value);
                        }
                    }
                })).connecting(
                    JavaFxBridge.bind("name").to("name").withInverse().initialValue(javaCustomer.getName()),
                    JavaFxBridge.bind("address").to("address").withInverse(),
                    JavaFxBridge.bind("mail").to("mail").
                        usingConverter(new EmailConverter.Java2Fx()).
                        withInverse().usingConverter(new EmailConverter.Fx2Java())
                );

                javaCustomer.setName("newName");
                assertEquals("newName", fxCustomer.get$name());
                fxCustomer.set$name("fxNewName");
                assertEquals("fxNewName", javaCustomer.getName());

                javaCustomer.setAddress("newAddress");
                assertEquals("newAddress", fxCustomer.get$address());

                Customer.Email fxMail = new Customer.Email();
                fxMail.set$mail("hey");
                fxCustomer.set$mail(fxMail);

                assertEquals("hey", javaCustomer.getMail().getMail());
            }
        });
    }

    @Test
    public void testStrategies() throws Throwable, IllegalAccessException {
        for (Java2FxStrategy java2FxStrategy : Java2FxStrategy.values()) {
            if (java2FxStrategy == Java2FxStrategy.BUSY) {
                continue;
            }

            for (Fx2JavaStrategy fx2JavaStrategy : Fx2JavaStrategy.values()) {
                try {
                    testStrategy(java2FxStrategy, fx2JavaStrategy);
                } catch (Throwable e) {
                    System.err.println("Failed with <" + java2FxStrategy + "> / <" + fx2JavaStrategy + ">");
                    throw e;
                    //throw new RuntimeException( "Failed with <" + java2FxStrategy + "> / <" + fx2JavaStrategy + ">", e );
                }
            }
        }
    }

    private void testStrategy(final Java2FxStrategy java2FxStrategy, final Fx2JavaStrategy fx2JavaStrategy) throws Throwable {
        final Customer fxCustomer = new Customer();
        final JavaCustomer javaCustomer = new JavaCustomer();

        try {
            SwingUtilities.invokeAndWait(new Runnable() {
                public void run() {
                    try {
                        JavaFxBridge.bridge(javaCustomer).to(fxCustomer).using(java2FxStrategy, fx2JavaStrategy).connecting(
                            JavaFxBridge.bind("name").to("name").withInverse(),
                            JavaFxBridge.bind("address").to("address").withInverse(),
                            JavaFxBridge.bind("mail").to("mail").
                                usingConverter(new EmailConverter.Java2Fx()).
                                withInverse().usingConverter(new EmailConverter.Fx2Java())
                        );

                        javaCustomer.setName("newName");
                        assertEquals("newName", fxCustomer.get$name());
                        fxCustomer.set$name("fxNewName");
                        assertEquals("fxNewName", javaCustomer.getName());

                        javaCustomer.setAddress("newAddress");
                        assertEquals("newAddress", fxCustomer.get$address());

                        Customer.Email fxMail = new Customer.Email();
                        fxMail.set$mail("hey");
                        fxCustomer.set$mail(fxMail);

                        assertEquals("hey", javaCustomer.getMail().getMail());
                    } catch (Exception e) {
                        throw new RuntimeException(e);
                    }
                }
            });
        } catch (InvocationTargetException e) {
            throw e.getTargetException();
        }
    }
}
