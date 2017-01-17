/**
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

package org.jfxtras.scene.layout;

import javafx.animation.Interpolator;
import javafx.animation.KeyFrame;
import javafx.animation.Timeline;
import javafx.scene.Node;
import javafx.geometry.Bounds;
import javafx.geometry.HPos;
import javafx.geometry.Insets;
import javafx.geometry.VPos;
import javafx.scene.layout.Container;
import javafx.scene.layout.Priority;
import javafx.scene.layout.Resizable;
import javafx.util.Math;
import javafx.util.Sequences;
import org.jfxtras.util.XMap;

/**
 * JFXtras extension of Container that provides versions of all the static
 * helper functions that respect XLayoutInfo.grow.
 *
 * @author Stephen Chin
 */
public class XContainer extends Container, Resizable {
    public var animate = false;

    public var animationDuration:Duration = 500ms;

    public var animationInterpolator = Interpolator.EASEOUT;

    protected var animatePosition = bind animate;

    protected var animateSize = bind animate;

    override function getHFill() {true}

    override function getVFill() {true}

    override function getHGrow() {maxPriority(for (node in content where node.managed) getNodeHGrow(node))}

    override function getVGrow() {maxPriority(for (node in content where node.managed) getNodeVGrow(node))}

    override function getHShrink() {maxPriority(for (node in content where node.managed) getNodeHShrink(node))}

    override function getVShrink() {maxPriority(for (node in content where node.managed) getNodeVShrink(node))}
}

/**
 * Utility function which returns the sequence of nodes within the content
 * whose layout should be managed by its container.
 */
public function getManaged(content:Node[]):Node[] {
    return content[n|n.managed];
}

/**
 * Utility function which returns the horizontal layout position of the Node
 * which defines how the node should be horizontally aligned within its layout
 * space if the width of the layout space is greater than the layout bounds
 * width of the node.
 * <p>
 * This version has no user default and will rely on class defaults instead.
 */
public function getNodeHPos(node:Node):HPos {
    getNodeHPos(node, null);
}

/**
 * Utility function which returns the vertical layout position of the Node
 * which defines how the node should be vertically aligned within its layout
 * space if the height of the layout space is greater than the layout bounds
 * height of the node.
 * <p>
 * This version has no user default and will rely on class defaults instead.
 */
public function getNodeVPos(node:Node):VPos {
    getNodeVPos(node, null);
}

/**
 * Utility function which returns the preferred height of the Node.
 */
public function getNodePrefHeight(node:Node):Number {
    return getNodePrefHeight(node, -1);
}

/**
 * Utility function which returns the preferred width of the Node.
 */
public function getNodePrefWidth(node:Node):Number {
    return getNodePrefWidth(node, -1);
}

/**
 * Utility function which returns the hfill of the Node.
 */
public function getNodeHFill(node:Node):Boolean {
    return getNodeHFill(node, false);
}

/**
 * Utility function which returns the vfill of the Node.
 */
public function getNodeVFill(node:Node):Boolean {
    return getNodeVFill(node, false);
}

/**
 * Utility function which returns the horizontal span of the Node.
 */
public function getNodeHSpan(node:Node):Integer {
    if (node.layoutInfo instanceof XGridLayoutInfo) {
        def gli = node.layoutInfo as XGridLayoutInfo;
        if (isInitialized(gli.hspan)) {
            return Math.max(1, gli.hspan);
        }
    }
    return 1;
}

/**
 * Utility function which returns the vertical span of the Node.
 */
public function getNodeVSpan(node:Node):Integer {
    if (node.layoutInfo instanceof XGridLayoutInfo) {
        def gli = node.layoutInfo as XGridLayoutInfo;
        if (isInitialized(gli.vspan)) {
            return Math.max(1, gli.vspan);
        }
    }
    return 1;
}

def EMPTY_MARGIN = XLayoutInfo.insets(0, 0, 0, 0);

/**
 * Utility function which returns the horizontal Margin of the Node.
 */
public function getNodeMargin(node:Node):Insets {
    if (node.layoutInfo instanceof XLayoutInfo) {
        def xli = node.layoutInfo as XLayoutInfo;
        if (isInitialized(xli.margin)) {
            return xli.margin;
        }
    }
    return EMPTY_MARGIN;
}

/**
 * Utility function which returns the width of the Margin for the given Node.
 */
public function getNodeMarginWidth(node:Node):Float {
    def margin = getNodeMargin(node);
    return margin.left + margin.right;
}

/**
 * Utility function which returns the height of the Margin for the given Node.
 */
public function getNodeMarginHeight(node:Node):Float {
    def margin = getNodeMargin(node);
    return margin.top + margin.bottom;
}

public function layoutNode(node:Node, x:Number, y:Number, width:Number, height:Number):Boolean {
    return layoutNode(node, x, y, width, height, false);
}

public function layoutNode(node:Node, x:Number, y:Number, width:Number, height:Number, snapToPixel:Boolean):Boolean {
    def resized = resizeNode(node, width, height);
    positionNode(node, x, y);
    return resized;
}

public function layoutNode(node:Node, areaX:Number, areaY:Number, areaWidth:Number, areaHeight:Number, hpos:HPos, vpos:VPos):Boolean {
    return layoutNode(node, areaX, areaY, areaWidth, areaHeight, -1, true, true, hpos, vpos, false);
}

/**
 * Utility function which lays out the node relative to the specified layout
 * area defined by areaX, areaY, areaW x areaH.
 * <p>
 * This differs from Container.layoutNode, because it also takes into account
 * XLayoutInfo.fill, and will attempt to constrain the node to fit the
 * bounding box.
 */
// todo 1.3 - compare this against the 1.3 function to see if there are any differences...
// big differences:
// * implement snapToPixel
// * implement baseLine
// * consolidate margin functions?
public function layoutNode(node:Node, areaX:Number, areaY:Number, areaWidth:Number, areaHeight:Number, areaBaselineOffset:Number, hfill:Boolean, vfill:Boolean, hpos:HPos, vpos:VPos, snapToPixel:Boolean):Boolean {
    def hposNode = getNodeHPos(node, if (hpos == null) HPos.CENTER else hpos);
    def vposNode = getNodeVPos(node, if (vpos == null) VPos.CENTER else vpos);
    def hfillNode = getNodeHFill(node, hfill);
    def vfillNode = getNodeVFill(node, vfill);
    def margin = getNodeMargin(node);
    def marginWidth = margin.left + margin.right;
    def marginHeight = margin.top + margin.bottom;
    var resized = false;
    var newWidth:Number;
    var newHeight:Number;
    def layoutBounds = getLayoutBounds(node);
    if (node instanceof Resizable) {
        def prefHMaxBound = if (not hfillNode) getNodePrefWidth(node) else Number.MAX_VALUE;
        newWidth = Math.max(getNodeMinWidth(node), Math.min(getNodeMaxWidth(node), Math.min(prefHMaxBound, areaWidth - marginWidth)));
        def prefVMaxBound = if (not vfillNode) getNodePrefHeight(node) else Number.MAX_VALUE;
        newHeight = Math.max(getNodeMinHeight(node), Math.min(getNodeMaxHeight(node), Math.min(prefVMaxBound, areaHeight - marginHeight)));
        resized = resizeNode(node, newWidth, newHeight);
    } else {
        newWidth = layoutBounds.width;
        newHeight = layoutBounds.height;
    }
    var newX = areaX;
    var newY = areaY;
    if (hposNode == HPos.LEFT) {
        newX += margin.left;
    } else if (hposNode == HPos.CENTER) {
        newX += margin.left + (areaWidth - marginWidth - newWidth) / 2;
    } else if (hposNode == HPos.RIGHT or hposNode == HPos.TRAILING) {
        newX += areaWidth - margin.right - newWidth;
    }
    if (vposNode == VPos.TOP or vposNode == VPos.PAGE_START) {
        newY += margin.top;
    } else if (vposNode == VPos.CENTER) {
        newY += margin.top + (areaHeight - marginHeight - newHeight) / 2;
    } else if (vposNode == VPos.BOTTOM or vposNode == VPos.PAGE_END) {
        newY += areaHeight - margin.bottom - newHeight;
    } else if (vposNode == VPos.BASELINE) {
        // todo 1.3 - use the new baseline support
        // note: algorithm is wrong in the case where minY fluctuates
        newY += (areaHeight + layoutBounds.minY) / 2;
    }
    positionNode(node, newX, newY);
    return resized;
}

public function maxPriority(priorities:Priority[]):Priority {
    if (sizeof priorities == 0) return Priority.NEVER;
    Sequences.max(priorities, PriorityComparator {}) as Priority
}

public function minPriority(priorities:Priority[]):Priority {
    if (sizeof priorities == 0) return Priority.ALWAYS;
    Sequences.min(priorities, PriorityComparator {}) as Priority
}

function getJFXContainer(node:Node):XContainer {
    var parent = node.parent;
    while (parent != null and not (parent instanceof XContainer)) {
        parent = parent.parent;
    }
    return parent as XContainer;
}

function childAnimating(map:XMap, node:Node):Boolean {
    for (entry in map.entries) {
        var parent = entry.key as Node;
        while (parent != null) {
            parent = parent.parent;
            if (parent == node) return true;
        }
    }
    return false;
}

public function positionNode(node:Node, x:Number, y:Number):Void {
    def newX = x - getLayoutBounds(node).minX;
    def newY = y - getLayoutBounds(node).minY;
    if (newX != node.layoutX or newY != node.layoutY) {
        if (getJFXContainer(node).animatePosition) {
            doPositionAnimation(node, newX, newY);
        } else if (not isReadOnly(node.layoutX) and not isReadOnly(node.layoutY)) {
            node.layoutX = newX;
            node.layoutY = newY;
        }
    }
}

public function resizeNode(node:Node, width:Number, height:Number):Boolean {
    if (not (node instanceof Resizable)) return false;
    def resizable = node as Resizable;
    if (width != resizable.width or height != resizable.height) {
        if (getJFXContainer(node).animateSize and not childAnimating(layoutSizeAnimations, node)) {
            return doSizeAnimation(node, width, height);
        } else if (not isReadOnly(resizable.width) and not isReadOnly(resizable.height)) {
            resizable.width = width;
            resizable.height = height;
            return true;
        }
    }
    return false;
}

abstract class LayoutAnimation {
    public-init var node:Node;
    var timeline:Timeline;
    def container = getJFXContainer(node);
}

def layoutPositionAnimations = XMap {};

function doPositionAnimation(node:Node, x:Number, y:Number):Void {
    var animation = layoutPositionAnimations.get(node) as LayoutPositionAnimation;
    if (animation == null) {
        animation = LayoutPositionAnimation {node: node}
        layoutPositionAnimations.put(node, animation);
    } else {
        if (animation.targetX == x and animation.targetY == y) return;
    }
    animation.animateTo(x, y);
}

class LayoutPositionAnimation extends LayoutAnimation {
    var targetX:Number;
    var targetY:Number;
    init {
        layoutPositionAnimations.put(node, this);
    }
    public function animateTo(targetX:Number, targetY:Number) {
        this.targetX = targetX;
        this.targetY = targetY;
        if (timeline != null) {
            timeline.pause();
        }
        timeline = Timeline {
            keyFrames: KeyFrame {
                def n = node;
                time: container.animationDuration
                values: [
                    n.layoutX => targetX tween container.animationInterpolator,
                    n.layoutY => targetY tween container.animationInterpolator
                ]
                action: function() {
                    layoutPositionAnimations.remove(node);
                }
                canSkip: true
            }
        }
        timeline.play();
    }
}

def layoutSizeAnimations = XMap {};

public function getLayoutBounds(node:Node):Bounds {
    if (layoutSizeAnimations.containsKey(node)) {
        def animation = layoutSizeAnimations.get(node) as LayoutSizeAnimation;
        return animation.targetLayoutBounds;
    } else {
        return node.layoutBounds;
    }
}

function doSizeAnimation(node:Node, width:Number, height:Number):Boolean {
    var animation = layoutSizeAnimations.get(node) as LayoutSizeAnimation;
    if (animation == null) {
        animation = LayoutSizeAnimation {node: node}
    } else {
        if (animation.targetWidth == width and animation.targetHeight == height) return false;
    }
    animation.animateTo(width, height);
}

class LayoutSizeAnimation extends LayoutAnimation {
    public-read var targetLayoutBounds:Bounds;
    var targetWidth:Number;
    var targetHeight:Number;
    init {
        layoutSizeAnimations.put(node, this);
    }
    function calculateTargetLayoutBounds(targetWidth:Number, targetHeight:Number) {
        def resizable = node as Resizable;
        def originalWidth = resizable.width;
        def originalHeight = resizable.height;
        resizable.width = targetWidth;
        resizable.height = targetHeight;
        targetLayoutBounds = node.layoutBounds;
        resizable.width = originalWidth;
        resizable.height = originalHeight;
    }
    public function animateTo(targetWidth:Number, targetHeight:Number):Boolean {
        this.targetWidth = targetWidth;
        this.targetHeight = targetHeight;
        calculateTargetLayoutBounds(targetWidth, targetHeight);
        if (timeline != null) {
            timeline.pause();
        }
        timeline = Timeline {
            def resizable = node as Resizable;
            keyFrames: KeyFrame {
                time: container.animationDuration
                values: [
                    resizable.width => targetWidth tween container.animationInterpolator,
                    resizable.height => targetHeight tween container.animationInterpolator
                ]
                action: function() {
                    layoutSizeAnimations.remove(node);
                }
                canSkip: true
            }
        }
        timeline.play();
        return true;
    }
}
