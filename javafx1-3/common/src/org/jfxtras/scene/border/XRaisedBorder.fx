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


package org.jfxtras.scene.border;

import javafx.scene.paint.Color;
import com.sun.javafx.UtilsFX;

/**
 * @author jclarke
 */

public abstract class XRaisedBorder extends XBorder {
    /**
     * Indicates whether the border appears raised or lower
     *
     * @defaultValue true
     */
    public var raised = true;

    /**
     * Defines the base border color
     *
     * @css highlight-outer
     */
    public var borderColor: Color = accent on replace {
        highlight  = UtilsFX.deriveColor(borderColor, .20);
        highlightInner = UtilsFX.deriveColor(highlight, .60);
        shadow = UtilsFX.deriveColor(borderColor, -.40);
        shadowOuter = UtilsFX.deriveColor(borderColor, .00);
    }

    /**
     * Defines the highlight color
     *
     * @css highlight
     */
    protected var highlight:Color;

    /**
     * Defines the highlight inner color
     */

    protected var highlightInner:Color;
    /**
     * Defines the shadow inner color
     */
    protected var shadow:Color;

    /**
     * Defines the shadow outer color
     */
    protected var shadowOuter:Color;

    public var borderWidth = 2.0 on replace { requestLayout(); }

    protected var lineWidth = bind borderWidth/2.0 on replace { requestLayout(); }
    override var borderTopWidth = bind borderWidth;
    override var borderLeftWidth = bind borderWidth;
    override var borderBottomWidth = bind borderWidth;
    override var borderRightWidth = bind borderWidth;

    protected var widthOfBorder:Number on replace { requestLayout(); };
    protected var heightOfBorder:Number on replace { requestLayout(); };
    protected var borderY: Number on replace { requestLayout(); };
    protected var borderX: Number on replace { requestLayout(); };
}
