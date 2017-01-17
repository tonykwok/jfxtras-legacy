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

import javafx.scene.*;
import javafx.scene.effect.Glow;
import javafx.scene.image.*;
import javafx.scene.input.MouseEvent;
import jfxmines.*;

/**
 * @author David Armitage
 */
public class GridSquare extends CustomNode {

  public-init var mineX : Integer;
  public-init var mineY : Integer;

  public var isHidden : Boolean = true;   // gridsquare not exposed yet
  public var isMine : Boolean = false;    // is it a mine? Public for setup process
  var isMarked : Boolean = false;         // is it marked as a mine by user
  var mineGlow = 0.0;                     // bound for glow effect
  var img: Image = Main.imgHidden;        // bound image used for gridsquare


//----- Expose or mark a gridsquare
  function checkClick(e:MouseEvent):Void {
    if (Main.isRevealAll)
      {
      MineEnd.alert_tl.rate = 1.0;
      MineEnd.alert_tl.play();
      return;
      }
    if (not isHidden) then return;            // already exposed
    if (e.primaryButtonDown)
      {
      if (not isMarked) then checkMine();
      }
    else
      {
      markMine();    // so mark it as mine
      // and check if we just marked the last mine and all non-mines uncovered
      if (((Main.squaresUncovered + Main.mfMines) == (Main.mfWidth * Main.mfHeight))
        and Main.minesUnmarked == 0) then minesSolved();
      }
    }

//----- Check if a mine against the mine sequence (used both when clicking and in finish process)
  public function checkMine(): Void
    {
    if (isMine)
      {
      foundMine();
      }
    else
      {
      if (not Main.isRevealAll)
        {
        countNearby();      // not a mine and not finished so see if nearby ones should cascade clear
        }
      else
        {
        if (isMarked) then img = Main.imgCross;   // not a mine and finished so if marked is in error
        }
      }
    }

//----- Scan neighbours for count of mines nearby
  public function countNearby(): Void
    {
    isHidden = false;               // unhide
    var mc = 0;
    for (mX in [(mineX - 1)..(mineX + 1)]) {
      if (mX < 1 or mX > Main.mfWidth) then continue;
      for (mY in [(mineY - 1)..(mineY + 1)]) {
        if (mY < 1 or mY > Main.mfHeight) then continue;
        if (Main.sqList[(mY - 1) * Main.mfWidth + mX - 1].isMine) then mc++;
        }
      }
    img = Main.imgNumber[mc];           // pick up the image equivalent for the count of mines nearby
    if (Main.isSoundOn) then PlaySound.UNCOVER.play();
    Main.squaresUncovered++;
    // if not currently finished and everything marked then do end process
    if (Main.isRevealAll == false
     and ((Main.squaresUncovered + Main.mfMines) == (Main.mfWidth * Main.mfHeight))
     and Main.minesUnmarked == 0) then minesSolved();
    // if no neighbouring mines and not finished then recurse through neighbours
    if (mc == 0 and not Main.isRevealAll) checkNeighbours();
    // if finished and this is marked as a mine then is an error
    if (Main.isRevealAll and isMarked) then img = Main.imgCross;
  }

//----- So - we landed on a mine
  public function foundMine(): Void
    {
    if (Main.isRevealAll)
      {
      if (isHidden and not isMarked)
        {
        img = Main.imgBomb        // finished and this is hidden and not marked show it was a bomb avoided
        }
       else
        {
        var xx = 0; // dummy else
        }
      }
     else
      {
      img = Main.imgBang;         // not finished so this is a BANG
      isHidden = false;
      minesDead();
      }
    }

//----- Count nearby ones without the self check
  function checkNeighbours() 
  {
    var cm : GridSquare;
    for (mX in [mineX - 1..mineX + 1]) {
      if (mX < 1 or mX > Main.mfWidth) continue;
      for (mY in [mineY - 1..mineY + 1]) {
        if (mY < 1 or mY > Main.mfHeight) continue;
        if (mX == 0 and mY == 0) continue;
        cm = Main.sqList[(mY - 1) * Main.mfWidth + mX - 1] as GridSquare;
        if (cm.isHidden) cm.countNearby();
      }
    }
  }


//----- mark or unmark gridsquare on right click
  function markMine()
    {
    if (isHidden)
      {
      if (Main.isSoundOn) then PlaySound.MARK.play();
      if (isMarked)
        {
        img = Main.imgHidden;
        isMarked = false;
        Main.minesUnmarked++;
        }
       else
        {
        img = Main.imgSkull;
        isMarked = true;
        Main.minesUnmarked--;
        }
      }
    }

//-------------- Blown up ----------------------------
  function minesDead()
    {
    Main.endResult = Main.DEAD;
    if (Main.isSoundOn) then PlaySound.EXPLODE.play();
    MinePanel.et_tl.stop();
    Main.revealAll();
    }

//--------------- successful clearance ----------------
  function minesSolved()
    {
    Main.endResult = Main.CLEARED;
    MinePanel.et_tl.stop();
    if (Main.elapsedTime < Main.mfBest)
      {
      PlaySound.BESTTIME.play();
      Main.endResult = Main.BESTTIME;
      if (Main.mfSet == 0) then Main.fastestEasy = Main.elapsedTime;
      if (Main.mfSet == 1) then Main.fastestIntermediate = Main.elapsedTime;
      if (Main.mfSet == 2) then Main.fastestHard = Main.elapsedTime;
      if (Main.mfSet == 3) then Main.fastestPerfTest = Main.elapsedTime;
      }
     else
      {
      PlaySound.CLEARED.play();
      }
    Main.revealAll();
    }

//----- set mine glow value utility
  public function setMineGlow(newGlow: Number)
    {
    mineGlow = newGlow;
    }

//----- The Node!
  override public function create(): Node
    {
    return Group {
      blocksMouse: true 
      translateX: mineX * Main.c_sqSize
      translateY: mineY * Main.c_sqSize
      onMousePressed: function( e : MouseEvent ) { checkClick(e) }
      onMouseEntered: function(evt: MouseEvent):Void { mineGlow = 0.15; }
      onMouseExited: function(evt: MouseEvent):Void { mineGlow = 0.0; }
      content: [
        ImageView {
          image: bind img
          fitWidth: Main.c_sqSize
          fitHeight: Main.c_sqSize
          effect: Glow {
            level: bind mineGlow
            }
//****          effect: Main.lightEffect
          }
        ]
      }
    }
  }

