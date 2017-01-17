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
package org.jfxtras.scene.control;

import javafx.reflect.FXContext;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.layout.HBox;
import javafx.scene.layout.VBox;
import javafx.scene.paint.Color;
import javafx.scene.shape.Circle;
import javafx.scene.text.Font;
import javafx.stage.Stage;
import org.jfxtras.lang.XBind;
import org.jfxtras.scene.control.XTreeView;
import org.jfxtras.scene.control.XTreeNode;
import org.jfxtras.scene.control.data.DataProvider;
import org.jfxtras.scene.control.data.DataRow;
import org.jfxtras.scene.control.renderer.StringAutoRenderer;
import org.jfxtras.scene.control.renderer.TextRenderer;

/**
 * @author jimclarke
 */
var root = XTreeNode {
    item: "Root"
    id: "Root"
    leaf: false
    expanded: true
    treeChildren: [
        XTreeNode {  item: "Test 1" id: "1.1"},
        XTreeNode {
            item: "Test 2"
            id: "2.1"
            leaf: false
            treeChildren: [
                XTreeNode { item: "Test 2.1" id: "1.2.1" }
                XTreeNode { item: "Test 2.2" id: "1.2.2"}
                XTreeNode { item: "Test 2.3" id: "1.2.3"}
                XTreeNode { item: "Test 2.4" id: "1.2.4"}
                XTreeNode { item: "Test 2.5" id: "1.2.5"}
                XTreeNode { item: "Test 2.6" id: "1.2.6"}
                XTreeNode { item: "Test 2.7 SSSSSSSSSSSSSSSSSSSSSSSSSSSSS" id: "1.2.7"},
                for(i in [1..25]) XTreeNode{
                    id: "1.2.{i+7}"
                    item: Circle { radius: 10  fill: Color.GREEN } }
            ]
        },
    ]


};

var tree: XTreeView;
var hbox: HBox;

var scene: Scene;
Stage {
    title : "TREE TEST"
    scene: scene = Scene {
            width: 300
            height: 400
            content: VBox { content: [
                tree = XTreeView {
                    rootVisible: true
                    width: bind scene.width
                    height: bind scene.height - hbox.layoutBounds.height
                    onSelection: function(item:XTreeNode) {
                        println("Selection: {item}");
                    }
                    onExpand: function(item:XTreeNode) {
                        println("Expand: {item}");
                    }
                    onCollapse: function(item:XTreeNode) {
                        println("Colapse: {item}");
                    }
                    onMousePressedNode: function(node,e) { println("Pressed {node}"); }
                    onMouseReleasedNode: function(node,e) { println("Pressed {node}"); }
                    onMouseClickedNode: function(node,e) { println("Clicked {node} :: {e.clickCount}"); }
                    onMouseEnteredNode: function(node,e) { println("Entered {node}"); }
                    onMouseExitedNode: function(node,e) { println("Exited {node}"); }
                    onMouseMovedNode: function(node,e) { println("Moved {node}"); }
                    onMouseDraggedNode: function(node,e) { println("Dragged {node}"); }
                    onMouseWheelMovedNode: function(node,e) { println("WheelMoved {node}"); }
                    onKeyPressedNode: function(node,e) { println("Key Pressed {node} :: {e.char}"); }
                    onKeyReleasedNode: function(node,e) { println("Key Released {node} :: {e.char}"); }
                    onKeyTypedNode: function(node,e) { println("Typed {node} :: {e.code}"); }
                    dataProvider: DataProvider {

                        override bound function getRange(rowStart:Integer, rowCount:Integer, columns:String[]):DataRow[] {
                            DataRow {
                                override function getData():XBind[] {XBind {ref: root}}
                            }
                        }
                        override var types = root.getJFXClass();
                        override var rowCount = 1;
                        override var columns = "";
                    }
                },
                hbox = HBox {
                    spacing: 5
                    content: [
                        Button {
                            text: "Clear"
                            action: function() {
                                tree.clearSelection();
                            }
                        },
                        Button {
                            text: "Collapse"
                            action: function() {
                                tree.collapseSelection();
                            }
                        },
                        Button {
                            text: "Expand"
                            action: function() {
                                tree.expandSelection();
                            }
                        },
                        Button {
                            text: "Visible"
                            action: function() {
                                tree.makeVisible(tree.selected);
                            }
                        }
                    ]
                }
           ]
       }

    }
}

tree.addRenderer(FXContext.getInstance().getStringType(),
    StringAutoRenderer {
        textRenderer: TextRenderer {
            font: Font {name: "Arial Bold Italic" size: 8 };
            fill: Color.RED
            selectedFill: bind Color.ALICEBLUE
        }
    });

