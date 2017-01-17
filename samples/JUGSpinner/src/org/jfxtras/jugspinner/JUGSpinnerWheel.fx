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

import javafx.animation.Interpolator;
import javafx.animation.KeyFrame;
import javafx.animation.Timeline;
import javafx.scene.effect.Reflection;
import javafx.util.Math;
import javafx.util.Sequences;
import org.jfxtras.scene.XCustomNode;
import org.jfxtras.scene.control.XSpinnerWheel;
import org.jfxtras.scene.layout.XGridLayoutInfo;
import org.jfxtras.scene.layout.XGridLayoutInfo.*;
import org.jfxtras.jugspinner.data.Member;

/**
 * @author Stephen Chin
 */
public class JUGSpinnerWheel extends XCustomNode {
    var winners = bind JUGSpinnerModel.winners with inverse;
    var members = bind JUGSpinnerModel.members with inverse;

    public-read var spinning = false;

    var spinner:XSpinnerWheel;

    public function spin(fast:Boolean) {
        spinning = true;
        var oldCentered = spinner.centered;
        var prospectiveWinners:Member[];
        Timeline {
            keyFrames: {
                def random = Math.random() * sizeof members;
                def upALittle = oldCentered - 3;
                var newCentered = oldCentered = Math.round(oldCentered +
                    Math.max(70, sizeof members) + random);
                def newWinner = bind newCentered mod sizeof members as Integer;
                while (Sequences.indexOf([winners, prospectiveWinners],
                       members[newWinner]) != -1) newCentered++;
                insert members[newWinner] into prospectiveWinners;
                [
                    KeyFrame {
                        time: if (fast) .1s else 1s
                        values: spinner.centered => upALittle
                                tween Interpolator.EASEOUT
                    },
                    KeyFrame {
                        time: if (fast) .7s else 7s
                        values: spinner.centered => newCentered
                                tween Interpolator.SPLINE(.2, .8, .6, 1.0)
                        action: function() {
                            JUGSpinnerModel.pickWinner(newWinner);
                            spinning = false;
                        }
                    }
                ]
            }
        }.play();
    }

    override function create() {
        spinner = XSpinnerWheel {
            wheelSound: "http://jfxtras.org/sounds/beep.wav"
            effect: Reflection {topOffset: 10, fraction: .25}
            entries: bind for (member in members) member.name
            maxVisible: 75
            layoutInfo: XGridLayoutInfo {
                width: 250, minWidth: 200, hgrow: NEVER, fill: VERTICAL
            }
        }
    }
}
