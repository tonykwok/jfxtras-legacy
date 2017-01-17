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
import cargoloader.BulletPoint;
import javafx.scene.Cursor;

/**
 * panel containing help contents and other details about the application.
 * @author Abhilshit Soni
 */
public class HelpPanel extends CustomNode {

    var guidelinesX = 450;
    var guidelinesY = 375;
    var helpPoints: BulletPoint[] = [];
    var generalGuides: String[] = ["Drag a cargo container from the cargo panel on the left side.", "Place it on any of the sections on bechcraft 1900C main deck in the upper center.", "See the change in center of gravity in the data table.", "See the change in weight v/s CG Chart, also see the change in weight coverage pie chart in lower left .", "To remove a dropped container double click it.", "Change the container's position by dragging from old position to new position.", "To enable/disable drag-drop animation toggle the 'Disable Animation' button in the center toolbar.","To reset the plan click 'Reset Containers' button in the center toolbar.","To quick view/hide the cargo weights toggle the 'View Weights' button in the center toolbar.", "Click on Weight Coverage chart or Weight vs CG chart to get a larger image."
            ];

    init {

        id = "start";
        timeline.play();
        var counter = 0;
        for (i in generalGuides) {
            helpPoints[counter] = BulletPoint {
                        bulletText: Text {
                            x: guidelinesX;
                            y: guidelinesY + counter * 25;
                            wrappingWidth: 450
                            fill: Color.WHITE
                            textAlignment: TextAlignment.LEFT
                            content: i
                        }
                        bulletFill: Color.web("#0093ff");
                    }
            counter++;
        }

    }

    var helpText = Text {
                layoutX: 450
                layoutY: 240
                wrappingWidth: 450
                fill: Color.WHITE
                textAlignment: TextAlignment.JUSTIFY
                content: "Beechcraft Cargoloader is a typical cargo weight and balance "
                "application made for cargo aircraft Beechcraft 1900C . Actually Beechcraft 1900C is available in passenger configuration and can be modified to operate in cargo configuration too. In a regular business scenario commercial cargo air planes(like Boeing 747 and Airbus A380) undergo a set of calculations on how the cargo containers are loaded inside it, before departure, which ensures that the resultant center of gravity is under the structural limits defined by the cargo aircraft manufacturer. For any functional references please see Chapter 7 of  FAA Weight and Balance Handbook";
            }
    var gerGuidesHeader = Text {
                layoutX: 450
                layoutY: 360
                fill: Color.web("#0093ff")
                content: "General Guidelines:"
            }
    var refHeader = Text {
                layoutX: 20
                layoutY: 250
                fill: Color.web("#0093ff")
                content: "References:"
            }
    var references = Text {
                layoutX: 20
                layoutY: 265
                wrappingWidth: 350
                fill: Color.WHITE
                textAlignment: TextAlignment.JUSTIFY
                content: "All the aircraft data and equations were referred from Chapter 7 - 'Large Aircraft Weight and Balance'"
                " - page 60, of The Weight and Balance Handbook by Federal Aviation Administration. The Beechcraft image show above is taken from the Hawker BeechCraft official website.";
            }
    var faaLink = Hyperlink {
                visited: true
                layoutX: 20
                layoutY: 325
                text: "FAA Weight and Balance Handbook"
                action: function () {

                    BrowserUtil.browse("http://www.faa.gov/library/manuals/aircraft/media/faa-h-8083-1a.pdf");
                }
            }
    var faaWebLink = Hyperlink {
                visited: true
                layoutX: 20
                layoutY: 345
                text: "FAA Website"
                action: function () {

                    BrowserUtil.browse("http://www.faa.gov/");
                }
            }
    var beechcraftSite = Hyperlink {
                visited: true
                layoutX: 20
                layoutY: 365
                text: "Hawker Beechcraft Website"
                action: function () {

                    BrowserUtil.browse("http://www.hawkerbeechcraft.com/");
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
                layoutY: 610
                text: "Back >>";
                action: function () {
                    timeline.stop();
                    fade.stop();
                    currImg = image;
                    delete this from scene.content;
                }
                cursor: Cursor.HAND
            }
    var separator1 = Separator {
                vertical: false
                layoutX: 13
                layoutY: 640
                layoutInfo: LayoutInfo {width: 950 }
            }
    var separator2 = Separator {
                vertical: true
                layoutX: 400
                layoutY: 250
                layoutInfo: LayoutInfo {height: 350 }
            }

    public override function create(): Node {
        return Group {
                    content: [background, imageView, title, closeButton, modelText,
                    separator1,helpText, separator2, helpPoints, gerGuidesHeader, refHeader, references, faaLink, faaWebLink, beechcraftSite, disclaimerHeader, disclaimerText]
                };
    }

}
