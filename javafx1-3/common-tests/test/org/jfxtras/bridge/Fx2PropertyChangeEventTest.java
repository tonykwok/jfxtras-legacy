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
import org.mockito.internal.matchers.apachecommons.ReflectionEquals;

import java.beans.PropertyChangeEvent;
import java.beans.PropertyChangeListener;

import static org.junit.Assert.*;
import static org.mockito.Mockito.argThat;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.verifyNoMoreInteractions;


/**
 *
 */
public class Fx2PropertyChangeEventTest {
    @Test
    public void testApi() throws NoSuchFieldException, IllegalAccessException {
        MyFxClass fxInstance = new MyFxClass();

        Fx2PropertyChangeEvent bridge = new Fx2PropertyChangeEvent(fxInstance);
        bridge.bind("b");
        bridge.bind("a");
    }

    @Test
    public void testApiStatic() throws Exception {
        final MyFxClass fxInstance = new MyFxClass();
        final Fx2PropertyChangeEvent bridge = Fx2PropertyChangeEvent.bindProperties("a", "b").to(fxInstance);

        new MockitoTemplate() {
            @Mock
            private PropertyChangeListener listener;

            @Override
            protected void stub() throws Exception {
            }

            @Override
            protected void execute() throws Exception {
                bridge.addPropertyChangeListener(listener);

                fxInstance.set$b("newB2");
                fxInstance.set$a("newA");
                fxInstance.set$b("newB3");
                fxInstance.set$a("newA2");
                fxInstance.set$b("newB3");
                fxInstance.set$b("newB4");
            }

            @Override
            protected void verifyMocks() throws Exception {
                verify(listener).propertyChange((PropertyChangeEvent) argThat(new ReflectionEquals(new PropertyChangeEvent(fxInstance, "b", "initialValue", "newB2"))));
                verify(listener).propertyChange((PropertyChangeEvent) argThat(new ReflectionEquals(new PropertyChangeEvent(fxInstance, "a", "initialValueA", "newA"))));
                verify(listener).propertyChange((PropertyChangeEvent) argThat(new ReflectionEquals(new PropertyChangeEvent(fxInstance, "b", "newB2", "newB3"))));
                verify(listener).propertyChange((PropertyChangeEvent) argThat(new ReflectionEquals(new PropertyChangeEvent(fxInstance, "a", "newA", "newA2"))));
                verify(listener).propertyChange((PropertyChangeEvent) argThat(new ReflectionEquals(new PropertyChangeEvent(fxInstance, "b", "newB3", "newB4"))));
                verifyNoMoreInteractions(listener);
            }
        }.run();
    }

    @Test
    public void testTwoVars() throws Exception {
        final MyFxClass fxInstance = new MyFxClass();
        assertEquals("initialValueA", fxInstance.get$a());
        assertEquals("initialValue", fxInstance.get$b());

        new MockitoTemplate() {
            @Mock
            private PropertyChangeListener listener;

            @Override
            protected void stub() throws Exception {
            }

            @Override
            protected void execute() throws Exception {
                final Fx2PropertyChangeEvent bridge = new Fx2PropertyChangeEvent(fxInstance);
                bridge.bind("a");
                bridge.bind("b");

                bridge.addPropertyChangeListener(listener);

                fxInstance.set$b("newB2");
                fxInstance.set$a("newA");
                fxInstance.set$b("newB3");
                fxInstance.set$a("newA2");
                fxInstance.set$b("newB3");
                fxInstance.set$b("newB4");
            }

            @Override
            protected void verifyMocks() throws Exception {
                verify(listener).propertyChange((PropertyChangeEvent) argThat(new ReflectionEquals(new PropertyChangeEvent(fxInstance, "b", "initialValue", "newB2"))));
                verify(listener).propertyChange((PropertyChangeEvent) argThat(new ReflectionEquals(new PropertyChangeEvent(fxInstance, "a", "initialValueA", "newA"))));
                verify(listener).propertyChange((PropertyChangeEvent) argThat(new ReflectionEquals(new PropertyChangeEvent(fxInstance, "b", "newB2", "newB3"))));
                verify(listener).propertyChange((PropertyChangeEvent) argThat(new ReflectionEquals(new PropertyChangeEvent(fxInstance, "a", "newA", "newA2"))));
                verify(listener).propertyChange((PropertyChangeEvent) argThat(new ReflectionEquals(new PropertyChangeEvent(fxInstance, "b", "newB3", "newB4"))));
                verifyNoMoreInteractions(listener);
            }
        }.run();
    }

    @Test
    public void testInvalid() throws IllegalAccessException {
        MyFxClass fxInstance = new MyFxClass();

        try {
            new Fx2PropertyChangeEvent(fxInstance).bind("doesNotExist");
            fail("Where is the Exception");
        } catch (NoSuchFieldException ignore) {

        }
        try {
            new Fx2PropertyChangeEvent(fxInstance).bind("c");
            fail("Where is the Exception");
        } catch (NoSuchFieldException ignore) {
        }
    }

    @Test
    public void testIt() throws Exception {
        final MyFxClass fxInstance = new MyFxClass();
        assertEquals("initialValue", fxInstance.get$b());

        new MockitoTemplate() {
            @Mock
            private PropertyChangeListener listener;

            @Override
            protected void stub() throws Exception {
            }

            @Override
            protected void execute() throws Exception {
                Fx2PropertyChangeEvent bridge = new Fx2PropertyChangeEvent(fxInstance);
                bridge.bind("b");
                bridge.addPropertyChangeListener(listener);

                fxInstance.set$b("newB2");

                fxInstance.set$b("newB3");
                fxInstance.set$b("newB3");
                fxInstance.set$b("newB4");
            }

            @Override
            protected void verifyMocks() throws Exception {
                verify(listener).propertyChange((PropertyChangeEvent) argThat(new ReflectionEquals(new PropertyChangeEvent(fxInstance, "b", "initialValue", "newB2"))));
                verify(listener).propertyChange((PropertyChangeEvent) argThat(new ReflectionEquals(new PropertyChangeEvent(fxInstance, "b", "newB2", "newB3"))));
                verify(listener).propertyChange((PropertyChangeEvent) argThat(new ReflectionEquals(new PropertyChangeEvent(fxInstance, "b", "newB3", "newB4"))));
                verifyNoMoreInteractions(listener);
            }
        }.run();
    }

    @Test
    public void testInitial() throws Exception {
        new MockitoTemplate() {
            @Mock
            private PropertyChangeListener listener;

            private final Customer fxCustomer = new Customer();

            @Override
            protected void stub() throws Exception {
            }

            @Override
            protected void execute() throws Exception {
                fxCustomer.set$address("fxAddress");

                Fx2PropertyChangeEvent bridge = new Fx2PropertyChangeEvent(fxCustomer);
                bridge.addPropertyChangeListener(listener);

                bridge.bind("address", null, true);
                fxCustomer.set$address("newFx");
            }

            @Override
            protected void verifyMocks() throws Exception {
                verify(listener).propertyChange((PropertyChangeEvent) argThat(new ReflectionEquals(new PropertyChangeEvent(fxCustomer, "address", null, "fxAddress"))));
                verify(listener).propertyChange((PropertyChangeEvent) argThat(new ReflectionEquals(new PropertyChangeEvent(fxCustomer, "address", "fxAddress", "newFx"))));
            }
        }.run();
    }

    @Test
    public void testConversion() throws Exception {
        new MockitoTemplate() {
            @Mock
            private PropertyChangeListener listener;

            private final Customer fxCustomer = new Customer();

            @Override
            protected void stub() throws Exception {
            }

            @Override
            protected void execute() throws Exception {
                Customer.Email mail = new Customer.Email();
                mail.set$mail("fxMail");
                fxCustomer.set$mail(mail);

                Fx2PropertyChangeEvent bridge = new Fx2PropertyChangeEvent(fxCustomer);
                bridge.bind("mail", new EmailConverter.Fx2Java());

                bridge.addPropertyChangeListener(listener);

                Customer.Email newMail = new Customer.Email();
                newMail.set$mail("newFxMail");
                fxCustomer.set$mail(newMail);
            }

            @Override
            protected void verifyMocks() throws Exception {
                verify(listener).propertyChange(argThat(new MailPropChangeMatcher("fxMail", "newFxMail")));
            }
        }.run();
    }

    private static class MailPropChangeMatcher extends BaseMatcher<PropertyChangeEvent> {


        private final String newMail;


        private final String oldMail;

        private MailPropChangeMatcher(String oldMail, String newMail) {
            this.oldMail = oldMail;
            this.newMail = newMail;
        }

        public boolean matches(Object item) {
            PropertyChangeEvent evt = (PropertyChangeEvent) item;
            return evt.getPropertyName().equals("mail") &&
                ((JavaCustomer.Email) evt.getOldValue()).getMail().equals(oldMail) &&
                ((JavaCustomer.Email) evt.getNewValue()).getMail().equals(newMail);
        }

        public void describeTo(Description description) {
            description.appendText("expecting prop event that changes mail from <" + oldMail + "> to <" + newMail + ">");
        }
    }
}
