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
package org.jfxtras.scene.control.renderer;

import javafx.scene.Node;
import javafx.scene.paint.LinearGradient;
import javafx.scene.paint.Paint;
import javafx.scene.paint.Stop;
import javafx.scene.text.Text;
import org.jfxtras.scene.paint.ColorUtil;

/**
 * @author Stephen Chin
 * @author Keith Combs
 */
public class DefaultTableHeaderRenderer extends TableHeaderRenderer {
        
    override function getFill(height:Number):Paint {
        LinearGradient {
            proportional: false
            endY: height
            endX: 0
            stops: [
                Stop {offset: 0, color: ColorUtil.lighter(skin.baseColor, .8)}
                Stop {offset: .15, color: ColorUtil.lighter(skin.baseColor, .4)}
                Stop {offset: .70, color: ColorUtil.lighter(skin.baseColor, .3)}
                Stop {offset: .85, color: ColorUtil.darker(skin.baseColor, .1)}
                Stop {offset: .851, color: skin.lightMarkColor}
                Stop {offset: 1, color: skin.markColor}
            ]
        }
    }

    override bound function render(text:String):Node {
        Text {
            content: bind text
            font: bind skin.headerFont
            fill: bind skin.textColor
        }
    }
}
