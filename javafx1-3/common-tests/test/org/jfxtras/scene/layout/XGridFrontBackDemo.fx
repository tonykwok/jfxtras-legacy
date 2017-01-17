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
package org.jfxtras.scene.layout;

import javafx.animation.Timeline;
import javafx.animation.KeyFrame;
import javafx.scene.input.MouseEvent;
import javafx.scene.paint.Color;
import javafx.scene.shape.Rectangle;
import javafx.scene.transform.Transform;
import javafx.stage.Stage;
import javafx.util.Math;
import org.jfxtras.scene.XScene;

import javafx.scene.effect.DropShadow;

/**
 * @author Stephen Chin
 */
// todo 1.3 - for some reason the window sizing and alignment are funky
function bringToFront(e:MouseEvent):Void {
    e.source.toFront();
}

var rectangles = for (i in [1..10]) Rectangle {
    effect: DropShadow {}
    width: 50
    height: 100
    transforms: Transform.scale(2, 1)
    fill: Color.WHITESMOKE
    stroke: Color.color(Math.random(), Math.random(), Math.random())
    strokeWidth: 10
    onMouseEntered: bringToFront
}
function rotateRectangle() {
    def last = rectangles[sizeof rectangles - 1];
    delete rectangles[sizeof rectangles - 1];
    insert last before rectangles[0];
}

Stage {
    title: "Rectangle order should be preserved"
    width: 730
    height: 150
    scene: XScene {
        content: XGrid {
            hgap: 0
            // todo - set margins to 0
            rows: bind XGridLayoutInfo.row(rectangles)
        }
    }
}

Timeline {
    repeatCount: Timeline.INDEFINITE
    keyFrames: KeyFrame {
        time: 1s
        action: rotateRectangle
    }
}.play();
