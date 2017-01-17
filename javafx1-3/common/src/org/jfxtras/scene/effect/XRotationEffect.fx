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

package org.jfxtras.scene.effect;

import javafx.geometry.Point2D;
import javafx.scene.Node;
import javafx.scene.effect.PerspectiveTransform;
import javafx.scene.shape.Polygon;
import javafx.util.Math;
import org.jfxtras.util.PerspectiveTransformer;

/**
 * Provides a simple rotation effect that can be used to transform a node around its vertical axis by a specific angle.
 * <p>
 * This makes use of a PerspectiveTransform, so it has the same limitation that mouse events will not be mapped
 * to the new coordinates.
 *
@example
ImageView {
    effect: XRotationEffect {
        x: 0
        y: 60
        width: 300
        height: 150
        topAspect: 0.15
        bottomAspect: 0.15
        angle: 45
    }
    image: Image {
        url: "{__DIR__}BakuretsuTenshi.jpg"
    }
}
@endexample
 *
 * @author Stephen Chin
 * @author Keith Combs
 */
public class XRotationEffect extends PerspectiveTransform {
    /**
     * Angle of rotation around the x or y axis.
     */
    public var angle:Number on replace {
        updateTransform();
    }

    /**
     * Number of degrees that this rotation stretches around the circle of
     * rotation.  The default is 180 degrees for a semi-circle.
     */
    public var sweep:Number = 180 on replace {
        updateTransform();
    }

    /**
     * True for rotation around the y-axis, false for rotation around the x-axis.
     */
    public var vertical = true on replace {
        updateTransform();
    }

    /**
     * x offset of the transformation.
     */
    public var x:Number on replace {
        updateTransform();
    }

    /**
     * y offset of the transformation.
     */
    public var y:Number on replace {
        updateTransform();
    }

    /**
     * width of the destination transformation (does not have to match the source node).
     */
    public var width:Number on replace {
        updateTransform();
    }

    /**
     * height of the destination transformation (does not have to match the source node).
     */
    public var height:Number on replace {
        updateTransform();
    }

    /**
     * Aspect of the circle of rotation for the top of the node.  0 is perpendicular (no tilt), and 1 is a full circle.
     */
    public var topAspect:Number on replace {
        updateTransform();
    }

    /**
     * Aspect of the circle of rotation for the bottom of the node.  0 is perpendicular (no tilt), and 1 is a full circle.
     */
    public var bottomAspect:Number on replace {
        updateTransform();
    }

    var perspectiveTransformer:PerspectiveTransformer;

    var polygon:Polygon;

    /**
     * Returns the bounds of the transformed node as a Polygon.  (Useful for hit detection)
     */
    public function getBounds():Polygon {
        if (polygon == null) {
            polygon = Polygon {
                points: bind [ulx, uly, urx, ury, lrx, lry, llx, lly]
            }
        }
        return polygon;
    }

    var node:Node;
    override function impl_add(node:Node) {
        this.node = node;
        super.impl_add(node);
    }

    public function mapLocalToTransformed(x:Number, y:Number):Point2D {
        if (perspectiveTransformer == null) {
            perspectiveTransformer = PerspectiveTransformer {
                ulx: ulx
                uly: uly
                urx: urx
                ury: ury
                lrx: lrx
                lry: lry
                llx: llx
                lly: lly
            }
        }
        perspectiveTransformer.transform(x, y)
    }

    function updateTransform() {
        perspectiveTransformer = null;
        def startRadians = Math.toRadians(angle + 90);
        def endRadians = Math.toRadians(angle + 90 + sweep);
        if (vertical) {
            def radius = width / 2;
            ulx = llx = x + radius + Math.sin(endRadians) * radius;
            lrx = urx = x + radius + Math.sin(startRadians) * radius;
            uly = y + Math.cos(endRadians) * radius * topAspect;
            ury = y + Math.cos(startRadians) * radius * topAspect;
            lly = y + height - Math.cos(endRadians) * radius * bottomAspect;
            lry = y + height - Math.cos(startRadians) * radius * bottomAspect;
        } else {
            def radius = height / 2;
            uly = ury = y + radius + Math.sin(endRadians) * radius;
            lly = lry = y + radius + Math.sin(startRadians) * radius;
            ulx = x + Math.cos(endRadians) * radius * topAspect;
            llx = x + Math.cos(startRadians) * radius * topAspect;
            urx = x + width - Math.cos(endRadians) * radius * bottomAspect;
            lrx = x + width - Math.cos(startRadians) * radius * bottomAspect;
        }
    }
}
