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

import javafx.scene.layout.Panel;
import javafx.scene.effect.Glow;
import javafx.scene.effect.Shadow;
import javafx.scene.paint.Color;
import javafx.scene.shape.Rectangle;
import cargoloader.ULDNode;
import javafx.scene.image.ImageView;
import javafx.scene.image.Image;
import javafx.scene.control.Label;
import javafx.scene.layout.LayoutInfo;
import javafx.scene.text.Font;

/**
 * the panel which contains the set of cargo containers.
 * @author Abhilshit Soni
 */
public class ULDPanel extends Panel {

    var startX = 15;
    var startY = 27;
    var deckImageBorder = Rectangle {
                cache: true
                x: startX - 8
                y: startY + 3
                fill: Color.CADETBLUE
                width: startX + 210;
                height: startY + 400;
                arcWidth: 15
                arcHeight: 15
                effect: Glow {
                    level: 1
                    input: Shadow {
                        // offsetX: -5
                        // offsetY: 5
                        width: 5
                        color: Color.CADETBLUE
                        radius: 15
                    }
                }
                opacity: 0.5
            }
    var deckImageBg = Rectangle {
                cache: true;
                x: startX - 7
                y: startY + 5
                fill: Color.BLACK
                width: deckImageBorder.width - 2;
                height: deckImageBorder.height - 2;
                arcWidth: 15
                arcHeight: 15
            }
    var deckImageHeader = Rectangle {
                x: 30
                y: 15
                fill: Color.BLACK
                width: deckImageBorder.width - 50;
                height: 20;
                arcWidth: 5
                arcHeight: 5
                opacity: 1
            }
    var header = Label {
                layoutX: 48
                layoutY: 25
                textFill: Color.WHITE
                font: Font {size: 15 }
                layoutInfo: LayoutInfo {width: deckImageBorder.width - 50 }
                text: "CARGO CONTAINERS"
            }

    init {

        id = "uldPanel";
        content = [deckImageBorder, deckImageBg, deckImageHeader, header,
                    ULDNode {
                        dataObject: ULD {
                            weight: 400
                        }
                        translateX: startX + 0 translateY: startY + 25
                        dragAnimate: true
                    }, ULDNode {
                        dataObject: ULD {
                            weight: 200
                        }
                        translateX: startX + 0 translateY: startY + 90
                        dragAnimate: true
                    }, ULDNode {
                        dataObject: ULD {
                            weight: 100
                        }
                        translateX: startX + 0 translateY: startY + 155
                        dragAnimate: true
                    }, ULDNode {
                        dataObject: ULD {
                            weight: 426
                        }
                        translateX: startX + 0 translateY: startY + 220
                        dragAnimate: true
                    }, ULDNode {
                        dataObject: ULD {
                            weight: 120
                        }
                        translateX: startX + 0 translateY: startY + 285
                        dragAnimate: true
                    }, ULDNode {
                        dataObject: ULD {
                            weight: 240
                        }
                        translateX: startX + 0 translateY: startY + 350
                        dragAnimate: true
                    }, ULDNode {
                        dataObject: ULD {
                            weight: 357
                        }
                        translateX: startX + 70 translateY: startY + 25
                        dragAnimate: true
                    }, ULDNode {
                        dataObject: ULD {
                            weight: 470
                        }
                        translateX: startX + 70 translateY: startY + 90
                        dragAnimate: true
                    }, ULDNode {
                        dataObject: ULD {
                            weight: 229
                        }
                        translateX: startX + 70 translateY: startY + 155
                        dragAnimate: true
                    }, ULDNode {
                        dataObject: ULD {
                            weight: 218
                        }
                        translateX: startX + 70 translateY: startY + 220
                        dragAnimate: true
                    }, ULDNode {
                        dataObject: ULD {
                            weight: 212
                        }
                        translateX: startX + 70 translateY: startY + 285
                        dragAnimate: true
                    }, ULDNode {
                        dataObject: ULD {
                            weight: 323
                        }
                        translateX: startX + 70 translateY: startY + 350
                        dragAnimate: true
                    }
                    ULDNode {
                        dataObject: ULD {
                            weight: 233
                        }
                        translateX: startX + 140 translateY: startY + 25
                        dragAnimate: true
                    }, ULDNode {
                        dataObject: ULD {
                            weight: 250
                        }
                        translateX: startX + 140 translateY: startY + 90
                        dragAnimate: true
                    }, ULDNode {
                        dataObject: ULD {
                            weight: 370
                        }
                        translateX: startX + 140 translateY: startY + 155
                        dragAnimate: true
                    }, ULDNode {
                        dataObject: ULD {
                            weight: 210
                        }
                        translateX: startX + 140 translateY: startY + 220
                        dragAnimate: true
                    }, ULDNode {
                        dataObject: ULD {
                            weight: 110
                        }
                        translateX: startX + 140 translateY: startY + 285
                        dragAnimate: true
                    }, ULDNode {
                        dataObject: ULD {
                            weight: 250
                        }
                        translateX: startX + 140 translateY: startY + 350
                        dragAnimate: true
                    }];
        var glueImage = Image {
                    url: "{__DIR__}images/sticky2.png"
                     }

        var glueImages: ImageView[];
        for (i in content) {
            if (i instanceof ULDNode) {
                var curULDNode = (i as ULDNode);
                var uld = curULDNode.dataObject as ULD;
                curULDNode.uldBorder.weightText.content = "{uld.weight}";
                curULDNode.uldBorder.toolTip.text = "Weight = {uld.weight















} lbs \n Serial No. {uld.hashCode()}";
                var glueImageView = ImageView{
                    translateX: curULDNode.translateX;
                    translateY:curULDNode.translateY;
                    image: glueImage;
                }
              insert glueImageView into glueImages;
             }
       }
       for(i in glueImages)
       insert i after content[3];
    }

}
