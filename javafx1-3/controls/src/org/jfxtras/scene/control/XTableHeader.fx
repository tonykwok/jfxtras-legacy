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
import javafx.scene.shape.Rectangle;
import org.jfxtras.scene.layout.XContainer;

/**
 * @author Stephen Chin
 */
package class XTableHeader extends XContainer {
    public-init var skin:XTableSkin;

    public function requestLayoutOnRows():Void {
        headers.requestLayout();
    }

    var headers:XTableRow = XTableRow {
        skin: skin
        nodes: bind for (column in skin.table.columns where column.visible) skin.table.headerRenderer.render(column.displayName)
        backgroundFill: bind skin.table.headerRenderer.getFill(height);
        onBackgroundDragged: function(e, index) {
            if (skin.table.columnDragging) {
                skin.columnLayout.startDrag(index);
                skin.columnLayout.drag(e.dragX, sceneToLocal(e.sceneX, e.sceneY).x);
            }
        }
        onBackgroundReleased: function(e, index) {
            if (skin.table.columnDragging) {
                skin.columnLayout.endDrag();
            }
        }
        useGap: false
    }

    override var content = bind headers;

    override var clip = Rectangle {
        width: bind width
        height: bind height
    }

    override function doLayout() {
        layoutNode(headers, 0, 0, width, height, HPos.LEFT, VPos.CENTER);
    }
}
