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

import javafx.scene.shape.Shape;
import javafx.scene.layout.Container;

/**
 * @author jclarke
 * @author Stephen Chin
 */
public class XShapeBorder extends XBorder {
    public var shape: Shape on replace {
        panel.clip = shape;
    }

    /**
     * Indicates additional offset to be applied to the horizontal position of
     * the content. Negative values shift the content left, positive, right.
     *
     * @defaultvalue 0
     * @css horizontal-offset
     */
    public var horizontalOffset = 0.0;

    /**
     * Indicates additional offset to be applied to the vertical position of
     * the content. Negative values shift the content up, positive, down.
     *
     * @defaultvalue 0
     * @css vertical-offset
     */
    public var verticalOffset = 0.0;

    /**
     * Computes preferred width as the sum of left and right border widths
     * and the content's preferred width
     */
    protected override function getPrefWidth(height): Number {
        Container.getNodePrefWidth(shape) + borderLeftWidth +
            borderRightWidth;
    }

    /**
     * Computes preferred width as the sum of left and right border widths
     * and the content's preferred width
     */
    protected override function getPrefHeight(height): Number {
        Container.getNodePrefHeight(shape) + borderTopWidth +
            borderBottomWidth;
    }

    protected var widthOfBorder:Number;
    protected var heightOfBorder:Number;
    protected var borderY: Number;
    protected var borderX: Number;

    init {
        panel.clip = shape;
    }

    public override function doBorderLayout(x:Number, y:Number, w:Number, h:Number):Void {
        shape.layoutX = x;
        shape.layoutY = y;
        borderX = x;
        borderY = y;
        widthOfBorder = w;
        heightOfBorder = h;
    }
}
