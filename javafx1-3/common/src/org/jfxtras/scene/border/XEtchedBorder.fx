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
import javafx.scene.shape.Rectangle;

/**
 * @author jclarke
 */
public class XEtchedBorder extends XRaisedBorder {

    //function getRaisedBorder(x: Number, y: Number, widthOfBorder:Number, heightOfBorder:Number): Node {
    def borderGroup = Group {
            // offset for line stroke
            layoutX: bind borderX + lineWidth/2
            layoutY: bind borderY + lineWidth/2
            content: [
                Rectangle {
                    width: bind widthOfBorder-2*lineWidth// - lineWidth/2
                    height: bind heightOfBorder - 2*lineWidth// - lineWidth/2
                    stroke: bind if(raised) highlight else shadow
                    strokeWidth: bind lineWidth
                    fill: null
                },
                Polyline {
                    stroke: bind if(raised) shadow else highlight
                    strokeWidth: bind lineWidth
                    points:  bind [
                        lineWidth, heightOfBorder - 2*lineWidth,
                        lineWidth, lineWidth,
                        widthOfBorder-2*lineWidth, lineWidth
                    ]
                },
                Polyline {
                    stroke: bind if(raised) shadow else highlight
                    strokeWidth: bind lineWidth
                    points:  bind [
                        0, heightOfBorder - lineWidth,
                        widthOfBorder - lineWidth, heightOfBorder - lineWidth,
                        widthOfBorder -lineWidth, 0
                    ]
                },


            ]
        };


    public override function doBorderLayout(x:Number, y:Number, w:Number, h:Number):Void {
        widthOfBorder = w;
        heightOfBorder = h;
        borderY = y;
        borderX = x;
        border = borderGroup;
    }
}
