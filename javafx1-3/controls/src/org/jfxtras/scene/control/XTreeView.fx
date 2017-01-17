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

import javafx.scene.control.Control;
import javafx.scene.Node;
import javafx.scene.paint.Color;
import javafx.reflect.FXContext;
import org.jfxtras.scene.control.renderer.StringAutoRenderer;
import org.jfxtras.scene.control.renderer.TextRenderer;
import org.jfxtras.scene.control.renderer.FileRenderer;
import org.jfxtras.scene.control.data.DefaultTreeDataDescriptor;
import org.jfxtras.scene.control.data.TreeDataDescriptor;
import org.jfxtras.util.XMap;
import org.jfxtras.scene.shape.ETriangle;
import org.jfxtras.scene.control.data.DataProvider;
import javafx.scene.input.MouseEvent;
import javafx.scene.input.KeyEvent;
import javafx.scene.input.MouseButton;
import java.lang.Class;

import org.jfxtras.scene.control.renderer.NodeRenderer;


import javafx.reflect.FXType;

import javafx.reflect.FXLocal;


/**
 * Reppresents a Tree control
 *
 * @author jimclarke
 */

public class XTreeView extends Control {
    var treeSkin = bind skin as XTreeSkin;
    def context = FXContext.getInstance();
    package var defaultRenderers:XMap = XMap {

        entries: [
            XMap.Entry {
                key: context.getStringType()
                value: StringAutoRenderer {
                    textRenderer: TextRenderer {
                        font: bind treeSkin.font
                        fill: bind treeSkin.textColor
                        selectedFill: bind treeSkin.lightTextColor
                    }
                }
            }
            XMap.Entry {
                key: context.getIntegerType()
                value: TextRenderer {
                    font: bind treeSkin.font
                    fill: Color.DARKBLUE
                    selectedFill: bind treeSkin.lightTextColor
                }
            }
            XMap.Entry {
                key: context.findClass("java.io.File");
                value: FileRenderer {
                    font: bind treeSkin.font
                    fill: Color.DARKBLUE
                    selectedFill: bind treeSkin.lightTextColor
                }

            }

        ]
    }

    /**
     * Add a custom renderer
     *
     * @param class the class to map to the renderer
     * @param renderer the renderer
     *
     */
    public function addRenderer( clazz: Class, renderer: NodeRenderer) : Void {
        addRenderer((context as FXLocal.Context).makeClassRef(clazz), renderer);
    }

    /**
     * Add a custom renderer
     *
     * @param type the FXType to map to the renderer
     * @param renderer the renderer
     *
     */
    public function addRenderer(type: FXType, renderer: NodeRenderer) : Void {
        defaultRenderers.put(type, renderer);
        treeSkin.root.setAllRenderers();
    }

    /**
     * remove a custom renderer
     *
     * @param class the class that maps to the renderer
     *
     */
    public function removeRenderer( clazz: Class) : Void {
        removeRenderer((context as FXLocal.Context).makeClassRef(clazz));
    }

    /**
     * remove a custom renderer
     *
     * @param type the FXType that maps to the renderer
     *
     */
    public function removeRenderer( type: FXType) : Void {
        defaultRenderers.remove(type);
        treeSkin.root.setAllRenderers();
    }

    /**
     * Function called when tree node is selected
    */
    public var onSelection: function(node: XTreeNode) : Void;

    /**
     * Function called when tree node is expanded
    */
    public var onExpand: function(node: XTreeNode) : Void;

    /**
     * Function called when tree node is collapsed
    */
    public var onCollapse: function(node: XTreeNode) : Void;

    /**
     * Function to determine if a mouse event represents a selection event.
     * Default behavior is primaryButtonDown and clickCount <= 1
    */
    public var isSelectionEvent: function(node: XTreeNode, e:MouseEvent) : Boolean  =
        function (node: XTreeNode, e:MouseEvent) : Boolean {
           e.button == MouseButton.PRIMARY and e.clickCount <= 1;
    }


    /**
     * Defines a function to be called when the mouse enters a {@code XTreeNode}.
    */
    public var onMouseEnteredNode: function(node: XTreeNode, event: MouseEvent): Void;
    /**
     * Defines a function to be called when the mouse exits a {@code XTreeNode}.
    */
    public var onMouseExitedNode: function(node: XTreeNode, event: MouseEvent): Void;
    /**
     * Defines a function to be called when the mouse clicks on a {@code XTreeNode}.
    */
    public var onMouseClickedNode: function(node: XTreeNode, event: MouseEvent): Void;
    /**
     * Defines a function to be called when the mouse drags a {@code XTreeNode}.
    */
    public var onMouseDraggedNode: function(node: XTreeNode, event: MouseEvent): Void;
    /**
     * Defines a function to be called when the mouse moves while on a {@code XTreeNode}.
    */
    public var onMouseMovedNode: function(node: XTreeNode, event: MouseEvent): Void;
    /**
     * Defines a function to be called when the mouse is pressed on a {@code XTreeNode}.
    */
    public var onMousePressedNode: function(node: XTreeNode, event: MouseEvent): Void;
    /**
     * Defines a function to be called when the mouse si released on a {@code XTreeNode}.
    */
    public var onMouseReleasedNode: function(node: XTreeNode, event: MouseEvent): Void;
    /**
     * Defines a function to be called when the mouse wheel is moved over a {@code XTreeNode}.
    */
    public var onMouseWheelMovedNode: function(node: XTreeNode, event: MouseEvent): Void;
    /**
     * Defines a function to be called when a key is pressed on a {@code XTreeNode}.
    */
    public var onKeyPressedNode: function(node: XTreeNode, event: KeyEvent ) : Void;
    /**
     * Defines a function to be called when a key is released on  a {@code XTreeNode}.
    */
    public var onKeyReleasedNode: function(node: XTreeNode, event: KeyEvent ) : Void;
    /**
     * Defines a function to be called when a key is typed on a {@code XTreeNode}.
    */
    public var onKeyTypedNode: function(node: XTreeNode, event: KeyEvent ) : Void;

    /**
     * Function to create the collapsed graphic
     *
     * @defaultValue a function that creates an right pointing Equilateral Triangle of width 8
    */
    public var getCollapsedGraphic: function(): Node  = function() {
        ETriangle {
            width: 8
            fill: Color.web("#333")
            rotate: 90
        }

    }

    /**
     * Function to create the expanded graphic
     *
     * @defaultValue a function that creates an down pointing Equilateral Triangle of width 8
    */
    public var getExpandedGraphic: function(): Node  = function() {
        ETriangle {
            width: 8
            fill: Color.web("#333")
            rotate: 180
        }
    }

    /**
     * Reset the root node to null
    */

    public function reset() : Void {
        treeSkin.root = null;
    }

    /**
     * Get the root node
    */
    public function getRoot() : XTreeNode {
        treeSkin.root;
    }

    /**
     * Indicates whether or not the tree is interested in key events.
    */
    package function isInterestedInKeyEvents() : Boolean {
        onKeyPressedNode != null or
        onKeyReleasedNode != null or
        onKeyTypedNode != null;
    }


    /**
     * The default padding around tree nodes.  Can be overriden on each side
     * by setting the more specific padding variable.
     *
     * @defaultValue 3
     */
    public var padding:Integer = 3;

    /**
     * Padding on the left side of tree nodes.  Overrides the default padding
     * value if set.
     */
    public var leftPadding:Integer;

    /**
     * Padding on the top side of tree nodes.  Overrides the default padding
     * value if set.
     */
    public var topPadding:Integer;

    /**
     * Padding on the right side of tree nodes.  Overrides the default padding
     * value if set.
     */
    public var rightPadding:Integer;

    /**
     * Padding on the bottom side of tree nodes.  Overrides the default padding
     * value if set.
     */
    public var bottomPadding:Integer;

    /**
     * The indent from the parent level.
     *
     * @defaultValue 10.0
    */
    public var baseIndent = 10.0;

    /** The current selected node */
    public var selected: XTreeNode on replace old {
        if(not FX.isSameObject(old, selected)) {
            old.selected = false;
            onSelection(selected);
        }

    }

    /**
     * The XTreeView Data Descriptor
     *
     * @defaultValue DefaultTreeDataDescriptor
    */

    public var dataDescriptor: TreeDataDescriptor = DefaultTreeDataDescriptor {};


    /**
     * The Data Provider for the tree nodes
    */
    public var dataProvider: DataProvider;


     /**
      * Indicates whether the root node is visible or not
      *
      * @defaultValue true
     */
    public var rootVisible = true;

    /**
     * flag to track whether the tree nodes need
     * to be rebuilt or not
     */
    package var treeDirty = 0;

    /**
     * mark the tree as dirty
     */
    package function markDirty() {
        treeDirty++;
    }

    /**
     * clear the dirty setting
     */
    override package function clearDirty() {
        treeDirty= 0;
    }

    package function getLeftPad() {
        return if (isInitialized(leftPadding)) leftPadding else padding;
    }
    package function getTopPad() {
        return if (isInitialized(topPadding)) topPadding else padding;
    }
    package function getRightPad() {
        return if (isInitialized(rightPadding)) rightPadding else padding;
    }
    package function getBottomPad() {
        return if (isInitialized(bottomPadding)) bottomPadding else padding;
    }

    //override var skin = XTreeSkin{};

    postinit {
        skin = XTreeSkin{};
        markDirty();
    }


    public function clearSelection() {
        selected = null;
    }


    public function collapseSelection() {
        selected.collapse();
        makeVisible(selected);

    }
    public function expandSelection() {
        selected.expanded = true;
        makeVisible(selected);

    }

    public function isVisible(node: XTreeNode) {
        treeSkin.isNodeViewable(node);
    }

    public function makeVisible(node: XTreeNode) {
        if(not treeSkin.isNodeViewable(node)) {
            treeSkin.makeNodeVisible(node);
        }

    }

    public function isExpanded(node: XTreeNode) {
        node.expanded;
    }

    public function isCollapsed(node: XTreeNode) {
        not isExpanded(node);
    }


    public function hasBeenExpanded(node: XTreeNode) {
        isInitialized(node.expanded);
    }





    public function collapsePath(node: XTreeNode) {
        node.collapse();
        makeVisible(node);
    }

    public function expandPath(node: XTreeNode) {
        node.expanded = true;
        makeVisible(node);
    }




}



