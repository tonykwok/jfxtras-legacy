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
import javafx.scene.effect.Glow;
import javafx.scene.Group;
import javafx.scene.input.MouseEvent;
import javafx.scene.Node;
import javafx.scene.paint.Color;
import javafx.scene.shape.Circle;



/**
 * @author sanderson
 */

public class AudioButton extends CustomNode {

    public var action: function():Void;
    public var radius: Number;

    public var darkColor: Color;
    public var medColor: Color;
    public var lightColor:Color;
    public var icon: Node;

    public var x: Number;
    public var y: Number;

    override public function create():Node {
        Group {
            onMouseEntered: function(e:MouseEvent) {
                effect = Glow {
                }
            }
            onMouseExited: function(e:MouseEvent) {
                effect = null
            }
            onMousePressed: function(e:MouseEvent) {
                effect = Glow {
                    level: 1.0
                }

            }

            onMouseReleased: function(e:MouseEvent) {
                effect = null;
                action();
            }

            content: bind [
                Circle {
                    fill:medColor
                    stroke: darkColor
                    /*
                    fill: RadialGradient {
                        centerX: -radius * 0.5
                        centerY: -radius * 0.5
                        radius: radius
                        proportional: false
                        stops: [
                            Stop {
                                offset: 0.0
                                color: lightColor
                            },
                            Stop {
                                offset: 0.7
                                color: medColor
                            },
                            Stop {
                                offset: 1.0
                                color: darkColor
                            },
                        ]
                    }
*/
                    radius: radius
                },
                icon
            ]
            translateX: x
            translateY: y
        }
    }

}
