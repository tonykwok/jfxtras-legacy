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
import javafx.scene.effect.DropShadow;

import org.jfxtras.scene.XScene;
import org.jfxtras.scene.layout.XVBox;
import org.jfxtras.scene.layout.XMigLayout;
import org.jfxtras.scene.layout.XMigLayout.*;

/**
 * This test program demonstrates XPane resizing behavior when placed inside an
 * XMigLayout container.
 * 
 * @author dean
 */
var sceneRef: XScene;

Stage {
    title: "XPane in an XMigLayout"
    scene: sceneRef = XScene {
        width: 800
        height: 400
        fill: Color.WHITESMOKE
        stylesheets: [ "/org/jfxtras/scene/control/skin/jfxtras.css", "{__DIR__}XPaneDemo.css" ]
        content: [
            XMigLayout {
                constraints: "fill, ins 10, wrap 3"
                rows: "[][align top]"
                columns: "[align center]"
                content:[
                    XPane {
                        id: "pane1"
                        contentNode: Label { text: "Default Pane with a Label" }
                    }
                    XPane {
                        id: "pane2"
                        contentNode: XVBox {
                            spacing: 5
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
                            style: "font-size: 14pt; fill: maroon;"
                            wrappingWidth: 340
                        }
                    }
                    XPane {
                        id: "pane4"
                        title: "Default Titled Pane"
                        layoutInfo: nodeConstraints( "w 200, h 200" )
                    }
                    XPane {
                        id: "pane5"
                        title: "Styled Draggable Pane"
                        draggable: true
                        closable: true
                        layoutInfo: nodeConstraints( "w 200, h 200" )
                    }
                    XPane {
                        id: "pane6"
                        closable: true
                        title: "Pane With Button"
                        titleGraphic: ImageView {
                            image: Image { url: "{__DIR__}TestImageLibrary/document_32.png" }
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
                        layoutInfo: nodeConstraints( "spanx, center" )
                    }
               ]
            }
        ]
    }
}