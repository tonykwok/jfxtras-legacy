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
import cargoloader.envelope.Envelope;
import javafx.scene.effect.Glow;
import javafx.scene.effect.Shadow;
import javafx.scene.paint.Color;
import javafx.scene.shape.Rectangle;
import javafx.scene.Node;
import javafx.scene.CacheHint;
import javafx.scene.Group;
import javafx.scene.input.MouseEvent;
import cargoloader.envelope.EnLargedEnvelope;

/**
 * panel containing a weight vs center-of-gravity graph.
 * @author Abhilshit Soni
 */
public class GraphPanel extends Panel {

    public var anotherChart: Node = null;
    public var isBig: Boolean;
    public var envelope = Envelope {
                id: "envelope"
                scaleX: 0.70
                scaleY: 0.90
                cacheHint: CacheHint.SCALE_AND_ROTATE
                translateX: 443 translateY: 260
            }
    public var enlargedEnvelope = EnLargedEnvelope {
                envelope: bind this.envelope
            };

    init {
        cache = true;

        onMouseClicked = function (e: MouseEvent): Void {
                    delete envelope from scene.content;
                    envelope.scaleX = 1.2;
                    envelope.scaleY = 1.2;
                    envelope.translateX = 200;
                    envelope.translateY = 80;
                    delete envelope from enlargedEnvelope.finalGroup.content;
                    insert envelope into scene.content;
                    insert enlargedEnvelope into scene.content;
                    for (i in scene.content) {
                        //println("id's {id}");
                        if (i.id.equals("envelope")) {
                            i.toFront();
                            break;
                        }

                    }

                }
    }

    var envelopeBorder = Rectangle {
                cache: true
                cacheHint: CacheHint.SCALE_AND_ROTATE
                x: envelope.translateX + 102
                y: envelope.translateY + 27
                fill: Color.CADETBLUE
                width: 379;
                height: 375;
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
    var envelopeBG = Rectangle {
                cache: true
                x: envelope.translateX + 102
                y: envelope.translateY + 27
                fill: Color.BLACK
                width: 379;
                height: 375;
                arcWidth: 15
                arcHeight: 15
            }

    init {
        isBig = true;

        var tempGroup = Group {
                    content: [envelopeBorder, envelopeBG, envelope]
                }

        content = [tempGroup];

    }

}
