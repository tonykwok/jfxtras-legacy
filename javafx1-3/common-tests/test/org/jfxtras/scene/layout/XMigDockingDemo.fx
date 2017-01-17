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

import javafx.scene.paint.Color;
import javafx.scene.paint.LinearGradient;
import javafx.scene.paint.Stop;
import javafx.scene.text.Font;
import javafx.scene.text.Text;
import javafx.stage.Stage;
import org.jfxtras.scene.layout.XMigLayout;
import org.jfxtras.scene.layout.XMigLayout.*;
import org.jfxtras.scene.shape.ResizableRectangle;
import org.jfxtras.scene.XScene;

/**
 * @author Dean Iverson
 */
Stage {
    title: "Mig Docking Test"
    scene: XScene {
        width: 400
        height: 400
        fill: Color.LEMONCHIFFON
        content: XMigLayout {
            id: "root"
            constraints: "fill"
            content: [
                migNode( createLabel( Color.KHAKI, "North" ),     "north" ),
                migNode( createLabel( Color.GOLDENROD, "South" ), "south" ),
                migNode( createLabel( Color.GOLD, "East" ),       "east" ),
                migNode( createLabel( Color.DARKKHAKI, "West" ),  "west" ),
                Text {
                    id: "dockingText"
                    content: "XMigLayout Docking"
                    font: Font { size: 24 }
                    layoutInfo: nodeConstraints( "center, grow" )
                }
            ]
        }
    }
}

function createLabel( color:Color, label:String ) {
    XMigLayout {
        id: label
        constraints: "fill"
        content: [
            ResizableRectangle {
                id: "rr:{label}"
                fill: LinearGradient {
                    stops: [
                        Stop {
                            offset: 0.0,
                            color: color.ofTheWay( Color.WHITE, 0.25 ) as Color
                        },
                        Stop {
                            offset: 1.0,
                            color: color.ofTheWay( Color.BLACK, 0.25 ) as Color
                        }
                    ]
                }
                layoutInfo: nodeConstraints( "pos 0 0 container.x2 container.y2" )
            }
            Text {
                id: "text:{label}"
                content: label
                font: Font { size: 18 }
                layoutInfo: nodeConstraints( "center, grow" )
            }
        ]
    }
}
