/*
 * Copyright (c) 2009, Sten Anderson, CITYTECH, INC.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 * 1. Redistributions of source code must retain the above copyright notice,
 *    this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 * 3. Neither the name of CITYTECH, INC. nor the names of its contributors may be used
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
 
package com.citytechinc.ria.musicexplorerfx;

import com.citytechinc.ria.musicexplorerfx.InfoItem;
import com.citytechinc.ria.musicexplorerfx.util.BareBonesBrowserLauncher;
import javafx.scene.CustomNode;
import javafx.scene.effect.Effect;
import javafx.scene.effect.Glow;
import javafx.scene.Group;
import javafx.scene.input.MouseEvent;
import javafx.scene.Node;
import javafx.scene.paint.Color;
import javafx.scene.paint.LinearGradient;
import javafx.scene.paint.Stop;
import javafx.scene.shape.Rectangle;
import javafx.scene.text.Font;
import javafx.scene.text.Text;

/**
 * @author sanderson
 */

public class InfoButton extends CustomNode {

    public var item: InfoItem;
    public var w: Number on replace {updateBounds()};
    public var x: Number;
    public var y: Number;
    public var active = true;

    var curEffect: Effect;
    var title:Text;

    public var group: Group;

    override public function create():Node {
        title = Text {
            fill: Color.WHITE
            content: item.title
            wrappingWidth: bind w
            font: Font {
                size: 16
            }

        }
        var titleHeight = title.boundsInLocal.height;
        var summary = Text {
            fill: Color.WHITE
            content: cleanString(item.summary)
            wrappingWidth: bind w
            y: titleHeight
        }
        var totalHeight = titleHeight + summary.boundsInLocal.height;
        updateBounds();
        group = Group {
            translateX: bind x
            translateY: y
            effect: bind curEffect
            onMouseEntered: function(e:MouseEvent) {
                curEffect = Glow {
                    level: 0.8
                }
            }
            onMouseExited: function(e:MouseEvent) {
                curEffect = null;
            }
            onMouseClicked: function(e:MouseEvent) {
                if (not active) {
                    return;
                }

                if (item.url != null) {
                    BareBonesBrowserLauncher.openURL(item.url);
                }

            }

            content: [
                Rectangle {
                    cache: true
                    fill: LinearGradient {
                        proportional: true
                        startX: 0
                        startY: 0
                        endX: 0
                        endY: 1//rectHeight
                        stops: [
                            Stop {
                                offset: 0.0
                                color: Color {
                                    red: 0,
                                    green: 0.2,
                                    blue: 0.3
                                }
                            },
                            Stop {
                                offset: 0.2
                                color: Color {
                                    red: 0,
                                    green: 0.1,
                                    blue: 0.2
                                }
                            },
                            Stop {
                                offset: 0.8
                                color: Color.BLACK
                            }
                        ]
                    }
                    width: bind w + x
                    height: titleHeight + 20
                    x: bind -x
                    y: -15
                }
                Rectangle {
                    fill: Color.BLACK
                    width: bind w
                    height: summary.boundsInLocal.height
                    y: titleHeight
                },
                title,
                summary
            ]
        }

    }

    function updateBounds() {
        title.translateX = w / 2 - title.boundsInLocal.width / 2;
    }

    function cleanString(str:String):String {
        str.replaceAll("<span>", "").replaceAll("</span>", "");
    }



}
