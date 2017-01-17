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

import javafx.geometry.HPos;
import javafx.geometry.VPos;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.layout.LayoutInfo;
import javafx.stage.Stage;

import javafx.scene.paint.Color;

/**
 * @author jclarke
 * @author Stephen Chin
 */
Stage {
    title : "Titled Border"
    scene: Scene {
        width: 500
        height: 200
        content: [
            XTitledBorder {
                layoutX: 40
                layoutY: 40
                titleVPos: VPos.TOP
                titleHPos: HPos.CENTER
                shapeToFit: true
                layoutInfo: LayoutInfo {
                    width: 200
                    height: 100
                }
                text: "Combo Box Jim"
                thickness: 2
                node: Button {
                    text: "hello"
                    layoutInfo: LayoutInfo{
                        width: 200
                    }
                }
            }
            XTitledBorder {
                layoutX: 260
                layoutY: 40
                titleVPos: VPos.TOP
                titleHPos: HPos.CENTER
                backgroundFill: Color.RED
                shapeToFit: false
                layoutInfo: LayoutInfo {
                    width: 200
                    height: 100
                }
                text: "Combo Box Jim"
                thickness: 2
                node: Button {
                    text: "hello"
                    layoutInfo: LayoutInfo{
                        width: 200
                    }
                }
            }
        ]
    }
}
