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

package scoreboard;


import javafx.scene.paint.Color;
import java.lang.String;

import javafx.scene.CustomNode;


import javafx.scene.image.Image;


import javafx.scene.Group;

import javafx.scene.image.ImageView;

import javafx.scene.effect.BlendMode;

/**
 * @author David
 */
def gridIndex = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789*:,.\"!>(<-+?);'/ @$£%";
def gridLetters = [
  Image { url: "{__DIR__}grids/CharA.png" },
  Image { url: "{__DIR__}grids/CharB.png" },
  Image { url: "{__DIR__}grids/CharC.png" },
  Image { url: "{__DIR__}grids/CharD.png" },
  Image { url: "{__DIR__}grids/CharE.png" },
  Image { url: "{__DIR__}grids/CharF.png" },
  Image { url: "{__DIR__}grids/CharG.png" },
  Image { url: "{__DIR__}grids/CharH.png" },
  Image { url: "{__DIR__}grids/CharI.png" },
  Image { url: "{__DIR__}grids/CharJ.png" },
  Image { url: "{__DIR__}grids/CharK.png" },
  Image { url: "{__DIR__}grids/CharL.png" },
  Image { url: "{__DIR__}grids/CharM.png" },
  Image { url: "{__DIR__}grids/CharN.png" },
  Image { url: "{__DIR__}grids/CharO.png" },
  Image { url: "{__DIR__}grids/CharP.png" },
  Image { url: "{__DIR__}grids/CharQ.png" },
  Image { url: "{__DIR__}grids/CharR.png" },
  Image { url: "{__DIR__}grids/CharS.png" },
  Image { url: "{__DIR__}grids/CharT.png" },
  Image { url: "{__DIR__}grids/CharU.png" },
  Image { url: "{__DIR__}grids/CharV.png" },
  Image { url: "{__DIR__}grids/CharW.png" },
  Image { url: "{__DIR__}grids/CharX.png" },
  Image { url: "{__DIR__}grids/CharY.png" },
  Image { url: "{__DIR__}grids/CharZ.png" },
  Image { url: "{__DIR__}grids/Char_a.png" },
  Image { url: "{__DIR__}grids/Char_b.png" },
  Image { url: "{__DIR__}grids/Char_c.png" },
  Image { url: "{__DIR__}grids/Char_d.png" },
  Image { url: "{__DIR__}grids/Char_e.png" },
  Image { url: "{__DIR__}grids/Char_f.png" },
  Image { url: "{__DIR__}grids/Char_g.png" },
  Image { url: "{__DIR__}grids/Char_h.png" },
  Image { url: "{__DIR__}grids/Char_i.png" },
  Image { url: "{__DIR__}grids/Char_j.png" },
  Image { url: "{__DIR__}grids/Char_k.png" },
  Image { url: "{__DIR__}grids/Char_l.png" },
  Image { url: "{__DIR__}grids/Char_m.png" },
  Image { url: "{__DIR__}grids/Char_n.png" },
  Image { url: "{__DIR__}grids/Char_o.png" },
  Image { url: "{__DIR__}grids/Char_p.png" },
  Image { url: "{__DIR__}grids/Char_q.png" },
  Image { url: "{__DIR__}grids/Char_r.png" },
  Image { url: "{__DIR__}grids/Char_s.png" },
  Image { url: "{__DIR__}grids/Char_t.png" },
  Image { url: "{__DIR__}grids/Char_u.png" },
  Image { url: "{__DIR__}grids/Char_v.png" },
  Image { url: "{__DIR__}grids/Char_w.png" },
  Image { url: "{__DIR__}grids/Char_x.png" },
  Image { url: "{__DIR__}grids/Char_y.png" },
  Image { url: "{__DIR__}grids/Char_z.png" },
  Image { url: "{__DIR__}grids/Char0.png" },
  Image { url: "{__DIR__}grids/Char1.png" },
  Image { url: "{__DIR__}grids/Char2.png" },
  Image { url: "{__DIR__}grids/Char3.png" },
  Image { url: "{__DIR__}grids/Char4.png" },
  Image { url: "{__DIR__}grids/Char5.png" },
  Image { url: "{__DIR__}grids/Char6.png" },
  Image { url: "{__DIR__}grids/Char7.png" },
  Image { url: "{__DIR__}grids/Char8.png" },
  Image { url: "{__DIR__}grids/Char9.png" },
  Image { url: "{__DIR__}grids/Char_asterisk.png" },
  Image { url: "{__DIR__}grids/Char_colon.png" },
  Image { url: "{__DIR__}grids/Char_comma.png" },
  Image { url: "{__DIR__}grids/Char_dot.png" },
  Image { url: "{__DIR__}grids/Char_doubleQuote.png" },
  Image { url: "{__DIR__}grids/Char_exclamation.png" },
  Image { url: "{__DIR__}grids/Char_greaterThan.png" },
  Image { url: "{__DIR__}grids/Char_leftBracket.png" },
  Image { url: "{__DIR__}grids/Char_lessThan.png" },
  Image { url: "{__DIR__}grids/Char_minus.png" },
  Image { url: "{__DIR__}grids/Char_plus.png" },
  Image { url: "{__DIR__}grids/Char_question.png" },
  Image { url: "{__DIR__}grids/Char_rightBracket.png" },
  Image { url: "{__DIR__}grids/Char_semicolon.png" },
  Image { url: "{__DIR__}grids/Char_singleQuote.png" },
  Image { url: "{__DIR__}grids/Char_slash.png" },
  Image { url: "{__DIR__}grids/Char_space.png" },
  Image { url: "{__DIR__}grids/Char_arrowDown.png" },
  Image { url: "{__DIR__}grids/Char_arrowLeft.png" },
  Image { url: "{__DIR__}grids/Char_arrowRightpng" },
  Image { url: "{__DIR__}grids/Char_arrowUp.png" },
  ];

def lightColors = [
  Image { url: "{__DIR__}grids/GridRed.png" },
  Image { url: "{__DIR__}grids/GridGreen.png" },
  Image { url: "{__DIR__}grids/GridBlue.png" },
  Image { url: "{__DIR__}grids/GridYellow.png" },
  Image { url: "{__DIR__}grids/GridAmber.png" },
  Image { url: "{__DIR__}grids/GridCyan.png" },
  Image { url: "{__DIR__}grids/GridMagenta.png" },
  ];

public def RED      = 0;
public def GREEN    = 1;
public def BLUE     = 2;
public def YELLOW   = 3;
public def AMBER    = 4;
public def CYAN     = 5;
public def MAGENTA  = 6;

public class ScoreChar extends CustomNode
  {
  public var letter: String;
  public var lightColor: Integer;

  override public function create()
    {
    Group {
      blendMode: BlendMode.COLOR_BURN
      content: [
        ImageView { image: gridLetters[gridIndex.indexOf(letter)] },
        ImageView { image: lightColors[lightColor] },
        ]
      }
    }

  }
