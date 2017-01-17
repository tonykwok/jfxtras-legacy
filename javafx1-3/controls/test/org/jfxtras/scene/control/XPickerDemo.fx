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
package  org.jfxtras.scene.control;

import javafx.scene.control.Label;
import javafx.scene.layout.LayoutInfo;
import javafx.stage.Stage;
import javafx.scene.text.Text;
import javafx.scene.text.Font.*;
import javafx.scene.paint.Color;
import javafx.scene.layout.Stack;
import javafx.scene.shape.Rectangle;
import javafx.geometry.HPos;
import javafx.scene.control.Button;
import javafx.scene.layout.HBox;
import javafx.geometry.VPos;
import org.jfxtras.scene.layout.XGrid;
import org.jfxtras.scene.layout.XGrid.*;
import org.jfxtras.scene.layout.XGridRow;
import org.jfxtras.scene.layout.XGridColumn;
import org.jfxtras.scene.layout.XLayoutInfo;
import javafx.scene.layout.Priority;
import javafx.scene.layout.VBox;
import javafx.animation.KeyFrame;
import javafx.animation.Timeline;
import javafx.scene.Scene;
import javafx.scene.control.ChoiceBox;
import javafx.scene.control.Tooltip;

/**
 * @author David
 */

/**************
XPicker Info currently
NAME            TYPE        ACCESS    DEFAULT     DESCRIPTION
items           Object[]                          List (can be modified dynamically, but may have knock on effect on current position)
promptText      String      init                  Displayed if present and no preset/presetItem **
preset          Integer     init      0           Index of the pre-selected value
presetItem      Object      init                  Item value to be preset
pickerType      XPickerType init      DROP_DOWN   Enum of DROP_DOWN, SIDE_SCROLL and THUMB_WHEEL
controlOnLeft   Boolean     init      false       Allows control button to be on left as opposed to default on right
firstLetter     Boolean     init      false       Allows keypress selection to next entry with same first letter
mouseRepeatDelayBoolean     init      0.5s        Delay before a mouse pressed will be treated as a repeat scroll
upArrowIncreasesBoolean     init      false       Reverse the natural behaviour such that up arrow/wheelscroll increase values
useArrowKeyTraversal Boolean init     false       Allow arrow keys to move to next control focus where not used by XPicker
**DEPRECATED** showFocus       Boolean     init      true        Whether to show the blue focus outline or not
**DEPRECATED** base            Color       init      Caspian     Color to base the control on
**DEPRECATED** useColorForText Boolean     init      false       Use the color in base for the text and arrow part of the Picker as well as buttons
hpos            HPos        init      LEFT        Position of text in picker
layoutInfo      LayoutInfo                        Defaults preferred and max width to max item size

selectedIndex   Integer     read                  For obtaining the currently selected items index
selectedItem    Object      read                  For obtaining the currently selected item

cyclic          Boolean     init      false       True if the list should cycle from last entry to first or vice versa
cycleChange     Integer     read                  On cycling, will indicate the cycle direction and amount
dropDown        Boolean     init      true        Indicates if the dropdown selection list is available
dropDownSize    Integer     init      150         Size of drop down list

onIndexChange   function(index: Integer): Void  Listener for an index change - will not trigger when initialising or resyncing
onCycle         function(cycleAmount: Integer): Void  Listener for a cycle change - will not trigger when initialising or resyncing

select(index: Integer): Void                    Sets the selection item dynamically
selectFirstRow(): Void                          Sets selected index to the first entry
selectLastRow(): Void                           Sets selected index to the last entry
selectNextRow(): Void                           Sets selected index to the next entry
                                                If cycle is on and current is the last entry, will set index to the
                                                first entry and set cycleChange to +1
selectPreviousRow(): Void                       Sets selected item to the previous entry
                                                If cycle is on and current is the firsst entry, will set index to the
                                                last entry and set cycleChange to -1


**************/

    var monthPicker: XPicker = XPicker {
        pickerType: XPickerType.SIDE_SCROLL
        pickerTooltip: Tooltip { text: "Select the required Month" }
        dropDown: true
        dropDownHeight: 300
        cyclic: true
        id: "Months"
        items: [
            "January", "February", "March", "April", "May", "June",
            "July", "August", "September", "October", "November", "December"
            ]
        onCycle: function(cycleAmount){ yearPicker.select(yearPicker.selectedIndex + monthPicker.cycleChange); }
        };

//**** and same as onCycle but as a bound public variable
//  var cycleWatch: Integer = bind monthPicker.cycleChange on replace
//    {
//    yearPicker.select(yearPicker.selectedIndex + monthPicker.cycleChange);
//    };

    var yearPicker: XPicker = XPicker {
        items: [ 1900..2099 ]
        id: "Years"
        presetItem: 2010
        pickerType: XPickerType.SIDE_SCROLL
        hpos: HPos.CENTER
        pickerTooltip: Tooltip { text: "Select the required Year" }
        };

    var shapePicker = XPicker {
        firstLetter: true
        promptText: "Please choose a shape ..."
        id: "JFXtras Shapes"
        layoutInfo: XLayoutInfo { hfill: true maxWidth: 4000 }
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
        "ALICEBLUE", "ANTIQUEWHITE", "AQUA", "AQUAMARINE", "AZURE", "BEIGE", "BISQUE", "BLACK", "BLANCHEDALMOND",
        "BLUE", "BLUEVIOLET", "BROWN", "BURLYWOOD", "CADETBLUE", "CHARTREUSE", "CHOCOLATE", "CORAL", "CORNFLOWERBLUE",
        "CORNSILK", "CRIMSON", "CYAN", "DARKBLUE", "DARKCYAN", "DARKGOLDENROD", "DARKGRAY", "DARKGREEN", "DARKGREY",
        "DARKKHAKI", "DARKMAGENTA", "DARKOLIVEGREEN", "DARKORANGE", "DARKORCHID", "DARKRED", "DARKSALMON", "DARKSEAGREEN",
        "DARKSLATEBLUE", "DARKSLATEGRAY", "DARKSLATEGREY", "DARKTURQUOISE", "DARKVIOLET", "DEEPPINK","DEEPSKYBLUE", "DIMGRAY",
        "DIMGREY", "DODGERBLUE", "FIREBRICK", "FLORALWHITE", "FORESTGREEN", "FUCHSIA", "GAINSBORO", "GHOSTWHITE", "GOLD",
        "GOLDENROD", "GRAY", "GREEN", "GREENYELLOW", "GREY", "HONEYDEW", "HOTPINK", "INDIANRED", "INDIGO", "IVORY", "KHAKI",
        "LAVENDER", "LAVENDERBLUSH", "LAWNGREEN", "LEMONCHIFFON", "LIGHTBLUE", "LIGHTCORAL", "LIGHTCYAN", "LIGHTGOLDENRODYELLOW",
        "LIGHTGRAY", "LIGHTGREEN", "LIGHTGREY", "LIGHTPINK", "LIGHTSALMON", "LIGHTSEAGREEN", "LIGHTSKYBLUE", "LIGHTSLATEGRAY",
        "LIGHTSLATEGREY", "LIGHTSTEELBLUE","LIGHTYELLOW", "LIME", "LIMEGREEN", "LINEN", "MAGENTA", "MAROON", "MEDIUMAQUAMARINE",
        "MEDIUMBLUE", "MEDIUMORCHID", "MEDIUMPURPLE", "MEDIUMSEAGREEN", "MEDIUMSLATEBLUE", "MEDIUMSPRINGGREEN", "MEDIUMTURQUOISE",
        "MEDIUMVIOLETRED", "MIDNIGHTBLUE", "MINTCREAM", "MISTYROSE", "MOCCASIN", "NAVAJOWHITE","NAVY", "OLDLACE", "OLIVE", "OLIVEDRAB",
        "ORANGE", "ORANGERED", "ORCHID", "PALEGOLDENROD", "PALEGREEN", "PALETURQUOISE", "PALEVIOLETRED", "PAPAYAWHIP", "PEACHPUFF",
        "PERU", "PINK", "PLUM", "POWDERBLUE", "PURPLE", "RED", "ROSYBROWN", "ROYALBLUE", "SADDLEBROWN", "SALMON", "SANDYBROWN",
        "SEAGREEN", "SEASHELL", "SIENNA", "SILVER", "SKYBLUE", "SLATEBLUE", "SLATEGRAY", "SLATEGREY", "SNOW", "SPRINGGREEN",
        "STEELBLUE", "TAN", "TEAL", "THISTLE", "TOMATO", "TURQUOISE", "VIOLET", "WHEAT", "WHITE", "WHITESMOKE", "YELLOW", "YELLOWGREEN"
        ];

    var dynamicColors:String[];

    var colorPicker: XPicker = XPicker {
        id: "JavaFX Colors"
        items: bind dynamicColors
        pickerTooltip: Tooltip { text: "Colors loading..." }
        firstLetter: true
        hpos: HPos.CENTER
        layoutInfo: XLayoutInfo { hfill: true hgrow: Priority.ALWAYS }
        onIndexChange: function(index){ println("Color changed to - {colorPicker.selectedItem}"); colorPicker.style = "-fx-base: {colorPicker.selectedItem};"; }
        };

    var thumb1 = XPicker {
        id: "Demo thumbwheel 1"
        items: [ 0..10 ]
        upArrowIncreases: false
        firstLetter: true
        pickerType: XPickerType.THUMB_WHEEL
        };

    var thumb2 = XPicker {
        id: "Demo thumbwheel 2"
        items: [ 8..26 step 2 ]
        pickerType: XPickerType.THUMB_WHEEL
        controlOnLeft: true
        hpos: HPos.RIGHT
        mouseRepeatDelay: 0.1s
        };

    var pNudgeSS = XPicker {
        id: "Left Right Nudger"
        pickerType: XPickerType.SIDE_SCROLL
        noText: true
        items: [1..10]
        hpos: HPos.RIGHT
        };

    var pNudgeTW = XPicker {
        id: "Up Down Nudger"
        pickerType: XPickerType.THUMB_WHEEL
        noText: true
        items: [-10..10]
        upArrowIncreases: true
        hpos: HPos.RIGHT
        };

    var aw1: XPicker = XPicker {
        id: "aw1"
        pickerType: XPickerType.THUMB_WHEEL
        controlOnLeft: true
        items: [10..300 step 5]
        presetItem: 80
        hpos: HPos.CENTER
        layoutInfo: LayoutInfo {
            width: bind aw1.selectedItem as Integer
            maxWidth: 300
            }
        };

    var aw2: XPicker = XPicker {
        id: "aw2"
        pickerType: XPickerType.THUMB_WHEEL
        controlOnLeft: true
        items: [10..300 step 5]
        presetItem: 100
        hpos: HPos.CENTER
        layoutInfo: LayoutInfo {
            width: bind aw2.selectedItem as Integer
            maxWidth: 300
            hfill: true
            }
        };

    var aw3: XPicker = XPicker {
        id: "aw3"
        pickerType: XPickerType.THUMB_WHEEL
        controlOnLeft: true
        items: [10..300 step 5]
        presetItem: 120
        hpos: HPos.CENTER
        layoutInfo: LayoutInfo {
            width: bind aw3.selectedItem as Integer
            maxWidth: 300
            }
        };

    function run() {
        Timeline {
            keyFrames: [
                for (color in colors)
                    {
                    KeyFrame {
                        time: 200ms * indexof color
                        action: function() {
                            insert color into dynamicColors;
                            }
                        }
                    },
                KeyFrame {
                    time: 200ms * sizeof(colors)
                    action: function() {
                        colorPicker.pickerTooltip = Tooltip { text: "This is the tooltip for colors\nonce they are all loaded"};
                        }
                    }
                ]
            }.play();

        Stage {
            title: "XPicker v2 for JavaFX 1.3 Examples"
            width: 600
            height: 240
            scene: Scene {
                stylesheets: ["{__DIR__}XPicker.css"]
                content: [
                    VBox {
                        layoutY: 10
                        layoutX: 10
                        content: [
                            XGrid {
                                vgap: 10
                                hgap: 10
                                nodeHPos: HPos.LEFT
                                columns: [
                                    XGridColumn { hpos: HPos.RIGHT },
                                    XGridColumn { hpos: HPos.LEFT },
                                    XGridColumn { hpos: HPos.LEFT },
                                    XGridColumn { hpos: HPos.CENTER },
                                    ]
                                rows: [
// row 1
                                    XGridRow{
                                        cells: [
                                            Label { text: "Side Scroll:" },
                                            monthPicker,
                                            yearPicker,
                                            Label {
                                                text: bind "{monthPicker.selectedItem} {yearPicker.selectedItem}"
                                                font: font("Arial", 14)
                                                },
                                            ]
                                        },
// row 2
                                    XGridRow{
                                        cells: [
                                            Label {text: "DropDown:" },
                                            shapePicker,
                                            colorPicker,
                                            Stack {
                                                content:
                                                    [
                                                    Rectangle {
                                                        height: 20
                                                        width: 140
                                                        fill: bind Color.web("{colorPicker.selectedItem}")
                                                        },
                                                    Text { content:
                                                        bind "{shapePicker.selectedItem}"
                                                        font: font("Arial", 14)
                                                        }
                                                    ]
                                                }
                                            ]
                                        },
// row 3
                                    XGridRow {
                                        cells: [
                                            Label {text: "Thumb Wheel:" },
                                            thumb1,
                                            thumb2,
                                            Text {
                                                content: bind "{thumb1.selectedItem}"
                                                font: bind font("Arial", thumb2.selectedItem as Integer)
                                                },
                                            ]
                                        },
// row 4
                                    XGridRow {
                                        cells: [
                                            Label {text: "Side / Thumb nudge:"},
                                            HBox {
                                                spacing: 10
                                                nodeVPos: VPos.CENTER
                                                content: [
                                                    pNudgeSS,
                                                    Text { content: bind pNudgeSS.selectedItem.toString() }
                                                    ]
                                                },
                                            HBox {
                                                spacing: 10
                                                nodeVPos: VPos.CENTER
                                                content: [
                                                    pNudgeTW, Text { content: bind pNudgeTW.selectedItem.toString() }
                                                    ]
                                                },
                                            Button {
                                                text: "Color LIGHTYELLOW"
                                                action: function(){ colorPicker.selectItem("LightYellow"); }
                                                },
                                            ]
                                        },
// row 5
                                    XGridRow {
                                        cells: [
                                            Label {text: "Adjust size:" },
                                            aw1,
                                            aw2,
                                            aw3,
                                            ]
                                        },
// row 6
                                    XGridRow {
                                        cells: [
                                            Label {text: "Diagnostics:" },
                                            ChoiceBox { items: [ 1..9 ] tooltip: Tooltip { text: "Test Tooltip1" } },
                                            Button {
                                                text: "Clear shapePicker"
                                                action: function(){ shapePicker.clearSelection(); }
                                                tooltip: Tooltip { text: "Test Tooltip2" }
                                                }
//                                            Button {
//                                                action: function(){ println("OnMouseEnter does scan to avoid focus change by pressing this!"); }
//                                                text: "Scan"
//                                                onMouseEntered: function(me){ scanScene(monthPicker.scene.content); }
//                                                },
//                                            xp,
                                            ]
                                        },
//            Text {
//              wrappingWidth: 550
//              content:
//                " \nSide Scroll picker for Month has been set to cycle and on cycling the change"
//                "modifies the Year picker.\n \n"
//                "The simple dropdown pickers have been set to allow for selection by their first"
//                "letter.\n \n"
//                "The Thumb wheel selectors have no dropdown, but the first one has been set to"
//                "first letter (number) selection. These are best seen using the mouse wheel. "
//                "Additionally the 2 thumbwheels set for opposite directions.\n \n"
//                "All pickers should respond to Mouse clicks, wheels and keys.\n \n"
//                "And NOW works with mouse pressed down for Scroll and Thumb Pickers! Plus adjustable item list with auto-resync.\n"
//              },
                                    ]
                                }
                            ]
                        }
                    ]
                }
            }
        }
//
//    var xp: XPicker = XPicker {
//        items: ["Month Picker","Year Picker","Shape Picker","Color Picker","Thumb1","Thumb2","Nudger Side","Nudger Thumb"]
//        onIndexChange: function(i){
//            if (xp.selectedItem.equals("Month Picker")) then {
//                //monthPicker.requestFocus();
//                TraversalEngine.traverse(monthPicker, Direction.DOWN);
//                }
//            if (xp.selectedItem.equals("Year Picker")) then yearPicker.requestFocus();
//            if (xp.selectedItem.equals("Shape Picker")) then shapePicker.requestFocus();
//            if (xp.selectedItem.equals("Color Picker")) then colorPicker.requestFocus();
//            if (xp.selectedItem.equals("Thumb1")) then thumb1.requestFocus();
//            if (xp.selectedItem.equals("Thumb2")) then thumb2.requestFocus();
//            if (xp.selectedItem.equals("Nudger Side")) then pNudgeSS.requestFocus();
//            if (xp.selectedItem.equals("Nudger Thumb")) then pNudgeTW.requestFocus();
//            scanScene(monthPicker.scene.content);
//            }
//        };//    var level = 0;
//    var dots = ".........................................................";
//
//    function scanScene(nodes: Node[]): Void
//        {
//        for (node in nodes)
//            {
//            println("{dots.substring(0,level)}{level} - {node.id} {node}   traversable - {node.focusTraversable}");
//            if (node.focused) then println("********* FOCUSED ***************");
//            if (node instanceof(Parent)) then
//                {
//                level++;
//                scanScene((node as Parent).impl_getChildren());
//                level--;
//                }
//            }
//        }
