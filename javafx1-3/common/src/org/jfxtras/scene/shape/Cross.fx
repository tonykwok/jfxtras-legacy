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

import org.jfxtras.scene.shape.Asterisk;
import javafx.scene.shape.Path;


/**
 * <p>The {@code Cross} class defines a symmetrical cross shape (with optional
 * round corners).</p>
 *
    @example
    import org.jfxtras.scene.shape.Cross;
    import javafx.scene.paint.*;

    Cross {
        centerX: 40
        centerY: 40
        radius: 30
        width: 20
        roundness: 0.5
        fill: Color.BLACK
    }
    @endexample
 *
 * @profile desktop
 *
 * @author Steven Bixby
 * @author Andres Almiray <aalmiray@users.sourceforge.net>
 */
public class Cross extends Path {

    init {
        recalculateShape();
    }

    function recalculateShape() {
        def a = Asterisk{
            centerX: centerX
            centerY: centerY
            beams:4
            radius: radius
            roundness: roundness
            width: width
        };
        elements = a.elements;
//        translateX = centerX;
//        translateY = centerY;
    }

    /**
     * Defines the radius of the cross in pixels.
     * @defaultvalue 40
     */
    public var radius:Number = 40 on replace {
        recalculateShape();
    }

    /**
     * Defines the width (thickness) of each arm of the cross.
     * @defaultvalue 30
     */
    public var width:Number = 30 on replace {
        recalculateShape();
    }

    /**
     * Defines the horizontal position of the center of the cross in pixels.
     * @defaultvalue 0
     */
    public var centerX:Number on replace {
        recalculateShape();
    }

    /**
     * Defines the vertical position of the center of the cross in pixels.
     * @defaultvalue 0
     */
    public var centerY:Number on replace {
        recalculateShape();
    }
    /**
     * Defines the roundness of the outside corners of the cross.  The range is from 0.0 to 1.0.
     * The higher the value the more round the corners will be.
     * @defaultvalue 0
     */
    public var roundness:Number = 0 on replace {
        recalculateShape();
    }
}