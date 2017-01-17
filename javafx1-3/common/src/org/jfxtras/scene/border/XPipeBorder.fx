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
import javafx.scene.paint.LinearGradient;
import javafx.scene.paint.Stop;
import javafx.scene.shape.Polygon;
import com.sun.javafx.UtilsFX;

/**
 * @author jclarke
 */
public class XPipeBorder extends XRaisedBorder {

    override var borderWidth = 15;

    var highlightOuter = UtilsFX.deriveColor(highlightInner, .80)
            on replace { requestLayout(); };

    def pipeBorder = Group {
            // offset for line stroke
            layoutX: bind borderX;// + lineWidth/2
            layoutY: bind borderY;// + lineWidth/2
            content: [
                Polygon { // left
                    points: bind [
                        0.0, 0.0,
                        borderLeftWidth, borderTopWidth,
                        borderLeftWidth,heightOfBorder - borderBottomWidth,
                        0.0, heightOfBorder
                    ]
                    fill: bind if(raised) LinearGradient {
                        endX: 1
                        endY: 0
                        stops: [
                            Stop {
                                offset: 0.0
                                color: highlight
                            },
                            Stop {
                                offset: 0.5
                                color: highlightOuter
                            },
                            Stop {
                                offset: 1.0
                                color: highlight
                            },
                        ]
                    } else LinearGradient {
                        endX: 1
                        endY: 0
                        stops: [
                            Stop {
                                offset: 0.0
                                color: highlightOuter
                            },
                            Stop {
                                offset: 0.5
                                color: highlight
                            },
                            Stop {
                                offset: 1.0
                                color: highlightOuter
                            },
                        ]
                    }
                },
                Polygon { // top
                    points: bind [
                        0.0, 0.0,
                        borderLeftWidth, borderTopWidth,
                        widthOfBorder - borderRightWidth,borderTopWidth,
                        widthOfBorder, 0.0,
                    ]
                    fill: bind if (raised) LinearGradient {
                        endX: 0
                        endY: 1
                        stops: [
                            Stop {
                                offset: 0.0
                                color: highlight
                            },
                            Stop {
                                offset: 0.5
                                color: highlightOuter
                            },
                            Stop {
                                offset: 1.0
                                color: highlight
                            },
                        ]
                    } else LinearGradient {
                        endX: 0
                        endY: 1
                        stops: [
                            Stop {
                                offset: 0.0
                                color: highlightOuter
                            },
                            Stop {
                                offset: 0.5
                                color: highlight
                            },
                            Stop {
                                offset: 1.0
                                color: highlightOuter
                            },
                        ]
                    }
                },
                Polygon { // right
                    points: bind [
                        widthOfBorder, 0.0,
                        widthOfBorder - borderRightWidth,borderTopWidth,
                        widthOfBorder - borderRightWidth,heightOfBorder - borderBottomWidth,
                        widthOfBorder, heightOfBorder
                    ]
                    fill: bind if (raised) LinearGradient {
                        endX: 1
                        endY: 0
                        stops: [
                            Stop {
                                offset: 0.0
                                color: highlight
                            },
                            Stop {
                                offset: 0.5
                                color: highlightOuter
                            },
                            Stop {
                                offset: 1.0
                                color: highlight
                            },
                        ]
                    }else LinearGradient {
                        endX: 1
                        endY: 0
                        stops: [
                            Stop {
                                offset: 0.0
                                color: highlightOuter
                            },
                            Stop {
                                offset: 0.5
                                color: highlight
                            },
                            Stop {
                                offset: 1.0
                                color: highlightOuter
                            },
                        ]
                    }
                },
                Polygon { // bottom
                    points: bind [
                        0.0, heightOfBorder,
                        borderLeftWidth, heightOfBorder - borderBottomWidth,
                        widthOfBorder - borderRightWidth, heightOfBorder - borderBottomWidth,
                        widthOfBorder, heightOfBorder
                    ]
                    fill: bind if(raised) LinearGradient {
                        endX: 0
                        endY: 1
                        stops: [
                            Stop {
                                offset: 0.0
                                color: highlight
                            },
                            Stop {
                                offset: 0.5
                                color: highlightOuter
                            },
                            Stop {
                                offset: 1.0
                                color: highlight
                            },
                        ]
                    } else LinearGradient {
                        endX: 0
                        endY: 1
                        stops: [
                            Stop {
                                offset: 0.0
                                color: highlightOuter
                            },
                            Stop {
                                offset: 0.5
                                color: highlight
                            },
                            Stop {
                                offset: 1.0
                                color: highlightOuter
                            },
                        ]
                    }
                },
            ]
        };



    public override function doBorderLayout(x:Number, y: Number,
                                    w: Number, h: Number) :  Void {
        widthOfBorder = w;
        heightOfBorder = h;
        borderY = y;
        borderX = x;
        border = pipeBorder;
    }


}
