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

 package org.jfxtras.scene.border;

import javafx.scene.Group;
import javafx.scene.shape.Polyline;


/**
 * @author jclarke
 */

public class XBevelBorder extends XRaisedBorder {

    def raisedBorder = Group {
            // offset for line stroke
            layoutX: bind borderX + lineWidth/2
            layoutY: bind borderY + lineWidth/2
            content: [
                Polyline {
                    stroke: bind highlight
                    strokeWidth: bind lineWidth
                    points:  bind [
                        0, heightOfBorder - borderWidth,
                        0, 0,
                        widthOfBorder - borderWidth, 0
                    ]
                },
                Polyline {
                    stroke: bind highlightInner
                    strokeWidth: bind lineWidth
                    points: bind [
                        lineWidth, heightOfBorder - borderWidth,
                        lineWidth, lineWidth,
                        widthOfBorder - borderWidth, lineWidth
                    ]
                },
                Polyline {
                    stroke: bind shadowOuter
                    strokeWidth: bind lineWidth
                    points: bind [
                        0, heightOfBorder - lineWidth,
                        widthOfBorder - lineWidth, heightOfBorder - lineWidth,
                        widthOfBorder - lineWidth, 0
                    ]
                },

                Polyline {
                    stroke: bind shadow
                    strokeWidth: bind lineWidth
                    points: bind [
                        lineWidth, heightOfBorder - borderWidth,
                        widthOfBorder - borderWidth, heightOfBorder - borderWidth,
                        widthOfBorder - borderWidth, lineWidth
                    ]
                }
            ]
        };

    def loweredBorder = Group {
            // offset for line stroke
            layoutX: bind borderX + lineWidth/2
            layoutY: bind borderY + lineWidth/2
            content: [
                Polyline {
                    stroke: bind shadow
                    strokeWidth: bind lineWidth
                    points: bind [
                        0, heightOfBorder - lineWidth,
                        0, 0,
                        widthOfBorder - lineWidth, 0
                    ]
                },
                Polyline {
                    stroke: bind  shadowOuter
                    strokeWidth: bind lineWidth
                    points: bind [
                        lineWidth, heightOfBorder - borderWidth,
                        lineWidth, lineWidth,
                        widthOfBorder - borderWidth, lineWidth
                    ]
                },
                Polyline {
                    stroke: bind highlight
                    strokeWidth: bind lineWidth
                    points: bind [
                        lineWidth, heightOfBorder - lineWidth,
                        widthOfBorder - lineWidth, heightOfBorder - lineWidth,
                        widthOfBorder - lineWidth, lineWidth
                    ]
                },
                Polyline {
                    stroke: bind highlightInner
                    strokeWidth: bind lineWidth
                    points: bind [
                        borderWidth, heightOfBorder - borderWidth,
                        widthOfBorder - borderWidth, heightOfBorder - borderWidth,
                        widthOfBorder - borderWidth, borderWidth
                    ]
                }

            ]
        };

    public override function doBorderLayout(x:Number, y: Number,
                                    w: Number, h: Number) :  Void {
        widthOfBorder = w;
        heightOfBorder = h;
        borderY = y;
        borderX = x;
        border = if(raised) raisedBorder else loweredBorder;
    }
}
