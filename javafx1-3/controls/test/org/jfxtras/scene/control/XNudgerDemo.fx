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

package org.jfxtras.scene.control;

import javafx.stage.*;
import javafx.scene.control.*;
import org.jfxtras.scene.layout.XMigLayout;
import net.miginfocom.layout.*;
import org.jfxtras.scene.XScene;
import org.jfxtras.scene.layout.XVBox;
import org.jfxtras.scene.layout.XHBox;


var nudger1 = XNudger{ value: 100 };
var textbox1 = TextBox{editable: false};
var nudger1Value : Integer = bind nudger1.value on replace { textbox1.text = "{nudger1Value }" };

var nudger2 = XNudger{ skin: XNudgerSkinCaspian{} };
var textbox2 = TextBox{editable: false};
var nudger2Value : Integer = bind nudger2.value on replace { textbox2.text = "{nudger2Value }" };

var nudger3 = XNudger{ skin: XNudgerSkinLight{} };
var textbox3 = TextBox{editable: false};
var nudger3Value : Integer = bind nudger3.value on replace { textbox3.text = "{nudger3Value }" };

var nudger4 = XNudger{ value: 100 };
var nudger5 = XNudger{ skin: XNudgerSkinLight{} };


// stage
Stage {
    width: 400;
    height: 200;
    scene: XScene { // XScene automatically scales its child to fill
		///stylesheets: ["{__DIR__}style.css"],
        content: [
      /*
			XMigLayout {
				constraints: LC{}.fill() //.debug(1000)
				columns: AC{}
				rows: AC{}
				content: [
					XMigLayout.migNode( nudger1, CC{} ), XMigLayout.migNode( textbox1, CC{}.wrap() ),
					XMigLayout.migNode( nudger2, CC{} ), XMigLayout.migNode( textbox2, CC{}.wrap() ),
					XMigLayout.migNode( nudger3, CC{} ), XMigLayout.migNode( textbox3, CC{}.wrap() ),
					XMigLayout.migNode( nudger4, CC{}.grow().push().wrap() ),
					XMigLayout.migNode( nudger5, CC{}.grow().push().wrap() )
				]
			}
      */
			XVBox {
        spacing: 10
				content: [
					XHBox {
            spacing: 10
            content: [
                nudger1,
                textbox1
            ]
          },
					XHBox {
            spacing: 10
            content: [
                nudger2,
                textbox2
            ]
          },
					XHBox {
            spacing: 10
            content: [
                nudger3,
                textbox3
            ]
          },
					XHBox {
            spacing: 10
            content: [
                nudger4
            ]
          },
					XHBox {
            spacing: 10
            content: [
                nudger5
            ]
          }
				]
			}
		]
	}
}

