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
import javafx.scene.paint.Color;
import javafx.scene.layout.VBox;

import javafx.scene.Group;
import javafx.scene.shape.Rectangle;

/**
 * @author David
 */
public class ScoreBoard extends CustomNode {

  public var lines: ScoreLine[];
  public-init var showBorder: Boolean = true;
  public      var lightColor = ScoreChar.RED on replace { setLineColors(lightColor); };

  override public function create()
    {
    var scoreBoard: VBox;
    Group {
      content: [
        Rectangle {
          visible: bind showBorder
          arcHeight: 24
          arcWidth: 24
          width: bind scoreBoard.boundsInLocal.width + 28
          height: bind scoreBoard.boundsInLocal.height + 28
          fill: Color.SILVER
          stroke: Color.BLACK
          strokeWidth: 1
          },
        Rectangle {
          layoutY: 4
          layoutX: 4
          arcHeight: 20
          arcWidth: 20
          width: bind scoreBoard.boundsInLocal.width + 20
          height: bind scoreBoard.boundsInLocal.height + 20
          fill: Color.BLACK
          },
        scoreBoard = VBox {
          layoutX: 14
          layoutY: 14
          content: bind lines
          }
        ]
      }
    }

  public function setLineColors(newColor: Integer): Void
    {
    for (line in lines)
      {
      line.lightColor = newColor;
      }
    }

}
