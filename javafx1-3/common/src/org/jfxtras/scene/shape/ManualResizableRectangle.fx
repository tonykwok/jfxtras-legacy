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

package org.jfxtras.scene.shape;

import javafx.scene.CustomNode;
import javafx.scene.shape.Rectangle;
import javafx.scene.paint.Paint;
import javafx.scene.paint.Color;
import javafx.scene.Group;
import javafx.scene.Node;
import javafx.scene.input.MouseEvent;
import javafx.scene.Cursor;

/**
 * <p>The {@code ManualResizableRectangle} class defines a rectangle that can
 * be manually resized.</p>
 *
 @example
 import org.jfxtras.scene.shape.ManualResizableRectangle;
 import javafx.scene.paint.*;

    ManualResizableRectangle {
        fill: Color.BLUE
        width: 200
        height: 200
        arcWidth: 20
        arcHeight: 20
        clickAreaWidth:10
        maxWidth: 250
        maxHeight: 250
        minWidth: 30
        minHeight: 30
        enableHorizontalResize: true;
        enableVerticalResize: true;
        enableMove: true;
    }
    @endexample
 *
 * @profile common
 *
 * @author Yannick Van Godtsenhoven <yannick@jfxperience.com>
 */

public class ManualResizableRectangle extends CustomNode{

    public def rectangle:Rectangle = Rectangle{};
    def SPACE = 1;
    def clickColor = Color.TRANSPARENT;

    var oldRectangleX;
    var oldRectangleY;
    var oldRectangleWidth;
    var oldRectangleHeight;
    var oldRectangleMinY;

    def leftClickArea:Rectangle = Rectangle{
        x: bind rectangle.x - (clickAreaWidth/2)
        y: bind rectangle.y + (3*clickAreaWidth/2) + SPACE
        width: bind clickAreaWidth
        height: bind rectangle.height - (6*clickAreaWidth/2) - 2*SPACE
        fill: clickColor
        onMouseEntered: function(me:MouseEvent) {
            if(enableHorizontalResize){
                cursor = Cursor.H_RESIZE;
            }
        }
        onMouseExited: function(me:MouseEvent) {
            if(enableHorizontalResize){
                cursor = Cursor.DEFAULT;
            }
        }
        onMousePressed: function(me:MouseEvent) {
            if(enableHorizontalResize){
                storeLeftResize();
            }
        }
        onMouseDragged: function(me:MouseEvent) {
            if(enableHorizontalResize and maxLeftWidthNotReached(me)
                and minLeftWidthNotReached(me)){
                leftResize(me);
            }
        }
        onMouseReleased: function(me:MouseEvent) {
            if(enableHorizontalResize){
                correctLeftWidthToSteps();
                storeLeftResize();
            }
        }
    }

    def rightClickArea:Rectangle = Rectangle{
        x: bind rectangle.x + rectangle.width - (clickAreaWidth/2)
        y: bind rectangle.y + (3*clickAreaWidth/2) + SPACE
        width: bind clickAreaWidth
        height: bind rectangle.height - (6*clickAreaWidth/2) - 2*SPACE
        fill: clickColor
        onMouseEntered: function(me:MouseEvent) {
            if(enableHorizontalResize){
                cursor = Cursor.H_RESIZE;
            }
        }
        onMouseExited: function(me:MouseEvent) {
            if(enableHorizontalResize){
                cursor = Cursor.DEFAULT;
            }
        }
        onMousePressed: function(me:MouseEvent) {
            if(enableHorizontalResize){
                storeRightResize()
            }
        }
        onMouseDragged: function(me:MouseEvent) {
            if(enableHorizontalResize and maxRightWidthNotReached(me)
                   and minRightWidthNotReached(me)){
                rightResize(me);
            }
        }
        onMouseReleased: function(me:MouseEvent) {
            if(enableHorizontalResize){
                correctRightWidthToSteps();
                storeRightResize()
            }
        }
    }

    def upperClickArea:Rectangle = Rectangle{
        x: bind rectangle.x + (3*clickAreaWidth/2) + SPACE
        y: bind rectangle.y - (clickAreaWidth/2)
        width: bind rectangle.width - (6*clickAreaWidth/2) - 2*SPACE
        height: bind clickAreaWidth
        fill: clickColor
        onMouseEntered: function(me:MouseEvent) {
            if(enableVerticalResize){
                cursor = Cursor.V_RESIZE;
            }
        }
        onMouseExited: function(me:MouseEvent) {
            if(enableVerticalResize){
                cursor = Cursor.DEFAULT;
            }
        }
        onMousePressed: function(me:MouseEvent) {
            if(enableVerticalResize){
                storeUpperResize();
            }
        }
        onMouseDragged: function(me:MouseEvent) {
            if(enableVerticalResize and maxUpperHeightNotReached(me)
                and minUpperHeightNotReached(me)){
                upperResize(me);
            }
        }
        onMouseReleased: function(me:MouseEvent) {
            if(enableVerticalResize){
                correctUpperHeightToSteps();
                storeUpperResize();
            }
        }
    }

    def lowerClickArea:Rectangle = Rectangle{
        x: bind rectangle.x + (3*clickAreaWidth/2) + SPACE
        y: bind rectangle.y + rectangle.height - (clickAreaWidth/2)
        width: bind rectangle.width - (6*clickAreaWidth/2) - 2*SPACE
        height: bind clickAreaWidth
        fill: clickColor
        onMouseEntered: function(me:MouseEvent) {
            if(enableVerticalResize){
                cursor = Cursor.V_RESIZE;
            }
        }
        onMouseExited: function(me:MouseEvent) {
            if(enableVerticalResize){
                cursor = Cursor.DEFAULT;
            }
        }
        onMousePressed: function(me:MouseEvent) {
            if(enableVerticalResize){
                storeLowerResize()
            }
        }
        onMouseDragged: function(me:MouseEvent) {
            if(enableVerticalResize and maxLowerHeightNotReached(me)
                and minLowerHeightNotReached(me)){
                lowerResize(me);
            }
        }
        onMouseReleased: function(me:MouseEvent) {
            if(enableVerticalResize){
                correctLowerHeightToSteps();
                storeLowerResize()
            }
        }
    }

    def upperLeftClickArea:Rectangle = Rectangle{
        x: bind rectangle.x - (clickAreaWidth/2)
        y: bind rectangle.y - (clickAreaWidth/2)
        width: bind clickAreaWidth*2
        height: bind clickAreaWidth*2
        fill: clickColor
        onMouseEntered: function(me:MouseEvent) {
            if(enableHorizontalResize and enableVerticalResize){
                cursor = Cursor.NW_RESIZE
            }
        }
        onMouseExited: function(me:MouseEvent) {
            if(enableHorizontalResize and enableVerticalResize){
                cursor = Cursor.DEFAULT;
            }
        }
        onMousePressed: function(me:MouseEvent) {
            if(enableHorizontalResize and enableVerticalResize){
                storeLeftResize();
                storeUpperResize();
            }
        }
        onMouseDragged: function(me:MouseEvent) {
            if(enableHorizontalResize and maxLeftWidthNotReached(me)
                and minLeftWidthNotReached(me)){
                leftResize(me);
            }
            if(enableVerticalResize and maxUpperHeightNotReached(me)
                and minUpperHeightNotReached(me)){
                upperResize(me);
            }
        }
        onMouseReleased: function(me:MouseEvent) {
            if(enableHorizontalResize and enableVerticalResize){
                correctLeftWidthToSteps();
                correctUpperHeightToSteps();
                storeLeftResize();
                storeUpperResize();
            }
        }
    }

    def lowerLeftClickArea:Rectangle = Rectangle{
        x: bind rectangle.x - (clickAreaWidth/2)
        y: bind rectangle.y + rectangle.height - (3*clickAreaWidth/2)
        width: bind clickAreaWidth*2
        height: bind clickAreaWidth*2
        fill: clickColor
        onMouseEntered: function(me:MouseEvent) {
            if(enableHorizontalResize and enableVerticalResize){
                cursor = Cursor.SW_RESIZE
            }
        }
        onMouseExited: function(me:MouseEvent) {
            if(enableHorizontalResize and enableVerticalResize){
                cursor = Cursor.DEFAULT;
            }
        }
        onMousePressed: function(me:MouseEvent) {
            if(enableHorizontalResize and enableVerticalResize){
                storeLeftResize();
                storeLowerResize();
            }
        }
        onMouseDragged: function(me:MouseEvent) {
            if(enableHorizontalResize and maxLeftWidthNotReached(me)
                and minLeftWidthNotReached(me)){
                leftResize(me);
            }
            if(enableVerticalResize and maxLowerHeightNotReached(me)
                and minLowerHeightNotReached(me)){
                lowerResize(me);
            }
        }
        onMouseReleased: function(me:MouseEvent) {
            if(enableHorizontalResize and enableVerticalResize){
                correctLeftWidthToSteps();
                correctLowerHeightToSteps();
                storeLeftResize();
                storeLowerResize();
            }
        }
    }

    def upperRightClickArea:Rectangle = Rectangle{
        x: bind rectangle.x + rectangle.width - (3*clickAreaWidth/2)
        y: bind rectangle.y - (clickAreaWidth/2)
        width: bind clickAreaWidth*2
        height: bind clickAreaWidth*2
        fill: clickColor
        onMouseEntered: function(me:MouseEvent) {
            if(enableHorizontalResize and enableVerticalResize){
                cursor = Cursor.NE_RESIZE
            }
        }
        onMouseExited: function(me:MouseEvent) {
            if(enableHorizontalResize and enableVerticalResize){
                cursor = Cursor.DEFAULT;
            }
        }
        onMousePressed: function(me:MouseEvent) {
            if(enableHorizontalResize and enableVerticalResize){
                storeRightResize();
                storeUpperResize();
            }
        }
        onMouseDragged: function(me:MouseEvent) {
            if(enableHorizontalResize and maxRightWidthNotReached(me)
                and minRightWidthNotReached(me)){
                rightResize(me);
            }
            if(enableVerticalResize and maxUpperHeightNotReached(me)
                and minUpperHeightNotReached(me)){
                upperResize(me);
            }
        }
        onMouseReleased: function(me:MouseEvent) {
            if(enableHorizontalResize and enableVerticalResize){
                correctRightWidthToSteps();
                correctUpperHeightToSteps();
                storeRightResize();
                storeUpperResize();
            }
        }
    }

    def lowerRightClickArea:Rectangle = Rectangle{
        x: bind rectangle.x + rectangle.width - (3*clickAreaWidth/2)
        y: bind rectangle.y + rectangle.height - (3*clickAreaWidth/2)
        width: bind clickAreaWidth*2
        height: bind clickAreaWidth*2
        fill: clickColor
        onMouseEntered: function(me:MouseEvent) {
            if(enableHorizontalResize and enableVerticalResize){
                cursor = Cursor.SE_RESIZE
            }
        }
        onMouseExited: function(me:MouseEvent) {
            if(enableHorizontalResize and enableVerticalResize){
                cursor = Cursor.DEFAULT;
            }
        }
        onMousePressed: function(me:MouseEvent) {
            if(enableHorizontalResize and enableVerticalResize){
                storeRightResize();
                storeLowerResize()
            }
        }
        onMouseDragged: function(me:MouseEvent) {
            if(enableHorizontalResize and maxRightWidthNotReached(me)
                and minRightWidthNotReached(me)){
                rightResize(me);
            }
            if(enableVerticalResize and maxLowerHeightNotReached(me)
                and minLowerHeightNotReached(me)){
                lowerResize(me);
            }
        }
        onMouseReleased: function(me:MouseEvent) {
            if(enableHorizontalResize and enableVerticalResize){
                correctRightWidthToSteps();
                correctLowerHeightToSteps();
                storeRightResize();
                storeLowerResize()
            }
        }
    }

    def moveRectangle:Rectangle = Rectangle{
        x: bind upperClickArea.x;
        y: bind leftClickArea.y;
        width: bind upperClickArea.width;
        height: bind leftClickArea.height;
        fill: clickColor
        onMouseEntered: function(me:MouseEvent) {
            if(enableMove){
                cursor = Cursor.HAND;
            }
        }
        onMouseExited: function(me:MouseEvent) {
            if(enableMove){
                cursor = Cursor.DEFAULT;
            }
        }
        onMousePressed: function(me:MouseEvent) {
            if(enableMove){
                storePosition();
            }
        }
        onMouseDragged: function(me:MouseEvent) {
            if(enableMove){
                rectangle.x = oldRectangleX + me.dragX;
                rectangle.y = oldRectangleY + me.dragY;
            }
        }
        onMouseReleased: function(me:MouseEvent) {
            if(enableMove){
                storePosition();
            }
        }
    };

    function storePosition() {
        oldRectangleX = rectangle.x;
        oldRectangleY = rectangle.y;
    }

    function storeLeftResize() {
        oldRectangleX = rectangle.x;
        oldRectangleWidth = rectangle.width;
    }

    function leftResize(me:MouseEvent) {
        rectangle.x = oldRectangleX + me.dragX;
        rectangle.width = oldRectangleWidth - (me.dragX);
    }

    function storeRightResize() {
        oldRectangleWidth = rectangle.width;
    }

    function rightResize(me:MouseEvent) {
        rectangle.width = oldRectangleWidth + (me.dragX);
    }

    function storeUpperResize() {
        oldRectangleY = rectangle.layoutBounds.minY;
        oldRectangleHeight = rectangle.layoutBounds.height;
        oldRectangleMinY = rectangle.layoutBounds.maxY;
    }

    function upperResize(me:MouseEvent) {
        def newY = oldRectangleY + me.dragY;
        def newHeight = oldRectangleHeight - (me.dragY);


        rectangle.y = newY;
        rectangle.height = newHeight;
    }

    function storeLowerResize() {
        oldRectangleHeight = rectangle.height;
    }

    function lowerResize(me:MouseEvent) {
        rectangle.height = oldRectangleHeight + (me.dragY);
    }

    function maxLeftWidthNotReached(me:MouseEvent):Boolean {
        if( maxWidth != 0 and (oldRectangleWidth - me.dragX)  > maxWidth) {
            return false;
        } else {
            return true;
        }
    }

    function maxRightWidthNotReached(me:MouseEvent):Boolean {
        if( maxWidth != 0 and (oldRectangleWidth + me.dragX)  > maxWidth) {
            return false;
        } else {
            return true;
        }
    }

    function maxUpperHeightNotReached(me:MouseEvent):Boolean {
        if( maxHeight != 0 and (oldRectangleHeight - me.dragY)  > maxHeight) {
            return false;
        } else {
            return true;
        }
    }

    function maxLowerHeightNotReached(me:MouseEvent):Boolean {
        if( maxHeight != 0 and (oldRectangleHeight + me.dragY)  > maxHeight) {
            return false;
        } else {
            return true;
        }
    }

    function minLeftWidthNotReached(me:MouseEvent):Boolean {
        if( minWidth != 0 and (oldRectangleWidth - me.dragX)  < minWidth) {
            //too fix width when dragging too fast
            //rectangle.width = minWidth;
            return false;
        } else {
            return true;
        }
    }

    function minRightWidthNotReached(me:MouseEvent):Boolean {
        if( minWidth != 0 and (oldRectangleWidth + me.dragX)  < minWidth) {
            return false;
        } else {
            return true;
        }
    }

    function minUpperHeightNotReached(me:MouseEvent):Boolean {
        if( minHeight != 0 and (oldRectangleHeight - me.dragY)  < minHeight) {
            return false;
        } else {

            return true;
        }
    }

    function minLowerHeightNotReached(me:MouseEvent):Boolean {
        if( minHeight != 0 and (oldRectangleHeight + me.dragY)  < minHeight) {
            return false;
        } else {

            return true;
        }
    }

    function correctLeftWidthToSteps() {
        def oldWidth = rectangle.width;
        def remainder = rectangle.width mod horizontalSteps;
        def number:Integer = (rectangle.width/horizontalSteps) as Integer;
        if(remainder != 0 and remainder >= horizontalSteps/2){
            var futureWidth = (number+1)*horizontalSteps;
            if(futureWidth > maxWidth) {
                futureWidth = maxWidth;
            }
            rectangle.width = futureWidth;
            def difference = rectangle.width - oldWidth;
            rectangle.x = rectangle.x - difference;
        } else if(remainder != 0 and remainder < horizontalSteps/2){
            var futureWidth = (number)*horizontalSteps;
            if(futureWidth < minWidth) {
                futureWidth = minWidth;
            }
            rectangle.width = futureWidth;
            def difference = oldWidth - rectangle.width;
            rectangle.x = rectangle.x + difference;
        }
    }

     function correctRightWidthToSteps() {
        def oldWidth = rectangle.width;
        def remainder = rectangle.width mod horizontalSteps;
        def number:Integer = (rectangle.width/horizontalSteps) as Integer;
        if(remainder != 0 and remainder >= horizontalSteps/2){
            var futureWidth = (number+1)*horizontalSteps;
            if(futureWidth > maxWidth) {
                futureWidth = maxWidth;
            }
            rectangle.width = futureWidth;
        } else if(remainder != 0 and remainder < horizontalSteps/2){
            var futureWidth = (number)*horizontalSteps;
            if(futureWidth < minWidth) {
                futureWidth = minWidth;
            }
            rectangle.width = futureWidth;
        }
    }

    function correctUpperHeightToSteps() {
        def oldHeight = rectangle.height;
        def remainder = rectangle.height mod verticalSteps;
        def number:Integer = (rectangle.height/verticalSteps) as Integer;
        if(remainder != 0 and remainder >= verticalSteps/2){
            var futureHeigth = (number+1)*verticalSteps;
            if(futureHeigth > maxHeight) {
                futureHeigth = maxHeight;
            }
            rectangle.height = futureHeigth;
            def difference = rectangle.height - oldHeight;
            rectangle.y = rectangle.y - difference;
        } else if(remainder != 0 and remainder < verticalSteps/2){
            var futureHeigth = (number)*verticalSteps;
            if(futureHeigth < minHeight) {
                futureHeigth = minHeight;
            }
            rectangle.height = futureHeigth;
            def difference = oldHeight - rectangle.height;
            rectangle.y = rectangle.y + difference;
        }
    }

    function correctLowerHeightToSteps() {
        def oldHeight = rectangle.height;
        def remainder = rectangle.height mod verticalSteps;
        def number:Integer = (rectangle.height/verticalSteps) as Integer;
        if(remainder != 0 and remainder >= verticalSteps/2){
            var futureHeigth = (number+1)*verticalSteps;
            if(futureHeigth > maxHeight) {
                futureHeigth = maxHeight;
            }
            rectangle.height = futureHeigth;
        } else if(remainder != 0 and remainder < verticalSteps/2){
            var futureHeigth = (number)*verticalSteps;
            if(futureHeigth < minHeight) {
                futureHeigth = minHeight;
            }
            rectangle.height = futureHeigth;
        }

    }

    /**
     * Defines the pixel width of the clickable area used to resize the rectangle.
     * @defaultvalue 5
     */
    public var clickAreaWidth = 5;

    /**
     * Enables or disables horizontal resizing of the rectangle.
     * @defaultvalue false
     */
    public var enableHorizontalResize = false;

    /**
     * Enables or disables vertical resizing of the rectangle.
     * @defaultvalue false
     */
    public var enableVerticalResize = false;

    /**
     * Enables or disables moving of the rectangle.
     * @defaultvalue false
     */
    public var enableMove = false;

    /**
     * Defines the maximum width of the rectangle. Trying to resize it bigger
     * than this value will not do anything. A value of 0 (zero) means that
     * no maximum width has ben set and the rectangle can be resized without any limitations.
     * @defaultvalue 0
     */
    public var maxWidth = 0;

    /**
     * Defines the maximum height of the rectangle. Trying to resize it bigger
     * than this value will not do anything. A value of 0 (zero) means that
     * no maximum height has ben set and the rectangle can be resized without any limitations.
     * @defaultvalue 0
     */
    public var maxHeight = 0;

    /**
     * Defines the minimum width of the rectangle. Trying to resize it smaller
     * than this value will not do anything. A value of 0 (zero) means that
     * no minimum width has ben set and the rectangle can be resized without any limitations.
     * @defaultvalue 0
     */
    public var minWidth = 0;

    /**
     * Defines the minimum height of the rectangle. Trying to resize it smaller
     * than this value will not do anything. A value of 0 (zero) means that
     * no minimum height has ben set and the rectangle can be resized without any limitations.
     * @defaultvalue 0
     */
    public var minHeight = 0;

    /**
     * Defines the steps in which the rectangle can be resized horizontally.
     * This means that the width of the rectangle will always a number of times the stepsize.
     * When resizing it, the width of the rectangle will automatically be changed to an allowed
     * width closest to the one that was chosen. A value of 0 (zero) means that
     * no step size has ben set and the rectangle can be resized without any limitations.
     * @defaultvalue 0
     */
    public var horizontalSteps = 0;

    /**
     * Defines the steps in which the rectangle can be resized vertically.
     * This means that the height of the rectangle will always a number of times the stepsize.
     * When resizing it, the height of the rectangle will automatically be changed to an allowed
     * height closest to the one that was chosen. A value of 0 (zero) means that
     * no step size has ben set and the rectangle can be resized without any limitations.
     * @defaultvalue 0
     */
    public var verticalSteps = 0;

    public var x = 0.0 on replace {
        rectangle.x = x;
    }

    public var y = 0.0 on replace {
        rectangle.y = y;
    }

    public var arcHeight = 0.0 on replace {
        rectangle.arcHeight = arcHeight;
    }

    public var arcWidth = 0.0 on replace {
        rectangle.arcWidth = arcWidth;
    }

    public var fill:Paint on replace {
        rectangle.fill = fill;
    }

    public var width = 0 on replace {
        rectangle.width = width;
    }

    public var height = 0 on replace {
        rectangle.height = height;
    }

    def contentItem:Group = Group {
        content: [rectangle, moveRectangle, leftClickArea, rightClickArea, upperClickArea, lowerClickArea, upperLeftClickArea, lowerLeftClickArea, upperRightClickArea, lowerRightClickArea]
    }

    override function create():Node {
        return contentItem;
    }
}