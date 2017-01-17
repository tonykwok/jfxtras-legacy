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
package org.jfxtras.scene.gadget;

import org.jfxtras.scene.XScene;
import org.jfxtras.stage.XStage;
import javafx.stage.StageStyle;
import javafx.util.Sequences;
import javafx.animation.Timeline;
import javafx.animation.KeyFrame;

/**
 * @author Stephen Chin
 */
class Medal {
    public var type:String;
    public var name:String;
    public var country:String;
    public var score:Number;
    public var lightColor:Integer;
}

def gold = Medal {
    type: "GOLD"
    name: "AMMANN Simon"
    country: "SUI"
    score: 276.5
    lightColor: ScoreChar.GREEN
}
def silver = Medal {
    type: "SILVER"
    name: "MALYSZ Adam"
    country: "POL"
    score: 269.5
    lightColor: ScoreChar.RED
}
def bronze = Medal {
    type: "BRONZE"
    name: "SCHLIERENZAUER G."
    country: "AUT"
    score: 268.0
    lightColor: ScoreChar.YELLOW
}
def medals = [gold, silver, bronze];
var medal:Medal = gold;
Timeline {
    repeatCount: Timeline.INDEFINITE
    keyFrames: for (m in medals) KeyFrame {
        time: 1000ms * indexof m
        action: function() {medal => m}
    }
}.play();

bound function getScore() {
    [
        ScoreLine {line: "Ski Jumping - Individual Norml"}
        ScoreLine {line: "                              "}
        ScoreLine {line: bind "            {%-10s medal.type}        "}
        ScoreLine {line: bind "{%-17s medal.name}  {%-3s medal.country}   {%3.1f medal.score}"}
    ]
}

def sb = ScoreBoard {
    lightColor: bind medal.lightColor
    lines: bind getScore()
    onMousePressed: function(e) {
        if (e.primaryButtonDown) {
            medal = medals[(Sequences.indexOf(medals, medal) + 1) mod sizeof medals]
        } else {
            FX.exit();
        }
    }
}

XStage {
    style: StageStyle.TRANSPARENT
    scene: XScene {
        content: sb
    }
}
