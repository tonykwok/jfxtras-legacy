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

import javafx.animation.KeyFrame;
import javafx.animation.Interpolator;
import javafx.animation.Timeline;
import javafx.scene.Node;
import javafx.scene.effect.Reflection;
import javafx.scene.layout.Panel;
import javafx.scene.paint.Color;
import javafx.scene.shape.Rectangle;
import javafx.util.Math;

import javafx.scene.text.Text;
import javafx.scene.text.Font;

import javafx.scene.text.FontWeight;


import javafx.scene.effect.DropShadow;
import javafx.scene.effect.BlurType;

import javafx.scene.control.ScrollBar;

/**
 * @author Stephen Chin
 * @author Keith Combs
 */
package class ShelfSkin extends AbstractSkin {
    def sizeRatio = 0.7;
    def squeezeRatio = 0.3;
    def sideAngle = 45;
    def topAspect = .5;
    def bottomAspect = bind .2 + reflectionEffect.fraction * .7;

    var reflectionEffect:Reflection = bind if (shelf.reflection) {
        Reflection{}
    } else null;
    var reflectionSizeMultiplier:Number = bind 1 + reflectionEffect.fraction;
    var animatingIndex:Number on replace {
        (node as Panel).requestLayout();
    }
    var firstVisible = -1;
    var lastVisible = -2;
    var center = 0;
    var views:ShelfView[] = bind for (url in shelf.imageUrls) ShelfView {
        index: bind indexof url;
        url: url
        placeholder: shelf.getPlaceHolder();
    }
    var nodes:Node[];
    def imageTitle = bind if (shelf.showText) Text {
        content: bind shelf.imageNames[shelf.index]
        font: Font.font("SansSerif", FontWeight.BOLD, 14);
        effect: DropShadow {color: Color.WHITE, radius: 5, blurType: BlurType.ONE_PASS_BOX}
    } else null;
    var updatingScrollValue = false;
    var scrollValue:Number on replace {
        if (not updatingScrollValue) {
            shelf.index = Math.round(scrollValue) as Integer;
        }
    }
    def scrollBar = bind if (shelf.showScrollBar) ScrollBar {
        value: bind scrollValue with inverse
        max: bind sizeof shelf.imageUrls
        blockIncrement: 5
        unitIncrement: 1
    } else null;

    var visibleViews:ShelfView[];
    def shelf = bind control as Shelf on replace {
        animatingIndex = shelf.index;
    }

    var timeline:Timeline;
    def setIndex = bind shelf.index on replace oldValue=newValue {
        if (setIndex != oldValue) {
            updatingScrollValue = true;
            scrollValue = shelf.index;
            updatingScrollValue = false;
            timeline.stop();
            timeline = Timeline {
                keyFrames: [
                    KeyFrame {
                        time: 1000ms
                        values: animatingIndex => shelf.index tween Interpolator.SPLINE(.05, .5, .5, .95)
                        action: loadVisible
                    }
                ]
            }
            timeline.play();
        }
    }

    def transparentRectangle = Rectangle {
        fill: Color.TRANSPARENT
        onMousePressed: function(e) {
            for (view in reverse visibleViews) {
                if (view.contains(e.x, e.y)) {
                    shelf.index = view.index;
                    return;
                }
            }
        }
    }

    override var node = Panel {
        prefWidth:function(height) {100}
        prefHeight:function(width) {100}
        width: bind shelf.width
        height: bind shelf.height
        content: bind [
            transparentRectangle,
            nodes,
            imageTitle,
            scrollBar
        ]
        clip: Rectangle {}
        onLayout: doLayout
    }

    public function refresh() {
        firstVisible = -1;
        lastVisible = -2;
        (node as Panel).requestLayout();
    }

    function getViewHeight() {
        shelf.height - imageTitle.font.size * 2 - scrollBar.layoutBounds.height;
    }

    function doLayout():Void {
        transparentRectangle.width = shelf.width;
        transparentRectangle.height = shelf.height;
        var clip = node.clip as Rectangle;
        clip.width = shelf.width;
        clip.height = shelf.height * 2;
        imageTitle.layoutX = (shelf.width - imageTitle.layoutBounds.width) / 2;
        imageTitle.layoutY = shelf.height - imageTitle.font.size / 2 - scrollBar.layoutBounds.height;
        scrollBar.width = shelf.width;
        scrollBar.layoutY = shelf.height - scrollBar.layoutBounds.height;
        def viewHeight = getViewHeight();
        updateVisible(viewHeight);
        def width = viewHeight * shelf.aspectRatio * sizeRatio;
        def height = viewHeight * sizeRatio;
        def distance = width * squeezeRatio;
        for (view in visibleViews) {
            def indexOffset = view.index - animatingIndex;
            var adjustedWidth = width;
            var adjustedHeight = height;
            var angle;
            var startPosition;
            var y = (viewHeight - height) / 2;
            if (indexOffset > -1 and indexOffset < 1) {
                def curve = Math.sin(indexOffset * Math.PI / 2);
                def absOffset = Math.abs(curve);
                adjustedWidth = viewHeight * shelf.aspectRatio - (viewHeight * shelf.aspectRatio - width) * absOffset;
                adjustedHeight = viewHeight - (viewHeight - height) * absOffset;
                angle = sideAngle * indexOffset;
                startPosition = width * shelf.centerGap * curve;
                y *= absOffset;
            } else {
                angle = if (indexOffset > 0) sideAngle else -sideAngle;
                startPosition = if (indexOffset > 0) width*shelf.centerGap else -width*shelf.centerGap;
            }
            view.setAngle(90 + angle);
            view.setSize(adjustedWidth, adjustedHeight * reflectionSizeMultiplier);
            def position = shelf.width / 2 + startPosition + indexOffset * distance;
            view.setPosition(position - adjustedWidth / 2, y);
        }
    }

    package function updateVisible() {
        updateVisible(getViewHeight());
    }

    package function updateVisible(viewHeight:Number) {
        def size = viewHeight * shelf.aspectRatio * sizeRatio;
        if (size == 0) {
            return;
        }
        def distance = size * squeezeRatio;
        var numNodes = ((shelf.width / 2 - size * shelf.centerGap) / distance);
        // todo - this might be slightly off...
        var newFirstVisible = Math.round(animatingIndex - numNodes - 1) as Integer;
        var newLastVisible = Math.round(animatingIndex + numNodes + 1) as Integer;
        if (newFirstVisible < 0) {
            newFirstVisible = 0;
        }
        if (newLastVisible >= sizeof views) {
            newLastVisible = sizeof views - 1;
        }
        def newCenter = Math.round(animatingIndex) as Integer;
        if (newFirstVisible != firstVisible or newLastVisible != lastVisible or newCenter != center) {
            for (view in views[firstVisible..newFirstVisible-1]) {
                view.cacheView();
            }
            for (view in views[Math.max(lastVisible+1, newFirstVisible)..newLastVisible]) {
                createView(view, viewHeight);
            }
            for (view in views[newLastVisible + 1..lastVisible]) {
                view.cacheView();
            }
            for (view in views[newFirstVisible..Math.min(newLastVisible, firstVisible-1)]) {
                createView(view, viewHeight);
            }
            firstVisible = newFirstVisible;
            lastVisible = newLastVisible;
            center = newCenter;
            if (timeline == null or not timeline.running) {
                loadVisible(viewHeight);
            }
            visibleViews = [views[firstVisible..center-1], reverse views[center..lastVisible]];
            nodes = for (view in visibleViews) {
                view.cached = true;
                view.node;
            }
            views[center].cached = false;
        }
    }

    function createView(view:ShelfView, viewHeight:Number) {
        def viewWidth = viewHeight * shelf.aspectRatio;
        view.createView(viewWidth, viewHeight, topAspect, bottomAspect, reflectionEffect, shelf.preserveRatio);
    }

    function loadVisible() {
        loadVisible(getViewHeight());
    }

    function loadVisible(viewHeight:Number) {
        for (view in reverse visibleViews) {
            createView(view, viewHeight);
            def viewWidth = viewHeight * shelf.aspectRatio;
            def imageWidth = if (isInitialized(shelf.thumbnailWidth) and shelf.thumbnailWidth != -1) then shelf.thumbnailWidth else viewWidth;
            def imageHeight = if (isInitialized(shelf.thumbnailHeight) and shelf.thumbnailHeight != -1) then shelf.thumbnailHeight else viewHeight;
            view.loadImage(imageWidth, imageHeight);
        }
    }
}
