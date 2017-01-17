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

/**
 * <p>The {@code Astroid} class defines a hypocycloid with four cusps.  See http://en.wikipedia.org/wiki/Astroid</p>
 *
    @example
    import org.jfxtras.scene.shape.Astroid;
    import javafx.scene.paint.*;

    Astroid {
        centerX: 40
        centerY: 40
        radius: 30
        fill: Color.BLACK
    }
    @endexample
 *
 * @profile desktop
 *
 * @author Steven Bixby
 * @author Dean Iverson
 */
public class Astroid extends Path {
    init {
        recalculatePath();
    }

    function recalculatePath() {
        elements = [
            MoveTo {
                x: centerX + radius
                y: centerY
            },
            ArcTo {
                x: centerX
                y: centerY + radius
                radiusX: radius
                radiusY: radius
            },
            ArcTo {
                x: centerX - radius
                y: centerY
                radiusX: radius
                radiusY: radius
            },
            ArcTo {
                x: centerX
                y: centerY - radius
                radiusX: radius
                radiusY: radius
            },
            ArcTo {
                x: centerX + radius
                y: centerY
                radiusX: radius
                radiusY: radius
            }
        ]
    }

    /**
     * Defines the radius of the astroid in pixels.
     * @defaultvalue 40
     */
    public var radius:Number = 40 on replace {
        recalculatePath();
    }

    /**
     * Defines the horizontal position of the center of the astroid in pixels.
     * @defaultvalue 0
     */
    public var centerX:Number on replace {
        recalculatePath();
    }

    /**
     * Defines the vertical position of the center of the astroid in pixels.
     * @defaultvalue 0
     */
    public var centerY:Number on replace {
        recalculatePath();
    }
}
