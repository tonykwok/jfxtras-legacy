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

import org.jfxtras.lang.XBind;
import org.jfxtras.scene.control.data.DataRow;
import org.jfxtras.scene.control.renderer.Selectable;

/**
 * @author Keith Combs
 * @author Stephen Chin
 */
package class XTableBodyRow extends XTableRow {
    public var index:Integer;
    public var data:XBind on replace {
        dataChanged();
        data.addListener(function(o, n) {dataChanged()});
    }
    public var selected:Boolean on replace {setSelected()}
    var dataDirty = true;

    function dataChanged() {
        dataDirty = true;
        requestLayout();
    }

    function updateData() {
        if (not dataDirty) return;
        if (nodes != null) {
            internalRecycleData();
        }
        var table = skin.table;
        var padW = table.getLeftPad() + table.getRightPad();
        var padH = table.getTopPad() + table.getBottomPad();
        var height = skin.rowHeight - padH;
        def columns = skin.table.columns[c|c.visible];
        renderers = null;
        nodes = for (object in (data.ref as DataRow).getData()) {
            def columnWidth = skin.columnLayout.columnInfo[indexof object].width;
            def renderer = columns[indexof object].renderer;
            insert renderer into renderers;
            renderer.createNode(object, index, false, columnWidth - padW, height);
        }
        setSelected();
        dataDirty = false;
    }

    function setSelected() {
        for (node in nodes where node instanceof Selectable) {
            (node as Selectable).selected = selected;
        }
    }

    public function recycleData() {
        data = null;
        internalRecycleData();
    }

    function internalRecycleData() {
        def columns = skin.table.columns[c|c.visible];
        for (n in content) {
            (n as XTableCell).recycleNode();
        }
        delete nodes;
    }

    override function doLayout() {
        updateData();
        super.doLayout();
    }

    override var backgroundFill = bind if (skin.table.selectedRow == index) {
        skin.selectedGradient
    } else if (index mod 2 == 0) {
        skin.backgroundColor
    } else {
        skin.alternateColor
    }

    override var onMouseReleased = function(e) {
        skin.table.selectedRow = index;
    }
    override var onMouseDragged = function(e) {
        skin.table.selectedRow = index;
    }
}
