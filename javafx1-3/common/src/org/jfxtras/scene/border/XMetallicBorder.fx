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
import javafx.scene.paint.Color;
import javafx.scene.paint.LinearGradient;
import javafx.scene.paint.Stop;
import javafx.scene.shape.Polygon;
import javafx.scene.shape.Rectangle;

/**
 * @author jclarke
 */
public class XMetallicBorder extends XRaisedBorder {
    override var borderWidth = 20;

    /**
     * defines the outer color of the gradient, upper left and lower right color
     * @defaultvalue #848A96
     * @css outer
     */
    public var outer: Color = Color.web("#848A96");

    /**
     * defines the inner color of the gradient
     * @defaultvalue white
     * @css inner
     */
    public var inner: Color = Color.WHITE;

    def metallicBorder = Group {
        translateX: bind borderX
        translateY: bind borderY
        content: [
            Polygon { // left
                points: bind [
                    0.0, 0.0,
                    borderLeftWidth / 4, borderTopWidth / 4,
                    borderLeftWidth / 4,heightOfBorder - borderBottomWidth / 4,
                    0.0, heightOfBorder
                ]

                fill: bind if(raised) LinearGradient {
                    endX: 1
                    endY: 0
                    stops: [
                        Stop {
                            offset: 0.0
                            color: outer
                        },
                        Stop {
                            offset: 0.8
                            color: inner
                        },
                        Stop {
                            offset: 1.0
                            color: outer
                        },
                    ]
                } else LinearGradient {
                    endX: 1
                    endY: 0
                    stops: [
                        Stop {
                            offset: 0.0
                            color: inner
                        },
                        Stop {
                            offset: 0.8
                            color: outer
                        },
                        Stop {
                            offset: 1.0
                            color: inner
                        },
                    ]
                }
            },
            Polygon { // top
                points: bind [
                    0.0, 0.0,
                    borderLeftWidth / 4, borderTopWidth / 4,
                    widthOfBorder - borderRightWidth / 4,borderTopWidth / 4,
                    widthOfBorder, 0.0,
                ]
                fill: bind if(raised) LinearGradient {
                    endX: 0
                    endY: 1
                    stops: [
                        Stop {
                            offset: 0.0
                            color: outer
                        },
                        Stop {
                            offset: 0.8
                            color: inner
                        },
                        Stop {
                            offset: 1.0
                            color: outer
                        },
                    ]
                }else LinearGradient {
                    endX: 0
                    endY: 1
                    stops: [
                        Stop {
                            offset: 0.0
                            color: inner
                        },
                        Stop {
                            offset: 0.8
                            color: outer
                        },
                        Stop {
                            offset: 1.0
                            color: inner
                        },
                    ]
                }
            },
            Polygon { // right
                points: bind [
                    widthOfBorder, 0.0,
                    widthOfBorder - borderRightWidth / 4,borderTopWidth / 4,
                    widthOfBorder - borderRightWidth / 4,heightOfBorder - borderBottomWidth / 4,
                    widthOfBorder, heightOfBorder
                ]
                fill: bind if(raised) LinearGradient {
                    endX: 1
                    endY: 0
                    stops: [
                        Stop {
                            offset: 0.0
                            color: outer
                        },
                        Stop {
                            offset: 0.8
                            color: inner
                        },
                        Stop {
                            offset: 1.0
                            color: outer
                        },
                    ]
                } else LinearGradient {
                    endX: 1
                    endY: 0
                    stops: [
                        Stop {
                            offset: 0.0
                            color: inner
                        },
                        Stop {
                            offset: 0.8
                            color: outer
                        },
                        Stop {
                            offset: 1.0
                            color: inner
                        },
                    ]
                }
            },
            Polygon { // bottom
                points: bind [
                    0.0, heightOfBorder,
                    borderLeftWidth / 4, heightOfBorder - borderBottomWidth / 4,
                    widthOfBorder - borderRightWidth / 4, heightOfBorder - borderBottomWidth / 4,
                    widthOfBorder, heightOfBorder
                ]
                fill: bind if(raised) LinearGradient {
                    endX: 0
                    endY: 1
                    stops: [
                        Stop {
                            offset: 0.0
                            color: outer
                        },
                        Stop {
                            offset: 0.8
                            color: inner
                        },
                        Stop {
                            offset: 1.0
                            color: outer
                        },
                    ]
                } else LinearGradient {
                    endX: 0
                    endY: 1
                    stops: [
                        Stop {
                            offset: 0.0
                            color: inner
                        },
                        Stop {
                            offset: 0.8
                            color: outer
                        },
                        Stop {
                            offset: 1.0
                            color: inner
                        },
                    ]
                }
            },
        ]
    }

    function getRaisedBackground() : Group {
        Group {
            content: [
                Rectangle {
                    layoutX: borderX
                    layoutY: borderY
                    width: bind widthOfBorder
                    height: bind heightOfBorder
                    fill: LinearGradient {
                        proportional: false
                        startX: 0.0
                        startY: 0.0
                        endX: widthOfBorder
                        endY: heightOfBorder
                        stops: [
                            Stop {
                                offset: 0.0
                                color: outer
                            },
                            Stop {
                                offset: 0.5
                                color: inner
                            },
                            Stop {
                                offset: 1.0
                                color: outer
                            },
                        ]
                    }
                }
            ]
        }
    }

    function getLoweredBackground() : Group {
        Group {
            content: [
                Rectangle {
                    //x: borderX
                    //y: borderY
                    layoutX: borderX
                    layoutY: borderY
                    width: widthOfBorder
                    height: heightOfBorder
                    fill: LinearGradient {
                        proportional: false
                        startX: 0.0
                        startY: 0.0
                        endX: widthOfBorder
                        endY: heightOfBorder
                        stops: [
                            Stop {
                                offset: 0.0
                                color: inner
                            },
                            Stop {
                                offset: 0.5
                                color: outer
                            },
                            Stop {
                                offset: 1.0
                                color: inner
                            },
                        ]
                    }
                }
            ]
        }
    }

    public override function doBorderLayout(x:Number, y:Number, w:Number, h:Number):Void {
        widthOfBorder = w;
        heightOfBorder = h;
        borderY = y;
        borderX = x;
        background =if(raised) getRaisedBackground() else getLoweredBackground();
        border = metallicBorder;
    }
}
