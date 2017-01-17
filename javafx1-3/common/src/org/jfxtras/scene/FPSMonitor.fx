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
package org.jfxtras.scene;

import javafx.scene.Node;
import javafx.scene.text.Text;
import javafx.scene.text.TextOrigin;
import org.jfxtras.scene.layout.XContainer;
import org.jfxtras.scene.layout.XPanel;

/**
 * @author Keith Combs
 * @author Stephen Chin
 */
public class FPSMonitor extends XCustomNode {
    public-init var node:Node;

    public var window = 500ms;

    var fps:Number;

    var timestamps:Long[];

    override var layoutInfo = bind node.layoutInfo;

    override function create() {
        return XPanel {
            minWidth: function():Number {
                XContainer.getNodeMinWidth(node)
            }
            minHeight: function():Number {
                XContainer.getNodeMinHeight(node)
            }
            maxWidth: function():Number {
                XContainer.getNodeMaxWidth(node)
            }
            maxHeight: function():Number {
                XContainer.getNodeMaxHeight(node)
            }
            prefWidth: function(width:Number):Number {
                XContainer.getNodePrefWidth(node)
            }
            prefHeight: function(height:Number):Number {
                XContainer.getNodePrefHeight(node)
            }
            width: bind width
            height: bind height
            content: [
                node,
                Text {
                    content: bind "{fps}"
                    textOrigin: TextOrigin.TOP
                }
            ]
            onLayout: function() {
                def now = java.lang.System.currentTimeMillis();
                insert now into timestamps;
                fps = calculateFPS(now);
                XContainer.resizeNode(node, width, height);
                FX.deferAction((children[0] as XPanel).requestLayout);
            }
        }
    }

    function calculateFPS(now:Long):Number {
        for (time in timestamps) {
            if (time < now - window.toMillis()) {
                delete timestamps[indexof time]
            }
        }
        return (1000.0 * sizeof timestamps) / window.toMillis();
    }
}
