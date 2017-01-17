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
package com.citytechinc.ria.mefxmobile.ui.widget;

import javafx.scene.CustomNode;

import javafx.scene.Node;

import javafx.scene.Group;

import javafx.animation.transition.TranslateTransition;
import com.citytechinc.ria.mefxmobile.ui.ArtistNode;

import com.citytechinc.ria.mefxmobile.model.Artist;
import com.citytechinc.ria.mefxmobile.ui.MusicExplorerFX;

/**
 * @author sanderson
 */

public class ImageList extends CustomNode {

    public-init var musicExplorer:MusicExplorerFX;
    public-init var width;
    public-init var action:function(artist:Artist);

    var nodes:ArtistNode[];
    public var artists:Artist[] on replace {updateNodes()};

    var currentIndex = 0;
    var gapX = width * 0.04;
    var nodeWidth = width * 0.65;
    var centerNodeX = width / 2 - nodeWidth / 2;

    override public function create():Node {
        Group {
            content: bind nodes
        }
    }

    public function clear() {
        delete nodes;
        delete artists;
    }

    function updateNodes() {
        if (sizeof artists == 0) {
            return;
        }

        delete nodes;

        nodes = for (a in artists) {
            ArtistNode {
                artist: a
                width: nodeWidth
                x: getOffsetX(indexof a) + centerNodeX
                action: function() {
                    musicExplorer.setCurrentArtist(a);
                    musicExplorer.setCurrentDisplay("explorer");

                    if (action != null) {
                        action(a);
                    }
                }
            }
        }
        currentIndex = 0;
        travel();
    }

    public function travelToEnd() {
        currentIndex = sizeof nodes - 1;
        travel();
    }

    function getOffsetX(index:Integer) {
        index * nodeWidth + index * gapX
    }

    function travel():Void {
        var destX = -getOffsetX(currentIndex);
        TranslateTransition {
            node: this
            toX: destX
            duration: 800ms
        }.playFromStart();

    }

    public function right() {
        currentIndex++;
        if (currentIndex >= sizeof nodes) {
            currentIndex = 0;
        }
        travel();
    }

    public function left() {
        currentIndex--;
        if (currentIndex < 0) {
            currentIndex = sizeof nodes - 1;
        }
        travel();
    }


}
