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

import javafx.scene.CustomNode;
import javafx.scene.layout.HBox;
import javafx.scene.paint.Color;
import javafx.scene.shape.Rectangle;
import javafx.util.Math;
import javafx.animation.KeyFrame;
import javafx.animation.Timeline;

/**
 * @author David
 */
package def preSpace = 1;
package def postSpace = 1;

public class ScoreLine extends CustomNode {

  var workLine: String;
  var scrollTL = Timeline {
    repeatCount: Timeline.INDEFINITE
    keyFrames : [
      KeyFrame {
        canSkip: true
        time: .5s
        action: function() { scrollNext(); }
        }
      ]
    };

  public      var line: String = " "
    on replace { 
      workLine = line;
      };
  public-init var spaceBefore: Integer = 1;
  public-init var spaceAfter:  Integer = 1;
  public      var lightColor = ScoreChar.RED;
  public      var scrollRate: Float = 0.0
    on replace {
      scrollTL.stop();
      workLine = line;
      scrollTL.rate = Math.abs(scrollRate);
      if (scrollRate != 0.0) then scrollTL.playFromStart() else scrollTL.stop();
      };

  function scrollNext(): Void
    {
    var tempLine: String;
    var wrapChar: String;

    tempLine = workLine;
    tempLine = workLine;
    if (scrollRate < 0)
      {
      wrapChar = tempLine.substring(0,1);
      tempLine = tempLine.substring(1);
      tempLine = tempLine.concat(wrapChar);
      }
     else
      {
      wrapChar = tempLine.substring(tempLine.length() - 1, tempLine.length());
      tempLine = tempLine.substring(0,tempLine.length()-1);
      tempLine = wrapChar.concat(tempLine);
      }
    workLine = tempLine;
    }

  override public function create()
    {
    HBox {
      cache: true
      layoutY: bind preSpace + spaceBefore
      height: bind spaceBefore + preSpace + 23 + postSpace + spaceAfter
      spacing: 3
      content: bind [
        getChars(workLine),
        Rectangle {
          height: bind spaceBefore + preSpace + 23 + postSpace + spaceAfter
          width: 1
          fill: Color.TRANSPARENT
          }
        ]
      }
    }

    function getChars(workLine: String) {
        for (i in [0..workLine.length()-1])
          {
          ScoreChar {
            letter: bind workLine.substring(i, i+1)
            lightColor: bind lightColor
            };
          }
    }


  }
