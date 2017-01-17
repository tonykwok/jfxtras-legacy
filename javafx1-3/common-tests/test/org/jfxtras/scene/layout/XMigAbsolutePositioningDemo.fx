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

import javafx.stage.Stage;
import javafx.scene.paint.Color;
import org.jfxtras.scene.XScene;
import org.jfxtras.scene.shape.ResizableRectangle;

/**
 * Should draw a dark blue rectangle that resizes with the scene and maintains
 * a 10 pixel border.
 *
 * @author Dean Iverson
 */
Stage {
    title: "Mig Absolute Positioning Test"
    scene: XScene {
        width: 200
        height: 200
        fill: Color.LIGHTBLUE

        content: XMigLayout {
            id: "root"
            constraints: "fill"
            content: [
                ResizableRectangle {
                    id: "blueRect"
                    fill: Color.BLUE
                    layoutInfo: XMigNodeLayoutInfo {
                        constraints: "pos 10 10 container.x2-10 container.y2-10"
                    }
                }
                XMigLayout {
                    id: "nestedMig"
                    layoutInfo: XMigNodeLayoutInfo {
                      constraints: "pos 20 20 container.x2-20 container.y2-20"
                    }
                    content:ResizableRectangle {
                        id: "violetRect"
                        fill: Color.BLUEVIOLET
                        layoutInfo: XMigNodeLayoutInfo {
                            constraints: "pos 0 0 container.x2 container.y2"
                        }
                    }
                }
            ]
        }
    }
}