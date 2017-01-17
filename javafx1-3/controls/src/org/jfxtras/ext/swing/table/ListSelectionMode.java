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

package org.jfxtras.ext.swing.table;

import javax.swing.ListSelectionModel;

/**
 * Enumeration of list selection modes.
 *
 * @profile desktop
 * @author John Freeman
 */
public enum ListSelectionMode {

    /**
     * Select one list index at a time.
     */
    SINGLE_SELECTION(ListSelectionModel.SINGLE_SELECTION),

    /**
     * Select one contiguous range of indices at a time.
     */
    SINGLE_INTERVAL_SELECTION(ListSelectionModel.SINGLE_INTERVAL_SELECTION),

    /**
     * Select one or more contiguous ranges of indices at a time.
     */
    MULTIPLE_INTERVAL_SELECTION(ListSelectionModel.MULTIPLE_INTERVAL_SELECTION);

    private final int value;

    private ListSelectionMode(int value) {
        this.value = value;
    }

    /**
     * Returns the integer value for use with the {@link javax.swing.ListSelectionModel}.
     *
     * @see javax.swing.ListSelectionModel#setSelectionMode(int)
     */
    public int getValue() {
        return value;
    }

    /**
     * Returns the {@code ListSelectionMode} associated with the integer value from
     * {@link javax.swing.ListSelectionModel}.
     *
     * @see javax.swing.ListSelectionModel#getSelectionMode()
     */
    public static ListSelectionMode valueOf(int value) {
        for (ListSelectionMode mode : ListSelectionMode.values()) {
            if (mode.getValue() == value) {
                return mode;
            }
        }
        throw new IllegalArgumentException("No enum const " + ListSelectionMode.class + "(" + value+ ")");
    }
}
