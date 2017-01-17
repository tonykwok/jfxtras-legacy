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

package org.jfxtras.scene.text;

import javafx.scene.CustomNode;
import javafx.scene.text.Text;
import javafx.scene.text.TextBoundsType;
import javafx.scene.transform.Rotate;
import javafx.scene.transform.Translate;
import javafx.util.Math;
import javafx.scene.Node;
import javafx.scene.Group;
import javafx.scene.text.TextOrigin;

/**
 * @author David
 */

public class XArcText extends CustomNode {

    /**
     *  The original Text node that is to be arced
     * @default "No text supplied."
     */
    public-init var text: Text = Text { content: "No text supplied." };

    /**
     *  The angle for the centre of the final arced text
     * @default 0
     */
    public-init var angle: Float = 0;

    /**
     *  The radius for the arced text
     * @default 100
     */
    public-init var radius: Float = 100;

    /**
     *  The X coordinate for the center
     * @default 0
     */
    public-init var centerX: Float = 0;

    /**
     *  The Y coordinate for the centre
     * @default 0
     */
    public-init var centerY: Float = 0;

    // the full angle extended by the length of the original text at the radius
    var angleFull: Float;
    // the angle per unit of original text width
    var anglePerUnit: Float;
    // the result
    var arcedText = Group { };
    // the original width of the supplied text
    var textWidth = bind text.layoutBounds.width;
    // the total width when each individual letter is dealt with separately
    // for some reason there seems to be some forced padding???
    var totalledWidth: Float;
    // Sequence of individual letter widths from left to right in text
    var letterWidth: Float[];
    // Sequence of single letter text nodes
    var letter: Text[];

    override function create(): Node {
        text.boundsType = TextBoundsType.VISUAL;
        text.textOrigin = TextOrigin.BASELINE;
        getLettersAndWidths();
        calculateAngle();
        transformLetters();
        arcedText;
        }

    // Loop through letters creating text nodes for each
    function getLettersAndWidths() {
        for (i in [1..text.content.length()])
            {
            var newLetter: Text = javafx.fxd.Duplicator.duplicate(text) as Text;
            newLetter.content = text.content.substring(i-1, i);
            newLetter.boundsType = TextBoundsType.VISUAL;
            letterWidth[i-1] = newLetter.boundsInParent.width;
            totalledWidth += newLetter.boundsInParent.width;
            insert newLetter into letter;
            }
        }

    // take text width as fraction of circumference and multiply by 360
    function calculateAngle() {
        var circumference: Float = 2.0 * Math.PI * radius;
        angleFull = 360 * (textWidth / circumference);
        anglePerUnit = angleFull / textWidth;
        }

    // Stick the text nodes where they should be (adjusted for the unavoidable padding)
    function transformLetters() {
        var adjustForPadding = ((totalledWidth - textWidth) / text.content.length());
        var nextAngle = - angleFull / 2 - adjustForPadding / 2 + angle;
        for (i in [0..sizeof(letter)-1])
            {
            var angleForCenter = nextAngle + ((letterWidth[i] +  adjustForPadding) / 2) * anglePerUnit;
            var r = Math.toRadians(nextAngle + 90);
            var h = Math.cos(r);
            var v = Math.sin(r);
            letter[i].transforms = [
                Translate {
                    x: centerX - h * radius
                    y: centerY - v * radius
                    },
                Rotate {
                    pivotX: letter[i].boundsInParent.minX
                    pivotY: letter[i].boundsInParent.maxY - letter[i].layoutBounds.maxY
                    angle: angleForCenter
                    },
                ];
            insert letter[i] into arcedText.content;
            nextAngle += (letterWidth[i] - adjustForPadding) * anglePerUnit;
            }
        }
    }
