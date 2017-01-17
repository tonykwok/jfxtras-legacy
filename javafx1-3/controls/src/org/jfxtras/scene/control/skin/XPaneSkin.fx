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
package org.jfxtras.scene.control.skin;

import org.jfxtras.scene.control.XPane;
import com.sun.javafx.scene.layout.Region;
import javafx.scene.control.Label;
import javafx.scene.layout.LayoutInfo;
import javafx.scene.control.Skin;
import javafx.scene.Cursor;
import org.jfxtras.scene.control.XPaneBehavior;
import javafx.scene.layout.Panel;
import javafx.util.Math;
import javafx.scene.layout.Priority;
import javafx.scene.layout.HBox;
import javafx.scene.layout.Container;
import javafx.geometry.VPos;

/**
 * A base class for Skins of the XPane control.
 *
 * @author Dean Iverson
 */
public class XPaneSkin extends AbstractSkin {

    override var behavior = XPaneBehavior {}

    def paneControl = bind control as XPane;
    def paneBehavior = bind behavior as XPaneBehavior;

    /**
     * True if the control's title bar is visible.
     */
    def titleBarVisible = bind paneControl.draggable or paneControl.closable or paneControl.title != "" on replace {
        rootPanel.requestLayout();
    }

    /**
     * The label for the title bar - displays the title bar text and graphic.
     */
    def titleText = Label {
        styleClass: "xpane-title-label"
        text: bind paneControl.title
        graphic: bind paneControl.titleGraphic
        layoutInfo: LayoutInfo {
            hfill: true
            hgrow: Priority.ALWAYS
        }
    }

    /**
     * The title bar's close button shape (an 'X' by default).
     */
    def titleCloseMark = Region {
        styleClass: "xpane-title-close-mark"
        visible: bind paneControl.closable
    }

    /**
     * The title bar's close button background.
     */
    def titleCloseBox = Region {
        styleClass: "xpane-title-close-box"
        visible: bind paneControl.closable
        content: titleCloseMark
        layoutInfo: LayoutInfo {
            hfill: true
            vfill: false
            hgrow: Priority.NEVER
            vgrow: Priority.NEVER
        }
        blocksMouse: true;
        onMouseClicked: function( me ) {
            paneBehavior.closeButtonClick()
        }
    }

    /**
     * The background node of the title bar.
     */
    def titleBar = Region {
        styleClass: "xpane-title"
        blocksMouse: true
        visible: bind titleBarVisible
        cursor: bind if (paneControl.draggable) Cursor.MOVE else Cursor.DEFAULT
        content: HBox {
            spacing: 10
            nodeVPos: VPos.CENTER
            content: [ titleText, titleCloseBox ]
        }
        onMousePressed: function( me ) {
            paneBehavior.titleBarPress( me )
        }
        onMouseDragged: function( me ) {
            paneBehavior.titleBarDrag( me )
        }
    }

    /**
     * The background of the content portion of control.
     */
    def contentBackground = Region {
        styleClass: "xpane-content"
        content: bind paneControl.contentNode
    }

    /**
     * This panel is the root container of the XPane's skin.  It provides the custom layout
     * of the title bar and content area.
     */
    def rootPanel = Panel {
        content: bind [contentBackground, titleBar]
        onLayout: doLayout
        minWidth: calcMinWidth
        minHeight: calcMinHeight
        prefWidth: calcPrefWidth
        prefHeight: calcPrefHeight
    }

    init {
        node = rootPanel;
    }

    /**
     * Override AbstractSkin's impl to take into account the skin's translation, which may be
     * changed if the panel is draggable.  This is potentially a bug in Node.contains since
     * it doesn't seem to take the node's translation into account at the moment.  I suspect
     * that this was broken when layoutBounds was changed to not encompass the node's
     * transformations.
     */
    override function contains(localX:Number, localY:Number):Boolean {
        return node.contains(localX-node.translateX, localY-node.translateY);
    }

    override function getMinWidth(): Number {
        rootPanel.getMinWidth();
    }

    override function getMinHeight(): Number {
        rootPanel.getMinHeight();
    }

    override function getPrefWidth( height ): Number {
        rootPanel.getPrefWidth(height);
    }

    override function getPrefHeight( width ): Number {
        rootPanel.getPrefHeight( width );
    }

    override function getMaxWidth(): Number {
        rootPanel.getMaxWidth();
    }

    override function getMaxHeight(): Number {
        rootPanel.getMaxHeight();
    }

    /**
     * The control calls this function when a re-layout may be needed.
     */
    public function requestLayout() {
        rootPanel.requestLayout();
    }

    function calcTitleHeight(): Number {
        if (titleBarVisible) titleBar.getPrefHeight(-1) else 0;
    }

    function calcMinWidth(): Number {
        def titleMin = titleBar.getMinWidth();
        def contentMin = contentBackground.getMinWidth();
        Math.max( contentMin, titleMin );
    }

    function calcMinHeight(): Number {
        titleBar.getMinHeight() + contentBackground.getMinHeight();
    }

    function calcPrefWidth( height: Float ): Number {
        def titlePref = titleBar.getPrefWidth( -1 );
        def contentPref = contentBackground.getPrefWidth( -1 );
        Math.max( contentPref, titlePref );
    }

    function calcPrefHeight( width: Float ): Number {
        calcTitleHeight() + contentBackground.getPrefHeight( width );
    }

    function doLayout():Void {
        def titleHeight = calcTitleHeight();
        def contentHeight = paneControl.height - titleHeight;
        
        Container.layoutNode( titleBar, 0, 0, paneControl.width, titleHeight );
        Container.layoutNode( contentBackground, 0, titleHeight, paneControl.width, contentHeight );
    }
}

