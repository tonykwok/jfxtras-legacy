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
 
 /*
 * InfoNode.fx
 *
 * Created on Mar 16, 2009, 2:09:39 PM
 */

package com.citytechinc.ria.musicexplorerfx;

import com.citytechinc.ria.musicexplorerfx.model.Artist;
import javafx.animation.transition.FadeTransition;
import javafx.animation.transition.TranslateTransition;
import javafx.scene.CustomNode;
import javafx.scene.Group;
import javafx.scene.Node;
import javafx.scene.paint.Color;
import javafx.scene.paint.LinearGradient;
import javafx.scene.paint.Stop;
import javafx.scene.shape.Polygon;
import javafx.scene.shape.Rectangle;
import javafx.scene.text.Font;
import javafx.scene.text.Text;

/**
 * An InfoNode corresponds to a "titled" box in "Info Mode",
 * (e.g. "Videos", "Reviews", "News", etc.)
 *
 * @author sanderson
 */

public class InfoNode extends CustomNode {

    public var title: String;
    public var x: Number;
    public var y: Number;
    public var artist: Artist;
    public var items: InfoItem[];
    public var mode:Mode;
    public var w: Number;

    public var h: Number;

    var rectOffsetX = bind w * 0.05;
    var rectOffsetY = bind h * 0.15;
    var centerX:Number = bind w / 2;
    var centerY:Number = bind h / 2;

    var textWidth = bind w - rectOffsetX;
    var textX = bind rectOffsetX / 2;
    var textY: Number;

    var titleText:Text;
    var noItems:Text;

    var buttons: InfoButton[];
    var buttonGroup:Group;
    var topButton = 0;

    var scrollUp:ScrollButton;
    var scrollDown:ScrollButton;

    override public function create():Node {
        var darkerColor = Color {
            red: 0.0,
            green: 0.1,
            blue: 0.2
        };
        var darkColor = Color {
            red: 0.0,
            green: 0.1,
            blue: 0.3
        };
        var medColor = Color {
            red: 0.2,
            green: 0.4,
            blue: 0.6
        };
        titleText = Text {
            content: title
            y: 20
            fill: Color.WHITESMOKE
            font: Font {
                size: 20
            }

        }

        var scrollUpY = rectOffsetY * 0.75;
        var buttonHeight = 15;
        var arrowWidth = 10;
        scrollUp = ScrollButton {
            x: textX
            y: scrollUpY
            h: buttonHeight
            w: bind textWidth
            action: doScrollUp
            arrow: Polygon {
                fill: Color.BLACK
                points: bind [
                    centerX - arrowWidth, buttonHeight - 4,
                    centerX + arrowWidth, buttonHeight - 4,
                    centerX, 3

                ]
            }
        }
        textY = scrollUpY + scrollUp.boundsInLocal.height;

        noItems = Text {
            visible: sizeof items == 0
            fill: Color.WHITESMOKE
            content: "No {title} Found"
            y: h / 2
        }

        var textRect = Rectangle {
            fill: Color.BLACK
            arcWidth: 5
            arcHeight: 5
            width: bind textWidth
            height: bind h - rectOffsetY - scrollUp.boundsInLocal.height * 2 // two scroll buttons
            x: textX
            y: textY
        }

        var clipRect = Rectangle {
            x: textX
            y: textY
            width: bind textWidth
            height: bind textRect.height
        }


        scrollDown = ScrollButton {
            x: textX
            y: bind textY + textRect.height
            h: buttonHeight
            w: bind textWidth
            action: doScrollDown
            arrow: Polygon {
                fill: Color.BLACK
                points: bind [
                    centerX - arrowWidth, 3,
                    centerX + arrowWidth, 3,
                    centerX, buttonHeight - 4

                ]
            }
        }

        buttons = createItemButtons();

        buttonGroup = Group {
            content:[buttons]
        }

        updateBounds();

        checkScroll(); // enable/disable the scroll buttons
        Group {
            content: [
                
                Rectangle {
                    cache: true
                    fill: LinearGradient {
                        startX: 0
                        startY: 0
                        endX: 0
                        endY: 1
                        stops: [
                            Stop {
                                offset: 0.0
                                color: medColor
                            },
                            Stop {
                                offset: 0.1
                                color: darkColor
                            },
                            Stop {
                                offset: 1.0
                                color: darkerColor
                            }
                        ]
                    }
                    arcWidth: 5
                    arcHeight: 5
                    width: bind w
                    height: bind h
                },
                
                titleText,
                textRect,
                noItems,
                Group {
                    content: [buttonGroup]
                    clip: clipRect
                },
                
                scrollUp,
                scrollDown
                
            ]
        }

    }

    public function activateButtons(b:Boolean) {
        for (button in buttons) {
            button.active = b;
        }

    }


    public function updateBounds() {
        titleText.x = centerX - titleText.boundsInLocal.width / 2;
        noItems.x = w / 2 - noItems.boundsInLocal.width / 2;

        translateX = x - centerX;
        translateY = y - centerY;
    }


    function checkScroll():Void {
        scrollDown.canScroll = (topButton + 1) < sizeof buttons;
        scrollUp.canScroll = topButton > 0;
    }

    function doScroll(amount:Number) {
        scrollUp.canScroll = false;
        scrollDown.canScroll = false;
        TranslateTransition {
            node: buttonGroup
            byY: amount
            duration: 0.4s
            action: function() { checkScroll() }
        }.play();
    }


    var doScrollDown = function():Void {
        doScroll(-buttons[topButton].boundsInLocal.height);
        topButton++;
    }

    var doScrollUp = function():Void {
        doScroll(buttons[topButton - 1].boundsInLocal.height);
        topButton--;
    }


    function createItemButtons():InfoButton[] {
        var curY = textY + 16;
        for (i in items) {
            var button = InfoButton {
                item: i
                w: bind textWidth
                x: bind textX
                y: curY
            }
            curY += button.boundsInLocal.height;

            button;
        }
    }

    public function dismiss() {
        FadeTransition {
            action: function():Void { mode.removeNode(this); }
            node: this
            duration: 0.8s
            fromValue: 1
            toValue: 0
        }.play();
    }


    public function intro():Void {

        this.cache = true;
        FadeTransition {
            node: this
            duration: 1s
            fromValue: 0
            toValue: 1
        }.play();

    }


}


