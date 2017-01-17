/*
 * Copyright (c) 2008-2009, JFXtras Group
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
package org.jfxtras.jugspinner;

import javafx.scene.control.Button;
import javafx.scene.control.Hyperlink;
import javafx.scene.control.Label;
import javafx.scene.image.ImageView;
import javafx.scene.control.CheckBox;
import javafx.scene.text.Font;
import org.jfxtras.scene.XCustomNode;
import org.jfxtras.scene.image.XImage;
import org.jfxtras.scene.layout.XGrid;
import org.jfxtras.scene.layout.XGridLayoutInfo;
import org.jfxtras.scene.layout.XGridLayoutInfo.*;
import org.jfxtras.scene.layout.XHBox;
import org.jfxtras.scene.layout.XSpacer;
import org.jfxtras.util.BrowserUtil;

/**
 * @author Stephen Chin
 */
public class JUGSpinnerUI extends XCustomNode {
    def spinButton:Button = Button {
        text: "Spin Wheel"
        font: Font {size: 20}
        action: spin
        override var hover on replace {
            // hack to work around a bug where the button never gets re-enabled if the mouse is hovering
            spinButton.disable = not spinButton.disable;
            spinButton.disable = not spinButton.disable;
        }
        graphic: ImageView {
            image: XImage {
                url: "{__DIR__}spin.png"
            }
        }
    }
    def spinning = bind JUGSpinnerModel.jugSpinnerWheel.spinning on replace {
        spinButton.disable = spinning
    }
    def fast = CheckBox {text: "Fast", selected: bind JUGSpinnerModel.fast with inverse}
    def controls = XHBox {spacing: 10, content: [spinButton, fast], layoutInfo: XGridLayoutInfo {hpos: RIGHT}}
    function spin() {
        if (spinning) return;
        JUGSpinnerModel.spin();
    }

    def meetupLink = Hyperlink {
        action: function() {
            BrowserUtil.browse("http://meetup.com/", "_blank");
        }
        graphic: ImageView {
            image: XImage {
                url: "{__DIR__}meetup-logo.jpeg"
            }
        }
    }
    def jfxtrasLink = Hyperlink {
        action: function() {
            BrowserUtil.browse("http://jfxtras.org/", "_blank");
        }
        graphic: ImageView {
            image: XImage {
                url: "{__DIR__}jfxtras-logo.png"
            }
        }
    }
    def logos = XHBox {
        spacing: 10
        content: [
            XSpacer {}
            Label {
                text: "Powered By:"
            }
            meetupLink,
            jfxtrasLink
        ]
    }

    override function create() {
        XGrid {
            layoutInfo: XGridLayoutInfo {margin: insets(20)}
            hgap: 10
            vgap: 20
            rows: [
                row([JUGSpinnerModel.jugSpinnerWheel, JUGSpinnerModel.winnerDisplay]),
                row([controls, logos])
            ]
        }
    }
}
