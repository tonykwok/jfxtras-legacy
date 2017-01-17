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
package com.citytechinc.ria.mefxmobile;

import com.citytechinc.ria.mefxmobile.util.KeyHelper;

import javafx.scene.Scene;
import javafx.scene.paint.Color;
import javafx.stage.Stage;
import com.citytechinc.ria.mefxmobile.ui.MusicExplorerFX;

/**
 * @author sanderson
 */

if (not KeyHelper.checkKeys()) {
    println("Missing API keys for the EchoNest and/or Last.fm web services. Please verify that the keys exist in 'api_keys.properties'.");
    FX.exit();
}

var scene:Scene = Scene {
    fill: Color.BLACK
    width: 480  // set the dimensions for desktop mode. The mobile device ignores this.
    height: 588
}

var w = bind scene.width on replace {addContent()}
var h = bind scene.height on replace {addContent()}
var contentAdded = false;

/**
 * This function creates the actual content, and will only do so if both the
 * width and height are set for the scene. For a mobile device the scene dimensions
 * are set at some point after its creation.
 */
function addContent() {
    if (contentAdded or scene.width == 0 or scene.height == 0) {
        return;
    }
    contentAdded = true;
    //println ("Adding Content w:{scene.width}, h:{scene.height}");
    scene.content =
        MusicExplorerFX {
            width: scene.width
            height: scene.height
        }
}


Stage {
    title: "Music Explorer FX Mobile"
    scene: scene

}

