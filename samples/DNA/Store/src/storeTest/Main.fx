/*
 * Copyright (c) 2008-2009, David Armitage
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 * 1. Redistributions of source code must retain the above copyright notice,
 *    this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 * 3. The names of its contributors may not be used
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

package storeTest;

import javafx.stage.Stage;
import javafx.scene.Scene;
import javafx.scene.layout.VBox;
import javafx.scene.text.Text;
import store.Store;
import store.StoreItem.*;
import org.jfxtras.scene.layout.Grid;
import org.jfxtras.scene.layout.Row;
import javafx.scene.control.Button;
import javafx.scene.control.CheckBox;
import javafx.scene.control.TextBox;
import javafx.scene.control.ListView;
import javafx.scene.layout.LayoutInfo;
import org.jfxtras.scene.layout.Cell;

/**
 * @author David
 */


// TODO - perhaps insert shutdown actions to save?
// TODO - Do we need Arrays as well as Sequences?


var store1 = Store {
    name: "TestStore1"
    content: [
      StoreInteger  { name: "mfSet" default: 1 value: bind mfSet with inverse },
      StoreFloat    { name: "stageX"  default: 300.0 value: bind stageX with inverse },
      StoreBoolean  { name: "boolTest" default: true value: bind boolTest with inverse },
      StoreString   { name: "stringTest" default: "Hello" value: bind stringTest with inverse },
      StoreDuration { name: "durTest" default: 30s value: bind durTest with inverse },
      ] 
    };
    
var store2 = Store {
    name: "TestStore2"
    content: [
      StoreIntegerSeq { name: "integerSeq" default: [1, 3, 5] value: bind integerSeq with inverse },
//    StoreIntegerArr { name: "integerArr" default: [1..5] value: bind integerArr with inverse },      LOL - this is an Array NOT a Sequence
      StoreFloatSeq   { name: "floatSeq" default: [1.0, 3.0, 5.0] value: bind floatSeq with inverse },
      StoreBooleanSeq  { name: "boolSeq" default: [true, false, true, false] value: bind boolSeq with inverse },
      StoreStringSeq   { name: "stringSeq" default: [ "Monday","Tuesday","Wednesday","Thursday","Friday" ] value: bind stringSeq with inverse },
      StoreDurationSeq { name: "durSeq" default: [ 1s, 5s, 10s, 30s, 1m, 10m, 30m, 1h, 6h, 12h ] value: bind durSeq with inverse },
      ]
    };

// Complexity from here down due to UI - not Store :-)

var stage: Stage;

var mfSet: Integer on replace { tInteger.text = "{mfSet}" };
var stageX: Float on replace { tFloat.text = "{stageX}"; stage.x = stageX; };
var boolTest: Boolean;
var stringTest: String on replace { tString.text = stringTest };
var durTest: Duration on replace { tDuration.text = "{durTest.toMillis()}" };

var integerSeq: Integer[];
//var integerArr: Integer[];
var floatSeq: Float[];
var boolSeq: Boolean[];
var stringSeq: String[];
var durSeq: Duration[];

var x = bind stage.x on replace { stageX = stage.x };

var tInteger: TextBox = TextBox { text: "{mfSet}" action: function(){ mfSet = Integer.parseInt(tInteger.text);} };
var tFloat:   TextBox = TextBox { text: "{stageX}" action: function(){ stageX = Float.parseFloat(tFloat.text);} };
var tBoolean: CheckBox = CheckBox { selected: bind boolTest with inverse };
var tString:  TextBox = TextBox { text: "{stringTest}" action: function(){ stringTest = tString.text; } };
var tDuration: TextBox = TextBox { text: "{durTest.toMillis()}" action: function(){ durTest = Duration.valueOf(Double.parseDouble(tDuration.text));} };
var lv: ListView = ListView {
    layoutInfo: LayoutInfo { height: 100 }
    items: ["mfSet","stageX","boolTest","stringTest","durTest" ]
    onMousePressed: function(e){ store1.reset(lv.selectedItem as String) }
    };

function run()
  {
//  store1.listStores();
//  store1.listItems();
//  store2.listItems();
//  store.save();
//  store.reset("mfSet");
//  store.clearAll();
//  insert 999 into integerSeq;

  stage = Stage {
    title: "Application title"
    x: stageX
    width: 500
    height: 400
    onClose: function(){ store1.save(); store2.save(); }
    scene: Scene {
      content: [
        VBox {
          spacing: 5
          content: bind [
            Grid {
              rows: [
                Row { cells: [ Text { content: "mfSet" },      Text { content: "Integer" },  Cell { content: tInteger hspan: 2 } ] },
                Row { cells: [ Text { content: "stageX" },     Text { content: "Float" },    Cell { content: tFloat hspan: 2 } ] },
                Row { cells: [ Text { content: "boolTest" },   Text { content: "Boolean" },  tBoolean ] },
                Row { cells: [ Text { content: "stringTest" }, Text { content: "String" },   Cell { content: tString hspan: 2 } ] },
                Row { cells: [ Text { content: "durTest" },    Text { content: "Duration" }, Cell { content: tDuration hspan: 2 } ] },
                Row { cells: [ Text { content: "Reset item" }, Cell { content: lv hspan: 2 } ] },
                Row { cells: [
                  Text { content: "Store1"  },
                  Button { text: "Reload" action: function(){ store1.reload(); } },
                  Button { text: "Reset" action: function(){ store1.resetAll(); } },
                  Button { text: "Save" action: function(){ store1.save(); } },
                  Button { text: "List Items" action: function(){ store1.listItems(); } },
                  ] },
                Row { cells: [ 
                  Text { content: "General" },
                  Button { text: "List Stores" action: function(){ store1.listStores(); } },
                  Button { text: "ClearAll" action: function(){ store2.resetAll(); } },
                  ] }
                Row { cells: [
                  Cell { content: Text { content: "(Reset will reset to default, Reload loads last stored version, Clear not as expected yet)"} hspan: 4 },
                  ] }
                ]
              }
            ]
          }
        ]
      }
    }
  }

