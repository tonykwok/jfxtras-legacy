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

import java.lang.Math;
import java.lang.Object;
import java.util.*;
import javafx.scene.effect.*;
import javafx.scene.Group;
import javafx.scene.image.*;
import javafx.scene.paint.*;
import javafx.scene.Scene;
import javafx.scene.shape.*;
import javafx.scene.text.*;
import javafx.stage.*;
import jfxmines.*;
import javafx.scene.effect.light.*;
import javafx.scene.input.MouseEvent;
import javafx.animation.*;

/**
 * @author David Armitage
 */

//---- Bound variables
package var stageX: Number;                 // read from properties - default 300 - adjusted by drag
package var stageY: Number;                 // read from properties - default 300 - adjusted by drag

package var minesUnmarked : Integer = 0;    // not really - is difference between marked mines and number of mines

//var uiScale: Scale = Scale {
//  x: bind sqSize / c_sqSize
//  y: bind sqSize / c_sqSize
//};

package var fastestEasy: Integer;               // fastest time at each level - read from properties - default 999
package var fastestIntermediate: Integer;
package var fastestHard: Integer;
package var fastestPerfTest: Integer;

package var endResult: Integer;
package def BESTTIME = 0;
package def CLEARED = 1;
package def DEAD = 2;

package var c_sqSize = 24;        // essential size of the UI - defines size of one gridsquare used to size all elements

package var mfSet: Integer;            // set from properties - 0, 1 or 2 ( 3 is silly for perf test)

//---- settings for each minefield variant
var s_mfHeight = [9, 16, 16, 30];               // Height of minefield in squares
var s_mfWidth  = [9, 16, 30, 50];               // Width of minefield in squares
var s_mfMines  = [10, 40, 100, 300];            // Mines planted
var s_mfLevel = ["Easy", "Intermediate", "Hard", "Performance Test"];     // level description
var s_mfBest = bind [fastestEasy, fastestIntermediate, fastestHard, fastestPerfTest];    // level best time
package var mfHeight = bind s_mfHeight[mfSet];
package var mfWidth  = bind s_mfWidth[mfSet];
package var mfMines = bind s_mfMines[mfSet];
package var mfLevel = bind s_mfMines[mfSet];
package var mfBest = bind s_mfBest[mfSet];

package var isSoundOn: Boolean;                 // global sound flag - set from properties

package var panelSize = 2;                      // how many mine squares high for bottom panel
package var sqList : GridSquare[];              // minefield object list
var         sqList2 : GridSquare[];             // purely to stage the minefield so binds dont slow startup
package var isRevealAll : Boolean = false;      // finished so reveal all
package var squaresUncovered : Integer = 0;     // count uncovered to detect end condition
package var elapsedTime : Integer = 0;          // time in seconds - could make time string


// preload all required images for reference by GridSquares
  package var imgHidden = Image {
    url: "{__DIR__}images/Hidden68.png" };
  package var imgCross = Image {
    url: "{__DIR__}images/BombCross68.png" };
  package var imgBomb = Image {
    url: "{__DIR__}images/Bomb68a.png" };
  package var imgBang = Image {
    url: "{__DIR__}images/Bang68.png" };
  package var imgSkull = Image {
    url: "{__DIR__}images/SkullBlue68.png" };
  package var imgNumber: Image[] = [
    Image {url: "{__DIR__}images/Number0.png" }
    Image {url: "{__DIR__}images/Number1.png" }
    Image {url: "{__DIR__}images/Number2.png" }
    Image {url: "{__DIR__}images/Number3.png" }
    Image {url: "{__DIR__}images/Number4.png" }
    Image {url: "{__DIR__}images/Number5.png" }
    Image {url: "{__DIR__}images/Number6.png" }
    Image {url: "{__DIR__}images/Number7.png" }
    Image {url: "{__DIR__}images/Number8.png" }
    ];

// global lighting effect
  package var lightEffect = Lighting {
    light: DistantLight {
      azimuth: 90
      elevation: 60
      }
    };

// Standard shadow effect
  package var c_shadow = InnerShadow{
    offsetX: c_sqSize / 8
    offsetY: c_sqSize / 8
    color: Color.BLACK
    };

// Standard font for main panel display
  package var myFont = Font {
    name: "Arial Bold"
    size: 20
    };
  package var myFont2 = Font {
    name: "Arial"
    size: 16
    };

//------------------------------ close button assembly -----------------------
var closeButton = Group {
  translateX: bind (mfWidth + 1) * c_sqSize
  blocksMouse: true
  content: [
    Rectangle {
      x: c_sqSize * 0.1
      y: c_sqSize * 0.1
      arcHeight: 5
      arcWidth: 5
      width: c_sqSize * 0.8,
      height: c_sqSize * 0.8
      fill: Color.TRANSPARENT
//      stroke: Color.BLACK
      onMouseClicked: function( e: MouseEvent ):Void { 
        mineExit();
        }
      },
    Text {
      font: Font {
        size: 20
        name: "Arial Bold"
        }
      x: c_sqSize * 0.3
      y: c_sqSize * 0.75
      content: "x"
      }
    ]
  };

//------------------------------ scene display panel and drag -----------------------
var mainPanel = Rectangle {
  width: bind (mfWidth + 2) * c_sqSize
  height: bind (mfHeight + 3) * c_sqSize
  stroke: Color.BLACK
  effect: Lighting {
    light: DistantLight {
      azimuth: 270
      elevation: 60
      }
    surfaceScale: 5
    }
  onMouseDragged: function(e) {
    stageX = e.screenX - e.dragAnchorX;
    stageY = e.screenY - e.dragAnchorY;

    }
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
        color: Color.GRAY
        }
      ]
    }
  };

// outline for the minefield
var fieldBox = Rectangle {
  translateY: c_sqSize - 1
  translateX: c_sqSize - 1
  width: bind mfWidth * c_sqSize + 1
  height: bind mfHeight * c_sqSize + 1
  fill: null
  stroke: Color.BLACK
  }

var mineScene = Scene {
    content: bind[
      mainPanel,
      Text {
        x: c_sqSize y:18
        content: "JFX Minesweeper"
        font: myFont2
        }
      fieldBox,
      sqList,
      MinePanel.elapsedTimeDisplay,
      MinePanel.minesMarkedDisplay,
      MineEnd.alertGroup,
      MineMenu.menuGroup,
      closeButton
      ]
    };

var mineStage = Stage {
    title: "JFX Minesweeper"
    x: bind stageX with inverse
    y: bind stageY with inverse
    width: bind (mfWidth + 2) * c_sqSize
    height: bind (mfHeight + 3) * c_sqSize
    style: StageStyle.UNDECORATED
    scene: bind mineScene
    }

public function mineStart() : Void
  {
  var m: Integer;
  var random = new Random;
  var minesLeftToPlant = mfMines;

  tl.stop();
  MineEnd.alert_tl.rate = -1.0;
  MineEnd.alert_tl.play();
  isRevealAll = false;
  minesUnmarked = mfMines;
  squaresUncovered = 0;
  sqList2 = null;
  MineMenu.setState(mfSet);

// create the minefield
  for (i in [1..Main.mfHeight])
    {
    for (j in [1..Main.mfWidth])
      {
      insert
      GridSquare
        {
        visible: true
        mineX: j
        mineY: i
        } into sqList2
      }
    }
  sqList = sqList2;       // make the bind only apply after all minefield created
  sqList2 = null;

// insert the required number of mines
  while ( minesLeftToPlant > 0 )
    {
    m = Math.abs(random.nextInt() mod (mfWidth * mfHeight));
    if (not sqList[m].isMine)
      {
      sqList[m].isMine = true;
      minesLeftToPlant--;
      }
    }

// start the clock!
  elapsedTime = 0;
  MinePanel.et_tl.play();
  }

public function mineExit() {
  MineStore.setStore(false);
  FX.exit();
  }


public function run() {
  MineStore.getStore();

//  PlaySound.TEST.play();
  PlaySound.volume = PlaySound.Volume.LOW;
  mineStart();
  }

//----- Finished or stepped on a mine so show the minefield using small animation
  public  var tl : Timeline;

  public function revealAll() : Void
    {
    isRevealAll = true;
    var m = 0;
    var cm : GridSquare;
    var pcm : GridSquare;

    tl = Timeline {
      repeatCount: sqList.size()
      keyFrames: [
        KeyFrame {
          time: .02s
          action: function() {
            cm = sqList[m] as GridSquare;
            cm.setMineGlow(0.4);
            pcm.setMineGlow(0.0);
            if (cm.isHidden) cm.checkMine();      // check every one that is still hidden
            pcm = cm;
            m++;
            if (m >= Main.sqList.size()) then
              {
              pcm.setMineGlow(0.0);     // make sure last one is reset
              MineEnd.alert_tl.rate = 1.0;
              MineEnd.alert_tl.play();  // and display end alert
              }
            }
          }
        ]
      };
    tl.play();
    }

