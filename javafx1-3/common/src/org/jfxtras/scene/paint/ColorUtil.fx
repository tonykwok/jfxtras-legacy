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

package org.jfxtras.scene.paint;

import javafx.scene.paint.Color;

/**
 * Convenience functions for manipulating Colors in JavaFX.  All the methods
 * in this class are static functions.  It may shorten the logic in your
 * application to include this file as a static import as follows:
@example
import org.jfxtras.scene.paint.ColorUtil.*;
@endexample
 *
 * @author Stephen Chin
 */
public class ColorUtil {}

/**
 * Derives a color given a base color and the new opacity value
 */
public function deriveA(base:Color, opacity:Number):Color {
    Color.color(base.red, base.green, base.blue, opacity)
}

/**
 * Derives a color given a base color and the new red value
 */
public function deriveR(base:Color, red:Number):Color {
    Color.color(red, base.green, base.blue, base.opacity)
}

/**
 * Derives a color given a base color and the new green value
 */
public function deriveG(base:Color, green:Number):Color {
    Color.color(base.red, green, base.blue, base.opacity)
}

/**
 * Derives a color given a base color and the new blue value
 */
public function deriveB(base:Color, blue:Number):Color {
    Color.color(base.red, base.green, blue, base.opacity)
}

/**
 * Derives a color given a base color and the new blue and opacity value
 */
public function deriveBA(base:Color, blue:Number, opacity:Number):Color {
    Color.color(base.red, base.green, blue, opacity)
}

/**
 * Derives a color given a base color and the new green and opacity value
 */
public function deriveGA(base:Color, green:Number, opacity:Number):Color {
    Color.color(base.red, green, base.blue, opacity)
}

/**
 * Derives a color given a base color and the new green and blue value
 */
public function deriveGB(base:Color, green:Number, blue:Number):Color {
    Color.color(base.red, green, blue, base.opacity)
}

/**
 * Derives a color given a base color and the new red and opacity value
 */
public function deriveRA(base:Color, red:Number, opacity:Number):Color {
    Color.color(red, base.green, base.blue, opacity)
}

/**
 * Derives a color given a base color and the new red and blue value
 */
public function deriveRB(base:Color, red:Number, blue:Number):Color {
    Color.color(red, base.green, blue, base.opacity)
}

/**
 * Derives a color given a base color and the new red and green value
 */
public function deriveRG(base:Color, red:Number, green:Number):Color {
    Color.color(red, green, base.blue, base.opacity)
}

/**
 * Derives a color given a base color and the new green, blue, and opacity value
 */
public function deriveGBA(base:Color, green:Number, blue:Number, opacity:Number):Color {
    Color.color(base.red, green, blue, opacity)
}

/**
 * Derives a color given a base color and the new red, blue, and opacity value
 */
public function deriveRBA(base:Color, red:Number, blue:Number, opacity:Number):Color {
    Color.color(red, base.green, blue, opacity)
}

/**
 * Derives a color given a base color and the new red, green, and opacity value
 */
public function deriveRGA(base:Color, red:Number, green:Number, opacity:Number):Color {
    Color.color(red, green, base.blue, opacity)
}

/**
 * Derives a color given a base color and the new red, green, and blue value
 */
public function deriveRGB(base:Color, red:Number, green:Number, blue:Number):Color {
    Color.color(red, green, blue, base.opacity)
}

/**
 * Makes a color darker by blending it with black by the given percentage.
 */
public function darker(base:Color, percentage:Number):Color {
    base.ofTheWay(Color.BLACK, percentage) as Color
}

/**
 * Makes a color lighter by blending it with white by the given percentage.
 */
public function lighter(base:Color, percentage:Number):Color {
    base.ofTheWay(Color.WHITE, percentage) as Color
}

/**
 * Interpolates between a start and end color by calling Color.ofTheWay with
 * the given percentage.
 */
public function interpolate(start:Color, end:Color, percentage:Number):Color {
    start.ofTheWay(end, percentage) as Color
}
