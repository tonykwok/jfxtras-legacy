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
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;
import javafx.scene.shape.Rectangle;
import javafx.scene.Group;
import javafx.scene.paint.Color;
import javafx.scene.effect.Glow;
import javafx.scene.effect.Shadow;
import javafx.scene.shape.Line;
import javafx.scene.control.Label;
import javafx.scene.text.Font;
import javafx.scene.layout.LayoutInfo;

/**
 * node containing the aircraft deck background and scale showing distance from the datum(nose of the aircraft)
 * @author Abhilshit Soni
 */
public class DeckNode extends CustomNode {

    var deckImage = ImageView {x: 0 y: 3 image: Image {url: "{__DIR__}images/FAA-H-8083-1B.png" }
                visible: true
            }
    var deckImageBorder = Rectangle {
                cache: true;
                x: -8
                y: -8
                fill: Color.CADETBLUE
                width: deckImage.image.width + 12;
                height: deckImage.image.height + 49;
                arcWidth: 15
                arcHeight: 15
                effect: Glow {
                    level: 1
                    input: Shadow {
                        // offsetX: -5
                        // offsetY: 5
                        width: 5
                        color: Color.CADETBLUE
                        radius: 15
                    }
                }
                opacity: 0.5
            }
    var deckImageBg = Rectangle {
                cache: true;
                x: -7
                y: -7
                fill: Color.BLACK
                width: deckImage.image.width + 10;
                height: deckImage.image.height + 48;
                arcWidth: 15
                arcHeight: 15
            }
    var deckImageHeader = Rectangle {
                cache: true
                x: 37
                y: -20
                fill: Color.BLACK
                width: deckImage.image.width - 80;
                height: 20;
                arcWidth: 5
                arcHeight: 5
                effect: Shadow {
                    color: Color.BLACK
                    radius: 1
                }
                opacity: 1
            }
    var header = Label {
                cache: true;
                layoutX: 123
                layoutY: -20
                textFill: Color.WHITE
                font: Font {size: 15 }
                layoutInfo: LayoutInfo {width: deckImage.image.width - 180 }
                text: "AIRCRAFT MODEL: BEECHCRAFT 1900C | MAIN DECK | NY CITY -> L.A"
            }
    var scaleBaseLine = Line {
                cache: true;
                startX: 10, startY: 160
                endX: 670, endY: 160
                strokeWidth: 1
                stroke: Color.WHITE
            }
    var noseLine = Line {
                cache: true;
                startX: 670, startY: 155
                endX: 670, endY: 165
                strokeWidth: 1
                stroke: Color.WHITE
            }
    var noseLabel = Label {
                cache: true;
                layoutX: 656 layoutY: 166
                text: "0 Nose"
                textWrap: true
                width: 25
                textFill: Color.WHITE
            }
    var tailLine = Line {
                cache: true;
                startX: 10, startY: 155
                endX: 10, endY: 165
                strokeWidth: 1
                stroke: Color.WHITE
            }
    var tailLabel = Label {
                cache: true;
                layoutX: 5 layoutY: 166
                text: "533 Tail"
                textWrap: true
                width: 35
                textFill: Color.WHITE
            }
    var aLine = Line {
                cache: true;
                startX: 595, startY: 155
                endX: 595, endY: 165
                strokeWidth: 1
                stroke: Color.WHITE
            }
    var aLabel = Label {
                cache: true;
                layoutX: 595 layoutY: 166
                text: "225 Sec A"
                textWrap: true
                width: 35
                textFill: Color.WHITE
            }
    var bLine = Line {
                cache: true;
                startX: 525, startY: 155
                endX: 525, endY: 165
                strokeWidth: 1
                stroke: Color.WHITE
            }
    var bLabel = Label {
                cache: true;
                layoutX: 525 layoutY: 166
                text: "255 Sec B"
                textWrap: true
                width: 35
                textFill: Color.WHITE
            }
    var cLine = Line {
                cache: true;
                startX: 465, startY: 155
                endX: 465, endY: 165
                strokeWidth: 1
                stroke: Color.WHITE
            }
    var cLabel = Label {
                cache: true;
                layoutX: 465 layoutY: 166
                text: "285 Sec C"
                textWrap: true
                width: 35
                textFill: Color.WHITE
            }
    var dLine = Line {
                cache: true;
                startX: 400, startY: 155
                endX: 400, endY: 165
                strokeWidth: 1
                stroke: Color.WHITE
            }
    var dLabel = Label {
                cache: true;
                layoutX: 400 layoutY: 166
                text: "315 Sec D"
                textWrap: true
                width: 35
                textFill: Color.WHITE
            }
    var eLine = Line {
                cache: true;
                startX: 335, startY: 155
                endX: 335, endY: 165
                strokeWidth: 1
                stroke: Color.WHITE
            }
    var eLabel = Label {
                cache: true;
                layoutX: 335 layoutY: 166
                text: "345 Sec E"
                textWrap: true
                width: 35
                textFill: Color.WHITE
            }
    var fLine = Line {
                cache: true;
                startX: 265, startY: 155
                endX: 265, endY: 165
                strokeWidth: 1
                stroke: Color.WHITE
            }
    var fLabel = Label {
                cache: true;
                layoutX: 265 layoutY: 166
                text: "375 Sec F"
                textWrap: true
                width: 35
                textFill: Color.WHITE
            }
    var gLine = Line {
                cache: true;
                startX: 195, startY: 155
                endX: 195, endY: 165
                strokeWidth: 1
                stroke: Color.WHITE
            }
    var gLabel = Label {
                cache: true;
                layoutX: 195 layoutY: 166
                text: "405 Sec G"
                textWrap: true
                width: 35
                textFill: Color.WHITE
            }
    var hLine = Line {
                cache: true;
                startX: 125, startY: 155
                endX: 125, endY: 165
                strokeWidth: 1
                stroke: Color.WHITE
            }
    var hLabel = Label {
                cache: true;
                layoutX: 125 layoutY: 166
                text: "435 Sec H"
                textWrap: true
                width: 35
                textFill: Color.WHITE
            }
    var iLine = Line {
                cache: true;
                startX: 55, startY: 155
                endX: 55, endY: 165
                strokeWidth: 1
                stroke: Color.WHITE
            }
    var iLabel = Label {
                cache: true;
                layoutX: 55 layoutY: 166
                text: "465 Sec I"
                textWrap: true
                width: 35
                textFill: Color.WHITE
            }
    var scaleGroup = Group {
                content: [scaleBaseLine, noseLine, noseLabel, tailLine, tailLabel, aLine, aLabel, bLine, bLabel, cLine, cLabel, dLine, dLabel, eLine, eLabel, fLine, fLabel, gLine, gLabel, hLine, hLabel, iLine, iLabel]
            }

    override protected function create(): Node {
        return Group {content: [deckImageBorder, deckImageBg, deckImage, scaleGroup, deckImageHeader, header] };
    }

}
