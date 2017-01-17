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

import javafx.scene.shape.Path;
import javafx.scene.shape.MoveTo;
import javafx.scene.shape.ArcTo;
import javafx.util.Math;
import javafx.scene.shape.LineTo;

/**
 * <p>The {@code Donut} class defines a regular polygon with a hole in the middle</p>
 *
    @example
    import org.jfxtras.scene.shape.Donut;
    import javafx.scene.paint.*;

    Donut {
        angle: 0
        centerX: 50
        centerY: 50
        outerRadius: 40
        innerRadius: 20
        sides: 7
        fill: Color.BLACK
    }
    @endexample
 *
 * @profile desktop
 *
 * @author Steven Bixby
 * @author Andres Almiray <aalmiray@users.sourceforge.net>
 */
public class Donut extends Path {
    init {
        recalculateShape()
    }

    function recalculateShape() {
        if (sides<3) {
            elements = [
                MoveTo { x: centerX + outerRadius; y: centerY }
                ArcTo  { x: centerX - outerRadius; y: centerY; radiusX:outerRadius; radiusY:outerRadius }
                ArcTo  { x: centerX + outerRadius; y: centerY; radiusX:outerRadius; radiusY:outerRadius }
                MoveTo { x: centerX + innerRadius; y: centerY }
                ArcTo  { x: centerX - innerRadius; y: centerY; radiusX:innerRadius; radiusY:innerRadius; sweepFlag:true }
                ArcTo  { x: centerX + innerRadius; y: centerY; radiusX:innerRadius; radiusY:innerRadius; sweepFlag:true }
            ]
        } else {
            def sliceTheta = Math.toRadians(360.0/(sides as Float));
            var points = for (n in [0..sides]) n*sliceTheta;

            elements = MoveTo{ x: centerX + outerRadius; y: centerY };
            for (n in points[1..]) {
                insert LineTo {
                        x: centerX + (Math.cos(n) * outerRadius);
                        y: centerY + (Math.sin(n) * outerRadius)
                    } into elements;
            }

            points = reverse points;
            insert MoveTo{x: centerX + innerRadius; y: centerY} into elements;
            for (n in points[1..]) {
                insert LineTo {
                        x: centerX + (Math.cos(n) * innerRadius);
                        y: centerY + (Math.sin(n) * innerRadius)
                    } into elements;
            }

        }


    }

    /**
     * Defines the outer radius (or total radius) of the polygon in pixels.
     * @defaultvalue 30
     */
    public var outerRadius:Number = 30 on replace {
        recalculateShape();
    }

    /**
     * Defines the radius of the hole in the middle of the polygon in pixels.
     * @defaultvalue 10
     */
    public var innerRadius:Number = 10 on replace {
        recalculateShape();
    }

    /**
     * Defines the horizontal position of the center of the polygon in pixels.
     * @defaultvalue 0
     */
    public var centerX:Number on replace {
        recalculateShape();
    }

    /**
     * Defines the vertical position of the center of the polygon in pixels.
     * @defaultvalue 0
     */
    public var centerY:Number on replace {
        recalculateShape();
    }

    /**
     * Defines the number of sides of the polygon.  A value of 3 is a triangle, 4 is a square, etc.
     * Values below 3 are invalid.
     * @defaultvalue 5
     */
    public var sides:Integer = 5 on replace {
        recalculateShape();
    }
}