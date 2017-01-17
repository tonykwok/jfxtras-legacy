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
package org.jfxtras.scene.control.renderer;

import javafx.scene.Node;
import javafx.scene.paint.Color;
import javafx.scene.paint.Paint;
import javafx.scene.text.Font;
import javafx.scene.control.TextBox;
import org.jfxtras.lang.XBind;

/**
 * @author Stephen Chin
 */
public class TextRenderer extends CachingNodeRenderer {
    public var font:Font = Font.DEFAULT;
    public var fill:Paint = Color.BLACK;
    public var selectedFont:Font;
    public var selectedFill:Paint;

    override function createNode():Node {
        var node = SelectableText {
            defaultFill: fill
            defaultFont: font
            selectedFill: selectedFill
            selectedFont: selectedFont
        }
        mostRecentNodeRendered = node;
        return node;
    }

    override function createEditableNode():Node {
        EditableTextBox {}
    }

    override function isEditable(node:Node):Boolean {node instanceof EditableTextBox}

    // todo - make XCell a first class citizen returned by renderers
    // XCell would have on it: editing, selected, backgroundNode, foregroundNode, data:XBind, layout funk (height/width/layoutInfo/margin)
    // keep renderer idea...  but mainly use it as a factory
    // move caching into a common area per cell type, and rewrite all defaults on creation
    override function populateNode(node:Node, data:XBind, index:Integer, width:Number, height:Number):Void {
        def text = node as SelectableText;
        text.data = data;
    }

    // todo - this is where the editing comes in...  need to wrap the TextBox somehow
    override function populateEditableNode(node:Node, data:XBind, index:Integer, width:Number, height:Number):Void {
        def text = node as EditableTextBox;
        text.data = data;
    }
}

class EditableTextBox extends TextBox {
    public var data:XBind on replace {
        text = data.ref as String;
        data.addListener(function(o, n):Void {text = n as String});
    }

    override var text on replace {
        data.ref = text;
    }
}
