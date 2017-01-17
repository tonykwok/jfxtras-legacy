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
import javafx.scene.effect.DropShadow;
import javafx.stage.Stage;
import org.jfxtras.scene.layout.XMigLayout;
import org.jfxtras.scene.layout.XMigLayout.*;
import org.jfxtras.scene.XScene;

/**
 * @author Dean Iverson
 */
Stage {
    title: "Mig Alignment Test"
    scene: XScene {
        width: 700
        height: 300
        fill: LinearGradient {
            stops: [
                Stop {
                    offset: 0.0,
                    color: Color.SILVER.ofTheWay( Color.WHITE, 0.35 ) as Color
                },
                Stop {
                    offset: 1.0,
                    color: Color.SILVER.ofTheWay( Color.BLACK, 0.35 ) as Color
                }
            ]
        }

        content: XMigLayout {
            constraints: "fill, wrap, insets 0"
            rows: "[]50[]50[]"
            columns: "[]50[]50[]"
            content: [
                migNode( createText( "Left, Top" ),      "alignx left,   aligny top" ),
                migNode( createText( "Center, Top" ),    "alignx center, aligny top" ),
                migNode( createText( "Right, Top" ),     "alignx right,  aligny top" ),

                // Note: you can just use ax and ay for short
                migNode( createText( "Left, Center" ),   "ax left,   ay center" ),
                migNode( createText( "Center, Center" ), "ax center, ay center" ),
                migNode( createText( "Right, Center" ),  "ax right,  ay center" ),

                migNode( createText( "Left, Bottom" ),   "ax left,   ay bottom" ),
                migNode( createText( "Center, Bottom" ), "ax center, ay bottom" ),
                migNode( createText( "Right, Bottom" ),  "ax right,  ay bottom" ),
            ]
        }
    }
}

function createText( content:String ) {
    Text {
        content: content
        font: Font { size: 24 }
        cache: true
        effect: DropShadow {
            offsetX: 5
            offsetY: 5
            radius: 8
        }
    }
}
