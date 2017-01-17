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
import javafx.animation.Timeline;
import javafx.scene.Group;
import javafx.scene.Node;
import javafx.scene.effect.Effect;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;
import javafx.scene.paint.Color;
import javafx.scene.shape.Rectangle;
import java.lang.ref.SoftReference;
import org.jfxtras.scene.effect.RotationEffect;
import org.jfxtras.scene.image.ImageFix;

/**
 * @author Stephen Chin
 * @author Keith Combs
 */
package class ShelfView {
    public var index:Integer;
    public var placeholder:Image;
    public var url:String;
    public var node:Node;
    public var cached:Boolean;
    var rotationEffect:RotationEffect;
    var image:Image;
    var imageCache:SoftReference;
    var cachedImageWidth:Number;
    var cachedImageHeight:Number;
    var cachedViewWidth:Number;
    var cachedViewHeight:Number;
    var cachedPreserveRatio:Boolean;
    
    public function createView(viewWidth:Number, viewHeight:Number, topAspect:Number, bottomAspect:Number, nestedEffect:Effect, preserveRatio:Boolean):Void {
        if (rotationEffect == null or rotationEffect.input != nestedEffect or
            rotationEffect.topAspect != topAspect or rotationEffect.bottomAspect != bottomAspect) {
            rotationEffect = RotationEffect {
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
        cachedViewWidth = viewWidth;
        cachedViewHeight = viewHeight;
        cachedPreserveRatio = preserveRatio;
        createNode();
    }

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
        if (cachedPreserveRatio) {
            node = Group {
                var view:ImageView;
                cache: bind cached
                content: [
                    Rectangle {
                        width: bind cachedViewWidth
                        height: bind cachedViewHeight
                        fill: Color.TRANSPARENT
                    }
                    view = ImageView {
                        preserveRatio: cachedPreserveRatio
                        layoutX: bind (cachedViewWidth - view.layoutBounds.width) / 2;
                        layoutY: bind cachedViewHeight - view.layoutBounds.height;
                        fitWidth: bind cachedViewWidth
                        fitHeight: bind cachedViewHeight
                        image: bind image
                    }
                ]
                effect: rotationEffect
            }
        } else {
            node = ImageView {
                cache: bind cached
                image: bind image
                effect: rotationEffect
            }
        }
    }

    // Workaround for bugs in PerspectiveTransform/caching with regard
    // to hardware acceleration.
    var needsTwiddle = false;
    var progress:Number = bind image.progress on replace {
        if (needsTwiddle and progress == 100) {
            needsTwiddle = false;
            Timeline {
                keyFrames: KeyFrame {
                    time: 100ms
                    action: function() {
                        var oldImage = image;
                        image = null;
                        image = oldImage;
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
            image = ImageFix {
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
        node = null;
        imageCache = new SoftReference(image);
        image = null;
    }

    public function setAngle(angle:Number):Void {
        rotationEffect.angle = angle;
    }

    public function setPosition(x:Number, y:Number):Void {
        node.layoutX = x;
        node.layoutY = y;
    }

    public function setSize(width:Number, height:Number):Void {
        rotationEffect.width = width;
        rotationEffect.height = height;
    }

    public function contains(x:Number, y:Number):Boolean {
        var boundary = rotationEffect.getBounds();
        return boundary.contains(x - node.layoutX, y - node.layoutY);
    }
}
