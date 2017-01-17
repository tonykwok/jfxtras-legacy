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

import com.cedarsoft.MockitoTemplate;
import org.hamcrest.BaseMatcher;
import org.hamcrest.Description;
import org.junit.Test;
import org.mockito.Mock;

import javax.script.ScriptException;
import java.beans.PropertyChangeEvent;
import java.beans.PropertyChangeListener;

import static org.mockito.Mockito.*;
import static org.junit.Assert.*;

/**
 *
 */
public class CustomerTest {
    public static void main(String[] args) throws InterruptedException, NoSuchFieldException, IllegalAccessException {
        {
            Customer customer = CustomerCreator.create();

            Fx2PropertyChangeEvent bridge = Fx2PropertyChangeEvent.bind("name", "address", "mail").to(customer);

            bridge.addPropertyChangeListener(new PropertyChangeListener() {
                public void propertyChange(PropertyChangeEvent evt) {
                    System.out.println("---> Property updated on " + evt.getSource());
                    System.out.println("\t\t\"" + evt.getPropertyName() + "\" changed from <" + evt.getOldValue() + "> to <" + evt.getNewValue() + ">");
                }
            });

            System.out.println("Setting new name");
            customer.set$name("Heidi Klumm");
            System.out.println("Setting new address");
            customer.set$address("Hollywood");
            System.out.println("Setting new mail");
            Customer.Email newMail = new Customer.Email();
            newMail.set$mail("heidi@klumm.com");
            customer.set$mail(newMail);
            System.out.println("-------------------");
        }

        System.out.println();
        System.out.println();
        System.out.println("--------------------------------");
        System.out.println();
        System.out.println();

        {
            Customer.M customer = CustomerCreator.createM();

            customer.get$pcs().addPropertyChangeListener(new PropertyChangeListener() {
                public void propertyChange(PropertyChangeEvent evt) {
                    System.out.println("---> Property updated on " + evt.getSource());
                    System.out.println("\t\t\"" + evt.getPropertyName() + "\" changed from <" + evt.getOldValue() + "> to <" + evt.getNewValue() + ">");
                }
            });

            System.out.println("Setting new name");
            customer.set$name("Heidi Klumm");
            System.out.println("Setting new address");
            customer.set$address("Hollywood");
            System.out.println("Setting new mail");
            Customer.Email newMail = new Customer.Email();
            newMail.set$mail("heidi@klumm.com");
            customer.set$mail(newMail);
            System.out.println("-------------------");
        }
    }

    @Test
    public void testManual() {
        Customer.M customer = CustomerCreator.createM();

        assertEquals("Max Mustermann", customer.get$name());
        assertEquals("MyStreet 77, NY", customer.get$address());
        assertEquals("mustermann@gafff.de", customer.get$mail().get$mail());
    }

    @Test
    public void testSimple() throws ScriptException {
        Customer customer = CustomerCreator.create();

        assertEquals("Max Mustermann", customer.get$name());
        assertEquals("MyStreet 77, NY", customer.get$address());
        assertEquals("mustermann@gafff.de", customer.get$mail().get$mail());
    }

    @Test
    public void testMulti() throws Exception {
        for (int i = 0; i < 1000; i++) {
            testMock();
        }
    }

    @Test
    public void testMock() throws Exception, InterruptedException {
        new MockitoTemplate() {
            @Mock
            private PropertyChangeListener listener;

            private final Customer customer = CustomerCreator.create();

            @Override
            protected void stub() throws Exception {
            }

            @Override
            protected void execute() throws Exception {
                Fx2PropertyChangeEvent bridge = Fx2PropertyChangeEvent.bind("name", "address", "mail").to(customer);
                bridge.addPropertyChangeListener(listener);

                customer.set$name("Other name");
                customer.set$name("Heidi Klumm");
                customer.set$address("Hollywood");
                Customer.Email newMail = new Customer.Email();
                newMail.set$mail("heidi@klumm.com");
                customer.set$mail(newMail);
            }

            @Override
            protected void verifyMocks() throws Exception {
                verify(listener).propertyChange(refEq(new PropertyChangeEvent(customer, "name", "Max Mustermann", "Other name")));
                verify(listener).propertyChange(refEq(new PropertyChangeEvent(customer, "name", "Other name", "Heidi Klumm")));
                verify(listener).propertyChange(refEq(new PropertyChangeEvent(customer, "address", "MyStreet 77, NY", "Hollywood")));

                verify(listener).propertyChange(argThat(new BaseMatcher<PropertyChangeEvent>() {
                    public boolean matches(Object item) {
                        PropertyChangeEvent event = (PropertyChangeEvent) item;
                        if (!event.getPropertyName().equals("mail")) {
                            return false;
                        }

                        Customer.Email oldMail = (Customer.Email) event.getOldValue();
                        Customer.Email newMail = (Customer.Email) event.getNewValue();

                        return oldMail.get$mail().equals("mustermann@gafff.de") && newMail.get$mail().equals("heidi@klumm.com");
                    }

                    public void describeTo(Description description) {
                        description.appendText("Comparing mail");
                    }
                }));
                verifyNoMoreInteractions(listener);
            }
        }.run();
    }


    @Test
    public void testMockM() throws Exception, InterruptedException {
        new MockitoTemplate() {
            @Mock
            private PropertyChangeListener listener;

            private final Customer.M customer = CustomerCreator.createM();

            @Override
            protected void stub() throws Exception {
            }

            @Override
            protected void execute() throws Exception {
                customer.get$pcs().addPropertyChangeListener(listener);

                customer.set$name("Other name");
                customer.set$name("Heidi Klumm");
                customer.set$address("Hollywood");
                Customer.Email newMail = new Customer.Email();
                newMail.set$mail("heidi@klumm.com");
                customer.set$mail(newMail);
            }

            @Override
            protected void verifyMocks() throws Exception {
                verify(listener).propertyChange(refEq(new PropertyChangeEvent(customer, "name", "Max Mustermann", "Other name")));
                verify(listener).propertyChange(refEq(new PropertyChangeEvent(customer, "name", "Other name", "Heidi Klumm")));
                verify(listener).propertyChange(refEq(new PropertyChangeEvent(customer, "address", "MyStreet 77, NY", "Hollywood")));

                verify(listener).propertyChange(argThat(new BaseMatcher<PropertyChangeEvent>() {
                    public boolean matches(Object item) {
                        PropertyChangeEvent event = (PropertyChangeEvent) item;
                        if (!event.getPropertyName().equals("mail")) {
                            return false;
                        }

                        Customer.Email oldMail = (Customer.Email) event.getOldValue();
                        Customer.Email newMail = (Customer.Email) event.getNewValue();

                        return oldMail.get$mail().equals("mustermann@gafff.de") && newMail.get$mail().equals("heidi@klumm.com");
                    }

                    public void describeTo(Description description) {
                        description.appendText("Comparing mail");
                    }
                }));
                verifyNoMoreInteractions(listener);
            }
        }.run();
    }

}
