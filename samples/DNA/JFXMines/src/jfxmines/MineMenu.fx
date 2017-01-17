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
import javafx.scene.text.*;
import javafx.scene.control.*;
import javafx.scene.layout.*;
import javafx.scene.effect.light.*;
import javafx.geometry.HPos;
import org.jfxtras.scene.layout.Cell;
import org.jfxtras.scene.layout.Grid;
import org.jfxtras.scene.layout.LayoutConstants.*;

/**
 * @author David Armitage
 */

var menuPos = Main.c_sqSize * -8;          // bound position for timeline to pull out

//---- Standard fonts for menu
var smallFont = Font {
  name: "Arial"
  size: 10
  };
var smallFontBold = Font {
  name: "Arial Bold"
  size: 12
  };
var buttonFont = Font {
  name: "Arial Bold"
  size: 12
  };

//--------------------- timeline for menu slide --------------------------
var menu_tl: Timeline = Timeline {
  repeatCount: 1
  keyFrames: [
    at (0s) {menuPos => Main.c_sqSize * -8}
    at (1s) {menuPos => 0 tween Interpolator.EASEBOTH}
    ]
  };

//---------------------- Menu frame  --------------------------------------
var menuBox = Rectangle {
  width: Main.c_sqSize * 8
  height: Main.c_sqSize * 9
  stroke: Color.BLACK
  opacity: 0.9
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
        color: Color.LIGHTGREY
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

//--------------------------- Menu tab area and text ------------------------
var menuTab = Group {
  translateX: Main.c_sqSize * 7.75
  translateY: Main.c_sqSize * 0.5
  onMouseEntered: function(e) {
    menu_tl.rate = 1.0;
    menu_tl.play();
    }
  content: [
    Rectangle {
      opacity: 0.3
      x: 0
      y: 0
      width: Main.c_sqSize * 0.8
      height: 40
      fill: Color.LIGHTGRAY
      },
    Text {
      y: 20
      content: "menu"
      font: smallFont
      rotate: 90
      }
    ]
  };


//----------- Menu heading ---------------------------------------------
var labelSettings = Label {
  text: "Settings"
  };

//----------- Minefield size radio button group ------------------------
var tg1 = ToggleGroup {};
var radioBeginner = RadioButton {
  text: "Beginner (9x9 10)"
  toggleGroup: tg1
  blocksMouse: false
  };
var radioIntermediate = RadioButton {
  text: "Intermediate (16x16 40)"
  toggleGroup: tg1
  blocksMouse: false
  };
var radioAdvanced = RadioButton {
  text: "Advanced (30x16 100)"
  toggleGroup: tg1
  blocksMouse: false
  };

//----------------- Sound option ----------------------------------------
var checkSound = CheckBox {
  text: "Play sounds"
  blocksMouse: false
  selected: bind Main.isSoundOn with inverse
  layoutInfo: LayoutInfo {
    height: 35
    }
  };

//---------------- cancel, reset and confirm buttons ---------------------------
var buttonCancel = Button {
  text: "Cancel"
  blocksMouse: false
  width: bind Main.c_sqSize * 2.5
  action: function() {
    if (Main.mfSet == 0) then radioBeginner.selected = true;
    if (Main.mfSet == 1) then radioIntermediate.selected = true;
    if (Main.mfSet == 2) then radioAdvanced.selected = true;
    menu_tl.rate = -4.0;
    menu_tl.play();
    }
  };
var buttonOK = Button {
  text: "OK"
  blocksMouse: false
  width: bind Main.c_sqSize * 2.5
  action: function() {
    menu_tl.rate = -4.0;
    menu_tl.play();
    if (radioBeginner.selected) then Main.mfSet = 0;
    if (radioIntermediate.selected) then Main.mfSet = 1;
    if (radioAdvanced.selected) then Main.mfSet = 2;
    Main.mineStart();
    }
  };
var buttonReset = Button {
  text: "Reset Best Times"
  blocksMouse: false
//  width: bind Main.c_sqSize * 2.5
  action: function() {
    MineStore.setStore(true);       // set to true to reset the best times
    MineStore.getStore();           // and ensure reload them
    }
  };


var tGrid = Grid {
  border: 10
//  width: Main.c_sqSize * 8
//  scaleX: 0.8
//  scaleY: 0.8
  rows: [
    row( [ Cell { hspan: 3 content: Text {content: "Settings:"} prefWidth: Main.c_sqSize * 8 - 20 }]),
    row( [ Cell { hspan: 3 content: radioBeginner }]),
    row( [ Cell { hspan: 3 content: radioIntermediate }]),
    row( [ Cell { hspan: 3 content: radioAdvanced }]),
    row( [ Cell { hspan: 3 content: Text{ content: " "} prefHeight: 5 }]),
    row( [ Cell { hspan: 3 content: checkSound }]),
    row( [ Cell { hspan: 3 content: Text{ content: " "} prefHeight: 5 }]),
    row( [
      Cell { content: buttonCancel hpos: HPos.RIGHT prefWidth: Main.c_sqSize * 4 - 20 },
      Cell { content: Text{ content: ""} prefWidth: 20 },
      Cell { content: buttonOK hpos: HPos.LEFT prefWidth: Main.c_sqSize * 4 - 20 }
      ]),
    row( [ Cell { hspan: 3 content: Text{ content: " "} prefHeight: 5 }]),
    row( [ Cell { hspan: 3 content: buttonReset hpos: HPos.CENTER }]),
    ]
  };



//---------------- Finally assemble all the menu components together ------------------
//---------------- and add mouse entry
package var menuGroup = Group {
    translateX: bind menuPos
    translateY: Main.c_sqSize * 1.1
    blocksMouse: true
//    onMouseEntered: function(e) {
//    menu_tl.rate = 1.0;
//    menu_tl.play();
//    }
  onMouseExited: function(e) {
    menu_tl.rate = -1.0;
    menu_tl.play();
    }
  content: [
    menuTab,
    menuBox,
    tGrid
//    labelSettings,
//    Flow {
//      layoutY: 15
//      vertical: true
//      vgap: 5
//      nodeHPos: HPos.LEFT
//      scaleX: 0.8
//      scaleY: 0.8
//      width: Main.c_sqSize * 7
//      content: [
//        radioBeginner,
//        radioIntermediate,
//        radioAdvanced,
//        checkSound,
//        Flow {
//          width: Main.c_sqSize * 7
//          hpos: HPos.RIGHT
//          hgap: 20
//          content: [
//            buttonCancel,
//            buttonOK
//            ]
//          }
//        ]
//      }
    ]
  }

  public function setState(mfSet : Integer) : Void
    {
    if (mfSet == 0) then radioBeginner.selected = true;
    if (mfSet == 1) then radioIntermediate.selected = true;
    if (mfSet == 2) then radioAdvanced.selected = true;
    }

