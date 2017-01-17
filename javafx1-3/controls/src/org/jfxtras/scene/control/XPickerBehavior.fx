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
package org.jfxtras.scene.control;

import javafx.scene.control.Behavior;
import javafx.animation.KeyFrame;
import javafx.animation.Timeline;
import javafx.scene.input.KeyCode;
import javafx.scene.input.KeyEvent;
import javafx.scene.input.KeyEventID;
import javafx.scene.input.MouseEvent;
import javafx.util.Sequences.*;
import com.sun.javafx.scene.traversal.Direction;
import com.sun.javafx.scene.traversal.TraversalEngine;
import org.jfxtras.scene.control.XPickerType;
import javafx.stage.AppletStageExtension;

/**
 * @author David
 */
public class XPickerBehavior extends Behavior
    {
    def runningAsApplet: Boolean = AppletStageExtension.eval("2+3") != null;
    def picker = bind skin.control as XPicker;
    def pickerSkin = bind skin as XPickerSkin;
    public var mouseExited: Boolean;

    init
        {
        }

    var focusChanger = bind picker.focused
        on replace {
        if (focusChanger == true) then
            {
            pickerSkin.xpickerButton.requestFocus();
            }
        };

    public function listViewClicked(me: MouseEvent): Void
        {
        hideDropDown();
        pickerSkin.xpickerButton.requestFocus();
        }

    public function listViewPressed(ke: KeyEvent): Void
        {
        if (ke.code == KeyCode.VK_ESCAPE
            or ke.code == KeyCode.VK_ENTER
            or ke.code == KeyCode.VK_TAB)
            {
            hideDropDown();
            if (ke.code == KeyCode.VK_TAB)
                {
                if (ke.shiftDown)
                    then TraversalEngine.traverse(picker, Direction.PREVIOUS)
                    else TraversalEngine.traverse(picker, Direction.NEXT);
                return;
                }
            pickerSkin.xpickerButton.requestFocus();
            }
          else
            {
            checkKey(ke);
            }
        }

    // Offsets to account for stage decoration or Applet when need to position dropdown
    def decorNotSet: Float = -999999;
    var decorX: Float = decorNotSet;
    var decorY: Float = decorNotSet;

    public function buttonKeyPressed(ke: KeyEvent): Void
        {
        // OK - we don't have the mouse click to give us the absolutely correct position so...

        // first - we may have a value already from mouse - so only do if not already set
        if (runningAsApplet) then   // we ARE an applet
            {
            decorX = - picker.scene.stage.x;
            decorY = - picker.scene.stage.y;
            }
          else   // we are NOT an applet
            {
            // Only guess if we dont already have decor offsets from a mouse click etc.
            if (decorX == decorNotSet and decorY == decorNotSet) then
                {
                // we are generally OK with x as normally left and right borders same width
                decorX = (picker.scene.stage.width - picker.scene.width) / 2;
                // however we have no idea of the disproportionate header to bottom border difference
                // so for now we will set to 0 if both same, else assume bottom border is 8 pixels
                decorY = picker.scene.stage.height - picker.scene.height;
                if (decorY > 0)
                    then decorY -= 8;
                }
            }
        checkKey(ke);
        }

public function pickerClicked(me: MouseEvent): Void
        {
        // calculate stage decoration offsets
        if (runningAsApplet) then   // we ARE an applet
            {
            decorX = - picker.scene.stage.x;
            decorY = - picker.scene.stage.y;
            }
          else   // we are NOT an applet
            {
            decorX = me.screenX - me.sceneX - picker.scene.stage.x;
            decorY = me.screenY - me.sceneY - picker.scene.stage.y;
            }
        if (not picker.dropDown) then return;
        if (pickerSkin.newDropdown == picker) then
            {
            if (pickerSkin.pickerDropDown.visible)
                then hideDropDown()
                else showDropDown();
            return;
            }
        pickerSkin.newDropdown = picker;
        }

    public function pickerWheeled(me: MouseEvent): Void
        {
        hideDropDown();
        if (picker.upArrowIncreases)
            {
            if (me.wheelRotation < 0) 
                then picker.selectNextRow()
                else picker.selectPreviousRow();
            }
          else
            {
            if (me.wheelRotation < 0) 
                then picker.selectPreviousRow()
                else picker.selectNextRow();
            }
        }

    public function leftButtonClicked(me: MouseEvent): Void
        {
        var cancelTl = bind mouseExited
            on replace
                {
                if (mouseExited) then tlCheckRepeat.stop()
                };
        var tlCheckRepeat = Timeline
            {
            repeatCount: 1
            keyFrames: [
                KeyFrame
                    {
                    time: picker.mouseRepeatDelay
                    action: function(){ tlRepeat.play(); }
                    }
                ]
            };
        var tlRepeat: Timeline = Timeline
            {
            repeatCount: Timeline.INDEFINITE
            keyFrames: [
                KeyFrame
                    {
                    time: .1s
                    canSkip: false
                    action: function()
                        {
                        if ((pickerSkin.leftClickArea.pressed)
                            and mouseExited == false)
                            {
                            if (picker.pickerType != XPickerType.THUMB_WHEEL)
                                {
                                picker.selectPreviousRow();
                                }
                              else
                                {
                                if (me.y < picker.layoutBounds.height / 2)
                                    then picker.selectNextRow()
                                    else picker.selectPreviousRow();
                                }
                            }
                          else
                            {
                            tlRepeat.stop();
                            }
                        }
                    }
                ]
            };
        if (picker.pickerType == XPickerType.DROP_DOWN)
            {
            pickerClicked(me);
            }
        else
            {
            mouseExited = false;
            pickerSkin.xpickerButton.requestFocus();
            if (picker.pickerType != XPickerType.THUMB_WHEEL)
                {
                picker.selectPreviousRow();
                }
              else
                {
                if (me.y < picker.layoutBounds.height / 2) 
                    then picker.selectNextRow()
                    else picker.selectPreviousRow();
                }
            tlCheckRepeat.play();
            }
        }

    public function rightButtonClicked(me: MouseEvent): Void
        {
        var cancelTl = bind mouseExited on replace
            {
            if (mouseExited) then tlCheckRepeat.stop()
            };
        var tlCheckRepeat = Timeline
            {
            repeatCount: 1
            keyFrames: [
                KeyFrame
                    {
                    time: picker.mouseRepeatDelay
                    action: function() { tlRepeat.play(); }
                    }
                ]
            };
        var tlRepeat: Timeline = Timeline
            {
            repeatCount: Timeline.INDEFINITE
            keyFrames: [
                KeyFrame
                    {
                    time: .1s
                    canSkip: false
                    action: function()
                        {
                        if ((pickerSkin.rightClickArea.pressed)
                            and mouseExited == false)
                            {
                            if (picker.pickerType != XPickerType.THUMB_WHEEL)
                                {
                                picker.selectNextRow();
                                }
                              else
                                {
                                if (me.y < picker.layoutBounds.height / 2) then picker.selectNextRow() else picker.selectPreviousRow();
                                }
                            }
                          else
                            {
                            tlRepeat.stop();
                            }
                        }
                    }
                ]
            };
        if (picker.pickerType == XPickerType.DROP_DOWN)
            {
            pickerClicked(me);
            }
          else
            {
            mouseExited = false;
            pickerSkin.xpickerButton.requestFocus();
            if (picker.pickerType != XPickerType.THUMB_WHEEL)
                {
                picker.selectNextRow()
                }
              else
                {
                if (me.y < picker.layoutBounds.height / 2) 
                    then picker.selectNextRow()
                    else picker.selectPreviousRow();
                }
            tlCheckRepeat.play();
            }
        }

    /*
     *   If picker button or dropdown stage loses focus then hide the dropdown
     */
    var xpickerButtonFocus = bind pickerSkin.xpickerButton.focused
        on replace
            {
            if (not xpickerButtonFocus) then hideDropDown();
            };
    var dropDownStageFocus = bind pickerSkin.pickerDropDown.containsFocus
        on replace
            {
            if (not dropDownStageFocus) then hideDropDown();
            };

    package function showDropDown(): Void
        {
        recalcDropDownPosition();
        pickerSkin.pickerDropDown.visible = true;
        recalcPositionTick.play();
        pickerSkin.listView.requestFocus();
        }

    package function hideDropDown(): Void
        {
        pickerSkin.pickerDropDown.visible = false;
        }

// desperate attempt to ensure dropdown in scene stays with the control in all cases when moved
    var recalcPositionTick: Timeline = Timeline
        {
        repeatCount: Timeline.INDEFINITE
        keyFrames: [
            KeyFrame
                {
                time: .05s
                canSkip: false
                action: function()
                    {
                    checkRecalcPositionNeeded();
                    }
                }
            ]
        };

    function checkRecalcPositionNeeded(): Void
        {
        if (not pickerSkin.pickerDropDown.visible) then
            {
            recalcPositionTick.stop();
            return;
            }
        recalcDropDownPosition();
        pickerSkin.pickerDropDown.toFront();
        }

    function recalcDropDownPosition(): Void
        {
        if (runningAsApplet) then   // we ARE an applet
            {
            // TODO does not seem to work as anticipated - will not adjust dynamically - will do for now
            pickerSkin.pickerDropDown.y = picker.localToScene(picker.layoutBounds).maxY - 2;
            pickerSkin.pickerDropDown.x = picker.localToScene(picker.layoutBounds).minX;
            }
          else // we are NOT an applet
            {
            pickerSkin.pickerDropDown.y = picker.scene.stage.y + picker.localToScene(picker.layoutBounds).maxY - 2 + decorY;
//println("----{picker.scene.stage.y + picker.localToScene(picker.layoutBounds).maxY - 2 + decorY}");
            pickerSkin.pickerDropDown.x = picker.scene.stage.x + picker.localToScene(picker.layoutBounds).minX + decorX;
            }
        }

    public function reSync(savedSelection: Object): Void
        {
        if (picker.selectedIndex == -1) then
            {
            if (picker.promptText == null) then
                {
                picker.select(0);
                }
            picker.resyncing--;
            return;
            }
        var i = indexOf(picker.items, savedSelection);
        if (i >= 0)
            {
            picker.select(i);
            }
          else
            {
            picker.select(0);
            }
        picker.resyncing--;
        }

    public function checkKey(ke: KeyEvent): Void
        {
        if (ke.impl_EventID == KeyEventID.PRESSED)
            {
            if (ke.code == KeyCode.VK_ENTER)
                {
                if (picker.dropDown) then
                    {
                    if (pickerSkin.pickerDropDown.visible)
                        then hideDropDown()
                        else showDropDown();
                    }
                pickerSkin.newDropdown = picker;
                return;
                }
            if (picker.useArrowKeyTraversal) then
                {
                if (not pickerSkin.pickerDropDown.visible) then
                    {
                    if (picker.pickerType == XPickerType.SIDE_SCROLL) then
                        {
                        if (ke.code == KeyCode.VK_UP
                            or ke.code == KeyCode.VK_DOWN)
                            then return;
                        }
                      else
                        {
                        if (ke.code == KeyCode.VK_LEFT
                            or ke.code == KeyCode.VK_RIGHT)
                            then return;
                        }
                    }
                }
            if (ke.code == KeyCode.VK_LEFT
                or (ke.code == KeyCode.VK_UP and not pickerSkin.pickerDropDown.visible))
                {
                picker.selectPreviousRow();
                picker.requestFocus();  // and grab focus back (wish I could stop it going!!!)
                return;
                }
            if (ke.code == KeyCode.VK_RIGHT
                or (ke.code == KeyCode.VK_DOWN and not pickerSkin.pickerDropDown.visible))
                {
                picker.selectNextRow();
                picker.requestFocus();  // and grab focus back (wish I could stop it going!!!)
                return;
                }
            // Quick and dirty first character selection - steps through all above then cycles - does not cause cycleChange
            if (picker.firstLetter)
                {
                var itemFound = false;
                for (i in [ (picker.selectedIndex + 1)..(sizeof (picker.items) - 1) ])
                    {
                    var l = picker.items[i].toString().substring(0, 1);
                    if (l.compareToIgnoreCase(ke.text) == 0)
                        {
                        picker.select(i);
                        itemFound = true;
                        break;
                        }
                    }
                // bottom portion if not found
                if (not itemFound)
                    {
                    for (i in [ 0..(picker.selectedIndex) ])
                        {
                        var l = picker.items[i].toString().substring(0, 1);
                        if (l.compareToIgnoreCase(ke.text) == 0)
                            {
                            picker.select(i);
                            itemFound = true;
                            break;
                            }
                        }
                    }
                }
            }
        }

    }
