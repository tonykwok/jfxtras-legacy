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

import javafx.scene.control.Control;
import javafx.scene.Node;

/**
 * <p>An iPhone style picker control.<p></p>
 *
    @example
 
 var iPicker4 = IPicker {
    textPadding: 5
    endAdjust: 0.65
    content: [
      IPickerWheel {
        name: "Hours"
        hpos: HPos.RIGHT
        font:  Font.font("Georgia", FontWeight.BOLD, 18)
        content:  for (i in [0..23]) { i.toString(); }
        visibleItems: 3
        }
      ]
    };
    @endexample
 *
 * @profile desktop
 *
 * @author David Armitage
 */

public class IPicker extends Control {

  override var skin = IPickerSkin {};
  var iPickerSkin = bind skin as IPickerSkin;
  var iPickerBehavior = bind iPickerSkin.behavior as IPickerBehavior;

  public-init var content: IPickerWheel[];
  public-init var textPadding: Integer = 15 
    on replace {
      if (textPadding < 0) then textPadding = 0;
      };
  public-init var verticalPaddingFactor = 1.5
    on replace {
      if (verticalPaddingFactor < 1.0) then verticalPaddingFactor = 1.0;
      };
      
// how much of the outer two items displays as a proportion
  public-init var endAdjust: Float = 0.5
    on replace {
      if (endAdjust > 0.9) then endAdjust = 0.9;
      if (endAdjust < 0.0) then endAdjust = 0.0;
      };
// Display the select bar or not (only really of use for single row mode
  public-init var selector: Boolean = true;
// Sound or not
  public-init var playSound: Boolean = true;
// Show blue focus outline or not
  public-init var showFocus: Boolean = false;

  package var wheelWidths: Float[];         // cumulative width of wheels
  package var fullWidth: Float;           // width of all wheels summed
  package var wheelHeight: Float;           // highest wheel result - should all be same really
  package var maxTextHeight: Float;
  package var maxVisibleItems: Integer;

  init
    {
    getTextSizes();
    }

  postinit
    {
    }

  override function create(): Node
    {
    skin = IPickerSkin{};
    super.create();
    }

  package function getTextSizes()
    {
    for (wheel in content)
      {
      fullWidth = fullWidth + wheel.maxTextWidth + 2 * textPadding;
      insert fullWidth into wheelWidths;
      if (wheel.maxTextHeight > maxTextHeight)
        then maxTextHeight = wheel.maxTextHeight;
      if (wheel.visibleItems > maxVisibleItems)
        then maxVisibleItems = wheel.visibleItems;
      }
    maxTextHeight = maxTextHeight * verticalPaddingFactor;   // vertical spacing adjust
    if (maxVisibleItems mod 2 == 0)         // if an even number move to next lower odd so center bar works
      then maxVisibleItems--;
    if (maxTextHeight > 0.0) 
      then wheelHeight = maxTextHeight * (maxVisibleItems + 2 * endAdjust);    
    for (wheel in content)
      {
      wheel.unifiedHeight = maxTextHeight;
      wheel.unifiedVisibleItems = maxVisibleItems;
      wheel.playSounds = playSound;
      }
    fullWidth = fullWidth + 3;   // and extra 4 for the right hand wheel boundary
    }

  public function getSelectedItem(name: String): String
    {
    return getWheel(name).getSelectedItem();
    }

  public function getSelectedIndex(name: String): Integer
    {
    return getWheel(name).getSelectedIndex();
    }

  public function setSelectedItem(name: String, item: String): Void
    {
    getWheel(name).setSelectedItem(item);
    }

  public function setSelectedIndex(name: String, index: Integer): Void
    {
    getWheel(name).setSelectedIndex(index);
    }

  public function scrollToIndex(name: String, index: Integer): Void
    {
    getWheel(name).scrollToIndex(index);
    }

  public function scrollToItem(name: String, item: String): Void
    {
    getWheel(name).scrollToItem(item);
    }

  function getWheel(name: String): IPickerWheel
    {
    for (wheel in content)
      {
      if (wheel.name.equals(name)) return wheel;
      }
    return null;
    }

  }

