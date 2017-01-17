/**
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

package org.jfxtras.scene.layout;

import javafx.geometry.HPos;
import javafx.stage.Stage;
import javafx.scene.control.Button;
import javafx.scene.layout.LayoutInfo;
import javafx.scene.layout.Stack;
import javafx.scene.layout.VBox;
import javafx.scene.paint.Color;
import javafx.scene.shape.Circle;
import javafx.scene.text.Text;
import javafx.scene.shape.Rectangle;
import org.jfxtras.scene.XScene;
import org.jfxtras.scene.layout.XGrid;
import org.jfxtras.scene.layout.XGridLayoutInfo;
import org.jfxtras.scene.layout.XGridLayoutInfo.*;
import org.jfxtras.scene.shape.ResizableRectangle;

/**
 * @author David
 */
var xg: XGrid;
var r: Rectangle;
var hs = 1;
Stage {
    scene: XScene {
        width: 600
        height: 600
        content: [
            VBox {
                content: [
                    Button {
                        translateX: 30
                        text: "HSpan--"
                        action: function(){hs--;}
                    }
                    Button {
                        translateX: 50
                        text: "HSpan++"
                        action: function(){hs++; println("xg {xg.layoutX} {xg.translateX}")}
                    }
                    Stack {
                        nodeHPos: HPos.LEFT
                        content: [
                            ResizableRectangle {fill: Color.YELLOW}
                            xg = XGrid {
                                onMouseClicked: function(me) {println("XGrid clicked")}
                                nodeHPos: HPos.LEFT
                                rows: [
                                    row([
                                        Text {content: "Hello there"},
                                        Button {text: "A Button"}
                                    ]),
                                    row([
                                        r = Rectangle {
                                            width: 50
                                            height: 30
                                            fill: Color.ORANGE
                                            layoutInfo: XGridLayoutInfo { hspan: bind hs }
                                        }
                                        ResizableRectangle {
                                            height: 60
                                            fill: Color.GREEN
                                        }
                                        Stack {
                                            content: [
                                                ResizableRectangle {
                                                    fill: Color.AZURE
                                                }
                                                Button {
                                                    text: "Another Button"
                                                    layoutInfo: XGridLayoutInfo { height: 30 width: 100 }
                                                }
                                            ]
                                        }
                                    ]),
                                    for (i in [0..9]) {
                                        row([
                                            ResizableRectangle {
                                                stroke: Color.BLUE
                                                fill: Color.TRANSPARENT
                                                layoutInfo: LayoutInfo{ minHeight: 0 height: 0 }
                                                onMouseClicked: function(me){ println("rr clicked"); }
                                            }
                                            ResizableRectangle {stroke: Color.BLUE layoutInfo: LayoutInfo {minHeight: 0 height: 0}}
                                            Circle {radius: 10, fill: Color.CHARTREUSE, stroke: Color.BLUE},
                                            Circle {radius: 10, fill: Color.BEIGE, stroke: Color.GREEN},
                                            Circle {radius: 10, fill: Color.BISQUE, stroke: Color.GAINSBORO},
                                            Circle {radius: 10, fill: Color.BLACK, stroke: Color.GHOSTWHITE},
                                            Circle {radius: 10, fill: Color.BLANCHEDALMOND, stroke: Color.GOLD},
                                            Circle {radius: 10, fill: Color.BLUE, stroke: Color.GOLDENROD},
                                            Circle {radius: 10, fill: Color.BLUEVIOLET, stroke: Color.GRAY},
                                            Circle {radius: 10, fill: Color.BROWN, stroke: Color.GREENYELLOW},
                                            Circle {radius: 10, fill: Color.BURLYWOOD, stroke: Color.FIREBRICK},
                                            Circle {radius: 10, fill: Color.CADETBLUE, stroke: Color.FORESTGREEN},
                                        ])
                                    }
                                ]
                                vgap: -1
                                hgap: -1
                            }
                        ]
                    }
                ]
            }
        ]
    }
}
