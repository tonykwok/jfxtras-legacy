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
import javafx.scene.image.ImageView;
import org.jfxtras.lang.XBind;
import org.jfxtras.lang.XException;
import org.jfxtras.scene.image.ImageUtil;

/**
 * @author Stephen Chin
 */
public class StringAutoRenderer extends CachingNodeRenderer {
    public var textRenderer = TextRenderer {}

    public var imageRenderer = ImageRenderer {}

    override function createNode(data:XBind, index:Integer, editable:Boolean, width:Number, height:Number):Node {
        var renderer = chooseRenderer(data);
        return renderer.createNode(data, index, editable, width, height);
    }

    function chooseRenderer(data:XBind):NodeRenderer {
        var content = data.ref as String;
        if ((content.startsWith("http://") or content.startsWith("https://") or content.startsWith("file:/") or content.startsWith("jar:http:/") or content.startsWith("jar:https:/") or content.startsWith("jar:file:/")) and ImageUtil.imageTypeSupported(content)) {
            return imageRenderer;
        } else {
            return textRenderer;
        }
    }

    override function recycleNode(node:Node):Void {
        if (node instanceof ImageView) {
            imageRenderer.recycleNode(node);
        } else if (node instanceof SelectableText) {
            textRenderer.recycleNode(node);
        } else {
            println("WARNING: Unknown node type, cannot recycle.")
        }
    }

    override function createNode():Node {
        throw XException {message: "createNode should never get called on auto renderers"}
    }

    override function populateNode(node:Node, data:XBind, index:Integer, width:Number, height:Number):Void {
        throw XException {message: "populateNode should never get called on auto renderers"}
    }
}
