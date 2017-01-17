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

import javafx.stage.Stage;
import javafx.scene.Scene;
import javafx.scene.paint.Color;
import javafx.scene.layout.HBox;
import javafx.scene.control.Button;
import javafx.scene.control.CheckBox;
import javafx.geometry.VPos;
import javafx.scene.Group;
import javafx.scene.shape.Line;
import javafx.scene.shape.StrokeLineCap;
import javafx.geometry.HPos;
import javafx.scene.layout.VBox;
import javafx.scene.image.ImageView;
import javafx.scene.image.Image;
import javafx.scene.shape.Circle;
import javafx.scene.text.Font;
import org.jfxtras.scene.control.XEtchedButton;
import org.jfxtras.scene.control.skin.XCaspian;
import javafx.scene.layout.Stack;
import javafx.geometry.Insets;
import javafx.scene.layout.LayoutInfo;
import com.javafx.preview.layout.Grid;
import com.javafx.preview.layout.GridRow;

/**
 * @author Dean Iverson
 */
var hposSeq = [ HPos.LEFT, HPos.CENTER, HPos.RIGHT ];
var vposSeq = [ VPos.TOP, VPos.CENTER, VPos.BOTTOM ];

 var images = [
     Image { url: "{__DIR__}TestImageLibrary/bubble_32.png" }
     Image { url: "{__DIR__}TestImageLibrary/clipboard_32.png" }
     Image { url: "{__DIR__}TestImageLibrary/diagram_32.png" }
 ];

var bgColor:Color = Color.LIGHTGRAY;

Stage {
    var sceneRef:Scene;

    title: "XEtchedButton Demo"
    scene: sceneRef = Scene {
        width: 250
        height: 600
        stylesheets: "/org/jfxtras/scene/control/skin/jfxtras.css"
        fill: bind XCaspian.getBodyPaint( bgColor );
        content: Stack {
            width: bind sceneRef.width
            height: bind sceneRef.height
            padding: Insets { top: 10, right: 10, bottom: 10, left: 10 }
            content: [
                CheckBox {
                    text: "Blue Background"
                    layoutInfo: LayoutInfo { hpos: HPos.RIGHT, vpos: VPos.BOTTOM }
                    override var selected on replace {
                        bgColor = if (selected) Color.STEELBLUE else Color.LIGHTGRAY;
                    }
                }
                VBox {
                    spacing: 25
                    layoutX: 20
                    layoutY: 20
                    content: [
                        createCaspianComparisonRow(),
                        createNumberPad(),
                        createHorizontalButtonBar(),
                        createVerticalButtonBar(),
                        createLShapedBar()
                    ]
                }
            ]
        }
    }
}

function createCaspianComparisonRow(): HBox {
    HBox {
        var disabledCheck:CheckBox;
        var eb:XEtchedButton;

        spacing: 5
        nodeVPos: VPos.CENTER
        content: [
            eb = XEtchedButton {
                def text = "Etched Button"
                def xShape = createXShape()

                text: text
                disable: bind disabledCheck.selected
                action: function() {
                    if (eb.text.length() == 0) {
                        eb.text = text;
                        eb.graphic = null;
                    } else {
                        eb.text = null;
                        eb.graphic = xShape;
                    }
                }
            }
            Button {
                text: "Button"
                disable: bind disabledCheck.selected
            }
            disabledCheck = CheckBox {
                text: "Disable"
                translateX: 15
            }
        ]
    }
}

function createNumberPad(): Grid {
    Grid {
        var cellLayout = LayoutInfo { width: 60, height: 60 }
        hgap: -1
        vgap: -1
        rows: for (i in [0..2]) {
            GridRow {
                cells: for (j in [0..2]) {
                    XEtchedButton {
                        text: "{i * 3 + j + 1}"
                        font: Font { size: 36, embolden: true }
                        buttonGroupHPos: hposSeq[j]
                        buttonGroupVPos: vposSeq[i]
                        layoutInfo: cellLayout
                    }
                }
            }
        }
    }
}

function createHorizontalButtonBar(): HBox {
    HBox {
        spacing: -1
        content: for (i in [0..2]) {
            XEtchedButton {
                graphic: ImageView { image: images[i] }
                buttonGroupHPos: hposSeq[i]
            }
        }
    }
}

function createVerticalButtonBar(): VBox {
    VBox {
        spacing: -1
        content: for (i in [0..2]) {
            XEtchedButton {
                graphic: ImageView { image: images[i] }
                buttonGroupVPos: vposSeq[i]
            }
        }
    }
}


function createLShapedBar(): VBox {
    VBox {
        spacing: -1
        content: [
            HBox {
                spacing: -1
                nodeVPos: VPos.BOTTOM
                content: [
                    XEtchedButton {
                        graphic: circle( Color.GREEN )
                        buttonGroupHPos: HPos.LEFT
                        buttonGroupVPos: VPos.TOP
                    }
                    XEtchedButton {
                        graphic: circle( Color.YELLOW )
                        buttonGroupHPos: HPos.CENTER
                    }
                    XEtchedButton {
                        graphic: circle( Color.RED )
                        buttonGroupHPos: HPos.RIGHT
                    }
                ]
            }
            XEtchedButton {
                graphic: circle( Color.YELLOW )
                buttonGroupVPos: VPos.CENTER
            }
            XEtchedButton {
                graphic: circle( Color.RED )
                buttonGroupVPos: VPos.BOTTOM
            }
        ]
    }
}

function createXShape(): Group {
    Group {
        def SIZE = 8;
        content: [
            Line { endX: SIZE, endY: SIZE, strokeWidth: 3, strokeLineCap: StrokeLineCap.ROUND }
            Line { startX: SIZE, endY: SIZE, strokeWidth: 3, strokeLineCap: StrokeLineCap.ROUND }
        ]
    }
}

function circle(color: Color): Circle {
    Circle {
        fill: XCaspian.getBodyPaint(color)
        radius: 10
    }
}

