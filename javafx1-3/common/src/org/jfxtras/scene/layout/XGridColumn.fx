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
import javafx.scene.layout.Priority;

/**
 * Column layout information used by the {@link XGrid}.
 *
 * @profile common
 * @see XGrid
 * @author Stephen Chin
 */
public class XGridColumn {
    /**
     * A fixed percentage of the Grid width to use for this column.
     * This overrides all the other layout settings, and should not
     * exceed 100% (1.0) for the sum of all the columns.
     */
    public var percentage:Number;

    /**
     * If set, will override the Row's minimum width.
     */
    public var minWidth:Number;

    /**
     * If set, will override the Row's preferred width.
     */
    public var width:Number;

    /**
     * If set, will override the Row's maximum width.
     */
    public var maxWidth:Number;

    /**
     * If set, will override the Row's horizontal grow priority.
     */
    public var hgrow:Priority;

    /**
     * If set, will override the Row's horizontal shrink priority.
     */
    public var hshrink:Priority;

    /**
     * If set, will override the Row's horizontal fill policy.
     */
    public var hfill:Boolean;

    /**
     * If set, will override the Row's horizontal positioning policy.
     */
    public var hpos:HPos;

    override function toString() {
        "GridColumn \{percentage={percentage}, minWidth={minWidth}, width={width}, maxWidth={maxWidth}, hgrow={hgrow}, hshrink={hshrink}\}"
    }
}
