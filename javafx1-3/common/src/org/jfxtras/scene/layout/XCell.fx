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

import javafx.geometry.HPos;
import javafx.geometry.VPos;
import javafx.scene.Node;
import javafx.scene.CustomNode;
import javafx.scene.layout.Priority;
import javafx.scene.layout.Resizable;

/**
 * Wrapper for a Node that is placed inside a {@link Grid}.  This provides
 * additional control over how the Node is positioned and oriented in the
 * Grid including alignment, span, grow, and the ability to override Resizable
 * properties.
 *
 * @profile desktop
 *
 * @author Stephen Chin
 * @author Keith Combs
 */
public class XCell extends CustomNode, Resizable {
    /**
     * The content of this Cell will be constrained by the constraint variables when
     * placed inside a {@link Grid}.
     */
    public-init var content:Node;

    // hack - workaround for RT-4524
    override var layoutBounds = bind content.layoutBounds;

    override var layoutInfo = XGridLayoutInfo {}

    /**
     * If set, will define how the node should be horizontally positioned within its allocated layout space.
     */
    public var hpos:HPos on replace {
        if (isInitialized(hpos)) {
            (layoutInfo as XGridLayoutInfo).hpos = hpos
        }
    }

    /**
     * If set, will define how the node should be vertically positioned within its allocated layout space.
     */
    public var vpos:VPos on replace {
        if (isInitialized(vpos)) {
            (layoutInfo as XGridLayoutInfo).vpos = vpos
        }
    }

    /**
     * Overrides the preferred height of the Node.
     */
    public var prefHeight:Number on replace {
        if (isInitialized(prefHeight)) {
            (layoutInfo as XGridLayoutInfo).height = prefHeight
        }
    }

    /**
     * Overrides the preferred width of the Node.
     */
    public var prefWidth:Number on replace {
        if (isInitialized(prefWidth)) {
            (layoutInfo as XGridLayoutInfo).width = prefWidth
        }
    }

    /**
     * Overrides the minimum height of the Node.
     */
    public var minHeight:Number on replace {
        if (isInitialized(minHeight)) {
            (layoutInfo as XGridLayoutInfo).minHeight = minHeight
        }
    }

    /**
     * Overrides the minimum width of the Node.
     */
    public var minWidth:Number on replace {
        if (isInitialized(minWidth)) {
            (layoutInfo as XGridLayoutInfo).minWidth = minWidth
        }
    }

    /**
     * Overrides the maximum height of the Node.
     */
    public var maxHeight:Number on replace {
        if (isInitialized(maxHeight)) {
            (layoutInfo as XGridLayoutInfo).maxHeight = maxHeight
        }
    }

    /**
     * Overrides the maximum width of the Node.
     */
    public var maxWidth:Number on replace {
        if (isInitialized(maxWidth)) {
            (layoutInfo as XGridLayoutInfo).maxWidth = maxWidth
        }
    }

    /**
     * If set, will cause the Node to take all available space in the
     * horizontal direction.
     */
    public var hfill:Boolean on replace {
        if (isInitialized(hfill)) {
            (layoutInfo as XGridLayoutInfo).hfill = hfill
        }
    }

    /**
     * If set, will cause the Node to take all available space in the
     * vertical direction.
     */
    public var vfill:Boolean on replace {
        if (isInitialized(vfill)) {
            (layoutInfo as XGridLayoutInfo).vfill = vfill
        }
    }

    /**
    * The number of columns that this Node will span.
     */
    public var hspan:Integer on replace {
        if (isInitialized(hspan)) {
            (layoutInfo as XGridLayoutInfo).hspan = hspan
        }
    }

    /**
    * The number of rows that this Node will span.
     */
    public var vspan:Integer on replace {
        if (isInitialized(vspan)) {
            (layoutInfo as XGridLayoutInfo).vspan = vspan
        }
    }

    /**
    * The priority for allocating unused space in the Grid.  Components with
     * the same horizontalGrow value will receive an equal portion of the Grid.
     * <p>
     * If unset this value will default to:
     * {@link GridConstraints.NEVER}
     * <p>
     * Note that extra space is first allocated to the Grid columnPercentages.
     */
    public var hgrow:Priority on replace {
        if (isInitialized(hgrow)) {
            (layoutInfo as XGridLayoutInfo).hgrow = hgrow
        }
    }

    /**
    * The priority for allocating unused space in the Grid.  Components with
     * the same verticalGrow value will receive an equal portion of the Grid.
     * <p>
     * If unset this value will default to:
     * {@link GridConstraints.NEVER}
     * <p>
     * Note that extra space is first allocated to the Grid columnPercentages.
     */
    public var vgrow:Priority on replace {
        if (isInitialized(vgrow)) {
            (layoutInfo as XGridLayoutInfo).vgrow = vgrow
        }
    }

    override function create() {
        return content;
    }

    override var width on replace {
        if (isInitialized(width)) {
            XContainer.setNodeWidth(content, width);
        }
    }

    override var height on replace {
        if (isInitialized(height)) {
            XContainer.setNodeHeight(content, height);
        }
    }

    override function getPrefWidth(height) {
        XContainer.getNodePrefWidth(content, height);
    }

    override function getPrefHeight(width) {
        XContainer.getNodePrefHeight(content, width);
    }

    override function getMinWidth() {
        XContainer.getNodeMinWidth(content);
    }

    override function getMinHeight() {
        XContainer.getNodeMinHeight(content);
    }

    override function getMaxWidth() {
        XContainer.getNodeMaxWidth(content);
    }

    override function getMaxHeight() {
        XContainer.getNodeMaxHeight(content);
    }
    
    override function getHFill() {
        XContainer.getNodeHFill(content);
    }

    override function getVFill() {
        XContainer.getNodeVFill(content);
    }

    override function getHGrow() {
        XContainer.getNodeHGrow(content);
    }

    override function getVGrow() {
        XContainer.getNodeVGrow(content);
    }

    override function getHShrink() {
        XContainer.getNodeHGrow(content);
    }

    override function getVShrink() {
        XContainer.getNodeVGrow(content);
    }

    override function toString() {
        "Cell \{content={content}, layoutInfo={layoutInfo}\}"
    }
}
