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

import javafx.scene.control.Behavior;

public class IPickerBehavior extends Behavior
  {
  var iPickerSkin = bind skin as IPickerSkin;
  var iPicker = bind skin.control as IPicker;

  init
    {
    }

  postinit
    {
    }

//
//  public var mouseExited: Boolean;
//
//  init
//    {  }
//
//  public function listViewClicked(me: MouseEvent): Void
//    {
//    showList = false;
//    }
//
//  public function listViewPressed(ke: KeyEvent): Void
//    {
//    if (ke.code == KeyCode.VK_ESCAPE
//      or ke.code == KeyCode.VK_ENTER
//      or ke.code == KeyCode.VK_TAB)
//      {
//      picker.requestFocus();
//      }
//    }
//
//public function pickerClicked(me: MouseEvent): Void
//    {
//    if (picker.dropDown == false) then
//      {
//      picker.requestFocus();
//      return;
//      }
//    if (showList)
//      {
//      picker.requestFocus();
//      }
//     else
//      {
//      showList = true;
//      }
//    }
//
//  public function pickerWheeled(me: MouseEvent): Void
//    {
//    showList = false;
//    if (me.wheelRotation < 0) then picker.selectPreviousRow() else picker.selectNextRow();
//    }
//
//  public function leftButtonClicked(me: MouseEvent): Void
//    {
//    var cancelTl = bind mouseExited on replace { if (mouseExited) then tlCheckRepeat.stop() };
//    var tlCheckRepeat = Timeline {
//      repeatCount: 1
//      keyFrames : [
//        KeyFrame {
//          time: picker.mouseRepeatDelay
//          action: function(){ tlRepeat.play(); }
//          }
//        ]
//      };
//    var tlRepeat: Timeline = Timeline {
//      repeatCount: Timeline.INDEFINITE
//        keyFrames: [
//          KeyFrame {
//          time : .1s
//          canSkip : false
//          action: function(){
//            if ((pickerSkin.leftButton.pressed
//             or pickerSkin.splitClick.pressed)
//             and mouseExited == false)
//              {
//              picker.selectPreviousRow();
//              }
//             else
//              {
//              tlRepeat.stop();
//              }
//            }
//          }
//        ]
//      };
//
//    if (picker.pickerType == PickerType.DROP_DOWN)
//      {
//      pickerClicked(me);
//      }
//     else
//      {
//      mouseExited = false;
//      picker.requestFocus();
//      picker.selectPreviousRow();
//      tlCheckRepeat.play();
//      }
//    }
//
//  public function rightButtonClicked(me: MouseEvent): Void
//    {
//    var cancelTl = bind mouseExited on replace { if (mouseExited) then tlCheckRepeat.stop() };
//    var tlCheckRepeat = Timeline {
//      repeatCount: 1
//      keyFrames : [
//        KeyFrame {
//          time: picker.mouseRepeatDelay
//          action: function(){ tlRepeat.play(); }
//          }
//        ]
//      };
//    var tlRepeat: Timeline = Timeline {
//      repeatCount: Timeline.INDEFINITE
//        keyFrames: [
//          KeyFrame {
//          time : .1s
//          canSkip : false
//          action: function(){
//            if ((pickerSkin.rightButton.pressed
//             or pickerSkin.splitClick.pressed)
//             and mouseExited == false)
//              {
//              picker.selectNextRow();
//              }
//             else
//              {
//              tlRepeat.stop();
//              }
//            }
//          }
//        ]
//      };
//
//    if (picker.pickerType == PickerType.DROP_DOWN)
//      {
//      pickerClicked(me);
//      }
//     else
//      {
//      mouseExited = false;
//      picker.requestFocus();
//      picker.selectNextRow();
//      tlCheckRepeat.play();
//      }
//    }
//
//// this tends to be used by default by requesting focus for picker so activating this to unshow listView
//  var listViewFocus = bind pickerSkin.listView.focused on replace {
//    if (not listViewFocus)
//      {
//      showList = false;
//      }
//    };
//
//  public var showList: Boolean on replace
//    {
//    if (isInitialized(showList))
//      {
//      if (showList)
//        {
//        recalcListViewPosition();
//        delete pickerSkin.listView from picker.scene.content;
//        insert pickerSkin.listView into picker.scene.content;
//        pickerSkin.listView.visible = true;
//        pickerSkin.listView.requestFocus();
//        }
//       else
//        {
//        delete pickerSkin.listView from picker.scene.content;
//        pickerSkin.listView.visible = false;
//        }
//      }
//    };
//
//// this function whenever show listView as binding values seems  ... interesting
//  public function recalcListViewPosition(): Void
//    {
//    pickerSkin.listView.translateY = picker.localToScene(picker.boundsInLocal).maxY - 4;
//    pickerSkin.listView.translateX = picker.localToScene(picker.boundsInLocal).minX + 5 + (if (picker.pickerType == PickerType.SIDE_SCROLL) then pickerSkin.leftButton.width - 5 else 0);
//    }
//
//  public function reSync(savedSelection: Object): Void
//    {
//    var i = indexOf(picker.items, savedSelection);
//    if (i >= 0)
//      {
//      picker.select(i);
//      }
//     else
//      {
//      picker.select(0);
//      }
//    }
//
//  public override function callActionForEvent(ke: KeyEvent) : Void
//    {
//    if (ke.impl_EventID == KeyEventID.PRESSED)
//      {
//      if (ke.code == KeyCode.VK_ENTER)
//        {
//        if (picker.dropDown) then showList = true;
//        return;
//        }
//      if (ke.code == KeyCode.VK_LEFT
//        or ke.code == KeyCode.VK_UP)
//        {
//        picker.selectPreviousRow();
//        return;
//        }
//      if (ke.code == KeyCode.VK_RIGHT
//        or ke.code == KeyCode.VK_DOWN)
//        {
//        picker.selectNextRow();
//        return;
//        }
//// Quick and dirty first character selection - steps through all above then cycles - does not cause cycleChange
//      if (picker.firstLetter)
//        {
//        var itemFound = false;
//        for (i in [(picker.selectedIndex + 1)..(sizeof(picker.items) - 1)])
//          {
//          var l = picker.items[i].toString().substring(0,1);
//          if (l.compareToIgnoreCase(ke.text) == 0)
//            {
//            picker.select(i);
//            itemFound = true;
//            break;
//            }
//          }
//// bottom portion if not found
//        if (not itemFound)
//          {
//          for (i in [0..(picker.selectedIndex)])
//            {
//            var l = picker.items[i].toString().substring(0,1);
//            if (l.compareToIgnoreCase(ke.text) == 0)
//              {
//              picker.select(i);
//              itemFound = true;
//              break;
//              }
//            }
//          }
//        }
//      }
//    }


  }   //---------- END