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
package org.jfxtras.scene.paint;

import javafx.animation.Timeline;
import javafx.scene.Scene;
import javafx.scene.shape.Rectangle;
import javafx.scene.paint.Paint;
import javafx.scene.paint.Stop;
import javafx.scene.paint.Color;

/**
 * @author Liu Huasong
 */
def stops0 = [
    Stop {
      offset:0 color:Color.WHITE
    }
    Stop {
      offset:1 color:Color.BLACK
    }
];

def stops1 = [
    Stop {
      offset:0 color:Color.BLACK
    }
    Stop {
      offset:1 color:Color.WHITE
    }
];

var color:Paint = XLinearGradient {endX:1 endY:0 stops:stops0};

def timeline = Timeline {
    repeatCount: Timeline.INDEFINITE
    framerate: 25
    keyFrames: [
        at(12s) {
            color => XLinearGradient {endX:0 endY:1 stops:stops1}
        }
    ]
}

def rect:Rectangle = Rectangle {
        fill: bind color
         width: 600
         height: 400
         onMouseClicked: function(e) {
             timeline.playFromStart();
         }
     }

Scene {
     content: [ rect ]
}