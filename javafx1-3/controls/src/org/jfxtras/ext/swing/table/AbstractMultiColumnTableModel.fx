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
 * Base {@code TableModel} for multi-column tables.
 *
 * @profile desktop
 * @author John Freeman
 */
public abstract class AbstractMultiColumnTableModel extends AbstractTableModel {

    /**
     * Rows of data for the table. Bind with inverse and set {@code editable = true} if you want the cell to be
     * editable.
     */
    protected var rows:Row[] on replace oldValue[start..end] = newElements {
        def numRowsReplaced = (end + 1) - start;
        def numNewRows = sizeof newElements;
        for (row in oldValue[start..end]) {
            // rows objects have been replaced so we remove the onChange function
            row.onChange = null;
        }
        for (row in newElements) {
            // new rows need the onChange function
            def rowIndex = start + indexof row;
            row.onChange = function(columnIndex) {
                fireTableCellUpdated(rowIndex, columnIndex);
            }
        }
        if (numRowsReplaced != numNewRows) {
            // subsequent row indexes have changed so we need to update the onChange function
            def postSliceIndex = start+numNewRows;
            for (row in rows[postSliceIndex..]) {
                def rowIndex = postSliceIndex + indexof row;
                row.onChange = function(columnIndex:Integer) {
                    fireTableCellUpdated(rowIndex, columnIndex);
                }
            }
        }

        if (columnCount == null and sizeof newElements > 0) {
            columnCount = sizeof newElements[0].cells;
            fireTableStructureChanged();
        } else {
            if (numRowsReplaced > 0 and numNewRows > 0) {
                def changeEnd = start + Math.min(numRowsReplaced, numNewRows) - 1;
                fireTableRowsUpdated(start, changeEnd);
            }
            if (numRowsReplaced > numNewRows) {
                def changeEnd = end + (numRowsReplaced - numNewRows) - 1;
                fireTableRowsDeleted(end, changeEnd);
            }
            if (numRowsReplaced < numNewRows) {
                def changeEnd = end + (numNewRows - numRowsReplaced);
                fireTableRowsInserted(end + 1, changeEnd);
            }
        }
    }

    /**
     * Labels to be used for the column headers.
     */
    public-init var columnLabels:String[] on replace = newElements {
        if (columnCount == null and sizeof newElements > 0) {
            columnCount = sizeof newElements;
        }
    }

    var columnCount:java.lang.Integer;

    override function getColumnClass(columnIndex):Class {
        if (sizeof rows == 0) {
            return BasicTypes.OBJECT;
        } else {
            return rows[0].cells[columnIndex].getColumnClass();
        }
    }

    override function getColumnCount():Integer {
        if (columnCount != null) {
            return columnCount;
        } else if (sizeof columnLabels > 0) {
            return sizeof columnLabels;
        } else {
            return 0;
        }
    }

    override function getColumnName(columnIndex):String {
        if (columnIndex >= 0 and columnIndex < sizeof columnLabels) {
            return columnLabels[columnIndex];
        } else {
            return AbstractTableModel.getColumnName(columnIndex);
        }
    }

    override function getRowCount() {
        return sizeof rows;
    }

    override function getValueAt(rowIndex, columnIndex) {
        return rows[rowIndex].cells[columnIndex].getValue();
    }

    override function isCellEditable(rowIndex, columnIndex) {
        return rows[rowIndex].cells[columnIndex].isEditable();
    }

    override function setValueAt(value, rowIndex, columnIndex) {
        rows[rowIndex].cells[columnIndex].setValue(value);
    }
}
