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

import javafx.scene.Node;
import javafx.scene.control.Control;
import javafx.scene.layout.Container;
import javafx.scene.paint.Color;
import javafx.scene.paint.Paint;
import org.jfxtras.scene.control.skin.XPaneSkin;
import com.sun.javafx.scene.control.skin.SkinAdapter;

/**
 * A simple control that can act as a background for a content node.  Optionally the
 * control can have a title bar with an icon, text, and a close button.  The pane
 * can also be dragged to reposition it if the <code>draggable</code> property is set
 * to true.
 *
 * Using the default skin, the control will respond to the standard <code>base</code>
 * color for styling.  The base color is used for the title bar.
 *
    @example
    import org.jfxtras.scene.control.XPane;
    import javafx.scene.paint.*;

    XPane {
        title: "Styled Draggable Pane"
        style: "base: green; background: lemonchiffon"
        draggable: true
        closable: true
        upperLeftArc: 10
        upperRightArc: 10
        contentNode: Label { text: "This is the content." }
    }
    @endexample
 *
 * @profile desktop
 * @author Dean Iverson
 */
public class XPane extends Control {
    override var styleClass = "xpane";

    /**
     * The control's skin.  Defaults to the Caspian skin.
     */
    override var skin = XPaneSkin {}

    /**
     * The text for the title bar.  If not set, the title bar will not be visible (unless the
     * control is closable).
     */
    public var title = "";

    /**
     * The graphic for the title bar.  Will be displayed to the left of the title text.
     */
    public var titleGraphic:Node;

    /**
     * The node to be shown in the content area of the pane.
     */
    public var contentNode:Node;

    /**
     * If true, the pane can be dragged around by its title bar.
     */
    public var draggable = false;

    /**
     * If true, the title bar will display a close button.  When clicked, the control
     * will call the <code>onClose</code> button.
     */
    public var closable = false;

    /**
     * Called when the pane is closable and the close button has been clicked.  The XPane will be faded out
     * and then this function will be called to give the application a chance to remove the XPane from the
     * scene graph.
     */
    public var onClose: function(): Void;

    override var width on replace {
        (skin as XPaneSkin).requestLayout();
    }

    override var height on replace {
        (skin as XPaneSkin).requestLayout();
    }
}
