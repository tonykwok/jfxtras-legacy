/*
 * Copyright (c) 2008-2009, David Armitage
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 * 1. Redistributions of source code must retain the above copyright notice,
 *    this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 * 3. The names of its contributors may not be used
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

package jfxmines;

import javafx.animation.*;
import javafx.scene.Group;
import javafx.scene.image.*;
import javafx.scene.paint.*;
import javafx.scene.shape.*;
import javafx.scene.text.*;
import jfxmines.*;

/**
 * @author David Armitage
 */

//------------------------------ unmarked mines panel assembly -----------------------
// group for the no of mines unmarked display panel and icon
var gmu = Group {
  content: [
    Text {
      content: bind Main.minesUnmarked.toString()
      font: Main.myFont
      }
    ]
  };

// final assembly for the mines marked panel
package var minesMarkedDisplay: Group = Group {
  translateY: bind (Main.mfHeight + 1) * Main.c_sqSize + Main.c_sqSize / 3
  translateX: bind (Main.mfWidth - 3) * Main.c_sqSize
  content: [
    Rectangle {
      width: Main.c_sqSize * 2
      height: Main.c_sqSize
      fill: Color.LIGHTGOLDENRODYELLOW
      stroke: Color.BLACK
      arcWidth: Main.c_sqSize / 2
      arcHeight: Main.c_sqSize / 2
      effect: Main.c_shadow
      },
    Group {
      translateX: bind ((Main.c_sqSize * 2) - gmu.layoutBounds.width) / 2
      translateY: (Main.c_sqSize * 9) / 10
      content: gmu
      },
    Circle {
      translateX: Main.c_sqSize * 3
      translateY: Main.c_sqSize / 2
      radius: Main.c_sqSize / 1.5
      fill: Color.LIGHTGOLDENRODYELLOW
      stroke: Color.BLACK
      effect: Main.c_shadow
      },
    ImageView {
      image: Image { url: "{__DIR__}images/Bomb68o.png" }
      fitWidth: Main.c_sqSize
      fitHeight: Main.c_sqSize
      translateX: Main.c_sqSize * 2.6
      }
    ]
  };

//------------------------------ elapsed time panel assembly -----------------------
// group for the elapsed time dislay panel and icon (so can use bounds to centre)
  var get = Group {
    content: [
      Text {
        content: bind "{Main.elapsedTime}"
        font: Main.myFont
        }
      ]
    };

// timeline for the elapsed time
package var et_tl: Timeline = Timeline {
  repeatCount: Timeline.INDEFINITE
  keyFrames: [
    KeyFrame {
      time: 1s
      action: function() { Main.elapsedTime++; }
      }
    ]
  };

// final assembly for the elapsed time panel
package var elapsedTimeDisplay: Group = Group {
  translateY: bind (Main.mfHeight + 1) * Main.c_sqSize + Main.c_sqSize / 3
  translateX: bind Main.c_sqSize * 3
  content: [
    Rectangle {
      width: 2 * Main.c_sqSize
      height: Main.c_sqSize
      fill: Color.LIGHTGOLDENRODYELLOW
      stroke: Color.BLACK
      arcWidth: Main.c_sqSize / 2
      arcHeight: Main.c_sqSize / 2
      effect: Main.c_shadow
      }
    Group {
      translateX: bind ((Main.c_sqSize * 2) - get.layoutBounds.width) / 2
      translateY: Main.c_sqSize * 0.9
      content: get
      },
    Circle {
      translateX: -Main.c_sqSize
      translateY: Main.c_sqSize / 2
      radius: Main.c_sqSize / 1.5
      fill: Color.LIGHTGOLDENRODYELLOW
      stroke: Color.BLACK
      effect: Main.c_shadow
      },
    ImageView {
      image: Image { url: "{__DIR__}images/Clock68.png" }
      fitWidth: Main.c_sqSize
      fitHeight: Main.c_sqSize
      translateX: -Main.c_sqSize * 1.5
      translateY: Main.c_sqSize / 24
      }
    ]
  };