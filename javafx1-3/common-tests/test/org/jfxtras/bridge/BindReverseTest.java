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
import org.fest.swing.junit.testcase.FestSwingJUnitTestCase;
import org.junit.Test;


import javax.swing.*;
import java.lang.reflect.InvocationTargetException;

import static org.junit.Assert.*;

/**
 *
 */
public class BindReverseTest extends FestSwingJUnitTestCase {
    @Override
    protected void onSetUp() {
    }

    @Test
    public void testCrazyEdt() throws Throwable {
        try {
            SwingUtilities.invokeAndWait(new Runnable() {
                public void run() {
                    try {
                        testCrazy();
                    } catch (Exception e) {
                        throw new RuntimeException(e);
                    }
                }
            });
        } catch (InvocationTargetException e) {
            throw e.getTargetException();
        }
    }

    public void testCrazy() throws NoSuchFieldException, IllegalAccessException, InterruptedException {
        Customer fxCustomer = new Customer();
        assertEquals("", fxCustomer.get$name());

        JavaCustomer javaCustomer = new JavaCustomer();
        javaCustomer.setName("initialNameJava");
        javaCustomer.setAddress("initialAddressJava");

        fxCustomer.set$name("initialNameFx");
        fxCustomer.set$address("initialAddressFx");


        assertEquals("initialNameJava", javaCustomer.getName());
        assertEquals("initialAddressJava", javaCustomer.getAddress());
        assertEquals("initialNameFx", fxCustomer.get$name());
        assertEquals("initialAddressFx", fxCustomer.get$address());


        //We bind in a circle. Java.name --> FX.name --> Java.address --> Fx.address --> Java.name
        PropertyChangeEvent2Fx java2fx = new PropertyChangeEvent2Fx(javaCustomer, fxCustomer);
        java2fx.bind(new JavaProperty("name"), new FXVar(fxCustomer.getClass(), "name"));
        {
            assertEquals("initialNameJava", javaCustomer.getName());
            assertEquals("initialAddressJava", javaCustomer.getAddress());
            assertEquals("initialNameJava", fxCustomer.get$name());
            assertEquals("initialAddressFx", fxCustomer.get$address());
        }
        java2fx.bind(new JavaProperty("address"), new FXVar(fxCustomer.getClass(), "address"));
        {
            assertEquals("initialNameJava", javaCustomer.getName());
            assertEquals("initialAddressJava", javaCustomer.getAddress());
            assertEquals("initialNameJava", fxCustomer.get$name());
            assertEquals("initialAddressJava", fxCustomer.get$address());
        }

        Fx2Setter fx2java = new Fx2Setter(fxCustomer, javaCustomer, new Fx2Setter.ReflectionSetterStrategy());
        fx2java.bind(new FXVar(fxCustomer.getClass(), "name"), new JavaProperty("address"));
        {
            assertEquals("initialNameJava", javaCustomer.getName());
            assertEquals("initialNameJava", javaCustomer.getAddress());
            assertEquals("initialNameJava", fxCustomer.get$name());
            assertEquals("initialNameJava", fxCustomer.get$address());
        }
        fx2java.bind(new FXVar(fxCustomer.getClass(), "address"), new JavaProperty("name"));
        {
            assertEquals("initialNameJava", javaCustomer.getName());
            assertEquals("initialNameJava", javaCustomer.getAddress());
            assertEquals("initialNameJava", fxCustomer.get$name());
            assertEquals("initialNameJava", fxCustomer.get$address());
        }


        //Test the initial state
        assertEquals("initialNameJava", javaCustomer.getName());
        assertEquals("initialNameJava", fxCustomer.get$name());
        assertEquals("initialNameJava", javaCustomer.getAddress());
        assertEquals("initialNameJava", fxCustomer.get$address());

        //set to java
        javaCustomer.setName("newNameSetInJava");

        assertEquals("newNameSetInJava", javaCustomer.getName());
        assertEquals("newNameSetInJava", fxCustomer.get$name());
        assertEquals("newNameSetInJava", javaCustomer.getAddress());
        assertEquals("newNameSetInJava", fxCustomer.get$address());

        //Set to fx
        fxCustomer.set$name("newNameSetInFx");

        assertEquals("newNameSetInFx", javaCustomer.getName());
        assertEquals("newNameSetInFx", fxCustomer.get$name());
        assertEquals("newNameSetInFx", javaCustomer.getAddress());
        assertEquals("newNameSetInFx", fxCustomer.get$address());


        javaCustomer.setAddress("nameSetInAddress");

        assertEquals("nameSetInAddress", javaCustomer.getName());
        assertEquals("nameSetInAddress", fxCustomer.get$name());
        assertEquals("nameSetInAddress", javaCustomer.getAddress());
        assertEquals("nameSetInAddress", fxCustomer.get$address());

        fxCustomer.set$address("nameSetInAddressFx");

        assertEquals("nameSetInAddressFx", javaCustomer.getName());
        assertEquals("nameSetInAddressFx", fxCustomer.get$name());
        assertEquals("nameSetInAddressFx", javaCustomer.getAddress());
        assertEquals("nameSetInAddressFx", fxCustomer.get$address());
    }

    @Test
    public void testItEdt() {
        GuiActionRunner.execute(new GuiTask() {
            @Override
            protected void executeInEDT() throws Throwable {
                testIt();
            }
        });
    }

    public void testIt() throws NoSuchFieldException, IllegalAccessException {
        Customer fxCustomer = new Customer();
        assertEquals("", fxCustomer.get$name());

        JavaCustomer javaCustomer = new JavaCustomer();
        javaCustomer.setName("MyName");
        assertEquals("MyName", javaCustomer.getName());

        PropertyChangeEvent2Fx java2fx = new PropertyChangeEvent2Fx(javaCustomer, fxCustomer);
        java2fx.bind("name");

        Fx2Setter fx2java = new Fx2Setter(fxCustomer, javaCustomer, new Fx2Setter.ReflectionSetterStrategy());
        fx2java.bind("name");

        //Test the initial state
        assertEquals("MyName", javaCustomer.getName());
        assertEquals("MyName", fxCustomer.get$name());

        //set to java
        javaCustomer.setName("newNameSetInJava");
        assertEquals("newNameSetInJava", javaCustomer.getName());
        assertEquals("newNameSetInJava", fxCustomer.get$name());

        //Set to fx
        fxCustomer.set$name("newNameSetInFx");
        assertEquals("newNameSetInFx", javaCustomer.getName());
        assertEquals("newNameSetInFx", fxCustomer.get$name());
    }

}
