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

 package picker;

import javafx.scene.control.Label;
import javafx.scene.layout.LayoutInfo;
import javafx.stage.Stage;
import javafx.scene.text.Text;
import javafx.scene.text.Font.*;
import javafx.scene.paint.Color;
import javafx.scene.layout.Stack;
import javafx.scene.shape.Rectangle;
import javafx.scene.layout.VBox;
import javafx.scene.layout.Tile;
import javafx.geometry.HPos;
import org.jfxtras.scene.ResizableScene;

/**
 * @author David
 */

/**************
Picker Info currently
NAME            TYPE        ACCESS    DEFAULT     DESCRIPTION
items           Object[]                          List (can be modified dynamically, but may have knock on effect on current position)
preset          Integer     init      0           Index of the pre-selected value
pickerType      PickerType  init      DROP_DOWN   Enum of DROP_DOWN, SIDE_SCROLL and THUMB_WHEEL
controlOnLeft   Boolean     init      false       Allows control button to be on left as opposed to default on right
firstLetter     Boolean     init      false       Allows keypress selection to next entry with same first letter
mouseRepeatDelayBoolean     init      0.5s        Delay before a mouse pressed will be treated as a repeat scroll

selectedIndex   Integer     read                  For obtaining the currently selected items index
selectedItem    Object      read                  For obtaining the currently selected item

cyclic          Boolean     init      false       True if the list should cycle from last entry to first or vice versa
cycleChange     Integer     read                  On cycling, will indicate the cycle direction and amount
dropDown        Boolean     init      true        Indicates if the dropdown selection list is available
dropDownSize    Integer     init      120         Size of drop down list


select(index: Integer): Void                    Sets the selection item dynamically
selectFirstRow(): Void                          Sets selected index to the first entry
selectLastRow(): Void                           Sets selected index to the last entry
selectNextRow(): Void                           Sets selected index to the next entry
                                                If cycle is on and current is the last entry, will set index to the
                                                first entry and set cycleChange to +1
selectPreviousRow(): Void                       Sets selected item to the previous entry
                                                If cycle is on and current is the firsst entry, will set index to the
                                                last entry and set cycleChange to -1


PrefHeight  24
MinHeight   16
PrefWidth   150
MinWidth    50
**************/

  var monthPicker = Picker {
    pickerType: PickerType.SIDE_SCROLL
    dropDown: true
    cyclic: true
    items: [
      "January", "February", "March", "April", "May", "June",
      "July", "August", "September", "October", "November", "December"
      ]
    layoutInfo: LayoutInfo {
      width: 120
      }
    };

  var cycleWatch: Integer = bind monthPicker.cycleChange on replace
    {
    yearPicker.select(yearPicker.selectedIndex + monthPicker.cycleChange);
    };

  var yearPicker = Picker {
    items: [ 1900..2099 ]
    preset: 2009 - 1900
    pickerType: PickerType.SIDE_SCROLL
    layoutInfo: LayoutInfo {
      width: 70
      }
    };

  var shapePicker = Picker {
    firstLetter: true
    items: [
      "Almond",
      "Arrow",
      "Asterisk",
      "Astroid",
      "Balloon",
      "Cross",
      "Donut",
      "Lauburu",
      "MultiRoundRectangle",
      "Rays",
      "RegularPolygon",
      "ReuleauxTriangle",
      "RoundPin",
      "Star2",
      "Triangle"
      ]
    };

  var colors = [
      "ALICEBLUE",
      "ANTIQUEWHITE",
      "AQUA",
      "AQUAMARINE",
      "AZURE",
      "BEIGE",
      "BISQUE",
      "BLACK",
      "BLANCHEDALMOND",
      "BLUE",
      "BLUEVIOLET",
      "BROWN",
      "BURLYWOOD",
      "CADETBLUE",
      "CHARTREUSE",
      "CHOCOLATE",
      "CORAL",
      "CORNFLOWERBLUE",
      "CORNSILK",
      "CRIMSON",
      "CYAN",
      "DARKBLUE",
      "DARKCYAN",
      "DARKGOLDENROD",
      "DARKGRAY",
      "DARKGREEN",
      "DARKGREY",
      "DARKKHAKI",
      "DARKMAGENTA",
      "DARKOLIVEGREEN",
      "DARKORANGE",
      "DARKORCHID",
      "DARKRED",
      "DARKSALMON",
      "DARKSEAGREEN",
      "DARKSLATEBLUE",
      "DARKSLATEGRAY",
      "DARKSLATEGREY",
      "DARKTURQUOISE",
      "DARKVIOLET",
      "DEEPPINK",
      "DEEPSKYBLUE",
      "DIMGRAY",
      "DIMGREY",
      "DODGERBLUE",
      "FIREBRICK",
      "FLORALWHITE",
      "FORESTGREEN",
      "FUCHSIA",
      "GAINSBORO",
      "GHOSTWHITE",
      "GOLD",
      "GOLDENROD",
      "GRAY",
      "GREEN",
      "GREENYELLOW",
      "GREY",
      "HONEYDEW",
      "HOTPINK",
      "INDIANRED",
      "INDIGO",
      "IVORY",
      "KHAKI",
      "LAVENDER",
      "LAVENDERBLUSH",
      "LAWNGREEN",
      "LEMONCHIFFON",
      "LIGHTBLUE",
      "LIGHTCORAL",
      "LIGHTCYAN",
      "LIGHTGOLDENRODYELLOW",
      "LIGHTGRAY",
      "LIGHTGREEN",
      "LIGHTGREY",
      "LIGHTPINK",
      "LIGHTSALMON",
      "LIGHTSEAGREEN",
      "LIGHTSKYBLUE",
      "LIGHTSLATEGRAY",
      "LIGHTSLATEGREY",
      "LIGHTSTEELBLUE",
      "LIGHTYELLOW",
      "LIME",
      "LIMEGREEN",
      "LINEN",
      "MAGENTA",
      "MAROON",
      "MEDIUMAQUAMARINE",
      "MEDIUMBLUE",
      "MEDIUMORCHID",
      "MEDIUMPURPLE",
      "MEDIUMSEAGREEN",
      "MEDIUMSLATEBLUE",
      "MEDIUMSPRINGGREEN",
      "MEDIUMTURQUOISE",
      "MEDIUMVIOLETRED",
      "MIDNIGHTBLUE",
      "MINTCREAM",
      "MISTYROSE",
      "MOCCASIN",
      "NAVAJOWHITE",
      "NAVY",
      "OLDLACE",
      "OLIVE",
      "OLIVEDRAB",
      "ORANGE",
      "ORANGERED",
      "ORCHID",
      "PALEGOLDENROD",
      "PALEGREEN",
      "PALETURQUOISE",
      "PALEVIOLETRED",
      "PAPAYAWHIP",
      "PEACHPUFF",
      "PERU",
      "PINK",
      "PLUM",
      "POWDERBLUE",
      "PURPLE",
      "RED",
      "ROSYBROWN",
      "ROYALBLUE",
      "SADDLEBROWN",
      "SALMON",
      "SANDYBROWN",
      "SEAGREEN",
      "SEASHELL",
      "SIENNA",
      "SILVER",
      "SKYBLUE",
      "SLATEBLUE",
      "SLATEGRAY",
      "SLATEGREY",
      "SNOW",
      "SPRINGGREEN",
      "STEELBLUE",
      "TAN",
      "TEAL",
      "THISTLE",
      "TOMATO",
      "TURQUOISE",
      "VIOLET",
      "WHEAT",
      "WHITE",
      "WHITESMOKE",
      "YELLOW",
      "YELLOWGREEN"];

  var colorPicker = Picker {
    controlOnLeft: true
    items: colors
    firstLetter: true
    };

  var thumb1 = Picker {
    items: [ 0..10 ]
    firstLetter: true
    pickerType: PickerType.THUMB_WHEEL
    layoutInfo: LayoutInfo {
      width: 50
      }
    };
  var thumb2 = Picker {
    items: [ 8..26 step 2 ]
    pickerType: PickerType.THUMB_WHEEL
    controlOnLeft: true
    mouseRepeatDelay: 0.1s
    layoutInfo: LayoutInfo {
      width: 45
      }
    };

  Stage {
    title: "JavaFX - Picker 0.83 Examples"
    scene: ResizableScene {
      width: 640
      height: 340
      fill: Color.WHITESMOKE
      content: [
        VBox {
          spacing: 10
          content: [
            Text { content: "Picker Control Examples" font: font("Arial", 16) },
            Tile {
              columns: 4
              vgap: 10
              hgap: 10
              nodeHPos: HPos.LEFT
              content: [
                Label { text: "Side Scroll:"},
                monthPicker,
                yearPicker,
                Label {text: bind "{monthPicker.selectedItem} {yearPicker.selectedItem}" font: font("Arial", 14) },
// row 2
                Label {text: "DropDown:"},
                shapePicker,
                colorPicker,
                Stack {
                  content:
                    [
                    Rectangle { height: 20 width: 140 fill: bind Color.web("{colorPicker.selectedItem}") },
                    Text { content:
                      bind "{shapePicker.selectedItem}"
                      font: font("Arial", 14)
                      }
                    ]
                  }
// row 3
                Label {text: "Thumb Wheel:"},
                thumb1,
                thumb2,
                Text { content:
                  bind "{thumb1.selectedItem}"
                  font: bind font("Arial", thumb2.selectedItem as Integer) 
                  },
                ]
              },
            Text {
              wrappingWidth: 550
              content:
                " \n \nSide Scroll picker for Month has been set to cycle and on cycling the change"
                "modifies the Year picker.\n \n"
                "The simple dropdown pickers have been set to allow for selection by their first"
                "letter.\n \n"
                "The Thumb wheel selectors have no dropdown, but the first one has been set to"
                "first letter (number) selection. These are best seen using the mouse wheel.\n \n"
                "All pickers should respond to Mouse clicks, wheels and keys.\n \n"
                "And NOW works with mouse pressed down for Scroll and Thumb Pickers! Plus adjustable item list with auto-resync."
              },
            ]
          }
        ]
      }
    };
