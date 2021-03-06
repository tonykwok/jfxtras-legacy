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

import javafx.scene.input.MouseEvent;
import javafx.scene.paint.Color;
import javafx.stage.Stage;
import org.jfxtras.scene.layout.XGrid;
import org.jfxtras.scene.layout.XGridLayoutInfo.*;
import org.jfxtras.scene.XScene;

/**
 * @author Stephen Chin
 */
function bringToFront(e:MouseEvent):Void {
    e.source.toFront();
}

var strokeWidth = 20;

Stage {
    title: "Grid (should not overlap)"
    x: 500
    y: 300
    width: 300
    height: 300
    scene: XScene {
        content: XGrid {
            // todo - set margins to 0
            hgap: 0
            vgap: 0
            rows: [
                row([
                    ResizableRectangle {
                      fill: Color.LIGHTBLUE
                      stroke: Color.BLUE
                      strokeWidth: strokeWidth
                      onMouseEntered: bringToFront
                    }
                    ResizableRectangle {
                      fill: Color.LIGHTGREEN
                      stroke: Color.GREEN
                      strokeWidth: strokeWidth
                      onMouseEntered: bringToFront
                    }
                ]),
                row([
                    ResizableRectangle {
                      fill: Color.LIGHTPINK
                      stroke: Color.PINK
                      strokeWidth: strokeWidth
                      onMouseEntered: bringToFront
                    }
                    ResizableRectangle {
                      fill: Color.LIGHTYELLOW
                      stroke: Color.YELLOW
                      strokeWidth: strokeWidth
                      onMouseEntered: bringToFront
                    }
                ])
            ]
        }
    }
}
