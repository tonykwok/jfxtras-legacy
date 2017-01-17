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
import javafx.scene.shape.PathElement;

import org.jfxtras.util.GeometryUtil;
import javafx.scene.shape.ClosePath;

/**
 * <p>The {@code Gear} class defines a circular gear shape with teeth
      and dimensional properties to resemble a mashine gear.</p>
 *
    @example
    import org.jfxtras.scene.shape.Gear;
    import javafx.scene.paint.*;

    Gear {
        centerX: 50
        centerY: 50
        outerRadius: 40
        innerRadius: 20
        teeth: 7
        toothTopWidth: 5
        toothBottomWidth: 5
        fill: Color.BLUE
    }
    @endexample
 *
 * @profile desktop
 *
 * @author Steven Bixby
 */
public class Gear extends Path {
    init {
        recalculateShape()
    }

    function recalculateShape() {
        // Angle between center of one tooth and center of next tooth
        def sliceTheta:Double = Math.toRadians(360.0/(teeth as Double));
        // arc dimension of tooth, based on toothRatio and tooth spacing arc
        def sliceTooth:Double = sliceTheta / (1.0 + (1.0/toothRatio));
        // Starting Y offset - half of tooth width.
        def toothDYO: Double = Math.sin(sliceTooth/2.0)*outerRadius;
        // Y-offset of first inner corner.
        def toothDYI: Double = toothDYO * toothTaperRatio;

        // Now, the four angles we need to set the points of the first tooth
        // and valley.  The first one works both above & below x axis.
        def a1:Double = sliceTooth/2.0;
        // Inner corner angle
        def a2:Double = Math.asin(toothDYI/innerRadius);
        // Next outer - we'll resuse it in a moment.
        def a4:Double = sliceTheta - (sliceTooth/2.0);
        // Finally, second inner corner, based on same offset as
        // first inner corner.
        def a3:Double = a4 - (a2-a1);

        // Now generate the first slice; re-use Y values from above
        // when possible.
        def oneTooth : PathElement[] = [
            ArcTo  { x:  Math.cos(a1) * outerRadius,
                     y:  toothDYO,
                     radiusX: outerRadius, radiusY: outerRadius, sweepFlag:true }
            LineTo { x:  Math.cos(a2) * innerRadius,
                     y:  toothDYI }
            ArcTo  { x:  Math.cos(a3) * innerRadius,
                     y:  Math.sin(a3) * innerRadius,
                     radiusX: innerRadius, radiusY: innerRadius, sweepFlag:true }
            LineTo { x:  Math.cos(a4) * outerRadius,
                     y:  Math.sin(a4) * outerRadius  }
        ];

        elements = [
            MoveTo { x:  Math.cos(a1) * outerRadius,
                     y:  - toothDYO },
            oneTooth,
            for (n in [1..<teeth]) {
                GeometryUtil.rotatePathElementsAroundPoint(oneTooth, n*sliceTheta)
            },
            ClosePath {}
        ];

        GeometryUtil.translatePathElementsInPlace(elements, centerX, centerY);
    }

    /**
     * Defines the outer radius (or total radius) of the gear in pixels.
     * @defaultvalue 50
     */
    public var outerRadius:Number = 50 on replace {
        recalculateShape();
    }

    /**
     * Defines the radius of the hole in the middle of the gear in pixels.
     * @defaultvalue 40
     */
    public var innerRadius:Number = 40 on replace {
        recalculateShape();
    }

    /**
     * Defines the horizontal position of the center of the gear in pixels.
     * @defaultvalue 0
     */
    public var centerX:Number on replace {
        recalculateShape();
    }

    /**
     * Defines the vertical position of the center of the gear in pixels.
     * @defaultvalue 0
     */
    public var centerY:Number on replace {
        recalculateShape();
    }

    /**
     * Defines the number of teeth in the gear.
     * @defaultvalue 8
     */
    public var teeth:Integer = 8 on replace {
        recalculateShape();
    }

    /**
     * Defines the ratio between tooth arc and non-tooth
     * arc.  1.0 would be half tooth, half valley.
     * @defaultvalue 1.0
     */
    public var toothRatio:Number = 1.0 on replace {
        recalculateShape();
    }

    /**
     * Defines the ratio of taper of the tooth - 1.0
     * means a straight tooth - the sides of the tooth
     * are parallel.  Greater than 1.0 means the tooth
     * is wider at the inner radius than the outer radius,
     * and vice versa.
     * @defaultvalue 1.0
     */
    public var toothTaperRatio:Number = 1.0 on replace {
        recalculateShape();
    }

}