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
import javafx.util.Math;
import javafx.scene.shape.LineTo;
import javafx.scene.shape.ClosePath;


/**
 * <p>The {@code RegularPolygon} class defines a poligon that is
 * centered and each side has the same length.<p>
 *
    @example
    import org.jfxtras.scene.shape.RegularPolygon;
    import javafx.scene.paint.*;

    RegularPolygon {
        angle: 0
        centerX: 50
        centerY: 50
        radius: 40
        sides: 6
        fill: Color.BLACK
    }
    @endexample
 *
 * @profile desktop
 *
 * @author Steven Bixby
 * @author Andres Almiray <aalmiray@users.sourceforge.net>
 */
public class RegularPolygon extends Path {
    init {
        recalculateShape();
    }

    function recalculateShape() {
        // negative to draw counterclockwise for backwards compatibility
        def theta = -Math.toRadians(360.0/sides);

        elements = MoveTo { x: centerX+radius; y: centerY }

        for (n in [1..<sides]) {
            insert 
                LineTo { x: centerX + (Math.cos(theta*n) * radius);
                         y: centerY + (Math.sin(theta*n) * radius) }
            into elements;
        }
        insert ClosePath {} into elements;
    }


    /**
     * Defines the horizontal position of the center of the polygon in pixels.
     * @defaultvalue 0.0
     */
    public var centerX:Number on replace {
        recalculateShape();
    }

    /**
     * Defines the vertical position of the center of the polygon in pixels.
     * @defaultvalue 0.0
     */
    public var centerY:Number on replace {
        recalculateShape();
    }

    /**
     * Defines the radius of the polygon in pixels.
     * @defaultvalue 30
     */
    public var radius:Number = 30 on replace {
        recalculateShape();
    }

    /**
     * Defines the number of sides of the polygon.
     * @defaultvalue 5
     */
    public var sides:Number =  5 on replace {
        recalculateShape();
    }
}
