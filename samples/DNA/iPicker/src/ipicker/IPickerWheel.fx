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

import javafx.scene.text.Font;
import javafx.geometry.HPos;
import javafx.scene.layout.Tile;
import javafx.scene.layout.Stack;
import javafx.scene.text.Text;
import java.lang.Integer;
import java.lang.String;
import java.lang.Void;
import javafx.scene.shape.Rectangle;
import javafx.scene.paint.Color;
import javafx.util.Math;
import javafx.geometry.VPos;
import javafx.animation.transition.TranslateTransition;

public class IPickerWheel
  {
  public-init var name: String;
  public-init var content: String[];
  public-init var font: Font;
  public-init var visibleItems = 5
    on replace {
      if (visibleItems > 9) then visibleItems = 9;
      if (visibleItems < 1) then visibleItems = 1;
      };
  public-init var hpos: HPos = HPos.CENTER;
// Allow flick drag action to be turned off - generally on single row mode
  public-init var noFlick: Boolean = false;
  public var onIndexChange: function(index: Integer): Void;

  var firstTimeThrough = true;
  var selectedIndex: Integer = 0;
  var selectedItem: String;

  package var unifiedHeight: Float = 1.0 on replace { if (isInitialized(unifiedHeight) and isInitialized(unifiedVisibleItems)) populateCurrentWindow(); };
  package var unifiedVisibleItems: Integer = 1 on replace {  if (isInitialized(unifiedHeight) and isInitialized(unifiedVisibleItems)) populateCurrentWindow(); };
  package var playSounds: Boolean = true;
  package var maxTextHeight: Float = 0.0;
  package var maxTextWidth:  Float = 0.0;

  var scrollTime = 0.05s;
  var scrollControl = 0.0;               // used to scroll the wheel
  var scrollAmount = 0;
  var scrollSign: Integer = bind Math.signum(scrollAmount);
  var scrolling: Boolean = false;
  var flickInMotion: Boolean = false;

  package var currentWindow = Tile {
    vertical: true
    tileHeight: bind unifiedHeight
    content: []
    };

  init
    {
    }

  postinit
    {
    setTextSizes();
    }

  function stepWheelSpin(): Void
    {
    scrolling = true;
    var stepWheel: TranslateTransition = TranslateTransition {          // positive scroll amount steps wheel down, negative up
      duration: bind scrollTime
      node: currentWindow
      fromY: 0
      toY: bind scrollSign * unifiedHeight
      repeatCount: 1
      action: function(){
        if (playSounds) then PlaySound.PIP.play();
        adjustSelectedIndex(scrollSign);
        scrollAmount = scrollAmount - scrollSign;
        if (flickInMotion)
          {
          if (Math.abs(scrollAmount) == 4) then scrollTime = 0.075s;
          if (Math.abs(scrollAmount) == 3) then scrollTime = 0.1s;
          if (Math.abs(scrollAmount) == 2) then scrollTime = 0.175s;
          if (Math.abs(scrollAmount) == 1) then scrollTime = 0.35s;
          }
        if (scrollAmount == 0)
          {
          scrolling = false;
          flicking = false;
          getSelectedItem();      // ensure item stored at end of flick / scrol and onIndexChange triggered
          }
         else
          {
          stepWheelSpin();
          }
        }
      };
    stepWheel.playFromStart();
    }

  package function setSelectedIndex(index: Integer): Void
    {
    if (index >= 0 and index < sizeof(content))
      {
      selectedIndex = index;
      populateCurrentWindow();
      getSelectedItem();
      }
    }

  function adjustSelectedIndex(amount: Integer): Void
    {
    var index = selectedIndex - amount;
    var size = sizeof(content) - 1;
    if (index < 0)
      then index = index + size + 1;
    if (index > size)
      then index = index - size - 1;
    setSelectedIndex(index);
    }


  package function getSelectedItem(): String
    {
    selectedItem = content[selectedIndex];
// trigger the onIndexChange now item is stored
    if (selectedItem != null and not flicking and not scrolling)     // avoid flick/scroll transients
      {
      onIndexChange(selectedIndex);
      }
    selectedItem;
    }

  package function setSelectedItem(item: String): Void
    {
    for (i in [0..sizeof(content)-1])
      {
      if (content[i].equals(item))
        {
        setSelectedIndex(i);
        return;
        }
      }
    }

  package function scrollToItem(item: String): Void
    {
    for (i in [0..sizeof(content)-1])
      {
      if (content[i].equals(item))
        {
        scrollToIndex(i);
        return;
        }
      }
    }

  package function scrollToIndex(index: Integer): Void
    {
    var offset1: Integer = selectedIndex - index;
    var offset2: Integer = (sizeof(content) - Math.abs(offset1)) * -Math.signum(offset1);
    if (offset1 == 0) then return;
    if (Math.abs(offset1) < Math.abs(offset2))
      {
      setScrollGoing(offset1, false);
      }
     else
      {
      setScrollGoing(offset2, false);
      }
    }

  package function getSelectedIndex(): Integer
    {
    selectedIndex;
    }

  public function selectNextItem(): Void
    {
    if (selectedIndex >= sizeof(content) - 1)
      {
      setSelectedIndex(0);
      }
     else
      {
      setSelectedIndex(selectedIndex + 1);
      }
    }

  public function selectPreviousItem(): Void
    {
    if (selectedIndex <= 0)
      {
      setSelectedIndex(sizeof(content)-1);
      }
     else
      {
      setSelectedIndex(selectedIndex - 1);
      }
    }

  function setTextSizes()
    {
    for (s in content)
      {
      var textSizer = Text { content: s font: font };
      if (textSizer.boundsInLocal.width > maxTextWidth)
        then maxTextWidth = textSizer.boundsInLocal.width;
      if (textSizer.boundsInLocal.height > maxTextHeight)
        then maxTextHeight = textSizer.boundsInLocal.height;
      }
    maxTextWidth = Math.ceil(maxTextWidth);
    }

  // var position: Number;
  var flicking: Boolean;                // indicates if current drag motion is above flick base limits
  def FLICK_DRAGDISTANCE_THRESHOLD = 10;  // must drag at least 15 pixels before considered for flicking
  def FLICK_DRAGSPEED_THRESHOLD = 0.2;    // speed on a drag event that indicates we have stopped if below pixels/ms .1 = 10 pixels in 100ms = 1/10sec
  def FLICK_SPEED_TO_SCROLL_RATIO = 15.0;     //

  function populateCurrentWindow(): Void
    {
    scrollControl = 0;
    currentWindow.translateY = 0;
    delete currentWindow.content;
    var items = unifiedVisibleItems + 4;      // The 2 half visible ones plus the next one at each end
    for (i in [0..items - 1])
      {
      var offset = (items - 1) / 2 - i;
      var item = selectedIndex - offset;
      if (item < 0)
        then item = sizeof(content) + item;
      if (item > sizeof(content) - 1)
        then item = item - sizeof(content);
      insert Stack {
        nodeHPos: hpos
        nodeVPos: VPos.CENTER
        content: [
          Text {
            content: content[item]
            font: font
            },
          Rectangle {
            width: bind maxTextWidth
            height: bind unifiedHeight
            fill: Color.TRANSPARENT
            strokeWidth: 0
            blocksMouse: true

            onMouseClicked: function(me){
              setScrollGoing(offset, false);
              }

            onMouseWheelMoved: function(me) {
              var v: Integer = 1 * Math.signum(me.wheelRotation);
              setScrollGoing(v, true);
              }

            // Used to monitor the speed of the mouse when dragging.
            var lastDragTime: Long;
            var lastDragY: Number
            var dragSpeed: Number

           // Sets up for flicking.
            onMousePressed: function(me): Void {
              lastDragTime = java.lang.System.currentTimeMillis();
              lastDragY = me.dragY;
              }

           // record the drag
            onMouseDragged: function(me){
              // Have we moved at least the threshold pixel count
              if (Math.abs(me.dragY - lastDragY) > FLICK_DRAGDISTANCE_THRESHOLD)
                {
                dragSpeed = (me.dragY - lastDragY) / (java.lang.System.currentTimeMillis() - lastDragTime);
                // ok - ensure we maintain a movement speed value greater than threshold, else we have stopped dragging?
                if (Math.abs(dragSpeed) < FLICK_DRAGSPEED_THRESHOLD)
                  {
                  lastDragTime = java.lang.System.currentTimeMillis();
                  lastDragY = me.dragY;
                  flicking = false;
                  }
                else     // still flicking or restarted
                 {
                  flicking = true;
                  }
                }
              }

            // check if a flick required
            onMouseReleased: function(me): Void {
            // If we have a release and we are still flicking then flick!
              if (flicking and noFlick == false)
                {
                // work out how quick and far the flick was
                // Use primarily the flick speed (not the distance) to calculate effect
                dragSpeed = (me.dragY - lastDragY) / (java.lang.System.currentTimeMillis() - lastDragTime);
                scrollAmount = (dragSpeed * FLICK_SPEED_TO_SCROLL_RATIO).intValue();
                flickInMotion = true;
                setScrollGoing(scrollAmount, true);
                }
               else
                {
                if (Math.abs(me.dragY - lastDragY) < 5)
                  {
                  setScrollGoing(offset, false);
                  }
                }
              }
            },          
          ]
        } into currentWindow.content;
      }
    }

  function setScrollGoing(offset: Integer, mouseWheel: Boolean): Void
    {
    if (not scrolling)
      {
      scrollAmount = offset;
      if (Math.abs(offset) > 4)  then scrollTime = 0.1s;
      if (Math.abs(offset) == 4) then scrollTime = 0.13s;
      if (Math.abs(offset) == 3) then scrollTime = 0.17s;
      if (Math.abs(offset) == 2) then scrollTime = 0.22s;
      if (Math.abs(offset) == 1) then scrollTime = 0.28s;
      if (mouseWheel) then scrollTime = 0.05s;
      stepWheelSpin();
      }
    }

  }   //------- END CLASS
