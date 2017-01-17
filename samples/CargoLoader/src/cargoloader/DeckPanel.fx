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

/**
 * the panel that contains horizontal crosssection view of the aircraft where there are positions to place cargo containers.
 * @author Abhilshit Soni
 */
public class DeckPanel extends Panel {

    init {
        id = "draggableContainer";
        content = [PositionNode {
                        id: "IR";
                        fuselageStation: 465
                        translateX: Properties.startX, translateY: Properties.startY
                    }, PositionNode {
                        id: "HR";
                        fuselageStation: 435
                        translateX: Properties.startX + Properties.width + 5, translateY: Properties.startY
                    }, PositionNode {
                        id: "GR";
                        fuselageStation: 405
                        translateX: Properties.startX + ((Properties.width + 5) * 2), translateY: Properties.startY
                    }, PositionNode {
                        id: "FR";
                        fuselageStation: 375
                        translateX: Properties.startX + ((Properties.width + 5) * 3), translateY: Properties.startY
                    }, PositionNode {
                        id: "ER";
                        fuselageStation: 345
                        translateX: Properties.startX + ((Properties.width + 5) * 4), translateY: Properties.startY
                    }, PositionNode {
                        id: "DR";
                        fuselageStation: 315
                        translateX: Properties.startX + ((Properties.width + 5) * 5), translateY: Properties.startY
                    }, PositionNode {
                        id: "CR";
                        fuselageStation: 285
                        translateX: Properties.startX + ((Properties.width + 5) * 6), translateY: Properties.startY
                    }, PositionNode {
                        id: "BR";
                        fuselageStation: 255
                        translateX: Properties.startX + ((Properties.width + 5) * 7), translateY: Properties.startY
                    }, PositionNode {
                        id: "AR";
                        fuselageStation: 225
                        translateX: Properties.startX + ((Properties.width + 5) * 8), translateY: Properties.startY
                    },
                    PositionNode {
                        id: "IL";
                        fuselageStation: 465
                        translateX: Properties.startX, translateY: Properties.leftStartY
                    }, PositionNode {
                        id: "HL";
                        fuselageStation: 435
                        translateX: Properties.startX + Properties.width + 5, translateY: Properties.leftStartY
                    }, PositionNode {
                        id: "GL";
                        fuselageStation: 405
                        translateX: Properties.startX + ((Properties.width + 5) * 2), translateY: Properties.leftStartY
                    }, PositionNode {
                        id: "FL";
                        fuselageStation: 375
                        translateX: Properties.startX + ((Properties.width + 5) * 3), translateY: Properties.leftStartY
                    }, PositionNode {
                        id: "EL";
                        fuselageStation: 345
                        translateX: Properties.startX + ((Properties.width + 5) * 4), translateY: Properties.leftStartY
                    }, PositionNode {
                        id: "DL";
                        fuselageStation: 315
                        translateX: Properties.startX + ((Properties.width + 5) * 5), translateY: Properties.leftStartY
                    }, PositionNode {
                        id: "CL";
                        fuselageStation: 285
                        translateX: Properties.startX + ((Properties.width + 5) * 6), translateY: Properties.leftStartY
                    }, PositionNode {
                        id: "BL";
                        fuselageStation: 255
                        translateX: Properties.startX + ((Properties.width + 5) * 7), translateY: Properties.leftStartY
                    }, PositionNode {
                        id: "AL";
                        fuselageStation: 225
                        translateX: Properties.startX + ((Properties.width + 5) * 8), translateY: Properties.leftStartY
                    }]
    }

}
