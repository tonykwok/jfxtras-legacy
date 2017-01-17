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

import javafx.scene.layout.Panel;
import javafx.scene.layout.ClipView;
import javafx.scene.control.ScrollBar;
import javafx.scene.shape.Rectangle;
import javafx.scene.paint.Color;
import javafx.scene.paint.LinearGradient;
import javafx.scene.paint.Stop;
import javafx.stage.Screen;
import javafx.scene.input.MouseEvent;
import javafx.scene.layout.Container;
import javafx.geometry.HPos;
import javafx.geometry.VPos;
import javafx.util.Math;
import javafx.util.Sequences;
import javafx.scene.Node;
import java.util.Comparator;
import org.jfxtras.scene.paint.ColorUtil;
import org.jfxtras.scene.control.skin.AbstractSkin;
import org.jfxtras.scene.control.skin.XCaspian;

/**
 * @author jimclarke
 */
public class XTreeSkin extends AbstractSkin {

    public var accentColor = XCaspian.fxAccent;
    public var baseColor  = XCaspian.fxBase;
    public var strongBaseColor = accentColor;  // In Caspian 1.3 strong button color is now accent
    public var darkTextColor = XCaspian.fxDarkTextColor;
    public var textColor = XCaspian.fxTextBaseColor;
    public var lightTextColor = XCaspian.fxLightTextColor;
    public var markColor = XCaspian.fxMarkColor;
    public var lightMarkColor = XCaspian.fxMarkHighlightColor;
    public var backgroundColor = Color.WHITE;
    public var alternateColor = Color.web("#F3F3F3");
    public var font = XCaspian.fxFont;
    package var selectedGradient = LinearGradient {
        endX: 0
        endY: 1.0
        stops: [
            Stop {color: accentColor}
            Stop {offset: 1, color: ColorUtil.darker(accentColor, 0.3)}
        ]
    }

    var tree: XTreeView = bind control as XTreeView;

    var firstShown: Integer on replace old {
        if(firstShown != old) {
            view.clipY = list.content[firstShown].boundsInParent.minY;
        }
    }

    package function makeNodeVisible(node: XTreeNode): Void {
        if(node.parentNode != null) {
            if(not node.parentNode.expanded) {
                node.parentNode.expanded = true;
            }
        }
        view.clipY = list.content[node.index].boundsInParent.minY
    }

    var inUpdateTree = false;

    package var root: XTreeNode on replace {
        if(not inUpdateTree) {
            updateTree();
        }

    }

    var dataProvider = bind tree.dataProvider on replace {
        if(dataProvider != null) {
            updateTree();
        }


    }

     package def view: ClipView = ClipView {
        width: bind tree.width - vscroll.width
        height: bind tree.height - hscroll.height
        pannable: false
        onMouseWheelMoved: function(e: MouseEvent) : Void {
            var tmp = firstShown;
            tmp += (e.wheelRotation + 0.5).intValue();
            if(tmp >= sizeof list.content) {
                tmp = sizeof list.content - 1;
            }
            if(tmp < 0) {
                tmp = 0;
            }
            if(tmp != firstShown)
                firstShown = tmp;
            //view.clipY = list.content[firstShown].boundsInParent.minY;

        }

        override var clipY on replace {
            firstShown = getIndex(view.clipY);
        }

        node: bind list
    };

    var vscroll: ScrollBar;
    var hscroll: ScrollBar;

    /** Vertical ScrollBar */
    def vertScroll:ScrollBar = ScrollBar {
        layoutX: bind view.width
        vertical: true
        height: bind tree.height - hscroll.height
        value: bind view.clipY with inverse
        max: bind Math.min(lastNodeY, view.maxClipY)
    };


    /** Horizontal ScrollBar */
    def horizScroll:ScrollBar = ScrollBar {
        layoutY: bind view.height
        width: bind tree.width - vscroll.width
        vertical: false
        value: bind view.clipX with inverse
        max: bind view.maxClipX

    };

    // these see if we need to display the scrolls or not
    var twidth = bind view.width on replace {
        hscroll = if(maxNodeWidth > twidth)
            horizScroll else null;
    }


    var maxNodeWidth: Number on replace {
        hscroll = if(maxNodeWidth > twidth)
            horizScroll else null;

    }
    var theight = bind view.height on replace {
        vscroll = if(maxNodeHeight > theight)
            vertScroll else null;
    }


    var maxNodeHeight: Number on replace {
        vscroll = if(maxNodeHeight > theight)
            vertScroll else null;
    }
    // END of scroll check
    // the position of the last XTreeNode in the list. Used by vertical scroll.
    var lastNodeY: Number;



    function buildDisplayedNodes(): XTreeNode[] {

        var tnodes: XTreeNode[];
        if(root == null) {
            // If we get 1 node, assume it is the root,
            // otherwise, assume a psuedo root and these nodes
            // are children of the pseudo root.
            var nodes = tree.dataProvider.getColumn(0, tree.dataProvider.rowCount, "");
            if(sizeof nodes > 0) {
                if(sizeof nodes == 1) {
                    if(nodes[0].ref instanceof XTreeNode) {
                        root = nodes[0].ref as XTreeNode;

                    }else {
                        root = XTreeNode {
                            data: tree.dataDescriptor.getData(nodes[0].ref )
                            item: nodes[0].ref
                            leaf: tree.dataDescriptor.isLeaf(nodes[0].ref )
                        };
                    }

                }else {
                    root = XTreeNode { item: "" }; // psuedo root
                    tree.rootVisible = false;
                    for(n in nodes) {
                        var tnode: XTreeNode;
                        if(n.ref instanceof XTreeNode) {
                            tnode = n.ref as XTreeNode;
                        }else {
                            tnode = XTreeNode {
                                data: tree.dataDescriptor.getData(n)
                                item: n.ref
                                leaf: tree.dataDescriptor.isLeaf(n)
                            }
                        }
//TODO 1.3                        insert tnode into root.children;
                    }
                }
                root.tree = tree;
            }
        }
        if(tree.rootVisible) {
            insert root into tnodes;
        }else if(not root.expanded) {
            root.expanded = true;
        }
        if(root.expanded)
            insert buildDisplayedNodes(root) into tnodes;

        tnodes;
    }




    function buildDisplayedNodes(node: XTreeNode) : XTreeNode[] {

        var tnodes: XTreeNode[];
//TODO 1.3        for( c in node.children) {
//TODO 1.3           insert c into tnodes;
//TODO 1.3            if(c.expanded)
//TODO 1.3                insert buildDisplayedNodes(c) into tnodes;
//TODO 1.3        }
        tnodes;
    }


    // Test to see if the node is viewable in the view.
    package function isNodeViewable(node: XTreeNode) {
        node.visible and
        node.layoutY >= view.clipY and
        node.layoutY < view.clipY + view.boundsInParent.height;
    }


    def maxHeight = Screen.primary.bounds.height;
    public function updateTree(): Void {
        try {
            inUpdateTree = true;
            var saveFirstShown = firstShown;
            delete list.content;
            var tnodes = buildDisplayedNodes();
            var my = 0.0;
            var mx = 0.0;
            var lastNodeyy = 0.0;
            for(c in tnodes) {
                mx = Math.max(mx, c.layoutBounds.width);
                lastNodeyy = my;
                my += c.layoutBounds.height;
                c.index = indexof c;
            }
            lastNodeY = lastNodeyy;
            maxNodeWidth = mx;
            maxNodeHeight = my;
            insert  tnodes into list.content;
            if(my < maxHeight) {  //draw extra in case there is a resize of the view
                var avg = my / sizeof tnodes;

                var ndx = sizeof tnodes;
                while(my < maxHeight) {
                    var c = Rectangle {
                            width: bind tree.width
                            height: bind avg
                            fill: if(ndx mod 2 == 0) backgroundColor else alternateColor
                    };
                    insert c into list.content;
                    my += avg;
                    ndx++;
                }

            }
            if(saveFirstShown < sizeof tnodes)
                firstShown = saveFirstShown
            else 
                firstShown = 0;
         }finally {
             inUpdateTree = false;
         }

    }

    package function addChildren(target: XTreeNode) : Void {
        // if children loaded it should be in the list already
        if(target.parent != null) {
            var startNdx = target.index;
            var nodesToInsert : Node[]; // TODO 1.3 for(c in target.children where c.parent == null)c;

            insert nodesToInsert after list.content[startNdx];
            startNdx++;
            for( c in list.content[startNdx..]) {
                if(c instanceof XTreeNode)
                    (c as XTreeNode).index = startNdx++;
            }
        }
    }
    var indexComparator:Comparator =  Comparator {
        // reverse sorted
        override function compare(a: Object, b:Object) : Integer {
            return (b as XTreeNode).index - (a as XTreeNode).index;
        }
    };
    package function deleteChildren(parent: XTreeNode, children: XTreeNode[]): Void {
        if(parent.parent != null) {
            var startNdx = parent.index+1;
            var indexSorted = Sequences.sort(children,indexComparator) as XTreeNode[];
            for( c in indexSorted) {
                delete list.content[c.index];
            }
            for( c in list.content[startNdx..]) {
                if(c instanceof XTreeNode)
                    (c as XTreeNode).index = startNdx++;
            }
        }


    }


    package function deleteChildren(target: XTreeNode) : Void {
// TODO 1.3        if(sizeof target.children > 0)
// TODO 1.3            deleteChildren(target, target.children);
    }

    package function deleteNode(target:XTreeNode) : Void {
        deleteChildren(target.parentNode, target);
    }


    // TODO
    //override var behavior = TreeBehavior { }


    var list: Panel = Panel{
            onLayout: function() {
                var yy = 0.0;
                for(n in Container.getManaged(list.content) ) {
                     if(n.visible) {
                         //Container.resizeNode(n, Container.getNodePrefWidth(n), Container.getNodePrefHeight(n));
                         Container.layoutNode(n, 0, yy, Container.getNodePrefWidth(n), Container.getNodePrefHeight(n),
                            HPos.LEFT, VPos.CENTER);
                         yy += n.layoutBounds.height;
                     }
                }

            }

    };





    package function requestLayoutTree() {
        var my = 0.0;
        var mx = 0.0;
        var lastNodeyy = 0.0;
        for(c in list.content) {
            if(c instanceof XTreeNode and c.visible) {
                mx = Math.max(mx, c.layoutBounds.width);
                lastNodeyy = my;
                my += c.layoutBounds.height;
            }
            lastNodeY = lastNodeyy;
            maxNodeWidth = mx;
            maxNodeHeight = my;
        }
        list.requestLayout();
    }
    function getIndex(clipY: Number) : Integer {
        if(clipY <= 0) {
            return 0;
        }
        if(clipY >= list.content[firstShown].boundsInParent.minY and
            clipY <= list.content[firstShown].boundsInParent.maxY) {
                return firstShown;
            }

        var ndx = firstShown;
        if(clipY < list.content[ndx].boundsInParent.minY) {
            ndx--;
            while(ndx > 0) {
                if(clipY >= list.content[ndx].boundsInParent.minY) {
                    return ndx;
                }
                ndx--;
            }
            return 0;

        }else {
            var end = sizeof list.content - 1;
            ndx++;
            while(ndx <= end) {
                if(clipY <= list.content[ndx].boundsInParent.maxY) {
                    return ndx;
                }
                ndx++;
            }
            return end;

        }



    }






    init {
        node = Panel {
            content: bind [
                view,
                vscroll,
                hscroll
            ]
        };
    }

    postinit {
        updateTree();
    }


}
