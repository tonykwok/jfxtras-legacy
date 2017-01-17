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
package org.jfxtras.scene.shape;

import javafx.geometry.BoundingBox;
import javafx.scene.*;
import javafx.scene.layout.*;
import javafx.scene.paint.*;
import javafx.scene.shape.*;
import org.jfxtras.scene.layout.*;
import org.jfxtras.scene.layout.XLayoutInfo.*;

/**
 * A Drop-in replacement for Rectangle that will resize to fit the bounds
 * of the container.  The preferred width and height can be easily set by
 * providing an initial value for the width and height variables, otherwise
 * they will both default to 200.
 * <p>
 * Unlike a normal Rectangle, the Stroke will always fall within the bounds
 * provided.  This ensures that when added to a Container, the size of this
 * ResizableRectangle will not exceed its allocated space regardless of the
 * stroke width.
 * <p>
 * See javafx.scene.shape.Rectangle for full documentation.  This class follows
 * a delegation pattern to avoid name collisions on Rectangle and Resizable.
 *
 * @profile common
 *
 * @author Stephen Chin
 * @author Keith Combs
 */
public class ResizableRectangle extends CustomNode, Resizable {

    def rectangle = FrontBackRectangle {}

    var preferredWidth:Number = 200;
    var preferredHeight:Number = 200;
    
    override var layoutBounds = bind lazy BoundingBox {
        minX: x
        minY: y
        width: width
        height: height
    }

    override function getMinWidth() {
        return 0;
    }

    override function getMinHeight() {
        return 0;
    }

    override function getPrefWidth(height) {
        return preferredWidth;
    }

    override function getPrefHeight(width) {
        return preferredHeight;
    }

    override function getMaxWidth() {
        return Integer.MAX_VALUE;
    }

    override function getMaxHeight() {
        return Integer.MAX_VALUE;
    }

    function compensateForStroke() {
        def bleed = if (stroke == null) 0 else strokeWidth / 2;
        rectangle.translateX = bleed;
        rectangle.translateY = bleed;
        rectangle.width = width - bleed * 2;
        rectangle.height = height - bleed * 2;
    }

    override var width on replace {
        compensateForStroke();
    }

    override var height on replace {
        compensateForStroke();
    }

    override function getHFill() {true}
    override function getVFill() {true}
    override function getHGrow() {SOMETIMES}
    override function getVGrow() {SOMETIMES}
    override function getHShrink() {ALWAYS}
    override function getVShrink() {ALWAYS}

    init {
        width = XContainer.getNodePrefWidth(this);
        height = XContainer.getNodePrefHeight(this);
    }

    public var x = 0.0 on replace {
        rectangle.x = x;
    }

    public var y = 0.0 on replace {
        rectangle.y = y;
    }

    public var arcHeight = 0.0 on replace {
        rectangle.arcHeight = arcHeight;
    }

    public var arcWidth = 0.0 on replace {
        rectangle.arcWidth = arcWidth;
    }

    public var fill:Paint on replace {
        rectangle.fill = fill;
    }

    public var smooth:Boolean = true on replace {
        rectangle.smooth = smooth;
    }

    public var stroke:Paint on replace {
        rectangle.stroke = stroke;
        compensateForStroke();
    }

    public var strokeDashArray:Number[] on replace {
        rectangle.strokeDashArray = strokeDashArray;
    }

    public var strokeDashOffset:Number = 0 on replace {
        rectangle.strokeDashOffset = strokeDashOffset;
    }

    public var strokeLineCap:StrokeLineCap = StrokeLineCap.SQUARE on replace {
        rectangle.strokeLineCap = strokeLineCap;
    }

    public var strokeLineJoin:StrokeLineJoin = StrokeLineJoin.MITER on replace {
        rectangle.strokeLineJoin = strokeLineJoin;
    }

    public var strokeMiterLimit:Number = 10 on replace {
        rectangle.strokeMiterLimit = strokeMiterLimit;
    }

    public var strokeWidth:Number = 1.0 on replace {
        rectangle.strokeWidth = strokeWidth;
        compensateForStroke();
    }

    override function create() {
        return rectangle;
    }
}

// could not be an anonymous inner class due to RT-4723
class FrontBackRectangle extends Rectangle {
    override function toFront() {
        parent.toFront();
    }
    override function toBack() {
        parent.toBack();
    }
}
