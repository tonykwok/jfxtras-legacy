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

package org.jfxtras.scene.control.data;

import org.jfxtras.scene.control.XTreeNode;

/**
 * Implempents a TreeDataDescriptor based on XTreeNode
 * 
 * @author jimclarke
 */

public class DefaultTreeDataDescriptor extends TreeDataDescriptor {

    public override function getData(node: Object) : Object {
        return node;
    }


    public override function isLeaf(node: Object): Boolean {
        (node as XTreeNode).leaf;
    }


    public override function hasChildren(node: Object) : Boolean {
        (node as XTreeNode).hasChildren;
    }


    public override function getChildren(node: Object) : Object[] {
        (node as XTreeNode).treeChildren;
    }


    public override function addChild(node: Object, child:Object, position: Integer): Boolean {
        var tnode = node as XTreeNode;
        var tchild = child as XTreeNode;
        if(position >= sizeof tnode.treeChildren) {
            return false;
        }

        if(position >= 0) {
            insert tchild after tnode.treeChildren[position];
        }else {
            insert tchild into tnode.treeChildren;
        }
        true;

    }


    public override function removeChild(node: Object, child:Object, position: Integer): Boolean {
        var tnode = node as XTreeNode;
        var tchild = child as XTreeNode;
        if(position >= sizeof tnode.treeChildren) {
            false;
        } else if(position >= 0) {
            if(FX.isSameObject(tchild, tnode.treeChildren[position])) {
                delete tnode.treeChildren[position];
                true;
            } else {
                false;
            }

        }else {
            delete tchild from tnode.treeChildren;
            true
        }
    }

}
