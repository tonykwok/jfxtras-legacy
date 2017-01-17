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

import javafx.scene.control.Skin;
import com.sun.javafx.scene.layout.Region;
import javafx.scene.paint.Color;
import javafx.scene.Scene;
import javafx.stage.Stage;
import javafx.stage.StageStyle;
import javafx.scene.shape.SVGPath;
import javafx.geometry.Insets;
import javafx.scene.Group;
import javafx.scene.control.Button;
import javafx.scene.control.Label;
import javafx.scene.control.ListView;
import javafx.scene.layout.Stack;
import javafx.scene.shape.Rectangle;
import com.sun.javafx.scene.layout.region.BackgroundFill;
import javafx.scene.layout.Container;
import org.jfxtras.scene.control.skin.XCaspian;

/**
 * @author David
 */
package var newDropdown: XPicker on replace oldDropdown {
    oldDropdown.pickerBehavior.hideDropDown();
    newDropdown.pickerBehavior.showDropDown();
    };

public class XPickerSkin extends Skin {

    override protected var behavior = XPickerBehavior {};
    var pickerBehavior = bind behavior as XPickerBehavior;
    var picker = bind control as XPicker;

    var markHighlightFill = BackgroundFill {
        offsets: Insets { top: 1, left: 0, bottom: -1, right: 0 }
        fill:  XCaspian.fxMarkHighlightColor
        };
    var markFill = BackgroundFill {
        fill: XCaspian.fxMarkColor
        };

    /*
     * Region available for appropriate left arrow shape to be styled by CSS
     * Placed in an area 2 * size so translate by half size to be in middle
     */
    var leftArrow: Region = Region {
        id: "left-arrow"
        translateX: bind leftArrow.layoutBounds.width / 2
        translateY: bind leftArrow.layoutBounds.height / 2
//-fx-shape
        shape: SVGPath { content: "M 0 0 v 7 l -4,-3.5 z" }
//-fx-padding
        padding: Insets { top: 3 left: 3.5 bottom: 3 right: 3.5 }
//-fx-background-color (and -fx-background-insets also in fills)
        backgroundFills: [ markHighlightFill, markFill ]
        };

    /*
     * Region available for appropriate right arrow shape to be styled by CSS
     * Placed in an area 2 * size so translate by -3/2 size to be in middle at end
     */
    var rightArrow: Region = Region {
        id: "right-arrow"
        translateX: bind rightArrow.layoutBounds.width / 2
        translateY: bind rightArrow.layoutBounds.height / 2
        shape: SVGPath { content: "M 0 0 v 7 l 4,-3.5 z" }
        padding: Insets { top: 3 left: 3.5 bottom: 3 right: 3.5 }
        backgroundFills: [ markHighlightFill, markFill ]
        };
    /*
     * Region available for appropriate down arrow shape to be styled by CSS
     */
    var pickerArrow: Region = Region {
        id: "picker-arrow"
        translateX: bind pickerArrow.layoutBounds.width / 2
        translateY: bind pickerArrow.layoutBounds.height / 2
        shape: SVGPath { content: "M 0 0 h 7 l -4,3.5 z" }
        padding: Insets { top: 3 left: 3.5 bottom: 3 right: 3.5 }
        backgroundFills: [ markHighlightFill, markFill ]
        };
    /*
     * Region available for appropriate up/down shape to be styled by CSS
     */
    var thumbWheelArrow: Region = Region {
        id: "thumb-wheel-arrow"
        translateX: bind thumbWheelArrow.layoutBounds.width / 2
        translateY: bind thumbWheelArrow.layoutBounds.height / 2
        shape: SVGPath { content: "M 0,3 h 7 l -4,-3.5 z M 0,5 h 7 l -4,3.5 z" }
        padding: Insets { top: 6 left: 4 bottom: 6 right: 4 }
        backgroundFills: [ markHighlightFill, markFill ]
        };

    /*
     * Determine which icons to use in the left area (if any)
     */
    var leftIcon: Group = Group {
        content: bind if (picker.pickerType == XPickerType.SIDE_SCROLL) then
            { leftArrow }
          else
            {
            if (picker.controlOnLeft) then
                { if (picker.pickerType == XPickerType.DROP_DOWN) then pickerArrow else thumbWheelArrow }
              else
                { null }
            }
        };
    /*
     * Determine which icons to use in the right area (if any)
     */
    var rightIcon: Group = Group {
        content: bind if (picker.pickerType == XPickerType.SIDE_SCROLL) then
            { rightArrow }
          else
            {
            if (not picker.controlOnLeft) then
                { if (picker.pickerType == XPickerType.DROP_DOWN) then pickerArrow else thumbWheelArrow }
              else
                { null }
            }
        };

    /*
     * Area at left of control for mouse clicking
     */
    package var leftClickArea: Rectangle = Rectangle {
        width: bind leftIcon.layoutBounds.width * 2
        height: bind picker.layoutBounds.height
        fill: Color.TRANSPARENT
        blocksMouse: true
        onMousePressed: function (e) {
            pickerBehavior.leftButtonClicked(e);
            }
        onMouseWheelMoved: function (e) {
            pickerBehavior.pickerWheeled(e);
            }
        onMouseExited: function (e) {
            pickerBehavior.mouseExited = true;
            }
        onMouseReleased: function (e) {
            pickerBehavior.mouseExited = true;
            }
        };

    /*
     * Area at right of control for mouse clicking
     */
    package var rightClickArea: Rectangle = Rectangle {
        width: bind rightIcon.layoutBounds.width * 2
        height: bind picker.layoutBounds.height
        fill: Color.TRANSPARENT
        blocksMouse: true
        onMousePressed: function (e) {
            pickerBehavior.rightButtonClicked(e);
            }
        onMouseWheelMoved: function (e) {
            pickerBehavior.pickerWheeled(e);
            }
        onMouseExited: function (e) {
            pickerBehavior.mouseExited = true;
            }
        onMouseReleased: function (e) {
            pickerBehavior.mouseExited = true;
            }
        };

    var leftButton: Stack = Stack {
        content: [ leftIcon, leftClickArea ]
        };
    var rightButton: Stack = Stack {
        translateX: bind picker.layoutBounds.width - rightClickArea.layoutBounds.width
        content: [ rightIcon, rightClickArea ]
        };


    /*
     * A button as our underlying control, but purely for graphics compatibility really
     */
    package var clickButtonWidth = bind
        if (picker.pickerType == XPickerType.SIDE_SCROLL) then
            {
            leftClickArea.layoutBounds.width + rightClickArea.layoutBounds.width;
            }
          else
            {
            if (picker.controlOnLeft)
                then leftClickArea.layoutBounds.width
                else rightClickArea.layoutBounds.width;
            };

    var leftPad = bind
        if (picker.pickerType == XPickerType.SIDE_SCROLL
            or picker.naturalWidth == 0
            or picker.controlOnLeft)
                then 0
                else 5;

    var rightPad = bind
        if (picker.pickerType == XPickerType.SIDE_SCROLL
            or picker.naturalWidth == 0
            or not picker.controlOnLeft)
                then 0
                else 5;

    package var labelWidth = bind 
        if (picker.noText)
            then 0
            else picker.layoutBounds.width - clickButtonWidth - leftPad - rightPad;

    package var xpickerButton: Button = Button {
        id: "picker-button"
        tooltip: bind picker.pickerTooltip 
        width: bind picker.layoutBounds.width
        height: bind picker.layoutBounds.height
        onMousePressed: function (e) {
            pickerBehavior.pickerClicked(e);
            }
        onMouseWheelMoved: function (e) {
            pickerBehavior.pickerWheeled(e);
            }
        onKeyPressed: function (e) {
            pickerBehavior.buttonKeyPressed(e);
            }
        };

    /*
     * Button label will not left justify so leave it blank and use a label layered on top
     */
    var xpickerLabel: Label = Label {
        id: "picker-label"
        translateX: bind leftClickArea.layoutBounds.width + leftPad
        text: bind if (listView.selectedIndex == -1) then picker.promptText else "{listView.selectedItem}"
        hpos: bind picker.hpos
        width: bind labelWidth
        height: bind picker.layoutBounds.height
        };

//    var diagRect = Rectangle {
//        width: bind xpickerLabel.width
//        height: bind xpickerLabel.height
//        translateX: bind leftClickArea.layoutBounds.width + leftPad
//        x: bind xpickerLabel.layoutX
//        y: bind xpickerLabel.layoutY
//        fill: Color.RED
//        opacity: 0.4
//        };
//
    /*
     * Stack for the button and label
     */
    var buttonLabelStack: Group = Group {
        content: bind [
            xpickerButton,
            if (picker.noText) then null else xpickerLabel,
//            diagRect
            ]
        };

    /*
     * The drop down ListView which is the real selection engine
     */
    public-read var listView: ListView = ListView {
        layoutX: 2
        layoutY: 2
        id: "picker-listview"
        managed: false 
        width: bind picker.layoutBounds.width - 3
        height: bind picker.dropDownHeight
        items: bind picker.items
        onMouseClicked: function (e) {
            pickerBehavior.listViewClicked(e);
            }
        onKeyPressed: function (e) {
            pickerBehavior.listViewPressed(e);
            }
        clip: bind Rectangle {
            x: 0
            y: 0
            width: bind listView.width
            height: bind listView.height
            }
        };

    package var pickerDropDown: Stage = Stage {
        isPopupStage: true
        visible: false
        style: StageStyle.TRANSPARENT
        width: bind picker.boundsInParent.width + 4
        height: bind listView.boundsInParent.height + 4
        scene: Scene {
            stylesheets: bind picker.scene.stylesheets
            fill: Color.TRANSPARENT
            content: listView
            }
        };

    init {
        }

    postinit {
        node = Container {
            id: picker.id
            styleClass: "xpicker"
            content: bind [
                buttonLabelStack,
                leftButton,
                rightButton,
                ]
            };
        }

/***************************************************************************
 * Required overrides
 ***************************************************************************/

    override function intersects(x, y, w, h): Boolean {
        return node.intersects(x, y, w, h);
        }

    override function contains(x, y): Boolean {
        return node.contains(x, y);
        }

    override protected function getPrefHeight(width: Number): Number {
        return picker.naturalHeight + 4;
        }

    override protected function getMinHeight(): Number {
        return picker.naturalHeight;
        }

    override protected function getPrefWidth(height: Number): Number {
        picker.naturalWidth + clickButtonWidth + leftPad + rightPad;
        }

    override protected function getMinWidth(): Number {
        clickButtonWidth;
        }

}
