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

import org.jfxtras.test.*;
import org.jfxtras.test.Expect.*;

import java.math.BigDecimal;
import java.math.BigInteger;
import java.util.Date;
import javax.swing.event.TableModelListener;
import javax.swing.event.TableModelEvent;
import javax.swing.table.TableModel;
import org.jfxtras.ext.swing.table.*;

public class BasicSequenceTableModelTest extends Test {}

var eventCount = 0;
var event:TableModelEvent;
def tableModelListener = TableModelListener {
    override function tableChanged(e:javax.swing.event.TableModelEvent):Void {
        eventCount++;
        event = e;
    }
}

function listenTo(tableModel:TableModel) {
    tableModel.removeTableModelListener(tableModelListener);
    tableModel.addTableModelListener(tableModelListener);
}

public function run() {
    perform([
        Test {
            var sequence:BigDecimal[] = [new BigDecimal("0"), new BigDecimal("1"), new BigDecimal("2")];
            def tableModel = BigDecimalSequenceTableModel {
                sequence: bind sequence with inverse
                override public function toString() {
                    return "testTableModel";
                }
            }

            say: "BigDecimalSequenceTableModel"
            test: [
                Test {
                    say: "should return column count of 1"
                    do: function() {
                        return tableModel.getColumnCount();
                    }
                    expect: equalTo(1);
                }
                Test {
                    say: "should return BigDecimal class"
                    do: function() {
                        return tableModel.getColumnClass(0).getName();
                    }
                    expect: equalTo("java.math.BigDecimal");
                }
                Test {
                    say: "should set editable false"
                    do: function() {
                        tableModel.editable = false;
                        return tableModel.isCellEditable(1, 0);
                    }
                    expect: equalTo(false);
                }
                Test {
                    say: "should set editable true"
                    do: function() {
                        tableModel.editable = true;
                        return tableModel.isCellEditable(1, 0);
                    }
                    expect: equalTo(true);
                }
                Test {
                    say: "should reflect model value"
                    do: function() {
                        sequence[1] = new BigDecimal("9");
                        return tableModel.getValueAt(1, 0);
                    }
                    expect: equalTo(new BigDecimal("9"));
                }
                Test {
                    say: "should update model value"
                    do: function() {
                        tableModel.setValueAt(new BigDecimal("7"), 1, 0);
                        return sequence[1];
                    }
                    expect: equalTo(new BigDecimal("7"))
                }
                Test {
                    say: "model update should trigger event"
                    do: function() {
                        eventCount = 0;
                        listenTo(tableModel);
                        tableModel.sequence[1] = new BigDecimal("14");
                        return "eventCount: {eventCount}, source: {event.getSource()}, type: {event.getType()}, firstRow: {event.getFirstRow()}, lastRow: {event.getLastRow()}, column: {event.getColumn()}";
                    }
                    expect: equalTo("eventCount: 1, source: testTableModel, type: 0, firstRow: 1, lastRow: 1, column: -1");
                }
                Test {
                    say: "model insert should trigger event"
                    do: function() {
                        eventCount = 0;
                        listenTo(tableModel);
                        insert new BigDecimal("15") into tableModel.sequence;
                        return "eventCount: {eventCount}, source: {event.getSource()}, type: {event.getType()}, firstRow: {event.getFirstRow()}, lastRow: {event.getLastRow()}, column: {event.getColumn()}";
                    }
                    expect: equalTo("eventCount: 1, source: testTableModel, type: 1, firstRow: 3, lastRow: 3, column: -1");
                }
                Test {
                    say: "model delete should trigger event"
                    do: function() {
                        eventCount = 0;
                        listenTo(tableModel);
                        delete tableModel.sequence[1] from tableModel.sequence;
                        return "eventCount: {eventCount}, source: {event.getSource()}, type: {event.getType()}, firstRow: {event.getFirstRow()}, lastRow: {event.getLastRow()}, column: {event.getColumn()}";
                    }
                    expect: equalTo("eventCount: 1, source: testTableModel, type: -1, firstRow: 1, lastRow: 1, column: -1");
                }
            ]
        }
        Test {
            var sequence:BigInteger[] = [new BigInteger("0"), new BigInteger("1"), new BigInteger("2")];
            def tableModel = BigIntegerSequenceTableModel {
                sequence: bind sequence with inverse
                override public function toString() {
                    return "testTableModel";
                }
            }

            say: "BigIntegerSequenceTableModel"
            test: [
                Test {
                    say: "should return column count of 1"
                    do: function() {
                        return tableModel.getColumnCount();
                    }
                    expect: equalTo(1);
                }
                Test {
                    say: "should return BigInteger class"
                    do: function() {
                        return tableModel.getColumnClass(0).getName();
                    }
                    expect: equalTo("java.math.BigInteger");
                }
                Test {
                    say: "should set editable false"
                    do: function() {
                        tableModel.editable = false;
                        return tableModel.isCellEditable(1, 0);
                    }
                    expect: equalTo(false);
                }
                Test {
                    say: "should set editable true"
                    do: function() {
                        tableModel.editable = true;
                        return tableModel.isCellEditable(1, 0);
                    }
                    expect: equalTo(true);
                }
                Test {
                    say: "should reflect model value"
                    do: function() {
                        sequence[1] = new BigInteger("9");
                        return tableModel.getValueAt(1, 0);
                    }
                    expect: equalTo(new BigInteger("9"));
                }
                Test {
                    say: "should update model value"
                    do: function() {
                        tableModel.setValueAt(new BigInteger("7"), 1, 0);
                        return sequence[1];
                    }
                    expect: equalTo(new BigInteger("7"))
                }
                Test {
                    say: "model update should trigger event"
                    do: function() {
                        eventCount = 0;
                        listenTo(tableModel);
                        tableModel.sequence[1] = new BigInteger("14");
                        return "eventCount: {eventCount}, source: {event.getSource()}, type: {event.getType()}, firstRow: {event.getFirstRow()}, lastRow: {event.getLastRow()}, column: {event.getColumn()}";
                    }
                    expect: equalTo("eventCount: 1, source: testTableModel, type: 0, firstRow: 1, lastRow: 1, column: -1");
                }
                Test {
                    say: "model insert should trigger event"
                    do: function() {
                        eventCount = 0;
                        listenTo(tableModel);
                        insert new BigInteger("15") into tableModel.sequence;
                        return "eventCount: {eventCount}, source: {event.getSource()}, type: {event.getType()}, firstRow: {event.getFirstRow()}, lastRow: {event.getLastRow()}, column: {event.getColumn()}";
                    }
                    expect: equalTo("eventCount: 1, source: testTableModel, type: 1, firstRow: 3, lastRow: 3, column: -1");
                }
                Test {
                    say: "model delete should trigger event"
                    do: function() {
                        eventCount = 0;
                        listenTo(tableModel);
                        delete tableModel.sequence[1] from tableModel.sequence;
                        return "eventCount: {eventCount}, source: {event.getSource()}, type: {event.getType()}, firstRow: {event.getFirstRow()}, lastRow: {event.getLastRow()}, column: {event.getColumn()}";
                    }
                    expect: equalTo("eventCount: 1, source: testTableModel, type: -1, firstRow: 1, lastRow: 1, column: -1");
                }
            ]
        }
        Test {
            var sequence = [true, false, true];
            def tableModel:BooleanSequenceTableModel = BooleanSequenceTableModel {
                sequence: bind sequence with inverse
                override public function toString() {
                    return "testTableModel";
                }
            }
            say: "BooleanSequenceTableModel"
            test: [
                Test {
                    say: "should return column count of 1"
                    do: function() {
                        return tableModel.getColumnCount();
                    }
                    expect: equalTo(1);
                }
                Test {
                    say: "should return boolean class"
                    do: function() {
                        return tableModel.getColumnClass(0).getName();
                    }
                    expect: equalTo("java.lang.Boolean");
                }
                Test {
                    say: "should set editable false"
                    do: function() {
                        tableModel.editable = false;
                        return tableModel.isCellEditable(1, 0);
                    }
                    expect: equalTo(false);
                }
                Test {
                    say: "should set editable true"
                    do: function() {
                        tableModel.editable = true;
                        return tableModel.isCellEditable(1, 0);
                    }
                    expect: equalTo(true);
                }
                Test {
                    say: "should reflect model true"
                    do: function() {
                        sequence[1] = true;
                        return tableModel.getValueAt(1, 0);
                    }
                    expect: equalTo(true);
                }
                Test {
                    say: "should reflect model false"
                    do: function() {
                        sequence[1] = false;
                        return tableModel.getValueAt(1, 0);
                    }
                    expect: equalTo(false);
                }
                Test {
                    say: "should update model true"
                    do: function() {
                        tableModel.setValueAt(true, 1, 0);
                        return sequence[1];
                    }
                    expect: equalTo(true)
                }
                Test {
                    say: "should update model false"
                    do: function() {
                        tableModel.setValueAt(false, 1, 0);
                        return sequence[1];
                    }
                    expect: equalTo(false)
                }
                Test {
                    say: "model update should trigger event"
                    do: function() {
                        tableModel.sequence[1] = true;
                        eventCount = 0;
                        listenTo(tableModel);
                        tableModel.sequence[1] = false;
                        return "eventCount: {eventCount}, source: {event.getSource()}, type: {event.getType()}, firstRow: {event.getFirstRow()}, lastRow: {event.getLastRow()}, column: {event.getColumn()}";
                    }
                    expect: equalTo("eventCount: 1, source: testTableModel, type: 0, firstRow: 1, lastRow: 1, column: -1");
                }
                Test {
                    say: "model insert should trigger event"
                    do: function() {
                        eventCount = 0;
                        listenTo(tableModel);
                        insert true into tableModel.sequence;
                        return "eventCount: {eventCount}, source: {event.getSource()}, type: {event.getType()}, firstRow: {event.getFirstRow()}, lastRow: {event.getLastRow()}, column: {event.getColumn()}";
                    }
                    expect: equalTo("eventCount: 1, source: testTableModel, type: 1, firstRow: 3, lastRow: 3, column: -1");
                }
                Test {
                    say: "model delete should trigger event"
                    do: function() {
                        eventCount = 0;
                        listenTo(tableModel);
                        delete tableModel.sequence[1] from tableModel.sequence;
                        return "eventCount: {eventCount}, source: {event.getSource()}, type: {event.getType()}, firstRow: {event.getFirstRow()}, lastRow: {event.getLastRow()}, column: {event.getColumn()}";
                    }
                    expect: equalTo("eventCount: 1, source: testTableModel, type: -1, firstRow: 1, lastRow: 1, column: -1");
                }
            ]
        }
        Test {
            var sequence:Byte[] = [0, 1, 2];
            def tableModel = ByteSequenceTableModel {
                sequence: bind sequence with inverse
                override public function toString() {
                    return "testTableModel";
                }
            }

            say: "ByteSequenceTableModel"
            test: [
                Test {
                    say: "should return column count of 1"
                    do: function() {
                        return tableModel.getColumnCount();
                    }
                    expect: equalTo(1);
                }
                Test {
                    say: "should return byte class"
                    do: function() {
                        return tableModel.getColumnClass(0).getName();
                    }
                    expect: equalTo("java.lang.Byte");
                }
                Test {
                    say: "should set editable false"
                    do: function() {
                        tableModel.editable = false;
                        return tableModel.isCellEditable(1, 0);
                    }
                    expect: equalTo(false);
                }
                Test {
                    say: "should set editable true"
                    do: function() {
                        tableModel.editable = true;
                        return tableModel.isCellEditable(1, 0);
                    }
                    expect: equalTo(true);
                }
                Test {
                    say: "should reflect model value"
                    do: function() {
                        sequence[1] = 9;
                        return tableModel.getValueAt(1, 0);
                    }
                    expect: equalTo(9 as Byte);
                }
                Test {
                    say: "should update model value"
                    do: function() {
                        tableModel.setValueAt(7 as Byte, 1, 0);
                        return sequence[1];
                    }
                    expect: equalTo(7 as Byte)
                }
                Test {
                    say: "model update should trigger event"
                    do: function() {
                        eventCount = 0;
                        listenTo(tableModel);
                        tableModel.sequence[1] = 14;
                        return "eventCount: {eventCount}, source: {event.getSource()}, type: {event.getType()}, firstRow: {event.getFirstRow()}, lastRow: {event.getLastRow()}, column: {event.getColumn()}";
                    }
                    expect: equalTo("eventCount: 1, source: testTableModel, type: 0, firstRow: 1, lastRow: 1, column: -1");
                }
                Test {
                    say: "model insert should trigger event"
                    do: function() {
                        eventCount = 0;
                        listenTo(tableModel);
                        insert 15 into tableModel.sequence;
                        return "eventCount: {eventCount}, source: {event.getSource()}, type: {event.getType()}, firstRow: {event.getFirstRow()}, lastRow: {event.getLastRow()}, column: {event.getColumn()}";
                    }
                    expect: equalTo("eventCount: 1, source: testTableModel, type: 1, firstRow: 3, lastRow: 3, column: -1");
                }
                Test {
                    say: "model delete should trigger event"
                    do: function() {
                        eventCount = 0;
                        listenTo(tableModel);
                        delete tableModel.sequence[1] from tableModel.sequence;
                        return "eventCount: {eventCount}, source: {event.getSource()}, type: {event.getType()}, firstRow: {event.getFirstRow()}, lastRow: {event.getLastRow()}, column: {event.getColumn()}";
                    }
                    expect: equalTo("eventCount: 1, source: testTableModel, type: -1, firstRow: 1, lastRow: 1, column: -1");
                }
            ]
        }
        Test {
            def date1 = new Date();
            def date2 = new Date(date1.getTime() + 1000);
            def date3 = new Date(date2.getTime() + 1000);
            def date4 = new Date(date3.getTime() + 1000);
            def date5 = new Date(date4.getTime() + 1000);
            def date6 = new Date(date5.getTime() + 1000);
            def date7 = new Date(date6.getTime() + 1000);
            var sequence = [date1, date2, date3];
            def tableModel = DateSequenceTableModel {
                sequence: bind sequence with inverse
                override public function toString() {
                    return "testTableModel";
                }
            }

            say: "DateSequenceTableModel"
            test: [
                Test {
                    say: "should return column count of 1"
                    do: function() {
                        return tableModel.getColumnCount();
                    }
                    expect: equalTo(1);
                }
                Test {
                    say: "should return date class"
                    do: function() {
                        return tableModel.getColumnClass(0).getName();
                    }
                    expect: equalTo("java.util.Date");
                }
                Test {
                    say: "should set editable false"
                    do: function() {
                        tableModel.editable = false;
                        return tableModel.isCellEditable(1, 0);
                    }
                    expect: equalTo(false);
                }
                Test {
                    say: "should set editable true"
                    do: function() {
                        tableModel.editable = true;
                        return tableModel.isCellEditable(1, 0);
                    }
                    expect: equalTo(true);
                }
                Test {
                    say: "should reflect model value"
                    do: function() {
                        sequence[1] = date4;
                        return tableModel.getValueAt(1, 0);
                    }
                    expect: equalTo(date4);
                }
                Test {
                    say: "should update model value"
                    do: function() {
                        tableModel.setValueAt(date5, 1, 0);
                        return sequence[1];
                    }
                    expect: equalTo(date5)
                }
                Test {
                    say: "model update should trigger event"
                    do: function() {
                        eventCount = 0;
                        listenTo(tableModel);
                        tableModel.sequence[1] = date6;
                        return "eventCount: {eventCount}, source: {event.getSource()}, type: {event.getType()}, firstRow: {event.getFirstRow()}, lastRow: {event.getLastRow()}, column: {event.getColumn()}";
                    }
                    expect: equalTo("eventCount: 1, source: testTableModel, type: 0, firstRow: 1, lastRow: 1, column: -1");
                }
                Test {
                    say: "model insert should trigger event"
                    do: function() {
                        eventCount = 0;
                        listenTo(tableModel);
                        insert date7 into tableModel.sequence;
                        return "eventCount: {eventCount}, source: {event.getSource()}, type: {event.getType()}, firstRow: {event.getFirstRow()}, lastRow: {event.getLastRow()}, column: {event.getColumn()}";
                    }
                    expect: equalTo("eventCount: 1, source: testTableModel, type: 1, firstRow: 3, lastRow: 3, column: -1");
                }
                Test {
                    say: "model delete should trigger event"
                    do: function() {
                        eventCount = 0;
                        listenTo(tableModel);
                        delete tableModel.sequence[1] from tableModel.sequence;
                        return "eventCount: {eventCount}, source: {event.getSource()}, type: {event.getType()}, firstRow: {event.getFirstRow()}, lastRow: {event.getLastRow()}, column: {event.getColumn()}";
                    }
                    expect: equalTo("eventCount: 1, source: testTableModel, type: -1, firstRow: 1, lastRow: 1, column: -1");
                }
            ]
        }
        Test {
            var sequence:Double[] = [0, 1, 2];
            def tableModel = DoubleSequenceTableModel {
                sequence: bind sequence with inverse
                override public function toString() {
                    return "testTableModel";
                }
            }

            say: "DoubleSequenceTableModel"
            test: [
                Test {
                    say: "should return column count of 1"
                    do: function() {
                        return tableModel.getColumnCount();
                    }
                    expect: equalTo(1);
                }
                Test {
                    say: "should return double class"
                    do: function() {
                        return tableModel.getColumnClass(0).getName();
                    }
                    expect: equalTo("java.lang.Double");
                }
                Test {
                    say: "should set editable false"
                    do: function() {
                        tableModel.editable = false;
                        return tableModel.isCellEditable(1, 0);
                    }
                    expect: equalTo(false);
                }
                Test {
                    say: "should set editable true"
                    do: function() {
                        tableModel.editable = true;
                        return tableModel.isCellEditable(1, 0);
                    }
                    expect: equalTo(true);
                }
                Test {
                    say: "should reflect model value"
                    do: function() {
                        sequence[1] = 9;
                        return tableModel.getValueAt(1, 0);
                    }
                    expect: equalTo(9 as Double);
                }
                Test {
                    say: "should update model value"
                    do: function() {
                        tableModel.setValueAt(7 as Double, 1, 0);
                        return sequence[1];
                    }
                    expect: equalTo(7 as Double)
                }
                Test {
                    say: "model update should trigger event"
                    do: function() {
                        eventCount = 0;
                        listenTo(tableModel);
                        tableModel.sequence[1] = 14;
                        return "eventCount: {eventCount}, source: {event.getSource()}, type: {event.getType()}, firstRow: {event.getFirstRow()}, lastRow: {event.getLastRow()}, column: {event.getColumn()}";
                    }
                    expect: equalTo("eventCount: 1, source: testTableModel, type: 0, firstRow: 1, lastRow: 1, column: -1");
                }
                Test {
                    say: "model insert should trigger event"
                    do: function() {
                        eventCount = 0;
                        listenTo(tableModel);
                        insert 15 into tableModel.sequence;
                        return "eventCount: {eventCount}, source: {event.getSource()}, type: {event.getType()}, firstRow: {event.getFirstRow()}, lastRow: {event.getLastRow()}, column: {event.getColumn()}";
                    }
                    expect: equalTo("eventCount: 1, source: testTableModel, type: 1, firstRow: 3, lastRow: 3, column: -1");
                }
                Test {
                    say: "model delete should trigger event"
                    do: function() {
                        eventCount = 0;
                        listenTo(tableModel);
                        delete tableModel.sequence[1] from tableModel.sequence;
                        return "eventCount: {eventCount}, source: {event.getSource()}, type: {event.getType()}, firstRow: {event.getFirstRow()}, lastRow: {event.getLastRow()}, column: {event.getColumn()}";
                    }
                    expect: equalTo("eventCount: 1, source: testTableModel, type: -1, firstRow: 1, lastRow: 1, column: -1");
                }
            ]
        }
        Test {
            var sequence:Float[] = [0, 1, 2];
            def tableModel = FloatSequenceTableModel {
                sequence: bind sequence with inverse
                override public function toString() {
                    return "testTableModel";
                }
            }

            say: "FloatSequenceTableModel"
            test: [
                Test {
                    say: "should return column count of 1"
                    do: function() {
                        return tableModel.getColumnCount();
                    }
                    expect: equalTo(1);
                }
                Test {
                    say: "should return float class"
                    do: function() {
                        return tableModel.getColumnClass(0).getName();
                    }
                    expect: equalTo("java.lang.Float");
                }
                Test {
                    say: "should set editable false"
                    do: function() {
                        tableModel.editable = false;
                        return tableModel.isCellEditable(1, 0);
                    }
                    expect: equalTo(false);
                }
                Test {
                    say: "should set editable true"
                    do: function() {
                        tableModel.editable = true;
                        return tableModel.isCellEditable(1, 0);
                    }
                    expect: equalTo(true);
                }
                Test {
                    say: "should reflect model value"
                    do: function() {
                        sequence[1] = 9;
                        return tableModel.getValueAt(1, 0);
                    }
                    expect: equalTo(9 as Float);
                }
                Test {
                    say: "should update model value"
                    do: function() {
                        tableModel.setValueAt(7 as Float, 1, 0);
                        return sequence[1];
                    }
                    expect: equalTo(7 as Float)
                }
                Test {
                    say: "model update should trigger event"
                    do: function() {
                        eventCount = 0;
                        listenTo(tableModel);
                        tableModel.sequence[1] = 14;
                        return "eventCount: {eventCount}, source: {event.getSource()}, type: {event.getType()}, firstRow: {event.getFirstRow()}, lastRow: {event.getLastRow()}, column: {event.getColumn()}";
                    }
                    expect: equalTo("eventCount: 1, source: testTableModel, type: 0, firstRow: 1, lastRow: 1, column: -1");
                }
                Test {
                    say: "model insert should trigger event"
                    do: function() {
                        eventCount = 0;
                        listenTo(tableModel);
                        insert 15 into tableModel.sequence;
                        return "eventCount: {eventCount}, source: {event.getSource()}, type: {event.getType()}, firstRow: {event.getFirstRow()}, lastRow: {event.getLastRow()}, column: {event.getColumn()}";
                    }
                    expect: equalTo("eventCount: 1, source: testTableModel, type: 1, firstRow: 3, lastRow: 3, column: -1");
                }
                Test {
                    say: "model delete should trigger event"
                    do: function() {
                        eventCount = 0;
                        listenTo(tableModel);
                        delete tableModel.sequence[1] from tableModel.sequence;
                        return "eventCount: {eventCount}, source: {event.getSource()}, type: {event.getType()}, firstRow: {event.getFirstRow()}, lastRow: {event.getLastRow()}, column: {event.getColumn()}";
                    }
                    expect: equalTo("eventCount: 1, source: testTableModel, type: -1, firstRow: 1, lastRow: 1, column: -1");
                }
            ]
        }
        Test {
            var sequence = [0, 1, 2];
            def tableModel = IntegerSequenceTableModel {
                sequence: bind sequence with inverse
                override public function toString() {
                    return "testTableModel";
                }
            }

            say: "IntegerSequenceTableModel"
            test: [
                Test {
                    say: "should return column count of 1"
                    do: function() {
                        return tableModel.getColumnCount();
                    }
                    expect: equalTo(1);
                }
                Test {
                    say: "should return integer class"
                    do: function() {
                        return tableModel.getColumnClass(0).getName();
                    }
                    expect: equalTo("java.lang.Integer");
                }
                Test {
                    say: "should set editable false"
                    do: function() {
                        tableModel.editable = false;
                        return tableModel.isCellEditable(1, 0);
                    }
                    expect: equalTo(false);
                }
                Test {
                    say: "should set editable true"
                    do: function() {
                        tableModel.editable = true;
                        return tableModel.isCellEditable(1, 0);
                    }
                    expect: equalTo(true);
                }
                Test {
                    say: "should reflect model value"
                    do: function() {
                        sequence[1] = 9;
                        return tableModel.getValueAt(1, 0);
                    }
                    expect: equalTo(9);
                }
                Test {
                    say: "should update model value"
                    do: function() {
                        tableModel.setValueAt(7, 1, 0);
                        return sequence[1];
                    }
                    expect: equalTo(7)
                }
                Test {
                    say: "model update should trigger event"
                    do: function() {
                        eventCount = 0;
                        listenTo(tableModel);
                        tableModel.sequence[1] = 14;
                        return "eventCount: {eventCount}, source: {event.getSource()}, type: {event.getType()}, firstRow: {event.getFirstRow()}, lastRow: {event.getLastRow()}, column: {event.getColumn()}";
                    }
                    expect: equalTo("eventCount: 1, source: testTableModel, type: 0, firstRow: 1, lastRow: 1, column: -1");
                }
                Test {
                    say: "model insert should trigger event"
                    do: function() {
                        eventCount = 0;
                        listenTo(tableModel);
                        insert 15 into tableModel.sequence;
                        return "eventCount: {eventCount}, source: {event.getSource()}, type: {event.getType()}, firstRow: {event.getFirstRow()}, lastRow: {event.getLastRow()}, column: {event.getColumn()}";
                    }
                    expect: equalTo("eventCount: 1, source: testTableModel, type: 1, firstRow: 3, lastRow: 3, column: -1");
                }
                Test {
                    say: "model delete should trigger event"
                    do: function() {
                        eventCount = 0;
                        listenTo(tableModel);
                        delete tableModel.sequence[1] from tableModel.sequence;
                        return "eventCount: {eventCount}, source: {event.getSource()}, type: {event.getType()}, firstRow: {event.getFirstRow()}, lastRow: {event.getLastRow()}, column: {event.getColumn()}";
                    }
                    expect: equalTo("eventCount: 1, source: testTableModel, type: -1, firstRow: 1, lastRow: 1, column: -1");
                }
            ]
        }
        Test {
            var sequence:Long[] = [0, 1, 2];
            def tableModel = LongSequenceTableModel {
                sequence: bind sequence with inverse
                override public function toString() {
                    return "testTableModel";
                }
            }

            say: "LongSequenceTableModel"
            test: [
                Test {
                    say: "should return column count of 1"
                    do: function() {
                        return tableModel.getColumnCount();
                    }
                    expect: equalTo(1);
                }
                Test {
                    say: "should return long class"
                    do: function() {
                        return tableModel.getColumnClass(0).getName();
                    }
                    expect: equalTo("java.lang.Long");
                }
                Test {
                    say: "should set editable false"
                    do: function() {
                        tableModel.editable = false;
                        return tableModel.isCellEditable(1, 0);
                    }
                    expect: equalTo(false);
                }
                Test {
                    say: "should set editable true"
                    do: function() {
                        tableModel.editable = true;
                        return tableModel.isCellEditable(1, 0);
                    }
                    expect: equalTo(true);
                }
                Test {
                    say: "should reflect model value"
                    do: function() {
                        sequence[1] = 9;
                        return tableModel.getValueAt(1, 0);
                    }
                    expect: equalTo(9 as Long);
                }
                Test {
                    say: "should update model value"
                    do: function() {
                        tableModel.setValueAt(7 as Long, 1, 0);
                        return sequence[1];
                    }
                    expect: equalTo(7 as Long);
                }
                Test {
                    say: "model update should trigger event"
                    do: function() {
                        eventCount = 0;
                        listenTo(tableModel);
                        tableModel.sequence[1] = 14;
                        return "eventCount: {eventCount}, source: {event.getSource()}, type: {event.getType()}, firstRow: {event.getFirstRow()}, lastRow: {event.getLastRow()}, column: {event.getColumn()}";
                    }
                    expect: equalTo("eventCount: 1, source: testTableModel, type: 0, firstRow: 1, lastRow: 1, column: -1");
                }
                Test {
                    say: "model insert should trigger event"
                    do: function() {
                        eventCount = 0;
                        listenTo(tableModel);
                        insert 15 into tableModel.sequence;
                        return "eventCount: {eventCount}, source: {event.getSource()}, type: {event.getType()}, firstRow: {event.getFirstRow()}, lastRow: {event.getLastRow()}, column: {event.getColumn()}";
                    }
                    expect: equalTo("eventCount: 1, source: testTableModel, type: 1, firstRow: 3, lastRow: 3, column: -1");
                }
                Test {
                    say: "model delete should trigger event"
                    do: function() {
                        eventCount = 0;
                        listenTo(tableModel);
                        delete tableModel.sequence[1] from tableModel.sequence;
                        return "eventCount: {eventCount}, source: {event.getSource()}, type: {event.getType()}, firstRow: {event.getFirstRow()}, lastRow: {event.getLastRow()}, column: {event.getColumn()}";
                    }
                    expect: equalTo("eventCount: 1, source: testTableModel, type: -1, firstRow: 1, lastRow: 1, column: -1");
                }
            ]
        }
        Test {
            var sequence:Short[] = [0, 1, 2];
            def tableModel = ShortSequenceTableModel {
                sequence: bind sequence with inverse
                override public function toString() {
                    return "testTableModel";
                }
            }

            say: "ShortSequenceTableModel"
            test: [
                Test {
                    say: "should return column count of 1"
                    do: function() {
                        return tableModel.getColumnCount();
                    }
                    expect: equalTo(1);
                }
                Test {
                    say: "should return short class"
                    do: function() {
                        return tableModel.getColumnClass(0).getName();
                    }
                    expect: equalTo("java.lang.Short");
                }
                Test {
                    say: "should set editable false"
                    do: function() {
                        tableModel.editable = false;
                        return tableModel.isCellEditable(1, 0);
                    }
                    expect: equalTo(false);
                }
                Test {
                    say: "should set editable true"
                    do: function() {
                        tableModel.editable = true;
                        return tableModel.isCellEditable(1, 0);
                    }
                    expect: equalTo(true);
                }
                Test {
                    say: "should reflect model value"
                    do: function() {
                        sequence[1] = 9;
                        return tableModel.getValueAt(1, 0);
                    }
                    expect: equalTo(9 as Short);
                }
                Test {
                    say: "should update model value"
                    do: function() {
                        tableModel.setValueAt(7 as Short, 1, 0);
                        return sequence[1];
                    }
                    expect: equalTo(7 as Short);
                }
                Test {
                    say: "model update should trigger event"
                    do: function() {
                        eventCount = 0;
                        listenTo(tableModel);
                        tableModel.sequence[1] = 14;
                        return "eventCount: {eventCount}, source: {event.getSource()}, type: {event.getType()}, firstRow: {event.getFirstRow()}, lastRow: {event.getLastRow()}, column: {event.getColumn()}";
                    }
                    expect: equalTo("eventCount: 1, source: testTableModel, type: 0, firstRow: 1, lastRow: 1, column: -1");
                }
                Test {
                    say: "model insert should trigger event"
                    do: function() {
                        eventCount = 0;
                        listenTo(tableModel);
                        insert 15 into tableModel.sequence;
                        return "eventCount: {eventCount}, source: {event.getSource()}, type: {event.getType()}, firstRow: {event.getFirstRow()}, lastRow: {event.getLastRow()}, column: {event.getColumn()}";
                    }
                    expect: equalTo("eventCount: 1, source: testTableModel, type: 1, firstRow: 3, lastRow: 3, column: -1");
                }
                Test {
                    say: "model delete should trigger event"
                    do: function() {
                        eventCount = 0;
                        listenTo(tableModel);
                        delete tableModel.sequence[1] from tableModel.sequence;
                        return "eventCount: {eventCount}, source: {event.getSource()}, type: {event.getType()}, firstRow: {event.getFirstRow()}, lastRow: {event.getLastRow()}, column: {event.getColumn()}";
                    }
                    expect: equalTo("eventCount: 1, source: testTableModel, type: -1, firstRow: 1, lastRow: 1, column: -1");
                }
            ]
        }
        Test {
            var sequence = ["0", "1", "2"];
            def tableModel = StringSequenceTableModel {
                sequence: bind sequence with inverse
                override public function toString() {
                    return "testTableModel";
                }
            }

            say: "StringSequenceTableModel"
            test: [
                Test {
                    say: "should return column count of 1"
                    do: function() {
                        return tableModel.getColumnCount();
                    }
                    expect: equalTo(1);
                }
                Test {
                    say: "should return string class"
                    do: function() {
                        return tableModel.getColumnClass(0).getName();
                    }
                    expect: equalTo("java.lang.String");
                }
                Test {
                    say: "should set editable false"
                    do: function() {
                        tableModel.editable = false;
                        return tableModel.isCellEditable(1, 0);
                    }
                    expect: equalTo(false);
                }
                Test {
                    say: "should set editable true"
                    do: function() {
                        tableModel.editable = true;
                        return tableModel.isCellEditable(1, 0);
                    }
                    expect: equalTo(true);
                }
                Test {
                    say: "should reflect model value"
                    do: function() {
                        sequence[1] = "9";
                        return tableModel.getValueAt(1, 0);
                    }
                    expect: equalTo("9");
                }
                Test {
                    say: "should update model value"
                    do: function() {
                        tableModel.setValueAt("7", 1, 0);
                        return sequence[1];
                    }
                    expect: equalTo("7");
                }
                Test {
                    say: "model update should trigger event"
                    do: function() {
                        eventCount = 0;
                        listenTo(tableModel);
                        tableModel.sequence[1] = "14";
                        return "eventCount: {eventCount}, source: {event.getSource()}, type: {event.getType()}, firstRow: {event.getFirstRow()}, lastRow: {event.getLastRow()}, column: {event.getColumn()}";
                    }
                    expect: equalTo("eventCount: 1, source: testTableModel, type: 0, firstRow: 1, lastRow: 1, column: -1");
                }
                Test {
                    say: "model insert should trigger event"
                    do: function() {
                        eventCount = 0;
                        listenTo(tableModel);
                        insert "15" into tableModel.sequence;
                        return "eventCount: {eventCount}, source: {event.getSource()}, type: {event.getType()}, firstRow: {event.getFirstRow()}, lastRow: {event.getLastRow()}, column: {event.getColumn()}";
                    }
                    expect: equalTo("eventCount: 1, source: testTableModel, type: 1, firstRow: 3, lastRow: 3, column: -1");
                }
                Test {
                    say: "model delete should trigger event"
                    do: function() {
                        eventCount = 0;
                        listenTo(tableModel);
                        delete tableModel.sequence[1] from tableModel.sequence;
                        return "eventCount: {eventCount}, source: {event.getSource()}, type: {event.getType()}, firstRow: {event.getFirstRow()}, lastRow: {event.getLastRow()}, column: {event.getColumn()}";
                    }
                    expect: equalTo("eventCount: 1, source: testTableModel, type: -1, firstRow: 1, lastRow: 1, column: -1");
                }
            ]
        }
    ]);
}
