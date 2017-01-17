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

import javafx.geometry.VPos;
import javafx.scene.Node;
import javafx.scene.layout.Priority;

/**
 * Container of cells for a row in an {@link XGrid}.
 *
 * @profile common
 * @see XGrid
 * @author Stephen Chin
 * @author Keith Combs
 */
public class XGridRow {
    /**
     * Contents of this row.
     */
    public var cells:Node[];

    /**
     * The column to start layout in.  This is zero based will skip over an
     * equal number of columns to its value.
     */
    public var column:Integer = 0;

    /**
     * A fixed percentage of the Grid height to use for this row.
     * This overrides all the other layout settings, and should not
     * exceed 100% (1.0) for the sum of all the rows.
     */
    public var percentage:Number;

    /**
     * If set, will override the Row's minimum height.
     */
    public var minHeight:Number;

    /**
     * If set, will override the Row's preferred height.
     */
    public var height:Number;

    /**
     * If set, will override the Row's maximum height.
     */
    public var maxHeight:Number;

    /**
     * If set, will override the Row's vertical grow priority.
     */
    public var vgrow:Priority;

    /**
     * If set, will override the Row's vertical shrink priority.
     */
    public var vshrink:Priority;

    /**
     * If set, will override the Row's fill policy.
     */
    public var vfill:Boolean;

    /**
     * If set, will override the Row's vertical positioning policy.
     */
    public var vpos:VPos;

    override function toString() {
        "GridRow \{cells={cells.toString()}, column={column}, percentage={percentage}, minHeight={minHeight}, height={height}, maxHeight={maxHeight}, vgrow={vgrow}, vshrink={vshrink}\}"
    }
}
