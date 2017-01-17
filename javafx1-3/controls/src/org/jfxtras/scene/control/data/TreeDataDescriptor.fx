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

/**
 * Mixin class that supports Hierarchical data access
 *
 * @author jimclarke
 */

public mixin class TreeDataDescriptor {

    /**
     * is the node a leaf or not
     *
     * @param node the parent node
     * @return true if the node is a leaf.
     */
    public abstract function isLeaf(node: Object): Boolean;

    /**
     * does the node have children
     *
     * @param node the parent node
     * @return true if the node has children
     */
    public abstract function hasChildren(node: Object) : Boolean;

    /**
     * get the node's children
     *
     * @param node the parent node
     * @return the children for the node
     */
    public abstract function getChildren(node: Object) : Object[];

    /**
     * get any data associated with the node
     *
     * @param node the parent node
     * @return the node's data or null if there is no data associated with the node
     */
    public abstract function getData(node: Object) : Object;

    /**
     * Add a child to the node, the child is added to the list in any order.
     *
     * @param node the parent node
     * @param child the child to be added
     * @return true if the child was successfully added
     */
    public function addChild(node: Object, child: Object): Boolean {
        addChild(node, child, -1);
    }
    /**
     * Add a child to the node after the indicated position within the children list.
     *
     * @param node the parent node
     * @param child the child to be added
     * @param position position within the children list where the child will be added.
     * @return true if the child was successfully added
     */
    public abstract function addChild(node: Object, child:Object, position: Integer): Boolean;

    /**
     * Remove a child from the node, if the child is in the list multiple times,
     * the implementation will determine which child is removed.
     *
     * @param node the parent node
     * @param child the child to be removed
     * @return true if the child was successfully removed
     */
    public function removeChild(node: Object, child:Object): Boolean {
        removeChild(node, child, -1);
    }

    /**
     * Remove a child from the node, at the specified position in the child list.
     *
     * @param node the parent node
     * @param child the child to be removed
     * @param position position within the children list where the child will be removed.
     * @return true if the child was successfully removed
     */
    public abstract function removeChild(node: Object, child:Object, position: Integer): Boolean;

}
