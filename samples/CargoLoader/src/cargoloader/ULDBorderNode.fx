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
package cargoloader;

import javafx.scene.CustomNode;
import javafx.scene.Node;
import javafx.scene.input.MouseEvent;
import javafx.scene.paint.Color;
import javafx.scene.shape.Rectangle;
import javafx.scene.Cursor;
//import richtooltip.RichToolTip;
import javafx.scene.Group;
import javafx.scene.control.Tooltip;
import javafx.scene.text.Text;
import javafx.scene.text.Font;

/**
 * the border that highlights on the mouse hover event on cargo containers or unit load devices (ULD)
 * @author Abhilshit Soni
 */
public class ULDBorderNode extends CustomNode {

    public var toolTip: Tooltip = Tooltip {
                text: "ULD ID: 56746LX"
            }
    public var borderFill = Color.CADETBLUE;
    public var uldBorder: Rectangle = Rectangle {
                width: 63, height: 60
                fill: bind borderFill
                arcHeight: 5
                arcWidth: 5
                onMouseEntered: function (e: MouseEvent): Void {
                    borderFill = Color.ORANGE;
                    uldBorder.cursor = Cursor.HAND;
                    toolTip.activate();
                }
                onMouseExited: function (e: MouseEvent): Void {
                    borderFill = Color.CADETBLUE;
                    uldBorder.cursor = Cursor.DEFAULT;
                    toolTip.deactivate();
                } onMouseDragged: function (e: MouseEvent): Void {
                    toolTip.disable = true;
                    toolTip.deactivate();
                    toolTip.disable = false;
                }
            }
    public var weightText = Text {
                cache: true
                font: Font {
                    size: 12
                    name: "ARIAL BOLD"
                    oblique: true
                    embolden: true
                }
                x: 20 y: 20
                content: ""
                fill: Color.WHITE;
            }
    var borderGroup = Group {
                content: [uldBorder, weightText, toolTip]
            }

    override protected function create(): Node {
        return borderGroup;
    }

}
