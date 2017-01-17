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
package org.jfxtras.scene.border;

import javafx.geometry.BoundingBox;
import javafx.geometry.HPos;
import javafx.geometry.VPos;
import javafx.scene.Node;
import javafx.scene.layout.Resizable;
import javafx.scene.paint.Color;
import org.jfxtras.scene.XCustomNode;
import org.jfxtras.scene.layout.XContainer;
import org.jfxtras.scene.layout.XPanel;
import org.jfxtras.scene.shape.ResizableRectangle;
import javafx.scene.paint.Paint;

// Work around for JFXC-3300
class BorderPanel extends XPanel {
    var border: XBorder;
    override var width on replace {
        border.updateNodeBounds();
    }
    override var height on replace {
        border.updateNodeBounds();
    }
}

/**
 * @author jclarke
 * @author Stephen Chin
 */
public abstract class XBorder extends XCustomNode {
    
    protected var panel:XPanel;

    /**
     * The horizontal position of the node within the border's width.
     * This may be overridden for individual nodes by setting the {@code hpos}
     * variable on the node's {@code layoutInfo} variable.
     *
     * @profile common
     * @defaultvalue HPos.CENTER
     */
    public var nodeHPos:HPos = HPos.CENTER on replace {
        requestLayout();
    }

    /**
     * The vertical position of the node within the border's height.
     * This may be overridden for individual nodes by setting the {@code vpos}
     * variable on the node's {@code layoutInfo} variable.
     *
     * @profile common
     * @defaultvalue VPos.CENTER
     */
    public var nodeVPos:VPos = VPos.CENTER on replace {
        requestLayout();
    }
    
    /**
     * Indicates that the Border will be resized to fit
     * the size of the contained node.
     */
    public var shapeToFit = true on replace { requestLayout(); }

    /**
     * defines the base color
     */
    public var base:Color = Color.web("#D0D0D0");

    /**
     * defines the accent color
     */
    public var accent:Color = Color.web("#0093FF");

    /**
     * Defines the top height of the border
     *
     * @defaultvalue 0
     * @css border-top-width
     */
    public var borderTopWidth: Number on replace { requestLayout(); }

    /**
     * Defines the left width of the border
     *
     * @defaultvalue 0
     * @css border-left-width
     */
    public var borderLeftWidth: Number on replace { requestLayout(); }

    /**
     * Defines the bottom height of the border
     *
     * @defaultvalue 0
     * @css border-bottom-width
     */
    public var borderBottomWidth: Number on replace { requestLayout(); }

    /**
     * Defines the rigth width of the border
     *
     * @defaultvalue 0
     * @css border-right-width
     */
    public var borderRightWidth: Number on replace { requestLayout(); }

    /**
     * Background fill for the border, if the border widths are not zero,
     * this color will be used to fill the uncovered areas.
     * @defaultvalue transparent
     * @css background-fill
     */
    public var backgroundFill : Paint = Color.TRANSPARENT on replace { requestLayout(); }

    /**
     * Node that is contained within the border.
     */
    public var node:Node on replace { requestLayout(); }

    /**
     * The border
     */
    protected var border:Node on replace { requestLayout(); }

    protected var background:Node = ResizableRectangle {
        fill: bind backgroundFill
    } on replace {
        requestLayout();
    }

    init {
        width = XContainer.getNodePrefWidth(this);
        height = XContainer.getNodePrefHeight(this);
    }

    override var layoutInfo = bind node.layoutInfo;

    override var layoutBounds = bind lazy if (shapeToFit) BoundingBox {
        def box = node.layoutBounds;
        minX: node.layoutX + box.minX - borderLeftWidth;
        minY: node.layoutY + box.minY - borderTopWidth;
        width: box.width + borderLeftWidth + borderRightWidth;
        height: box.height + borderTopWidth + borderBottomWidth;
    } else BoundingBox {
        width: width
        height: height
    }

    override function create():Node {
        panel = BorderPanel {
            border: bind this
            minWidth: function():Number {
                XContainer.getNodeMinWidth(node) + borderLeftWidth + borderRightWidth;
            }
            minHeight: function():Number {
                XContainer.getNodeMinHeight(node) + borderTopWidth + borderBottomWidth;
            }
            maxWidth: function():Number {
                XContainer.getNodeMaxWidth(node) + borderLeftWidth + borderRightWidth;
            }
            maxHeight: function():Number {
                XContainer.getNodeMaxHeight(node) + borderTopWidth + borderBottomWidth;
            }
            prefWidth: function(width:Number):Number {
                XContainer.getNodePrefWidth(node) + borderLeftWidth + borderRightWidth;
            }
            prefHeight: function(height:Number):Number {
                XContainer.getNodePrefHeight(node) + borderTopWidth + borderBottomWidth;
            }
            /** Work Around for JXFC-3300
            override var width on replace {
                updateNodeBounds();
            }
            override var height on replace {
                updateNodeBounds();
            }
            **/
            content: bind  [
                background,
                node,
                border
            ]
            onLayout: borderLayout
        }
    }

    protected abstract function doBorderLayout(x:Number, y:Number, width:Number, height:Number):Void;

    function borderLayout():Void  {
        XContainer.layoutNode(background, 0, 0, width, height);
        updateNodeBounds();
        if (shapeToFit) {
            def box = node.layoutBounds;
            def boxX = box.minX - borderLeftWidth + node.layoutX;
            def boxY = box.minY - borderTopWidth + node.layoutY;
            def boxWidth = box.width + borderLeftWidth + borderRightWidth;
            def boxHeight = box.height + borderTopWidth + borderBottomWidth;
            doBorderLayout(boxX, boxY, boxWidth, boxHeight);
            XContainer.layoutNode(background, boxX, boxY, boxWidth, boxHeight);
        } else {
            doBorderLayout(0, 0, width, height);
            XContainer.resizeNode(background, width, height);
        }
    }

    function updateNodeBounds() {
        if (node.managed){
            XContainer.layoutNode(node, borderLeftWidth, borderTopWidth,
                width - borderLeftWidth - borderRightWidth,
                height - borderTopWidth - borderBottomWidth,
                nodeHPos, nodeVPos);
        }
    }
}
