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
package  org.jfxtras.scene.gadget;

import java.lang.String;
import javafx.scene.CustomNode;
import javafx.scene.image.Image;
import javafx.scene.Group;
import javafx.scene.image.ImageView;
import javafx.scene.effect.BlendMode;

/**
 * @author David
 */
def gridIndex = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789*:,.\"!>(<-+?);'/ @$£%ÇüéâäàåçêëèïîìÄÅÉæÆôöòûùÿÖÜøØáíóúñÑÁÂÀãÃðÐÊËÈıÍÎÏÌÓßÔÒõÕµþÞÚÛÙýÝ";

def gridLetters = [
  Image { url: "{__DIR__}scoreboardgrids/CharA.png" },
  Image { url: "{__DIR__}scoreboardgrids/CharB.png" },
  Image { url: "{__DIR__}scoreboardgrids/CharC.png" },
  Image { url: "{__DIR__}scoreboardgrids/CharD.png" },
  Image { url: "{__DIR__}scoreboardgrids/CharE.png" },
  Image { url: "{__DIR__}scoreboardgrids/CharF.png" },
  Image { url: "{__DIR__}scoreboardgrids/CharG.png" },
  Image { url: "{__DIR__}scoreboardgrids/CharH.png" },
  Image { url: "{__DIR__}scoreboardgrids/CharI.png" },
  Image { url: "{__DIR__}scoreboardgrids/CharJ.png" },
  Image { url: "{__DIR__}scoreboardgrids/CharK.png" },
  Image { url: "{__DIR__}scoreboardgrids/CharL.png" },
  Image { url: "{__DIR__}scoreboardgrids/CharM.png" },
  Image { url: "{__DIR__}scoreboardgrids/CharN.png" },
  Image { url: "{__DIR__}scoreboardgrids/CharO.png" },
  Image { url: "{__DIR__}scoreboardgrids/CharP.png" },
  Image { url: "{__DIR__}scoreboardgrids/CharQ.png" },
  Image { url: "{__DIR__}scoreboardgrids/CharR.png" },
  Image { url: "{__DIR__}scoreboardgrids/CharS.png" },
  Image { url: "{__DIR__}scoreboardgrids/CharT.png" },
  Image { url: "{__DIR__}scoreboardgrids/CharU.png" },
  Image { url: "{__DIR__}scoreboardgrids/CharV.png" },
  Image { url: "{__DIR__}scoreboardgrids/CharW.png" },
  Image { url: "{__DIR__}scoreboardgrids/CharX.png" },
  Image { url: "{__DIR__}scoreboardgrids/CharY.png" },
  Image { url: "{__DIR__}scoreboardgrids/CharZ.png" },
  Image { url: "{__DIR__}scoreboardgrids/Char_a.png" },
  Image { url: "{__DIR__}scoreboardgrids/Char_b.png" },
  Image { url: "{__DIR__}scoreboardgrids/Char_c.png" },
  Image { url: "{__DIR__}scoreboardgrids/Char_d.png" },
  Image { url: "{__DIR__}scoreboardgrids/Char_e.png" },
  Image { url: "{__DIR__}scoreboardgrids/Char_f.png" },
  Image { url: "{__DIR__}scoreboardgrids/Char_g.png" },
  Image { url: "{__DIR__}scoreboardgrids/Char_h.png" },
  Image { url: "{__DIR__}scoreboardgrids/Char_i.png" },
  Image { url: "{__DIR__}scoreboardgrids/Char_j.png" },
  Image { url: "{__DIR__}scoreboardgrids/Char_k.png" },
  Image { url: "{__DIR__}scoreboardgrids/Char_l.png" },
  Image { url: "{__DIR__}scoreboardgrids/Char_m.png" },
  Image { url: "{__DIR__}scoreboardgrids/Char_n.png" },
  Image { url: "{__DIR__}scoreboardgrids/Char_o.png" },
  Image { url: "{__DIR__}scoreboardgrids/Char_p.png" },
  Image { url: "{__DIR__}scoreboardgrids/Char_q.png" },
  Image { url: "{__DIR__}scoreboardgrids/Char_r.png" },
  Image { url: "{__DIR__}scoreboardgrids/Char_s.png" },
  Image { url: "{__DIR__}scoreboardgrids/Char_t.png" },
  Image { url: "{__DIR__}scoreboardgrids/Char_u.png" },
  Image { url: "{__DIR__}scoreboardgrids/Char_v.png" },
  Image { url: "{__DIR__}scoreboardgrids/Char_w.png" },
  Image { url: "{__DIR__}scoreboardgrids/Char_x.png" },
  Image { url: "{__DIR__}scoreboardgrids/Char_y.png" },
  Image { url: "{__DIR__}scoreboardgrids/Char_z.png" },
  Image { url: "{__DIR__}scoreboardgrids/Char0.png" },
  Image { url: "{__DIR__}scoreboardgrids/Char1.png" },
  Image { url: "{__DIR__}scoreboardgrids/Char2.png" },
  Image { url: "{__DIR__}scoreboardgrids/Char3.png" },
  Image { url: "{__DIR__}scoreboardgrids/Char4.png" },
  Image { url: "{__DIR__}scoreboardgrids/Char5.png" },
  Image { url: "{__DIR__}scoreboardgrids/Char6.png" },
  Image { url: "{__DIR__}scoreboardgrids/Char7.png" },
  Image { url: "{__DIR__}scoreboardgrids/Char8.png" },
  Image { url: "{__DIR__}scoreboardgrids/Char9.png" },
  Image { url: "{__DIR__}scoreboardgrids/Char_asterisk.png" },
  Image { url: "{__DIR__}scoreboardgrids/Char_colon.png" },
  Image { url: "{__DIR__}scoreboardgrids/Char_comma.png" },
  Image { url: "{__DIR__}scoreboardgrids/Char_dot.png" },
  Image { url: "{__DIR__}scoreboardgrids/Char_doubleQuote.png" },
  Image { url: "{__DIR__}scoreboardgrids/Char_exclamation.png" },
  Image { url: "{__DIR__}scoreboardgrids/Char_greaterThan.png" },
  Image { url: "{__DIR__}scoreboardgrids/Char_leftBracket.png" },
  Image { url: "{__DIR__}scoreboardgrids/Char_lessThan.png" },
  Image { url: "{__DIR__}scoreboardgrids/Char_minus.png" },
  Image { url: "{__DIR__}scoreboardgrids/Char_plus.png" },
  Image { url: "{__DIR__}scoreboardgrids/Char_question.png" },
  Image { url: "{__DIR__}scoreboardgrids/Char_rightBracket.png" },
  Image { url: "{__DIR__}scoreboardgrids/Char_semicolon.png" },
  Image { url: "{__DIR__}scoreboardgrids/Char_singleQuote.png" },
  Image { url: "{__DIR__}scoreboardgrids/Char_slash.png" },
  Image { url: "{__DIR__}scoreboardgrids/Char_space.png" },
  Image { url: "{__DIR__}scoreboardgrids/Char_arrowDown.png" },
  Image { url: "{__DIR__}scoreboardgrids/Char_arrowLeft.png" },
  Image { url: "{__DIR__}scoreboardgrids/Char_arrowRight.png" },
  Image { url: "{__DIR__}scoreboardgrids/Char_arrowUp.png" },
  Image { url: "{__DIR__}scoreboardgrids/Char_128.png" }, // Ç
  Image { url: "{__DIR__}scoreboardgrids/Char_129.png" }, // ü
  Image { url: "{__DIR__}scoreboardgrids/Char_130.png" }, // é
  Image { url: "{__DIR__}scoreboardgrids/Char_131.png" }, // â
  Image { url: "{__DIR__}scoreboardgrids/Char_132.png" }, // ä
  Image { url: "{__DIR__}scoreboardgrids/Char_133.png" }, // à
  Image { url: "{__DIR__}scoreboardgrids/Char_134.png" }, // å
  Image { url: "{__DIR__}scoreboardgrids/Char_135.png" }, // ç
  Image { url: "{__DIR__}scoreboardgrids/Char_136.png" }, // ê
  Image { url: "{__DIR__}scoreboardgrids/Char_137.png" }, // ë
  Image { url: "{__DIR__}scoreboardgrids/Char_138.png" }, // è
  Image { url: "{__DIR__}scoreboardgrids/Char_139.png" }, // ï
  Image { url: "{__DIR__}scoreboardgrids/Char_140.png" }, // î
  Image { url: "{__DIR__}scoreboardgrids/Char_141.png" }, // ì
  Image { url: "{__DIR__}scoreboardgrids/Char_142.png" }, // Ä
  Image { url: "{__DIR__}scoreboardgrids/Char_143.png" }, // Å
  Image { url: "{__DIR__}scoreboardgrids/Char_144.png" }, // É
  Image { url: "{__DIR__}scoreboardgrids/Char_145.png" }, // æ
  Image { url: "{__DIR__}scoreboardgrids/Char_146.png" }, // Æ
  Image { url: "{__DIR__}scoreboardgrids/Char_147.png" }, // ô
  Image { url: "{__DIR__}scoreboardgrids/Char_148.png" }, // ö
  Image { url: "{__DIR__}scoreboardgrids/Char_149.png" }, // ò
  Image { url: "{__DIR__}scoreboardgrids/Char_150.png" }, // û
  Image { url: "{__DIR__}scoreboardgrids/Char_151.png" }, // ù
  Image { url: "{__DIR__}scoreboardgrids/Char_152.png" }, // ÿ
  Image { url: "{__DIR__}scoreboardgrids/Char_153.png" }, // Ö
  Image { url: "{__DIR__}scoreboardgrids/Char_154.png" }, // Ü
  Image { url: "{__DIR__}scoreboardgrids/Char_155.png" }, // ø
  Image { url: "{__DIR__}scoreboardgrids/Char_157.png" }, // Ø
  Image { url: "{__DIR__}scoreboardgrids/Char_160.png" }, // á
  Image { url: "{__DIR__}scoreboardgrids/Char_161.png" }, // í
  Image { url: "{__DIR__}scoreboardgrids/Char_162.png" }, // ó
  Image { url: "{__DIR__}scoreboardgrids/Char_163.png" }, // ú
  Image { url: "{__DIR__}scoreboardgrids/Char_164.png" }, // ñ
  Image { url: "{__DIR__}scoreboardgrids/Char_165.png" }, // Ñ
  Image { url: "{__DIR__}scoreboardgrids/Char_181.png" }, // Á
  Image { url: "{__DIR__}scoreboardgrids/Char_182.png" }, // Â
  Image { url: "{__DIR__}scoreboardgrids/Char_183.png" }, // À
  Image { url: "{__DIR__}scoreboardgrids/Char_198.png" }, // ã
  Image { url: "{__DIR__}scoreboardgrids/Char_199.png" }, // Ã
  Image { url: "{__DIR__}scoreboardgrids/Char_208.png" }, // ð
  Image { url: "{__DIR__}scoreboardgrids/Char_209.png" }, // Ð
  Image { url: "{__DIR__}scoreboardgrids/Char_210.png" }, // Ê
  Image { url: "{__DIR__}scoreboardgrids/Char_211.png" }, // Ë
  Image { url: "{__DIR__}scoreboardgrids/Char_212.png" }, // È
  Image { url: "{__DIR__}scoreboardgrids/Char_213.png" }, // ı
  Image { url: "{__DIR__}scoreboardgrids/Char_214.png" }, // Í
  Image { url: "{__DIR__}scoreboardgrids/Char_215.png" }, // Î
  Image { url: "{__DIR__}scoreboardgrids/Char_216.png" }, // Ï
  Image { url: "{__DIR__}scoreboardgrids/Char_222.png" }, // Ì
  Image { url: "{__DIR__}scoreboardgrids/Char_225.png" }, // ß
  Image { url: "{__DIR__}scoreboardgrids/Char_226.png" }, // Ô
  Image { url: "{__DIR__}scoreboardgrids/Char_227.png" }, // Ò
  Image { url: "{__DIR__}scoreboardgrids/Char_228.png" }, // õ
  Image { url: "{__DIR__}scoreboardgrids/Char_229.png" }, // Õ
  Image { url: "{__DIR__}scoreboardgrids/Char_230.png" }, // µ
  Image { url: "{__DIR__}scoreboardgrids/Char_231.png" }, // þ
  Image { url: "{__DIR__}scoreboardgrids/Char_232.png" }, // Þ
  Image { url: "{__DIR__}scoreboardgrids/Char_233.png" }, // Ú
  Image { url: "{__DIR__}scoreboardgrids/Char_234.png" }, // Û
  Image { url: "{__DIR__}scoreboardgrids/Char_235.png" }, // Ù
  Image { url: "{__DIR__}scoreboardgrids/Char_236.png" }, // ý
  Image { url: "{__DIR__}scoreboardgrids/Char_237.png" }, // Ý
  ];

def lightColors = [
  Image { url: "{__DIR__}scoreboardgrids/GridRed.png" },
  Image { url: "{__DIR__}scoreboardgrids/GridGreen.png" },
  Image { url: "{__DIR__}scoreboardgrids/GridBlue.png" },
  Image { url: "{__DIR__}scoreboardgrids/GridYellow.png" },
  Image { url: "{__DIR__}scoreboardgrids/GridAmber.png" },
  Image { url: "{__DIR__}scoreboardgrids/GridCyan.png" },
  Image { url: "{__DIR__}scoreboardgrids/GridMagenta.png" },
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
        ImageView { image: bind gridLetters[gridIndex.indexOf(letter)] },
        ImageView { image: bind lightColors[lightColor] },
        ]
      }
    }

  }