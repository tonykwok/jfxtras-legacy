package cargoloader;
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

import javafx.scene.Node;
import javafx.scene.Group;
import dnd.DraggableNode;
import javafx.scene.paint.Color;
import javafx.scene.input.MouseEvent;

/**
 * the container that is draggable (consists of both the ULD image and the ULD border)
 * @author Abhilshit Soni
 */
public class ULDNode extends DraggableNode {

    public var uldImage: ULDImageNode = ULDImageNode {
                translateX: 5, translateY: 5
            }
    public var uldBorder: ULDBorderNode = ULDBorderNode {
                onMouseDragged: function (e: MouseEvent): Void {
                    if (dropIndicator) {
                        uldBorder.borderFill = Color.GREEN;
                    } else {
                        uldBorder.borderFill = Color.ORANGE
                    }
                }
                onMouseReleased: function (e: MouseEvent): Void {
                    uldBorder.borderFill = Color.CADETBLUE;
                }
            }
    var uldGroup: Group = Group {
                cache: true
                content: [uldBorder, uldImage]
            }

    override protected function create(): Node {
        return uldGroup;
    }

}
