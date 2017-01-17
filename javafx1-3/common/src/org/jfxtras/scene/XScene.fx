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

import com.javafx.preview.control.MenuBar;
import javafx.geometry.HPos;
import javafx.geometry.Insets;
import javafx.geometry.VPos;
import javafx.util.Sequences.*;
import javafx.scene.*;
import org.jfxtras.scene.layout.XContainer;

/**
 * Drop-in replacement for a JavaFX Scene that will automatically resize any
 * of its children that extend Resizable to fill the Scene bounds.  This is
 * particularly useful when used together with a resizable layout that should
 * fill the scene bounds, such as the following example:
 *
    @example
    import org.jfxtras.scene.*;
    import org.jfxtras.scene.layout.*;
    import javafx.ext.swing.*;

    XScene {
        width: 200
        height: 200
        content: XGrid {
            rows: Row {
                cells: SwingList {
                    items: SwingListItem {text: "Sample Item"}
                }
            }
        }
    }
    @endexample
 *
 * Note: This class resets the managed property to false on all nodes added to
 * prevent contention with resizing in the Root container.  It remembers the original
 * managed value that was set when the node was added to the content array, so as
 * long as you don't change the managed value after adding a node there will be no issues.
 *
 * @profile common
 * 
 * @author Stephen Chin
 */
public class XScene extends Scene {
    /**
     * The top,right,bottom,left padding around the scene's content.
     * This space will be included in the calculation of the scene's
     * minimum and preferred sizes.
     */
    public var padding:Insets on replace {
        if (initialized) {
            requestContentUpdate();
        }
    }

    /**
     * The horizontal position of each node within the XScene.
     * <p>
     * This may be overridden for individual nodes by setting the hpos variable
     * on the node's layoutInfo variable.
     *
     * @defaultvalue HPos.CENTER
     */
    public var nodeHPos:HPos = HPos.CENTER;

    /**
     * The vertical position of each node within the XScene.
     * <p>
     * This may be overridden for individual nodes by setting the vpos variable
     * on the node's layoutInfo variable.
     *
     * @defaultvalue VPos.CENTER
     */
    public var nodeVPos:VPos = VPos.CENTER;

    var initialized = false;
    var updatingContent = false;

    public var menuBar:MenuBar on replace {
        if (initialized) {
            contentUpdate();
        }
    }

    // Keep our own list of managed nodes, because we don't want the Root container to change
    // sizes on us.
    var managedNodes:Node[];

    override var content on replace oldContent[a..b] = newContent {
        for (n in oldContent[a..b]) {
            delete n from managedNodes;
        }
        for (n in newContent where n.managed = true) {
            insert n into managedNodes;
            n.managed = false;
        }
        if (initialized and not updatingContent) {
            contentUpdate();
        }
    }

    function contentUpdate() {
        // push menu to the top
        updatingContent = true;
        if (menuBar != null) {
            if (isReadOnly(menuBar)) {
                println("Could not insert menu bar into XScene, because content is bound.");
            } else {
                delete menuBar from content;
                insert menuBar into content;
            }
        }
        updatingContent = false;
        requestContentUpdate();
    }

    var widthInitialized = false;

    def internalWidth = bind width on replace {
        if (initialized) {
            requestContentUpdate();
        } else { // will get called twice (=false) if the superclass init changes the width
            widthInitialized = not widthInitialized;
        }
    }

    var heightInitialized = false;

    def internalHeight = bind height on replace {
        if (initialized) {
            requestContentUpdate();
        } else { // will get called twice (=false) if the superclass init changes the height
            heightInitialized = not heightInitialized;
        }
    }

    def prefWidths = bind for (node in managedNodes) XContainer.getNodePrefWidth(node) + XContainer.getNodeMarginWidth(node) on replace {
        requestContentUpdate();
    }

    def prefHeights = bind for (node in managedNodes) XContainer.getNodePrefHeight(node) + XContainer.getNodeMarginHeight(node) on replace {
        requestContentUpdate();
    }

    init {
        if (menuBar != null) {
            if (isReadOnly(menuBar)) {
                println("Could not insert menu bar into XScene, because content is bound.");
            } else {
                insert menuBar into content;
            }
        }
        initialized = true;
        updateContentBounds();
        if (not widthInitialized or not heightInitialized) {
            // todo 1.3 - This doesn't actually seem to change the width and height.  :(
            if (not widthInitialized) {
                SceneUtil.setSceneWidth(this, ((max(prefWidths) as Number) + padding.left + padding.right) as Integer);
            }
            if (not heightInitialized) {
                SceneUtil.setSceneHeight(this, ((max(prefHeights) as Number) + padding.top + padding.bottom) as Integer);
            }
            SceneUtil.sceneSizeChanged(this);
        }
    }

    var needsUpdate = true;

    function requestContentUpdate():Void {
        if (not needsUpdate) {
            needsUpdate = true;
            FX.deferAction(updateContentBounds);
        }
    }

    function updateContentBounds():Void {
        def top = if (menuBar != null) XContainer.getNodePrefHeight(menuBar) else 0;
        for (node in managedNodes where node != menuBar) {
            XContainer.layoutNode(node, padding.left, padding.top + top, width - padding.left - padding.right, height - top - padding.top - padding.bottom, nodeHPos, nodeVPos);
        }
        if (menuBar != null) {
            XContainer.layoutNode(menuBar, 0, 0, width, top);
        }
        needsUpdate = false;
    }
}
