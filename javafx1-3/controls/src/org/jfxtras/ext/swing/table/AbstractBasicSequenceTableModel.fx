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

import java.lang.Class;
import java.lang.Math;
import javax.swing.table.AbstractTableModel;

/**
 * Base {@code TableModel} for simple sequences of basic types.
 *
 * @profile desktop
 * @author John Freeman
 */
public abstract class AbstractBasicSequenceTableModel extends AbstractTableModel {

    /**
     * Sub-classes must bind their typed sequences to this.
     */
    protected var entries:Object[] on replace oldValue[start..end] = newElements {
        def numRowsReplaced = (end + 1) - start;
        def numNewRows = sizeof newElements;
        if (numRowsReplaced > 0 and numNewRows > 0) {
            def changeEnd = start + Math.min(numRowsReplaced, numNewRows) - 1;
            fireTableRowsUpdated(start, changeEnd);
        }
        if (numRowsReplaced > numNewRows) {
            def changeEnd = end + (numRowsReplaced - numNewRows) - 1;
            fireTableRowsDeleted(end, changeEnd);
        }
        if (numRowsReplaced < numNewRows) {
            def changeEnd = end + numNewRows - numRowsReplaced;
            fireTableRowsInserted(end + 1, changeEnd);
        }
    }

    /**
     * Label to be displayed in column header.
     */
    public-init var columnLabel:String;

    /**
     * Should entries be editable. For bound sequences {@code with inverse} must also be used for editing to
     * function properly.
     *
     * @defaultvalue false
     */
    public var editable:Boolean = false;

    override function getColumnClass(columnIndex):Class {
        if (sizeof entries == 0) {
            return BasicTypes.OBJECT;
        } else {
            return entries[0].getClass();
        }
    }

    override function getColumnCount() {
        return 1;
    }

    override function getColumnName(columnIndex) {
        if (columnLabel != null) {
            return columnLabel;
        } else {
            return AbstractTableModel.getColumnName(columnIndex);
        }
    }

    override function getRowCount() {
        return sizeof entries;
    }

    override function getValueAt(rowIndex, columnIndex) {
        return entries[rowIndex];
    }

    override function isCellEditable(rowIndex, columnIndex) {
        return editable;
    }

}
