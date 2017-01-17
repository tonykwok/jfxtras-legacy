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

import javafx.scene.layout.Resizable;
import javafx.scene.shape.Ellipse;
import org.jfxtras.scene.layout.XContainer;

/**
 * @author Stephen Chin
 */
public class ResizableEllipse extends Ellipse, Resizable {
    var preferredWidth:Number = 200;
    var preferredHeight:Number = 200;

    override function getPrefWidth(height) {
        return preferredWidth;
    }

    override function getPrefHeight(width) {
        return preferredHeight;
    }

    function compensateForStroke() {
        def bleed = if (stroke == null) 0 else strokeWidth / 2;
        radiusX = width / 2 - bleed;
        radiusY = height / 2 - bleed;
        translateX = radiusX + bleed;
        translateY = radiusY + bleed;
    }

    override var width on replace {
        compensateForStroke();
    }

    override var height on replace {
        compensateForStroke();
    }

    init {
        width = XContainer.getNodePrefWidth(this);
        height = XContainer.getNodePrefHeight(this);
    }
}
