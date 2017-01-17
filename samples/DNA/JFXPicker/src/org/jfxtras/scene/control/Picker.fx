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

package org.jfxtras.scene.control;

import javafx.scene.control.Control;
import javafx.scene.Node;

/**
 * <p>A multi choice drop down / side scroll picker / thumbWheel.<p></p>
 *
    @example

    Picker {
      pickerType: PickerType.SIDE_SCROLL
      cyclic: true
      items: [ "January", "February", "March", "April", "May", "June",
               "July", "August", "September", "October", "November", "December" ]
      };
    @endexample
 *
 * @profile desktop
 *
 * @author David Armitage
 */
public class Picker extends Control {

  def NO_PRESET: Integer = -999999;

  override var skin = PickerSkin {};
  var pickerSkin = bind skin as PickerSkin;
  var pickerBehavior = bind pickerSkin.behavior as PickerBehavior;

  public      var items:            Object[] = [] on replace
    {
    if (isInitialized(selectedItem)) then FX.deferAction(function(){pickerBehavior.reSync(savedSelection);});
    };
  public-init var cyclic:           Boolean = false;
  public-init var dropDown:         Boolean = false;
  public-init var dropDownHeight:   Integer = 120;
  public-init var preset:           Integer = NO_PRESET;
  public-init var controlOnLeft:    Boolean = false;
  public-init var pickerType:       PickerType = PickerType.DROP_DOWN;
  public-init var firstLetter:      Boolean = false;
  public-init var mouseRepeatDelay: Duration = 0.5s;

  public-read var selectedIndex: Integer = bind (skin as PickerSkin).listView.selectedIndex;
  public-read var selectedItem = bind (skin as PickerSkin).listView.selectedItem on replace
    {
    if (selectedItem != null) then savedSelection = selectedItem;
    };
  public-read var cycleChange: Integer = 0;

  var savedSelection: Object;

  init
    {
    //-- if dropDownPicker ensure dropDown is set
    if (pickerType == PickerType.DROP_DOWN)
      {
      dropDown = true;
      }
    //-- additionally - if is a sideScrollPicker then set controlLeft to show there is one
    if (pickerType == PickerType.SIDE_SCROLL)
      {
      controlOnLeft = true;       // slightly artificial but saves lots of extra code checks
      }
    }

  postinit
    {
    if (preset == NO_PRESET) then select(0) else select(preset);
    }

  override function create(): Node
    {
    skin = PickerSkin{};
    super.create();
    }

  public function select(index: Integer): Void
    {
    if (index >= 0 and index < sizeof(pickerSkin.listView.items))
      {
      pickerSkin.listView.select(index);
      }
    cycleChange = 0;
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
    if (cyclic and selectedIndex >= sizeof(items) - 1)
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
    if (cyclic and selectedIndex <= 0)
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
  }
 