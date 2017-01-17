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

import jfxmines.*;
import javafx.animation.*;
import javafx.scene.effect.*;
import javafx.scene.Group;
import javafx.scene.paint.*;
import javafx.scene.shape.*;
import javafx.scene.control.*;
import javafx.scene.effect.light.*;
import javafx.scene.text.Text;
import javafx.scene.text.TextAlignment;
import javafx.scene.layout.VBox;
import javafx.geometry.HPos;

import org.jfxtras.scene.layout.Grid;
import org.jfxtras.scene.layout.LayoutConstants.*;
import org.jfxtras.scene.layout.Cell;

/**
 * @author David Armitage
 */
var alertSize = Main.c_sqSize * 8;        // make alert window 8 squares high and wide
var alertPosX = bind Main.c_sqSize * Main.mfWidth / 2 + Main.c_sqSize - alertSize / 2;    // bound centre x position for dialogue
var alertPosY = bind Main.c_sqSize * Main.mfHeight / 2 + Main.c_sqSize - alertSize / 2;   // bound centre y position for dialogue
var alertOpacity = 0.0        // for binding
  on replace oldValue {
    if (alertOpacity == 0) then alertVisible = false;
    if (oldValue == 0) then alertVisible = true;
    };
var alertVisible = false;

var endMsg = ["Congratulations!\n \nYou cleared the Minefield and did it in the quickest time so far for this level!",
              "Well done.\n \nYou cleared the Minefield.\rTry again and see if you can get the quickest time for this level!",
              "Hard Luck!\n \nFortunately this is only a game!\rTry again and see if you can survive!"];

//--------------------- timeline for alert fade --------------------------
package var alert_tl: Timeline = Timeline {
  repeatCount: 1

  keyFrames: [
    at (0s) {alertOpacity => 0.0}
    at (1s) {alertOpacity => 1.0 } //tween Interpolator.EASEBOTH}
    ]
  };

//---------------------- Alert frame  --------------------------------------
var alertBox = Rectangle {
  width: alertSize
  height: alertSize
  stroke: Color.BLACK
  fill: LinearGradient {
    startX: 0
    startY: 0
    endX: 1
    endY: 1
    proportional: true
    stops: [
      Stop {
        offset: 0.0
        color: Color.WHITE
        },
      Stop {
        offset: 1.0
        color: Color.GREY
        }
      ]
    }
  effect: Lighting {
    light: DistantLight {
      azimuth: 90
      elevation: 60
      }
    surfaceScale: 3
    diffuseConstant: 1.2
    }
  };

//----------- Alert end message ---------------------------------------------
var labelEndMsg = Text {
  textAlignment: TextAlignment.CENTER
  wrappingWidth: alertSize - 20
  content: bind endMsg[Main.endResult]
  };
//----------- time status ---------------------------------------------
var labelYourTime = Text {
  content: bind "Your time: {Main.elapsedTime} seconds"
  };
//----------- best time status ---------------------------------------------
var labelBestTime = Text {
  content: bind "Best time: {Main.mfBest} seconds"
  };

var buttonRetry = Button {
  text: "Retry"
  blocksMouse: false
  width: bind Main.c_sqSize * 2.5
  action: function() {
    Main.mineStart();
    }
  };

var buttonExit = Button {
  text: "Exit"
  blocksMouse: false
  width: bind Main.c_sqSize * 2.5
  action: function() {
    Main.mineExit();
    }
  };

var tGrid = Grid {
  width: alertSize - 20
  border: 0

  rows: [
    row([ 
      Cell { content:buttonRetry minWidth: (alertSize - 30) / 2 hpos: HPos.RIGHT},
      Cell { content: Text{ content: ""} prefWidth: 20 },
      Cell { content:buttonExit minWidth: (alertSize - 30) / 2 hpos: HPos.LEFT}
      ])
    ]
  };

//---------------- Finally assemble all the menu components together ------------------
package var alertGroup = Group {
  layoutX: bind alertPosX
  layoutY: bind alertPosY
  opacity: bind alertOpacity
  visible: bind alertVisible
  blocksMouse: true
  content: [
    alertBox,
    VBox {
      layoutY: 10
      layoutX: 10
      width: alertSize - 20
      height: alertSize - 20
      spacing: 10
      content: bind [
        labelEndMsg,
        labelYourTime,
        labelBestTime,
        tGrid
        ]
      },
    ]
  }
