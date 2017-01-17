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
import javafx.scene.shape.LineTo;


/**
 * <p>The {@code RoundPin} class defines a cone with a rounded top.<p>
 *
    @example
    import org.jfxtras.scene.shape.RoundPin;
    import javafx.scene.paint.*;

    RoundPin {
        centerX: 50
        centerY: 50
        radius: 40
        height: 80
        fill: Color.BLACK
    }
    @endexample
 *
 * @profile desktop
 *
 * @author Steven Bixby
 * @author Andres Almiray <aalmiray@users.sourceforge.net>
 */
public class RoundPin extends Path {
    init {
        recalculateShape();
    }

    function recalculateShape() {
        elements = [
            MoveTo { x: centerX + radius; y: centerY },
            if (radius > 0.0) then
                ArcTo  { x: centerX - radius; y: centerY; radiusX:radius; radiusY:radius } else null,
            LineTo { x: centerX; y: centerY+height },
            LineTo { x: centerX + radius; y: centerY },
        ];
    }

    /**
     * Defines the horizontal position of the center of the pin in pixels.
     * @defaultvalue 0.0
     */
    public var centerX:Number on replace {
        recalculateShape();
    }

    /**
     * Defines the vertical position of the center of the pin in pixels.
     * @defaultvalue 0.0
     */
    public var centerY:Number on replace {
        recalculateShape();
    }

    /**
     * Defines the radius of the pin in pixels.
     * @defaultvalue 20
     */
    public var radius:Number = 20 on replace {
        recalculateShape();
    }

    /**
     * Defines the height of the pin in pixels.
     * @defaultvalue 40
     */
    public var height:Number = 40 on replace {
        recalculateShape();
    }
}
