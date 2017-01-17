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
package org.jfxtras.scene.layout;

import javafx.animation.Interpolator;
import javafx.geometry.HPos;
import javafx.geometry.VPos;
import javafx.scene.Node;
import javafx.scene.layout.LayoutInfo;
import org.jfxtras.scene.XCustomNode;

/**
 * Drop-in replacement for VBox that supports resizing of children to fit the
 * available space.  XLayoutInfo can be used with this class
 * to specify grow behavior.
 *
 * @profile desktop
 *
 * @author Stephen Chin
 */
public class XVBox extends XCustomNode {
    public var spacing:Number;

    /**
     * The horizontal position of each node within the XVBox's row.
     * <p>
     * This is offered for compatibility only, but the recommended practice is
     * to assign a layoutInfo with the desired horizontal position.  If layoutInfo
     * is set, this parameter is not used.
     */
    public var hpos:HPos;

    /**
     * The vertical position of each node within the XVBox's column.
     * <p>
     * This is offered for compatibility only, but the recommended practice is
     * to assign a layoutInfo with the desired vertical position.  If layoutInfo
     * is set, this parameter is not used.
     */
    public var vpos:VPos;

    /**
     * The horizontal position of each node within the XVBox's row.
     */
    public var nodeHPos:HPos;

    public var content:Node[];

    public var animate = false;

    public var animationDuration:Duration = 500ms;

    public var animationInterpolator = Interpolator.EASEOUT;

    init {
        if (layoutInfo == null) {
            layoutInfo = LayoutInfo {
                hpos: bind hpos
                vpos: bind vpos
            }
        }
    }

    override function create() {
        XGrid {
            animate: bind animate
            animationDuration: bind animationDuration
            animationInterpolator: bind animationInterpolator
            vgap: bind spacing
            nodeHPos: bind nodeHPos
            rows: bind for (node in content) XGridRow {
                cells: node
            }
        }
    }
}
