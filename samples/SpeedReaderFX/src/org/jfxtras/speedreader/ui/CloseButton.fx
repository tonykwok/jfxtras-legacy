/*
 * Copyright (c) 2008-2009, JFXtras Group
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
 *
 * Developed 2009 by James L. Weaver with the JFXtras Group
 * to read multiple social network and news feeds, as well
 * as to demonstrate some JFXtras features.
 *
 * CloseButton.fx -
 * Button that closes the Criteria dialog
 */
package org.jfxtras.speedreader.ui;

import javafx.scene.CustomNode;
import javafx.scene.input.MouseEvent;
import javafx.scene.paint.Color;
import javafx.scene.Group;
import javafx.scene.shape.Rectangle;
import javafx.scene.paint.LinearGradient;
import javafx.scene.paint.Stop;
import org.jfxtras.speedreader.model.SpeedReaderModel;
import javafx.scene.shape.Line;
import javafx.scene.effect.InnerShadow;
import javafx.scene.shape.StrokeLineCap;

import javafx.scene.layout.Stack;

import javafx.animation.transition.FadeTransition;

/**
 * Button that closes the Criteria dialog
 *
 * @author Dean Iverson
 */
public class CloseButton extends CustomNode {
  public-init var model:SpeedReaderModel;
  public-init var size = 20;

  var background:Rectangle;

  def padding = bind size / 4;
  def stroke = Color.GRAY;
  def fill = LinearGradient {
    endX: 0.0
    stops: [
      Stop { offset: 0.0, color: Color.rgb( 245, 245, 245)}
      Stop { offset: 1.0, color: Color.rgb( 200, 200, 200)}
    ]
  }
  def fadeAnim = FadeTransition {
    node: bind background
    fromValue: 0
    toValue: 1
    duration: 100ms
  }

  override function create () {
    Stack {
      width: size
      height: size
      blocksMouse: true
      onMouseEntered: function( me ) {
        fadeAnim.rate = 1;
        fadeAnim.play();
      }
      onMouseExited: function( me ) {
        fadeAnim.rate = -0.2;
        fadeAnim.play();
      }
      onMouseReleased: function(me:MouseEvent):Void {
        model.showCriteria = false;
      }
      content: [
        background = Rectangle {
          arcWidth: size / 4
          arcHeight: size / 4
          width: size
          height: size
          fill: fill
          stroke: stroke
          opacity: 0
        },
        Group {
          content: [
            Line {
              strokeWidth: 3
              startX: padding
              startY: padding
              endX: size - padding
              endY: size - padding
              strokeLineCap: StrokeLineCap.ROUND
            },
            Line {
              strokeWidth: 3
              startX: size - padding
              startY: padding
              endX: padding
              endY: size - padding
              strokeLineCap: StrokeLineCap.ROUND
            }
          ]
          effect: InnerShadow {
            color: Color.GRAY
          }
        }
      ]
    }
  }
}
