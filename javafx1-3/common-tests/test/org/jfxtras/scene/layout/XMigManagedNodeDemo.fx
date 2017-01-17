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

/*
 * MigManagedNodeTest.fx
 *
 * Created on May 19, 2009, 6:52:56 PM
 */

package org.jfxtras.scene.layout;

import javafx.stage.Stage;
import javafx.scene.Scene;
import javafx.scene.text.Text;
import javafx.scene.control.Button;
import javafx.scene.text.TextOrigin;
import javafx.scene.control.CheckBox;

import javafx.animation.Timeline;

import javafx.animation.Interpolator;

/**
 * @author dean
 */

var text:Text;
var managedCheckBox:CheckBox;

Stage {
    title: "Mig Managed Node Test"
    scene: Scene {
        width: 400
        content: XMigLayout {
            constraints: "fill, wrap"
            columns: "[150!][150!]"
            content: [
                Button {
                  text: "Button 1,1"
                }
                Button {
                  text: "Button 1,2"
                }
                managedCheckBox = CheckBox {
                  text: "Text is managed?"
                  selected: true
                }
                text = Text {
                    content: bind if (managedCheckBox.selected) "Managed Text" else "Unmanaged Text"
                    managed: bind managedCheckBox.selected
                    textOrigin: TextOrigin.TOP
                }
                Button {
                  text: "Button 3,1"
                }
                Button {
                  text: "Button 3,2"
                }
            ]
        }
    }
}

var textManaged = bind text.managed on replace {
    // When the text is not managed we can lay it out as we please
    if (not textManaged) {
        Timeline {
            def targetNode = text;
            keyFrames: [
                at(1s) {
                    targetNode.layoutX => 0 tween Interpolator.EASEOUT;
                    targetNode.layoutY => 0 tween Interpolator.EASEOUT;
                }
            ]
        }.play()
    }
}
