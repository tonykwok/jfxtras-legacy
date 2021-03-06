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
import javafx.scene.Group;
import javafx.scene.Node;
import javafx.scene.paint.Color;
import javafx.scene.shape.Rectangle;
import javafx.scene.control.Button;
import javafx.scene.chart.PieChart;
import javafx.scene.Cursor;

/**
 * node that contains enlarged weight coverage node with a bit transparent background that covers the entire application.
 * @author Abhilshit Soni
 */
public class EnLargedWeightCoverage extends CustomNode {

    init {
        blocksMouse = true;
        pie.toFront();
    }

    public var pie: PieChart;
    var background = Rectangle {
                cache: true
                x: 0, y: 23
                width: 950, height: 642
                fill: Color.BLACK
                opacity: 0.97
                blocksMouse: true
            }
    var closeButton = Button {
                cache: true;
                layoutX: 425
                layoutY: 500
                text: "Close >>";
                action: function () {


                    delete this from scene.content;
                    this.pie.scaleX = 0.45;
                    this.pie.scaleY = 0.48;
                    this.pie.translateX = -120;
                    this.pie.translateY = 353;


                    insert pie into scene.content;
                    pie.toFront();
                }
                cursor:Cursor.HAND;
            }
    public var finalGroup = Group {
                id: "fg"
                content: [background, closeButton, pie]
            };

    public override function create(): Node {
        return finalGroup;
    }

}
