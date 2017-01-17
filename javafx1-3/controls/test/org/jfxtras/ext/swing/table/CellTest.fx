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
import java.math.BigDecimal;
import java.math.BigInteger;
import org.jfxtras.ext.swing.table.*;
import org.jfxtras.test.*;
import org.jfxtras.test.Expect.*;

public class CellTest extends Test {}

class Model {
    var bigDecimal:BigDecimal;
    var bigInteger:BigInteger;
    var boolean:Boolean;
    var booleanObject:java.lang.Boolean;
    var byte:Byte;
    var byteObject:java.lang.Byte;
    var date:java.util.Date;
    var double:Double;
    var doubleObject:java.lang.Double;
    var float:Float;
    var floatObject:java.lang.Float;
    var integer:Integer;
    var integerObject:java.lang.Integer;
    var long:Long;
    var longObject:java.lang.Long;
    var short:Short;
    var shortObject:java.lang.Short;
    var string:String;
}

var tests:Test[];

public function addBigDecimalCellTest() {
    insert Test {
        def model = Model {
            bigDecimal: new BigDecimal("0");
        }
        def bigDecimalCell = BigDecimalCell {
            value: bind model.bigDecimal with inverse;
        }
        var updateValue:Object = null;
        var updateIndex:Integer = -1;
        def row = Row {
            cells: bigDecimalCell
            onChange: function(column:Integer) {
                updateValue = bigDecimalCell.getValue();
                updateIndex = column;
            }
        }

        say: "BigDecimalCell"
        test: [
            Test {
                say: "should return BigDecimal class"
                do: function() {
                    return bigDecimalCell.getColumnClass().getName()
                }
                expect: equalTo("java.math.BigDecimal");
            }
            Test {
                say: "should reflect model"
                do: function() {
                    return bigDecimalCell.getValue();
                }
                expect: equalTo(model.bigDecimal);
            }
            Test {
                say: "should update model"
                do: function() {
                    bigDecimalCell.setValue(new BigDecimal("1"));
                    return model.bigDecimal;
                }
                expect: equalTo(new BigDecimal("1"))
            }
            Test {
                say: "should handle null"
                do: function() {
                    bigDecimalCell.setValue(null);
                    return model.bigDecimal;
                }
                expect: equalTo(null)
            }
            Test {
                say: "should reflect model updates"
                do: function() {
                    model.bigDecimal = new BigDecimal("2");
                    return bigDecimalCell.getValue();
                }
                expect: equalTo(new BigDecimal("2"))
            }
            // todo 1.3 - This is broken in 1.3, but fixed in 1.3.1 (per http://javafx-jira.kenai.com/browse/JFXC-4295)
//            Test {
//                say: "should pass on model updates"
//                do: function() {
//                    model.bigDecimal = new BigDecimal("3");
//                    updateValue;
//                }
//                expect: equalTo(new BigDecimal("3"))
//            }
//            Test {
//                say: "should pass on model updates with correct index"
//                do: function() {
//                    model.bigDecimal = new BigDecimal("4");
//                    updateIndex;
//                }
//                expect: equalTo(0)
//            }
        ]
    } into tests;
}

public function addBigIntegerCellTest() {
    insert Test {
        def model = Model {
            bigInteger: new BigInteger("0");
        }
        def bigIntegerCell = BigIntegerCell {
            value: bind model.bigInteger with inverse;
        }
        var updateValue:Object = null;
        var updateIndex:Integer = -1;
        def row = Row {
            cells: bigIntegerCell
            onChange: function(column:Integer) {
                updateValue = bigIntegerCell.getValue();
                updateIndex = column;
            }
        }

        say: "BigIntegerCell"
        test: [
            Test {
                say: "should return BigInteger class"
                do: function() {
                    return bigIntegerCell.getColumnClass().getName()
                }
                expect: equalTo("java.math.BigInteger");
            }
            Test {
                say: "should reflect model"
                do: function() {
                    return bigIntegerCell.getValue();
                }
                expect: equalTo(model.bigInteger);
            }
            Test {
                say: "should update model"
                do: function() {
                    bigIntegerCell.setValue(new BigInteger("1"));
                    return model.bigInteger;
                }
                expect: equalTo(new BigInteger("1"))
            }
            Test {
                say: "should handle null"
                do: function() {
                    bigIntegerCell.setValue(null);
                    return model.bigInteger;
                }
                expect: equalTo(null)
            }
            Test {
                say: "should reflect model updates"
                do: function() {
                    model.bigInteger = new BigInteger("2");
                    return bigIntegerCell.getValue();
                }
                expect: equalTo(new BigInteger("2"))
            }
            // todo 1.3 - This is broken in 1.3, but fixed in 1.3.1 (per http://javafx-jira.kenai.com/browse/JFXC-4295)
//            Test {
//                say: "should pass on model updates"
//                do: function() {
//                    model.bigInteger = new BigInteger("3");
//                    updateValue;
//                }
//                expect: equalTo(new BigInteger("3"))
//            }
//            Test {
//                say: "should pass on model updates with correct index"
//                do: function() {
//                    model.bigInteger = new BigInteger("4");
//                    updateIndex;
//                }
//                expect: equalTo(0)
//            }
        ]
    } into tests;
}

public function addBooleanCellTest() {
    insert Test {
        def model = Model {
            boolean: true
        }
        def booleanCell = BooleanCell {
            value: bind model.boolean with inverse;
        }
        var updateValue:Object = null;
        var updateIndex:Integer = -1;
        def row = Row {
            cells: booleanCell
            onChange: function(column:Integer) {
                updateValue = booleanCell.getValue();
                updateIndex = column;
            }
        }

        say: "BooleanCell"
        test: [
            Test {
                say: "should return boolean class"
                do: function() {
                    return booleanCell.getColumnClass().getName()
                }
                expect: equalTo("java.lang.Boolean");
            }
            Test {
                say: "should reflect model"
                do: function() {
                    return booleanCell.getValue();
                }
                expect: equalTo(model.boolean);
            }
            Test {
                say: "should update model"
                do: function() {
                    booleanCell.setValue(false);
                    return model.boolean;
                }
                expect: equalTo(false)
            }
            Test {
                say: "should handle null"
                do: function() {
                    booleanCell.setValue(null);
                    return model.boolean;
                }
                expect: equalTo(false)
            }
            Test {
                say: "should reflect model updates"
                do: function() {
                    model.boolean = true;
                    return booleanCell.getValue();
                }
                expect: equalTo(true)
            }
            // todo 1.3 - This is broken in 1.3, but fixed in 1.3.1 (per http://javafx-jira.kenai.com/browse/JFXC-4295)
//            Test {
//                say: "should pass on model updates"
//                do: function() {
//                    model.boolean = true;
//                    updateValue;
//                }
//                expect: equalTo(true)
//            }
//            Test {
//                say: "should pass on model updates with correct index"
//                do: function() {
//                    model.boolean = true;
//                    updateIndex;
//                }
//                expect: equalTo(0)
//            }
        ]
    } into tests;
}

public function addBooleanObjectCellTest() {
    insert Test {
        def model = Model {
            booleanObject: true
        }
        def booleanObjectCell = BooleanObjectCell {
            value: bind model.booleanObject with inverse;
        }
        var updateValue:Object = null;
        var updateIndex:Integer = -1;
        def row = Row {
            cells: booleanObjectCell
            onChange: function(column:Integer) {
                updateValue = booleanObjectCell.getValue();
                updateIndex = column;
            }
        }

        say: "BooleanObjectCell"
        test: [
            Test {
                say: "should return boolean class"
                do: function() {
                    return booleanObjectCell.getColumnClass().getName()
                }
                expect: equalTo("java.lang.Boolean");
            }
            Test {
                say: "should reflect model"
                do: function() {
                    return booleanObjectCell.getValue();
                }
                expect: equalTo(model.booleanObject);
            }
            Test {
                say: "should update model"
                do: function() {
                    booleanObjectCell.setValue(false);
                    return model.booleanObject;
                }
                expect: equalTo(false)
            }
            Test {
                say: "should handle null"
                do: function() {
                    booleanObjectCell.setValue(null);
                    return model.booleanObject;
                }
                expect: equalTo(null)
            }
            Test {
                say: "should reflect model updates"
                do: function() {
                    model.booleanObject = true;
                    return booleanObjectCell.getValue();
                }
                expect: equalTo(true)
            }
            // todo 1.3 - This is broken in 1.3, but fixed in 1.3.1 (per http://javafx-jira.kenai.com/browse/JFXC-4295)
//            Test {
//                say: "should pass on model updates"
//                do: function() {
//                    model.booleanObject = true;
//                    updateValue;
//                }
//                expect: equalTo(true)
//            }
//            Test {
//                say: "should pass on model updates with correct index"
//                do: function() {
//                    model.booleanObject = true;
//                    updateIndex;
//                }
//                expect: equalTo(0)
//            }
        ]
    } into tests;
}

public function addByteCellTest() {
    insert Test {
        def model = Model {
            byte: 0
        }
        def byteCell = ByteCell {
            value: bind model.byte with inverse;
        }
        var updateValue:Object = null;
        var updateIndex:Integer = -1;
        def row = Row {
            cells: byteCell
            onChange: function(column:Integer) {
                updateValue = byteCell.getValue();
                updateIndex = column;
            }
        }

        say: "ByteCell"
        test: [
            Test {
                say: "should return byte class"
                do: function() {
                    return byteCell.getColumnClass().getName()
                }
                expect: equalTo("java.lang.Byte");
            }
            Test {
                say: "should reflect model"
                do: function() {
                    return byteCell.getValue();
                }
                expect: equalTo(model.byte);
            }
            Test {
                say: "should update model"
                do: function() {
                    byteCell.setValue(1 as Byte);
                    return model.byte;
                }
                expect: equalTo(1 as Byte)
            }
            Test {
                say: "should handle null"
                do: function() {
                    byteCell.setValue(null);
                    return model.byte;
                }
                expect: equalTo(0 as Byte)
            }
            Test {
                say: "should reflect model updates"
                do: function() {
                    model.byte = 2;
                    return byteCell.getValue();
                }
                expect: equalTo(2 as Byte)
            }
            // todo 1.3 - This is broken in 1.3, but fixed in 1.3.1 (per http://javafx-jira.kenai.com/browse/JFXC-4295)
//            Test {
//                say: "should pass on model updates"
//                do: function() {
//                    model.byte = 3;
//                    updateValue;
//                }
//                expect: equalTo(3 as Byte)
//            }
//            Test {
//                say: "should pass on model updates with correct index"
//                do: function() {
//                    model.byte = 4;
//                    updateIndex;
//                }
//                expect: equalTo(0)
//            }
        ]
    } into tests;
}

public function addByteObjectCellTest() {
    insert Test {
        def model = Model {
            byteObject: 0
        }
        def byteObjectCell = ByteObjectCell {
            value: bind model.byteObject with inverse;
        }
        var updateValue:Object = null;
        var updateIndex:Integer = -1;
        def row = Row {
            cells: byteObjectCell
            onChange: function(column:Integer) {
                updateValue = byteObjectCell.getValue();
                updateIndex = column;
            }
        }

        say: "ByteObjectCell"
        test: [
            Test {
                say: "should return byte class"
                do: function() {
                    return byteObjectCell.getColumnClass().getName()
                }
                expect: equalTo("java.lang.Byte");
            }
            Test {
                say: "should reflect model"
                do: function() {
                    return byteObjectCell.getValue();
                }
                expect: equalTo(model.byteObject);
            }
            Test {
                say: "should update model"
                do: function() {
                    byteObjectCell.setValue(1 as Byte);
                    return model.byteObject;
                }
                expect: equalTo(1 as Byte)
            }
            Test {
                say: "should handle null"
                do: function() {
                    byteObjectCell.setValue(null);
                    return model.byteObject;
                }
                expect: equalTo(null)
            }
            Test {
                say: "should reflect model updates"
                do: function() {
                    model.byteObject = 2;
                    return byteObjectCell.getValue();
                }
                expect: equalTo(2 as Byte)
            }
            // todo 1.3 - This is broken in 1.3, but fixed in 1.3.1 (per http://javafx-jira.kenai.com/browse/JFXC-4295)
//            Test {
//                say: "should pass on model updates"
//                do: function() {
//                    model.byteObject = 3;
//                    updateValue;
//                }
//                expect: equalTo(3 as Byte)
//            }
//            Test {
//                say: "should pass on model updates with correct index"
//                do: function() {
//                    model.byteObject = 4;
//                    updateIndex;
//                }
//                expect: equalTo(0)
//            }
        ]
    } into tests;
}

public function addDateCellTest() {
    insert Test {
        def model = Model {
            date: new java.util.Date()
        }
        def dateCell = DateCell {
            value: bind model.date with inverse;
        }
        var updateValue:Object = null;
        var updateIndex:Integer = -1;
        def row = Row {
            cells: dateCell
            onChange: function(column:Integer) {
                updateValue = dateCell.getValue();
                updateIndex = column;
            }
        }
        def date1 = new java.util.Date();
        def date2 = new java.util.Date(date1.getTime() + 1000);
        def date3 = new java.util.Date(date2.getTime() + 1000);
        def date4 = new java.util.Date(date3.getTime() + 1000);

        say: "DateCell"
        test: [
            Test {
                say: "should return date class"
                do: function() {
                    return dateCell.getColumnClass().getName()
                }
                expect: equalTo("java.util.Date");
            }
            Test {
                say: "should reflect model"
                do: function() {
                    return dateCell.getValue();
                }
                expect: equalTo(model.date);
            }
            Test {
                say: "should update model"
                do: function() {
                    dateCell.setValue(date1);
                    return model.date;
                }
                expect: equalTo(date1)
            }
            Test {
                say: "should handle null"
                do: function() {
                    dateCell.setValue(null);
                    return model.date;
                }
                expect: equalTo(null)
            }
            Test {
                say: "should reflect model updates"
                do: function() {
                    model.date = date2;
                    return dateCell.getValue();
                }
                expect: equalTo(date2)
            }
            // todo 1.3 - This is broken in 1.3, but fixed in 1.3.1 (per http://javafx-jira.kenai.com/browse/JFXC-4295)
//            Test {
//                say: "should pass on model updates"
//                do: function() {
//                    model.date = date3;
//                    updateValue;
//                }
//                expect: equalTo(date3)
//            }
//            Test {
//                say: "should pass on model updates with correct index"
//                do: function() {
//                    model.date = date4;
//                    updateIndex;
//                }
//                expect: equalTo(0)
//            }
        ]
    } into tests;
}

public function addDoubleCellTest() {
    insert Test {
        def model = Model {
            double: 0
        }
        def doubleCell = DoubleCell {
            value: bind model.double with inverse;
        }
        var updateValue:Object = null;
        var updateIndex:Integer = -1;
        def row = Row {
            cells: doubleCell
            onChange: function(column:Integer) {
                updateValue = doubleCell.getValue();
                updateIndex = column;
            }
        }

        say: "DoubleCell"
        test: [
            Test {
                say: "should return double class"
                do: function() {
                    return doubleCell.getColumnClass().getName()
                }
                expect: equalTo("java.lang.Double");
            }
            Test {
                say: "should reflect model"
                do: function() {
                    return doubleCell.getValue();
                }
                expect: equalTo(model.double);
            }
            Test {
                say: "should update model"
                do: function() {
                    doubleCell.setValue(1 as Double);
                    return model.double;
                }
                expect: equalTo(1 as Double)
            }
            Test {
                say: "should handle null"
                do: function() {
                    doubleCell.setValue(null);
                    return model.double;
                }
                expect: equalTo(0 as Double)
            }
            Test {
                say: "should reflect model updates"
                do: function() {
                    model.double = 2;
                    return doubleCell.getValue();
                }
                expect: equalTo(2 as Double)
            }
            // todo 1.3 - This is broken in 1.3, but fixed in 1.3.1 (per http://javafx-jira.kenai.com/browse/JFXC-4295)
//            Test {
//                say: "should pass on model updates"
//                do: function() {
//                    model.double = 3;
//                    updateValue;
//                }
//                expect: equalTo(3 as Double)
//            }
//            Test {
//                say: "should pass on model updates with correct index"
//                do: function() {
//                    model.double = 4;
//                    updateIndex;
//                }
//                expect: equalTo(0)
//            }
        ]
    } into tests;
}

public function addDoubleObjectCellTest() {
    insert Test {
        def model = Model {
            doubleObject: 0
        }
        def doubleObjectCell = DoubleObjectCell {
            value: bind model.doubleObject with inverse;
        }
        var updateValue:Object = null;
        var updateIndex:Integer = -1;
        def row = Row {
            cells: doubleObjectCell
            onChange: function(column:Integer) {
                updateValue = doubleObjectCell.getValue();
                updateIndex = column;
            }
        }

        say: "DoubleObjectCell"
        test: [
            Test {
                say: "should return double class"
                do: function() {
                    return doubleObjectCell.getColumnClass().getName()
                }
                expect: equalTo("java.lang.Double");
            }
            Test {
                say: "should reflect model"
                do: function() {
                    return doubleObjectCell.getValue();
                }
                expect: equalTo(model.doubleObject);
            }
            Test {
                say: "should update model"
                do: function() {
                    doubleObjectCell.setValue(1 as Double);
                    return model.doubleObject;
                }
                expect: equalTo(1 as Double)
            }
            Test {
                say: "should handle null"
                do: function() {
                    doubleObjectCell.setValue(null);
                    return model.doubleObject;
                }
                expect: equalTo(null)
            }
            Test {
                say: "should reflect model updates"
                do: function() {
                    model.doubleObject = 2;
                    return doubleObjectCell.getValue();
                }
                expect: equalTo(2 as Double)
            }
            // todo 1.3 - This is broken in 1.3, but fixed in 1.3.1 (per http://javafx-jira.kenai.com/browse/JFXC-4295)
//            Test {
//                say: "should pass on model updates"
//                do: function() {
//                    model.doubleObject = 3;
//                    updateValue;
//                }
//                expect: equalTo(3 as Double)
//            }
//            Test {
//                say: "should pass on model updates with correct index"
//                do: function() {
//                    model.doubleObject = 4;
//                    updateIndex;
//                }
//                expect: equalTo(0)
//            }
        ]
    } into tests;
}

public function addFloatCellTest() {
    insert Test {
        def model = Model {
            float: 0
        }
        def floatCell = FloatCell {
            value: bind model.float with inverse;
        }
        var updateValue:Object = null;
        var updateIndex:Integer = -1;
        def row = Row {
            cells: floatCell
            onChange: function(column:Integer) {
                updateValue = floatCell.getValue();
                updateIndex = column;
            }
        }

        say: "FloatCell"
        test: [
            Test {
                say: "should return float class"
                do: function() {
                    return floatCell.getColumnClass().getName()
                }
                expect: equalTo("java.lang.Float");
            }
            Test {
                say: "should reflect model"
                do: function() {
                    return floatCell.getValue();
                }
                expect: equalTo(model.float);
            }
            Test {
                say: "should update model"
                do: function() {
                    floatCell.setValue(1 as Float);
                    return model.float;
                }
                expect: equalTo(1 as Float)
            }
            Test {
                say: "should handle null"
                do: function() {
                    floatCell.setValue(null);
                    return model.float;
                }
                expect: equalTo(0 as Float)
            }
            Test {
                say: "should reflect model updates"
                do: function() {
                    model.float = 2;
                    return floatCell.getValue();
                }
                expect: equalTo(2 as Float)
            }
            // todo 1.3 - This is broken in 1.3, but fixed in 1.3.1 (per http://javafx-jira.kenai.com/browse/JFXC-4295)
//            Test {
//                say: "should pass on model updates"
//                do: function() {
//                    model.float = 3;
//                    updateValue;
//                }
//                expect: equalTo(3 as Float)
//            }
//            Test {
//                say: "should pass on model updates with correct index"
//                do: function() {
//                    model.float = 4;
//                    updateIndex;
//                }
//                expect: equalTo(0)
//            }
        ]
    } into tests;
}

public function addFloatObjectCellTest() {
    insert Test {
        def model = Model {
            floatObject: 0
        }
        def floatObjectCell = FloatObjectCell {
            value: bind model.floatObject with inverse;
        }
        var updateValue:Object = null;
        var updateIndex:Integer = -1;
        def row = Row {
            cells: floatObjectCell
            onChange: function(column:Integer) {
                updateValue = floatObjectCell.getValue();
                updateIndex = column;
            }
        }

        say: "FloatObjectCell"
        test: [
            Test {
                say: "should return float class"
                do: function() {
                    return floatObjectCell.getColumnClass().getName()
                }
                expect: equalTo("java.lang.Float");
            }
            Test {
                say: "should reflect model"
                do: function() {
                    return floatObjectCell.getValue();
                }
                expect: equalTo(model.floatObject);
            }
            Test {
                say: "should update model"
                do: function() {
                    floatObjectCell.setValue(1 as Float);
                    return model.floatObject;
                }
                expect: equalTo(1 as Float)
            }
            Test {
                say: "should handle null"
                do: function() {
                    floatObjectCell.setValue(null);
                    return model.floatObject;
                }
                expect: equalTo(null)
            }
            Test {
                say: "should reflect model updates"
                do: function() {
                    model.floatObject = 2;
                    return floatObjectCell.getValue();
                }
                expect: equalTo(2 as Float)
            }
            // todo 1.3 - This is broken in 1.3, but fixed in 1.3.1 (per http://javafx-jira.kenai.com/browse/JFXC-4295)
//            Test {
//                say: "should pass on model updates"
//                do: function() {
//                    model.floatObject = 3;
//                    updateValue;
//                }
//                expect: equalTo(3 as Float)
//            }
//            Test {
//                say: "should pass on model updates with correct index"
//                do: function() {
//                    model.floatObject = 4;
//                    updateIndex;
//                }
//                expect: equalTo(0)
//            }
        ]
    } into tests;
}

public function addIntegerCellTest() {
    insert Test {
        def model = Model {
            integer: 0
        }
        def integerCell = IntegerCell {
            value: bind model.integer with inverse;
        }
        var updateValue:Object = null;
        var updateIndex:Integer = -1;
        def row = Row {
            cells: integerCell
            onChange: function(column:Integer) {
                updateValue = integerCell.getValue();
                updateIndex = column;
            }
        }

        say: "IntegerCell"
        test: [
            Test {
                say: "should return integer class"
                do: function() {
                    return integerCell.getColumnClass().getName()
                }
                expect: equalTo("java.lang.Integer");
            }
            Test {
                say: "should reflect model"
                do: function() {
                    return integerCell.getValue();
                }
                expect: equalTo(model.integer);
            }
            Test {
                say: "should update model"
                do: function() {
                    integerCell.setValue(1);
                    return model.integer;
                }
                expect: equalTo(1)
            }
            Test {
                say: "should handle null"
                do: function() {
                    integerCell.setValue(null);
                    return model.integer;
                }
                expect: equalTo(0)
            }
            Test {
                say: "should reflect model updates"
                do: function() {
                    model.integer = 2;
                    return integerCell.getValue();
                }
                expect: equalTo(2)
            }
            // todo 1.3 - This is broken in 1.3, but fixed in 1.3.1 (per http://javafx-jira.kenai.com/browse/JFXC-4295)
//            Test {
//                say: "should pass on model updates"
//                do: function() {
//                    model.integer = 3;
//                    updateValue;
//                }
//                expect: equalTo(3)
//            }
//            Test {
//                say: "should pass on model updates with correct index"
//                do: function() {
//                    model.integer = 4;
//                    updateIndex;
//                }
//                expect: equalTo(0)
//            }
        ]
    } into tests;
}

public function addIntegerObjectCellTest() {
    insert Test {
        def model = Model {
            integerObject: 0
        }
        def integerObjectCell = IntegerObjectCell {
            value: bind model.integerObject with inverse;
        }
        var updateValue:Object = null;
        var updateIndex:Integer = -1;
        def row = Row {
            cells: integerObjectCell
            onChange: function(column:Integer) {
                updateValue = integerObjectCell.getValue();
                updateIndex = column;
            }
        }

        say: "IntegerObjectCell"
        test: [
            Test {
                say: "should return integer class"
                do: function() {
                    return integerObjectCell.getColumnClass().getName()
                }
                expect: equalTo("java.lang.Integer");
            }
            Test {
                say: "should reflect model"
                do: function() {
                    return integerObjectCell.getValue();
                }
                expect: equalTo(model.integerObject);
            }
            Test {
                say: "should update model"
                do: function() {
                    integerObjectCell.setValue(1);
                    return model.integerObject;
                }
                expect: equalTo(1)
            }
            Test {
                say: "should handle null"
                do: function() {
                    integerObjectCell.setValue(null);
                    return model.integerObject;
                }
                expect: equalTo(null)
            }
            Test {
                say: "should reflect model updates"
                do: function() {
                    model.integerObject = 2;
                    return integerObjectCell.getValue();
                }
                expect: equalTo(2)
            }
            // todo 1.3 - This is broken in 1.3, but fixed in 1.3.1 (per http://javafx-jira.kenai.com/browse/JFXC-4295)
//            Test {
//                say: "should pass on model updates"
//                do: function() {
//                    model.integerObject = 3;
//                    updateValue;
//                }
//                expect: equalTo(3)
//            }
//            Test {
//                say: "should pass on model updates with correct index"
//                do: function() {
//                    model.integerObject = 4;
//                    updateIndex;
//                }
//                expect: equalTo(0)
//            }
        ]
    } into tests;
}

public function addLongCellTest() {
    insert Test {
        def model = Model {
            long: 0
        }
        def longCell = LongCell {
            value: bind model.long with inverse;
        }
        var updateValue:Object = null;
        var updateIndex:Integer = -1;
        def row = Row {
            cells: longCell
            onChange: function(column:Integer) {
                updateValue = longCell.getValue();
                updateIndex = column;
            }
        }

        say: "LongCell"
        test: [
            Test {
                say: "should return long class"
                do: function() {
                    return longCell.getColumnClass().getName()
                }
                expect: equalTo("java.lang.Long");
            }
            Test {
                say: "should reflect model"
                do: function() {
                    return longCell.getValue();
                }
                expect: equalTo(model.long);
            }
            Test {
                say: "should update model"
                do: function() {
                    longCell.setValue(1 as Long);
                    return model.long;
                }
                expect: equalTo(1 as Long)
            }
            Test {
                say: "should handle null"
                do: function() {
                    longCell.setValue(null);
                    return model.long;
                }
                expect: equalTo(0 as Long)
            }
            Test {
                say: "should reflect model updates"
                do: function() {
                    model.long = 2;
                    return longCell.getValue();
                }
                expect: equalTo(2 as Long)
            }
            // todo 1.3 - This is broken in 1.3, but fixed in 1.3.1 (per http://javafx-jira.kenai.com/browse/JFXC-4295)
//            Test {
//                say: "should pass on model updates"
//                do: function() {
//                    model.long = 3;
//                    updateValue;
//                }
//                expect: equalTo(3 as Long)
//            }
//            Test {
//                say: "should pass on model updates with correct index"
//                do: function() {
//                    model.long = 4;
//                    updateIndex;
//                }
//                expect: equalTo(0)
//            }
        ]
    } into tests;
}

public function addLongObjectCellTest() {
    insert Test {
        def model = Model {
            longObject: 0
        }
        def longObjectCell = LongObjectCell {
            value: bind model.longObject with inverse;
        }
        var updateValue:Object = null;
        var updateIndex:Integer = -1;
        def row = Row {
            cells: longObjectCell
            onChange: function(column:Integer) {
                updateValue = longObjectCell.getValue();
                updateIndex = column;
            }
        }

        say: "LongObjectCell"
        test: [
            Test {
                say: "should return long class"
                do: function() {
                    return longObjectCell.getColumnClass().getName()
                }
                expect: equalTo("java.lang.Long");
            }
            Test {
                say: "should reflect model"
                do: function() {
                    return longObjectCell.getValue();
                }
                expect: equalTo(model.longObject);
            }
            Test {
                say: "should update model"
                do: function() {
                    longObjectCell.setValue(1 as Long);
                    return model.longObject;
                }
                expect: equalTo(1 as Long)
            }
            Test {
                say: "should handle null"
                do: function() {
                    longObjectCell.setValue(null);
                    return model.longObject;
                }
                expect: equalTo(null)
            }
            Test {
                say: "should reflect model updates"
                do: function() {
                    model.longObject = 2;
                    return longObjectCell.getValue();
                }
                expect: equalTo(2 as Long)
            }
            // todo 1.3 - This is broken in 1.3, but fixed in 1.3.1 (per http://javafx-jira.kenai.com/browse/JFXC-4295)
//            Test {
//                say: "should pass on model updates"
//                do: function() {
//                    model.longObject = 3;
//                    updateValue;
//                }
//                expect: equalTo(3 as Long)
//            }
//            Test {
//                say: "should pass on model updates with correct index"
//                do: function() {
//                    model.longObject = 4;
//                    updateIndex;
//                }
//                expect: equalTo(0)
//            }
        ]
    } into tests;
}

public function addShortCellTest() {
    insert Test {
        def model = Model {
            short: 0
        }
        def shortCell = ShortCell {
            value: bind model.short with inverse;
        }
        var updateValue:Object = null;
        var updateIndex:Integer = -1;
        def row = Row {
            cells: shortCell
            onChange: function(column:Integer) {
                updateValue = shortCell.getValue();
                updateIndex = column;
            }
        }

        say: "ShortCell"
        test: [
            Test {
                say: "should return short class"
                do: function() {
                    return shortCell.getColumnClass().getName()
                }
                expect: equalTo("java.lang.Short");
            }
            Test {
                say: "should reflect model"
                do: function() {
                    return shortCell.getValue();
                }
                expect: equalTo(model.short);
            }
            Test {
                say: "should update model"
                do: function() {
                    shortCell.setValue(1 as Short);
                    return model.short;
                }
                expect: equalTo(1 as Short)
            }
            Test {
                say: "should handle null"
                do: function() {
                    shortCell.setValue(null);
                    return model.short;
                }
                expect: equalTo(0 as Short)
            }
            Test {
                say: "should reflect model updates"
                do: function() {
                    model.short = 2;
                    return shortCell.getValue();
                }
                expect: equalTo(2 as Short)
            }
            // todo 1.3 - This is broken in 1.3, but fixed in 1.3.1 (per http://javafx-jira.kenai.com/browse/JFXC-4295)
//            Test {
//                say: "should pass on model updates"
//                do: function() {
//                    model.short = 3;
//                    updateValue;
//                }
//                expect: equalTo(3 as Short)
//            }
//            Test {
//                say: "should pass on model updates with correct index"
//                do: function() {
//                    model.short = 4;
//                    updateIndex;
//                }
//                expect: equalTo(0)
//            }
        ]
    } into tests;
}

public function addShortObjectCellTest() {
    insert Test {
        def model = Model {
            shortObject: 0
        }
        def shortObjectCell = ShortObjectCell {
            value: bind model.shortObject with inverse;
        }
        var updateValue:Object = null;
        var updateIndex:Integer = -1;
        def row = Row {
            cells: shortObjectCell
            onChange: function(column:Integer) {
                updateValue = shortObjectCell.getValue();
                updateIndex = column;
            }
        }

        say: "ShortObjectCell"
        test: [
            Test {
                say: "should return short class"
                do: function() {
                    return shortObjectCell.getColumnClass().getName()
                }
                expect: equalTo("java.lang.Short");
            }
            Test {
                say: "should reflect model"
                do: function() {
                    return shortObjectCell.getValue();
                }
                expect: equalTo(model.shortObject);
            }
            Test {
                say: "should update model"
                do: function() {
                    shortObjectCell.setValue(1 as Short);
                    return model.shortObject;
                }
                expect: equalTo(1 as Short)
            }
            Test {
                say: "should handle null"
                do: function() {
                    shortObjectCell.setValue(null);
                    return model.shortObject;
                }
                expect: equalTo(null)
            }
            Test {
                say: "should reflect model updates"
                do: function() {
                    model.shortObject = 2;
                    return shortObjectCell.getValue();
                }
                expect: equalTo(2 as Short)
            }
            // todo 1.3 - This is broken in 1.3, but fixed in 1.3.1 (per http://javafx-jira.kenai.com/browse/JFXC-4295)
//            Test {
//                say: "should pass on model updates"
//                do: function() {
//                    model.shortObject = 3;
//                    updateValue;
//                }
//                expect: equalTo(3 as Short)
//            }
//            Test {
//                say: "should pass on model updates with correct index"
//                do: function() {
//                    model.shortObject = 4;
//                    updateIndex;
//                }
//                expect: equalTo(0)
//            }
        ]
    } into tests;
}

public function addStringObjectCellTest() {
    insert Test {
        def model = Model {
            string: "0"
        }
        def stringCell = StringCell {
            value: bind model.string with inverse;
        }
        var updateValue:Object = null;
        var updateIndex:Integer = -1;
        def row = Row {
            cells: stringCell
            onChange: function(column:Integer) {
                updateValue = stringCell.getValue();
                updateIndex = column;
            }
        }

        say: "StringObjectCell"
        test: [
            Test {
                say: "should return string class"
                do: function() {
                    return stringCell.getColumnClass().getName()
                }
                expect: equalTo("java.lang.String");
            }
            Test {
                say: "should reflect model"
                do: function() {
                    return stringCell.getValue();
                }
                expect: equalTo(model.string);
            }
            Test {
                say: "should update model"
                do: function() {
                    stringCell.setValue("1");
                    return model.string;
                }
                expect: equalTo("1")
            }
            Test {
                say: "should handle null"
                do: function() {
                    stringCell.setValue(null);
                    return model.string;
                }
                expect: equalTo("")
            }
            Test {
                say: "should reflect model updates"
                do: function() {
                    model.string = "2";
                    return stringCell.getValue();
                }
                expect: equalTo("2")
            }
            // todo 1.3 - This is broken in 1.3, but fixed in 1.3.1 (per http://javafx-jira.kenai.com/browse/JFXC-4295)
//            Test {
//                say: "should pass on model updates"
//                do: function() {
//                    model.string = "3";
//                    updateValue;
//                }
//                expect: equalTo("3")
//            }
//            Test {
//                say: "should pass on model updates with correct index"
//                do: function() {
//                    model.string = "4";
//                    updateIndex;
//                }
//                expect: equalTo(0)
//            }
        ]
    } into tests;
}

public function run() {
    addBigDecimalCellTest();
    addBigIntegerCellTest();
    addBooleanCellTest();
    addBooleanObjectCellTest();
    addByteCellTest();
    addByteObjectCellTest();
    addDateCellTest();
    addDoubleCellTest();
    addDoubleObjectCellTest();
    addFloatCellTest();
    addFloatObjectCellTest();
    addIntegerCellTest();
    addIntegerObjectCellTest();
    addLongCellTest();
    addLongObjectCellTest();
    addShortCellTest();
    addShortObjectCellTest();
    addStringObjectCellTest();
    perform(tests);
}
