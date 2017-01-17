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

import javafx.geometry.HPos;
import javafx.geometry.VPos;
import javafx.scene.Group;
import javafx.scene.control.Label;
import javafx.scene.layout.Container;
import javafx.scene.layout.LayoutInfo;
import javafx.scene.paint.Color;
import javafx.scene.paint.Paint;
import javafx.scene.shape.Polyline;
import javafx.scene.text.Font;
import javafx.util.Math;

/**
 * @author jclarke
 */
public class XTitledBorder extends XBorder {
    /**
     * The vertical position of the title, either TOP or BOTTOM
     * @defaultValue VPos.TOP
     */
    public var titleVPos = VPos.TOP;

    /**
     * The horizontal position of the title
     * @defaultValue HPos.CENTER
     */
    public var titleHPos = HPos.CENTER;

    /**
     * The text for the title
     */
    public var text:String on replace { requestLayout(); };

    /**
     * The font for the title
     */
    public var font: Font = Font{} on replace { requestLayout(); };

    /**
     * Color for for the text,
     *
     * @defaultvalue black
     * @css text-color
     */
    public var textFill: Paint = Color.BLACK;

    /**
     * Defines the line color
     *
     * @defaultvalue black
     * @css line-color
     */

    public var lineColor: Paint = Color.BLACK;

    /**
     * The line thichness, the border widths will assume this value
     *
     * @defaultvalue 1
     * @css thickness
     */
    public var thickness = 1 on replace { requestLayout(); }

    public var borderWidth:Number on replace {
        if(not isInitialized (borderWidth)) borderWidth = font.size*2;
        requestLayout();
    }

    override var borderTopWidth = bind borderWidth;
    override var borderLeftWidth = bind borderWidth;
    override var borderBottomWidth = bind borderWidth;
    override var borderRightWidth = bind borderWidth;

    var widthOfBorder:Number;
    var heightOfBorder:Number;
    var borderY: Number;
    var borderX: Number;

    def TEXT_PAD = 4.0;

    var topPolyline:Polyline;

    var bottomPolyline:Polyline;

    def TEXT_INSET = 5.0;

    def label:Label = Label {
        text: bind text
        font: bind font
        textFill: bind textFill
        layoutInfo: LayoutInfo {
            maxWidth: bind widthOfBorder - borderWidth - 2*TEXT_INSET
        }
    }

    bound function getTitleX() : Number {
        if (titleHPos == HPos.LEFT or titleHPos == HPos.LEADING) {
            borderLeftWidth + TEXT_INSET;
        } else if (titleHPos == HPos.RIGHT or titleHPos == HPos.TRAILING) {
            widthOfBorder - borderRightWidth - label.layoutBounds.width - TEXT_INSET;
        } else {
            (widthOfBorder - label.layoutBounds.width) / 2.0 - label.layoutBounds.minX;
        }
    }

    bound function getTitleY() : Number {
        if (titleVPos == VPos.BOTTOM or titleVPos == VPos.PAGE_END) {
            heightOfBorder-borderWidth/2.0 - label.layoutBounds.height/2.0 - label.layoutBounds.minY;
        } else {
            (borderWidth- label.layoutBounds.height)/2.0 - label.layoutBounds.minY;
        }
    }

    override var border = Group {
        content: [
            Group {
                layoutX: bind borderX
                layoutY: bind borderY
                content: bind if (titleVPos == VPos.BOTTOM or titleVPos == VPos.PAGE_END) bottomPolyline else topPolyline;
            },
            Group {
                content: bind label
            }
        ]
    }

    public override function doBorderLayout(x:Number, y: Number, w:Number, h:Number):Void {
        borderX = x;
        borderY = y;
        widthOfBorder = w;
        heightOfBorder = h;

        if (label.width < Container.getNodePrefWidth(label)) {
            def lw = Math.min(Container.getNodePrefWidth(label), Container.getNodeMaxWidth(label));
            Container.resizeNode(label, lw, label.height);
        } 
        label.layoutX = getTitleX() + borderX;
        label.layoutY = getTitleY() + borderY;
        def width = bind widthOfBorder - borderWidth;
        def height = bind heightOfBorder - borderWidth;
        def tx = bind Math.max(TEXT_PAD, getTitleX() - borderWidth/2);
        def etx = bind Math.min(width, tx + label.layoutBounds.width + TEXT_PAD);
        def ty = bind getTitleY();
        topPolyline = Polyline {
            stroke: bind lineColor
            strokeWidth: bind thickness
            layoutX: bind borderWidth / 2
            layoutY: bind borderWidth / 2
            points: bind [
               tx - TEXT_PAD, 0,
               0, 0,
               0, height,
               width, height,
               width, 0,
               etx, 0
            ]
        }
        bottomPolyline = Polyline {
            layoutX: bind borderWidth/2
            layoutY: bind borderWidth/2
            stroke: bind lineColor
            strokeWidth: bind thickness
            points: bind [
               tx - TEXT_PAD, h,
               0, h,
               0, 0,
               width, 0,
               width, height,
               etx, height
            ]
        }
    }

    postinit {
        if (not isInitialized(borderWidth)) borderWidth = font.size * 2;
    }
}
