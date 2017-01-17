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

/**
 * @author John Freeman
 */
import javax.swing.ListSelectionModel;
import javax.swing.JTable;
import javax.swing.table.DefaultTableModel;
import org.jfxtras.ext.swing.table.*;
import org.jfxtras.test.*;
import org.jfxtras.test.Expect.*;

public class XSwingTableTest extends Test {}

class Person {
    var forename:String;
    var surname:String;
    var age:Integer;
}

var employees = [
    Person {
        forename: "Joe"
        surname: "Bloggs"
        age: 29
    }
    Person {
        forename: "Fred"
        surname: "Bloggs"
        age: 46
    }
    Person {
        forename: "John"
        surname: "Smith"
        age: 52
    }
];

def tableModel = ObjectSequenceTableModel {
    override function transformEntry(entry) {
        def person:Person = entry as Person;
        return Row {
            cells: [
                StringCell { value: bind person.forename }
                StringCell {
                    value: bind person.surname with inverse
                    editable: true
                }
                IntegerCell { value: bind person.age }
            ]
        }
    }
    columnLabels: ["Forename", "Surname", "Age"]
    sequence: bind employees
}

def swingTable = XSwingTable {
    tableModel: tableModel
}

var otherEmployees = [
    Person {
        forename: "Jane"
        surname: "Bloggs"
        age: 29
    }
    Person {
        forename: "Fran"
        surname: "Bloggs"
        age: 30
    }
];

def otherTableModel = ObjectSequenceTableModel {
    override function transformEntry(entry) {
        def person:Person = entry as Person;
        return Row {
            cells: [
                StringCell { value: bind person.forename }
                StringCell {
                    value: bind person.surname with inverse
                    editable: true
                }
                IntegerCell { value: bind person.age }
            ]
        }
    }
    columnLabels: ["Forename", "Surname", "Age"]
    sequence: bind otherEmployees
}

def swingTableModel = new DefaultTableModel();

public function run() {
    perform("XSwingTable", [
        Test {
            say: "tableSelectionMode"
            test: [
                Test {
                    say: "should set cell mode"
                    do: function() {
                        swingTable.tableSelectionMode = TableSelectionMode.CELL;
                        return swingTable.getJTable().getCellSelectionEnabled();
                    }
                    expect: equalTo(true);
                }
                Test {
                    say: "should set row mode"
                    do: function() {
                        swingTable.tableSelectionMode = TableSelectionMode.ROW;
                        return swingTable.getJTable().getRowSelectionAllowed()
                            and not swingTable.getJTable().getColumnSelectionAllowed();
                    }
                    expect: equalTo(true);
                }
                Test {
                    say: "should set column mode"
                    do: function() {
                        swingTable.tableSelectionMode = TableSelectionMode.COLUMN;
                        return swingTable.getJTable().getColumnSelectionAllowed()
                            and not swingTable.getJTable().getRowSelectionAllowed();
                    }
                    expect: equalTo(true);
                }
                Test {
                    say: "should set mode none"
                    do: function() {
                        swingTable.tableSelectionMode = TableSelectionMode.NONE;
                        return not (swingTable.getJTable().getColumnSelectionAllowed()
                            or swingTable.getJTable().getRowSelectionAllowed());
                    }
                    expect: equalTo(true);
                }
                Test {
                    say: "should set pickup cell mode"
                    do: function() {
                        swingTable.getJTable().setCellSelectionEnabled(true);
                        return swingTable.tableSelectionMode;
                    }
                    expect: equalTo(TableSelectionMode.CELL);
                }
                Test {
                    say: "should set pickup row mode"
                    do: function() {
                        swingTable.getJTable().setColumnSelectionAllowed(false);
                        swingTable.getJTable().setRowSelectionAllowed(true);
                        return swingTable.tableSelectionMode;
                    }
                    expect: equalTo(TableSelectionMode.ROW);
                }
                Test {
                    say: "should set pickup column mode"
                    do: function() {
                        swingTable.getJTable().setColumnSelectionAllowed(true);
                        swingTable.getJTable().setRowSelectionAllowed(false);
                        return swingTable.tableSelectionMode;
                    }
                    expect: equalTo(TableSelectionMode.COLUMN);
                }
                Test {
                    say: "should set pickup mode none"
                    do: function() {
                        swingTable.getJTable().setColumnSelectionAllowed(false);
                        swingTable.getJTable().setRowSelectionAllowed(false);
                        return swingTable.tableSelectionMode;
                    }
                    expect: equalTo(TableSelectionMode.NONE);
                }
            ]
        }
        Test {
            say: "columnSelectionMode"
            test: [
                Test {
                    say: "should set single mode"
                    do: function() {
                        swingTable.columnSelectionMode = ListSelectionMode.SINGLE_SELECTION;
                        return swingTable.getJTable().getColumnModel().getSelectionModel().getSelectionMode();
                    }
                    expect: equalTo(ListSelectionModel.SINGLE_SELECTION);
                }
                Test {
                    say: "should set single interval mode"
                    do: function() {
                        swingTable.columnSelectionMode = ListSelectionMode.SINGLE_INTERVAL_SELECTION;
                        return swingTable.getJTable().getColumnModel().getSelectionModel().getSelectionMode();
                    }
                    expect: equalTo(ListSelectionModel.SINGLE_INTERVAL_SELECTION);
                }
                Test {
                    say: "should set multiple interval mode"
                    do: function() {
                        swingTable.columnSelectionMode = ListSelectionMode.MULTIPLE_INTERVAL_SELECTION;
                        return swingTable.getJTable().getColumnModel().getSelectionModel().getSelectionMode();
                    }
                    expect: equalTo(ListSelectionModel.MULTIPLE_INTERVAL_SELECTION);
                }
                Test {
                    say: "should pickup single mode"
                    do: function() {
                        def selectionModel = swingTable.getJTable().getColumnModel().getSelectionModel();
                        selectionModel.setSelectionMode(ListSelectionModel.SINGLE_SELECTION);
                        return swingTable.columnSelectionMode;
                    }
                    expect: equalTo(ListSelectionMode.SINGLE_SELECTION);
                }
                Test {
                    say: "should pickup single interval mode"
                    do: function() {
                        def selectionModel = swingTable.getJTable().getColumnModel().getSelectionModel();
                        selectionModel.setSelectionMode(ListSelectionModel.SINGLE_INTERVAL_SELECTION);
                        return swingTable.columnSelectionMode;
                    }
                    expect: equalTo(ListSelectionMode.SINGLE_INTERVAL_SELECTION);
                }
                Test {
                    say: "should pickup multiple interval mode"
                    do: function() {
                        def selectionModel = swingTable.getJTable().getColumnModel().getSelectionModel();
                        selectionModel.setSelectionMode(ListSelectionModel.MULTIPLE_INTERVAL_SELECTION);
                        return swingTable.columnSelectionMode;
                    }
                    expect: equalTo(ListSelectionMode.MULTIPLE_INTERVAL_SELECTION);
                }
            ]
        }
        Test {
            say: "rowSelectionMode"
            test: [
                Test {
                    say: "should set single mode"
                    do: function() {
                        swingTable.rowSelectionMode = ListSelectionMode.SINGLE_SELECTION;
                        return swingTable.getJTable().getSelectionModel().getSelectionMode();
                    }
                    expect: equalTo(ListSelectionModel.SINGLE_SELECTION);
                }
                Test {
                    say: "should set single interval mode"
                    do: function() {
                        swingTable.rowSelectionMode = ListSelectionMode.SINGLE_INTERVAL_SELECTION;
                        return swingTable.getJTable().getSelectionModel().getSelectionMode();
                    }
                    expect: equalTo(ListSelectionModel.SINGLE_INTERVAL_SELECTION);
                }
                Test {
                    say: "should set multiple interval mode"
                    do: function() {
                        swingTable.rowSelectionMode = ListSelectionMode.MULTIPLE_INTERVAL_SELECTION;
                        return swingTable.getJTable().getSelectionModel().getSelectionMode();
                    }
                    expect: equalTo(ListSelectionModel.MULTIPLE_INTERVAL_SELECTION);
                }
                Test {
                    say: "should pickup single mode"
                    do: function() {
                        def selectionModel = swingTable.getJTable().getSelectionModel();
                        selectionModel.setSelectionMode(ListSelectionModel.SINGLE_SELECTION);
                        return swingTable.rowSelectionMode;
                    }
                    expect: equalTo(ListSelectionMode.SINGLE_SELECTION);
                }
                Test {
                    say: "should pickup single interval mode"
                    do: function() {
                        def selectionModel = swingTable.getJTable().getSelectionModel();
                        selectionModel.setSelectionMode(ListSelectionModel.SINGLE_INTERVAL_SELECTION);
                        return swingTable.rowSelectionMode;
                    }
                    expect: equalTo(ListSelectionMode.SINGLE_INTERVAL_SELECTION);
                }
                Test {
                    say: "should pickup multiple interval mode"
                    do: function() {
                        def selectionModel = swingTable.getJTable().getSelectionModel();
                        selectionModel.setSelectionMode(ListSelectionModel.MULTIPLE_INTERVAL_SELECTION);
                        return swingTable.rowSelectionMode;
                    }
                    expect: equalTo(ListSelectionMode.MULTIPLE_INTERVAL_SELECTION);
                }
            ]
        }
        Test {
            say: "preferredColumnWidths"
            do: function() {
                swingTable.preferredColumnWidths = [100, 200, 300];
                var columnModel = swingTable.getJTable().getColumnModel();
                var preferredColumnWidths:Integer[] = for (i in [0 .. columnModel.getColumnCount() - 1]) {
                    columnModel.getColumn(i).getPreferredWidth();
                }

                return preferredColumnWidths as Object;
            }
            expect: equalTo([100, 200, 300]);
        }
        Test {
            say: "preferredColumnWidths extra values"
            do: function() {
                swingTable.preferredColumnWidths = [100, 200, 300, 400];
                var columnModel = swingTable.getJTable().getColumnModel();
                var preferredColumnWidths:Integer[] = for (i in [0 .. columnModel.getColumnCount() - 1]) {
                    columnModel.getColumn(i).getPreferredWidth();
                }

                return preferredColumnWidths as Object;
            }
            expect: equalTo([100, 200, 300]);
        }
        Test {
            say: "preferredColumnWidths with new tableModel"
            do: function() {
                swingTable.preferredColumnWidths = [100, 200, 300];
                swingTable.tableModel = otherTableModel;
                var columnModel = swingTable.getJTable().getColumnModel();
                var preferredColumnWidths:Integer[] = for (i in [0 .. columnModel.getColumnCount() - 1]) {
                    columnModel.getColumn(i).getPreferredWidth();
                }

                return preferredColumnWidths as Object;
            }
            expect: equalTo([100, 200, 300]);
        }
        Test {
            say: "tableModel"
            test: [
                Test {
                    say: "set origional"
                    do: function() {
                        swingTable.tableModel = tableModel;
                        return swingTable.getJTable().getModel();
                    }
                    expect: equalTo(tableModel);
                }
                Test {
                    say: "set other"
                    do: function() {
                        swingTable.tableModel = otherTableModel;
                        return swingTable.getJTable().getModel();
                    }
                    expect: equalTo(otherTableModel);
                }
                Test {
                    say: "pickup origional"
                    do: function() {
                        swingTable.getJTable().setModel(swingTableModel);
                        return swingTable.tableModel;
                    }
                    expect: equalTo(swingTableModel);
                }
            ]
        }
        Test {
            say: "select"
            test: [
                Test {
                    say: "first row"
                    do: function() {
                        var selectedIndex:java.lang.Integer;
                        swingTable.onSelectedRowChanged = function(index) {
                            selectedIndex = index;
                        }

                        var rowSelectionModel = swingTable.getJTable().getSelectionModel();
                        rowSelectionModel.setSelectionInterval(0, 0);
                        return selectedIndex;
                    }
                    expect: equalTo(0);
                }
                Test {
                    say: "second row"
                    do: function() {
                        var selectedIndex:java.lang.Integer;
                        swingTable.onSelectedRowChanged = function(index) {
                            selectedIndex = index;
                        }

                        var rowSelectionModel = swingTable.getJTable().getSelectionModel();
                        rowSelectionModel.setSelectionInterval(1, 1);
                        return selectedIndex;
                    }
                    expect: equalTo(1);
                }
                Test {
                    say: "second to third row"
                    do: function() {
                        var selectedIndexes:Integer[];
                        swingTable.onSelectedRowsChanged = function(indexes) {
                            selectedIndexes = indexes;
                        }

                        var rowSelectionModel = swingTable.getJTable().getSelectionModel();
                        rowSelectionModel.setSelectionInterval(1, 2);
                        return selectedIndexes as Object;
                    }
                    expect: equalTo([1,2]);
                }
                Test {
                    say: "first column"
                    do: function() {
                        var selectedIndex:java.lang.Integer;
                        swingTable.onSelectedColumnChanged = function(index) {
                            selectedIndex = index;
                        }

                        var columnSelectionModel = swingTable.getJTable().getColumnModel().getSelectionModel();
                        columnSelectionModel.setSelectionInterval(0, 0);
                        return selectedIndex;
                    }
                    expect: equalTo(0);
                }
                Test {
                    say: "second column"
                    do: function() {
                        var selectedIndex:java.lang.Integer;
                        swingTable.onSelectedColumnChanged = function(index) {
                            selectedIndex = index;
                        }

                        var columnSelectionModel = swingTable.getJTable().getColumnModel().getSelectionModel();
                        columnSelectionModel.setSelectionInterval(1, 1);
                        return selectedIndex;
                    }
                    expect: equalTo(1);
                }
                Test {
                    say: "second to third column"
                    do: function() {
                        var selectedIndexes:Integer[];
                        swingTable.onSelectedColumnsChanged = function(indexes) {
                            selectedIndexes = indexes;
                        }

                        var columnSelectionModel = swingTable.getJTable().getColumnModel().getSelectionModel();
                        columnSelectionModel.setSelectionInterval(1, 2);
                        return selectedIndexes as Object;
                    }
                    expect: equalTo([1,2]);
                }
            ]
        }
        Test {
            say: "clear selected"
            test: [
                Test {
                    say: "row"
                    do: function() {
                        var selectedIndex:java.lang.Integer;
                        swingTable.onSelectedRowChanged = function(index) {
                            selectedIndex = index;
                        }

                        var rowSelectionModel = swingTable.getJTable().getSelectionModel();
                        rowSelectionModel.setSelectionInterval(0, 0);
                        rowSelectionModel.clearSelection();
                        return selectedIndex;
                    }
                    expect: equalTo(null);
                }
                Test {
                    say: "rows"
                    do: function() {
                        var selectedIndexes:Integer[];
                        swingTable.onSelectedRowsChanged = function(indexes) {
                            selectedIndexes = indexes;
                        }

                        var rowSelectionModel = swingTable.getJTable().getSelectionModel();
                        rowSelectionModel.setSelectionInterval(1, 2);
                        rowSelectionModel.clearSelection();
                        return selectedIndexes as Object;
                    }
                    expect: equalTo([]);
                }
                Test {
                    say: "column"
                    do: function() {
                        var selectedIndex:java.lang.Integer;
                        swingTable.onSelectedRowChanged = function(index) {
                            selectedIndex = index;
                        }

                        var columnSelectionModel = swingTable.getJTable().getColumnModel().getSelectionModel();
                        columnSelectionModel.setSelectionInterval(0, 0);
                        columnSelectionModel.clearSelection();
                        return selectedIndex;
                    }
                    expect: equalTo(null);
                }
                Test {
                    say: "columns"
                    do: function() {
                        var selectedIndexes:Integer[];
                        swingTable.onSelectedColumnsChanged = function(indexes) {
                            selectedIndexes = indexes;
                        }

                        var columnSelectionModel = swingTable.getJTable().getColumnModel().getSelectionModel();
                        columnSelectionModel.setSelectionInterval(1, 2);
                        columnSelectionModel.clearSelection();
                        return selectedIndexes as Object;
                    }
                    expect: equalTo([]);
                }
            ]
        }
        Test {
            say: "auto resize mode"
            test: [
                Test {
                    say: "set AUTO_RESIZE_OFF"
                    do: function() {
                        swingTable.autoResizeMode = TableResizeMode.AUTO_RESIZE_OFF;
                        return swingTable.getJTable().getAutoResizeMode();
                    }
                    expect: equalTo(JTable.AUTO_RESIZE_OFF);
                }
                Test {
                    say: "set AUTO_RESIZE_LAST_COLUMN"
                    do: function() {
                        swingTable.autoResizeMode = TableResizeMode.AUTO_RESIZE_LAST_COLUMN;
                        return swingTable.getJTable().getAutoResizeMode();
                    }
                    expect: equalTo(JTable.AUTO_RESIZE_LAST_COLUMN);
                }
                Test {
                    say: "pickup AUTO_RESIZE_OFF"
                    do: function() {
                        swingTable.getJTable().setAutoResizeMode(JTable.AUTO_RESIZE_OFF);
                        return swingTable.autoResizeMode;
                    }
                    expect: equalTo(TableResizeMode.AUTO_RESIZE_OFF);
                }
                Test {
                    say: "pickup AUTO_RESIZE_LAST_COLUMN"
                    do: function() {
                        swingTable.getJTable().setAutoResizeMode(JTable.AUTO_RESIZE_LAST_COLUMN);
                        return swingTable.autoResizeMode;
                    }
                    expect: equalTo(TableResizeMode.AUTO_RESIZE_LAST_COLUMN);
                }
            ]
        }
    ]);
}
