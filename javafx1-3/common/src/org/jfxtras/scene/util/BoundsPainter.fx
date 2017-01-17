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
package org.jfxtras.scene.util;

import javafx.scene.CustomNode;
import javafx.scene.Group;
import javafx.scene.Node;
import javafx.scene.shape.Rectangle;
import javafx.scene.paint.Color;

/**
 * Helper class for testing layouts that paints its bounds so you can see
 * the result of the layout algorithm.
 *
 * @profile common
 *
 * @author Dean Iverson
 */
public class BoundsPainter extends CustomNode {
    public-init var targetNode: Node;

    override function create() {
        Group {
            content: [
                targetNode,
                Rectangle {
                    x: bind targetNode.boundsInLocal.minX 
                    y: bind targetNode.boundsInLocal.minY
                    width: bind targetNode.boundsInLocal.width
                    height: bind targetNode.boundsInLocal.height
                    fill: Color.TRANSPARENT
                    stroke: Color.BLUE
                },
                Rectangle {
                    x: bind targetNode.layoutBounds.minX
                    y: bind targetNode.layoutBounds.minY
                    width: bind targetNode.layoutBounds.width
                    height: bind targetNode.layoutBounds.height
                    fill: Color.TRANSPARENT
                    stroke: Color.YELLOW
                    strokeDashArray: [10.0, 10.0]
                    strokeDashOffset: 5
                },
                Rectangle {
                    x: bind targetNode.boundsInParent.minX
                    y: bind targetNode.boundsInParent.minY
                    width: bind targetNode.boundsInParent.width
                    height: bind targetNode.boundsInParent.height
                    fill: Color.TRANSPARENT
                    stroke: Color.RED
                    strokeDashArray: [10.0, 10.0]
                },
            ]
        }
    }
}
