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

import javafx.scene.shape.Rectangle;
import org.jfxtras.scene.XCustomNode;
import org.jfxtras.scene.layout.XLayoutInfo.*;

/**
 * Spacer that can be used to leave blank cells in a layout container.  By
 * default the spacer will grow to take available space unless there is another
 * item with a higher grow priority.  The priority can be changed using the hgrow
 * and vgrow variables.
 * <p>
 * The default preferred width and height is 10, which can be overridden using
 * the w and h variables.
 *
 * @author Stephen Chin
 */
public class XSpacer extends XCustomNode {
    /** The preferred width of this spacer */
    public var w:Number = 10;
    /** The preferred height of this spacer */
    public var h:Number = 10;
    /** The horizontal grow priority of this spacer */
    public var hgrow = SOMETIMES;
    /** The vertical grow priority of this spacer */
    public var vgrow = SOMETIMES;
    /** The horizontal shrink priority of this spacer */
    public var hshrink = ALWAYS;
    /** The vertical shrink priority of this spacer */
    public var vshrink = ALWAYS;

    override function getPrefWidth(h) {w}
    override function getPrefHeight(w) {h}
    override function getHFill() {true}
    override function getVFill() {true}
    override function getHGrow() {hgrow}
    override function getVGrow() {vgrow}
    override function getHShrink() {hshrink}
    override function getVShrink() {vshrink}

    override function create() {
        Rectangle {
            width: bind width
            height: bind height
            fill: null
        }
    }
}
