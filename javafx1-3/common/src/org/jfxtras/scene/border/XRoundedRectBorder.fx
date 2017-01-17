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


package org.jfxtras.scene.border;

import javafx.scene.paint.Color;

import javafx.scene.shape.Rectangle;

import javafx.scene.Group;

import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.layout.LayoutInfo;
import javafx.stage.Stage;

import org.jfxtras.scene.shape.ResizableRectangle;

/**
 * @author jclarke
 */

public class XRoundedRectBorder extends XRaisedBorder {
    override var backgroundFill = Color.WHITE;
    /**
     * Defines the arc for the corrners
     *
     * @defaultvalue 20
     * @css arc
     */
    public var arc: Number = 20.0;

    override var clip = Rectangle {
        width: bind widthOfBorder
        height: bind heightOfBorder
        arcWidth: bind arc
        arcHeight: bind arc
    };
    override var background = ResizableRectangle {
        fill: bind backgroundFill
        arcWidth: bind arc
        arcHeight: bind arc
    };

    override var border = Group {
        layoutX: bind borderX
        layoutY: bind borderY
        content: [
            Rectangle {
                //layoutX: 1
                //layoutY: 1
                width: bind widthOfBorder
                height: bind heightOfBorder
                fill: bind null
                arcWidth: bind arc
                arcHeight: bind arc
                stroke: bind if(raised) shadow else highlight
            },
            Rectangle {
                layoutX: 1
                layoutY: 1
                width: bind widthOfBorder - 2
                height: bind heightOfBorder - 2
                fill: null
                arcWidth: bind arc
                arcHeight: bind arc
                stroke: bind if(raised) highlight  else shadow
            },
        ]
    };

    public override function doBorderLayout(x:Number, y: Number,
                                    w: Number, h: Number) :  Void {
        widthOfBorder = w;
        heightOfBorder = h;
        borderY = y;
        borderX = x;
        //border = rectBoder;
    }
}

function run() {
    var border: XRoundedRectBorder;
    Stage {
        title : "RoundedRect XBorder"
        scene: Scene {
            width: 200
            height: 200
            content: [
                border = XRoundedRectBorder {
                    layoutX: 40
                    layoutY: 40
                    backgroundFill: Color.RED
                    //shapeToFit: true
                    shapeToFit: false
                    layoutInfo: LayoutInfo {
                        width: 100
                        height: 100
                    }
                    //borderWidth: 10
                    node: Group {
                        content: [
                            Button {
                                text: "hello"
                            }
                        ]
                    }
                    onMouseReleased: function(e) {
                        border.raised = not border.raised;
                    }
                }

            ]
        }
    }
}

