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

import javafx.scene.control.Skin;
import javafx.scene.Group;
import javafx.scene.shape.*;
import javafx.scene.paint.*;
import javafx.scene.control.ScrollBar;
import javafx.scene.layout.ClipView;
import javafx.scene.layout.Panel;
import javafx.scene.layout.Container;
import javafx.util.Math;
import org.jfxtras.scene.control.skin.AbstractSkin;


/**
 * Specifies the skin for a XScrollView
 *
 * @profile desktop
 *
 * @author jclarke
 */

package class XScrollViewSkin extends AbstractSkin {
    /**
    * holds the XScrollView control
     */
    var scroll = bind control as XScrollView;

    /**
     * Holds the background color for the scroll view
     *
     * @css background-fill
     * @defaultValue #EFEFEF
     */
    public var backgroundFill: Paint = Color.web("#EFEFEF") on replace {
        requestLayout();
    }

    var width = bind scroll.width  on replace {
        requestLayout();
    }

    var height = bind scroll.height on replace {
        requestLayout();
    }

    function requestLayout():Void {
        (node as Panel).requestLayout();
    }

    /**
    * Indicates that a ScrollBar will be on the left.
     */
    var leftPlacement = bind scroll.position == ScrollPosition.LEFT or
            scroll.position == ScrollPosition.TOP_LEFT or
            scroll.position == ScrollPosition.BOTTOM_LEFT  on replace {
        requestLayout();
    }

    /**
    * Indicates that a ScrollBar will be on the right.
     */
    var rightPlacement = bind scroll.position == ScrollPosition.RIGHT or
            scroll.position == ScrollPosition.TOP_RIGHT or
            scroll.position == ScrollPosition.BOTTOM_RIGHT  on replace {
        requestLayout();
    }

    /**
    * Indicates that a ScrollBar will be on the top.
     */
    var topPlacement = bind scroll.position == ScrollPosition.TOP or
            scroll.position == ScrollPosition.TOP_LEFT or
            scroll.position == ScrollPosition.TOP_RIGHT  on replace {
        requestLayout();
    }

    /**
    * Indicates that a ScrollBar will be on the bottom.
     */
    var bottomPlacement = bind scroll.position == ScrollPosition.BOTTOM or
            scroll.position == ScrollPosition.BOTTOM_LEFT or
            scroll.position == ScrollPosition.BOTTOM_RIGHT  on replace {
        requestLayout();
    }
     /* holds the scroll able region */
    def clipView: ClipView = ClipView {
        node: bind scroll.node
    };
    /**
    * Indicates that there will be a horizontal scrollbar
     */
    var horizontal = bind (topPlacement or bottomPlacement) and
        (clipView.node.boundsInLocal.width > width) on replace {
        requestLayout();
    }

    /**
    * Indicates that there will be a vertial scrollbar
     */
    var vertical = bind (leftPlacement or rightPlacement) and
        (clipView.node.boundsInLocal.height > height) on replace {
        requestLayout();
    }

    /**
     * Provides the hieght for the horizontal and width for the
     * vertical scrollbar.
    */
    // TODO: javafx.scene.layout.ScrollBar does not resize properly
    /******* TODO
    public var scrollBarSize = 24 on replace {
        requestLayout();
    }
    *******/


    /**
    * The horizontal scroll bar
     */
    var hscrollBar:ScrollBar = ScrollBar {
        visible: bind horizontal
        managed: bind horizontal
        vertical: false
        blockIncrement: bind hBlockIncrement
        unitIncrement: 10
        max: bind clipView.maxClipX
        value: bind clipView.clipX with inverse
    };



    /**
    * The veritical scroll bar
     */
    var vscrollBar: ScrollBar = ScrollBar {
        visible: bind vertical
        managed: bind vertical
        vertical: true
        blockIncrement: bind vBlockIncrement
        unitIncrement: 10
        max: bind clipView.maxClipY
        value: bind clipView.clipY with inverse
    };

   

    /** The x position for the horizontal scroll bar */
    var hscrollX = bind if(leftPlacement and horizontal) vscrollBar.width else 0 on replace {
        requestLayout();
    }
    /** The y position for the horizontal scroll bar */
    var hscrollY = bind if(bottomPlacement ) height - hscrollBar.height else 0 on replace {
        requestLayout();
    }
    /** The x position for the vertical scroll bar */
    var vscrollX = bind if(rightPlacement) width - vscrollBar.width else 0 on replace {
        requestLayout();
    }
    /** The y position for the vertical scroll bar */
    var vscrollY = bind if(topPlacement and vertical)  hscrollBar.height else 0 on replace {
        requestLayout();
    }

    /** The height of the viewable area */
    var viewHeight = bind
        if(horizontal)  height - hscrollBar.height else height on replace {
        requestLayout();
    }
    /** The width of the viewable area */
    var viewWidth = bind
        if(vertical) width- vscrollBar.width else width on replace {
        requestLayout();
    }
    /** The x position of the viewable area */
    var viewX = bind if(leftPlacement and vertical ) vscrollBar.width else 0 on replace {
        requestLayout();
    }
    /** The y position of the viewable area */
    var viewY = bind if(topPlacement and horizontal) hscrollBar.height else 0 on replace {
        requestLayout();
    }


    /** Holds block increment for the horizontal scroll bar */
    var hBlockIncrement = bind viewWidth;
    /** Holds block increment for the vertical scroll bar */
    var vBlockIncrement = bind viewHeight;

    override function getMinWidth() : Number {
        Container.getNodeMinWidth(vscrollBar) +
            Container.getNodeMinWidth(hscrollBar);
    }
     override function getMinHeight() : Number {
        Container.getNodeMinHeight(vscrollBar) +
            Container.getNodeMinHeight(hscrollBar);
    }

    /**
     * Computes preferred width as the sum of left and right border widths
     * and the content's preferred width
     */
    protected override function getPrefWidth(height): Number {
        var w = if(vertical) {
             Container.getNodePrefWidth(clipView, -1) +
                Container.getNodePrefWidth(vscrollBar, -1);
        } else {
            Container.getNodePrefWidth(clipView, -1);
        }
        Math.max(w, getMinWidth());
    }

    /**
     * Computes preferred height as the sum of top and bottom border widths
     * and the content's preferred height
     */
    protected override function getPrefHeight(width): Number {
        var h = if(horizontal) {
            Container.getNodePrefHeight(clipView, -1) +
                Container.getNodePrefHeight(hscrollBar, -1);
        } else {
            Container.getNodePrefHeight(clipView, -1);
        }
        Math.max(h, getMinHeight());
    }
    function doScrollLayout() : Void {
        Container.layoutNode(clipView, viewX, viewY, viewWidth, viewHeight);
        if(vscrollBar.managed) {
            Container.layoutNode(vscrollBar, vscrollX, vscrollY, vscrollBar.width, viewHeight);
        }
        if(hscrollBar.managed) {
            Container.layoutNode(hscrollBar,hscrollX, hscrollY, viewWidth, hscrollBar.height);
        }
    }



    init {

        node = Panel {
            onLayout: doScrollLayout
            content: [
                Rectangle {
                    width: bind width
                    height: bind height
                    fill: bind backgroundFill
                },
                clipView,
                vscrollBar,
                hscrollBar ,
            ]
        };
    }
}
