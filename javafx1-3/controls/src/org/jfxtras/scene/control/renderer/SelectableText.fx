/**
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

/*
 * SelectableText.fx
 *
 * Created on Aug 16, 2009, 2:49:14 AM
 */

package org.jfxtras.scene.control.renderer;

import javafx.scene.paint.Color;
import javafx.scene.paint.Paint;
import javafx.scene.text.Font;
import javafx.scene.text.Text;
import org.jfxtras.lang.XBind;
import org.jfxtras.scene.XCustomNode;
import org.jfxtras.scene.layout.XLayoutInfo;
import org.jfxtras.scene.layout.XLayoutInfo.*;
import javafx.scene.layout.LayoutInfo;

/**
 * @author Stephen Chin
 */
public class SelectableText extends XCustomNode, Selectable, Recyclable {
    public var data:XBind on replace {
        content = data.ref.toString();
        data.addListener(function(o, n):Void {content = n.toString()});
    }
    public var content:String;
    public var defaultFont:Font = Font.DEFAULT;
    public var defaultFill:Paint = Color.BLACK;
    public var selectedFont:Font;
    public var selectedFill:Paint;

    var text:Text;

    override public function getMinWidth() {0}
    override public function getMinHeight() {0}
    override public function getPrefWidth(height) {text.boundsInLocal.width}
    override public function getPrefHeight(width) {text.boundsInLocal.height}
    override public function getMaxWidth() {Integer.MAX_VALUE}
    override public function getMaxHeight() {Integer.MAX_VALUE}
    override public function getHFill() {true}
    override public function getVFill() {true}
    override public function getHGrow() {ALWAYS}

    override function create() {
        text = Text {
            content: bind content
            font: bind if (selected and selectedFont != null) selectedFont else defaultFont
            fill: bind if (selected and selectedFill != null) selectedFill else defaultFill
            wrappingWidth: bind width
            layoutInfo: LayoutInfo {vpos: TOP}
        }
    }
}
