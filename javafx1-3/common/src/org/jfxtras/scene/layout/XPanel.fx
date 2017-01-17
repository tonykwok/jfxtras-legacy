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
package org.jfxtras.scene.layout;

import javafx.scene.layout.Panel;
import javafx.util.Sequences;
import org.jfxtras.util.SequenceUtil;

/**
 * An extension to the Panel class that trickles up resizable defaults from its child
 * nodes.
 *
 * @author Stephen Chin
 */
public class XPanel extends Panel {
    override var prefWidth = function(height) {
        if (sizeof children == 0) return 0;
        Sequences.max(for (child in children) XContainer.getNodePrefWidth(child, height)) as Number;
    }

    override var prefHeight = function(width) {
        if (sizeof children == 0) return 0;
        Sequences.max(for (child in children) XContainer.getNodePrefHeight(child, width)) as Number;
    }

    override var minWidth = function() {
        if (sizeof children == 0) return 0;
        Sequences.max(for (child in children) XContainer.getNodeMinWidth(child)) as Number;
    }

    override var minHeight = function() {
        if (sizeof children == 0) return 0;
        Sequences.max(for (child in children) XContainer.getNodeMinHeight(child)) as Number;
    }

    override var maxWidth = function() {
        if (sizeof children == 0) return 0;
        Sequences.max(for (child in children) XContainer.getNodeMaxWidth(child)) as Number;
    }

    override var maxHeight = function() {
        if (sizeof children == 0) return 0;
        Sequences.max(for (child in children) XContainer.getNodeMaxHeight(child)) as Number;
    }

    override function getHFill() {
        SequenceUtil.any(for (child in children where child.managed) XContainer.getNodeHFill(child));
    }

    override function getVFill() {
        SequenceUtil.any(for (child in children where child.managed) XContainer.getNodeVFill(child));
    }

    override function getHGrow() {
        XContainer.maxPriority(for (child in children where child.managed) XContainer.getNodeHGrow(child));
    }

    override function getVGrow() {
        XContainer.maxPriority(for (child in children where child.managed) XContainer.getNodeVGrow(child));
    }

    override function getHShrink() {
        XContainer.minPriority(for (child in children where child.managed) XContainer.getNodeHShrink(child));
    }

    override function getVShrink() {
        XContainer.minPriority(for (child in children where child.managed) XContainer.getNodeVShrink(child));
    }
}
