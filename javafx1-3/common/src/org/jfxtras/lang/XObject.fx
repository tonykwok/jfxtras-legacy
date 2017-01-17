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

package org.jfxtras.lang;

import javafx.reflect.FXClassType;
import javafx.reflect.FXLocal;

/**
 * A class intended to be inherited by other JavaFX classes to implement
 * base functionality that is generally useful to all JavaFX objects.
 * The first version of this class supports a single method that provides
 * a convenient way to get the JavaFX Class Type wrapper for a given object
 * instance.
 * <p>
 * Usage: Simply have your JavaFX class extend this in addition to your other
 * inherited classes.
 * <p>
 * Note: Additional functionality will be added sparingly.  To avoid name clashes
 * all new methods will contain the letters "JFX" in them.
 *
 * @profile common
 *
 * @author Stephen Chin
 */
public mixin class XObject {
    /**
     * Get the javafx.reflect.FXClassType for this object instance.  It is safe to cast
     * the return type to javafx.reflect.FXLocal.ClassType to access additional methods.
     *
     * @return The JavaFX Class Type wrapper for this instance
     */
    public function getJFXClass():FXClassType {
        FXLocal.getContext().makeClassRef(getClass());
    }
}
