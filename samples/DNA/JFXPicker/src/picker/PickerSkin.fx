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

/*
** Thanks to Rakesh Menon for original idea (and I hopr he forgives me for the small remanants
** of his original code still visible :-) )
*/

package picker;

import javafx.scene.paint.Stop;
import javafx.scene.shape.Rectangle;
import javafx.scene.control.ListView;
import javafx.scene.control.Skin;
import javafx.scene.control.Label;
import javafx.scene.paint.Color;
import javafx.scene.paint.LinearGradient;
import org.jfxtras.scene.shape.MultiRoundRectangle;
import javafx.scene.Group;
import javafx.scene.shape.VLineTo;
import javafx.scene.shape.MoveTo;
import javafx.scene.shape.Path;
import javafx.scene.shape.ClosePath;
import javafx.scene.shape.LineTo;
import javafx.scene.shape.HLineTo;
import javafx.scene.layout.LayoutInfo;

public class PickerSkin extends Skin {

  override var behavior = PickerBehavior { };
  var picker = bind control as Picker;
  var pickerBehavior = bind behavior as PickerBehavior;

  var buttonTop = "#62778a";
  var buttonBottom = "#253a4d";
  var buttonFillTop = "#f6f8fa";
  var buttonFillCenter = "#a8bcce";
  var buttonFillBottom = "#bbd0e3";
  var borderTop = "#95989E";
  var borderBottom = "#585B61";
  var textBG = "#dddfe5";
  var focusBorder = "#0093ff";

  var arrowStroke = Color.DARKSLATEGREY;
  var arrowFill   = Color.SLATEGREY;

  var buttonWidth = bind picker.height * 2 / 3;

  public-read var listView : ListView = ListView
    {
// layoutX etc. all driven by the bind to showList in behavior to force recalc as bind to layoutX, bounds etc. is not available for us
    layoutInfo: LayoutInfo { managed: false }
    visible: false
    width: bind picker.width - 10 - (if (picker.pickerType == PickerType.SIDE_SCROLL) then leftButton.width - 5 else 0)
    height: bind picker.dropDownHeight
    items: bind picker.items
    onMouseClicked: function(e) { pickerBehavior.listViewClicked(e); }
    onKeyPressed:   function(e) { pickerBehavior.listViewPressed(e); }
    clip: bind Rectangle {
      x: -1
      y: 4
      width: bind listView.width + 2
      height: bind listView.height - 3
      }
    };

  var text : Label = Label {
    text: bind "{listView.selectedItem}"
    width: bind picker.width - buttonWidth                           // at least 1 button
        - (if (picker.pickerType == PickerType.SIDE_SCROLL) then buttonWidth else 0)     // and if sideScroll then 2
        - 4
    layoutX: bind (if (picker.controlOnLeft) then buttonWidth else 0) + 6
    layoutY: bind (picker.height - text.layoutBounds.height) / 2.0
    };

  var rightArrow: Path = Path {
    visible: bind picker.pickerType == PickerType.SIDE_SCROLL
    layoutX: bind rightButton.x
    layoutY: bind rightButton.y
    translateX: bind rightButton.width / 4.0
    translateY: bind rightButton.height / 4.0
    elements: [
      MoveTo  { x:0, y:0}
      VLineTo { y: bind rightButton.height * 2.0 / 4.0}
      LineTo  { x: bind rightButton.width * 2.0 / 4.0 y: bind rightButton.height * 2.0 / 8.0 }
      ClosePath { }
      ]
    fill: arrowFill
    stroke: arrowStroke
    };

  var leftArrow: Path = Path {
    visible: bind picker.pickerType == PickerType.SIDE_SCROLL
    layoutX: bind leftButton.x
    layoutY: bind leftButton.y
    translateX: bind leftButton.width / 4.0
    translateY: bind leftButton.height / 4.0
    elements: [
      MoveTo  { x: bind leftButton.width * 2.0 / 4.0, y:0}
      VLineTo { y: bind leftButton.height * 2.0 / 4.0}
      LineTo  { x: 0 y: bind leftButton.height * 2.0 / 8.0 }
      ClosePath { }
      ]
    fill: arrowFill
    stroke: arrowStroke
    };

  var downArrow: Path = Path {
    visible: bind picker.pickerType == PickerType.DROP_DOWN
    layoutX: bind if (picker.controlOnLeft) then leftButton.x else rightButton.x
    translateX: bind rightButton.width / 4.0 - 1
    layoutY: bind rightButton.height * 2.0 / 5.0
    elements: [
      MoveTo  { x: 0, y: 0}
      HLineTo { x: bind rightButton.width * 2.0 / 3.0}
      LineTo  { x: bind rightButton.width * 1.0 / 3.0 y: bind rightButton.height * 2.0 / 5.0 }
      ClosePath { }
      ]
    fill: arrowFill
    stroke: arrowStroke
    };

  var twinArrow: Group = Group {
    visible: bind picker.pickerType == PickerType.THUMB_WHEEL
    layoutX: bind if (picker.controlOnLeft) then leftButton.x else rightButton.x
    layoutY: bind leftButton.height * 2.0 / 12.0
    translateX: bind leftButton.width * 3.0 / 12.0
    content: [
      Path {
        translateY: bind leftButton.height * 2.0 / 12.0
        elements: [
          MoveTo { x: 0 y: bind leftButton.height * 3.0 / 12.0 }
          HLineTo { x: bind leftButton.width * 6.0 / 12.0 }
          LineTo { x: bind leftButton.width * 3.0 / 12.0 y: 0 }
          ClosePath { }
          ]
        fill: arrowFill
        stroke: arrowStroke
        },
      Path {
        translateY: bind leftButton.height * 6.0 / 12.0
        elements: [
          MoveTo { x: 0 y: 0 }
          HLineTo { x: bind leftButton.width * 6.0 / 12.0 }
          LineTo { x: bind leftButton.width * 3.0 / 12.0 y: bind leftButton.height * 3.0 / 12.0 }
          ClosePath { }
          ]
        fill: arrowFill
        stroke: arrowStroke
        },
      ]
    };

  var buttonFill: LinearGradient = LinearGradient {
    startX: 0.0, startY: 0.0, endX: 0.0, endY: 1.0
    proportional: true
    stops: [
      Stop { offset: 0.0 color: Color.web(buttonFillTop) },
      Stop { offset: 0.3 color: Color.web(buttonFillCenter) },
      Stop { offset: 0.7 color: Color.web(buttonFillBottom) }
      ]
    };

  var buttonStroke: LinearGradient = LinearGradient {
    startX: 0.0, startY: 0.0, endX: 0.0, endY: 1.0
    proportional: true
    stops: [
      Stop { offset: 0.0 color: Color.web(buttonTop) },
      Stop { offset: 1.0 color: Color.web(buttonBottom) }
      ]
    };

  public var rightButton: MultiRoundRectangle = MultiRoundRectangle {
    visible: bind picker.pickerType == PickerType.SIDE_SCROLL or not picker.controlOnLeft
    x: bind controlBorder.width - buttonWidth + 2
    y: 2
    width: bind buttonWidth
    height: bind controlBorder.height
    topRightWidth: 5
    topRightHeight: 5
    bottomRightWidth: 5
    bottomRightHeight: 5
    topLeftWidth: 1             // kludge for fill/mouse problem
    topLeftHeight: 1            // ditto
    bottomLeftWidth: 1          // ditto
    bottomLeftHeight: 1         // ditto
    fill: buttonFill
    strokeWidth: 1.5
    stroke: buttonStroke
    blocksMouse: true
    onMousePressed: function(e){ pickerBehavior.rightButtonClicked(e); }
    onMouseExited:  function(e){ pickerBehavior.mouseExited = true; }
    onMouseReleased:function(e){ pickerBehavior.mouseExited = true; }
    };

  public var leftButton: MultiRoundRectangle = MultiRoundRectangle {
    visible: bind picker.controlOnLeft
    x: 2
    y: 2
    width: bind buttonWidth
    height: bind controlBorder.height
    topLeftWidth: 5
    topLeftHeight: 5
    bottomLeftWidth: 5
    bottomLeftHeight: 5
    topRightWidth: 1          // kludge for fill/mouse problem
    topRightHeight: 1         // ditto
    bottomRightWidth: 1       // ditto
    bottomRightHeight: 1      // ditto
    fill: buttonFill
    strokeWidth: 1.5
    stroke: buttonStroke
    blocksMouse: true
    onMousePressed: function(e){ pickerBehavior.leftButtonClicked(e); }
    onMouseExited:  function(e){ pickerBehavior.mouseExited = true; }
    onMouseReleased:function(e){ pickerBehavior.mouseExited = true; }
    };

  public var splitClick: Group = Group {
    layoutX: bind if(picker.controlOnLeft) then 2 else rightButton.x + 1
    layoutY: 2
    visible: bind picker.pickerType == PickerType.THUMB_WHEEL
    blocksMouse: true
    content: [
      Rectangle {
        x: 0
        y: 0
        width: bind buttonWidth
        height: bind controlBorder.height / 2
        fill: Color.TRANSPARENT
        onMousePressed: function(e){ pickerBehavior.leftButtonClicked(e); }
        onMouseWheelMoved: function(e) { pickerBehavior.pickerWheeled(e); }
        onMouseExited:  function(e){ pickerBehavior.mouseExited = true; }
        onMouseReleased:function(e){ pickerBehavior.mouseExited = true; }
        },
      Rectangle {
        x: bind 0
        y: bind controlBorder.height / 2
        width: bind buttonWidth
        height: bind controlBorder.height / 2
        fill: Color.TRANSPARENT
        onMousePressed: function(e){ pickerBehavior.rightButtonClicked(e); }
        onMouseWheelMoved: function(e) { pickerBehavior.pickerWheeled(e); }
        onMouseExited:  function(e){ pickerBehavior.mouseExited = true; }
        onMouseReleased:function(e){ pickerBehavior.mouseExited = true; }
        },
      ]
    };

  
  var borderStroke: LinearGradient = LinearGradient {
    startX: 0.0, startY: 0.0, endX: 0.0, endY: 1.0
    proportional: true
    stops: [
      Stop { offset: 0.0 color: Color.web(borderTop) },
      Stop { offset: 1.0 color: Color.web(borderBottom) }
      ]
    };
    
  var borderFill: LinearGradient = LinearGradient {
    startX: 0.0, startY: 0.0, endX: 0.0, endY: 1.0
    proportional: true
    stops: [
      Stop { offset: 0.0 color: Color.WHITE },
      Stop { offset: 0.3 color: Color.web(textBG) },
      Stop { offset: 0.7 color: Color.WHITE }
      ]
    };
  
  var controlBorder: Rectangle = Rectangle {
    x: 2
    y: 2
    width: bind picker.width - 4
    height: bind picker.height - 4
    arcWidth: 10
    arcHeight: 10
    strokeWidth: 1.5
    stroke: borderStroke
    fill: borderFill
    };

  var focusBorderColor = Color.web(focusBorder);

  var focusRectangle = Rectangle {
    width: bind picker.width
    height: bind picker.height
    arcWidth: 10
    arcHeight: 10
    fill: bind
      if (picker.focused or listView.focused) then focusBorderColor else Color.TRANSPARENT
    };

  init {
    node = Group {
      content: [
        focusRectangle,
        controlBorder,
        text,
        leftButton,
        rightButton,
        downArrow,
        leftArrow,
        rightArrow,
        twinArrow,
        splitClick,
        ]
      focusTraversable: false
      }

    node.onMousePressed = function(e) { pickerBehavior.pickerClicked(e); };
    node.onMouseWheelMoved = function(e) { pickerBehavior.pickerWheeled(e); };
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
// ok lets pretend if someone has asked for our preferred height then probably a layout change going on so ...
    pickerBehavior.showList = false;
    return 24;
    }

  override protected function getMinHeight() : Number
    {
    return 16;
    }

  override protected function getPrefWidth(height: Number) : Number
    {
// ok lets pretend if someone has asked for our preferred height then probably a layout change going on so ...
    pickerBehavior.showList = false;
    return 150;
    }

  override protected function getMinWidth() : Number
    {
    return 50;
    }


}  //-------- END
