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
 * Convenience Class to interpolate Colors via HSB values.
@example
import org.jfxtras.scene.paint.HSBColor;
def hsbColor = HSBColor {
        h: 60
        s: 1
        b: 1
    }
@endexample
 *
 * @profile common
 *
 * @author Liu Huasong
 */
public class HSBColor extends Color {
    /** Hue of the Color */
    public-init var h:Number;
    /** Saturation of the Color */
    public-init var s:Number;
    /** Brightness of the Color */
    public-init var b:Number;

    init {
        def c = Color.hsb(h, s, b, opacity);
        PaintUtil.setRed(this, c.red);
        PaintUtil.setGreen(this, c.green);
        PaintUtil.setBlue(this, c.blue);
    }

    public override function ofTheWay(endVal:Object, t:Number): Object {
        if (t == 0) {
            this
        } else if (t == 1) {
            endVal
        } else {
            def c1 = endVal as HSBColor;
            var h0 = h;
            var s0 = s;
            var b0 = b;
            var o0 = opacity;
            def h1 = c1.h;
            def s1 = c1.s;
            def b1 = c1.b;
            def o1 = c1.opacity;
            if (h0 != h1) {
                h0 += (h1 - h0) * t;
            }
            if (s0 != s1) {
                s0 += (s1 - s0) * t;
            }
            if (b0 != b1) {
                b0 += (b1 - b0) * t;
            }
            if (o0 != o1) {
                o0 += (o1 - o0) * t;
            }
            HSBColor {
                h: h0
                s: s0
                b: b0
                opacity: o0
            }
        }
    }
}
