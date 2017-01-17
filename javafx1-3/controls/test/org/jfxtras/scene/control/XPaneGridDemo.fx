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

import java.lang.String;
import javafx.stage.Stage;
import javafx.scene.paint.Color;
import javafx.scene.layout.VBox;
import javafx.scene.control.Label;
import javafx.scene.control.Button;
import javafx.scene.control.ProgressBar;
import javafx.scene.image.ImageView;
import javafx.scene.image.Image;
import javafx.scene.text.Text;

import javafx.scene.layout.LayoutInfo;
import javafx.scene.Scene;
import com.javafx.preview.layout.Grid;
import com.javafx.preview.layout.GridRow;
import javafx.geometry.Insets;
import javafx.geometry.HPos;
import javafx.geometry.VPos;
import javafx.scene.Node;

/**
 * This test program demonstrates XPane resizing behavior when placed inside a
 * Grid container.
 * 
 * @author dean
 */
var sceneRef:Scene;

Stage {
    title: "XPane in a XGrid"
    scene: sceneRef = Scene {
        width: 800
        height: 400
        fill: Color.WHITESMOKE
        stylesheets: ["/org/jfxtras/scene/control/skin/jfxtras.css", "{__DIR__}XPaneDemo.css"]
        content: [
            Grid {
                hgap: 5
                vgap: 15
                nodeHPos: HPos.CENTER
                width: bind sceneRef.width
                height: bind sceneRef.height
                padding: Insets { top: 10, right: 10, bottom: 10, left: 10 }
                rows: [
                    GridRow {
                        cells: [
                            XPane {
                                id: "pane1"
                                contentNode: Label { text: "Default Pane with a Label" }
                            }
                            XPane {
                                id: "pane2"
                                contentNode: VBox {
                                    spacing: 10
                                    nodeHPos: HPos.CENTER
                                    vpos: VPos.CENTER
                                    content: [
                                        Label {
                                            text: "Progress is progressing"
                                        }
                                        ProgressBar {
                                            progress: -1
                                        }
                                    ]
                                }
                            }
                            XPane {
                                id: "pane3"
                                contentNode: Text {
                                    content: "\u201cWhat's in a name? That which we call a rose "
                                             "By any other name would smell as sweet.\u201d"
                                    wrappingWidth: 340
                                }
                            }
                        ]
                    }
                    GridRow {
                        var cellsRef: Node[];
                        var styledPane: XPane;
                        var buttonPane: XPane;
                        
                        cells: cellsRef = [
                            XPane {
                                id: "pane4"
                                title: "Default Titled Pane"
                                layoutInfo: LayoutInfo { width: 200, height: 200 }
                            }
                            styledPane = XPane {
                                id: "pane5"
                                title: "Closable & Draggable Pane"
                                draggable: true
                                closable: true
                                onClose: function() {
                                    delete styledPane from cellsRef;
                                }
                                layoutInfo: LayoutInfo { width: 200, height: 200 }
                            }
                            XPane {
                                id: "pane6"
                                title: "Pane With Controls"
                                titleGraphic: ImageView {
                                    image: Image { url: "{__DIR__}TestImageLibrary/document_32.png" }
                                }
                                closable: true
                                onClose: function() {
                                    delete buttonPane from cellsRef;
                                }
                                layoutInfo: LayoutInfo {
                                    vpos: VPos.TOP
                                }
                                contentNode: VBox {
                                    spacing: 4
                                    content: [
                                        Label {
                                            text: "I'm with stupid. \u2193"
                                        }
                                        Button {
                                            var numClicks = -1;
                                            def titleMessages = [
                                                "Pane With Immature Controls",
                                                "Don't Make Me Come Down There You Two!",
                                                "They Get This From Their Parent Class"
                                            ];

                                            text: "Buttons Are NOT Stupid."
                                            action: function() {
                                                def pane = (sceneRef.lookup("pane6") as XPane);
                                                pane.title = titleMessages[++numClicks mod sizeof titleMessages];
                                            }
                                        }
                                    ]
                                }
                            }
                        ]
                    }
               ]
            }
        ]
    }
}