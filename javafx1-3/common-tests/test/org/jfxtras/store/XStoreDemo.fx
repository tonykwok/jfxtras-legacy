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
package org.jfxtras.store;

import javafx.stage.Stage;
import javafx.scene.control.Button;
import javafx.scene.control.CheckBox;
import javafx.scene.control.ListView;
import javafx.scene.control.Slider;
import javafx.scene.control.TextBox;
import javafx.scene.text.Text;
import org.jfxtras.scene.XScene;
import org.jfxtras.scene.layout.XGrid;
import org.jfxtras.scene.layout.XGridLayoutInfo;
import org.jfxtras.scene.layout.XGridLayoutInfo.*;

/**
 * @author David Armitage
 * @author Stephen Chin
 */
var floatTest:Float;
var stageX:Integer on replace {tFloat.text = "{stageX}"; stage.x = stageX;}
var boolTest:Boolean;
var stringTest:String;
var durTest:Duration on replace {tDuration.text = "{durTest.toMillis()}"}

var store1 = XStore {
    name: "TestStore1"
    saveOnExit: true
    content: [
        XStoreFloat {name: "mfSet", default: 1, value: bind floatTest with inverse, autoSave: true},
        XStoreInteger {name: "stageX", default: 300, value: bind stageX with inverse},
        XStoreBoolean {name: "boolTest", default: true, value: bind boolTest with inverse},
        XStoreString {name: "stringTest", default: "Hello", value: bind stringTest with inverse},
        XStoreDuration {name: "durTest", default: 30s, value: bind durTest with inverse},
    ]
}

var integerSeq: Integer[];
var floatSeq: Float[];
var boolSeq: Boolean[];
var stringSeq: String[];
var durSeq: Duration[];

var store2 = XStore {
    name: "TestStore2"
    saveOnExit: true
    content: [
        XStoreIntegerSeq {name: "integerSeq", default: [1, 3, 5], value: bind integerSeq with inverse},
        XStoreFloatSeq {name: "floatSeq", default: [1.0, 3.0, 5.0], value: bind floatSeq with inverse},
        XStoreBooleanSeq {name: "boolSeq", default: [true, false, true, false], value: bind boolSeq with inverse},
        XStoreStringSeq {name: "stringSeq", default: ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"], value: bind stringSeq with inverse},
        XStoreDurationSeq {name: "durSeq", default: [1s, 5s, 10s, 30s, 1m, 10m, 30m, 1h, 6h, 12h], value: bind durSeq with inverse},
    ]
}

// Complexity from here down due to UI - not Store :-)

var stage:Stage;
def x = bind stage.x on replace {stageX = stage.x as Integer};

var slider = Slider {value: bind floatTest with inverse, layoutInfo: XGridLayoutInfo {hspan: 2}}
def tSlider = TextBox {text: bind "{floatTest}", editable: false}
var tFloat:TextBox = TextBox {text: "{stageX}", action: function() {stageX = Integer.parseInt(tFloat.text)}}
var tBoolean = CheckBox {selected: bind boolTest with inverse}
var tString = TextBox {text: bind stringTest with inverse}
var tDuration:TextBox = TextBox {text: "{durTest.toMillis()}", action: function() {durTest = Duration.valueOf(Double.parseDouble(tDuration.text))}}
var lv:ListView = ListView {
    layoutInfo: XGridLayoutInfo {height: 100}
    items: ["mfSet", "stageX", "boolTest", "stringTest", "durTest"]
    onMouseClicked: function(e){ store1.reset(lv.selectedItem.toString())}
}

function run() {
    stage = Stage {
        title: "XStore Application Info"
        x: stageX
        width: 480
        height: 450
        scene: XScene {
            content: XGrid {
                spanToRowEnd: true
                layoutInfo: XGridLayoutInfo {margin: insets(10)}
                rows: [
                    row([Text {content: "floatTest (autoSaved)"}, Text {content: "Float"}, slider, tSlider]),
                    row([Text {content: "stageX"}, Text {content: "Integer"}, tFloat]),
                    row([Text {content: "boolTest"}, Text {content: "Boolean"}, tBoolean]),
                    row([Text {content: "stringTest"}, Text {content: "String"}, tString]),
                    row([Text {content: "durTest"}, Text {content: "Duration"}, tDuration]),
                    row([Text {content: "Reset item"}, lv]),
                    row([
                        Text {content: "Store"}
                        Button {text: "Reload" action: function() {store1.reload(); store2.reload();}}
                        Button {text: "Reset All" action: function(){store1.resetAll(); store2.resetAll();}}
                        Button {text: "Save" action: function() {store1.save(); store2.save();}}
                        Text {content: " "}
                    ]),
                    row([
                        Text {content: "General"}
                        Button {text: "List Stores", action: function() {XStore.listStores()}}
                        Button {text: "List Items 1", action: function() {store1.listItems()}}
                        Button {text: "List Items 2", action: function() {store2.listItems()}}
                        Button {text: "ClearAll", action: function() {XStore.clearAll()}}
                    ]),
                    row(Text {content: " "}),
                    row(Text {content: "As a rapid example, drag window across screen to change the bound stageX..."}),
                    row(Text {content: "click Save, drag the app elsewhere, click Reload will move it back ... "}),
                    row(Text {content: "click Reset All, will reset to defaults which should be 300. Exit will save current."}),
                    row(Text {content: "Store1 contents are displayed, see app code for Store2 (sequences)."}),
                ]
            }
        }
    }
}
