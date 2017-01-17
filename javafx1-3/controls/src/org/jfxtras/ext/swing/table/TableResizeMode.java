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

import javax.swing.JTable;

/**
 * Enumeration of methods used to auto resize table columns when an individual column or the table itself is resized.
 *
 * @author John Freeman
 */
public enum TableResizeMode {
    /**
     * Do not resize columns to fit table width; use a horizontal scrollbar.
     */
    AUTO_RESIZE_OFF(JTable.AUTO_RESIZE_OFF),

    /**
     * When a column is resized, adjust the following column to maintain the same table width.
     */
    AUTO_RESIZE_NEXT_COLUMN(JTable.AUTO_RESIZE_NEXT_COLUMN),

    /**
     * When a column is resized, adjust all following columns to maintain the same table width.
     */
    AUTO_RESIZE_SUBSEQUENT_COLUMNS(JTable.AUTO_RESIZE_SUBSEQUENT_COLUMNS),

    /**
     * When a column is resized, adjust the last column to maintain the same table width.
     */
    AUTO_RESIZE_LAST_COLUMN(JTable.AUTO_RESIZE_LAST_COLUMN),

    /**
     * When a column is resized, adjust all other columns to maintain the same table width.
     */
    AUTO_RESIZE_ALL_COLUMNS(JTable.AUTO_RESIZE_ALL_COLUMNS);

    private final int value;

    TableResizeMode(int value) {
        this.value = value;
    }

    /**
     * Returns the integer value for use with the {@link javax.swing.JTable}.
     *
     * @see javax.swing.JTable#setAutoResizeMode(int)
     */
    public int getValue() {
        return value;
    }

    /**
     * Returns the {@code TableResizeMode} associated with the integer value from
     * {@link javax.swing.JTable}.
     *
     * @see javax.swing.JTable#setAutoResizeMode()
     */
    public static TableResizeMode valueOf(int value) {
        switch(value) {
            case JTable.AUTO_RESIZE_OFF:
                return AUTO_RESIZE_OFF;
            case JTable.AUTO_RESIZE_NEXT_COLUMN:
                return AUTO_RESIZE_NEXT_COLUMN;
            case JTable.AUTO_RESIZE_SUBSEQUENT_COLUMNS:
                return AUTO_RESIZE_SUBSEQUENT_COLUMNS;
            case JTable.AUTO_RESIZE_LAST_COLUMN:
                return AUTO_RESIZE_LAST_COLUMN;
            case JTable.AUTO_RESIZE_ALL_COLUMNS:
                return AUTO_RESIZE_ALL_COLUMNS;
            default:
                throw new IllegalArgumentException("Unrecognized table resize mode: " + value);
        }
    }
}
