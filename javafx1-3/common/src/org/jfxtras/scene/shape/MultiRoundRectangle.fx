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
import javafx.scene.shape.LineTo;
import javafx.scene.shape.ArcTo;
import javafx.scene.shape.ClosePath;

/**
 * <p>The {@code MultiRoundRectangle} class defines a rectangular shape
 * with different rounding valus for each corder (width and height).</p>
 *
     @example
     import org.jfxtras.scene.shape.MultiRoundRectangle;
     import javafx.scene.paint.*;

     MultiRoundRectangle {
         x: 10
         y: 10
         width: 130
         height: 70
         topLeftWidth: 10
         topLeftHeight: 10
         bottomLeftWidth: 5
         bottomLeftHeight: 5
         topRightWidth: 20
         topRightHeight: 20
         bottomRightWidth: 5
         bottomRightHeight: 5
         fill: Color.BLACK
     }
     @endexample
 *
 * @profile desktop
 *
 * @author Steven Bixby
 * @author Andres Almiray <aalmiray@users.sourceforge.net>
 */
public class MultiRoundRectangle extends Path {
    init {
        recalculateShape();
    }

    function recalculateShape() {
        elements = [
            MoveTo { x:x+(width-topRightWidth); y:y },
            LineTo { x:x+topLeftWidth; y:y },
            if (topLeftWidth > 0 or topLeftHeight > 0) then
                ArcTo  { x:x; y: y+topLeftHeight; radiusX: topLeftWidth; radiusY: topLeftHeight } else null,
                
            LineTo { x:x; y: y+(height-bottomLeftHeight) },

            if (bottomLeftWidth > 0 or bottomLeftHeight > 0) then
                ArcTo  { x:x+bottomLeftWidth; y:y+height  radiusX: bottomLeftWidth radiusY: bottomLeftHeight } else null,

            LineTo { x:x+(width-bottomRightWidth); y:y+height },

            if (bottomRightWidth > 0 or bottomRightHeight > 0) then
                ArcTo  { x:x+width; y:y+(height-bottomRightHeight); radiusX: bottomRightWidth; radiusY: bottomRightHeight } else null,

            LineTo { x:x+width; y:y+topRightHeight },

            if (topRightWidth > 0 or topRightHeight > 0) then
                ArcTo  { x:x+(width-topRightWidth); y:y; radiusX:topRightWidth; radiusY: topRightHeight } else null,

            ClosePath {}
        ];


    }

    /**
     * Defines the X coordinate of the upper-left corner of the rectangle.
     * @defaultvalue 0
     */
    public var x:Number on replace {
        recalculateShape();
    }

    /**
     * Defines the Y coordinate of the upper-left corner of the rectangle.
     * @defaultvalue 0
     */
    public var y:Number on replace {
        recalculateShape();
    }

    /**
     * Defines the width of the rectangle.
     * @defaultvalue 50
     */
    public var width:Number = 50 on replace {
        recalculateShape();
    }

    /**
     * Defines the height of the rectangle.
     * @defaultvalue 50
     */
    public var height:Number = 50 on replace {
        recalculateShape();
    }

    /**
     * Defines the horizontal radius of the arc at the top left corner of the rectangle.
     * @defaultvalue 0
     */
    public var topLeftWidth:Number on replace {
        recalculateShape();
    }

    /**
     * Defines the vertical radius of the arc at the top left corner of the rectangle.
     * @defaultvalue 0
     */
    public var topLeftHeight:Number on replace {
        recalculateShape();
    }

    /**
     * Defines the horizontal radius of the arc at the top right corner of the rectangle.
     * @defaultvalue 0
     */
    public var topRightWidth:Number on replace {
        recalculateShape();
    }

    /**
     * Defines the vertical radius of the arc at the top right corner of the rectangle.
     * @defaultvalue 0
     */
    public var topRightHeight:Number on replace {
        recalculateShape();
    }

    /**
     * Defines the horizontal radius of the arc at the bottom left corner of the rectangle.
     * @defaultvalue 0
     */
    public var bottomLeftWidth:Number on replace {
        recalculateShape();
    }

    /**
     * Defines the vertical radius of the arc at the bottom left corner of the rectangle.
     * @defaultvalue 0
     */
    public var bottomLeftHeight:Number on replace {
        recalculateShape();
    }

    /**
     * Defines the horizontal radius of the arc at the bottom right corner of the rectangle.
     * @defaultvalue 0
     */
    public var bottomRightWidth:Number on replace {
        recalculateShape();
    }

    /**
     * Defines the vertical radius of the arc at the bottom right corner of the rectangle.
     * @defaultvalue 0
     */
    public var bottomRightHeight:Number on replace {
        recalculateShape();
    }
}
