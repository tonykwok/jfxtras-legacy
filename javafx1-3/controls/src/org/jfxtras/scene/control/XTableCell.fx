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

import javafx.scene.Node;
import javafx.geometry.HPos;
import javafx.geometry.VPos;
import javafx.scene.input.MouseEvent;
import javafx.scene.paint.Paint;
import javafx.scene.shape.Rectangle;
import org.jfxtras.scene.layout.XContainer;
import org.jfxtras.scene.control.renderer.NodeRenderer;
import javafx.scene.layout.LayoutInfo;

/**
 * @author Stephen Chin
 */
public class XTableCell extends XContainer {
    public var skin:XTableSkin;
    public var backgroundFill:Paint;
    public var backgroundOpacity:Number = 1;
    public var node:Node;
    public var index:Integer;
    public var renderer:NodeRenderer;
    public var onBackgroundPressed:function(e:MouseEvent, index:Integer);
    public var onBackgroundDragged:function(e:MouseEvent, index:Integer);
    public var onBackgroundReleased:function(e:MouseEvent, index:Integer);
    public var onBackgroundClicked:function(e:MouseEvent, index:Integer);
    public function recycleNode() {
        renderer.recycleNode(node);
    }
    def background = Rectangle {
        fill: bind backgroundFill
        opacity: bind backgroundOpacity;
        onMousePressed: function(e) {
            onBackgroundPressed(e, index);
        }
        onMouseDragged: function(e) {
            onBackgroundDragged(e, index);
        }
        onMouseReleased: function(e) {
            onBackgroundReleased(e, index);
        }
        onMouseClicked: function(e) {
            onBackgroundClicked(e, index);
        }
    }
    override var content = bind [background, node];
    override var clip = Rectangle {width: bind width, height: bind height}
    override function doLayout() {
        def leftPad = skin.table.getLeftPad();
        def topPad = skin.table.getTopPad();
        def rightPad = skin.table.getRightPad();
        def bottomPad = skin.table.getBottomPad();
        layoutNode(node, leftPad, topPad, width - leftPad - rightPad, height - topPad - bottomPad, HPos.LEFT, VPos.TOP);
        background.width = width;
        background.height = height;
    }
}
