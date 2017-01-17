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
package org.jfxtras.scene;

import javafx.scene.Scene;
import javafx.scene.text.Text;
import javafx.scene.text.Font;
import javafx.scene.paint.*;
import javafx.scene.shape.Rectangle;
import javafx.animation.Timeline;

/**
 * A scene that is used in the JXSceneAnimatingDemo
 *
 * @author jclarke
 */
public class JXSceneAnimatingScene extends Scene {
    var xx = 0.0;
    var yy = 0.0;
    var rotate = 0.0;

    var tl = Timeline {
         repeatCount: 999999999//.INDEFINITE
         autoReverse: true
         keyFrames : [
             at(0s) {
                 xx => 0.0;
                 yy => 0.0;
                 rotate=>0.0;
             },
             at(5s) {
                 xx=>200;
                 yy=>250;
                 rotate => 180;
             }
         ]
     }
     override var content= [
         Rectangle {
            width: 250, height: 250
            fill: Color.SKYBLUE
        },
        Text {
            font : Font {
                size: 24
            }
            layoutX: bind xx, layoutY: bind yy
            rotate: bind rotate
            content: "Hello World"
            fill: Color.RED
        }
    ];

    init { tl.play(); }
}
