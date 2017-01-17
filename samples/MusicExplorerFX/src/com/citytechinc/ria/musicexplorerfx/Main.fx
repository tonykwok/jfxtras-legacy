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
import com.citytechinc.ria.musicexplorerfx.ArtistSearch;
import com.citytechinc.ria.musicexplorerfx.ImageButton;
import com.citytechinc.ria.musicexplorerfx.model.Artist;
import com.citytechinc.ria.musicexplorerfx.model.EchoNestManager;
import com.citytechinc.ria.musicexplorerfx.model.LastfmManager;
import com.sun.labs.aura.music.web.flickr.FlickrManager;
import java.awt.Dimension;
import java.awt.Toolkit;
import javafx.lang.FX;
import javafx.scene.Node;
import javafx.scene.paint.Color;
import javafx.scene.Scene;
import javafx.stage.Stage;
import com.citytechinc.ria.musicexplorerfx.util.KeyHelper;

/**
 * @author sanderson
 */

if (not KeyHelper.checkKeys()) {
    println ("ERROR: Missing one or more API keys. Please verify that src/api_keys.properties contains entries for all of the keys.");
    FX.exit();
}


var scene:Scene;

def originalWidth:Number = 1300;
def originalHeight:Number = 1000;

def help:HelpNode = HelpNode {};

def windowedStage = Stage {
    fullScreen: false
    title: "Music Explorer FX"
    width: originalWidth
    height: originalHeight
    visible:true
    onClose: function() { FX.exit() }
}

def screensize:Dimension = Toolkit.getDefaultToolkit().getScreenSize();

def fullScreenStage = Stage {
    title: "Music Explorer FX"
    fullScreen: true
    visible: false
    width: screensize.width
    height: screensize.height
}

def w:Number = bind if (windowedStage.visible) windowedStage.width else fullScreenStage.width;
def h:Number = bind if (windowedStage.visible) windowedStage.height else fullScreenStage.height on replace {updateBounds()};


def echoNestManager = EchoNestManager {
};
def flickrManager = FlickrManager {
};
def lastfmManager = LastfmManager {
};


FX.addShutdownAction(function() {
    echoNestManager.saveCache()
});

var curNode: Node;

def explorer: ArtistExplorer = ArtistExplorer {
    width: bind w
    height: bind h
    echoNestManager: echoNestManager
    flickrManager: flickrManager
    lastfmManager: lastfmManager
    help: help
    action: function():Void {
        curNode = search;
        search.intro();
    }
}

help.explorer = explorer;

def search: ArtistSearch = ArtistSearch {
    width: bind w
    height: bind h
    explorer: explorer
    //scaleX: bind w / originalWidth
    //scaleY: bind h / originalHeight
    flickrManager: flickrManager
    lastfmManager: lastfmManager
    echoNestManager: echoNestManager
    action: function (artist:Artist):Void {
        explorer.setCurrentArtist(artist);
        curNode = explorer;
        explorer.intro();
    }

}

curNode = search;
//curNode = explorer;

function toggleFullscreen(toVis:Stage, toNotVis:Stage):Void {
    toNotVis.visible = false;
    toNotVis.scene = null;
    toVis.scene = scene;
    toVis.visible = true;

    updateBounds();

}

def buttonWidth = 50;
def fullScreenButton:ImageButton = ImageButton {
    imageUrl: "FullScreenIcon.png"
    action: function() { 
        //println("Switching to fullscreen");
        toggleFullscreen(fullScreenStage, windowedStage);
        fullScreenButton.dismiss();
        windowedButton.intro();
    }
    w: buttonWidth
}

def windowedButton:ImageButton = ImageButton {
    imageUrl: "WindowIcon.png"
    action: function() {
        //println("Switching to window");
        toggleFullscreen(windowedStage, fullScreenStage);
        windowedButton.dismiss();
        fullScreenButton.intro();
    }
    w: buttonWidth
}

function updateBounds():Void {
    fullScreenButton.translateX = w - fullScreenButton.boundsInLocal.width * 1.3;
    fullScreenButton.translateY = h - fullScreenButton.boundsInLocal.height * 1.7;
    windowedButton.translateX = w - fullScreenButton.boundsInLocal.width * 1.3;
    windowedButton.translateY = h - fullScreenButton.boundsInLocal.height * 1.7;

    //println ("updateBounds: w:{w} h:{h}");

    search.updateBounds();
    //explorer.updateBounds();
}

updateBounds();
scene = Scene {
    fill: Color.BLACK
    content: bind [
        help,
        curNode,
        fullScreenButton,
        windowedButton
    ]
}
windowedStage.scene = scene;

fullScreenButton.intro();


//var a = Artist {
//    name: "Steve Vai",
//    id: "music://id.echonest.com/~/AR/AROY6XW1187B991121",
//    echoNestManager: echoNestManager
//};

//var a = Artist {name:"Fleetwood Mac", id:"music://id.echonest.com/~/AR/AR6BJ1V1187B9AE3B7", echoNestManager:echoNestManager};
//var a = Artist {name:"Frou Frou", id:"music://id.echonest.com/~/AR/ARWD2X51187B9AE7B1", echoNestManager:echoNestManager};
//a.loadArtistData(lastfmManager, function() {
//    explorer.setCurrentArtist(a);
//});

