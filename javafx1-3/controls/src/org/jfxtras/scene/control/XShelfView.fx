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
package org.jfxtras.scene.control;

import javafx.scene.control.Control;
import javafx.scene.image.Image;
import javafx.util.Math;
import org.jfxtras.scene.control.data.DataProvider;
import org.jfxtras.scene.control.data.XShelfImageProvider;
import org.jfxtras.scene.control.data.XShelfNodeProvider;
import org.jfxtras.scene.control.renderer.DirectNodeRenderer;
import org.jfxtras.scene.control.renderer.ImageRenderer;
import org.jfxtras.scene.control.renderer.NodeRenderer;
import org.jfxtras.scene.image.XImage;
import org.jfxtras.scene.layout.XLayoutInfo;
import org.jfxtras.scene.layout.XLayoutInfo.*;
import javafx.scene.Node;

/**
 * XShelfView control, that displays a set of Images in a horizontal scrolling list with perspective transform.
 * <p>
 * Still in progress.
 *
 * @author Stephen Chin
 * @author Keith Combs
 */
public class XShelfView extends Control {
    var shelfSkin:XShelfSkin;
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

    /**
     * List of Nodes that will display images in the Shelf.  This is used by the default
     * dataProvider and will take precedence over imageUrls.
     */
    public var imageNodes:Node[] on replace {
        if (imageNodes != null) {
            if (not isInitialized(renderer)) {
                renderer = DirectNodeRenderer {}
            }
            if (not isInitialized(dataProvider)) {
                dataProvider = XShelfNodeProvider {names: bind imageNames, nodes: bind imageNodes}
            }
            shelfSkin.updateVisible();
        }
    }

    /**
     * List of urls for the images that will be displayed in the Shelf.  This is used by the default
     * dataProvider, but will not be used if imageNodes is set.
     */
    public var imageUrls:String[] on replace {
        if (imageUrls != null) {
            if (not isInitialized(renderer)) {
                renderer = ImageRenderer {placeholder: XImage {url: "{__DIR__}PlaceHolder.png"}}
            }
            if (not isInitialized(dataProvider)) {
                dataProvider = XShelfImageProvider {names: bind imageNames, urls: bind imageUrls}
            }
            shelfSkin.updateVisible();
        }
    }

    /**
     * Optional list of names for the images being displayed.  If left empty no image names
     * will be displayed.
     */
    public var imageNames:String[];

    /**
     * The renderer that will be used to create nodes for display.  By default this is an ImageRenderer that takes
     * String urls and turns them into ImageViews.
     */
    public var renderer:NodeRenderer;
    public var dataProvider:DataProvider;
    public var thumbnailWidth:Number on replace {
        shelfSkin.refresh();
    }
    public var thumbnailHeight:Number on replace {
        shelfSkin.refresh();
    }
    public var wrap:Boolean on replace {
        index = getBoundedIndex(index);
        shelfSkin.refresh();
    }
    override var focused on replace {
        shelfSkin.refresh();
    }
    public var index:Integer;
    public var showScrollBar = true;
    public var showText = true;
    public var showHighlight = true;
    public var centerEventsOnly = true;
    public var onImagePressed:function(e:XShelfEvent):Void;
    public var onImageClicked:function(e:XShelfEvent):Void;
    public var onImageReleased:function(e:XShelfEvent):Void;
    public var onImageEntered:function(e:XShelfEvent):Void;
    public var onImageExited:function(e:XShelfEvent):Void;
    public var action:function(e:XShelfEvent):Void;
    public var preloadLeftDepth = 1;
    public var preloadRightDepth = 5;
    // todo - need to set reasonable defaults...
    override function getPrefWidth(height) {1000}
    override function getPrefHeight(width) {300}
    override function getMaxWidth() {10000}
    override function getMaxHeight() {10000}
    override function getHFill() {true}
    override function getVFill() {true}
    override function getHGrow() {ALWAYS}
    override function getVGrow() {ALWAYS}
    override function getHShrink() {SOMETIMES}
    override function getVShrink() {SOMETIMES}

    init {
        skin = shelfSkin = XShelfSkin {}
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

    package function getBoundedIndex(i:Integer) {
        if (wrap) {
            i;
        } else {
            Math.max(0, Math.min(dataProvider.rowCount - 1, i));
        }
    }

    package function wrapIndex(i:Integer) {
        var size = dataProvider.rowCount;
        if (size == 0) return 0;
        var modulus = ((i mod size) + size) mod size;
        return Math.abs(modulus);
    }

}
