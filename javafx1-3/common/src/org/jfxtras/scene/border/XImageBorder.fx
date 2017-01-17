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

import javafx.scene.image.Image;
import javafx.scene.image.ImageView;

/**
 * @author jclarke
 */
public class XImageBorder extends XBorder {
    /**
     * The background image
     */
    public var image:Image;

    /**
     * Indicates that the Image should preserve its aspect ratio
     * when being fitted to the size of the border. If preserveRatio is true,
     * then extra space will be in the backgroundFill color
     * @defaultvalue false
     */
    public var preserveRatio:Boolean;

    override var borderTopWidth = 10;
    override var borderLeftWidth = 10;
    override var borderBottomWidth = 10;
    override var borderRightWidth = 10;
    
    def imageBorder = ImageView {
        preserveRatio: bind preserveRatio
        image: bind image
        smooth: true
    }

    public override function doBorderLayout(x:Number, y:Number, w:Number, h:Number):Void {
        imageBorder.layoutX = x;
        imageBorder.layoutY = y;
        imageBorder.fitWidth = w;
        imageBorder.fitHeight = h;
        background = imageBorder;
    }
}
