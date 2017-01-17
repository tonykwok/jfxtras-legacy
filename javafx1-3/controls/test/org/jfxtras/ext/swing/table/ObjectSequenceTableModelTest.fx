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

/**
 * @author John Freeman
 */

import javax.swing.event.*;
import org.jfxtras.ext.swing.table.*;
import org.jfxtras.test.*;
import org.jfxtras.test.Expect.*;

public class ObjectSequenceTableModelTest extends Test {}

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
        age: 30
    }
];

def tableModel = ObjectSequenceTableModel {
    override function transformEntry(entry) {
        def person:Person = entry as Person;
        return Row {
            cells: [
                StringCell {
                    value: bind person.forename with inverse
                    editable: true
                }
                StringCell { value: bind person.surname }
                IntegerCell { value: bind person.age }
            ]
        }
    }
    columnLabels: ["Forename", "Surname", "Age"]
    sequence: bind employees

    override function toString() {
        return "testTableModel";
    }
}

def namelessTableModel = ObjectSequenceTableModel {
    override function transformEntry(entry) {
        def person:Person = entry as Person;
        return Row {
            cells: [
                StringCell {
                    value: bind person.forename with inverse
                    editable: true
                }
                StringCell { value: bind person.surname }
                IntegerCell { value: bind person.age }
            ]
        }
    }
    sequence: bind employees
}

var eventCount = 0;
var event:TableModelEvent;

public function run() {
    tableModel.addTableModelListener(TableModelListener {
        override function tableChanged(e) {
            eventCount++;
            event = e;
        }
    });
    perform("ObjectSequenceTableModel", [
        Test {
            say: "should return column count of 3"
            do: function() {
                return tableModel.getColumnCount();
            }
            expect: equalTo(3);
        }
        Test {
            say: "should return string class for first column"
            do: function() {
                return tableModel.getColumnClass(0).getName();
            }
            expect: equalTo("java.lang.String");
        }
        Test {
            say: "should return string class for second column"
            do: function() {
                return tableModel.getColumnClass(1).getName();
            }
            expect: equalTo("java.lang.String");
        }
        Test {
            say: "should return integer class for third column"
            do: function() {
                return tableModel.getColumnClass(0).getName();
            }
            expect: equalTo("java.lang.String");
        }
        Test {
            say: "should return editable true for first column"
            do: function() {
                return tableModel.isCellEditable(0, 0);
            }
            expect: equalTo(true);
        }
        Test {
            say: "should return editable false for second column"
            do: function() {
                return tableModel.isCellEditable(0, 1);
            }
            expect: equalTo(false);
        }
        Test {
            say: "should return editable false for third column"
            do: function() {
                return tableModel.isCellEditable(0, 2);
            }
            expect: equalTo(false);
        }
        Test {
            say: "should reflect model value"
            do: function() {
                employees[1].forename = "Jane";
                return tableModel.getValueAt(1, 0);
            }
            expect: equalTo("Jane");
        }
        Test {
            say: "should update model value"
            do: function() {
                tableModel.setValueAt("Fran", 1, 0);
                return employees[1].forename;
            }
            expect: equalTo("Fran")
        }
        // todo 1.3 - This is broken in 1.3, but fixed in 1.3.1 (per http://javafx-jira.kenai.com/browse/JFXC-4295)
//        Test {
//            say: "model update should trigger event"
//            do: function() {
//                eventCount = 0;
//                employees[1].forename = "Jim";
//                return "eventCount: {eventCount}, source: {event.getSource()}, type: {event.getType()}, firstRow: {event.getFirstRow()}, lastRow: {event.getLastRow()}, column: {event.getColumn()}";
//            }
//            expect: equalTo("eventCount: 1, source: testTableModel, type: 0, firstRow: 1, lastRow: 1, column: 0");
//        }
        Test {
            say: "model insert should trigger event"
            do: function() {
                eventCount = 0;
                insert Person { forename: "John", surname: "Smith", age: 40} into employees;
                return "eventCount: {eventCount}, source: {event.getSource()}, type: {event.getType()}, firstRow: {event.getFirstRow()}, lastRow: {event.getLastRow()}, column: {event.getColumn()}";
            }
            expect: equalTo("eventCount: 1, source: testTableModel, type: 1, firstRow: 2, lastRow: 2, column: -1");
        }
        Test {
            say: "model delete should trigger event"
            do: function() {
                eventCount = 0;
                delete employees[1] from employees;
                return "eventCount: {eventCount}, source: {event.getSource()}, type: {event.getType()}, firstRow: {event.getFirstRow()}, lastRow: {event.getLastRow()}, column: {event.getColumn()}";
            }
            expect: equalTo("eventCount: 1, source: testTableModel, type: -1, firstRow: 1, lastRow: 1, column: -1");
        }
        Test {
            say: "auto-generated column names"
            test: [
                Test {
                    say: "first column"
                    do: function() {
                        return namelessTableModel.getColumnName(0);
                    }
                    expect: equalTo("A");
                }
                Test {
                    say: "second column"
                    do: function() {
                        return namelessTableModel.getColumnName(1);
                    }
                    expect: equalTo("B");
                }
                Test {
                    say: "twenty seventh column"
                    do: function() {
                        return namelessTableModel.getColumnName(26);
                    }
                    expect: equalTo("AA");
                }
                Test {
                    say: "twenty eighth column"
                    do: function() {
                        return namelessTableModel.getColumnName(27);
                    }
                    expect: equalTo("AB");
                }
                Test {
                    say: "fifty third column"
                    do: function() {
                        return namelessTableModel.getColumnName(52);
                    }
                    expect: equalTo("BA");
                }
                Test {
                    say: "703 column"
                    do: function() {
                        return namelessTableModel.getColumnName(702);
                    }
                    expect: equalTo("AAA");
                }
            ]
        }
    ]);
}
