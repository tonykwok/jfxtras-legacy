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
package org.jfxtras.scene.layout;

import javafx.scene.text.*;
import javafx.scene.control.*;
import javafx.scene.paint.Color;
import javafx.scene.paint.LinearGradient;
import javafx.scene.paint.Stop;
import javafx.ext.swing.*;
import org.jfxtras.scene.*;
import org.jfxtras.scene.layout.XGridLayoutInfo.*;
import org.jfxtras.stage.*;

/**
 * @author Stephen Chin
 * @author Keith Combs
 */
XStage {
    title: "Span Layout"
    scene: XScene {
        width: 500
        height: 300
        fill: LinearGradient {
            endX: 0.0
            stops: [
                Stop {offset: 0.0, color: Color.WHITE},
                Stop {offset: 0.7, color: Color.web("#e8e8e8")},
                Stop {offset: 1.0, color: Color.SILVER},
            ]
        }
        def grid:XGrid = XGrid {
            spanToRowEnd: true
            animate: true
            layoutInfo: XGridLayoutInfo {margin: insets(10)}
            var list = ListView {
                items: for (i in [1..10]) "List item {i}";
                layoutInfo: XGridLayoutInfo {hspan: 3, vspan: 2}
            }
            rows: [
                row([Text {content: "Two Text Boxes:"}, TextBox {}, TextBox {}, Text {content: "Column 4"}]),
                row([Label {text: "Spanning Text Box:"}, TextBox {layoutInfo: XGridLayoutInfo {hspan: 2}}, Label {text: "Column 4-stretch"}]),
                row([Text {content: "Span Extends Boundary:"}, TextBox {layoutInfo: XGridLayoutInfo {hspan: 4}}]),
                row([Text {content: "Very Long..."}, list]),
                // Note: I put in an hspan here just to test the case where it conflicts with vspan...  conflicting cells are not supported and will simply overlap
                // Also, there is a button that will limit vspan of the list due to the conflict between spanToRowEnd and vspan.  This is expected.
                row([TextBox {text: "This is an error and should overlap", layoutInfo: XGridLayoutInfo {hspan: 2}}, Button {text: "I blocked the List"}]),
                row([SwingLabel {text: "Swing Label:"}, SwingTextField {layoutInfo: XGridLayoutInfo {hspan: 3}}]),
                row(CheckBox {text: "Animating", selected: bind grid.animate with inverse})
            ]
        }
        content: grid;
    }
}
