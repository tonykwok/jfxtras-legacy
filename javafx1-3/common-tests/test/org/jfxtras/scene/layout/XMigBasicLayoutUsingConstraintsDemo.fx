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
import javafx.scene.Scene;
import javafx.scene.shape.Rectangle;
import javafx.scene.text.Font;
import javafx.scene.text.Text;
import javafx.stage.Stage;

import org.jfxtras.scene.layout.XMigLayout.*;
import net.miginfocom.layout.AC;
import net.miginfocom.layout.LC;
import net.miginfocom.layout.CC;

/**
 * This is a copy of the BasicLayoutTest, using the XMigLayout constraint classes directly instead of string constraints.
 * Using these classes allow for compile time checking, thus reducing the chance on errors.
 *
 * At the time of writing this test, the constraint classes are not 100% functional identical to string constraints.
 * For example: a string constraints allows for "span" (calculating the remaining number of columns in a row),
 * while the constraint classes only offer a spanX(n) where the number of columns must be specified.
 * It is possible to mix string and constraint notation within one layout.
 *
 * @author Tom Eugelink
 */
Stage {
    title: "XMigLayout Basic Test"
    scene: Scene {
        width: 300
        height: 200
        content: XMigLayout {
            constraints: LC{}.fill().debug(1000)
            columns: AC{}.gap("30")
            rows: AC{}.gap("30")
            content: [
                Text {
					id: 'text'
                    font: Font { size: 24 }
                    content: "Row Number One"
                },
                Rectangle {
                    width: 20
                    height: 20
                    fill: Color.CORNFLOWERBLUE
                    layoutInfo: nodeConstraints( CC{}.grow().spanX(2).wrap() )
                },
                Text {
                    font: Font { size: 24 }
                    content: "Row Number Two"
                    layoutInfo: nodeConstraints( CC{}.grow().spanX(2).gapX("indent", "") )
                },
            ]
        }
    }
}

