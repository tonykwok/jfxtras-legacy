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

import javafx.scene.control.Control;
import javafx.geometry.HPos;
import javafx.scene.layout.Resizable;
import javafx.scene.control.Label;
import javafx.scene.Group;
import javafx.scene.control.Tooltip;

/**
 * @author David
 */
public class XPicker extends Control, Resizable
    {

    def NO_PRESET: Integer = -999999;
    override var skin = XPickerSkin {};
    var pickerSkin = bind skin as XPickerSkin;
    package var pickerBehavior = bind skin.behavior as XPickerBehavior;
    public var items: Object[ ] = [] on replace
        {
        if (isInitialized(selectedItem))
            {
            getNaturalSize();
            resyncing++;
            FX.deferAction(function():Void {pickerBehavior.reSync(savedSelection);});
            }
        };
    public-init var cyclic:         Boolean = false;
    public-init var promptText:     String;
    public-init var dropDown:       Boolean = false;
    public-init var dropDownHeight: Integer = 150;
    public-init var preset:         Integer = NO_PRESET;
    public-init var presetItem:     Object;
    public-init var controlOnLeft:  Boolean = false;
    public-init var pickerType:     XPickerType = XPickerType.DROP_DOWN;
    public-init var firstLetter:    Boolean = false;
    public-init var mouseRepeatDelay: Duration = 0.5s;
    public-init var upArrowIncreases: Boolean = true;
    public var pickerTooltip: Tooltip;
    /** 
     * Just display the arrows - no text. This is not valid on a DROP_DOWN
     * and will be ignored
     * @default false
     */
    public-init var noText:         Boolean = false;
    /**
     * Specify that cursor movement in the non-control direction, i.e. up/down
     * for a SIDE_SCROLL will move focus to the next appropriate control
     * @default false
     */
    public-init var useArrowKeyTraversal: Boolean = false;
    override var focusTraversable = true;
    public-init var hpos:           HPos = HPos.LEFT;
    public var onIndexChange:       function(index: Integer): Void;
    public var onCycle:             function(cycleAmount: Integer): Void;
    package var resyncing:          Integer = 0;
    package var naturalWidth:       Float;
    package var naturalHeight:      Float;
    var firstTimeThrough = true;
    public-read var selectedIndex: Integer = bind (skin as XPickerSkin).listView.selectedIndex
    on replace
        {
        if (selectedItem != null)     // avoid initialisation crap
            {
            if (firstTimeThrough)      // avoid initial set
                {
                firstTimeThrough = false
                }
              else
                {
                if (resyncing == 0) onIndexChange(selectedIndex); // avoid notification if resyncing
                }
            }
        };
    public-read var selectedItem = bind (skin as XPickerSkin).listView.selectedItem
        on replace
            {
            if (selectedItem != null) then savedSelection = selectedItem;
            };
    public-read var cycleChange: Integer = 0
        on replace
            {
            if (cycleChange != 0) then
                {
                onCycle(cycleChange);
                }
            };
    var savedSelection: Object = "";

    init
        {
        //-- if dropDownPicker ensure dropDown is set
        if (pickerType == XPickerType.DROP_DOWN)
            {
            dropDown = true;
            }
        //-- additionally - if is a sideScrollPicker then set controlLeft to show there is one
        if (pickerType == XPickerType.SIDE_SCROLL)
            {
            controlOnLeft = true; // slightly artificial but saves lots of extra code checks
            }
        //-- additionally - if is a dropdown then ensure noText is false
        if (pickerType == XPickerType.DROP_DOWN and noText)
            {
            noText = false;
            }
        getNaturalSize();
        }

    postinit
        {
        focusTraversable = false;
        select(0);
        if (promptText != null) then
            {
            clearSelection();       // will force display of promptText
            }
        if (preset != NO_PRESET) then select(preset);
        if (presetItem != null) then
            {
            savedSelection = presetItem;
            resyncing++;
            FX.deferAction(function():Void {pickerBehavior.reSync(savedSelection);});
            }
        if (noText) then
            {
            naturalWidth = 0;
            }
        }

    public function getNaturalSize(): Void
        {
        var maxW: Float = 0;
        var newW: Float;
        var maxH: Float = 0;
        var newH: Float;
        var testLabel = Label {  };
        var itemsCopy = items;
        insert promptText into itemsCopy;
        for (item in itemsCopy)
            {
            testLabel.text = "{item}";
            var g = Group { content: testLabel };
            newW = testLabel.getPrefWidth(0);
            newH = testLabel.getPrefHeight(0);
            if (newW > maxW) then maxW = newW;
            if (newH > maxH) then maxH = newH;
            }
        naturalWidth = maxW;
        naturalHeight = maxH;
        }

    public function select(index: Integer): Void
        {
        if (index >= 0
            and index < sizeof (pickerSkin.listView.items))
            {
            pickerSkin.listView.select(index);
            }
        cycleChange = 0;
        }

    public function selectItem(item: Object): Void
        {
        for (index in [ 0..sizeof (items) - 1 ])
            {
            if (items[index].toString().equalsIgnoreCase(item.toString()))
                {
                select(index);
                }
            }
        }

    public function selectFirstRow(): Void
        {
        pickerSkin.listView.selectFirstRow();
        cycleChange = 0;
        }

    public function selectLastRow(): Void
        {
        pickerSkin.listView.selectLastRow();
        cycleChange = 0;
        }

    public function selectNextRow(): Void
        {
        if (cyclic
            and selectedIndex >= sizeof (items) - 1)
            {
            selectFirstRow();
            cycleChange = 1;
            }
        else
            {
            pickerSkin.listView.selectNextRow();
            cycleChange = 0;
            }
        }

    public function selectPreviousRow(): Void
        {
        if (cyclic
            and selectedIndex <= 0)
            {
            selectLastRow();
            cycleChange = -1;
            }
        else
            {
            pickerSkin.listView.selectPreviousRow();
            cycleChange = 0;
            }
        }

    public function clearSelection(): Void
        {
        pickerSkin.listView.clearSelection();
        }

    }
