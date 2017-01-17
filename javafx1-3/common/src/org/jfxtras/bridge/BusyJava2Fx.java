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

import com.sun.javafx.runtime.FXObject;

import javax.swing.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.Map;

/**
 * This is a workaround! Do not use this class unitl you really know what you are doing!
 * <p/>
 * This bridge updates JavaFX objects whenever a java class has been updated. But be careful! This class polls
 * the java objects actively. This is a fallback class that may be useful for some corner cases. But generally
 * this is *not* the solution.
 * <p/>
 * Use {@link PropertyChangeEvent2Fx} instead!
 */
public class BusyJava2Fx extends AbstractJava2Fx {
    private final Timer timer;

    public BusyJava2Fx(Object bindee, FXObject binder) throws NoSuchFieldException, IllegalAccessException {
        this(bindee, binder, 20);
    }

    public BusyJava2Fx(Object bindee, FXObject binder, final int delay) throws NoSuchFieldException, IllegalAccessException {
        super(bindee, binder);

        updateVars();

        timer = new Timer(delay, new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                try {
                    updateVars();
                } catch (Exception ex) {
                    throw new RuntimeException(ex);
                }
            }
        });
        timer.setRepeats(true);
        timer.start();
    }

    private void updateVars() throws NoSuchFieldException, IllegalAccessException {
        for (Map.Entry<JavaProperty, FXVar> entry : boundVars.entrySet()) {
            JavaProperty property = entry.getKey();

            FXVar fxVar = entry.getValue();

            Object value = getValueByReflection(property);
            setVar(fxVar, value);
        }
    }

    @Override
    protected Object getInitialValue(JavaProperty property) throws NoSuchFieldException, IllegalAccessException {
        return getValueByReflection(property);
    }

    public void stop() {
        timer.stop();
    }
}

