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

import java.lang.Class;
import javafx.geometry.HPos;
import javafx.geometry.VPos;
import javafx.reflect.FXLocal;
import javafx.scene.shape.Rectangle;
import javafx.util.Math;
import org.jfxtras.lang.XBind;
import org.jfxtras.scene.layout.XContainer;

/**
 * @author Stephen Chin
 */
var context = FXLocal.getContext();
package class XTableBody extends XContainer {
    public-init var skin:XTableSkin;
    public var scrollPosition:Double on replace {
        updateVisible(false);
        requestLayout();
    }
    public function requestLayoutOnRows() {
        for (row in content) {
            (row as XTableRow).requestLayout();
        }
    }

    override var height on replace {
        updateVisible(false);
    }
    var needsUpdate:Boolean;
    var dataProvider = bind skin.dataProvider;
    var rowCount = bind dataProvider.rowCount on replace {
        updateVisible(false);
    }

    var rowPool:XTableBodyRow[];
    var startIndex:Integer;
    var endIndex:Integer = -1;
    var dataType:Class;
    var selected = bind skin.table.selectedRow on replace oldSelected=newSelected {
        (content[oldSelected-startIndex] as XTableBodyRow).selected = false;
        (content[newSelected-startIndex] as XTableBodyRow).selected = true;
    }
    var columnIds = bind for (column in skin.table.columns where column.visible) column.id on replace {
        clearRows();
        updateVisible(false);
    }

    override var clip = Rectangle {
        width: bind width
        height: bind height
    }

    function clearRows() {
        recycle(content as XTableBodyRow[]);
        delete content;
        startIndex = 0;
        endIndex = -1;
    }

    function updateVisible(fromLayout:Boolean) {
        if (not fromLayout and needsLayout) {
            // if a layout is already scheduled, defer this method until that call
            needsUpdate = true;
            return;
        }
        var newStartIndex = Math.max(0, scrollPosition) as Integer;
        var newEndIndex = Math.min(dataProvider.rowCount - 1, Math.ceil(scrollPosition + height / skin.rowHeight) as Integer);
        if (startIndex != newStartIndex or endIndex != newEndIndex) {
            recycle(content[0..newStartIndex-startIndex-1] as XTableBodyRow[]);
            recycle(content[newEndIndex-startIndex+1..endIndex-startIndex] as XTableBodyRow[]);
            var contentReuse = content[newStartIndex-startIndex..newEndIndex-startIndex];
            var newRowsBefore = createRows(newStartIndex, Math.min(startIndex, newEndIndex+1)-newStartIndex);
            var rowsAfter = newEndIndex-newStartIndex+1 - sizeof contentReuse - sizeof newRowsBefore;
            var newRowsAfter = createRows(newEndIndex-rowsAfter+1, rowsAfter);
            content = [
                newRowsBefore,
                contentReuse,
                newRowsAfter
            ];
            startIndex = newStartIndex;
            endIndex = newEndIndex;
            requestLayout();
        }
        needsUpdate = false;
    }

    function recycle(rows:XTableBodyRow[]):Void {
        for (row in rows) {
            row.recycleData();
        }
        insert rows into rowPool;
    }

    function createRows(index:Integer, count:Integer):XTableRow[] {
        if (count == 0) return null;
        def dataSeq = bind skin.table.dataProvider.getRange(index, count, columnIds);
        for (data in dataSeq) {
            def rowIndex = index + indexof data;
            def row = if (sizeof rowPool > 0) {
                var r = rowPool[sizeof rowPool - 1];
                delete rowPool[sizeof rowPool - 1];
                r;
            } else {
                XTableBodyRow {
                    skin: skin
                }
            }
            row.index = rowIndex;
            row.data = XBind {ref: bind dataSeq[indexof data]};
            row.selected = rowIndex == selected;
            row;
        }
    }

    override function doLayout() {
        if (needsUpdate) {
            updateVisible(true);
        }
        for (i in [startIndex..endIndex]) {
          
            // Mitigate the artifacts left when scrolling
            content[i - startIndex].clip = Rectangle {
                width: width
                height: skin.rowHeight
            };

            layoutNode(content[i - startIndex], 0, skin.rowHeight * (i - scrollPosition), width, skin.rowHeight, HPos.LEFT, VPos.TOP);
        }
    }
}
