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

import javafx.util.Math;
import javafx.scene.shape.Path;
import javafx.scene.shape.MoveTo;
import javafx.scene.shape.LineTo;
import javafx.scene.shape.ClosePath;
import javafx.scene.shape.PathElement;
import javafx.scene.shape.ArcTo;
import org.jfxtras.util.GeometryUtil;

/**
 * <p>The {@code Asterisk} class defines an asterisk shape that may have round corners.</p>
 *
    @example
    import org.jfxtras.scene.shape.Asterisk;
    import javafx.scene.paint.*;

    Asterisk {
        centerX: 40
        centerY: 40
        radius: 30
        width: 20
        beams: 5
        roundness: 0.5
        fill: Color.BLACK
    }
    @endexample
 *
 * @author Steven Bixby <sbixby@gmail.com>
 * @author Andres Almiray <aalmiray@users.sourceforge.net>
 */
public class Asterisk extends Path {
    postinit {
        recalculateShape();
    }


    function recalculateShape() {
        // Angle from center of beam to middle between beams
        def alpha = Math.toRadians(360 / beams  / 2);
        // offset from x-axis for Y dimension
        def ydx = width/2;
        // offset from y-axis for x dimension of
        // starting point.
        def xdx = ydx / Math.tan(alpha);

        // Define first beam's line-to & arc-to's as if at origin.
        // If no rounded corners, just generate LineTo's
        var oneBeam : PathElement[];
        if (roundness == 0) {
            oneBeam = [
                LineTo{ x: radius;  y: -ydx; }
                LineTo{ x: radius;  y:  ydx; }
                LineTo{ x: xdx;     y:  ydx; }
            ];
        } else {
            def roundnessOffset = (roundness * ydx);
            oneBeam = [ 
                LineTo { x: radius - roundnessOffset ;  y: -ydx; },
                if (roundness > 0) then
                    ArcTo { x: radius;  y: -ydx + roundnessOffset; radiusX: roundnessOffset; radiusY: roundnessOffset; sweepFlag:true; } else null,
                LineTo { x: radius;  y:  ydx - roundnessOffset; },
                if (roundness > 0) then
                    ArcTo { x: radius - roundnessOffset;  y:  ydx; radiusX: roundnessOffset; radiusY: roundnessOffset; sweepFlag:true; } else null,
                LineTo { x: xdx;     y:  ydx; }
             ];
        }


        // Starting point relative to origin
        elements = MoveTo{ x: xdx; y: -ydx; };
        // Add the first beam
        insert oneBeam into elements;

        // Rotate and add the remainder of the beams
        for (beamId in [1..<beams]) {
            def theta:Number = beamId * (alpha * 2);
            insert GeometryUtil.rotatePathElementsAroundPoint(oneBeam, theta) into elements;
        }

        // Close the path for completeness; it *should* end up
        // exactly on the starting point, but we'll be safe.
        insert ClosePath {} into elements;

        // Translate all points into final position.
        GeometryUtil.translatePathElementsInPlace(elements, centerX, centerY);
    }

    /**
     * Defines the radius of the asterisk in pixels.
     * @defaultvalue 40
     */
    public var radius:Number = 40 on replace {
        recalculateShape();
    }

    /**
     * Defines the width (thickness) of each arm of the asterisk.
     * @defaultvalue 30
     */
    public var width:Number = 30 on replace {
        recalculateShape();
    }

    /**
     * Defines the horizontal position of the center of the asterisk in pixels.
     * @defaultvalue 0
     */
    public var centerX:Number on replace {
        recalculateShape();
    }

    /**
     * Defines the vertical position of the center of the asterisk in pixels.
     * @defaultvalue 0
     */
    public var centerY:Number on replace {
        recalculateShape();
    }

    /**
     * Defines the number of beams (or arms) that eminate from the center of the shape.  Minimum
     * value is 2.
     * @defaultvalue 5
     */
    public var beams:Number = 5 on replace {
        if( beams < 2 )
            beams = 2;
        recalculateShape();
    }

    /**
     * Defines the roundness of the outside corners of the asterisk.  The range is from 0.0 to 1.0.
     * The higher the value the more round the corners will be.
     * @defaultvalue 0
     */
    public var roundness:Number = 0 on replace {
        recalculateShape();
    }
}