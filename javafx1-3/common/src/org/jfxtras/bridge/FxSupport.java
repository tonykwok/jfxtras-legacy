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


/**
 * Support methods for JavaFX
 */
public class FxSupport {
    public static final String VOFF_FIELD_PREFIX = "VOFF$";

    private FxSupport() {
    }

    /**
     * Ensures that a var exists of the given type
     *
     * @param type    the type
     * @param varName the var name
     * @throws IllegalArgumentException if the var does not exist
     */
    public static void ensureVarExists(Class<? extends FXObject> type, String varName) throws NoSuchFieldException {
        type.getField(getVarFieldName(varName));
    }

    /**
     * Returns the var number for the given type
     *
     * @param type    the type
     * @param varName the var name
     * @return the number representing the var
     */
    public static int getVarNum(Class<? extends FXObject> type, String varName) throws NoSuchFieldException, IllegalAccessException {
        return (Integer) type.getField(getVoffFieldName(varName)).get(null);
    }

    /**
     * Returns the VOFF field name (containing the id of the var)
     *
     * @param varName the name of the var
     * @return the field name of the VOFF field
     */
    public static String getVoffFieldName(String varName) {
        return VOFF_FIELD_PREFIX + varName;
    }

    /**
     * Returns the field name for a var ("$varName")
     *
     * @param varName the var name
     * @return the field name for a var
     */
    public static String getVarFieldName(String varName) {
        return "$" + varName;
    }
}
