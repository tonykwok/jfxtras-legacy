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

import com.citytechinc.ria.musicexplorerfx.model.Artist;

/**
 * @author sanderson
 */

public class ArtistInfoMode extends Mode {

    var maxInfo = 5;
    var currentInfo = 0;
    var artistInfoStr = "Loaded Artist Info ";
    var outerRadius: Number = explorer.width * 0.32;
    var lowerRadius: Number = explorer.width * 0.438;

    var columns:Number[];
    var rows:Number[];

    var stopped = true;

    postinit {
        updateBounds();

        insert
            ImageButton {
                x: bind buttonSlots[1]
                imageUrl: "ClonesIcon.png"
                w: buttonWidth
                action: function() {explorer.switchToSimilarMode()}

            }
            into buttons;
        insert
            ImageButton {
                x: bind buttonSlots[2]
                imageUrl: "ImagesIcon.png"
                w: buttonWidth
                action: function() {explorer.switchToGalleryMode()}

            }
            into buttons;
    }


    override public function start():Void {
        stopped = false;
        showArtistInfo();
        explorer.modeStarted(this);
    }

    override public function stop():Void {
        stopped = true;
        explorer.dismissProgress();
        dismissButtons();
        for (i in nodes) {
            (i as InfoNode).dismiss();
        }
    }

    override public function activateButtons(b:Boolean) {
        super.activateButtons(b);
        for (i in nodes) {
            (i as InfoNode).activateButtons(b);
        }

    }

    override public function updateBounds():Void {
        var paddingX = getInfoWidth() - 40;
        var paddingY = getInfoHeight();
        paddingY *= 1.1;
        var col1 = explorer.centerX - paddingX;
        var col2 = explorer.centerX + paddingX;
        var row1 = 280;
        var row2 = row1 + paddingY;//570;
        var row3 = row2 + paddingY;//840;

        columns = [col2, col2, col1, col1, col1];
        rows = [row1, row2, row3, row1, row2];

        for (i in explorer.currentNode.infoNodes) {
            i.x = columns[indexof i];
            i.y = rows[indexof i];
            i.w = getInfoWidth();
            i.h = getInfoHeight();
            i.updateBounds();
        }

    }

    public function showArtistInfo() {
        
        var currentNode = explorer.currentNode;
        delete currentNode.infoNodes;
        /*
        if (sizeof currentNode.infoNodes > 0) {
            for (n in currentNode.infoNodes) {
                insert n into nodes;
                n.intro();
            }
            explorer.modeStarted(this);
            return;
        }
        */
        explorer.startProgress();
        currentInfo = -1;
        incrementArtistInfo();
        currentNode.artist.loadReviews(function(a:Artist) {
            createInfoNode("Reviews", columns[0], rows[0], a.getReviews());
        });
        currentNode.artist.loadNews(function(a:Artist) {
            createInfoNode("News", columns[1], rows[1], a.getNews());
        });
        currentNode.artist.loadLinks(function(a:Artist) {
            createInfoNode("Links", columns[2], rows[2], a.getLinks());
        });

        currentNode.artist.loadVideo(function(a:Artist) {
            createInfoNode("Videos", columns[3], rows[3], a.getVideos());
        });
        currentNode.artist.loadBlogs(function(a:Artist) {
            createInfoNode("Blogs", columns[4], rows[4], a.getBlogs());
        });
    }

    function getInfoHeight():Number {
        return explorer.height / 4.2
    }

    function getInfoWidth():Number {
        return explorer.width / 3.0
    }

    function createInfoNode(title:String, x:Number, y:Number, items:InfoItem[]):Void {
        if (stopped) {
            return
        }

        var currentNode = explorer.currentNode;
        incrementArtistInfo();

        var node = InfoNode {
            artist: currentNode.artist
            mode: this
            title: title
            x: x
            y: y
            w: getInfoWidth()
            h: getInfoHeight()
            items: items
        }

        insert node into nodes;
        insert node into currentNode.infoNodes;

        node.intro();
    }

    function incrementArtistInfo() {
        currentInfo++;
        explorer.setProgress(currentInfo, maxInfo);
        if (currentInfo >= maxInfo) {
            explorer.dismissProgress();
            return;
        }
    }

}
