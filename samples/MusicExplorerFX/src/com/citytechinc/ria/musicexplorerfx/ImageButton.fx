/*
 * Copyright (c) 2009, Sten Anderson, CITYTECH, INC.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 * 1. Redistributions of source code must retain the above copyright notice,
 *    this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 * 3. Neither the name of CITYTECH, INC. nor the names of its contributors may be used
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
 
package com.citytechinc.ria.musicexplorerfx;
import javafx.animation.transition.FadeTransition;
import javafx.scene.CustomNode;
import javafx.scene.effect.Effect;
import javafx.scene.effect.Glow;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;
import javafx.scene.input.MouseEvent;
import javafx.scene.Node;

/**
 * @author sanderson
 */

public class ImageButton extends CustomNode {

    public var x: Number;
    public var y: Number;
    public var w: Number;

    public var imageUrl: String on replace {createImage()};
    public var enabled = false;
    public var active = true;
    public var action: function():Void;

    var imageView:ImageView;
    var curEffect: Effect;

    var introTransition:FadeTransition;
    var image:Image;

    override function create():Node {
        imageView = ImageView {
            opacity: if (enabled) 1 else 0
            image: bind image
            translateX: bind x
            translateY: bind y
            effect: bind curEffect

            onMousePressed: function(me:MouseEvent):Void {
                if (not enabled or not active) {
                    return;
                }

                curEffect = Glow {
                    level: 1.0
                }
            }
            onMouseReleased: function(me:MouseEvent):Void {
                curEffect = null;
                if (not active) {
                    return;
                }

                if (enabled) {
                    action();
                }
            }
            onMouseEntered: function(me:MouseEvent):Void {
                if (not enabled) {
                    return;
                }

                curEffect = Glow {
                    level: 0.4
                }

            }
            onMouseExited: function(me:MouseEvent):Void {
                curEffect = null;
            }
        }

        introTransition = FadeTransition {
            duration: 2s
            node: imageView
            fromValue: 0
            toValue: 1
            action: function() { enabled = true };
        }
        //layoutInfo = LayoutInfo { width: w height: imageView.image.height }
        //layoutInfo = LayoutInfo { width: 50 height: 50 }

        imageView
    }

    function createImage():Void {
        image = Image {
            url: "{__DIR__}images/IconsShortNoGloss/{imageUrl}"
            preserveRatio: true
            width: w
        }
    }


    public function dismiss():Void {
        if (introTransition != null and introTransition.running) {
            introTransition.stop();
        }
        else if (not enabled) {
            return;
        }

        enabled = false;
        FadeTransition {
            duration: 0.5s
            node: imageView
            fromValue: 1
            toValue: 0
        }.play();
    }


    public function intro():Void {
        introTransition.playFromStart();
    }


}
