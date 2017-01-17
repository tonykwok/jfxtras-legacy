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
package org.jfxtras.scene.layout;

import javafx.geometry.Insets;
import javafx.scene.Node;
import javafx.scene.layout.Priority;
import javafx.util.Math;
import javafx.util.Sequences;
import org.jfxtras.scene.layout.XLayoutInfo.*;
import org.jfxtras.util.SequenceUtil;

/**
 * This container uses a flexible Grid layout algorithm to position and size
 * its children.  Creating a new Grid is as easy as constructing an instance,
 * adding in a list of Rows, and populating whatever Nodes you want to display.
 * <p>
 * Reasonable defaults are provided for most of the common JavaFX components,
 * but for more control you can wrap Nodes in {@link Cell} objects and set
 * various constraints such as grow, span, and preferred dimensions.
 * <p>
 * Here is a sample Grid to create a form:
 * <blockquote><pre>
 * XGrid {
 *     rows: [
 *         row([Text {content: "Username:"}, TextBox {}]),
 *         row([Text {content: "Password:"}, TextBox {}]),
 *         row([TextBox {layoutInfo: XGridLayoutInfo {hspan: 2}}])
 *     ]
 * }
 * </pre></blockquote>
 * <p>
 * For more information about using Grids, please refer to the test examples in
 * the JavaFX source code, or see my blog:
 * <a href="http://steveonjava.com/">http://steveonjava.com/</a>
 *
 * Todo:
 * - implement aspect ratio
 *
 * @profile common
 *
 * @author Stephen Chin
 * @author Keith Combs
 */
public class XGrid extends XContainer {

    /**
     * The horizontal position of each node within the Grid cell.
     * <p>
     * This may be overridden for individual nodes by setting the hpos variable
     * on the node's layoutInfo variable.
     */
    public var nodeHPos = LEFT on replace {
        requestLayout();
    }

    /**
     * The vertical position of each node within the Grid cell.
     * <p>
     * This may be overridden for individual nodes by setting the vpos variable
     * on the node's layoutInfo variable.
     */
    public var nodeVPos = MIDDLE on replace {
        requestLayout();
    }

    /**
     * The top,right,bottom,left padding around the container's content.
     * This space will be included in the calculation of the container's
     * minimum and preferred sizes.
     */
    public var padding:Insets on replace {
        requestLayout();
    }

    /**
     * The width of the horizontal gaps between cells.  This can be set to zero
     * to have cells flush against each other.
     */
    public var hgap:Number = 6 on replace {
        requestLayout();
    }

    /**
     * The width of the vertical gaps between cells.  This can be set to zero
     * to have cells flush against each other.
     */
    public var vgap:Number = 6 on replace {
        requestLayout();
    }

    /**
     * If set, all rows will automatically span the last element to the width
     * of the container.
     * <p>
     * Note: Some nodes may not span to the row end if doing so would cause
     * rows below them to get wider based on their vspan setting.
     */
    public var spanToRowEnd:Boolean on replace {
        requestLayout();
    }

    public var rows:XGridRow[] on replace {
        def newContent = for (row in rows) {
            row.cells
        }
        // use a stable update so toFront and toBack work correctly
        fromRows = true;
        content = SequenceUtil.stableUpdate(content, newContent) as Node[];
        fromRows = false;
    }

    public var columns:XGridColumn[] on replace {
        requestLayout();
    }

    var rowMaximum:Number[];

    var columnMaximum:Number[];

    var rowMinimum:Number[];

    var columnMinimum:Number[];

    var rowPreferred:Number[];

    var columnPreferred:Number[];

    var rowActual:Number[];

    var columnActual:Number[];

    var rowGrow:Priority[];

    var columnGrow:Priority[];

    var rowShrink:Priority[];

    var columnShrink:Priority[];

    var rowEndSpans:Integer[];

    override function getMaxHeight() {recalculateSizes(); SequenceUtil.sum(rowMaximum) + (rowMaximum.size() - 1) * vgap + padding.top + padding.bottom}

    override function getMaxWidth() {recalculateSizes(); SequenceUtil.sum(columnMaximum) + (columnMaximum.size() - 1) * hgap + padding.left + padding.right}

    override function getMinHeight() {recalculateSizes(); SequenceUtil.sum(rowMinimum) + (rowMinimum.size() - 1) * vgap + padding.top + padding.bottom}

    override function getMinWidth() {recalculateSizes(); SequenceUtil.sum(columnMinimum) + (columnMinimum.size() - 1) * hgap + padding.left + padding.right}

    override function getPrefHeight(width) {recalculateSizes(); SequenceUtil.sum(rowPreferred) + (rowPreferred.size() - 1) * vgap + padding.top + padding.bottom}

    override function getPrefWidth(height) {recalculateSizes(); SequenceUtil.sum(columnPreferred) + (columnPreferred.size() - 1) * hgap + padding.left + padding.right}

    function createSequence(length:Integer, value:Object):Object[] {
        return for (i in [1..length]) value;
    }

    function createNumberSequence(length:Integer, value:Number):Number[] {
        return for (i in [1..length]) value;
    }

    var fromRows:Boolean;

    override var content on replace originalContent=newContent {
        if (not fromRows and originalContent != newContent) {
            println("WARNING: Please set rows rather than content when using the Grid");
        }
    }

    var hgrow:Priority[] = bind for (r in rows) {
        for (c in getManaged(r.cells)) {
            getNodeHGrow(c)
        }
    }

    var vgrow:Priority[] = bind for (r in rows) {
        for (c in getManaged(r.cells)) {
            getNodeVGrow(c)
        }
    }

    var layoutDirty = true;

    override function requestLayout() {
        layoutDirty = true;
        super.requestLayout();
    }

    var numRows:Integer;
    var numColumns:Integer;

    function recalculateSizes() {
        if (not layoutDirty or rows.isEmpty()) {
            return;
        }
        numRows = sizeof rows;
        var rowSpans:Integer[];
        var rowSizes = for (row in rows) {
            def width = row.column + sizeof rowSpans + SequenceUtil.sum(for (cell in getManaged(row.cells)) {
                getNodeHSpan(cell);
            });
            insert for (cell in getManaged(row.cells), i in [0..<getNodeHSpan(cell)]) getNodeVSpan(cell) into rowSpans;
            rowSpans = for (span in rowSpans where span > 1) span - 1;
            width;
        }
        numColumns = Sequences.max(rowSizes) as Integer;
        if (spanToRowEnd) {
            rowEndSpans = for (row in rows) {
                def width = rowSizes[indexof row];
                def managed = getManaged(row.cells);
                def lastNode = managed[sizeof managed - 1];
                def originalHspan = getNodeHSpan(lastNode);
                def vspan = getNodeVSpan(lastNode);
                var rowSpan = numColumns - width + originalHspan;
                for (i in [1..<vspan]) {
                    def space = numColumns - rowSizes[indexof row + i] + originalHspan;
                    if (rowSpan > space) {
                        rowSpan = space;
                    }
                }
                if (rowSpan > originalHspan) for (i in [0..<vspan]) {
                    rowSizes[indexof row + i] += rowSpan - originalHspan;
                }
                rowSpan;
            }
        }
        rowMaximum = createNumberSequence(numColumns, 0);
        columnMaximum = createNumberSequence(numColumns, 0);
        rowMinimum = createNumberSequence(numRows, 0);
        columnMinimum = createNumberSequence(numColumns, 0);
        rowPreferred = createNumberSequence(numRows, 0);
        columnPreferred = createNumberSequence(numColumns, 0);
        rowActual = createNumberSequence(numRows, 0);
        columnActual = createNumberSequence(numColumns, 0);
        rowGrow = createSequence(numRows, NEVER) as Priority[];
        columnGrow = createSequence(numColumns, NEVER) as Priority[];
        rowShrink = createSequence(numRows, NEVER) as Priority[];
        columnShrink = createSequence(numColumns, ALWAYS) as Priority[];
        rowSpans = createSequence(numColumns, 0) as Integer[];
        for (row in rows) {
            var columnIndex = row.column;
            def managed = getManaged(row.cells);
            for (node in managed) {
                while (rowSpans[columnIndex] > 0) {columnIndex++}
                def marginWidth = getNodeMarginWidth(node);
                def marginHeight = getNodeMarginHeight(node);
                def vspan = getNodeVSpan(node);
                def hspan = getHSpan(node, indexof row, indexof node == sizeof managed - 1);
                def vgrow = getNodeVGrow(node);
                def hgrow = getNodeHGrow(node);
                def vshrink = getNodeVShrink(node);
                def hshrink = getNodeHShrink(node);
                def maximumHeight = getNodeMaxHeight(node) + marginHeight;
                def maximumWidth = getNodeMaxWidth(node) + marginWidth;
                def minimumHeight = (if (vspan > 1) 0 else if (vshrink == NEVER) getNodePrefHeight(node) else getNodeMinHeight(node)) + marginHeight;
                def minimumWidth = (if (hspan > 1) 0 else if (hshrink == NEVER) getNodePrefWidth(node) else getNodeMinWidth(node)) + marginWidth;
                def preferredHeight = (if (vspan > 1) 0 else getNodePrefHeight(node)) + marginHeight;
                def preferredWidth = (if (hspan > 1) 0 else getNodePrefWidth(node)) + marginWidth;
                rowMaximum[indexof row] = Math.max(rowMaximum[indexof row], maximumHeight);
                columnMaximum[columnIndex] = Math.max(columnMaximum[columnIndex], maximumWidth);
                rowMinimum[indexof row] = Math.max(rowMinimum[indexof row], minimumHeight);
                columnMinimum[columnIndex] = Math.max(columnMinimum[columnIndex], minimumWidth);
                rowPreferred[indexof row] = Math.max(rowPreferred[indexof row], preferredHeight);
                columnPreferred[columnIndex] = Math.max(columnPreferred[columnIndex], preferredWidth);
                for (i in [0..<vspan]) {
                    rowGrow[indexof row + i] = Priority.max(rowGrow[indexof row + i], vgrow);
                    rowShrink[indexof row + i] = Priority.min(rowShrink[indexof row + i], vshrink);
                }
                for (i in [0..<hspan]) {
                    columnGrow[columnIndex + i] = Priority.max(columnGrow[columnIndex + i], hgrow);
                    columnShrink[columnIndex + i] = Priority.min(columnShrink[columnIndex + i], hshrink);
                }
                if (vspan > 1) for (i in [0..<hspan]) {
                    rowSpans[columnIndex + i] = vspan;
                }
                columnIndex += hspan;
            }
            rowSpans = for (span in rowSpans) if (span == 0) 0 else span - 1;
        }
        doSpanSizes();
        doRowColumnOverrides();
        doPercentages();
        var rowSometimesShrink:Number[];
        var columnSometimesShrink:Number[];
        for (row in rows) {
            var columnIndex = row.column;
            def managed = getManaged(row.cells);
            for (node in managed) {
                while (rowSpans[columnIndex] > 0) {columnIndex++}
                def marginHeight = getNodeMarginHeight(node);
                def marginWidth = getNodeMarginWidth(node);
                def vspan = getNodeVSpan(node);
                def hspan = getHSpan(node, indexof row, indexof node == sizeof managed - 1);
                def preferredHeight = (if (vspan > 1) 0 else getNodePrefHeight(node)) + marginHeight;
                def preferredWidth = (if (hspan > 1) 0 else getNodePrefWidth(node)) + marginWidth;
                if (getNodeVShrink(node) == SOMETIMES) {
                    rowSometimesShrink[indexof row] = Math.max(rowSometimesShrink[indexof row], preferredHeight);
                }
                if (getNodeHShrink(node) == SOMETIMES) {
                    columnSometimesShrink[columnIndex] = Math.max(columnSometimesShrink[columnIndex], preferredWidth);
                }
                columnIndex += hspan;
            }
        }
        doRowShrink(rowSometimesShrink);
        doColumnShrink(columnSometimesShrink);
        doRowGrow(rowGrow);
        doColumnGrow(columnGrow);
        layoutDirty = false;
    }

    function getHSpan(node:Node, rowIndex:Integer, lastInRow:Boolean) {
        if (spanToRowEnd and lastInRow) {
            rowEndSpans[rowIndex];
        } else {
            getNodeHSpan(node);
        }
    }

    function doSpanSizes() {
        var rowSpans = createSequence(numColumns, 0) as Integer[];
        for (row in rows) {
            var columnIndex = row.column;
            def managed = getManaged(row.cells);
            for (node in managed) {
                while (rowSpans[columnIndex] > 0) {columnIndex++}
                def marginWidth = getNodeMarginWidth(node);
                def marginHeight = getNodeMarginHeight(node);
                def vspan = getNodeVSpan(node);
                def hspan = getHSpan(node, indexof row, indexof node == sizeof managed - 1);
                def vshrink = getNodeVShrink(node);
                def hshrink = getNodeHShrink(node);
                if (hspan > 1) {
                    def minimumWidth = (if (hshrink == NEVER) getNodePrefWidth(node) else getNodeMinWidth(node)) + marginWidth;
                    def curMinWidth = SequenceUtil.sum(for (i in [0..<hspan]) columnMinimum[columnIndex + i]);
                    if (curMinWidth < minimumWidth) {
                        def widthDelta = (minimumWidth - curMinWidth) / hspan;
                        for (i in [0..<hspan]) {
                            columnMinimum[columnIndex + i] += widthDelta;
                        }
                    }
                    def preferredWidth = getNodePrefWidth(node) + marginWidth;
                    def curPrefWidth = SequenceUtil.sum(for (i in [0..<hspan]) columnPreferred[columnIndex + i]);
                    if (curPrefWidth < preferredWidth) {
                        def widthDelta = (preferredWidth - curPrefWidth) / hspan;
                        for (i in [0..<hspan]) {
                            columnPreferred[columnIndex + i] += widthDelta;
                        }
                    }
                }
                if (vspan > 1) {
                    def minimumHeight = (if (vshrink == NEVER) getNodePrefHeight(node) else getNodeMinHeight(node)) + marginHeight;
                    def curMinHeight = SequenceUtil.sum(for (i in [0..<vspan]) rowMinimum[indexof row + i]);
                    if (curMinHeight < minimumHeight) {
                        def heightDelta = (minimumHeight - curMinHeight) / vspan;
                        for (i in [0..<vspan]) {
                            rowMinimum[indexof row + i] += heightDelta;
                        }
                    }
                    def preferredHeight = getNodePrefHeight(node) + marginHeight;
                    def curPrefHeight = SequenceUtil.sum(for (i in [0..<vspan]) rowPreferred[indexof row + i]);
                    if (curPrefHeight < preferredHeight) {
                        def heightDelta = (preferredHeight - curPrefHeight) / vspan;
                        for (i in [0..<vspan]) {
                            rowPreferred[indexof row + i] += heightDelta;
                        }
                    }
                }
                if (vspan > 1) for (i in [0..<hspan]) {
                    rowSpans[columnIndex + i] = vspan;
                }
                columnIndex += hspan;
            }
            rowSpans = for (span in rowSpans) if (span == 0) 0 else span - 1;
        }
    }

    function doRowColumnOverrides() {
        for (row in rows) {
            if (isInitialized(row.minHeight)) {
                rowMinimum[indexof row] = row.minHeight;
            }
            if (isInitialized(row.height)) {
                rowPreferred[indexof row] = row.height;
            }
            if (isInitialized(row.vgrow)) {
                rowGrow[indexof row] = row.vgrow;
            }
            if (isInitialized(row.vshrink)) {
                rowShrink[indexof row] = row.vshrink;
            }
            if (isInitialized(row.percentage)) {
                rowGrow[indexof row] = rowShrink[indexof row] = NEVER;
            }
            rowActual[indexof row] = Math.max(rowMinimum[indexof row], rowPreferred[indexof row]);
        }
        for (i in [0..<numColumns]) {
            def column = columns[i];
            if (column != null) {
                if (isInitialized(column.minWidth)) {
                    columnMinimum[i] = column.minWidth;
                }
                if (isInitialized(column.width)) {
                    columnPreferred[i] = column.width;
                }
                if (isInitialized(column.hgrow)) {
                    columnGrow[i] = column.hgrow;
                }
                if (isInitialized(column.hshrink)) {
                    columnShrink[i] = column.hshrink;
                }
                if (isInitialized(column.percentage)) {
                    columnGrow[i] = columnShrink[i] = NEVER;
                }
            }
            columnActual[i] = Math.max(columnMinimum[i], columnPreferred[i]);
        }
    }


    function doPercentages() {
        def rowPercentageTotal = SequenceUtil.sum(for (row in rows) row.percentage);
        def rowOverrun = if (rowPercentageTotal <= 1) 1 else 1 / rowPercentageTotal;
        for (row in rows) {
            if (isInitialized(row.percentage)) {
                rowActual[indexof row] = height * row.percentage * rowOverrun;
            }
        }
        def columnPercentageTotal = SequenceUtil.sum(for (column in columns) column.percentage);
        def columnOverrun = if (columnPercentageTotal <= 1) 1 else 1 / columnPercentageTotal;
        for (column in columns) {
            if (isInitialized(column.percentage)) {
                columnActual[indexof column] = width * column.percentage * columnOverrun;
            }
        }
    }

    function doRowShrink(rowSometimesShrink:Integer[]) {
        var rowTotal = vgap * (rowActual.size() - 1);
        for (actual in rowActual) {
            rowTotal += actual;
        }
        def rowAvailable = height - rowTotal;
        if (rowAvailable < 0) {
            var minimumHeight = vgap * (rowMinimum.size() - 1);
            for (minimum in rowMinimum) {
                minimumHeight += minimum;
            }
            // handle ALWAYS shrinking
            var sometimesHeight = minimumHeight;
            for (sometimes in rowSometimesShrink) {
                sometimesHeight += sometimes;
            }
            var newHeight = Math.max(sometimesHeight, height);
            if (rowTotal > newHeight) {
                def shrinkPercent = (rowTotal - newHeight) / (rowTotal - sometimesHeight);
                for (minimum in rowMinimum) {
                    rowActual[indexof minimum] -= (rowActual[indexof minimum] - Math.max(minimum, rowSometimesShrink[indexof minimum])) * shrinkPercent
                }
                rowTotal = newHeight;
            }
            newHeight = Math.max(minimumHeight, height);
            // handle SOMETIMES shrinking
            if (rowTotal > newHeight) {
                def shrinkPercent = (rowTotal - newHeight) / (rowTotal - minimumHeight);
                for (minimum in rowMinimum) {
                    rowActual[indexof minimum] -= (rowActual[indexof minimum] - minimum) * shrinkPercent
                }
            }
        }
    }

    function doColumnShrink(columnSometimesShrink:Number[]) {
        var columnTotal = hgap * (columnActual.size() - 1);
        for (actual in columnActual) {
            columnTotal += actual;
        }
        var columnAvailable = width - columnTotal;
        if (columnAvailable < 0) {
            var minimumWidth = hgap * (columnMinimum.size() - 1);
            for (minimum in columnMinimum) {
                minimumWidth += minimum;
            }
            // handle ALWAYS shrinking
            var sometimesWidth = minimumWidth;
            for (sometimes in columnSometimesShrink) {
                sometimesWidth += sometimes;
            }
            var newWidth = Math.max(sometimesWidth, width);
            if (columnTotal > newWidth) {
                def shrinkPercent = (columnTotal - newWidth) / (columnTotal - sometimesWidth);
                for (minimum in columnMinimum) {
                    columnActual[indexof minimum] -= (columnActual[indexof minimum] - Math.max(minimum, columnSometimesShrink[indexof minimum])) * shrinkPercent
                }
                columnTotal = newWidth;
            }
            newWidth = Math.max(minimumWidth, width);
            // handle SOMETIMES shrinking
            if (columnTotal > newWidth) {
                def shrinkPercent = (columnTotal - newWidth) / (columnTotal - minimumWidth);
                for (minimum in columnMinimum) {
                    columnActual[indexof minimum] -= (columnActual[indexof minimum] - minimum) * shrinkPercent
                }
            }
        }
    }

    function doRowGrow(rowGrow:Priority[]) {
        var rowTotal = vgap * (rowActual.size() - 1);
        for (actual in rowActual) {
            rowTotal += actual;
        }
        def rowAvailable = height - rowTotal;
        if (rowAvailable > 0) {
            def numAlways = rowGrow[g|g == ALWAYS].size();
            if (numAlways > 0) {
                for (grow in rowGrow where grow == ALWAYS) {
                    rowActual[indexof grow] += rowAvailable / numAlways;
                }
            } else {
                def numSometimes = rowGrow[g|g == SOMETIMES].size();
                for (grow in rowGrow where grow == SOMETIMES) {
                    rowActual[indexof grow] += rowAvailable / numSometimes;
                }
            }
        }
    }

    function doColumnGrow(columnGrow:Priority[]) {
        var columnTotal = hgap * (columnActual.size() - 1);
        for (actual in columnActual) {
            columnTotal += actual;
        }
        def columnAvailable = width - columnTotal;
        if (columnAvailable > 0) {
            def numAlways = columnGrow[g|g == ALWAYS].size();
            if (numAlways > 0) {
                for (grow in columnGrow where grow == ALWAYS) {
                    columnActual[indexof grow] += columnAvailable / numAlways;
                }
            } else {
                def numSometimes = columnGrow[g|g == SOMETIMES].size();
                for (grow in columnGrow where grow == SOMETIMES) {
                    columnActual[indexof grow] += columnAvailable / numSometimes;
                }
            }
        }
    }

    override function doLayout():Void {
        recalculateSizes();
        var y:Number = padding.top;
        var rowSpans = createSequence(numColumns, 0) as Integer[];
        for (row in rows) {
            var columnIndex = row.column;
            var x:Number = padding.left;
            for (i in [0..<columnIndex]) {
                x += columnActual[i] + hgap;
            }
            def managed = getManaged(row.cells);
            for (node in managed) {
                while (rowSpans[columnIndex] > 0) x += columnActual[columnIndex++] + hgap;
                def vspan = getNodeVSpan(node);
                def hspan = getHSpan(node, indexof row, indexof node == sizeof managed - 1);
                def areaX = x;
                def areaY = y;
                var areaW = columnActual[columnIndex];
                for (i in [1..<hspan]) {
                    areaW += columnActual[columnIndex + i] + hgap;
                }
                var areaH = rowActual[indexof row];
                for (i in [1..<vspan]) {
                    areaH += rowActual[indexof row + i] + vgap;
                }
                def column = columns[columnIndex];
                layoutNode(node, areaX, areaY, areaW, areaH, -1,
                    if (column != null and isInitialized(column.hfill)) column.hfill else true,
                    if (isInitialized(row.vfill)) row.vfill else true,
                    if (column != null and isInitialized(column.hpos)) column.hpos else nodeHPos,
                    if (isInitialized(row.vpos)) row.vpos else nodeVPos,
                    snapToPixel
                );
                x += areaW + hgap;
                if (vspan > 1) for (i in [0..<hspan]) {
                    rowSpans[columnIndex + i] = vspan;
                }
                columnIndex += hspan;
            }
            rowSpans = for (span in rowSpans) if (span == 0) 0 else span - 1;
            y += rowActual[indexof row] + vgap;
        }
        layoutDirty = true;
    }

    override function toString() {
        "XGrid \{nodeHPos={nodeHPos}, nodeVPos={nodeVPos}, padding={padding}, hgap={hgap}, vgap={vgap}, spanToRowEnd={spanToRowEnd}, rows={rows.toString()}, columns={columns.toString()}\}"
    }
}
