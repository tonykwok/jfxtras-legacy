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

import javafx.scene.CustomNode;
import javafx.scene.effect.Effect;
import javafx.scene.effect.Glow;
import javafx.scene.Group;
import javafx.scene.input.MouseEvent;
import javafx.scene.Node;
import javafx.scene.paint.Color;
import javafx.scene.paint.LinearGradient;
import javafx.scene.paint.Stop;
import javafx.scene.shape.Polygon;
import javafx.scene.shape.Rectangle;

/**
 * One of either a scroll up or scroll down button. These are
 * displayed on the info boxes in "info" mode.
 * 
 * @author sanderson
 */

public class ScrollButton extends CustomNode {

    public var x: Number;
    public var y: Number;
    public var h: Number;
    public var w: Number;
    public var arrow: Polygon;
    public var action:function():Void;

    public var canScroll = true;

    var curEffect: Effect;

    override public function create():Node {
        Group {
            translateX: x
            translateY: bind y
            effect: bind curEffect
            onMouseEntered: function(e:MouseEvent) {
                if (canScroll) {
                    curEffect = Glow {
                        level: 1.0
                    }
                }
            }
            onMouseExited: function(e:MouseEvent) {
                curEffect = null;
            }
            onMousePressed: function(e:MouseEvent) {
                if (canScroll) {
                    arrow.fill = Color.DARKGRAY;
                    action();
                }
            }
            onMouseReleased: function(e:MouseEvent) {
                arrow.fill = Color.BLACK
            }


            content: [
                Rectangle {
                    fill: LinearGradient {
                        startX: 0
                        startY: 0
                        endX: 0
                        endY: 1
                        stops: [
                            Stop {
                                offset: 0.0
                                color: Color {
                                    red: 0.3,
                                    green: 0.3,
                                    blue: 0.3
                                }
                            },
                            Stop {
                                offset: 1.0
                                color: Color {
                                    red: 0.1,
                                    green: 0.1,
                                    blue: 0.1
                                }
                            }
                        ]
                    }
                    width: bind w
                    height: h
                },
                arrow

            ]
        }
    }

}
