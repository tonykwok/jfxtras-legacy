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
import javafx.scene.shape.LineTo;
import javafx.scene.shape.MoveTo;
import javafx.scene.shape.Path;


/**
 * <p>The {@code ETriangle} class defines an equilateral triangle shape.</p>
 *
    @example
    import org.jfxtras.scene.shape.ETriangle;
    import javafx.scene.paint.*;

    ETriangle {
        centerX: 10
        centerY: 10
        width: 50
        fill: Color.BLACK
    }
    @endexample
 *
 * @profile desktop
 *
 * @author Steven Bixby
 * @author Andres Almiray <aalmiray@users.sourceforge.net>
 */
public class ETriangle extends Path {
    init {
        recalculateShape();
    }

    function recalculateShape() {
        def sq3d2tr = (Math.sqrt(3)/2)*width;

        elements = [
            MoveTo { x:x; y:y }
            LineTo { x:x+width; y:y }
            LineTo { x:x+(width/2); y:y-sq3d2tr }
            LineTo { x:x; y:y; }
        ];
    }

    /**
     * Defines the width of the triangle's sides in pixels.
     * @defaultvalue 80
     */
    public var width:Number = 80 on replace {
        recalculateShape();
    }

    /**
     * Defines the X coordinate of the triangle's lower left point
     * @defaultvalue 0.0
     */
    public var x:Number on replace {
        recalculateShape();
    }

    /**
     * Defines the Y coordinate of the triangle's lower left point.
     * @defaultvalue 0.0
     */
    public var y:Number on replace {
        recalculateShape();
    }

}