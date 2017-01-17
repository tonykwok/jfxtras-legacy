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

import javafx.animation.KeyFrame;
import javafx.animation.Interpolator;
import javafx.animation.Timeline;
import javafx.scene.Node;
import javafx.scene.effect.Reflection;
import javafx.scene.layout.LayoutInfo;
import javafx.scene.layout.Panel;
import javafx.scene.layout.Priority;
import javafx.scene.paint.Color;
import javafx.scene.shape.Rectangle;
import javafx.scene.text.Text;
import javafx.scene.text.Font;
import javafx.scene.text.FontWeight;
import javafx.scene.effect.DropShadow;
import javafx.scene.effect.BlurType;
import javafx.scene.control.ScrollBar;
import javafx.scene.input.MouseEvent;
import javafx.scene.input.MouseButton;
import javafx.util.Math;
import org.jfxtras.util.SequenceUtil;
import org.jfxtras.scene.control.data.XShelfImageProvider;
import org.jfxtras.scene.control.skin.AbstractSkin;
import org.jfxtras.scene.control.skin.XCaspian;

/**
 * @author Stephen Chin
 * @author Keith Combs
 */
package class XShelfSkin extends AbstractSkin {
    public var highlightColor : Color = XCaspian.fxAccent;
    def sizeRatio = 0.7;
    def squeezeRatio = 0.3;
    def sideAngle = 45;
    def topAspect = .5;
    def bottomAspect = bind .2 + reflectionEffect.fraction * .7;

    var reflectionEffect:Reflection = bind if (shelf.reflection) Reflection{} else null;
    package var reflectionSizeMultiplier:Number = bind 1 + reflectionEffect.fraction;
    var animatingIndex:Number on replace {
        (node as Panel).requestLayout();
    }
    var firstVisible = -1;
    var lastVisible = -2;
    var center = 0;
    var views:XShelfItemView[] = bind if (shelf.dataProvider instanceof XShelfImageProvider) {
        for (data in shelf.dataProvider.getColumn(0, shelf.dataProvider.rowCount, "url")) XShelfItemView {
            shelf: shelf
            url: data.ref as String
            placeholder: shelf.getPlaceHolder();
        }
    } else {
        for (data in shelf.dataProvider.getColumn(0, shelf.dataProvider.rowCount, "node")) XShelfItemView {
            shelf: shelf
            view: data.ref as Node
            externalView: true
            placeholder: shelf.getPlaceHolder();
        }
    }

    var nodes:Node[];
    def imageTitle = bind if (shelf.showText) Text {
        content: bind shelf.dataProvider.getCell(shelf.wrapIndex(shelf.index), "name").ref as String
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
        max: bind sizeof shelf.imageUrls - 1
        blockIncrement: 5
        unitIncrement: 1
        layoutInfo: LayoutInfo {hgrow: Priority.ALWAYS, hfill: true, maxWidth: Integer.MAX_VALUE}
    } else null;

    var visibleViews:XShelfItemView[];
    def shelf = bind control as XShelfView on replace {
        animatingIndex = shelf.getBoundedIndex(shelf.index);
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
                        values: animatingIndex => shelf.getBoundedIndex(shelf.index) tween Interpolator.SPLINE(.05, .5, .5, .95)
                        action: function() {
                            var viewHeight = getViewHeight();
                            createViews(viewHeight);
                            loadVisible(viewHeight);
                            updateViews();
                        }
                    }
                ]
            }
            timeline.play();
        }
    }

    function eventOnCenter(e:MouseEvent):Boolean {
        var topView = visibleViews[sizeof visibleViews - 1];
        return topView.contains(e.x, e.y);
    }

    def transparentRectangle = Rectangle {
        fill: Color.TRANSPARENT
        var centerClicked:Boolean;
        var overCenter:Boolean;
        var pressedIndex:Integer = -1;
        var imageEntered:Integer = -1;

        onMousePressed: function(e) {
            for (view in reverse visibleViews) {
                if (view.contains(e.x, e.y)) {
                    shelf.requestFocus();
                    centerClicked = eventOnCenter(e);
                    if (not shelf.centerEventsOnly or eventOnCenter(e)){
                        shelf.onImagePressed(XShelfEvent{shelf: shelf, center: centerClicked, index: view.index, mouseEvent: e});
                    }
                    pressedIndex = view.index;
                    if (e.button == MouseButton.PRIMARY and not e.popupTrigger and not e.controlDown) {
                        shelf.index = pressedIndex;
                    }
                    return;
                }
            }
            pressedIndex = -1;
        }
        onMouseClicked: function(e) {
            if (not shelf.centerEventsOnly or centerClicked){
                shelf.onImageClicked(XShelfEvent{shelf: shelf, center: centerClicked, index: pressedIndex, mouseEvent: e});
            }
        }
        onMouseReleased: function(e) {
            if (pressedIndex != -1) {
                if (not shelf.centerEventsOnly or centerClicked) {
                    shelf.onImageReleased(XShelfEvent{shelf: shelf, center: centerClicked, index: pressedIndex, mouseEvent: e});
                }
                if (e.button == MouseButton.PRIMARY and not e.popupTrigger and not e.controlDown and centerClicked and visibleViews[sizeof visibleViews - 1].contains(e.x, e.y)) {
                    shelf.action(XShelfEvent{shelf: shelf, center: true, index: shelf.index, mouseEvent: e});
                    return;
                }
            }
        }
        onMouseWheelMoved: function(e) {
            shelf.index = shelf.getBoundedIndex(shelf.index + e.wheelRotation as Integer);
        }
        onMouseEntered: function(e){
            for (view in reverse visibleViews) {
                if (view.contains(e.x, e.y)) {
                    overCenter = eventOnCenter(e);
                    if (not shelf.centerEventsOnly or overCenter){
                        imageEntered = view.index;
                        shelf.onImageEntered(XShelfEvent{shelf: shelf, center: overCenter, index: view.index, mouseEvent: e});
                    }
                    return;
                }
            }
            imageEntered = -1;
            overCenter = false;
        }
        onMouseExited:function(e){
            if (imageEntered != -1 and (not shelf.centerEventsOnly or overCenter)){
                shelf.onImageExited(XShelfEvent{shelf: shelf, center: overCenter, index: imageEntered, mouseEvent: e});
                imageEntered = -1;
                overCenter = false;
            }
        }
        onMouseMoved:function(e){
            for (view in reverse visibleViews) {
                if (view.contains(e.x, e.y)) {
                    // need exit events even if no longer over center
                    if (imageEntered != -1 and imageEntered != view.index and (not shelf.centerEventsOnly or overCenter)){
                        shelf.onImageExited(XShelfEvent{shelf: shelf, center: overCenter, index: imageEntered, mouseEvent: e});
                    }
                    overCenter = eventOnCenter(e);
                    if (not shelf.centerEventsOnly or overCenter){
                        if (imageEntered != view.index){
                            shelf.onImageEntered(XShelfEvent{shelf: shelf, center: overCenter, index: view.index, mouseEvent: e});
                        }

                    }
                    imageEntered = view.index;
                    return;
                }
            }
            if (imageEntered != -1 and (not shelf.centerEventsOnly or overCenter)){
                shelf.onImageExited(XShelfEvent{shelf: shelf, center: overCenter, index: imageEntered, mouseEvent: e});
                imageEntered = -1;
                overCenter = false;
            }
        }
    }

    override var behavior = XShelfBehavior {}

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
        clip.y = -shelf.height;
        clip.height = shelf.height * 3;
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
            var adjustedWidth = height * shelf.aspectRatio;
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
            view.setAngle(angle);
            view.resizeView(viewHeight, viewHeight * shelf.aspectRatio);
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
        var newFirstVisible = Math.round(animatingIndex - numNodes - shelf.preloadLeftDepth) as Integer;
        var newLastVisible = Math.round(animatingIndex + numNodes + shelf.preloadRightDepth) as Integer;
        if (not shelf.wrap and newFirstVisible < 0) {
            newFirstVisible = 0;
        }
        if (not shelf.wrap and newLastVisible >= sizeof views) {
            newLastVisible = sizeof views - 1;
        }
        def newCenter = Math.round(animatingIndex) as Integer;
        if (newFirstVisible != firstVisible or newLastVisible != lastVisible or newCenter != center) {
            SequenceUtil.updateWindow(views, firstVisible, lastVisible, newFirstVisible, newLastVisible,
                function(e, i:Integer) {(views[shelf.wrapIndex(i)]).cacheView()}, null);
            firstVisible = newFirstVisible;
            lastVisible = newLastVisible;
            center = newCenter;
            var visibleSize = (Math.max(shelf.preloadLeftDepth, shelf.preloadRightDepth) + Math.round(numNodes) as Integer) * 2;
            for (i in [firstVisible..lastVisible]) {
                views[shelf.wrapIndex(i)].index = Integer.MAX_VALUE;
            }
            visibleViews = reverse (for (i in [0..visibleSize]) {
                var index = center + (i mod 2) * i - i / 2;
                var adjustedIndex = shelf.wrapIndex(index);
                if (index < firstVisible or index > lastVisible or views[adjustedIndex].index != Integer.MAX_VALUE) {
                    null
                } else {
                    views[adjustedIndex].index = index;
                    views[adjustedIndex];
                }
            });
            createViews(viewHeight);
            if (timeline == null or not timeline.running) {
                loadVisible(viewHeight);
            }
            updateViews();
        }
    }

    function createView(view:XShelfItemView, viewHeight:Number) {
        def viewWidth = viewHeight * shelf.aspectRatio;
        view.createView(viewWidth, viewHeight, topAspect, bottomAspect, reflectionEffect, shelf.preserveRatio);
    }

    function createViews(viewHeight:Number) {
        for (view in reverse visibleViews) {
            createView(view, viewHeight);
        }
    }

    function loadVisible(viewHeight:Number) {
        for (view in reverse visibleViews) {
            def viewWidth = viewHeight * shelf.aspectRatio;
            def imageWidth = if (isInitialized(shelf.thumbnailWidth) and shelf.thumbnailWidth != -1) then shelf.thumbnailWidth else viewWidth;
            def imageHeight = if (isInitialized(shelf.thumbnailHeight) and shelf.thumbnailHeight != -1) then shelf.thumbnailHeight else viewHeight;
            view.loadImage(imageWidth, imageHeight);
        }
    }

    function updateViews() {
        nodes = for (view in visibleViews) {
            view.cached = true;
            view.highlighted = shelf.focused and view.index == shelf.index;
            view.node;
        }
        views[center].cached = false;
    }

}
