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

import javafx.scene.control.Button;
import javafx.geometry.HPos;
import javafx.geometry.VPos;

/**
 * A button that looks like it is etched into its background.
 *
 * This is a CSS-based control.  You must include /org/jfxtras/scene/control/skin/jfxtras.css in your
 * scene's styleSheets sequence for it to function properly.  If you are using XScene, this is done
 * automatically for you.
 *
    @example
    import org.jfxtras.scene.control.XEtchedButton;

    XEtchedButton {
        text: "Click Me"
        action: function() {
            println( "Button clicked" );
        }
    }
    @endexample
 *
 * @profile common
 * @author Dean Iverson
 */
public class XEtchedButton extends Button {
    override var styleClass = "xetched-button";

    public var buttonGroupHPos: HPos on replace {
        setStyleClassForButtonGroup();
    }

    public var buttonGroupVPos: VPos on replace {
        setStyleClassForButtonGroup();
    }

    /**
     * Note: Setting the node's ID for now since we can't yet do multiple style classes
     * in JavaFX 1.3.
     */
    function setStyleClassForButtonGroup() {
        var h = buttonGroupHPos;
        var v = buttonGroupVPos;

        if (h == null and v == null) {
            id = "";
            return;
        }

        if (h == HPos.CENTER or v == VPos.CENTER) {
            id = "center";
        } else if (h == null) {
            // only vpos is set
            id = if (v == VPos.TOP) "top" else "bottom";
        } else {
            // hpos is set
            if (v == null) {
                // only hpos is set
                id = if (h == HPos.LEFT) "left" else "right";
            } else {
                // both hpos and vpos are set so build an id of ul, ur, ll, or lr.
                id = "{if (v == VPos.TOP) "u" else "l"}{if (h == HPos.LEFT) "l" else "r"}"
            }
        }
    }
}
