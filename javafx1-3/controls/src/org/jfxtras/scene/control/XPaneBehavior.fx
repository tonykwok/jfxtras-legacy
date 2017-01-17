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
package org.jfxtras.scene.control;

import javafx.scene.control.Behavior;
import javafx.scene.input.MouseEvent;
import javafx.animation.transition.FadeTransition;

/**
 * The behavior of the XPane control.  Provides functions that handle mouse actions on the skin.
 *
 * @author Dean Iverson
 */
public class XPaneBehavior extends Behavior {
    /**
     * The duration during which the pane will fade out when the close button is pressed.
     */
    public var fadeDuration = 250ms;

    var lastDragX = 0.0;
    var lastDragY = 0.0;

    /**
     * Should be called by the skin every time a mouse press occurs over the title bar.
     */
    public function titleBarPress( me:MouseEvent ) {
        lastDragX = lastDragY = 0.0;
    }

    /**
     * Should be called by the skin every time a mouse drag occurs over the title bar.
     */
    public function titleBarDrag( me:MouseEvent ) {
        if ((skin.control as XPane).draggable) {
            skin.node.translateX += me.dragX - lastDragX;
            skin.node.translateY += me.dragY - lastDragY;
            lastDragX = me.dragX;
            lastDragY = me.dragY;
        }
    }

    /**
     * Called whenever the close button is clicked on.  Handles calling the onClose after the button
     * fades out.
     */
    public function closeButtonClick() {
        def control = skin.control as XPane;
        FadeTransition {
            node: control
            toValue: 0.0
            duration: fadeDuration
            action: function() {
                control.onClose();
            }
        }.playFromStart()
    }
}
