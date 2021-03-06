/*
 * Copyright (c) 2009, Pro JavaFX Authors
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
 *
 * RectangleDrawingToolNode.fx - A drawing tool that, when selected, indicates that
 * the user wants to draw a Rectangle.
 *
 * Developed 2009 by James L. Weaver jim.weaver [at] javafxpert.com
 *               and Stephen Chin steve [at] widgetfx.org
 * as a JavaFX Script SDK 1.2 example for the Pro JavaFX book.
 */
package projavafx.drawjfx.ui.tool;

import javafx.scene.shape.Rectangle;
import javafx.scene.paint.Color;
import projavafx.drawjfx.ui.ShapeProducer;

/**
 * A drawing tool that, when selected, indicates that the user wants to
 * draw a Rectangle.
 */
public class RectangleDrawingToolNode extends AbstractDrawingToolNode {
    var shapeProducer = ShapeProducer {
        produceShape: function() {
            Rectangle {}
        }
        sizeShape: function(shape, x, y) {
            var line = shape as Rectangle;
            line.width = x;
            line.height = y;
        }
    }

    override var selected = bind djfxModel.currentShapeProducer == shapeProducer;

    override var action = function():Void {
        djfxModel.currentShapeProducer = shapeProducer;
        djfxModel.currentFilled = filled;
    }

    /**
     * Type of shape that this tool node represents
     */
    init {
        toolFaceNode = Rectangle {
            x: 4
            y: 8
            width: 24
            height: 16
            fill: bind if (filled) Color.BLACK else Color.TRANSPARENT
            stroke: Color.BLACK
        }
    }

    /**
     * Determines if the Rectangle is filled
     */
    public var filled: Boolean;
}
