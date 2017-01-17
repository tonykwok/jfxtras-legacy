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

import javafx.geometry.HPos;
import javafx.geometry.VPos;
import javafx.scene.Node;
import javafx.scene.control.Skin;
import javafx.scene.input.KeyEvent;
import javafx.scene.input.MouseEvent;
import javafx.scene.layout.Container;
import javafx.scene.layout.Panel;
import javafx.scene.paint.Color;
import javafx.scene.paint.Paint;
import javafx.scene.shape.Rectangle;
import javafx.util.Math;
import org.jfxtras.lang.XBind;
import org.jfxtras.scene.control.skin.AbstractSkin;

/**
 * @author jimclarke
 */
public class XTreeNodeSkin extends AbstractSkin  {

    var treeNode:XTreeNode = bind control as XTreeNode;
    var treeSkin = bind treeNode.tree.skin as XTreeSkin;

    var initted = false;

    protected override function getMinWidth():Number {
        if(treeNode != null) {
            treeNode.minimumWidth;
        }else {
            500.0;
        }
    }
    public override function getPrefHeight(h: Number) : Number {
        var tmp = tree.getTopPad() + tree.getBottomPad() + Math.max(expandedGraphic.layoutBounds.height, displayNode.layoutBounds.height);
        Math.max(tmp, 14.0);
    }
    public override function getPrefWidth(w: Number) : Number {
        preferredWidth = tree.getLeftPad() + tree.getRightPad() + Math.max(getMinWidth(),
            displayNode.layoutBounds.width + expandedGraphic.layoutBounds.width + spacing);
    }



    /**
     * The tree
    */
    var tree: XTreeView  = bind treeNode.tree on replace {
        if(initted and tree != null) {
            if(not isInitialized(collapsedGraphic))
                collapsedGraphic = tree.getCollapsedGraphic();
            if(not isInitialized(expandedGraphic))
                expandedGraphic = tree.getExpandedGraphic();
        }
    }

    /*
    * This display node
    */
    var displayNode: Node;


    var twidth = bind tree.width on replace {
        getPrefWidth(-1);
        createDisplayNode();
    }

    
    /**
     * Set the displayNode from the item
    */
    var index = bind treeNode.index on replace {
        createDisplayNode();
    }

    var item = bind treeNode.item on replace {
        createDisplayNode();
    }

    var renderer = bind treeNode.renderer on replace {
        createDisplayNode();
    }

    var panel: Panel;

    function createDisplayNode():Void {
        if (item != null) {
            if (item instanceof Node) {
                displayNode = item as Node;
            }
            else {
                displayNode = treeNode.renderer.createNode(XBind {ref: item}, index, false, Math.max(tree.width, getMinWidth()), getPrefHeight(-1));
            } 
            //var grp = node as Group;
            treeNode.width = getPrefWidth(-1);
            treeNode.height = getPrefHeight(-1);
            panel.requestLayout();
        }
    }







    /** the graphic to use for a collapsed node */
    public var collapsedGraphic: Node;

    /** the graphic to use for an expaned node */
    public var expandedGraphic: Node;

    public var pressedColor: Paint = bind treeSkin.baseColor;


    var currentGraphic: Node = bind if(treeNode.leaf) null 
        else if (treeNode.expanded) expandedGraphic else collapsedGraphic ;

    override function toString() : String {
        "Skin {treeNode}"

    }

    var preferredWidth = getPrefWidth(-1);



    postinit {
        initted = true;
    }

    // Horizontal spacing betweend collapse/expand area and the display node
    public var spacing = 5.0;

    var backgroundFill: Paint = bind treeNode.backgroundFill;

    init {
        if(tree != null) {
            if(not isInitialized(collapsedGraphic))
                collapsedGraphic = tree.getCollapsedGraphic();
            if(not isInitialized(expandedGraphic))
                expandedGraphic = tree.getExpandedGraphic();
        }
        node = Panel {
            visible: bind treeNode.visible
            onLayout: function() {
                panel.layoutX = tree.getLeftPad() + treeNode.indent;
                panel.layoutY = tree.getTopPad();
            }
            var backgroundRect: Rectangle;
            content: [
                backgroundRect = Rectangle { // Background
                    width: bind Math.max(preferredWidth, tree.width)
                    height: bind treeNode.height
                    fill: bind backgroundFill
                    onMouseClicked: function(e:MouseEvent) {
                        if(tree.isSelectionEvent(treeNode, e)) {
                            treeNode.selected = not treeNode.selected;
                            if(treeNode.selected and tree.isInterestedInKeyEvents())
                                backgroundRect.requestFocus();
                        }
                        tree.onMouseClickedNode(treeNode, e);
                    }
                    onMouseDragged:function(e:MouseEvent) {
                        tree.onMouseDraggedNode(treeNode, e);
                    }
                    onMouseEntered:function(e:MouseEvent) {
                        tree.onMouseDraggedNode(treeNode, e);
                    }
                    onMouseExited:function(e:MouseEvent) {
                        tree.onMouseEnteredNode(treeNode, e);
                    }
                    onMouseMoved:function(e:MouseEvent) {
                        tree.onMouseMovedNode(treeNode, e);
                    }
                    onMousePressed:function(e:MouseEvent) {
                        tree.onMousePressedNode(treeNode, e);
                    }
                    onMouseReleased:function(e:MouseEvent) {
                        tree.onMouseReleasedNode(treeNode, e);
                    }
                    onMouseWheelMoved:function(e:MouseEvent) {
                        tree.onMouseWheelMovedNode(treeNode, e);
                    }
                    onKeyReleased: function(e: KeyEvent) {
                        tree.onKeyReleasedNode(treeNode, e);
                    }
                    onKeyPressed: function(e: KeyEvent) {
                        tree.onKeyPressedNode(treeNode, e);
                    }
                    onKeyTyped: function(e: KeyEvent) {
                        tree.onKeyTypedNode(treeNode, e);
                    }
                }
                panel = Panel {
                            var side = bind treeNode.height - tree.getTopPad() - tree.getBottomPad();
                            var collapseRect:Rectangle = Rectangle {
                                    width: bind side+4
                                    height: bind side
                                    blocksMouse: bind currentGraphic != null
                                    fill: bind if(not treeNode.leaf and collapseRect.pressed)
                                            pressedColor else Color.TRANSPARENT
                                    onMouseClicked: function(e) {
                                       if(not treeNode.leaf) {
                                          treeNode.expanded = not treeNode.expanded;
                                       }
                                    }
                                };
                            onLayout: function() {
                                Container.layoutNode(collapseRect, 0, 0, collapseRect.width, collapseRect.height,
                                    HPos.CENTER, VPos.CENTER);
                                Container.layoutNode(currentGraphic, 0, 0, collapseRect.width, collapseRect.height,
                                    HPos.CENTER, VPos.CENTER);
                                var mx = collapseRect.width + spacing;
                                Container.layoutNode(displayNode, mx, 0, backgroundRect.width - mx, collapseRect.height,
                                    HPos.LEFT, VPos.CENTER);

                            }

                            content: bind [
                                collapseRect,
                                currentGraphic,
                                displayNode
                            ]
                }
            ]
        }
    }
}
