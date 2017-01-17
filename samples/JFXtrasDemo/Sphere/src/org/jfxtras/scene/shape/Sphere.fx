/*
 * Copyright (c) 2008-2009, JFXtras Group
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

package org.jfxtras.scene.shape;

import javafx.geometry.BoundingBox;
import javafx.scene.CustomNode;
import javafx.scene.Group;
import javafx.scene.effect.BoxBlur;
import javafx.scene.paint.Color;
import javafx.scene.paint.RadialGradient;
import javafx.scene.paint.Stop;
import javafx.scene.shape.Circle;
import javafx.scene.shape.Ellipse;
import org.jfxtras.scene.paint.ColorUtil.*;

/**
 * @author Stephen Chin
 */
public class Sphere extends CustomNode {
    public var centerX:Number;
    public var centerY:Number;
    public var radius:Number;
    public var base = Color.BLUE;
    public var ambient = Color.rgb(6, 76, 160, .5);
    public var specular = Color.rgb(64, 142, 203);
    public var shine = Color.WHITE;
    public var shadowSize = .7;
    public var shadowHeight:Number = 0;

    override var layoutBounds = bind lazy BoundingBox {
        minX: centerX - radius
        minY: centerY - radius
        width: radius * 2
        height: radius * 2
    }

    override function create() {
        def shadow = if (shadowSize > 0) Ellipse {
            cache: true
            def shadowRadius = bind radius * shadowSize;
            centerX: bind centerX
            centerY: bind centerY + radius + shadowHeight
            radiusX: bind shadowRadius
            radiusY: bind shadowRadius * 0.2
            effect: BoxBlur {
                width: bind shadowRadius
                height: bind shadowRadius * 0.2
                iterations: 2
            }
        } else null;

        def sphere = Group {
            cache: true
            content: [
                Circle {
                    centerX: bind centerX
                    centerY: bind centerY
                    radius: bind radius
                    fill: bind base
                }
                Circle {
                    centerX: bind centerX, centerY: bind centerY
                    radius: bind radius
                    fill: bind RadialGradient {
                        centerX: .5, centerY: .5, radius: .5
                        stops: [
                            Stop {offset: 0, color: ambient}
                            Stop {offset: 1, color: Color.color(0, 0, 0, .8)}
                        ]
                    }
                }
                Circle {
                    centerX: bind centerX
                    centerY: bind centerY + radius * .35
                    radius: bind radius
                    scaleY: 0.5
                    fill: bind RadialGradient {
                        centerX: 0.5, centerY: 0.7, radius: 0.5
                        focusX: 0.5, focusY: 0.8
                        stops: [
                            Stop {offset: 0, color: specular}
                            Stop {offset: 0.8, color: deriveRGB(specular, 0)}
                        ]
                    }
                }
                Circle {
                    centerX: bind centerX
                    centerY: bind centerY
                    radius: bind radius * 1.4
                    fill: bind RadialGradient {
                        centerX: .5, centerY: .5, radius: .5
                        focusX: .35, focusY: .3
                        stops: [
                            Stop {offset: 0.0, color: deriveRGB(shine, 0.5)}
                            Stop {offset: 0.5, color: deriveRGB(shine, 0)}
                        ]
                    }
                }
            ]
        }

        return Group {
            content: [shadow, sphere]
        }
    }
}
