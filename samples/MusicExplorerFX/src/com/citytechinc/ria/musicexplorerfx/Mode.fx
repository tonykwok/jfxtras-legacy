/*
 * Copyright (c) 2009, Sten Anderson, CITYTECH, INC.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 * 1. Redistributions of source code must retain the above copyright notice,
 *    this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 * 3. Neither the name of CITYTECH, INC. nor the names of its contributors may be used
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
 
package com.citytechinc.ria.musicexplorerfx;

import com.citytechinc.ria.musicexplorerfx.ArtistExplorer;
import com.citytechinc.ria.musicexplorerfx.ImageButton;
import javafx.scene.Node;

/**
 * A Mode roughly corresponds to a "screen" in the main application. The three
 * modes of the application are "Similarity", "Artist Info", and "Image Gallery" and
 * are generally transitioned between each other via the button bar below the
 * main artist.
 *
 * @author sanderson
 */

public abstract class Mode {

    public var explorer: ArtistExplorer;
    public var buttons: ImageButton[];
    public var nodes: Node[];

    var leftEdge = bind explorer.centerX - explorer.nodeWidth / 2;
    protected var buttonWidth = explorer.nodeWidth / 4;
    protected var buttonSlots:Number[] = bind [leftEdge, leftEdge + buttonWidth, leftEdge + buttonWidth * 2, leftEdge + buttonWidth * 3];

    postinit {
        buttons = [
            ImageButton {
                x: bind buttonSlots[0]
                imageUrl: "SearchIcon.png"
                action: explorer.dismiss
                w: buttonWidth
            }
            ImageButton {
                x: bind buttonSlots[3]
                imageUrl: "HelpIcon.png"
                action: function() {explorer.showHelp() }
                w: buttonWidth
            }
        ]
    }

    public abstract function start():Void;

    public abstract function stop():Void;

    public abstract function updateBounds():Void;

    public function removeNode(n:Node) {
        delete n from nodes;
    }

    public function activateButtons(b:Boolean) {
        for (button in buttons) {
            button.active = b;
        }

    }

    protected function dismissButtons() {
        for (b in buttons) {
            b.dismiss();
        }

    }

    public function showButtons(offsetY:Number) {
        for (b in buttons) {
            showSwitchButton(b, offsetY);
        }
    }

    function showSwitchButton(button:ImageButton, offsetY:Number) {
        button.y = offsetY;
        button.intro();
    }

}
