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
import javafx.scene.shape.ClosePath;

/**
 * <p>The {@code Arrow} class defines an arrow shape.</p> 
 *
 @example
 import org.jfxtras.scene.shape.Arrow;
 import javafx.scene.paint.*;

    Arrow {
        x: 10
        y: 10
        width: 100
        height: 60
        rise: 0.5
        depth: 0.5
        fill: Color.BLACK
    }
    @endexample
 *
 * @profile desktop
 *
 * @author Steven Bixby <sbixby@gmail.com>
 * @author Andres Almiray <aalmiray@users.sourceforge.net>
 */
public class Arrow extends Path {

    init {
        recalculatePath();
    }

    function recalculatePath() {
      def d : Number = width * depth;
      def r : Number = height * rise / 2;
        elements = [
            MoveTo {
                x: x + d
                y: y
            },
            LineTo {
                x: x + width
                y: y + (height / 2)
            },
            LineTo {
                x: x + d
                y: y + height
            },
            LineTo {
                x: x + d
                y: y + (height / 2) + r
            },
            LineTo {
                x: x
                y: y + (height / 2) + r
            },
            LineTo {
                x: x
                y: y + (height / 2) - r
            },
            LineTo {
                x: x + d
                y: y + (height / 2) - r
            }
            ClosePath {}
        ];
    }


    /**
     * Defines how far along the shaft the arrowhead starts.  The range is from 0.0 to 1.0. 
     * A value of 0.0 will create a shape that is all arrow head.  A value of 0.5 means the
     * arrow will be half shaft and half arrow head.  A value of 1.0 will lead to an arrow
     * that is all shaft - basically a rectangle.
     * @defaultvalue 0.5
     */
    public var depth:Number = 0.5 on replace {
        recalculatePath();
    }

    /**
     * Defines how tall the shaft is compared to the arrowhead.  The range is from 0.0 to 1.0.
     * A value of 0.5 will create an arrow with a shaft that is half of the total height of the
     * arrow.  The remaining half of the arrow's height will be divided between the bottom and
     * top edge of the arrow.
     * @defaultvalue 0.5
     */
    public var rise:Number = 0.5 on replace {
        recalculatePath();
    }

    /**
     * Defines the width of the arrow.
     * @defaultvalue 100
     */
    public var width:Number = 100 on replace {
        recalculatePath();
    }

    /**
     * Defines the height of the arrow.
     * @defaultvalue 60
     */
    public var height:Number = 60 on replace {
        recalculatePath();
    }

    /**
     * Defines the X coordinate of the upper-left corner of the base of the arrow.
     * @defaultvalue 0
     */
    public var x:Number on replace {
        recalculatePath();
    }

    /**
     * Defines the Y coordinate of the upper-left corner of the base of the arrow.
     * @defaultvalue 0
     */
    public var y:Number on replace {
        recalculatePath();
    }
}