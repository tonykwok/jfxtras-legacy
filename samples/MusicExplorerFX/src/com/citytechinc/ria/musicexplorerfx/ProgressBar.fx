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
import javafx.animation.Timeline;
import javafx.animation.transition.FadeTransition;
import javafx.scene.CustomNode;
import javafx.scene.Group;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;
import javafx.scene.Node;
import javafx.scene.paint.Color;
import javafx.scene.shape.Rectangle;

/**
 * @author sanderson
 */

public class ProgressBar extends CustomNode {
    
    public var max:Integer;
    public var value:Integer;
    public var w:Number;

    var rect:Rectangle;
    var ft:FadeTransition;
    var stopped = false;
    var rectWidth:Number = bind w - 6;
    var active = false;

    override public function create():Node {
        opacity = 0;
        rect = Rectangle {
            opacity: 0
            fill: Color.rgb(155, 200, 250)
            width: bind if (max > 0) rectWidth * (value / (max * 1.0)) else rectWidth
            height: 20
            arcWidth: 20
            arcHeight: 20
            x: 4
            y: 13
        }
        ft = FadeTransition {
            autoReverse: true
            repeatCount: Timeline.INDEFINITE
            node: rect
            duration: 1s
            fromValue: 0
            toValue: 1
        }


        Group {
            content: [
                rect,
                ImageView {
                    image: Image {
                        url: "{__DIR__}images/GlassBar.png"
                        preserveRatio: true
                        width: w
                    }
                }

            ]
        }
    }

    public function setProgress(v:Integer, m:Integer) {
        value = v;
        max = m;
    }

    public function dismiss() {
        if (not active) {
            return;
        }

        active = false;
        ft.stop();
        FadeTransition {
            node: this
            toValue: 0
            duration: 1s
        }.play();

    }


    public function setIndeterminate() {
        active = true;
        max = 0;
        value = 0;
        stopped = false;
        rect.opacity = 0;
        FadeTransition {
            node: this
            toValue: 1
            duration: 1s
            action: function() {if (not stopped) ft.playFromStart()}
        }.play();
        
    }

    public function stop() {
        active = true;
        stopped = true;
        ft.stop();
        rect.opacity = 1;
    }

}
