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

import javafx.scene.CustomNode;

import javafx.scene.Node;

import javafx.scene.Group;

import javafx.scene.image.Image;
import javafx.scene.image.ImageView;

import com.citytechinc.ria.mefxmobile.model.Artist;

/**
 * @author sanderson
 */

public class MusicExplorerFX extends CustomNode {

    public var width:Number;
    public var height:Number;
    public var artistHistory:Artist[];

    var displays:Display[];

    var currentDisplay:Display;

    override public function create():Node {
        var logo = ImageView {
            image: Image {
                //url: "{__DIR__}../images/MusicExplorerFX4.PNG"
                url: "{__DIR__}MusicExplorerFX4.PNG"
                preserveRatio: true
                width: width
            }
        }
        var titleImageHeight = logo.image.height;

        insert ArtistSearch {
            width: bind width
            height: bind height - titleImageHeight
            musicExplorer: this
            translateY: titleImageHeight
        } into displays;
        
        insert ArtistExplorer {
            width: bind width
            height: bind height - titleImageHeight
            musicExplorer: this
            translateY: titleImageHeight
        } into displays;

        insert SimilarArtists {
            width: bind width
            height: bind height - titleImageHeight
            musicExplorer: this
            translateY: titleImageHeight
        } into displays;

        insert HistoryDisplay {
            width: bind width
            height: bind height - titleImageHeight
            musicExplorer: this
            translateY: titleImageHeight
        } into displays;

        setCurrentDisplay("search");

        Group {
            content: bind [logo, currentDisplay]
        }

    }

    public function setCurrentDisplay(displayName:String) {
        if (currentDisplay != null) {
            currentDisplay.stop(function() {doSetCurrentDisplay(displayName)});
        }
        else {
            doSetCurrentDisplay(displayName);
        }

    }

    function doSetCurrentDisplay(displayName:String) {
        var display = displays[d | d.getName().equals(displayName)];
        if (sizeof display == 0) {
            println ("MusicExplorerFX Error: Couldn't find display named {displayName}");
            return;
        }

        currentDisplay = display[0];
        currentDisplay.start();
    }

    public function getCurrentArtist() {
        artistHistory[sizeof artistHistory - 1];
    }

    public function setCurrentArtist(artist:Artist) {
        insert artist into artistHistory;
    }


}
