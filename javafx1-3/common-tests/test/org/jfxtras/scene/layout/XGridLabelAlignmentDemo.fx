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

import javafx.stage.*;
import javafx.scene.*;
import javafx.scene.control.Label;
import javafx.scene.layout.Priority;
import org.jfxtras.scene.*;
import org.jfxtras.scene.layout.XGridLayoutInfo.*;

/**
 * @author Stephen Chin
 * @author Keith Combs
 */
Stage {
    title: "Label alignment"
    width: 400
    height: 400
    var scene:Scene;
    scene: scene = XScene {
        content: XGrid {
            rows: [
                row([
                    Label {text: "Top Left", layoutInfo: XLayoutInfo {vpos: TOP, hpos: LEFT, hgrow: Priority.ALWAYS, vgrow: Priority.ALWAYS}},
                    Label {text: "Top Center", layoutInfo: XLayoutInfo {vpos: TOP, hpos: CENTER, hgrow: Priority.ALWAYS, vgrow: Priority.ALWAYS}},
                    Label {text: "Top Right", layoutInfo: XLayoutInfo {vpos: TOP, hpos: RIGHT, hgrow: Priority.ALWAYS, vgrow: Priority.ALWAYS}}
                ]),
                row([
                    Label {text: "Center Left", layoutInfo: XLayoutInfo {vpos: MIDDLE, hpos: LEFT, hgrow: Priority.ALWAYS, vgrow: Priority.ALWAYS}},
                    Label {text: "Center Center", layoutInfo: XLayoutInfo {vpos: MIDDLE, hpos: CENTER, hgrow: Priority.ALWAYS, vgrow: Priority.ALWAYS}},
                    Label {text: "Center Right", layoutInfo: XLayoutInfo {vpos: MIDDLE, hpos: RIGHT, hgrow: Priority.ALWAYS, vgrow: Priority.ALWAYS}}
                ]),
                row([
                    Label {text: "Bottom Left", layoutInfo: XLayoutInfo {vpos: BOTTOM, hpos: LEFT, hgrow: Priority.ALWAYS, vgrow: Priority.ALWAYS}},
                    Label {text: "Bottom Center", layoutInfo: XLayoutInfo {vpos: BOTTOM, hpos: CENTER, hgrow: Priority.ALWAYS, vgrow: Priority.ALWAYS}},
                    Label {text: "Bottom Right", layoutInfo: XLayoutInfo {vpos: BOTTOM, hpos: RIGHT, hgrow: Priority.ALWAYS, vgrow: Priority.ALWAYS}}
                ]),
                row([
                    Label {text: "Baseline Left", layoutInfo: XLayoutInfo {vpos: BASELINE, hpos: LEFT, hgrow: Priority.ALWAYS, vgrow: Priority.ALWAYS}},
                    Label {text: "Baseline Center", layoutInfo: XLayoutInfo {vpos: BASELINE, hpos: CENTER, hgrow: Priority.ALWAYS, vgrow: Priority.ALWAYS}},
                    Label {text: "Baseline Right", layoutInfo: XLayoutInfo {vpos: BASELINE, hpos: RIGHT, hgrow: Priority.ALWAYS, vgrow: Priority.ALWAYS}}
                ])
            ]
        }
    }
}
