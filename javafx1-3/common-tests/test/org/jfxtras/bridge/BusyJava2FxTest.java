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

import static org.junit.Assert.*;

/**
 *
 */
public class BusyJava2FxTest extends AbstractJava2FxTest {
    BusyJava2Fx bridge;

    @Override
    protected AbstractJava2Fx createBridge(JavaCustomer javaCustomer, Customer fxCustomer) throws NoSuchFieldException, IllegalAccessException {
        return bridge = new BusyJava2Fx(javaCustomer, fxCustomer, 10);
    }

    @Test
    public void testIt2() throws Exception {
        final Customer fxCustomer = new Customer();
        final JavaCustomer javaCustomer = new JavaCustomer();

        GuiActionRunner.execute(new GuiTask() {
            @Override
            protected void executeInEDT() throws Throwable {
                AbstractJava2Fx bridge = createBridge(javaCustomer, fxCustomer);

                assertEquals("", fxCustomer.get$name());
                javaCustomer.setName("changed");
                assertEquals("changed", javaCustomer.getName());
                assertEquals("", fxCustomer.get$name());

                bridge.bind("name");
                javaCustomer.setName("newName");
                assertEquals("newName", javaCustomer.getName());
            }
        });

        propertyChanged();

        assertEquals("newName", fxCustomer.get$name());
        assertEquals("newName", fxCustomer.get$name());
    }

    @Override
    protected void propertyChanged() throws Exception {
        super.propertyChanged();
        Thread.sleep(11);
    }

    @Override
    protected void onTearDown() {
        super.onTearDown();
        bridge.stop();
    }
}
