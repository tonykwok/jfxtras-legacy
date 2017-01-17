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

import java.io.File;
import javafx.stage.Stage;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.layout.HBox;
import javafx.scene.layout.VBox;
import org.jfxtras.lang.XBind;
import org.jfxtras.scene.control.XTreeView;
import org.jfxtras.scene.control.XTreeNode;
import org.jfxtras.scene.control.data.DataProvider;
import org.jfxtras.scene.control.data.DataRow;
import org.jfxtras.scene.control.data.FileTreeDataDescriptor;
import javafx.reflect.FXLocal;

/**
 * @author jimclarke
 */
var root = new File(".");
var rootType = FXLocal.getContext().makeClassRef(root.getClass());
var tree: XTreeView;
var hbox: HBox;

var scene: Scene;
Stage {
    title : "FILE TREE TEST"
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
                    dataDescriptor: FileTreeDataDescriptor{}
                    dataProvider: DataProvider {

                        override bound function getRange(rowStart:Integer, rowCount:Integer, columns:String[]):DataRow[] {
                            DataRow {
                                override function getData():XBind[] {XBind {ref: root}}
                            }
                        }
                        override var types = rootType;
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
