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

import javafx.reflect.FXContext;
import javafx.reflect.FXClassType;
import javafx.scene.control.Control;
import javafx.scene.paint.Color;
import org.jfxtras.scene.control.XTableSkin;
import org.jfxtras.scene.control.data.DataProvider;
import org.jfxtras.scene.control.data.SequenceObjectDataProvider;
import org.jfxtras.scene.control.renderer.DefaultTableHeaderRenderer;
import org.jfxtras.scene.control.renderer.NodeRenderer;
import org.jfxtras.scene.control.renderer.StringAutoRenderer;
import org.jfxtras.scene.control.renderer.TextRenderer;
import org.jfxtras.scene.layout.XLayoutInfo;
import org.jfxtras.scene.layout.XLayoutInfo.*;
import org.jfxtras.util.XMap;
import org.jfxtras.util.SequenceUtil;
import org.jfxtras.util.StringUtil;

/**
 * Table control
 * Still in progress.
 *
 * Todo list:
 * - put a cap on image caching
 * - sorting
 * - filtering
 * - column reordering
 * - column widths
 * - multiselect
 * - editable fields
 * - row highlight on mouse over
 * - variable row height
 * - wordwrap setting on grid
 * - vertical/horizontal alignment defaults
 * - support column (cell) selection
 * - multi-column sorting
 * - column grouping
 * - copy/paste
 * - non-uniform rows
 * - printing
 * - drag for scrolling / drag for multi-select (based on mobile/multiselect flags)
 * - validation
 * - custom editors
 * - tooltips
 * - implement additional renderers
 *
 * @author Stephen Chin
 * @author Keith Combs
 */
public class XTableView extends Control {
    var tableSkin = bind skin as XTableSkin;
    public var headerRenderer = DefaultTableHeaderRenderer {} on replace {
        headerRenderer.skin = tableSkin;
    }
    package var defaultRenderers:XMap = XMap {
        def context = FXContext.getInstance();
        entries: [
            XMap.Entry {
                key: context.getStringType()
                value: StringAutoRenderer {
                    textRenderer: TextRenderer {
                        font: bind tableSkin.font
                        fill: bind tableSkin.textColor
                        selectedFill: bind tableSkin.lightTextColor
                    }
                }
            }
            XMap.Entry {
                key: context.getIntegerType()
                value: TextRenderer {
                    font: bind tableSkin.font
                    fill: Color.DARKBLUE
                    selectedFill: bind tableSkin.lightTextColor
                }
            }
        ]
    }

    public var columns:XTableColumn[];
    public var sortOrder:String[];
    public var rowType:FXClassType;
    public var rows:Object[];
    public var dataProvider:DataProvider = SequenceObjectDataProvider {type: bind rowType, data: bind rows}
    public var rowSelect:Boolean; // todo - change to enum (none, row, column, cell)
    public var multiSelect:Boolean; // todo - change to enum (singleSelection, singleIntervalSelection, multipleInvervalSelection)
    public var selectedRow:Integer = -1;
    public var columnDragging = true;

    // A reference to a NodeRender in order to get the height of a row
    var nodeRenderer:NodeRenderer;
    // todo - get the default value from the nodeRenderer requested height instead
    //public var rowHeight:Integer = 20;
    //public var rowHeight:Integer = 200;
    public var rowHeight:Integer = bind nodeRenderer.mostRecentNodeRendered.layoutBounds.height as Integer on replace {
//        println("rowHeight:{rowHeight}");
    };
    
    /**
     * The default padding around table cells.  Can be overriden on each side
     * by setting the more specific padding variable.
     */
    public var padding:Integer = 3;

    /**
     * Padding on the left side of table cells.  Overrides the default padding
     * value if set.
     */
    public var leftPadding:Integer;

    /**
     * Padding on the top side of table cells.  Overrides the default padding
     * value if set.
     */
    public var topPadding:Integer;

    /**
     * Padding on the right side of table cells.  Overrides the default padding
     * value if set.
     */
    public var rightPadding:Integer;

    /**
     * Padding on the bottom side of table cells.  Overrides the default padding
     * value if set.
     */
    public var bottomPadding:Integer;

    public function scrollToSelected() {
        (skin as XTableSkin).scrollToRow(selectedRow);
    }
    // todo - need to set reasonable defaults...
    override function getMinWidth() {0}
    override function getMinHeight() {0}
    override function getPrefWidth(height) {
        // todo - figure out proper decoration width (probably not 20)
        var prefWidth = SequenceUtil.sum(for (column in columns) column.prefWidth) + 20;
        prefWidth;
    }
    override function getPrefHeight(width) {500}
    override function getMaxWidth() {Integer.MAX_VALUE}
    override function getMaxHeight() {Integer.MAX_VALUE}
    override function getHFill() {true}
    override function getVFill() {true}
    override function getHGrow() {ALWAYS}
    override function getVGrow() {ALWAYS}
    override function getHShrink() {SOMETIMES}
    override function getVShrink() {SOMETIMES}
    override var skin = XTableSkin {}

    init {
        initializeColumns();
    }

    function initializeColumns() {
        // todo 1.3 - this used to be isInitialized, but this is not reliable during init, file a bug on this.
        if (columns != null) return;
//        columns = for (column in dataProvider.columns) XTableColumn {
//            id: column
//            displayName: StringUtil.camelToTitleCase(column)
//            prefWidth: column.length() * 8 // todo - defaults should be provided by renderer
//            renderer: defaultRenderers.get(dataProvider.types[indexof column]) as NodeRenderer
//        }
        columns = for (column in dataProvider.columns) {
            nodeRenderer = defaultRenderers.get(dataProvider.types[indexof column]) as NodeRenderer;
            XTableColumn {
                id: column
                displayName: StringUtil.camelToTitleCase(column)
                prefWidth: column.length() * 8 // todo - defaults should be provided by renderer
                renderer: nodeRenderer
            }
        }
    }

    package function getLeftPad() {
        return if (isInitialized(leftPadding)) leftPadding else padding;
    }
    package function getTopPad() {
        return if (isInitialized(topPadding)) topPadding else padding;
    }
    package function getRightPad() {
        return if (isInitialized(rightPadding)) rightPadding else padding;
    }
    package function getBottomPad() {
        return if (isInitialized(bottomPadding)) bottomPadding else padding;
    }
}
