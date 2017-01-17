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

import javafx.animation.transition.FadeTransition;
import javafx.scene.CustomNode;
import javafx.scene.effect.Effect;
import javafx.scene.effect.Glow;
import javafx.scene.Group;
import javafx.scene.input.MouseEvent;
import javafx.scene.Node;
import javafx.scene.paint.Color;
import javafx.scene.paint.LinearGradient;
import javafx.scene.paint.Stop;
import javafx.scene.shape.Rectangle;
import javafx.scene.text.Font;
import javafx.scene.text.Text;

/**
 * @author sanderson
 */

public class LegacyButton extends CustomNode {

    public var x: Number;
    public var y: Number;
    public var w: Number;

    public var label: String;
    public var enabled = false;
    public var action: function():Void;

    var group: Group;
    var curEffect: Effect;

    var introTransition:FadeTransition;

    override function create():Node {
        var text = Text {
            translateY: bind y + 20
            font: Font {
                size: 16
            }
            content: label
            fill: Color.WHITE
        }
        text.translateX = x + w / 2 - text.boundsInLocal.width / 2;
        var topColor = Color {
            red: 0.2,
            green: 0.4,
            blue: 0.6
        }
        var midColor = Color {
            red: 0.1,
            green: 0.2,
            blue: 0.4
        }
        var bottomColor = Color {
            red: 0,
            green: 0.1,
            blue: 0.3
        }
        group = Group {
            opacity: 0
            content: [
                Rectangle {
                    cache: true
                    fill: LinearGradient {
                        startX: 0
                        startY: 0
                        endX: 0
                        endY: 1
                        stops: [
                            Stop {
                                offset: 0.0
                                color: topColor
                            },
                            Stop {
                                offset: 0.2
                                color: midColor
                            },
                            Stop {
                                offset: 0.6
                                color: midColor
                            },
                            Stop {
                                offset: 1.0
                                color: bottomColor
                            }
                        ]
                    }
                    translateX: bind x
                    translateY: bind y
                    width: w
                    height: 30
                    arcWidth: 20
                    arcHeight: 20
                    effect: bind curEffect
                    onMousePressed: function(me:MouseEvent):Void {
                        if (not enabled) {
                            return;
                        }

                        curEffect = Glow {
                            level: 1.0
                        }
                    }
                    onMouseReleased: function(me:MouseEvent):Void {
                        curEffect = null;
                        if (enabled) {
                            action();
                        }
                    }
                    onMouseEntered: function(me:MouseEvent):Void {
                        if (not enabled) {
                            return;
                        }

                        curEffect = Glow {
                            level: 0.4
                        }

                    }
                    onMouseExited: function(me:MouseEvent):Void {
                        curEffect = null;
                    }
                },
                text
            ]
        }

        introTransition = FadeTransition {
            duration: 2s
            node: group
            fromValue: 0
            toValue: 1
            action: function() { enabled = true }
        }

        group

    }

    public function dismiss():Void {
        if (introTransition != null and introTransition.running) {
            introTransition.stop();
        }
        else if (not enabled) {
            return;
        }

        enabled = false;
        FadeTransition {
            duration: 1s
            node: group
            fromValue: 1
            toValue: 0
        }.play();
    }


    public function intro():Void {
        introTransition.playFromStart();
    }

}
