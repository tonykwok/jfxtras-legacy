/*
 * Copyright (c) 2008-2009, JFXtras Group
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

package org.jfxtras.scene.control;

import javafx.geometry.BoundingBox;
import javafx.scene.control.Control;
import javafx.scene.image.Image;
import org.jfxtras.scene.layout.DefaultLayout;
import org.jfxtras.scene.layout.GridLayoutInfo;
import org.jfxtras.scene.layout.LayoutConstants.*;

/**
 * Shelf control, that displays a set of Images in a horizontal scrolling list with perspective transform.
 * <p>
 * Still in progress.
 *
 * @author Stephen Chin
 * @author Keith Combs
 */
public class Shelf extends Control, DefaultLayout {
    var shelfSkin:ShelfSkin;
    public var placeholder:Image on replace {
        shelfSkin.refresh();
    }
    public var reflection = true on replace {
        shelfSkin.refresh();
    }
    public var preserveRatio = true on replace {
        shelfSkin.refresh();
    }
    public var aspectRatio = 1.0 on replace {
        shelfSkin.refresh();
    }
    public var centerGap = 0.7 on replace {
        shelfSkin.refresh();
    }
    public var index:Integer;
    public var imageUrls:String[] on replace {
        shelfSkin.updateVisible();
    }
    public var thumbnailWidth:Number on replace {
        shelfSkin.refresh();
    }
    public var thumbnailHeight:Number on replace {
        shelfSkin.refresh();
    }
    public var showScrollBar = true;
    public var showText = true;
    public var imageNames:String[];
    // todo - need to set reasonable defaults...
    override function getPrefWidth(height) {1000}
    override function getPrefHeight(width) {300}
    override function getMaxWidth() {10000}
    override function getMaxHeight() {10000}
    override var defaultLayoutInfo = GridLayoutInfo {
        fill: BOTH
        hgrow: ALWAYS
        vgrow: ALWAYS
    }
    override var layoutBounds = bind BoundingBox {
        width: width
        height: height
    }

    init {
        skin = shelfSkin = ShelfSkin {}
    }

    package function getPlaceHolder() {
        if (placeholder == null) {
            placeholder = Image {
                width: 200
                height: 200
                preserveRatio: preserveRatio
                url: "{__DIR__}PlaceHolder.png"
            }
        }
        return placeholder;
    }
}
