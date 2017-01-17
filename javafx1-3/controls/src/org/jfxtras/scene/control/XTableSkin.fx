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

import javafx.animation.Timeline;
import javafx.animation.Interpolator;
import javafx.geometry.BoundingBox;
import javafx.geometry.HPos;
import javafx.geometry.VPos;
import javafx.scene.Node;
import javafx.scene.control.ScrollBar;
import javafx.scene.effect.InnerShadow;
import javafx.scene.layout.LayoutInfo;
import javafx.scene.layout.Panel;
import javafx.scene.paint.Color;
import javafx.scene.paint.LinearGradient;
import javafx.scene.paint.Stop;
import javafx.scene.shape.Rectangle;
import javafx.scene.text.Font;
import javafx.scene.text.FontWeight;
import javafx.util.Math;
import org.jfxtras.scene.layout.XContainer;
import org.jfxtras.scene.paint.ColorUtil;
import org.jfxtras.scene.shape.ResizableRectangle;
import org.jfxtras.scene.control.skin.AbstractSkin;
import org.jfxtras.scene.control.skin.XCaspian;

/**
 * @author Stephen Chin
 * @author Keith Combs
 */
public class XTableSkin extends AbstractSkin {
    public var accentColor:Color = XCaspian.fxAccent;
    public var baseColor:Color = XCaspian.fxBase;
    public var strongBaseColor:Color = XCaspian.fxAccent;  // Strong base is now accent since v1.3
    public var darkTextColor:Color = XCaspian.fxDarkTextColor;
    public var textColor:Color = XCaspian.fxTextBaseColor;
    public var lightTextColor:Color = XCaspian.fxLightTextColor;
    public var markColor:Color = XCaspian.fxMarkColor;
    public var lightMarkColor:Color = XCaspian.fxMarkHighlightColor;
    public var backgroundColor:Color = Color.WHITE;
    public var alternateColor:Color = Color.web("#F3F3F3");
    public var font:Font = XCaspian.fxFont;
    public var headerFont:Font = Font.font(font.style, FontWeight.BOLD, font.size);
    // hack - do something better!
    package var headerHeight:Number = 20;
    package var rowHeight:Number = bind table.rowHeight;
    package var columnLayout = XTableColumnLayout {skin: this};
    package var selectedGradient = XCaspian.fxSelectionBar;

    package var table = bind control as XTableView;

    package var dataProvider = bind table.dataProvider;

    var pageHeight:Number = bind tableBody.layoutBounds.height / rowHeight - 1;

    var scrollMax:Number = bind Math.max(0, dataProvider.rowCount - tableBody.layoutBounds.height / rowHeight);

    package function scrollToRow(row:Integer) {
        scrollBar.value = Math.max(scrollBar.value, row - pageHeight);
        scrollBar.value = Math.min(scrollBar.value, row);
    }

    package function pageUp() {
        table.selectedRow = Math.max(table.selectedRow - (pageHeight as Integer), 0);
        scrollToRow(table.selectedRow);
    }

    package function pageDown() {
        table.selectedRow = Math.min(table.selectedRow + (pageHeight as Integer), dataProvider.rowCount - 1);
        scrollToRow(table.selectedRow);
    }

    package function requestLayout():Void {
        (node as Panel).requestLayout();
    }

    package function requestLayoutOnRows():Void {
        tableHeader.requestLayoutOnRows();
        tableBody.requestLayoutOnRows();
    }

    var scrollBar:ScrollBar = ScrollBar {
        // workaround for scrollbar bug where UI freezes on thumb hide/show
        ////override var max = bind Math.max(pageHeight + 1, scrollMax) on replace {
        //override var max = bind dataProvider.rowCount on replace {
        override var max = bind dataProvider.rowCount on replace {
          //println("ScrollBar.max:{max}");
        }
        override var min on replace {
          //println("ScrollBar.min:{min}");
        }
        override var value on replace {
          //println("ScrollBar.value:{value}");
        }
        override var visibleAmount = bind tableBody.layoutBounds.height / rowHeight on replace {
//          println("ScrollBar.visibleAmount:{visibleAmount}");
//          println("  tableBody.layoutBounds.height:{tableBody.layoutBounds.height}");
//          println("  rowHeight:{rowHeight}");
//          println("  ScrollBar.max:{scrollBar.max}");
        }

        vertical: true
        unitIncrement: 1
        blockIncrement: bind pageHeight
        disable: bind scrollBar.max <= scrollBar.visibleAmount
        blocksMouse: true
        // workaround for defaults issue with scrollbars:
        // todo 1.3 - file a bug on this
        layoutInfo: LayoutInfo {vfill: true}
    }

    var tableHeader = XTableHeader {skin: this}

    var tableBody:XTableBody = XTableBody {skin: this, scrollPosition: bind scrollBar.value * ((scrollBar.max - scrollBar.visibleAmount) / scrollBar.max)}

    var tableCorner = ResizableRectangle {
        effect: InnerShadow {color: bind markColor, offsetX: 2, offsetY: 2, radius: 5}
        fill: bind ColorUtil.darker(baseColor, .1)
    }

    var border = Rectangle {
        x: -1, y: -1
        fill: bind baseColor
        stroke: bind markColor
    }

    def focus = Rectangle {
        translateX: -3, translateY: -3
        fill: null
        stroke: bind accentColor
        strokeWidth: 1.5
        arcWidth: 2
        arcHeight: 2
        opacity: 0
    }

    var focusTransition = Timeline {
        keyFrames: [
            at (0s) {focus.opacity => 0}
            at (200ms) {focus.opacity => 1 tween Interpolator.EASEIN}
        ]
    }

    var focused = bind table.focused on replace {
        focusTransition.rate = if (table.focused) then 1 else -1;
        focusTransition.play();
    }

    override var behavior = XTableBehavior {}

    override var node = Panel {
        override var onMouseWheelMoved = function(e) {
            if (scrollBar.max > scrollBar.visibleAmount) {
                if (e.wheelRotation > 0) {
                    if (scrollBar.value + e.wheelRotation <= scrollBar.max) {
                        scrollBar.value += e.wheelRotation;
                    }
                    else {
                        scrollBar.value = scrollBar.max;
                    }
                }
                else if (e.wheelRotation < 0) {
                    if (scrollBar.value + e.wheelRotation >= scrollBar.min) {
                        scrollBar.value += e.wheelRotation;
                    }
                    else {
                        scrollBar.value = scrollBar.min;
                    }
                }
            }
        }
        override var onMousePressed = function(e) {
            table.requestFocus();
        }
        width: bind table.width
        height: bind table.height
        var lastWidth:Number;
        var lastHeight:Number;
        content: bind [
            focus,
            border,
            tableBody,
            tableHeader,
            tableCorner,
            scrollBar,
        ]
        prefWidth: function(height) {500}
        prefHeight: function(width) {500}
        override var layoutBounds = bind lazy BoundingBox{width: table.width, height: table.height}
        onLayout: function() {
            if (lastWidth != table.width or lastHeight != table.height or columnLayout.needsLayout) {
                lastWidth = table.width;
                lastHeight = table.height;
                var scrollBarWidth = XContainer.getNodePrefWidth(scrollBar);
                columnLayout.layoutWidth = table.width - scrollBarWidth;
                columnLayout.doLayout();
                XContainer.layoutNode(tableHeader, 0, 0, table.width - scrollBarWidth, headerHeight, HPos.CENTER, VPos.CENTER);
                XContainer.layoutNode(tableBody, 0, headerHeight, table.width - scrollBarWidth, table.height - headerHeight);
                XContainer.layoutNode(tableCorner, table.width - scrollBarWidth, 0, scrollBarWidth, headerHeight - 1);
                XContainer.layoutNode(scrollBar, table.width - scrollBarWidth, headerHeight - 1, scrollBarWidth, table.height - headerHeight + 1, HPos.CENTER, VPos.CENTER);
                border.width = table.width + 1;
                border.height = table.height + 1;
                focus.width = table.width + 5;
                focus.height = table.height + 5;
            }
        }
    }
}
