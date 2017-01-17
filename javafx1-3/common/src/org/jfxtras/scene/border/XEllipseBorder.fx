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
import javafx.scene.shape.Arc;
import javafx.scene.shape.ArcType;
import javafx.scene.shape.Ellipse;

/**
 * @author jclarke
 */
public class XEllipseBorder extends XRaisedBorder {
    def centerX = bind widthOfBorder / 2;
    def centerY = bind heightOfBorder / 2;
    def radiusX =  bind widthOfBorder / 2;
    def radiusY = bind heightOfBorder / 2;

    override var clip = Ellipse {
        centerX: bind centerX + borderX
        centerY: bind centerY + borderY
        radiusX: bind radiusX
        radiusY: bind radiusY
    }

    def ellipseBorder = Group {
            layoutX: bind borderX //+ lineWidth/2
            layoutY: bind borderY //+ lineWidth/2
            content: [
                Arc {
                    centerX: bind centerX
                    centerY: bind centerY
                    radiusX: bind radiusX - lineWidth/2
                    radiusY: bind radiusY - lineWidth/2
                    type: ArcType.OPEN
                    startAngle: 45
                    length: 180
                    fill: null
                    stroke: bind  if(raised) highlight else shadow
                    strokeWidth: bind lineWidth
                },
                Arc {
                    centerX: bind centerX
                    centerY: bind centerY
                    radiusX: bind radiusX - lineWidth-lineWidth/2
                    radiusY: bind radiusY - lineWidth-lineWidth/2
                    type: ArcType.OPEN
                    startAngle: 45
                    length: 180
                    fill: null
                    stroke: bind if(raised) highlightInner else shadowOuter
                    strokeWidth: bind lineWidth
                },
                Arc {
                    centerX: bind centerX
                    centerY: bind centerY
                    radiusX: bind radiusX - lineWidth/2
                    radiusY: bind radiusY - lineWidth/2
                    type: ArcType.OPEN
                    startAngle: 225
                    length: 180
                    fill: null
                    stroke: bind if(raised) shadowOuter else highlight
                    strokeWidth: bind lineWidth
                },
                Arc {
                    centerX: bind centerX
                    centerY: bind centerY
                    radiusX: bind radiusX - lineWidth - lineWidth/2
                    radiusY: bind radiusY - lineWidth - lineWidth/2
                    type: ArcType.OPEN
                    startAngle: 225
                    length: 180
                    fill: null
                    stroke: bind if(raised) shadow else highlightInner
                    strokeWidth: bind lineWidth
                },
            ]
    };

    override function doBorderLayout(x:Number, y:Number, w:Number, h:Number):Void {
        widthOfBorder = w;
        heightOfBorder = h;
        borderY = y;
        borderX = x;
        border = ellipseBorder;
    }
}
