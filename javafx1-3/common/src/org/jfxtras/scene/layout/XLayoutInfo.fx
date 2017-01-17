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

import javafx.geometry.HPos;
import javafx.geometry.Insets;
import javafx.geometry.VPos;
import javafx.scene.layout.LayoutInfo;
import javafx.scene.layout.Priority;

/**
 * Layout constraints that can be used to give hints to different layout
 * containers about the desired bounds and alignment.
 *
 * @profile common
 *
 * @author Stephen Chin
 */
public class XLayoutInfo extends LayoutInfo {}

/**
 * hpos: Horizontally aligns to the leading edge of the cell
 */
public def LEADING = HPos.LEADING;

/**
 * hpos: Horizontally aligns to the left of the cell
 */
public def LEFT = HPos.LEFT;

/**
 * hpos: Horizontally aligns to the center of the cell
 */
public def CENTER = HPos.CENTER;

/**
 * hpos: Horizontally aligns to the right of the cell
 */
public def RIGHT = HPos.RIGHT;

/**
 * hpos: Horizontally aligns to the trailing edge of the cell
 */
public def TRAILING = HPos.TRAILING;

/**
 * hpos: Vertically aligns to the top of the container
 */
public def PAGE_START = VPos.PAGE_START;

/**
 * vpos: Vertically aligns to the top of the cell
 */
public def TOP = VPos.TOP;

/**
 * vpos: Vertically aligns to the middle of the cell (equivalent to VPos.CENTER)
 */
public def MIDDLE = VPos.CENTER;

/**
 * vpos: Vertically aligns the portion above the baseline of the component
 * to the center of the container.  The typical use case for this is to center
 * text inside of a container excluding the descenders.  To use the alignment
 * in this way, the Text origin must also be set to BASELINE.
 */
public def BASELINE = VPos.BASELINE;

/**
 * vpos: Vertically aligns to the bottom of the cell
 */
public def BOTTOM = VPos.BOTTOM;

/**
 * vpos: Vertically aligns to the bottom of the container
 */
public def PAGE_END = VPos.PAGE_END;

/**
 * vgrow/hgrow: Component will always try to grow, sharing space equally with
 * other components that have a grow of ALWAYS.
 */
public def ALWAYS = Priority.ALWAYS;

/**
 * vgrow/hgrow: If there are no other components with Priority set to ALWAYS will
 * get an equal share of the extra space.
 */
public def SOMETIMES = Priority.SOMETIMES;

/**
 * vgrow/hgrow: Disables grow behavior for this component.
 */
public def NEVER = Priority.NEVER;

public function insets(top:Number, right:Number, bottom:Number, left:Number):Insets {
    Insets {top: top, right: right, bottom: bottom, left: left}
}

public function insets(topBottom:Number, leftRight:Number):Insets {
    Insets {top: topBottom, right: leftRight, bottom: topBottom, left: leftRight}
}

public function insets(size:Number):Insets {
    Insets {top: size, right: size, bottom: size, left: size}
}