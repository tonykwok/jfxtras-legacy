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

import javafx.scene.CustomNode;
import javafx.scene.Group;
import javafx.scene.Node;
import javafx.scene.input.MouseEvent;
import javafx.scene.paint.Color;
import javafx.scene.shape.Rectangle;
import javafx.scene.text.Font;
import javafx.scene.text.Text;

import com.citytechinc.ria.mefxmobile.model.Artist;

public class ListButton extends CustomNode {

    public-init var artist:Artist;
    public-init var w: Number;
    public-init var x: Number;
    public-init var y: Number;
    public-init var action:function(:Artist):Void;

    var title:Text;

    public var group: Group;

    override public function create():Node {
        title = Text {
            fill: Color.WHITE
            content: artist.name
            wrappingWidth: w
            font: Font {
                size: 20
            }
            translateY: 30
        }
        var titleHeight = title.boundsInLocal.height;
        title.translateX = w / 2 - title.boundsInLocal.width / 2;
        group = Group {
            translateX: x
            translateY: y
            onMouseClicked: function(e:MouseEvent) {
                action(artist);
            }

            content: [
                Rectangle {
                    arcWidth: 5
                    arcHeight: 5
                    stroke: Color.WHITESMOKE
                    fill: Color {red: 0.1, green: 0.1, blue: 0.1}
                    width: w - 4;
                    height: titleHeight + 40
                }
                title
            ]
        }

    }
}
