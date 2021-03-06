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
import javafx.scene.shape.MoveTo;
import javafx.scene.shape.LineTo;


/**
 * <p>The {@code Star2} class defines a star shape (twinkle, twinkle)</p>
 *
    @example
    import org.jfxtras.scene.shape.Star2;
    import javafx.scene.paint.*;

    Star2 {
        angle: 0
        centerX: 50
        centerY: 50
        outerRadius: 40
        innerRadius: 20
        count: 7
        fill: Color.BLACK
    }
    @endexample
 *
 * @profile desktop
 *
 * @author Steven Bixby
 * @author Andres Almiray <aalmiray@users.sourceforge.net>
 */
public class Star2 extends Path {
    init {
        recalculateShape();
    }

    function recalculateShape() {
        // Half the angle between points of star
        def thetad2 = Math.toRadians( (360/(count*2)));

        // Start at top - just because original shape did.
        elements = MoveTo { x:centerX; y: centerY - outerRadius };

        // Loop to add all the lines; since we start at top,
        // offset -90 degrees (in radians).
        def offset = Math.toRadians(90);
        for (n in [0..<count]) {
            def rho1 = (n*(2*thetad2)) - offset + thetad2;
            def rho2 = rho1+thetad2;
            insert [
                LineTo { x:centerX + (Math.cos(rho1)*innerRadius); y: centerY + (Math.sin(rho1)*innerRadius) }
                LineTo { x:centerX + (Math.cos(rho2)*outerRadius); y: centerY + (Math.sin(rho2)*outerRadius) }
            ] into elements;
        }
    }

    /**
     * Defines the radius to the tip of the star's points.
     * @defaultvalue 30
     */
    public var outerRadius:Number = 30 on replace {
        recalculateShape();
    }

    /**
     * Defines the radius to the start of the star's points.
     * @defaultvalue 10
     */
    public var innerRadius:Number = 10 on replace {
        recalculateShape();
    }

    /**
     * Defines the horizontal position of the center of the star in pixels.
     * @defaultvalue 0.0
     */
    public var centerX:Number on replace {
        recalculateShape();
    }

    /**
     * Defines the vertical position of the center of the star in pixels.
     * @defaultvalue 0.0
     */
    public var centerY:Number on replace {
        recalculateShape();
    }

    /**
     * Defines the number of points the star has.
     * @defaultvalue 5
     */
    public var count:Number = 5 on replace {
        recalculateShape();
    }
}
