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
import com.citytechinc.ria.musicexplorerfx.model.EchoNestManager;
import com.citytechinc.ria.musicexplorerfx.model.LastfmManager;
import com.sun.labs.aura.music.web.flickr.FlickrManager;
import javafx.animation.transition.FadeTransition;
import javafx.scene.CustomNode;
import javafx.scene.Group;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;
import javafx.scene.Node;
import javafx.scene.paint.Color;
import javafx.scene.paint.LinearGradient;
import javafx.scene.paint.Stop;
import javafx.scene.shape.Rectangle;
import javafx.scene.text.Font;
import javafx.scene.text.Text;



/**
 * This is the main "screen" that controls the artists nodes and history, etc.
 * It also manages the transition between the various modes (e.g. Similarity,
 * Image Gallery, etc).
 *
 * To make it visible, first call "intro()".
 *
 * @author sanderson
 */

public class ArtistExplorer extends CustomNode {

    public-read var centerX: Number;
    public-read var centerY: Number;
    public-read var nodeWidth: Number = 270;
    public-read var currentNode: ArtistNode;
    public-read var history: ArtistNode[];
    public-read var active = true;

    public-init var echoNestManager: EchoNestManager;
    public-init var flickrManager: FlickrManager;
    public-init var lastfmManager: LastfmManager;
    public-init var help:HelpNode;

    public var controls: Group;

    public var width: Number on replace { updateBounds() };
    public var height: Number on replace { updateBounds() };

    public var action: function():Void;

    var artistInfoMode: ArtistInfoMode;
    var similarMode: SimilarMode;
    var galleryMode: GalleryMode;
    var currentMode: Mode;
    var modes:Mode[];
    
    var maxHistory:Integer = bind (width - 100) / 100 as Integer;

    var audioPlayer: AudioPlayer;
    var statusNode: Text;
    var statusStr: String;
    var progress:ProgressBar;

    var showStatusTransition: FadeTransition;
    var hideStatusTransition: FadeTransition;

    var logo:ImageView;
    var scale:Number = 1.0;
    var background:ImageView;

    var twitterPanel:TwitterPanel;
    var twitterButton:ImageButton;
    var group:Group;

    override function create():Node {
        opacity = 0;
        artistInfoMode = ArtistInfoMode {
            explorer: this
        }
        similarMode = SimilarMode {
            explorer: this
        }
        galleryMode = GalleryMode {
            explorer: this
        }
        currentMode = similarMode;
        //currentMode = artistInfoMode;

        twitterPanel = TwitterPanel {
            y: 50
            explorer:this
        };

        modes = [artistInfoMode,similarMode,galleryMode];

        progress = ProgressBar {
            w: nodeWidth
        }
        statusNode = Text {
            opacity: 0
            content: bind statusStr
            fill: Color.WHITESMOKE
            font: Font {
                size: 18
            }
            translateY: height - 50
            translateX: 600
        }
        showStatusTransition = FadeTransition {
            node: statusNode
            duration: 2s
            fromValue: 0
            toValue: 1
        }
        hideStatusTransition = FadeTransition {
            node: statusNode
            duration: 1s
            fromValue: 1
            toValue: 0
        }
        logo = ImageView {
            image: Image {
                url: "{__DIR__}images/MusicExplorerFX3.png"
                preserveRatio: true
                smooth: true
                width: 420
            }
        }
        audioPlayer = AudioPlayer {
            w: nodeWidth - 4
            explorer: this
        }
        twitterButton = ImageButton {
            action: function() {showTwitter()}
            imageUrl: "TweetIcon.png"
            w: 50
        }
        twitterButton.translateY = 50;

        var color = Color {
            red: 0
            green: 0.1
            blue: 0.2
        }
        var leftGradient:Rectangle = Rectangle {
            cache: true
            fill: LinearGradient {
                startX: 0
                startY: 1
                endX: 1
                endY: 1
                stops: [
                    Stop {
                        offset: 0.0
                        color: Color.BLACK
                    },
                    Stop {
                        offset: 0.8
                        color: color
                    }
                    Stop {
                        offset: 1.0
                        color: Color.BLACK
                    }
                ]
            }
            height: bind height
            width: bind width / 3
            translateX: bind centerX - leftGradient.width - nodeWidth / 2

        }

        var rightGradient = Rectangle {
            cache: true
            fill: LinearGradient {
                startX: 0
                startY: 1
                endX: 1
                endY: 1
                stops: [
                    Stop {
                        offset: 0.0
                        color: Color.BLACK
                    },
                    Stop {
                        offset: 0.2
                        color: color
                    }
                    Stop {
                        offset: 1.0
                        color: Color.BLACK
                    }
                ]
            }
            height: bind height
            width: bind width / 3
            translateX: bind centerX + nodeWidth / 2

        }

        controls = Group {
            content: [
                //audioPlayer
                artistInfoMode.buttons,
                similarMode.buttons,
                galleryMode.buttons
            ]
        }
        background = ImageView {
            image: Image {
                url: "{__DIR__}images/MusicExplorerBkgd2b.jpg"
            }

        }
        updateBounds();
        group = Group {
            content: bind [
                //leftGradient
                //rightGradient
                background,
                logo,
                statusNode,
                progress,
                history,
                artistInfoMode.nodes,
                similarMode.nodes,
                galleryMode.nodes,
                controls,
                currentNode,
                audioPlayer
            ]
        }

        Group {
            content: [
                group,
                twitterPanel,
                twitterButton
            ]
        }
    }

    public function updateBounds():Void {
        centerX = width / 2;
        centerY = height / 2;

        progress.translateX = centerX - progress.boundsInLocal.width / 2;
        progress.translateY = height - 80;

        //audioPlayer.translateX = centerX - audioPlayer.boundsInLocal.width / 2 + 2;

        audioPlayer.updateBounds();

        help.translateX = centerX - help.boundsInLocal.width / 2;
        //help.translateY = centerY - help.boundsInLocal.height / 2;

        background.translateX = centerX - background.boundsInLocal.width / 2;
        background.translateY = centerY - background.boundsInLocal.height / 2;

        //nodeWidth = height / 3.7;
        //scale = height / 1000.0;

        //println ("scale: {scale}");
        if (currentNode != null) {
            //currentNode.w = nodeWidth;
            currentNode.scaleX = scale;
            currentNode.scaleY = scale;
            currentNode.translateX = centerX;
            currentNode.translateY = centerY;
            controls.scaleX = scale;
            controls.scaleY = scale;
        }
        //logo.scaleX = scale;
        //logo.scaleY = scale;
        logo.translateX = width - logo.boundsInLocal.width * scale * 1.2;
        logo.translateY = height - logo.boundsInLocal.height * scale * 1.7;
        updateControlsY();
        updateHistory();

        similarMode.updateBounds();
        artistInfoMode.updateBounds();
        galleryMode.updateBounds();

        //scaleX = scale;
        //scaleY = scale;

        twitterPanel.translateX = width - twitterPanel.boundsInLocal.width - 100;
        twitterButton.translateX = width - twitterButton.boundsInLocal.width - 30;
    }

    function showTwitter() {
        setEnabled(false);
        var firstArtist = history[sizeof history - 1].artist.name;
        var secondArtist = currentNode.artist.name;
        var steps = if (sizeof history > 1) "steps" else "step";
        twitterPanel.intro("My Music Explorer FX journey took me from {firstArtist} to {secondArtist}  in {sizeof history} {steps}");
    }


    function updateHistory() {
        for (h in history) {
            h.moveToHistory((maxHistory - indexof h - 1) * 100 + 50, 80);
        }

        if (sizeof history > maxHistory + 1) {
            var n = history[sizeof history - 1];
            delete n from history;
        }
    }

    public var nodeClicked = function(a:ArtistNode):Void {
        if (not currentNode.equals(a)) {
            setCurrentNode(a);
        }
    }


    public function setCurrentArtist(artist:Artist):Void {
        currentNode = ArtistNode {
            x: centerX
            y: centerY
            //w: nodeWidth
            artist: artist
            explorer: this
            similarMode: similarMode
            action: nodeClicked
            isCurrent: true
        }
        currentNode.ready = true;
        updateControlsY();
        playAudio(currentNode.artist);

        currentMode.start();
    }

    function reset():Void {
        delete history;
        currentMode.stop();

        currentNode = null;
        audioPlayer.reset();
        twitterButton.dismiss();
    }

    public function setEnabled(enable:Boolean) {
        activateButtons(enable);
        active = enable;
        FadeTransition {
            node: group
            duration: 0.5s
            toValue: if (enable) 1 else 0.4
        }.play();
    }


    public function dismiss():Void {
        reset();
        FadeTransition {
            action: function() {action()
            }
            node: this
            duration: 1s
            fromValue: 1
            toValue: 0
        }.play();
    }

     public function showHelp():Void {
        active = false;
        activateButtons(false);
        FadeTransition {
            action: function() {help.show()}
            node: this
            duration: 1s
            fromValue: 1
            toValue: 0
        }.play();
    }

    function activateButtons(b:Boolean) {
        for (m in modes) {
            m.activateButtons(b);
        }
    }


    public function intro() {
        active = true;
        activateButtons(true);

        FadeTransition {
            node: this
            duration: 1s
            fromValue: 0
            toValue: 1
        }.play();
    }

    public function switchToSimilarMode() {
        switchMode(similarMode);
    }

    public function switchToGalleryMode() {
        switchMode(galleryMode);
    }

    public function switchToArtistInfoMode() {
        switchMode(artistInfoMode);
    }

    function switchMode(newMode:Mode) {
        currentMode.stop();
        currentMode = newMode;
        currentMode.start();
    }


    public function playAudio(artist:Artist) {
        audioPlayer.setArtist(artist);
    }

    public function setCurrentNode(node:ArtistNode):Boolean {
        
        node.removeFromParent();
        if (currentNode != null) {
            twitterButton.intro();
            currentNode.hideAudio();
            delete node from currentNode.similar;
            currentMode.stop();
            //delete currentNode.similar;
            currentNode.isCurrent = false;

            var nodeIndex = getNodeIndexInHistory(node);
            if (nodeIndex >= 0) {
                node.inHistory = false;
                delete history [0..nodeIndex];
            }
            var oldNode = currentNode;
            currentNode = null;
            insert oldNode before history[0];
            oldNode.inHistory = true;

            updateHistory();

        }
        audioPlayer.reset();
        
        currentNode = node;
        currentNode.isCurrent = true;
        currentNode.ready = false;

        switchToSimilarMode();
        currentNode.moveTo(centerX, centerY, 1.0, function() {
            updateControlsY();
            playAudio(node.artist);
            showModeButtons();
        });


        true
    }

    function updateControlsY() {
        var audioOffset = if (audioPlayer.hasAudio()) 0 else audioPlayer.boundsInLocal.height;
        controls.translateY = centerY + (currentNode.defaultHeight * scale) / 2 + 1 - audioOffset;

    }


    public function modeStarted(mode:Mode):Void {
        if (currentMode != mode) {
            return;
        }
        if (currentNode != null and currentNode.ready) {
            showModeButtons();
        }
    }

    public function audioInitialized(foundAudio:Boolean):Void {
        if (foundAudio) {
            currentNode.showAudio(audioPlayer);

        }
    }

    function showModeButtons() {
        currentMode.showButtons(audioPlayer.boundsInLocal.height);
    }

    public function startProgress() {
        progress.setIndeterminate();
    }

    public function setProgress(value:Integer, max:Integer) {
        progress.stop();
        progress.setProgress(value, max);
    }

    public function dismissProgress() {
        progress.dismiss();
    }

    public function stopProgress() {
        progress.stop();
    }


    public function showStatus(str:String):Void {
        statusStr = str;
        statusNode.translateX = centerX - statusNode.boundsInLocal.width / 2;
        hideStatusTransition.stop();
        showStatusTransition.playFromStart();
    }

    public function hideStatus():Void {
        showStatusTransition.stop();
        hideStatusTransition.playFromStart();
    }

    function getNodeIndexInHistory(node:ArtistNode):Integer {
        var index = -1;

        for (i in [0..<sizeof history]) {
            if (history[i] == node) {
                index = i;
                break;
            }

        }

        index
    }

}
