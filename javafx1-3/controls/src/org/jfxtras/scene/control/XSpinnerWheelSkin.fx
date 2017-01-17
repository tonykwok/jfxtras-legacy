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

import javafx.scene.Node;
import javafx.scene.effect.Blend;
import javafx.scene.effect.BlendMode;
import javafx.scene.layout.Panel;
import javafx.scene.paint.Color;
import javafx.scene.shape.Rectangle;
import javafx.scene.transform.Transform;
import javafx.util.Math;
import org.jfxtras.scene.control.skin.AbstractSkin;
import org.jfxtras.scene.effect.XRotationEffect;
import org.jfxtras.scene.shape.ETriangle;
import javafx.scene.effect.Identity;
import javafx.scene.image.Image;

/**
 * @author Stephen Chin
 */
public class XSpinnerWheelSkin extends AbstractSkin {
    var spinner = bind control as XSpinnerWheel;
    var entryHeight = bind Math.sin(Math.PI / numVisible) * spinner.height;
    public var curve = 0.3;
    var numVisible = bind if (spinner.maxVisible == 0) sizeof spinner.entries else Math.min(spinner.maxVisible, sizeof spinner.entries) as Number;
    var slots:Node[] = bind for (entry in spinner.entries) XSpinnerSlot {
        width: bind spinner.width
        height: bind entryHeight
        text: entry
        fill: if (indexof entry mod 3 == 0) {
            Color.LIGHTGRAY
        } else if (indexof entry mod 3 == 1) {
            Color.DARKGRAY
        } else {
            Color.hsb(360 * Math.abs((indexof entry * 2 - sizeof spinner.entries as Number) / sizeof spinner.entries), .4, .7)
        }
        stroke: Color.BLACK
        var index = bind (((indexof entry - spinner.centered + numVisible / 4) mod sizeof spinner.entries) + sizeof spinner.entries) mod sizeof spinner.entries;
        visible: bind index <= numVisible / 2
        effect: XRotationEffect {
            var sweep = bind 360.0 / numVisible;
            var width = bind spinner.width * (1 - curve*2);
            x: bind spinner.width * curve
            width: bind width
            height: bind spinner.height
            angle: bind index / numVisible * 360 - sweep / 2
            sweep: bind sweep
            topAspect: bind curve * spinner.width / spinner.height
            bottomAspect: bind curve * spinner.width / spinner.height
            vertical: false
        }
    }
    var selectedArrow = ETriangle {
        width: 30
        translateX: 45
        translateY: bind spinner.height / 2
        transforms: Transform.rotate(210, 0, 0)
        stroke: Color.BLACK
        fill: Color.DARKRED
    }

    var selectedRect = Rectangle {
        var height = bind entryHeight + 6;
        y: bind (spinner.height - height) / 2
        width: bind spinner.width
        height: bind height
        stroke: Color.BLACK
        fill: Color.color(1, 1, 0, 0.2)
    }
    var overlay = Rectangle {
        width: bind spinner.width
        height: bind spinner.height
        fill: Color.TRANSPARENT
    }
    override var node = Panel {
        effect: Blend {
            mode: BlendMode.SRC_ATOP
            topInput: Identity {
                source: bind Image {
                    width: spinner.width
                    height: spinner.height
                    url: "{__DIR__}gradient.png"
                }
            }
// replaced with an image workaround due to RT-7577 (dup of RT-6315 and RT-5389)
//            topInput: Flood {
//                paint: LinearGradient {
//                    endX: 0
//                    stops: [
//                        Stop {offset: 0, color: Color.color(0, 0, 0, .6)}
//                        Stop {offset: .3, color: Color.TRANSPARENT}
//                        Stop {offset: .7, color: Color.TRANSPARENT}
//                        Stop {offset: 1, color: Color.color(0, 0, 0, .6)}
//                    ]
//                }
//                width: bind spinner.width
//                height: bind spinner.height
//             }
        }
        content: bind [slots, selectedArrow]
        height: bind spinner.height
        width: bind spinner.width
        onMouseDragged: function(e) {
            println(e.dragY);
        }
    }
}
