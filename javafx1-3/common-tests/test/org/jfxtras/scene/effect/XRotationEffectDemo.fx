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
package org.jfxtras.scene.effect;

import javafx.animation.Timeline;
import javafx.scene.Scene;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;
import javafx.stage.Stage;
import javafx.stage.StageStyle;
import javafx.scene.layout.VBox;
import javafx.scene.control.Button;

/**
 * @author Stephen Chin
 * @author Keith Combs
 */
var angle:Number;

Timeline {
    repeatCount: Timeline.INDEFINITE
    keyFrames: [
        at (0s) {angle => 0}
        at (5s) {angle => 360}
    ]
}.play();

Stage {
    style: StageStyle.TRANSPARENT
    scene: Scene {
        width: 360
        height: 270
        var imageView:ImageView;
        // todo 1.3 - for some reason the mouse and key events only work with an enclosing box...  1.3 layout bug?
        content: VBox {
            content: [
                imageView = ImageView {
                    effect: XRotationEffect {
                        x: 30
                        y: 60
                        width: 300
                        height: 150
                        topAspect: -.25
                        bottomAspect: .15
                        angle: bind angle
                        vertical: bind not imageView.hover
                    }
                    image: Image {
                        url: "{__DIR__}BakuretsuTenshi.jpg"
                    }
                    onMousePressed: function(e) {
                        FX.exit();
                    }
                }
            ]
        }
        fill: null
    }
}
