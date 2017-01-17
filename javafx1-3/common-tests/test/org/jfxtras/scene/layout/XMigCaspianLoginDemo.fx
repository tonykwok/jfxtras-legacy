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
import javafx.stage.Stage;
import org.jfxtras.scene.layout.XMigLayout;
import org.jfxtras.scene.layout.XMigLayout.*;
import javafx.ext.swing.SwingComponent;
import javax.swing.JPasswordField;
import org.jfxtras.scene.XScene;
import javafx.scene.control.Label;
import javafx.scene.control.TextBox;
import javafx.scene.control.Button;


/**
 * @author Dean Iverson
 */
function createPasswordField( constraints:String ) {
    var sc = SwingComponent.wrap( new JPasswordField() );
    migNode( sc, constraints )
}

Stage {
    title: "Mig Login Test"
    scene: XScene{
        width: 300
        height: 200
        fill: LinearGradient {
            endX: 0.0
            stops: [
                Stop { offset: 0.0, color: Color.WHITE },
                Stop { offset: 0.7, color: Color.web("#e8e8e8") },
                Stop { offset: 1.0, color: Color.SILVER },
            ]
        }

        content: XMigLayout {
            constraints: "fill, wrap"
            columns: "[][]"
            rows: "[][]4mm[]push[]"
            content: [
                Label {
                    text: "Email"
                    layoutInfo: nodeConstraints( "ax right" )
                }
                TextBox {
                    layoutInfo: nodeConstraints( "growx, pushx" )
                }
                Label {
                    text: "Password"
                    layoutInfo: nodeConstraints( "ax right" )
                }
                createPasswordField( "growx, pushx" ),
                Button {
                    text: "Login"
                    layoutInfo: nodeConstraints( "skip, right" )
                }
                Label {
                    text: "This text is 'pushed' to the bottom"
                    layoutInfo: nodeConstraints( "span" )
                }
            ]
        }
    }
}
