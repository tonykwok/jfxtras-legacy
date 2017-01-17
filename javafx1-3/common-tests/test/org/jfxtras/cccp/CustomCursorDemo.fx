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
package org.jfxtras.cccp;

import javafx.scene.Scene;
import javafx.scene.effect.Lighting;
import javafx.scene.effect.light.DistantLight;
import javafx.scene.image.Image;
import javafx.scene.paint.Color;
import javafx.scene.paint.LinearGradient;
import javafx.scene.paint.Stop;
import javafx.stage.Stage;
import javafx.scene.shape.Circle;

import javafx.scene.Cursor;

/**
 * IMPORTANT: You need to specify -Djavafx.toolkit=org.jfxtras.cccp.Toolkit as
 * a JVM runtime argument when you require custom cursors and/or are assigning
 * a texture paint to a Scene's fill variable. Of course, jfxtras.jar(s) must be
 * included in the CLASSPATH.
 *
 * @author bastardised by David
 * @author original Jeff Friesen
 */
def OPENHAND = CustomCursor
{
    url: "{__DIR__}demoresources/openhand.gif"
    name: "open"
}

def CLOSEDHAND = CustomCursor
{
    url: "{__DIR__}demoresources/closedhand.gif"
    name: "close"
}

var startX = 0.0;
var startY = 0.0;

var draggableCircle:Circle = Circle {
    centerX: 30.0
    centerY: 30.0
    radius: 30.0
    fill: Color.RED
    effect: Lighting { light: DistantLight { azimuth: -135 } surfaceScale: 5 }
    cursor: OPENHAND
    onMousePressed: function(me) {
        startX = me.sceneX - draggableCircle.translateX;
        startY = me.sceneY - draggableCircle.translateY;
        draggableCircle.cursor = CLOSEDHAND;
        draggableCircle.visible = false;   // this flip of visibility is purely to force the cursor to change
        draggableCircle.visible = true;    // as it wont change unless another mouse event occurs
    }
    onMouseDragged: function(me) {
        var tx = me.sceneX - startX;
        if (tx < 0) then tx = 0;
        if (tx > sceneRef.width - draggableCircle.boundsInLocal.width)
            then tx = sceneRef.width - draggableCircle.boundsInLocal.width;
        draggableCircle.translateX = tx;

        var ty = me.sceneY - startY;
        if (ty < 0) then ty = 0;
        if (ty > sceneRef.height - draggableCircle.boundsInLocal.height)
            then ty = sceneRef.height - draggableCircle.boundsInLocal.height;
        draggableCircle.translateY = ty
    }
    onMouseReleased: function(me) { 
        draggableCircle.cursor = OPENHAND;
        draggableCircle.visible = false;   // this flip of visibility is purely to force the cursor to change
        draggableCircle.visible = true;    // as it wont change unless another mouse event occurs
        }
};

var sceneRef: Scene;

Stage
{
    title: "Custom Cursors Demo"
    width: 350
    height: 350
    icons:[
        Image { url: "{__DIR__}demoresources/icon16x16.png" },
        Image { url: "{__DIR__}demoresources/icon32x32.png" }
    ]
    scene: sceneRef = Scene {
        fill: LinearGradient {
            startX: 0.0
            startY: 0.0
            endX: 0.0
            endY: 1.0
            stops: [
                Stop {
                    offset: 0.0
                    color: Color.BLUE
                },
                Stop {
                    offset: 1.0
                    color: Color.ALICEBLUE
                }
            ]
        }
        content: draggableCircle
    }
}