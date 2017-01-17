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
import javafx.animation.Timeline;
import javafx.scene.Group;
import javafx.scene.Node;
import javafx.scene.effect.Effect;
import javafx.scene.effect.Reflection;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;
import javafx.scene.layout.Container;
import javafx.scene.layout.Resizable;
import javafx.scene.paint.Color;
import javafx.scene.shape.Rectangle;
import javafx.scene.shape.Polygon;
import java.lang.ref.SoftReference;
import org.jfxtras.scene.effect.XRotationEffect;
import org.jfxtras.scene.image.XImage;

/**
 * @author Stephen Chin
 * @author Keith Combs
 */
package class XShelfItemView {
    public var shelf:XShelfView;
    public var index:Integer;
    public var placeholder:Image;
    public var url:String;
    public var node:Group;
    public var cached:Boolean;
    public var highlighted:Boolean on replace oldHighlight=newHighlight {
        if (oldHighlight != newHighlight) {
            updateHighlight();
        }
    }
    var rotationEffect:XRotationEffect;
    var image:Image;
    public-init var view:Node;
    public var externalView: Boolean;
    var imageCache:SoftReference;
    var cachedImageWidth:Number;
    var cachedImageHeight:Number;
    var cachedViewWidth:Number;
    var cachedViewHeight:Number;
    var cachedPreserveRatio:Boolean;
    var highlight:Polygon;
    
    public function createView(viewWidth:Number, viewHeight:Number, topAspect:Number, bottomAspect:Number, nestedEffect:Effect, preserveRatio:Boolean):Void {
        if (rotationEffect == null or rotationEffect.input != nestedEffect or
            rotationEffect.topAspect != topAspect or rotationEffect.bottomAspect != bottomAspect) {
            rotationEffect = XRotationEffect {
                topAspect: topAspect
                bottomAspect: bottomAspect
                input: nestedEffect
            }
            node = null;
        }
        if (cachedPreserveRatio != preserveRatio) {
            node = null;
            imageCache = null;
            image = null;
        }
        resizeView(cachedViewWidth, cachedViewHeight);
        cachedPreserveRatio = preserveRatio;
        createNode();
    }

    var polyShape:Polygon;

    function createNode() {
        if (node != null) {
            return;
        }
        if (image == null) {
            if (imageCache != null) {
                image = imageCache.get() as Image;
            }
            if (image == null) {
                image = placeholder;
            }
        }
        if (highlight == null and shelf.showHighlight) {
            highlight = Polygon {
                scaleX: 1.02
                scaleY: 1.02
                fill: (shelf.skin as XShelfSkin).highlightColor
                opacity: 0.5
            }
        }
        if (cachedPreserveRatio) {
            if (not externalView) {
                view = ImageView {
                    preserveRatio: cachedPreserveRatio
                    layoutX: bind (cachedViewWidth - view.layoutBounds.width) / 2;
                    layoutY: bind cachedViewHeight - view.layoutBounds.height;
                    fitWidth: bind cachedViewWidth
                    fitHeight: bind cachedViewHeight
                    image: bind image
                }
            }

            node = Group {
                content: [
                    highlight,
                    Group {
                        cache: bind cached
                        content: [
                            Rectangle {
                                width: bind cachedViewWidth
                                height: bind cachedViewHeight
                                fill: Color.TRANSPARENT
                            }
                            view
                        ]
                        effect: rotationEffect
                    }
                ]
            }
        } else {
            if (not externalView) {
                view = ImageView {
                    cache: bind cached
                    image: bind image
                }
            }

            node = Group {
                content: [
                    highlight,
                    Group {
                        content: view
                        effect: rotationEffect
                    }
                ]
            }
        }
        FX.deferAction(updateHighlight);
    }

    public function resizeView(width:Number, height:Number) {
        if (cachedViewWidth != width or cachedViewHeight != height) {
            cachedViewWidth = width;
            cachedViewHeight = height;
            if (view instanceof Resizable and view.managed) {
                var resizable = view as Resizable;
                resizable.width = width;
                resizable.height = height;
            }
        }
    }

    // Workaround for bugs in PerspectiveTransform/caching with regard
    // to hardware acceleration.
    // Note: Added a second use -- for updating the highlight after image load
    var needsTwiddle = false;
    var progress:Number = bind image.progress on replace {
        if (needsTwiddle and progress == 100) {
            needsTwiddle = false;
            updateHighlight(); // try it once (for fast refresh)
            Timeline {
                keyFrames: KeyFrame {
                    time: 100ms
                    action: function() {
                        var oldImage = image;
                        image = null;
                        image = oldImage;
                        updateHighlight(); // try it a second time...
                    }
                }
            }.play();
        }
    }

    public function loadImage(imageWidth:Number, imageHeight:Number) {
        if (imageWidth > cachedImageWidth or imageHeight > cachedImageHeight) {
            imageCache = null;
            image = null;
        }
        if (image == null or image == placeholder) {
            needsTwiddle = true;
            cachedImageWidth = imageWidth;
            cachedImageHeight = imageHeight;
            image = XImage {
                width: cachedImageWidth
                height: cachedImageHeight
                backgroundLoading: true
                url: url
                placeholder: placeholder
                preserveRatio: cachedPreserveRatio
            }
        }
    }

    public function cacheView():Void {
        rotationEffect = null;
        (view.parent as Group).content = null; // Whack the parent to get rid of the "infernal" scenegraph warning
        node = null;
        highlight = null;
        if (not externalView) view = null;
        imageCache = new SoftReference(image);
        image = null;
    }

    public function setAngle(angle:Number):Void {
        if (rotationEffect.angle != angle) {
            rotationEffect.angle = angle;
            updateHighlight();
        }
    }

    public function setPosition(x:Number, y:Number):Void {
        node.layoutX = x;
        node.layoutY = y;
    }

    public function setSize(width:Number, height:Number):Void {
        if (rotationEffect.width != width or rotationEffect.height != height) {
            rotationEffect.width = width;
            rotationEffect.height = height;
            updateHighlight();
        }
    }

    function updateHighlight():Void {
        if (highlighted) {
            highlight.points = getBoundingPoints();
        } else {
            highlight.points = null;
        }
    }

    function getBoundingPoints() {
        var rect = view.boundsInParent;
        var w = cachedViewWidth;
        var reflectionMultiplier = if (rotationEffect.input instanceof Reflection) then (rotationEffect.input as Reflection).fraction + 1 else 1;
        var h = cachedViewHeight * reflectionMultiplier;
        var ul = rotationEffect.mapLocalToTransformed(rect.minX / w, rect.minY / h);
        var ur = rotationEffect.mapLocalToTransformed(rect.maxX / w, rect.minY / h);
        var ll = rotationEffect.mapLocalToTransformed(rect.minX / w, rect.maxY / h );
        var lr = rotationEffect.mapLocalToTransformed(rect.maxX / w, rect.maxY / h);
        return [ul.x, ul.y, ur.x, ur.y, lr.x, lr.y, ll.x, ll.y];
    }

    public function contains(x:Number, y:Number):Boolean {
        var bounds = Polygon {
            points: getBoundingPoints()
        }
        return bounds.contains(x - node.layoutX, y - node.layoutY);
    }
}
