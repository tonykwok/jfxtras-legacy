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

import javafx.scene.Node;
import org.jfxtras.scene.control.XTreeNodeSkin;
import javafx.scene.control.Control;
import javafx.scene.paint.Paint;
import org.jfxtras.scene.control.renderer.NodeRenderer;
import org.jfxtras.lang.XObject;
import javafx.reflect.FXLocal;


/**
 * A control for displaying tree nodes
 *
 * @author jimclarke
 */

public class XTreeNode  extends Control, XObject {

    /**
     * The tree
    */
    public var tree: XTreeView on replace {
        if(tree != null) {
            setRenderer();
        }
        for(it in treeChildren) {
            it.tree = tree;
        }

    }
    var treeSkin = bind tree.skin as XTreeSkin;
    override var blocksMouse = false; // needed for the mouseWheel event in view window

    /** The raw data, this is the data from the dataprovider,
     * null if the raw data is a XTreeNode
     */
    public var data: Object;

    /**
     * The nodes's parent item
    */
    public var parentNode: XTreeNode on replace {
        //tree.markDirty();
    }

    /**
     * The node's minimumWidth
    */
    public var minimumWidth:Number = bind treeSkin.view.width;

    /**
     * The node's index position in the view list
    */
    package var index: Integer;

    /**
     * The renderer for the node
    */
    public var renderer:NodeRenderer;

    //override var visible;

    public override function toString(): String {
        var idStr = if(id != "") id else item;
        "XTreeNode: {idStr}";
    }

    def context = FXLocal.getContext();


    package var childrenLoaded = false;

    /*
    * This display node, if this is not a javafx.scene.Node, then
    * a NodeRendere will be used to generate the displayed node.
    */
    public var item: Object on replace {
        setRenderer();
    }

    function setRenderer() : Void {
         if(item != null and renderer == null) {
            var itemType = context.makeClassRef(item.getClass());
            renderer = tree.defaultRenderers.get(itemType) as NodeRenderer;
            if(renderer == null) {
                renderer = tree.defaultRenderers.get(context.getStringType()) as NodeRenderer;
            }
        }


    }

    package function setAllRenderers() : Void {
        setRenderer();
        for(c in treeChildren) {
            c.setAllRenderers();
        }
    }




    /**
     * Indicator to determine if this node is selected or not.
    */
    public var selected:Boolean  on replace {
        if(not selected and FX.isSameObject(this, tree.selected ) ) {
        tree.selected = null;
        }else if(selected) {
            tree.selected = this;
        }
    }


    /**
     * The indent for this item within the tree
    */
    package var indent:Number = bind parentNode.indent + (if(visible) tree.baseIndent else 0);

    /** The children nodes */
    public var treeChildren: XTreeNode[] on replace old [lo..hi] = newChildren {
        treeSkin.deleteChildren(this, old);
        for(i in [lo..hi]) {
            if(old[i].selected) {
                old[i].selected = false;
            }
            old[i].tree = null;
            old[i].parentNode = null;
        }
        for(n in newChildren) {
            n.tree = tree;
            n.parentNode = this;

        }
        treeSkin.addChildren(this);
    }

    /** Indicates whether or not this item has Children */
    public var hasChildren = bind sizeof treeChildren != 0 on replace {
        if(hasChildren)  {  
            leaf = false;
            childrenLoaded = true;
        }
    }

    /** Indicates whether or not this item is a leaf or not */
    public var leaf: Boolean = true;

    package function loadChildren() : Void {
         if(not this.childrenLoaded ) {
            var result = tree.dataDescriptor.getChildren(if(this.data != null) this.data else this);
            var tnodes = for( r in result) {
                if(r instanceof XTreeNode) {
                    r as XTreeNode;
                }else {
                    XTreeNode {
                        data: tree.dataDescriptor.getData(r)
                        item: r
                        leaf: tree.dataDescriptor.isLeaf(r)
                    }
                }
            };
            insert tnodes into this.treeChildren;
            this.childrenLoaded = true;
        }
    }


    /** Indicates whether this node is expanded or collapsed */
    public var expanded: Boolean on replace old {
        if(isInitialized(expanded) and expanded != old) {
            // Expand all the parents.
            if(expanded) {
                loadChildren();
                showChildren(this);
                var par = this.parentNode;
                while(par != null) {
                    if(not par.expanded) {
                        par.expanded = true;
                        par = par.parentNode;
                    } else {
                        break;
                    }
                }

                treeSkin.addChildren(this);
            }else {
                hideChildren(this);
            }
            treeSkin.requestLayoutTree();

            FX.deferAction( function() {
                if(expanded) {
                    tree.onExpand(this);
                }else {
                    tree.onCollapse(this);
                }
            } );
        }

    }

    function hideChildren(target: XTreeNode) : Void {
        for(c in target.treeChildren) {
            c.visible = false;
            hideChildren(c);
        }
    }

    function showChildren(target: XTreeNode) : Void {
        if(target.expanded) {
            for(c in target.treeChildren) {
                c.visible = true;
                showChildren(c);
            }
        }

    }



    /**
     * expand from this node down
     */
    public function expand () : Void {
        if(not leaf) {
            this.expanded = true;
            for(n in treeChildren) {
                n.expand();
            }
        }
    }

    /**
     * expand from this node down
     */
    public function expand (levels: Integer) : Void {
        if(not leaf and levels > 0) {
            this.expanded = true;
            var nextLevel = levels-1;
            if(nextLevel > 0) {
                for(n in treeChildren) {
                    n.expand(nextLevel);
                }
            }
        }
    }
    /**
     * collapse from this node down
     */
    public function collapse () : Void {
        if(not leaf) {
            this.expanded = false;
            for(n in treeChildren) {
                n.collapse();
            }
        }

    }

    /**
     * Get the XTreeView Path from this node up to the root node
     *
     * @return sequence of paths in order from this node to the root.
     */

    public function getPath() : XTreeNode[] {
        var items : XTreeNode[];
        var tmp = this;
        while(tmp != null) {
            insert tmp into items;
            tmp = tmp.parentNode;
        }
        items;
    }



    public var backgroundFill:Paint = bind if (selected) {
        treeSkin.selectedGradient
    } else if (index mod 2 == 0) {
        treeSkin.backgroundColor
    } else {
        treeSkin.alternateColor
    }

    override var skin = XTreeNodeSkin { };

}

