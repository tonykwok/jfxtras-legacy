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
package dnd;

import javafx.scene.CustomNode;
import javafx.scene.Node;
import javafx.scene.input.MouseEvent;
import javafx.animation.Interpolator;
import javafx.animation.KeyFrame;
import javafx.animation.Timeline;
import dnd.DroppableNode;
import java.lang.Void;

/**
 * a draggable node :)
 * @author Abhilshit Soni
 */
public class DraggableNode extends CustomNode {

    /** The data object owned by this draggable*/
    public var dataObject: Object;
    /** Reference to the DroppableNode on which this draggble is dropped */
    public var dropNode: Node;
    /** set this flag to true if you need drag animation */
    public var dragAnimate: Boolean = true;
    /** initial x-axis value of draggable. */
    public var initialTransX: Number;
    /** initial y-axis value of draggable. */
    public var initialTransY: Number;
    /** current x-axis value of draggable updated when dragged.*/
    public var currTransX: Number;
    /** current y-axis value of draggable updated when dragged.*/
    public var currTransY: Number;
    /** a flag that indicates whether a draggable can be dropped on the node below or not */
    public var dropIndicator: Boolean = false;
    /** a flag that indicates if a draggable is currently dragged or not.*/
    public var isDragged = false;
    /** a flag that indicates that other draggables in the scene can be dragged at the same time or not */
    var otherNodesDraggable = true;
    /** a flag that indicates if a draggable is currently dropped or not.*/
    public var isDropped = false;
    public var allDroppables = [];
    public var allDraggables = [];
    /** timeline that makes draggable node come back to its original position from where it was dragged.*/
    public var comeBack = Timeline {
                repeatCount: 1
                keyFrames: [
                    KeyFrame {
                        time: 0s
                        canSkip: true
                        values: [translateX => currTransX tween Interpolator.EASEBOTH, translateY => currTransY tween Interpolator.EASEOUT]
                        action: function () {
                            blockMouseActions();
                        }
                    }
                    KeyFrame {
                        time: 1s
                        canSkip: true
                        values: [translateX => this.initialTransX tween Interpolator.EASEBOTH, translateY => this.initialTransY tween Interpolator.EASEOUT]
                        action: function () {
                            resumeMouseActions();
                        }
                    }
                ]
            }

    init {
        initialTransX = translateX;
        initialTransY = translateY;

    }

    /**
     * checks scene content if there is any node of type Droppable that contains current sceneX and sceneY of mouse.
     */
    public function updateVariables(transX: Number, transY: Number, e: MouseEvent) {
        dropIndicator = false;
        var node: Node = e.source;
        var sceneContent = node.scene.content;
        currTransX = transX;
        currTransY = transY;
        for (i in allDroppables) {
            if (((i as DroppableNode).boundsInParent.contains(e.sceneX, e.sceneY)) and (i instanceof DroppableNode)) {
                if ((i as DroppableNode).dataObject == null) {
                    dropNode = (i as DroppableNode);
                    dropIndicator = true;
                    break;
                }
            }
        }
    }

    /**
     * on mouse dragged ask draggable node to follow mouse and ping updateVariables() to see if the node below is droppable or not.
     */
    public override var onMouseDragged = function (e: MouseEvent): Void {
                if (isDropped) {
                    this.dataObject = (dropNode as DroppableNode).dataObject;
                    (dropNode as DroppableNode).dataObject = null;
                    isDropped = false;
                }
                if (otherNodesDraggable) {
                   blockMouseActions();
                }
                isDragged = true;
                toFront();
                translateX = e.sceneX - (layoutBounds.width / 2);
                translateY = e.sceneY - (layoutBounds.height / 2);
                opacity = 0.5;
                updateVariables(translateX, translateY, e);
            }
    /**
     * when drag is released assign draggable node's dataobject to droppable node's dataobject.
     * and place the draggable node on droppable node.
     */
    public override var onMouseReleased = function (e: MouseEvent): Void {

                if (dropIndicator) {
                    translateX = dropNode.translateX;
                    translateY = dropNode.translateY;
                    (dropNode as DroppableNode).dataObject = this.dataObject;
                    //this.dataObject = null;
                    (dropNode as DroppableNode).onDrop();
                    isDropped = true;
                } else {
                    if (isDragged) {
                        if (isDropped) {
                           // println("revert");
                            revert();
                        } else {
                           // println("reset");
                            reset();
                            (dropNode as DroppableNode).onRevert();
                        }
                    }
                }
                isDragged = false;
                opacity = 1;
                if(not dragAnimate){
                resumeMouseActions();
                 }
            }
    /**
     * call revert() if user double clicks the draggable node
     */
    public override var onMouseClicked = function (e: MouseEvent): Void {
                if (e.clickCount == 2) {
                    revertBack();
                }


            }

    public function revertBack(): Void {
        if (dropIndicator) {
            isDropped = false;
            revert();
        }
    }

    /**
    performs the revert action.
     */
    protected function revert(): Void {
        this.dataObject = (dropNode as DroppableNode).dataObject;
        (dropNode as DroppableNode).dataObject = null;
        (dropNode as DroppableNode).onRevert();
        reset();
    }

    public function reset() {
        dropIndicator = false;
        if (dragAnimate) {
            comeBack.evaluateKeyValues();
            comeBack.playFromStart();
        }
        translateX = initialTransX;
        translateY = initialTransY;
    }

    public function blockMouseActions() {
        for (i in allDraggables) {

            if (not (i as DraggableNode).equals(this)) {
                (i as DraggableNode).blocksMouse = false;

            }
        }
        otherNodesDraggable = false;
    }

    public function resumeMouseActions() {
        for (i in allDraggables) {

            if (not (i as DraggableNode).equals(this)) {
                (i as DraggableNode).blocksMouse = true;

            }
        }
        otherNodesDraggable = true;
    }

    /** just to override.*/
    override protected function create(): Node {
        return this;
    }

}
