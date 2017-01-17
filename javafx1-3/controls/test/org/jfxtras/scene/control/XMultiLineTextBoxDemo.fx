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

/**
 * Some simple examples. The second TextBox can be resized using the scroll wheel
 * @author Till Ballendat
 */

package org.jfxtras.scene.control;

import javafx.stage.Stage;
import javafx.scene.Scene;
import javafx.scene.paint.Color;
import javafx.scene.input.MouseEvent;
import javafx.scene.layout.VBox;

function createBoxes():XMultiLineTextBox[]{
    var javaFxStyledBox:XMultiLineTextBox = XMultiLineTextBox{
        width: 100
        height: 60
        onFocusHighlightColor: Color.CORNFLOWERBLUE
    }
    var resizeableBox:XMultiLineTextBox = XMultiLineTextBox{
        width: 200
        height: 40
        onMouseWheelMoved: function(e:MouseEvent){
            resizeableBox.width += e.wheelRotation;
            resizeableBox.height += e.wheelRotation;
        }
    }
    var customBox:XMultiLineTextBox = XMultiLineTextBox{
        width: 150
        height: 60
        borderColor: Color.ORANGE
        onFocusHighlightColor: Color.FIREBRICK
        arc: 20
    }
    return [javaFxStyledBox,resizeableBox,customBox];
}

Stage {
    title: "MultiLineTextBoxTest"
    width: 250
    height: 250
    scene: Scene {
        content: [
            VBox {
                content: createBoxes()
            }
        ]
    }
}