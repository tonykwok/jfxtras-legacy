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

package org.jfxtras.scene.shape;

import javafx.animation.Interpolator;
import javafx.animation.Timeline;
import javafx.scene.Scene;
import javafx.scene.effect.Glow;
import javafx.scene.input.MouseButton;
import javafx.scene.layout.Stack;
import javafx.scene.paint.Color;
import javafx.stage.Screen;
import javafx.stage.Stage;
import javafx.stage.StageStyle;
import javafx.util.Math;

/**
 * @author Stephen Chin
 */
def stageSize = 400;

function addSphere(x:Number, y:Number, radius:Number, initialHue:Integer):Void {
    var sphere:Sphere = Sphere {
        var hue = initialHue;
        effect: bind if (sphere.hover) Glow {} else null
        centerX: radius
        centerY: radius
        radius: radius
        shadowHeight: y + stageSize;
        base: bind Color.hsb(hue, 1.0, 1.0)
        specular: bind Color.hsb(hue - 40, 0.9, 0.7)
        var startRadius:Number;
        var startHue:Integer;
        var pressedButton:MouseButton;
        onMousePressed: function(e) {
            startRadius = sphere.radius;
            startHue = hue;
            pressedButton = e.button;
        }
        onMouseDragged: function(e) {
            if (pressedButton == MouseButton.PRIMARY) {
                stage.x = e.screenX - e.dragAnchorX;
                stage.y = e.screenY - e.dragAnchorY;
            } else if (pressedButton == MouseButton.SECONDARY) {
                sphere.radius = Math.min(150, Math.max(20, startRadius + e.dragY));
                hue = startHue + e.dragX as Integer;
            }
        }
        onMouseClicked: function(e) {
            if (e.button == MouseButton.PRIMARY) {
                var radius = 20 + Math.random() * 130;
                var bounds = Screen.primary.visualBounds;
                var x = bounds.minX + (bounds.width - stageSize) * Math.random();
                var y = bounds.minY + (bounds.height - stageSize) * Math.random();
                addSphere(x, y, radius, Math.random() * 360);
            } else if (e.button == MouseButton.SECONDARY) {
                FX.exit();
            }
        }
    }
    var stage = Stage {
        x: x
        y: -stageSize
        style: StageStyle.TRANSPARENT
        width: stageSize
        height: stageSize
        scene: Scene {
            content: Stack {
                width: stageSize
                height: stageSize
                content: sphere
            }
            fill: null
        }
    }
    Timeline {
        var verySlowOut = Interpolator.SPLINE(.05, .5, .5, .95);
        keyFrames: at (1s) {
            stage.y => y tween verySlowOut;
            sphere.shadowHeight => 0 tween verySlowOut;
        }
    }.play();
}

var bounds = Screen.primary.bounds;
addSphere(bounds.minX + (bounds.width - stageSize) / 2, bounds.minY + (bounds.height - stageSize) / 2, 100, 245);
