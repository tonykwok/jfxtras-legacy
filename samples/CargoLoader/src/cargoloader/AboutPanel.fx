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
package cargoloader;

import javafx.animation.KeyFrame;
import javafx.animation.Timeline;
import javafx.animation.transition.FadeTransition;
import javafx.scene.Group;
import javafx.scene.Node;
import javafx.scene.control.Button;
import javafx.scene.control.Label;
import javafx.scene.control.Separator;
import javafx.scene.effect.Blend;
import javafx.scene.effect.BlendMode;
import javafx.scene.effect.DropShadow;
import javafx.scene.effect.Reflection;
import javafx.scene.image.ImageView;
import javafx.scene.layout.LayoutInfo;
import javafx.scene.paint.Color;
import javafx.scene.shape.Rectangle;
import javafx.scene.text.Font;
import javafx.scene.text.Text;
import javafx.scene.image.Image;
import javafx.scene.CustomNode;
import javafx.scene.text.TextAlignment;
import javafx.scene.control.Hyperlink;
import org.jfxtras.util.BrowserUtil;
import javafx.scene.Cursor;

/**
 * @author Abhilshit Soni
 */
public class AboutPanel extends CustomNode {

    init {
        id = "start";
        timeline.play();
    }

    var introHeader = Text {
                layoutX: 450
                layoutY: 240
                fill: Color.web("#0093ff")
                content: "Introduction"
            }
    var helpText = Text {
                layoutX: 450
                layoutY: 260
                wrappingWidth: 400
                fill: Color.WHITE
                textAlignment: TextAlignment.JUSTIFY
                content: "The center-of-gravity (CG) is the point at which an aircraft would balance if it were possible to suspend it at that point. It is the mass center of the aircraft,"
                " or the theoretical point at which the entire weight of the aircraft is assumed to be concentrated. Its distance from the reference datum is determined by dividing "
                "the total moment by the total weight of the aircraft."
                " The center-of-gravity point affects the stability of the aircraft. "
                "To ensure the aircraft is safe to fly, the center-of-gravity must"
                " fall within specified limits established by the manufacturer. This application aims at achieving the same for Beechcraft 1900C aircrafts.";
            }
    var gerGuidesHeader = Text {
                layoutX: 450
                layoutY: 380
                fill: Color.web("#0093ff")
                content: "Limitations"
            }
    var generalGuides = Text {
                layoutX: 450
                layoutY: 405
                wrappingWidth: 420
                fill: Color.WHITE
                textAlignment: TextAlignment.JUSTIFY
                content: "This application does not notify you when you cross the aitcraft structural limits."
                " Although it can be visualized through Weight vs CG chart when that yellow dot falls"
                " outside the polygons drawn inside the chart, you are exceeding the structural limits."
                "Also it does not calculate lateral center of gravity as of now."
                "Some other functional validations are also missing."
            }
    var refHeader = Text {
                layoutX: 20
                layoutY: 250
                fill: Color.web("#0093ff")
                content: "Developed By:"
            }
    var references = Text {
                layoutX: 20
                layoutY: 275
                wrappingWidth: 350
                fill: Color.WHITE
                textAlignment: TextAlignment.JUSTIFY
                content: "Abhilshit Soni";
            }
    var faaLink = Hyperlink {
                visited: true
                layoutX: 20
                layoutY: 305
                text: "abhi.996@gmail.com"
                action: function () {

                    BrowserUtil.browse("abhi.996@gmail.com");
                }
            }
    var faaWebLink = Hyperlink {
                visited: true
                layoutX: 20
                layoutY: 325
                text: "Follow me"
                action: function () {

                    BrowserUtil.browse("http://twitter.com/abhilshit");
                }
            }
    var beechcraftSite = Hyperlink {
                visited: true
                layoutX: 20
                layoutY: 345
                text: "My Blog"
                action: function () {

                    BrowserUtil.browse("http://dukesrepaint.blogspot.com");
                }
            }
    var disclaimerHeader = Text {
                layoutX: 20
                layoutY: 415
                fill: Color.web("#0093ff")
                content: "Disclaimer:"
            }
    var disclaimerText = Text {
                layoutX: 20
                layoutY: 430
                wrappingWidth: 350
                fill: Color.WHITE
                textAlignment: TextAlignment.JUSTIFY
                content: "This application is intended for JavaFX demo purposes"
                " and is NOT thoroughly tested. It is not intended to be used for "
                "actual Aircraft loadplanning. "
                "Neither the creator nor the publisher is responsible for any losses"
                " caused by use of this software. Use only FAA/IATA certified softwares "
                "for loadplanning your cargo aircrafts. ";
            }
    var background = Rectangle {
                cache: true
                x: 0, y: 23
                width: 950, height: 639
                fill: Color.BLACK
                opacity: 0.97
                blocksMouse: true
            }
    var image = Image {
                url: "{__DIR__}images/b2.png"
                 };
    var currImg = image;
    var imageView = ImageView {
                cache: true;
                image: bind currImg
            }
    def fade = FadeTransition {
                duration: 2s
                node: imageView
                fromValue: 1.0
                toValue: 0.1
                repeatCount: 2
                autoReverse: true
            }
    var timeline = Timeline {
                repeatCount: Timeline.INDEFINITE
                keyFrames: [
                    KeyFrame {time: 4.5s action: function () {
                            fade.play();
                        } },
                    KeyFrame {time: 9.5s action: function () {
                            fade.play();
                        } },
                    KeyFrame {time: 14.5s action: function () {
                            fade.play();
                        } },
                    KeyFrame {time: 19.5s action: function () {
                            fade.play();
                        } },
                ]
            }
    var title: Text = Text {
                effect: Blend {
                    mode: BlendMode.MULTIPLY
                    bottomInput: DropShadow {
                        color: Color.SILVER
                        offsetX: 1, offsetY: 1
                        radius: 1
                        spread: 0.2
                    }
                    topInput: Reflection {
                        fraction: 0.55
                        topOffset: 0.0
                        topOpacity: 0.3
                        bottomOpacity: 0.0
                    }
                }
                fill: Color.WHITE
                font: Font {name: "" size: 25 }
                layoutX: 600
                layoutY: 150
                content: "Air Cargo Loader"
            }
    var modelText: Text = Text {
                effect: Blend {
                    mode: BlendMode.MULTIPLY
                    bottomInput: DropShadow {
                        color: Color.SILVER
                        offsetX: 1, offsetY: 1
                        radius: 1
                        spread: 0.2
                    }
                    topInput: Reflection {
                        fraction: 0.55
                        topOffset: 0.0
                        topOpacity: 0.3
                        bottomOpacity: 0.0
                    }
                }
                fill: Color.WHITE
                font: Font {name: "" size: 35 }
                layoutX: 570
                layoutY: 120
                content: "BEECHCRAFT 1900C"
            }
    var closeButton = Button {
                layoutX: 385
                layoutY: 570
                text: "Back >>";
                action: function () {
                    timeline.stop();
                    fade.stop();
                    currImg = image;
                    delete this from scene.content;
                }
                cursor: Cursor.HAND
            }
    var jfxtraslogo = ImageView {
                x: 450 y: 620
                image: Image {
                    url: "{__DIR__}images/logo.png"
                     width: 70
                    height: 30
                }
            }
    var logo = ImageView {
                x: 350 y: 620
                image: Image {
                    url: "{__DIR__}images/JavaFX_logo.jpg"
                     width: 70
                    height: 30
                }
            }
    var poweredBylabel = Label {
                layoutX: 280 layoutY: 630
                text: "Powered By:"
                textFill: Color.SILVER
            }
    var separator1 = Separator {
                vertical: false
                layoutX: 13
                layoutY: 600
                layoutInfo: LayoutInfo {width: 950 }
            }
    var separator2 = Separator {
                vertical: true
                layoutX: 400
                layoutY: 230
                layoutInfo: LayoutInfo {height: 330 }
            }

    public override function create(): Node {
        return Group {
                    content: [background, imageView, title, closeButton, modelText, logo,jfxtraslogo, separator1, poweredBylabel, helpText, separator2, generalGuides, gerGuidesHeader, refHeader, references, faaLink, faaWebLink, beechcraftSite, disclaimerHeader, disclaimerText, introHeader]
                };
    }

}
