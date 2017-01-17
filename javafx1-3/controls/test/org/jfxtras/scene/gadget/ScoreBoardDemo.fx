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

import javafx.stage.Stage;
import javafx.scene.Scene;
import javafx.scene.layout.VBox;
import javafx.scene.control.Button;
import javafx.animation.KeyFrame;
import javafx.animation.Timeline;
import javafx.scene.Group;
import javafx.scene.layout.Tile;
import org.jfxtras.scene.control.XPicker;
import org.jfxtras.scene.control.XPickerType;
import javafx.scene.text.Text;
import javafx.scene.layout.LayoutInfo;

import javafx.scene.control.ToggleButton;

/**
 * @author David
 */
var sb: ScoreBoard;
var s1: ScoreLine = ScoreLine { line: " " spaceAfter: 10 };
var s2: ScoreLine;

var s1a = "      Medals Ceremony      ";
var s1b = "  Athens Paralympics 2004  ";

var s1TL = Timeline {
  repeatCount: Timeline.INDEFINITE
  keyFrames : [
    KeyFrame {
      time: 2s
      action: function() { if (s1.line.equals(s1a)) then s1.line = s1b else s1.line = s1a; }
      }
    ]
  };

var extToggleButton = ToggleButton { text: "Swap Extended" };

function run()
  {
  s1.line = s1a;
  s1TL.play();
  Stage {
    title: "Application title"
    width: 580
    height: 490
    scene: Scene {
        content: [
          Group {
            layoutX: 10
            layoutY: 10
            content: [
              VBox { 
                spacing: 25
                content: [
                  sb = ScoreBoard {
                    lightColor: ScoreChar.GREEN
                    lines: [
                      s1,
                      ScoreLine { line: "Men's 100m Backstroke - S8 " },
                      ScoreLine { line: "                           " },
                      s2 = ScoreLine { line: " GOLD     GOLD     GOLD    " },
                      ScoreLine { line: "Mohr Travis    USA  1:10.15" },
                      ScoreLine { line: "                           " },
                      ScoreLine { line: "         SILVER            " },
                      ScoreLine { line: "Malone David   IRL  1:12.15" },
                      ScoreLine { line: bind if (extToggleButton.selected) then "ÇüéâäàåçêëèïîìÄÅÉæÆôöòûùÿÖÜ" else "                           " },
                      ScoreLine { line: bind if (extToggleButton.selected) then "øØáíóúñÑÁÂÀãÃðÐÊËÈıÍÎÏÌÓßÔÒ" else "         BRONZE            " },
                      ScoreLine { line: bind if (extToggleButton.selected) then "õÕµþÞÚÛÙýÝ             @$£%" else "Spanja M.      CRO  1:13.49" },
                      ]
                    },
                  Tile {
                    rows: 1
                    hgap: 5
                    translateX: 20
                    content: [
                      Button { text: "Red"      action: function(){ sb.lightColor = ScoreChar.RED; } }
                      Button { text: "Green"    action: function(){ sb.lightColor = ScoreChar.GREEN; } }
                      Button { text: "Blue"     action: function(){ sb.lightColor = ScoreChar.BLUE; } }
                      Button { text: "Yellow"   action: function(){ sb.lightColor = ScoreChar.YELLOW; } }
                      Button { text: "Amber"    action: function(){ sb.lightColor = ScoreChar.AMBER; } }
                      Button { text: "Cyan"     action: function(){ sb.lightColor = ScoreChar.CYAN; } }
                      Button { text: "Magenta"  action: function(){ sb.lightColor = ScoreChar.MAGENTA; } }
                      ]
                    },
                  Tile {
                    rows: 1
                    hgap: 5
                    translateX: 20
                    content: [
                      Text { content: "Gold scroll rate:" },
                      XPicker {
                        pickerType: XPickerType.THUMB_WHEEL
                        items: [ -10..10 ]
                        onIndexChange: function(i){ s2.scrollRate = i-10; }
                        preset: 10
                        layoutInfo: LayoutInfo { width: 60 }
                        },
                      Button { text: "Line color"  action: function(){ s2.lightColor = ScoreChar.AMBER; } },
                      extToggleButton,
                      ]
                    }
                  ]
                }
              ]
            }
          ]
        }
      }
  }
