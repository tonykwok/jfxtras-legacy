/*
 * Copyright (c) 2009, Sten Anderson, CITYTECH, INC.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 * 1. Redistributions of source code must retain the above copyright notice,
 *    this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 * 3. Neither the name of CITYTECH, INC. nor the names of its contributors may be used
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
 
package com.citytechinc.ria.musicexplorerfx;

import javafx.animation.KeyFrame;
import javafx.animation.Timeline;
import javafx.scene.CustomNode;
import javafx.scene.Group;
import javafx.scene.Node;
import javafx.scene.paint.Color;
import javafx.scene.paint.LinearGradient;
import javafx.scene.paint.Stop; 
import javafx.scene.shape.Rectangle;
import javafx.scene.text.Text;
import javafx.animation.Interpolator;

/**
 * @author sanderson
 */

public class Gauge extends CustomNode {

    public var w: Number;
    public var h: Number;
    public var gaugeX: Number;
    public var label: String;
    
    public var color:Color;

    var value: Number;

    override public function create():Node {
        var text = Text {
            fill: Color.WHITESMOKE
            content: label
        }
        var textWidth = text.boundsInLocal.width;
        var textHeight = text.boundsInLocal.height;
        var offsetX = if (gaugeX > 0) gaugeX else textWidth;
        var rectWidth = w - offsetX;

        var darkColor = Color.BLACK;
        //var darkColor = Color {red: 0.4, green: 0.1, blue: 0.1 }
        //var lightColor = Color {red: 1.0, green: 0.2, blue: 0.2 }
        //var lightColor = Color.RED;

        cache = true;
        Group {
            content: [
                text,
                /*
                Rectangle {
                    fill: Color.BLACK
                    arcWidth: 5
                    arcHeight: 5
                    x: offsetX
                    y: -h
                    width: rectWidth
                    height: h
                },*/
                Rectangle {
                    cache: true
                    fill: LinearGradient {
                        proportional: false
                        startX: offsetX - 20
                        startY: h / 2
                        endX: rectWidth
                        endY: h / 2
                        stops: [
                            Stop {
                                offset: 0.0
                                color: Color.BLACK
                            },
                            Stop {
                                offset: 1.0
                                color: color
                            }
                        ]
                    }
                    arcWidth: 5
                    arcHeight: 5
                    x: offsetX
                    y: -h
                    width: bind rectWidth * value
                    height: h
                },


            ]
        }

    }

    public function setValue(val:Number) {
        Timeline {
            keyFrames: [
                KeyFrame {
                    values: [
                        value => 0 tween Interpolator.EASEBOTH
                    ]
                    time: 0s
                }
                KeyFrame {
                    values: [
                        value => val tween Interpolator.EASEBOTH
                    ]
                    time: 1s
                }
            ]
        }.play();

    }

}
