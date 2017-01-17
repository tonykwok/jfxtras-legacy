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

import javafx.geometry.HPos;
import javafx.geometry.VPos;
import javafx.scene.Node;
import javafx.scene.input.MouseEvent;
import javafx.scene.paint.Paint;
import org.jfxtras.scene.control.renderer.NodeRenderer;
import org.jfxtras.scene.layout.XContainer;
import org.jfxtras.scene.layout.XLayoutInfo;
import org.jfxtras.scene.layout.XLayoutInfo.*;
import javafx.scene.Parent;

/**
 * @author Keith Combs
 * @author Stephen Chin
 */
package class XTableRow extends XContainer {
    public var skin:XTableSkin;
    public var backgroundFill:Paint;
    public var nodes:Node[] on replace {
        updateCells();
    }
    public var renderers:NodeRenderer[];
    public var cells:XTableCell[];
    public var useGap = true;
    public var onBackgroundPressed:function(e:MouseEvent, index:Integer);
    public var onBackgroundDragged:function(e:MouseEvent, index:Integer);
    public var onBackgroundReleased:function(e:MouseEvent, index:Integer);
    public var onBackgroundClicked:function(e:MouseEvent, index:Integer);

    var draggingIndex = bind skin.columnLayout.draggingIndex on replace {
        updateOrder();
    }

    function updateCells() {
        for (cell in cells) {
            cell.node = null;
        }
        cells = [
            cells[0..sizeof nodes - 1],
            for (i in [sizeof cells..sizeof nodes - 1]) {
                XTableCell {
                    skin: skin
                    backgroundFill: bind backgroundFill
                    onBackgroundPressed: onBackgroundPressed
                    onBackgroundDragged: onBackgroundDragged
                    onBackgroundReleased: onBackgroundReleased
                    onBackgroundClicked: onBackgroundClicked
                }
            }
        ];
        for (node in nodes) {
            cells[indexof node].node = node;
            cells[indexof node].renderer = renderers[indexof node];
            cells[indexof node].index = indexof node;
        }
        updateOrder();
    }

    function updateOrder() {
        content = [cells[c|indexof c != draggingIndex], cells[c|indexof c == draggingIndex]];
        requestLayout();
    }

    override function doLayout() {
        for (n in content) {
            def cell = n as XTableCell;
            def columnInfo = skin.columnLayout.columnInfo[cell.index];
            cell.backgroundOpacity = columnInfo.opacity;
            layoutNode(cell, columnInfo.position, 0, columnInfo.width, height, HPos.LEFT, VPos.TOP);
        }
    }
}
