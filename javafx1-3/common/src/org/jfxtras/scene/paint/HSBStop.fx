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

import javafx.scene.paint.Stop;
import javafx.util.Math;

/**
 * This class is used in XHSBLinearGradient and XHSBRadialGradient
 *
 * @profile common
 *
 * @author Liu Huasong
 */
public class HSBStop extends Stop {
    /**
     * The hsbColor of this stop, you need not to specify the color.
     */
    public-init var hsbColor:HSBColor;

    init {
        PaintUtil.setColor(this, hsbColor);
    }
}

/**
 * Interpolate a HSBStop[]
 */
public function toRGB(hsbStops:HSBStop[]):HSBStop[] {
    def len = sizeof hsbStops;
    if (len < 2) {
        return hsbStops;
    }
    var rgbStops:HSBStop[];
    var i = 0;
    while (i < len - 1) {
        def h0 = hsbStops[i].hsbColor.h;
        def h1 = hsbStops[i+1].hsbColor.h;
        def hueDiff = Math.abs(h1 - h0);
        insert hsbStops[i] into rgbStops;
        if (h1 != h0) {
            def modH0 = h0 mod 60;
            var next:Number;
            if (h0 < 0) {
                if (h1 > h0) {
                    next = h0 - modH0;
                } else {
                    next = h0 - (60 + modH0);
                }
            } else {
                if (h1 > h0) {
                    next = h0 + (60 - modH0);
                } else {
                    next = h0 - modH0;
                }
            }
            def step = if (h1 > h0) 60 else -60;
            while (if (h1 > h0) next < h1 else next < h0) {
                def th = Math.abs(next - h0) / hueDiff;
                var offset0 = hsbStops[i].offset;
                def offset1 = hsbStops[i+1].offset;
                if (offset0 != offset1) {
                    offset0 += (offset1 - offset0) * th
                }
                def hsbColor = hsbStops[i].hsbColor.ofTheWay(hsbStops[i+1].hsbColor, th) as HSBColor;
                insert HSBStop{offset:offset0 hsbColor:hsbColor} into rgbStops;
                next += step;
            }
        }
        i++;
    }
    insert hsbStops[i] into rgbStops;
    rgbStops
}
