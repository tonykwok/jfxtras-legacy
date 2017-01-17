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
package org.jfxtras.scene.control.skin;

import javafx.scene.paint.Color;
import javafx.scene.paint.Stop;
import javafx.scene.text.Font;
import com.sun.javafx.UtilsFX;
import javafx.scene.paint.LinearGradient;
import javafx.scene.paint.Paint;

/**
 * The Caspian class disappeared in JavaFX 1.3 with the switch to CSS-based controls.  Since a lot of 1.2 controls
 * depend on it, it was easier to reintroduce it here.  This module has been populated with defaults from the new
 * caspian.css style sheet that is used for the core controls.  These default values can be used to create controls
 * that blend in nicely with the core controls but aren't neccessarily CSS-based.
 *
 * @author David
 * @author Tom Eugelink
 * @author Dean Iverson
 */

//    -fx-font: 12pt "Amble Cn";
public-read var fxFont = Font {size: 12 name: "Amble Cn" };

//    -fx-accent: #0093ff;
public-read var fxAccent = Color.web("#0093ff");

//    -fx-base: #d0d0d0;
public-read var fxBase = Color.web("#d0d0d0");

//    -fx-background: #f4f4f4;
public-read var fxBackground = Color.web("#f4f4f4");

//    -fx-control-inner-background: white;
public-read var fxControlInnerBackground = Color.WHITE;

//    -fx-focus-color: #0093ff;
public-read var fxFocusColor = Color.web("#0093ff");

//    -fx-dark-text-color: black;
public-read var fxDarkTextColor = Color.BLACK;

//    -fx-mid-text-color: #292929;
public-read var fxMidTextColor = Color.web("#292929");

//    -fx-light-text-color: white;
public-read var fxLightTextColor = Color.WHITE;

//    -fx-color: -fx-base;
public-read var fxColor = Color.web("#d0d0d0");

//    -fx-hover-base: UtilsFX.ladder base stops (20%,derive(-fx-base,20%)) (35%,derive(-fx-base,30%)) (50%,derive(-fx-base,40%));
public-read var fxHoverBase = UtilsFX.ladder(fxBase, [
            Stop {offset: 0.2, color: UtilsFX.deriveColor(fxBase, 0.2) },
            Stop {offset: 0.35, color: UtilsFX.deriveColor(fxBase, 0.3) },
            Stop {offset: 0.5, color: UtilsFX.deriveColor(fxBase, 0.4) },
        ]);

//    -fx-pressed-base: derive(-fx-base,-20%);
public-read var fxPressedBase = UtilsFX.deriveColor(fxBase, -0.2);

//    -fx-box-border: UtilsFX.ladder -fx-color stops (0.2,black) (0.3,derive(-fx-color,-30%));
public-read var fxBoxBorder = UtilsFX.ladder(fxColor, [
            Stop {offset: 0.2, color: Color.BLACK },
            Stop {offset: 0.3, color: UtilsFX.deriveColor(fxColor, -0.3) },
        ]);

//    -fx-text-box-border: UtilsFX.ladder -fx-background stops (0.1,black) (0.3,derive(-fx-background,-15%));
public-read var fxTextBoxBorder = UtilsFX.ladder(fxBackground, [
            Stop {offset: 0.1, color: Color.BLACK },
            Stop {offset: 0.3, color: UtilsFX.deriveColor(fxBackground, -0.15) },
        ]);

/*     -fx-shadow-highlight-color: UtilsFX.ladder -fx-background stops
(0,transparent)
(0.05,derive(-fx-background,40%))
(0.70,derive(-fx-background,60%))
(0.85,derive(-fx-background,100%))
(0.97,derive(-fx-background,100%))
(0.975,derive(-fx-background,-10%));   */
public-read var fxShadowHighlightColor = UtilsFX.ladder(fxBackground, [
            Stop {offset: 0, color: Color.TRANSPARENT },
            Stop {offset: 0.05, color: UtilsFX.deriveColor(fxBackground, 0.40) },
            Stop {offset: 0.70, color: UtilsFX.deriveColor(fxBackground, 0.60) },
            Stop {offset: 0.85, color: UtilsFX.deriveColor(fxBackground, 1.0) },
            Stop {offset: 0.97, color: UtilsFX.deriveColor(fxBackground, 1.0) },
            Stop {offset: 0.975, color: UtilsFX.deriveColor(fxBackground, -0.10) },
        ]);

//    -fx-outer-border: linear (0%,0%) to (0%,100%) stops (0%,derive(-fx-color,-9%)) (100%,derive(-fx-color,-33%));
public-read var fxOuterBorder = getOuterBorderPaint( fxColor );

/*    -fx-inner-border: linear (0%,0%) to (0%,100%) stops
(0,UtilsFX.ladder -fx-color stop (0.6, derive(-fx-color,80%) (0.82,white ))
(1,UtilsFX.ladder -fx-color stop (0.1,derive(-fx-color,20%)) (0.8,derive(-fx-color,-10%)) );
*/
public-read var fxInnerBorder = getInnerBorderPaint( fxColor );

//    -fx-body-color: linear (0%,0%) to (0%,100%) stops (0,derive(-fx-color,34%)) (1,derive(-fx-color,-18%));
public-read var fxBodyColor = getBodyPaint( fxColor );

//    -fx-text-base-color: UtilsFX.ladder -fx-color stops (30%,-fx-light-text-color) (31%,-fx-dark-text-color) (59%,-fx-dark-text-color) (60%,-fx-mid-text-color);
public-read var fxTextBaseColor = UtilsFX.ladder(fxColor, [
            Stop {offset: 0.30, color: fxLightTextColor },
            Stop {offset: 0.31, color: fxDarkTextColor },
            Stop {offset: 0.59, color: fxDarkTextColor },
            Stop {offset: 0.60, color: fxMidTextColor },
        ]);

//    -fx-text-background-color: UtilsFX.ladder -fx-background stops (30%,-fx-light-text-color) (31%,-fx-dark-text-color) (59%,-fx-dark-text-color) (60%,-fx-mid-text-color);
public-read var fxTextBackgroundColor = UtilsFX.ladder(fxBackground, [
            Stop {offset: 0.30, color: fxLightTextColor },
            Stop {offset: 0.31, color: fxDarkTextColor },
            Stop {offset: 0.59, color: fxDarkTextColor },
            Stop {offset: 0.60, color: fxMidTextColor },
        ]);

//    -fx-text-inner-color: UtilsFX.ladder -fx-control-inner-background stops (30%,-fx-light-text-color) (31%,-fx-dark-text-color) (59%,-fx-dark-text-color) (60%,-fx-mid-text-color);
public-read var fxTextInnerColor = UtilsFX.ladder(fxControlInnerBackground, [
            Stop {offset: 0.30, color: fxLightTextColor },
            Stop {offset: 0.31, color: fxDarkTextColor },
            Stop {offset: 0.59, color: fxDarkTextColor },
            Stop {offset: 0.60, color: fxMidTextColor },
        ]);

//    -fx-mark-color: UtilsFX.ladder -fx-color stops (0.3,white) (0.31,derive(-fx-color,-63%));
public-read var fxMarkColor = UtilsFX.ladder(fxColor, [
            Stop {offset: 0.3, color: Color.WHITE },
            Stop {offset: 0.31, color: UtilsFX.deriveColor(fxColor, -0.63) }
        ]);

//    -fx-mark-highlight-color: UtilsFX.ladder -fx-color stops (0.6,derive(-fx-color,80%)) (0.7,white);
public-read var fxMarkHighlightColor = UtilsFX.ladder(fxColor, [
            Stop {offset: 0.6, color: UtilsFX.deriveColor(fxColor, -0.80) },
            Stop {offset: 0.7, color: Color.WHITE }
        ]);

//    -fx-selection-bar: linear (0%,0%) to (0%,100%) stops (0%,derive(-fx-background,-7%)) (100%,derive(-fx-background,-34%));
public-read var fxSelectionBar = LinearGradient {
            endX: 0
            stops: [
                Stop {offset: 0.0, color: UtilsFX.deriveColor(fxBackground, -0.07) },
                Stop {offset: 1.0, color: UtilsFX.deriveColor(fxBackground, -0.34) },
            ] };

//    -fx-selection-bar-text: UtilsFX.ladder -fx-background stops (50%,-fx-light-text-color) (51%,-fx-mid-text-color);
public-read var fxSelectionBarText = UtilsFX.ladder(fxBackground, [
            Stop {offset: 0.5, color: fxLightTextColor },
            Stop {offset: 0.51, color: fxMidTextColor }
        ]);

//    -fx-text-fill: -fx-text-background-color;
public-read var fxTextFill = fxTextBackgroundColor;

public function getBodyPaint(c: Color): Paint {
    LinearGradient {
        endX: 0
        stops: [
            Stop {offset: 0.0, color: UtilsFX.deriveColor(c, 0.34) },
            Stop {offset: 1.0, color: UtilsFX.deriveColor(c, -0.18) },
        ]
    };
}

public function getInnerBorderPaint(c: Color): Paint {
    def color1 = UtilsFX.ladder(c, [
        Stop { offset: 0.6, color: UtilsFX.deriveColor(c, 0.80) },
        Stop { offset: 0.82, color: Color.WHITE },
    ]);

    def color2 = UtilsFX.ladder(c, [
        Stop { offset: 0.1, color: UtilsFX.deriveColor(c, 0.20) },
        Stop { offset: 0.8, color: UtilsFX.deriveColor(c, -0.10) },
    ]);

    LinearGradient {
        endX: 0
        stops: [
            Stop {offset: 0.0, color: color1 },
            Stop {offset: 1.0, color: color2 },
        ]
    }
}

public function getOuterBorderPaint(c: Color): Paint {
    LinearGradient {
        endX: 0
        stops: [
            Stop {offset: 0.0, color: UtilsFX.deriveColor(c, -0.09) },
            Stop {offset: 1.0, color: UtilsFX.deriveColor(c, -0.33) },
        ]
    }
}

public function getTextPaint(c: Color): Paint {
    def brightness = UtilsFX.calculateBrightness(c);
    if (brightness >= .5 and brightness < .7) {
        return fxDarkTextColor;
    }
    if (brightness >= .5) {
        return fxTextBaseColor;
    }
    return fxLightTextColor;
}

public class XCaspian {

}
