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
var border:XEmptyBorder;
var border2:XEmptyBorder;
Stage {
    title: "Empty Border"
    scene: Scene {
        width: 200
        height: 200
        content: [
            border = XEmptyBorder {
                layoutX: 40
                layoutY: 40
                backgroundFill: Color.RED
                borderTopWidth: 10
                borderBottomWidth: 10
                borderLeftWidth: 10
                borderRightWidth: 10
                shapeToFit: false
                layoutInfo: LayoutInfo {
                    width: 100
                    height: 100
                }
                node: Button {
                    text: "hello"
                }
            }

        ]
    }
}
