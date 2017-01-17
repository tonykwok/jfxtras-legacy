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
package com.citytechinc.ria.mefxmobile.ui;

import javafx.scene.Node;
import javafx.scene.Group;
import com.citytechinc.ria.mefxmobile.ui.widget.ImageButton;

/**
 * @author sanderson
 */

public class ArtistExplorer extends Display {

    var currentNode:ArtistNode;
        
    override public function create():Node {
        var historyButton = ImageButton  {
            imageUrl: "IconsPhoneBack"
            x: 0
            w: width / 3
            action: function() {setCurrentDisplay("history")}
        }

        var similarButton = ImageButton  {
            imageUrl: "IconsPhoneSimilar"
            x: bind width / 3
            w: width / 3
            action: function() {
                setCurrentDisplay("similar")
            }
        }
        var searchButton = ImageButton  {
            imageUrl: "IconsPhoneSearch"
            x: bind width * 2 / 3
            w: width / 3
            action: function() {setCurrentDisplay("search")}
        }
        historyButton.y = height - historyButton.boundsInLocal.height;
        similarButton.y = height - similarButton.boundsInLocal.height;
        searchButton.y = height - searchButton.boundsInLocal.height;
        Group {
            content: bind [currentNode, historyButton, searchButton, similarButton]
        }

    }

    override public function start() {
        super.start();
        var node = ArtistNode {
            artist: musicExplorer.getCurrentArtist()
            width: width - 2
        }
        currentNode = node;
    }


    override public function getName():String {
        "explorer"
    }

}
