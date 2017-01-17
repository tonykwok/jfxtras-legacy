/*
 * Copyright (c) 2008-2009, JFXtras Group
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
 * @author Stephen Chin
 */
public class ColorUtil {}

public function deriveRGB(base:Color, opacity:Number):Color {
    Color.color(base.red, base.green, base.blue, opacity)
}

public function deriveGBA(base:Color, red:Number):Color {
    Color.color(red, base.green, base.blue, base.opacity)
}

public function deriveRBA(base:Color, green:Number):Color {
    Color.color(base.red, green, base.blue, base.opacity)
}

public function deriveRGA(base:Color, blue:Number):Color {
    Color.color(base.red, base.green, blue, base.opacity)
}

public function deriveRG(base:Color, blue:Number, opacity:Number):Color {
    Color.color(base.red, base.green, blue, opacity)
}

public function deriveRB(base:Color, green:Number, opacity:Number):Color {
    Color.color(base.red, green, base.blue, opacity)
}

public function deriveRA(base:Color, green:Number, blue:Number):Color {
    Color.color(base.red, green, blue, base.opacity)
}

public function deriveGB(base:Color, red:Number, opacity:Number):Color {
    Color.color(red, base.green, base.blue, opacity)
}

public function deriveGA(base:Color, red:Number, blue:Number):Color {
    Color.color(red, base.green, blue, base.opacity)
}

public function deriveBA(base:Color, red:Number, green:Number):Color {
    Color.color(red, green, base.blue, base.opacity)
}

public function deriveR(base:Color, green:Number, blue:Number, opacity:Number):Color {
    Color.color(base.red, green, blue, opacity)
}

public function deriveG(base:Color, red:Number, blue:Number, opacity:Number):Color {
    Color.color(red, base.green, blue, opacity)
}

public function deriveB(base:Color, red:Number, green:Number, opacity:Number):Color {
    Color.color(red, green, base.blue, opacity)
}

public function deriveA(base:Color, red:Number, green:Number, blue:Number):Color {
    Color.color(red, green, blue, base.opacity)
}
