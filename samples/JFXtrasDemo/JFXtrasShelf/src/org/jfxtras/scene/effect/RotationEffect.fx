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

package org.jfxtras.scene.effect;

import javafx.scene.effect.PerspectiveTransform;

import javafx.util.Math;

import javafx.scene.shape.Polygon;

/**
 * Provides a simple rotation effect that can be used to transform a node around its vertical axis by a specific angle.
 * <p>
 * This makes use of a PerspectiveTransform, so it has the same limitation that mouse events will not be mapped
 * to the new coordinates.
 *
@example
ImageView {
    effect: RotationEffect {
        x: 0
        y: 60
        width: 300
        height: 150
        topRadius: 60
        bottomRadius: 30
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
public class RotationEffect extends PerspectiveTransform {
    /**
     * Angle of rotation around the y-axis.
     */
    public var angle:Number on replace {
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

    /**
     * Returns the bounds of the transformed node as a Polygon.  (Useful for hit detection)
     */
    public function getBounds():Polygon {
        Polygon {
            points: [ulx, uly, urx, ury, lrx, lry, llx, lly]
        }
    }

    function updateTransform() {
        def radius = width / 2;
        def radians = Math.toRadians(angle);
        def lx = x + radius - Math.sin(radians) * radius;
        ulx = lx;
        llx = lx;
        def rx = x + radius + Math.sin(radians) * radius;
        lrx = rx;
        urx = rx;
        uly = y - Math.cos(radians) * radius * topAspect;
        ury = y + Math.cos(radians) * radius * topAspect;
        lly = y + height + Math.cos(radians) * radius * bottomAspect;
        lry =y +  height - Math.cos(radians) * radius * bottomAspect;
    }
}
