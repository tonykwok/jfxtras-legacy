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
import java.awt.Dimension;
import javafx.ext.swing.SwingComponent;
import javafx.scene.paint.Color;
import javafx.scene.shape.Rectangle;
import javafx.scene.layout.Container;
import javafx.scene.Cursor;
import javafx.scene.paint.Paint;
import javafx.animation.Timeline;
import javafx.animation.KeyFrame;
import javax.swing.JTextArea;
import org.jfxtras.scene.XCustomNode;
import org.jfxtras.scene.layout.XLayoutInfo;
import org.jfxtras.scene.layout.XLayoutInfo.*;
import org.jfxtras.scene.layout.XStack;

/**
 * The XMultiLineTextBox is a simple Swing Wrapper for the JTextArea. It can simulate the JavaFX looks if you set onFocusHighlightColor: CORNFLOWERBLUE
 * here is an easy example. Further Examples can be found in the MultiLineTextBoxTest class:
 *
 *   var m:XMultiLineTextBox = XMultiLineTextBox{
 *       width: 150
 *       height: 80
 *       onFocusHighlightColor: Color.CORNFLOWERBLUE
 *   }
 *
 * @author Till Ballendat
 */
public class XMultiLineTextBox extends XCustomNode {
    var textNode:Node;

    /**
     * Defines the height of the TextBox
     *
     * @defaultValue 20
     */
    override var height = 20 on replace {
        createTextArea();  // recreating the text area seems to be the only way to force a resize
    }

    /**
     * Defines the height of the TextBox
     *
     * @defaultValue 100
     */
    override var width = 100 on replace {
        createTextArea();  // recreating the text area seems to be the only way to force a resize
    }

    override public function getMinWidth() {0}
    override public function getMinHeight() {0}
    override public function getPrefWidth(height) {100}
    override public function getPrefHeight(width) {100}
    override public function getHFill() {true}
    override public function getVFill() {true}
    override public function getVGrow() {ALWAYS}
    override public function getHGrow() {ALWAYS}
    override public function getVShrink() {SOMETIMES}
    override public function getHShrink() {SOMETIMES}

    /**
     * Defines the Radius of the rounded corner of the XMultiLineTextBox
     *
     * @defaultValue 5
     */
    public-init var arc:Float = 5;

    /**
     * Defines a Color for the default border of the TextBox
     *
     * @defaultValue Color.rgb(130, 130, 130)
     */
    public-init var borderColor:Paint = Color.rgb(130, 130, 130);

    /**
     * Defines a Color for a highlighting border around the Textbox. Is is automatically shown when the TextBox has the Focus and is ready to get the users Keybord input. by default this is turned off.
    The standart javaFX light Blue border can be achieved by setting: onFocusHighlightColor: Color.CORNFLOWERBLUE
     *
     * @defaultValue null (off)
     */
    public-init var onFocusHighlightColor:Paint = null;

    var textBox:JTextArea;

    function createTextArea() {
        def previousText = if (textBox != null) textBox.getText() else "";
        textBox = new JTextArea();
        textBox.setPreferredSize(new Dimension(width,height));
        textBox.setEditable(true);
        textBox.setForeground(java.awt.Color.GREEN);
        textBox.setText(previousText);
        textNode = SwingComponent.wrap(textBox);
    }

    override public function create(): Node {
        createTextArea();

        var defaultBorder:Rectangle = Rectangle{
            height: bind height 
            width: bind width
            fill: null
            stroke: borderColor
            strokeWidth: 2
            arcHeight: arc
            arcWidth: arc
        };

        var multilineTextBox:Container = Container {
            cursor: Cursor.TEXT
            content: bind textNode
            height: bind height
            width: bind width
            clip: Rectangle{
                height: bind height
                width: bind width
                arcHeight: arc
                arcWidth: arc
            }
        };
        var returnGroup:XStack = XStack {content: [multilineTextBox, defaultBorder]}
        // this is necessary, because i found no way to use the java Listeners with javax
        if (onFocusHighlightColor != null) {
            Timeline {
                repeatCount: Timeline.INDEFINITE
                keyFrames : [KeyFrame {time : 100mscanSkip : true action: function(){selectBorder.stroke = getHighlightColor();}}]
            }.playFromStart();

            var selectBorder:Rectangle = Rectangle{
                translateX: -1
                translateY: -1
                height: bind height +2
                width: bind width +2
                fill: null
                strokeWidth: 3
                arcHeight: arc+1
                arcWidth: arc+1
            };
            insert selectBorder after returnGroup.content[0];
        }
        return returnGroup;
    }

    /**
     * Returns the text currently displayed inside the XMultiLineTextBox as a String.
     *
     * @return The text currently displayed inside the XMultiLineTextBox
     */
    public function getText():String{return textBox.getText();}

    function getHighlightColor():Paint{
        if(focused or textBox.hasFocus()){
            return onFocusHighlightColor;
        }
        else{return Color.rgb(0,0,0,0);}
    }
}
