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

import dnd.DroppableNode;
import javafx.scene.Node;
import javafx.scene.paint.Color;
import javafx.scene.shape.Rectangle;
import cargoloader.Properties;
import cargoloader.DeckPanel;
import java.lang.Void;
import javafx.scene.paint.LinearGradient;
import javafx.scene.paint.Stop;
import javafx.scene.effect.DropShadow;
import javafx.scene.effect.InnerShadow;

/**
 * just a rectangle denoting a position on the aircrafts deck where a user can place cargo container.
 * @author Abhilshit Soni
 */
public class PositionNode extends DroppableNode {

    public var planData: PlanData;
    /**
     * distance to the centroid of this position from a reference point called datum (generally nose of aircraft)
     */
    public var fuselageStation: Number;
    /**
     * moment = weight of the ULD placed on this position multiplied by fuselage station
     */
    public var moment: Number;

    override protected function create(): Node {
        return Rectangle {
                    cache: true
                    width: Properties.width, height: Properties.height;
                    arcWidth: 5
                    arcHeight: 5
                    fill: LinearGradient {
                        startX: 0, endX: 0, startY: 0, endY: 1
                        stops: [
                            Stop {offset: 0, color: Color.RED }
                            Stop {offset: 1, color: Color.MAROON }
                        ]
                    }
                    effect: InnerShadow {
                        color: Color.rgb(0, 0, 0, 0.7)
                        offsetX: 1, offsetY: 1
                        radius: 1
                        input: DropShadow {
                            offsetX: 1
                            offsetY: 1
                            color: Color.RED
                            radius: 1
                        }
                    }
                }
    }

    override public function onDrop(): Void {
        planData.update(parent as DeckPanel);
    }

    override public function onRevert(): Void {
        planData.update(parent as DeckPanel);
    }

}
