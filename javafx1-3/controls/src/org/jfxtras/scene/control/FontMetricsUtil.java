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

package org.jfxtras.scene.control;

import com.sun.javafx.tk.FontMetrics;
import javafx.scene.text.Font;

/**
 *
 */
public class FontMetricsUtil {
    public static void setFont(final FontMetrics fontMetrics, Font font) {
        if (fontMetrics != null) fontMetrics.set$font(font);
    }

    public static void setMaxAscent(final FontMetrics fontMetrics, float maxAscent) {
        if (fontMetrics != null) fontMetrics.set$maxAscent(maxAscent);
    }

    public static void setMaxDescent(final FontMetrics fontMetrics, float maxDescent) {
        if (fontMetrics != null) fontMetrics.set$maxDescent(maxDescent);
    }

    public static void setAscent(final FontMetrics fontMetrics, float ascent) {
        if (fontMetrics != null) fontMetrics.set$ascent(ascent);
    }

    public static void setBaseline(final FontMetrics fontMetrics, int baseline) {
        if (fontMetrics != null) fontMetrics.set$baseline(baseline);
    }

    public static void setLeading(final FontMetrics fontMetrics, float leading) {
        if (fontMetrics != null) fontMetrics.set$leading(leading);
    }

    public static void setLineHeight(final FontMetrics fontMetrics, float lineHeight) {
        if (fontMetrics != null) fontMetrics.set$lineHeight(lineHeight);
    }

    public static void setXheight(final FontMetrics fontMetrics, float xheight) {
        if (fontMetrics != null) fontMetrics.set$xheight(xheight);
    }

    public static void copy(final FontMetrics src, final FontMetrics dst) {
        if (src != null && dst != null) {
            dst.set$ascent(src.$ascent);
            dst.set$baseline(src.$baseline);
            dst.set$descent(src.$descent);
            dst.set$font(src.$font);
            dst.set$leading(src.$leading);
            dst.set$lineHeight(src.$lineHeight);
            dst.set$maxAscent(src.$maxAscent);
            dst.set$maxDescent(src.$maxDescent);
            dst.set$xheight(src.$xheight);
        }
    }
}
