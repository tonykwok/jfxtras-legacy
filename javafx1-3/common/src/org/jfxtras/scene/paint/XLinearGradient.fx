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

import javafx.animation.Interpolatable;
import javafx.scene.paint.LinearGradient;
import javafx.scene.paint.Stop;
import javafx.scene.paint.Color;
import java.lang.RuntimeException;

/**
 * This is a Interpolatable LinearGradient.
 *
 * @profile common
 *
 * @author Liu Huasong
 */
public class XLinearGradient extends LinearGradient, Interpolatable {
    public override function ofTheWay(endVal:Object, t:Number): Object {
        if (t == 0) {
            this
        } else if (t == 1) {
            endVal
        } else {
            def g1 = endVal as LinearGradient;
            var startX0 = startX;
            var startY0 = startY;
            var endX0 = endX;
            var endY0 = endY;
            def startX1 = g1.startX;
            def startY1 = g1.startY;
            def endX1 = g1.endX;
            def endY1 = g1.endY;
            if (startX0 != startX1) {
                startX0 += (startX1 - startX0) * t;
            }
            if (startY0 != startY1) {
                startY0 += (startY1 - startY0) * t;
            }
            if (endX0 != endX1) {
                endX0 += (endX1 - endX0) * t;
            }
            if (endY0 != endY1) {
                endY0 += (endY1 - endY0) * t;
            }
            def stops0 = this.stops;
            def stops1 = g1.stops;
            var stopsNew:Stop[];
            def len0 = sizeof stops0;
            def len1 = sizeof stops1;
            if (len0 != len1) {
                throw new RuntimeException("Lengths of two stops must be equal.");
            }
            var i = 0;
            while (i < len0) {
                if (stops0[i].offset == stops1[i].offset) {
                   def color = stops0[i].color.ofTheWay(stops1[i].color, t) as Color;
                   insert Stop{offset:stops0[i].offset color:color} into stopsNew;
                   i++;
                } else {
                    throw new RuntimeException("stop offsets of two stops must be equal.");
                }
            }
            LinearGradient {
                startX: startX0
                startY: startY0
                endX: endX0
                endY: endY0
                cycleMethod: cycleMethod
                proportional: proportional
                stops: stopsNew
            }
        }
    }
}
