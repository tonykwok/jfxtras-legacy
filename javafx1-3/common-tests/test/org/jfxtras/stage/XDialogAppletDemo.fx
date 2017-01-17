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
package org.jfxtras.stage;

import javafx.stage.Stage;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import org.jfxtras.stage.XDialog;
import org.jfxtras.scene.XScene;
import javafx.stage.StageStyle;
import javafx.scene.shape.Rectangle;
import javafx.scene.layout.VBox;
import javafx.scene.control.Label;
import javafx.geometry.HPos;
import javafx.scene.paint.Color;

/**
 * @author Baptiste Grenier
 */
Stage {
    title: "Dialog"
    scene: Scene {
        width: 200
        height: 200
        content: [
            Button {
                text: "Button"
                action: function () {
                    XDialog {
                        style: StageStyle.DECORATED
                        modal: true
                        resizable: true
                        scene: XScene {
                            width: 300 height: 300
                            content: [
                                Rectangle {
                                    width: 300 height: 300
                                    arcWidth: 20 arcHeight: 20
                                },
                                VBox {
                                    nodeHPos: HPos.CENTER spacing: 20
                                    content: [
                                        Label {
                                            text: "Hello, I'm modal"
                                            textFill: Color.WHITE
                                        }
                                        Button {
                                            text: "Close"
                                            action: function () {
                                                XDialog.CURRENT_MODAL.close();
                                            }
                                        }
                                    ]
                                }
                            ]
                        }
                    }
                }
            }
        ]
    }
}
