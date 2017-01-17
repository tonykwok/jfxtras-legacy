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
import org.jfxtras.lang.XBind;
import org.jfxtras.lang.XException;

/**
 * @author Stephen Chin
 */
public abstract class CachingNodeRenderer extends NodeRenderer {
    protected var maxSize:Integer = 100;
    var cache:Node[];
    var editableCache:Node[];

    public function getNode(editable:Boolean):Node {
        // todo - get rid of copy/paste code here
        if (editable) {
            if (sizeof editableCache > 0) {
                def node = editableCache[sizeof editableCache - 1];
                delete editableCache[sizeof editableCache - 1];
                return node;
            } else {
                return createEditableNode();
            }
        } else {
            if (sizeof cache > 0) {
                def node = cache[sizeof cache - 1];
                delete cache[sizeof cache - 1];
                return node;
            } else {
                return createNode();
            }
        }
    }

    override function createNode(data:XBind, index:Integer, editable:Boolean, width:Number, height:Number):Node {
        var node = getNode(editable);
        if (editable) {
            populateEditableNode(node, data, index, width, height);
        } else {
            populateNode(node, data, index, width, height);
        }
        return node;
    }

    override function recycleNode(node:Node):Void {
        // todo - get rid of copy/paste code here
        if (isEditable(node)) {
            if (sizeof editableCache >= maxSize) {
                delete editableCache[0];
            }
            insert node into editableCache;
        } else {
            if (sizeof cache >= maxSize) {
                delete cache[0];
            }
            insert node into cache;
        }
    }


    protected abstract function createNode():Node;

    protected function createEditableNode():Node {throw XException {message: "Renderer doesn't support editing"}}

    protected function isEditable(node:Node):Boolean {false}

    protected abstract function populateNode(node:Node, data:XBind, index:Integer, width:Number, height:Number):Void;

    protected function populateEditableNode(node:Node, data:XBind, index:Integer, width:Number, height:Number):Void {throw XException {message: "Renderer doesn't support editing"}}
}
