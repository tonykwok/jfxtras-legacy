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
package org.jfxtras.test.junit;

import java.lang.reflect.InvocationTargetException;
import org.jfxtras.test.*;
import com.sun.javafx.runtime.Entry;
import com.sun.javafx.runtime.sequence.Sequence;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.swing.SwingUtilities;
import org.junit.runner.Description;
import org.junit.runner.Runner;
import org.junit.runner.notification.RunNotifier;

/**
 * Runner for JavaFX classes that will invoke the JFXtras-Test style Test block.
 *
 * @author Stephen Chin
 */
public class JFXtrasRunner extends Runner {
    private final Class testClass;
    private TestSet testSet;

    public JFXtrasRunner(Class testClass) {
        this.testClass = testClass;
        createTest();
    }

    private void createTest() {
        TestBase.runIndividual = false;
        try {
            SwingUtilities.invokeAndWait(new Runnable() {
                @Override
                public void run() {
                    try {
                        String name = Entry.entryMethodName();
                        Entry.deferAction(new Runnable() {@Override public void run() {}});  // force the runtime provider to get loaded
                        testSet = (TestSet) testClass.getMethod(name, Sequence.class).invoke(null, (Object) null);
                    } catch (NoSuchMethodException ex) {
                        throw new IllegalArgumentException("Test class is missing a JavaFX run function.", ex);
                    } catch (Exception ex) {
                        Logger.getLogger(JFXtrasRunner.class.getName()).log(Level.SEVERE, null, ex);
                    }
                }
            });
        } catch (InterruptedException ex) {
            Logger.getLogger(JFXtrasRunner.class.getName()).log(Level.SEVERE, null, ex);
        } catch (InvocationTargetException ex) {
            Logger.getLogger(JFXtrasRunner.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    @Override
    public Description getDescription() {
        Description suite = Description.createSuiteDescription(testClass.getName(), testClass.getAnnotations());
        for (String desc : testSet.getDescriptions()) {
            suite.addChild(Description.createTestDescription(testClass, desc));
        }
        return suite;
    }

    @Override
    public void run(RunNotifier notifier) {
        TestCallback callback = new JUnitTestCallback(testClass, notifier);
        testSet.execute(callback);
    }
}
