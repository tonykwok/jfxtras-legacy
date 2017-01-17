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

import com.citytechinc.ria.mefxmobile.ui.widget.ImageList;

import com.citytechinc.ria.mefxmobile.model.EchoNestSimilarityRequest;

import javafx.scene.paint.Color;
import javafx.scene.text.Font;
import javafx.scene.text.Text;

import com.citytechinc.ria.mefxmobile.model.Artist;
import javafx.scene.control.ProgressIndicator;

import javafx.scene.text.TextAlignment;

/**
 * @author sanderson
 */

public class SimilarArtists extends Display {

    var similarText:Text;
    var imageList:ImageList;
    var showProgress = false;

    override public function create():Node {
        var progress = ProgressIndicator {
            progress: -1
            visible: bind showProgress
            translateY: height * 0.3;
        }
        progress.translateX = width / 2 - progress.boundsInLocal.width / 2;

        similarText = Text {
            fill: Color.WHITE
            wrappingWidth: width
            textAlignment: TextAlignment.CENTER
            font: Font {
                size: width / 25
            }
            translateY: height * 0.032
        }
        layoutText();

        imageList = ImageList {
            width: width
            translateY: height * 0.1
            musicExplorer: musicExplorer
        }
        var navButtonY = height * 0.65;
        var navButtonWidth = width * 0.37;
        var navButtons = Group {
            translateY: navButtonY
            content: [
                ImageButton  {
                    imageUrl: "IconsPhoneLeft"
                    w: navButtonWidth
                    action: function() {imageList.left()}
                }
                ImageButton  {
                    imageUrl: "IconsPhoneRight"
                    x: bind width - navButtonWidth
                    w: navButtonWidth
                    action: function() {imageList.right()}
                }

            ]
        }

        var historyButton = ImageButton  {
            imageUrl: "IconsPhoneBack"
            x: 0
            w: width / 3
            action: function() {setCurrentDisplay("history")}
        }
        var similarButton = ImageButton  {
            imageUrl: "IconsPhoneHome"
            x: bind width / 3
            w: width / 3
            action: function() {setCurrentDisplay("explorer")}
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
            content: bind [similarText, imageList, navButtons, historyButton, searchButton, similarButton, progress]
        }
    }

    function layoutText() {
        similarText.content = "Artists Similar to '{musicExplorer.getCurrentArtist()}'";
        similarText.translateX = width / 2 - similarText.boundsInLocal.width / 2;
    }

    override public function start() {
        imageList.clear();
        showProgress = true;

        super.start();

        layoutText();
        EchoNestSimilarityRequest {
            similarArtist: musicExplorer.getCurrentArtist()
            onDone: parseResults
        }.start();
    }

    function parseResults(artists:Artist[]):Void {
        showProgress = false;

        var checkedList = artists[a | not isArtistInHistory(a)];

        imageList.artists = checkedList[0..4];
    }

    function isArtistInHistory(artist:Artist) {
        for (a in musicExplorer.artistHistory) {
            if (a.equals(artist)) {
                return true
            }
        }
        false
    }

    override public function getName():String {
        "similar"
    }

}
