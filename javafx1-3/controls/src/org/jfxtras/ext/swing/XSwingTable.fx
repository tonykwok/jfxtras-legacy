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

package org.jfxtras.ext.swing;

import org.jfxtras.ext.swing.table.ListSelectionMode;
import org.jfxtras.ext.swing.table.TableResizeMode;
import org.jfxtras.ext.swing.table.TableSelectionMode;
import org.jfxtras.scene.layout.XLayoutInfo;
import org.jfxtras.scene.layout.XLayoutInfo.*;

import javafx.ext.swing.SwingComponent;
import javafx.ext.swing.SwingScrollableComponent;

import java.beans.PropertyChangeListener;

import javax.swing.DefaultListSelectionModel;
import javax.swing.ListSelectionModel;
import javax.swing.JTable;
import javax.swing.event.ListSelectionListener;
import javax.swing.event.TableColumnModelListener;
import javax.swing.table.DefaultTableColumnModel;
import javax.swing.table.TableColumnModel;
import javax.swing.table.TableModel;

/**
 * Uses {@code JTable} to display and edit regular two-dimensional tables of cells.
 *
 * @example
 * import org.jfxtras.ext.swing.XSwingTable;
 * import org.jfxtras.ext.swing.table.IntegerCell;
 * import org.jfxtras.ext.swing.table.Row;
 * import org.jfxtras.ext.swing.table.ObjectSequenceTableModel;
 * import org.jfxtras.ext.swing.table.StringCell;
 *
 * import javafx.ext.swing.SwingScrollPane;
 *
 * class Person {
 *     var forename:String;
 *     var surname:String;
 *     var age:Integer;
 * }
 *
 * var employees = [
 *     Person {
 *         forename: "Joe"
 *         surname: "Bloggs"
 *         age: 45
 *     }
 *     Person {
 *         forename: "Fred"
 *         surname: "Bloggs"
 *         age: 60
 *     }
 * ];
 *
 * SwingScrollPane {
 *     view: XSwingTable {
 *         tableModel: ObjectSequenceTableModel {
 *             override function transformEntry(entry) {
 *                 def person:Person = entry as Person;
 *                 return Row {
 *                     cells: [
 *                         StringCell { value: bind person.forename }
 *                         StringCell {
 *                             value: bind person.surname with inverse
 *                             editable: true
 *                         }
 *                         IntegerCell { value: bind person.age }
 *                     ]
 *                 }
 *             }
 *             columnLabels: ["Forename", "Surname", "Age"]
 *             sequence: bind employees
 *         }
 *     }
 * }
 * @endexample
 * 
 * @profile desktop
 * @see JTable
 * @author John Freeman
 */
public class XSwingTable extends SwingScrollableComponent, PropertyChangeListener {
    def swingTable = this;
    override var scrollable = true;

    // this needs to be initialized before columnModel
    def columnModelListener = TableColumnModelListener {
        override function columnAdded(e) { }
        override function columnRemoved(e) { }
        override function columnMoved(e) { }
        override function columnMarginChanged(e) { }
        override function columnSelectionChanged(event) {
            def jTable = getJTable();
            if (not event.getValueIsAdjusting()) {
                def newSelectedColumn = jTable.getSelectedColumn();
                selectedColumn = if (newSelectedColumn == -1) then null else newSelectedColumn;
                def onChangeFunction = onSelectedColumnsChanged;
                if (onChangeFunction != null) {
                    onChangeFunction(jTable.getSelectedColumns());
                }
            }
        }
    };

    // this needs to be initialized before tableModel and preferredColumnWidths
    def columnModel = PropertyNotifierColumnModel{} on replace = newValue {
        getJTable().setColumnModel(newValue);
    }

    /**
     * The data model for this table.
     *
     * @see org.jfxtras.ext.swing.table.SequenceEntryTableModel
     * @see org.jfxtras.ext.swing.table.SequencePropertyTableModel
     */
    public var tableModel:TableModel on replace = newValue { // this needs to be initialzed before preferredColumnWidths
        getJTable().setModel(tableModel);
        if (isInitialized(preferredColumnWidths)) {
            setPreferredColumnWidths(preferredColumnWidths);
        }
    }

    /**
     * Whether selection should be done by row, column or individual cells.
     *
     * @defaultvalue ROW
     */
    public var tableSelectionMode:TableSelectionMode = TableSelectionMode.ROW on replace = newValue {
        def jTable = getJTable();
        if (newValue == TableSelectionMode.CELL) {
            jTable.setCellSelectionEnabled(true);
        } else if (newValue == TableSelectionMode.COLUMN) {
            jTable.setRowSelectionAllowed(false);
            jTable.setColumnSelectionAllowed(true);
        } else if (newValue == TableSelectionMode.ROW) {
            jTable.setColumnSelectionAllowed(false);
            jTable.setRowSelectionAllowed(true);
        } else {
            jTable.setCellSelectionEnabled(false);
        }
    }

    /**
     * Row selection mode. The following list describes the accepted selection modes:
     * <ul>
     * <li>{@code ListSelectionModel.SINGLE_SELECTION} -
     *   Only one row can be selected at a time.
     * <li>{@code ListSelectionModel.SINGLE_INTERVAL_SELECTION} -
     *   Only one contiguous interval can be selected at a time.
     * <li>{@code ListSelectionModel.MULTIPLE_INTERVAL_SELECTION} -
     *   In this mode, there's no restriction on what can be selected.
     * </ul>
     *
     * @defaultvalue MULTIPLE_INTERVAL_SELECTION
     */
    public var rowSelectionMode:ListSelectionMode = ListSelectionMode.MULTIPLE_INTERVAL_SELECTION
            on replace = newValue {

        getJTable().getSelectionModel().setSelectionMode(newValue.getValue());
    }

    /**
     * The column selection mode. The following list describes the accepted selection modes:
     * <ul>
     * <li>{@code ListSelectionModel.SINGLE_SELECTION} -
     *   Only one column can be selected at a time.
     * <li>{@code ListSelectionModel.SINGLE_INTERVAL_SELECTION} -
     *   Only one contiguous interval can be selected at a time.
     * <li>{@code ListSelectionModel.MULTIPLE_INTERVAL_SELECTION} -
     *   In this mode, there's no restriction on what can be selected.
     * </ul>
     *
     * @defaultvalue MULTIPLE_INTERVAL_SELECTION
     */
    public var columnSelectionMode:ListSelectionMode = ListSelectionMode.MULTIPLE_INTERVAL_SELECTION
            on replace = newValue {
                
        getJTable().getColumnModel().getSelectionModel().setSelectionMode(newValue.getValue());
    }

    /**
     * The preferred widths of the columns.
     */
    public var preferredColumnWidths:Integer[] on replace = newValue {
        setPreferredColumnWidths(newValue);
    }

    /**
     * Sets how columns are resized when individual columns or the table itself is resized.
     */
    public var autoResizeMode:TableResizeMode = TableResizeMode.AUTO_RESIZE_SUBSEQUENT_COLUMNS on replace = newValue {
        getJTable().setAutoResizeMode(newValue.getValue());
    }

    /**
     * The function to be called when the selected row is changed.
     */
    public var onSelectedRowChanged:function(selectedRowIndex:java.lang.Integer):Void;

    /**
     * The function to be called when the selected rows are changed.
     */
    public var onSelectedRowsChanged:function(selectedRowIndexes:Integer[]):Void;

    var selectedRow:java.lang.Integer on replace = newValue {
        def onChangeFunction = onSelectedRowChanged;
        if (onChangeFunction != null) {
            onChangeFunction(newValue);
        }
    }

    /**
     * The function to be called when the selected column is changed.
     */
    public var onSelectedColumnChanged:function(selectedColumnIndex:java.lang.Integer):Void;

    /**
     * The function to be called when the selected columns are changed.
     */
    public var onSelectedColumnsChanged:function(selectedColumnIndexes:Integer[]):Void;

    var selectedColumn:java.lang.Integer on replace = newValue {
        def onChangeFunction = onSelectedColumnChanged;
        if (onChangeFunction != null) {
            onChangeFunction(newValue);
        }
    }

    def rowSelectionListener = ListSelectionListener {
        override function valueChanged(event) {
            def jTable = getJTable();
            if (not event.getValueIsAdjusting()) {
                def newSelectedRow = jTable.getSelectedRow();
                selectedRow = if (newSelectedRow == -1) then null else newSelectedRow;
                def onChangeFunction = onSelectedRowsChanged;
                if (onChangeFunction != null) {
                    onChangeFunction(jTable.getSelectedRows());
                }
            }
        }
    }

    def rowSelectionModel = PropertyNotifierListSelectionModel{} on replace = newValue {
        getJTable().setSelectionModel(newValue);
    }

    def columnSelectionModel = PropertyNotifierListSelectionModel{} on replace = newValue {
        columnModel.setSelectionModel(newValue);
    }

    override function getHFill() {true}
    override function getVFill() {true}
    override function getHGrow() {ALWAYS}
    override function getVGrow() {ALWAYS}
    override function getHShrink() {SOMETIMES}
    override function getVShrink() {SOMETIMES}

    function setPreferredColumnWidths(widths:Integer[]) {
        def columnModel = getJTable().getColumnModel();
        def columnCount = columnModel.getColumnCount();
        for (width in widths) {
            def columnIndex = indexof width;
            if (columnIndex >= columnCount) {
                break; // ignore extra column widths
            }

            def column = columnModel.getColumn(columnIndex);
            column.setPreferredWidth(width);
        }
    }

    override function propertyChange(event) {
        def source = event.getSource();
        def propertyName = event.getPropertyName();
        def jTable = getJTable();
        if (source == jTable) {
            if (propertyName == "cellSelectionEnabled") {
                tableSelectionModeChanged(TableSelectionMode.CELL, event.getNewValue() == true);
            }
            else if (propertyName == "columnSelectionAllowed") {
                tableSelectionModeChanged(TableSelectionMode.COLUMN, event.getNewValue() == true);
            }
            else if (propertyName == "rowSelectionAllowed") {
                tableSelectionModeChanged(TableSelectionMode.ROW, event.getNewValue() == true);
            }
            else if (propertyName == "selectionModel") {
                def oldModel = event.getOldValue() as ListSelectionModel;
                def newModel = event.getNewValue() as ListSelectionModel;
                rowSelectionModelChanged(oldModel, newModel);
            }
            else if (propertyName == "columnModel") {
                def oldModel = event.getOldValue() as TableColumnModel;
                def newModel = event.getNewValue() as TableColumnModel;
                columnModelChanged(oldModel, newModel);
            }
            else if (propertyName == "model") {
                def newTableModel = event.getNewValue() as javax.swing.table.TableModel;
                tableModel = newTableModel;
            }
            else if (propertyName == "autoResizeMode") {
                var autoResizeMode = event.getNewValue() as Integer;
                swingTable.autoResizeMode = TableResizeMode.valueOf(autoResizeMode);
            }
        }
        else if (source == jTable.getSelectionModel()) {
            if (propertyName == "selectionMode") {
                def selectionMode = event.getNewValue() as Integer;
                swingTable.rowSelectionMode = ListSelectionMode.valueOf(selectionMode);
            }
        }
        else if (source == jTable.getColumnModel().getSelectionModel()) {
            if (propertyName == "selectionMode") {
                def selectionMode = event.getNewValue() as Integer;
                swingTable.columnSelectionMode = ListSelectionMode.valueOf(selectionMode);
            }
        }
        else if (source == jTable.getColumnModel()) {
            if (propertyName == "selectionModel") {
                def oldModel = event.getOldValue() as ListSelectionModel;
                def newModel = event.getNewValue() as ListSelectionModel;
                columnSelectionModelChanged(oldModel, newModel);
            }
        }
    }

    function tableSelectionModeChanged(modeChanged:TableSelectionMode, enable:Boolean) {
        var currentMode = tableSelectionMode;
        if (currentMode == null) {
            currentMode = TableSelectionMode.NONE;
        }
        tableSelectionMode = if (enable) then currentMode.add(modeChanged)
            else currentMode.subtract(modeChanged);
    }

    function rowSelectionModelChanged(oldModel:ListSelectionModel, newModel:ListSelectionModel) {
        oldModel.removeListSelectionListener(rowSelectionListener);
        if (oldModel instanceof PropertyChangeNotifier) {
            (oldModel as PropertyChangeNotifier).removePropertyChangeListener("selectionMode", this);
        }

        newModel.addListSelectionListener(rowSelectionListener);
        if (isInitialized(rowSelectionMode)) {
            newModel.setSelectionMode(rowSelectionMode.getValue());
        }
        if (newModel instanceof PropertyChangeNotifier) {
            (newModel as PropertyChangeNotifier).addPropertyChangeListener("selectionMode", this);
        }
    }

    function columnSelectionModelChanged(oldModel:ListSelectionModel, newModel:ListSelectionModel) {
        if (oldModel instanceof PropertyChangeNotifier) {
            (oldModel as PropertyChangeNotifier).removePropertyChangeListener("selectionMode", this);
        }

        if (isInitialized(columnSelectionMode)) {
            newModel.setSelectionMode(columnSelectionMode.getValue());
        }
        if (newModel instanceof PropertyChangeNotifier) {
            (newModel as PropertyChangeNotifier).addPropertyChangeListener("selectionMode", this);
        }
    }

    function columnModelChanged(oldModel:TableColumnModel, newModel:TableColumnModel) {
        oldModel.removeColumnModelListener(columnModelListener);
        if (oldModel instanceof PropertyChangeNotifier) {
            (oldModel as PropertyChangeNotifier).removePropertyChangeListener("selectionModel", this);
        }

        newModel.addColumnModelListener(columnModelListener);
        if (newModel instanceof PropertyChangeNotifier) {
            (newModel as PropertyChangeNotifier).addPropertyChangeListener("selectionModel", this);
        }

        def oldSelectionModel = oldModel.getSelectionModel();
        def newSelectionModel = newModel.getSelectionModel();
        columnSelectionModelChanged(oldSelectionModel, newSelectionModel);
    }

    override function createJComponent() {
        def jTable = new JTable();
        jTable.addPropertyChangeListener(this);
        return jTable;
    }

    /**
     * Returns the Swing {@code JTable} encapsulated by this Component. Never returns {@code null}.
     */
    public function getJTable():JTable {
        return getJComponent() as JTable;
    }
}

class PropertyNotifierListSelectionModel extends DefaultListSelectionModel, PropertyChangeNotifier {
    override function setSelectionMode(newMode) {
        def oldMode = getSelectionMode();
        if (oldMode != newMode) {
            firePropertyChange("selectionMode", oldMode, newMode);
        }
        DefaultListSelectionModel.setSelectionMode(newMode);
    }
}

class PropertyNotifierColumnModel extends DefaultTableColumnModel, PropertyChangeNotifier {
    override function setSelectionModel(newMode) {
        def oldMode = getSelectionModel();
        if (oldMode != newMode) {
            firePropertyChange("selectionModel", oldMode, newMode);
        }
        DefaultTableColumnModel.setSelectionModel(newMode);
    }
}
