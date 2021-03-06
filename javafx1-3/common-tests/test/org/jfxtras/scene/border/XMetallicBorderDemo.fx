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
package org.jfxtras.scene.border;

import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.layout.LayoutInfo;
import javafx.scene.paint.Color;
import javafx.stage.Stage;

/**
 * @author jclarke
 * @author Stephen Chin
 */
var border: XMetallicBorder;
var border2: XMetallicBorder;
Stage {
    title: "Metallic Border"
    scene: Scene {
        width: 350
        height: 200
        content: [
            border = XMetallicBorder {
                layoutX: 50
                layoutY: 50
                backgroundFill: Color.RED
                shapeToFit: true
                //shapeToFit: false
                layoutInfo: LayoutInfo {
                    width: 100
                    height: 100
                }
                //borderWidth: 10
                node: Button {
                    text: "hello"
                }
                onMouseReleased: function(e) {
                    border.raised = not border.raised;
                }
            }
            border2 = XMetallicBorder {
                layoutX: 200
                layoutY: 50
                backgroundFill: Color.RED
                shapeToFit: false
                layoutInfo: LayoutInfo {
                    width: 100
                    height: 100
                }
                borderWidth: 10
                node: Button {
                    text: "hello"
                }
                onMouseReleased: function(e) {
                    border2.raised = not border2.raised;
                }
            }
        ]
    }
}
