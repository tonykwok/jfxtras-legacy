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
 * Creates a circle with a pseudo-3D effect that is rendered with gradients.
 * <p>
 * The following example creates a sphere with a configurable hue and rollover
 * Glow effect:
@example
var radius = 100;
var hue = Color.RED;
Sphere {
    effect: bind if (sphere.hover) Glow {} else null
    centerX: radius
    centerY: radius
    radius: radius
    base: bind Color.hsb(hue, 1.0, 1.0)
    specular: bind Color.hsb(hue - 40, 0.9, 0.7)
}
@endexample
 *
 * @author Stephen Chin
 */
public class Sphere extends CustomNode {
    /**
     * The horizontal center coordinate of the sphere.
     */
    public var centerX:Number;

    /**
     * The vertical center coordinate of the sphere.
     */
    public var centerY:Number;

    /**
     * The radius of the sphere
     */
    public var radius:Number;

    /**
     * Base color of the sphere.  This is used to render the sphere background.
     */
    public var base = Color.BLUE;

    /**
     * Edge color of the sphere.  This is the color that the sphere fades to at the edges.
     */
    public var edge = Color.color( 0, 0, 0, 0.8 );

    /**
     * Ambient color of the sphere.  This is used to draw a backgroung gradient.
     */
    public var ambient = Color.rgb(6, 76, 160, .5);

    /**
     * Specular color of the sphere.  This is used to draw a light reflection off
     * the surface the sphere is resting on.
     */
    public var specular = Color.rgb(64, 142, 203);

    /**
     * Shine color of the sphere.  This is used to draw a highlight light source
     * at the top fo the sphere.
     */
    public var shine = Color.WHITE;

    /**
     * Size of the shadow under the sphere as a percentage of the sphere's size.
     * Set this to 0 to disable the shadow.
     */
    public var shadowSize = .7;

    /**
     * Height of the shadow under the sphere, where 0 is flush on the surface,
     * and positive values move the sphere upwards by pixel increments.
     */
    public var shadowHeight:Number = 0;

    override var layoutBounds = bind lazy BoundingBox {
        minX: centerX - radius
        minY: centerY - radius
        width: radius * 2
        height: radius * 2
    }

    override function create() {
        def shadow = bind if (shadowSize > 0) Ellipse {
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
                            Stop {offset: 1, color: edge }
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
                            Stop {offset: 0.8, color: deriveA(specular, 0)}
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
                            Stop {offset: 0.0, color: deriveA(shine, 0.5)}
                            Stop {offset: 0.5, color: deriveA(shine, 0)}
                        ]
                    }
                }
            ]
        }

        return Group {
            content: bind [shadow, sphere]
        }
    }
}
