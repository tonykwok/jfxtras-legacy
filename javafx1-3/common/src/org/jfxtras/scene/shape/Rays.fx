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
import javafx.util.Math;
import javafx.scene.shape.PathElement;
import javafx.scene.shape.LineTo;
import javafx.scene.shape.ArcTo;
import javafx.scene.shape.MoveTo;
import org.jfxtras.util.GeometryUtil;

/**
 * <p>The {@code Rays} class defines a shape having a number of rays extending from its center point.</p>
 *
    @example
    import org.jfxtras.scene.shape.Rays;
    import javafx.scene.paint.*;

    Rays {
       angle: 0
       extent: 0.5
       centerX: 50
       centerY: 50
       radius: 40
       rays: 5
       fill: Color.BLACK
    }
    @endexample
 *
 * @profile desktop
 *
 * @author Steven Bixby
 * @author Andres Almiray <aalmiray@users.sourceforge.net>
 */
public class Rays extends Path {
    init {
        recalculateShape();
    }

    function recalculateShape() {
        // Angle between rays
        def theta = Math.toRadians(360.0/rays);
        // Angular offset of extent
        def gamma = (theta * extent);

        // elements for one arm
        // Note: For backwards compatibility we start with the
        // ending line along the y-axis.
        def oneArm:PathElement[] = [
            LineTo { x: Math.cos(gamma) * radius;  y: Math.sin(-gamma) * radius; }
            if (rounded) then
                ArcTo  { x:radius; y:0;  radiusX: radius; radiusY: radius; sweepFlag:true }
            else
                LineTo { x:radius; y:0 }
            LineTo { x: 0; y:0 }
        ];

        // Starting point and first arm
        elements = MoveTo{ x: 0; y: 0 };
        insert oneArm into elements;

        for (n in [1..<rays]) {
            insert GeometryUtil.rotatePathElementsAroundPoint(oneArm, n * theta) into elements;
        }

        // Translate all points into final position.
        GeometryUtil.translatePathElementsInPlace(elements, centerX, centerY);
    }


    /**
     * Defines the width of the rays.  The range is from 0.0 to 1.0.  A value of 1.0 will make
     * each ray take up the maximum amount of space on that side of the shape.
     * @defaultvalue 0.5
     */
    public var extent:Number = 0.5 on replace {
        recalculateShape();
    }

    /**
     * Defines the horizontal position of the center of the shape in pixels.
     * @defaultvalue 0.0
     */
    public var centerX:Number on replace {
        recalculateShape();
    }

    /**
     * Defines the vertical position of the center of the shape in pixels.
     * @defaultvalue 0.0
     */
    public var centerY:Number on replace {
        recalculateShape();
    }

    /**
     * Defines the radius of the shape in pixels.
     * @defaultvalue 30
     */
    public var radius:Number = 30 on replace {
        recalculateShape();
    }

    /**
     * Defines the number of rays eminating from the center.
     * @defaultvalue 5
     */
    public var rays:Number = 5 on replace {
        recalculateShape();
    }

    /**
     * Defines whether the outside edge of the rays should be rounded.
     * @defaultvalue false
     */
    public var rounded:Boolean = false on replace {
        recalculateShape();
    }
}
