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

import javafx.geometry.BoundingBox;
import javafx.scene.CustomNode;
import javafx.scene.layout.Resizable;
import javafx.util.Sequences;
import org.jfxtras.scene.layout.XContainer;
import org.jfxtras.util.SequenceUtil;
import javafx.geometry.HPos;
import javafx.geometry.VPos;

/**
 * An extension of CustomNode that is designed to work in layout containers.
 * It delegates all the methods of Resizable to the Node returned from create,
 * allowing the use of CustomNode to instantiate Resizable objects cleanly.
 *
 * @profile desktop
 *
 * @author Stephen Chin
 */
public abstract class XCustomNode extends CustomNode, Resizable {
    override var layoutBounds = bind lazy BoundingBox {
        width: width
        height: height
    }

    override var width on replace {requestLayout()}
    override var height on replace {requestLayout()}

    override function getPrefWidth(height) {
        if (sizeof children == 0) return 0;
        Sequences.max(for (child in children) XContainer.getNodePrefWidth(child, height)) as Number;
    }

    override function getPrefHeight(width) {
        if (sizeof children == 0) return 0;
        Sequences.max(for (child in children) XContainer.getNodePrefHeight(child, width)) as Number;
    }

    override function getMinWidth() {
        if (sizeof children == 0) return 0;
        Sequences.max(for (child in children) XContainer.getNodeMinWidth(child)) as Number;
    }

    override function getMinHeight() {
        if (sizeof children == 0) return 0;
        Sequences.max(for (child in children) XContainer.getNodeMinHeight(child)) as Number;
    }

    override function getMaxWidth() {
        if (sizeof children == 0) return 0;
        Sequences.max(for (child in children) XContainer.getNodeMaxWidth(child)) as Number;
    }

    override function getMaxHeight() {
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

    // Override the automatic resize behavior so the Resizable semantics work
    // better for subclasses.
    override function doLayout() {
        for (child in children where child.managed) {
            XContainer.layoutNode(child, 0, 0, width, height, HPos.CENTER, VPos.CENTER);
        }
    }
}
