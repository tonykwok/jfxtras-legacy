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
package com.citytechinc.ria.mefxmobile.ui.widget;

import javafx.animation.transition.TranslateTransition;
import javafx.scene.CustomNode;
import javafx.scene.Group;
import javafx.scene.Node;
import javafx.scene.paint.Color;
import javafx.scene.shape.Polygon;
import javafx.scene.shape.Rectangle;
import javafx.scene.text.Text;

import com.citytechinc.ria.mefxmobile.model.Artist;

/**
 * @author sanderson
 */

public class ArtistList extends CustomNode {

    public-init var title: String;
    public-init var x: Number;
    public-init var y: Number;
    public var artists: Artist[] on replace {createItemButtons()};
    public-init var w: Number;
    public-init var h: Number;
    public-init var action:function(:Artist):Void;

    var centerX:Number = w / 2;

    var textY: Number;

    var noItems:Text;

    var buttons: ListButton[];
    var buttonGroup:Group;
    var topButton = 0;

    var scrollUp:ScrollButton;
    var scrollDown:ScrollButton;

    override public function create():Node {
        var buttonHeight = 40;
        var arrowWidth = 10;
        scrollUp = ScrollButton {
            h: buttonHeight
            w: w
            action: doScrollUp
            arrow: Polygon {
                fill: Color.BLACK
                points: [
                    centerX - arrowWidth, buttonHeight - 4,
                    centerX + arrowWidth, buttonHeight - 4,
                    centerX, 3

                ]
            }
        }
        textY = scrollUp.boundsInLocal.height;

        noItems = Text {
            visible: bind sizeof artists == 0
            fill: Color.WHITESMOKE
            content: "No Artists Found"
            y: h / 2
        }

        var clipRect = Rectangle {
            y: textY
            width: w
            height: h - scrollUp.boundsInLocal.height * 2 // two scroll buttons
        }


        scrollDown = ScrollButton {
            y: textY + clipRect.height
            h: buttonHeight
            w: w
            action: doScrollDown
            arrow: Polygon {
                fill: Color.BLACK
                points: [
                    centerX - arrowWidth, 3,
                    centerX + arrowWidth, 3,
                    centerX, buttonHeight - 4

                ]
            }
        }

        buttonGroup = Group {
            content: bind buttons
        }

        updateBounds();

        checkScroll(); // enable/disable the scroll buttons
        Group {
            content: [
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

    public function updateBounds() {
        noItems.x = w / 2 - noItems.boundsInLocal.width / 2;

        translateX = x - centerX;
        translateY = y;
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


    function createItemButtons() {
        var curY = textY;
        topButton = 0;
        buttonGroup.translateY = 0;
        buttons = for (a in artists) {
            var button = ListButton {
                artist: a
                w: w
                y: curY
                action: action
            }
            curY += button.boundsInLocal.height;

            button;
        }
        checkScroll();
    }

}


