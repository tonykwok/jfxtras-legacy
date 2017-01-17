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

package ipicker;

import javafx.scene.control.Skin;
import javafx.scene.Group;
import javafx.scene.effect.BlendMode;
import javafx.scene.layout.HBox;
import javafx.scene.paint.Color;
import javafx.scene.paint.LinearGradient;
import javafx.scene.paint.Stop;
import javafx.scene.shape.Rectangle;
import javafx.util.Math.*;
import javafx.scene.shape.Line;
import javafx.scene.effect.InnerShadow;

public class IPickerSkin extends Skin {

  override var behavior = IPickerBehavior { };
  var iPicker = bind control as IPicker;
  var iPickerBehavior = bind behavior as IPickerBehavior;

  var radius: Float = 15.0;   // scale this for font size etc?

  init
    {
    }
  var focusRectangle = Rectangle {
    layoutX: -2
    layoutY: -2
    width: bind iPicker.fullWidth + 4
    height: bind iPicker.wheelHeight + 4
    arcHeight: radius + 2
    arcWidth: radius + 2
    fill: bind
      if (iPicker.focused and iPicker.showFocus) then Color.web( "#0093ff") else Color.TRANSPARENT
    };

// the window with an InnerShadow
  var wheelWindow = Rectangle {
    width: bind iPicker.fullWidth
    height: bind iPicker.wheelHeight
    arcHeight: radius
    arcWidth: radius
    stroke: Color.GREY
    fill: Color.WHITE
    effect: InnerShadow { 
      height: bind iPicker.wheelHeight / 2
      color: Color.BLACK
      }
    };

  var outerClipWindow = Rectangle
    {
    width: bind iPicker.fullWidth
    height: bind iPicker.wheelHeight
    arcHeight: radius
    arcWidth: radius
    };

  var innerClipWindow1 = Rectangle
    {
    layoutX: 1
    layoutY: 1
    width: bind iPicker.fullWidth - 2
    height: bind iPicker.wheelHeight - 2
    arcHeight: radius - 1
    arcWidth: radius - 1
    };

  var innerClipWindow2 = Rectangle
    {
    layoutX: 1
    layoutY: 1
    width: bind iPicker.fullWidth - 2
    height: bind iPicker.wheelHeight - 2
    arcHeight: radius - 1
    arcWidth: radius - 1
    };

  var wheelBorders = Group {
    content: bind [
//      Line { startX: 1 startY: 0 endX: 1 endY: bind iPicker.wheelHeight
//        smooth: false
//        fill: Color.BLACK
//        },
      Line { startX: 3 startY: 0 endX: 3 endY: bind iPicker.wheelHeight
        smooth: false
        stroke: Color.GAINSBORO
        strokeWidth: 3
        },
      for (i in iPicker.wheelWidths)
        {
        Rectangle {
          layoutX: i 
          layoutY: -3
          width: 5 
          height: bind iPicker.wheelHeight + 6
          fill: Color.BLACK
          smooth: false
          stroke: Color.GAINSBORO
          strokeWidth: 4
          }
        }
      ]
    };

  var wheelText = HBox {
    layoutY: bind -(2 - iPicker.endAdjust) * iPicker.maxTextHeight
    layoutX: bind iPicker.textPadding
    spacing: bind (2 * iPicker.textPadding + 1)
    content: bind
      for (wheel in iPicker.content)
        {
        wheel.currentWindow
        }
    };

  var clippedText = Group {
    content: [
      wheelText,
      ]
    clip: innerClipWindow2
    }

  var selectBar = Rectangle {
    layoutX: -1
    layoutY: bind iPicker.wheelHeight / 2 - (iPicker.maxTextHeight * 1.1)  / 2
    height: bind iPicker.maxTextHeight * 1.1
    width: bind iPicker.fullWidth + 2
    stroke: Color.BLACK
    opacity: 0.2
    fill: LinearGradient {
      startX: 0.0 startY: 0.0 endX: 0.0 endY: 1.0
      proportional: true
      stops: [
        Stop { offset: 0.0 color: Color.BLUE },
        Stop { offset: 0.5 color: Color.WHITE },
        Stop { offset: 1.0 color: Color.BLUE },
        ]
      }
    };

  var selectBarOutline = Rectangle {
    layoutX: -1
    layoutY: bind iPicker.wheelHeight / 2 - (iPicker.maxTextHeight * 1.1)  / 2
    height: bind iPicker.maxTextHeight * 1.1
    width: bind iPicker.fullWidth + 2
    stroke: Color.DARKGREY
    fill: null
    };

  var clippedWheelBorders = Group {
    content: [
      wheelBorders,
      ]
    clip: innerClipWindow1
    };

  var wheelsAndWindow = Group {
    content: bind [
      clippedWheelBorders,
      wheelWindow
      ]
    blendMode: BlendMode.MULTIPLY
    };

  var contentGroup = Group {
      content: bind [
        wheelsAndWindow,
        clippedText,
        ]
      };


  var clippedSelectBar = Group {
    content: [
      selectBar,
      selectBarOutline,
      ]
    clip: outerClipWindow
    };

  postinit
    {
    node = Group {
      content: bind [
        focusRectangle,
        contentGroup,
        if (iPicker.selector) then clippedSelectBar else null,
        ]
      }
    node.onMousePressed = function(e) { };//pickerBehavior.pickerClicked(e); };
    node.onMouseWheelMoved = function(e) {}; //pickerBehavior.pickerWheeled(e); };
    }

  override function intersects(x, y, w, h) : Boolean
    {
    return node.intersects(x, y, w, h);
    }

  override function contains(x, y) : Boolean
    {
    return node.contains(x, y);
    }

  override protected function getPrefHeight(width: Number) : Number
    {
    return iPicker.wheelHeight;
    }

  override protected function getMinHeight() : Number
    {
    return iPicker.wheelHeight;
    }

  override protected function getMaxHeight() : Number
    {
    return iPicker.wheelHeight;
    }

  override protected function getPrefWidth(height: Number) : Number
    {
    return iPicker.fullWidth;
    }

  override protected function getMinWidth() : Number
    {
    return iPicker.fullWidth;
    }

  override protected function getMaxWidth() : Number
    {
    return iPicker.fullWidth;
    }

}  //-------- END
