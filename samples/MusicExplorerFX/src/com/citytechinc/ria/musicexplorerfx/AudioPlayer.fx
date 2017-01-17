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
import com.citytechinc.ria.musicexplorerfx.AudioButton;
import com.citytechinc.ria.musicexplorerfx.model.Artist;
import com.echonest.api.v3.artist.Audio;
import java.text.DecimalFormat;
import java.text.NumberFormat;
import javafx.animation.transition.FadeTransition;
import javafx.lang.Duration;
import javafx.scene.CustomNode;
import javafx.scene.Group;
import javafx.scene.media.Media;
import javafx.scene.media.MediaError;
import javafx.scene.media.MediaPlayer;
import javafx.scene.media.MediaView;
import javafx.scene.Node;
import javafx.scene.paint.Color;
import javafx.scene.shape.Polygon;
import javafx.scene.shape.Rectangle;
import javafx.scene.text.Text;

/**
 * @author sanderson
 */

public class AudioPlayer extends CustomNode {

    public var x: Number;
    public var y: Number;
    public var w: Number;
    public var explorer: ArtistExplorer;

    public var artist: Artist;

    var audioTracks: Audio[];

    var currentTrack = -1;
    var mediaPlayer: MediaPlayer;

    var autoPlay = false;
    var autoPlayButton:ImageButton;
    var status: String;
    var artistName: String;
    var nowPlaying: String;
    var currentAudio:Audio;

    //var curTrackUrl: String;

    var numberFormat: NumberFormat = new DecimalFormat("00");

    //var dismissTransition: FadeTransition;
    var introTransition: FadeTransition;

    var playPauseButton:AudioButton;
    var playIcon:Node;
    var pauseIcon:Node;

    //var media: Media;

    override public function create():Node {
        /*
        dismissTransition = FadeTransition {
            node: this
            fromValue: 1
            toValue: 0
            duration: 0.5s
        }
        */
        introTransition = FadeTransition {
            node: this
            fromValue: 0
            toValue: 1
            duration: 1s
        }

        opacity = 0;
        mediaPlayer = MediaPlayer {
            //autoPlay: true
            autoPlay: false
            volume: 1.0
            onBuffering: function(remaining:Duration) {
                println ("buffering {remaining}");
                status = "Buffering {remaining}";
            }
            onError: function(e:MediaError) {
                println ("media error {e}");
                status = "Media Error {e}"
            }
            onStalled: function (remaining:Duration) {
                println ("stalled {remaining}");
                status = "Stalled {remaining}"
            }
            onEndOfMedia: function() {
                println ("end of track");
                status = "End of Track";
                playNextTrack();
            }
            //media: bind media

        }
         
        var r = 10;
        var arrowLength = r * 0.75;
        var darkerColor = Color {
            red: 0,
            green: 0.1,
            blue: 0.3
        };
        /*
        var darkColor = Color {
            red: 0.1,
            green: 0.2,
            blue: 0.4
        };
        
        var medColor = Color {
            red: 0.2,
            green: 0.4,
            blue: 0.6
        };
        */
        var medColor = Color.rgb(31,48,68);
        var darkColor = Color.rgb(11,28,48);
        var lightColor = Color {
            red: 0.3
            green: 0.5
            blue: 0.6
        };

        var rectHeight = 80;
        var smallRectOffsetY = r * 4 + 5;
        var bigR = r * 1.4;
        var halfBigR = bigR / 2;
        var medR = r * 1.2;
        var buttonY = y + r * 1.7;
        var progressWidth = w * 0.9;
        var progressX = x + w / 2 - progressWidth / 2;
        var progressY = y + bigR * 2.5;

        playIcon = Polygon {
            fill: Color.BLACK
            points: [
            -halfBigR, -halfBigR,
            -halfBigR, halfBigR,
                bigR * 0.8, 0

            ]
        }

        pauseIcon = Group {
            content: [
                Rectangle {
                    fill: Color.BLACK
                    width: medR / 3
                    height: medR
                    x: -medR / 3 - 2
                    y: -medR / 2
                }
                Rectangle {
                    fill: Color.BLACK
                    width: medR / 3
                    height: medR
                    x: 2
                    y: -medR / 2
                }

            ]
        }

        var prevTrackButton:AudioButton;
        var stopButton:AudioButton;
        var gaugeHeight = 4;
        Group {
            content: [
                Rectangle {
                    //fill: medColor
                    opacity: 0.4
                    width: w
                    height: rectHeight
                    translateX: x
                    translateY: y
                },
                Rectangle {
                    //fill: Color.BLACK
                    fill: medColor
                    width: progressWidth
                    height: gaugeHeight
                    x: progressX
                    y: progressY
                }
                Rectangle {
                    fill: Color {
                        red: 0,
                        green: 0,
                        blue: 0.2
                    }
                    width: bind getProgress(mediaPlayer.bufferProgressTime, mediaPlayer.media.duration) * progressWidth
                    height: gaugeHeight
                    x: progressX
                    y: progressY
                }
                Rectangle {
                    fill: lightColor
                    width: bind getProgress(mediaPlayer.currentTime, mediaPlayer.media.duration) * progressWidth
                    height: gaugeHeight
                    x: progressX
                    y: progressY
                }

                Text {
                    fill: Color.WHITE
                    content: bind "Track {currentTrack + 1} of {sizeof audioTracks}: {nowPlaying}"
                    translateX: x + 10
                    translateY: y + smallRectOffsetY + 15
                    wrappingWidth: w * 0.9
                },

                prevTrackButton = AudioButton {
                    radius: r
                    darkColor: darkColor
                    medColor: medColor
                    lightColor: lightColor
                    //x: x + w / 2 - bigR * 4 - 3
                    x: x + r * 2
                    y: buttonY
                    icon: Group {
                        content: [
                            Polygon {
                                fill: Color.BLACK
                                points: [
                                    0, -arrowLength / 2,
                                    -arrowLength, 0,
                                    0,arrowLength / 2,
                                ]
                            }
                            Polygon {
                                fill: Color.BLACK
                                points: [
                                    arrowLength, -arrowLength / 2,
                                    0, 0,
                                    arrowLength, arrowLength / 2,
                                ]
                            }
                        ]
                    }
                    action: function() {
                        playPreviousTrack()
                    }
                }
                playPauseButton = AudioButton {
                    radius: bigR
                    darkColor: darkColor
                    medColor: medColor
                    lightColor: lightColor
                    //x: x + w / 2 - medR * 2.5
                    x: prevTrackButton.x + prevTrackButton.boundsInLocal.width + 8
                    y: buttonY
                    icon: bind updatePlayPauseIcon(mediaPlayer.status);
                    action: function() {
                        updatePlayPause();
                    }
                }
                stopButton = AudioButton {
                    radius: medR
                    darkColor: darkColor
                    medColor: medColor
                    lightColor: lightColor
                    //x: x + w / 2
                    x: playPauseButton.boundsInLocal.width + playPauseButton.x
                    y: buttonY
                    icon: Rectangle {
                        width: medR * 0.9
                        height: medR * 0.9
                        fill: Color.BLACK
                        x: -medR * 0.9 / 2
                        y: -medR * 0.9 / 2
                    }

                    action: function() {
                        mediaPlayer.stop();
                    }
                }
                AudioButton {
                    radius: r
                    darkColor: darkColor
                    medColor: medColor
                    lightColor: lightColor
                    //x: x + w / 2 + bigR * 2 - 3
                    x: stopButton.x + stopButton.boundsInLocal.width
                    y: buttonY
                    icon: Group {
                        content: [
                            Polygon {
                                fill: Color.BLACK
                                points: [
                                    0,
                                    -arrowLength / 2,
                                    arrowLength, 0,
                                    0,
                                    arrowLength / 2,
                                ]
                            }
                            Polygon {
                                fill: Color.BLACK
                                points: [
                                    -arrowLength, -arrowLength / 2,
                                    0, 0,
                                    -arrowLength, arrowLength / 2,
                                ]
                            }
                        ]
                    }

                    action: function() {
                        playNextTrack()
                    }
                }
                autoPlayButton = ImageButton {
                    imageUrl: "AutoPlayIcon.png"
                    w: 30
                    y: 2
                    x: w - 44
                    enabled: true
                    action: function() {
                        autoPlay = if (autoPlay) {
                            autoPlayButton.imageUrl = "AutoPlayIcon.png";
                            false
                        }
                        else {
                            autoPlayButton.imageUrl = "AutoPlayIconDown.png";
                            true
                        }

                    }
                }

                MediaView {
                    mediaPlayer: mediaPlayer
                }

            ]
            
        }
    }

    function getProgress(dur1:Duration, dur2:Duration):Number {
        var t1 = dur1.toSeconds();
        var t2 = dur2.toSeconds();
        if (t1 <= 0 or t2 <= 0) {
            return 0;
        }
        var p = t1 / t2;
        if (p > 1) {
            p = 1
        }
        p
    }


    function convertTime(dur:Duration):String {
        var min =
        dur.toMinutes() as Integer;
        if (min < 0)
        min = 0;
        "{min}:{numberFormat.format(dur.toSeconds() mod 60 as Integer)}"
    }


    function setTrackUrl(url:String) {
        if (url == null ) {
            return;
        }

        //curTrackUrl = url;

        mediaPlayer.media = Media {
            source: url
            onError: function (e: MediaError) {
                println ("Audio Player setTrackUrl error: {e}");
            }

        }
    }


    public function setArtist(artist:Artist):Void {
        this.artist = artist;
        status = "Loading Tracks for {artist.name}";
        artist.loadAudio(applyArtist);

    }

    public function reset() {
        //println ("Audioplayer stopping");
        mediaPlayer.stop();
        artistName = null;
        this.artist = null;
        status = null;
        nowPlaying = null;
        delete audioTracks;
        currentTrack = -1;

        dismiss();
    }


    var applyArtist = function(a:Artist):Void {
        //println ("applyArtist: {a}");
        if (artist == null or not a.equals(artist)) { // check to see if this artist is from an old request
            return;
        }

        artistName = artist.name;

        for (curAudio in artist.audio) {
            insert curAudio into audioTracks;
        }

        explorer.audioInitialized(sizeof audioTracks > 0);
        if (sizeof audioTracks == 0) {
            nowPlaying = null;
            return;
        }

        currentTrack = 0;

        playCurrentTrack();
    }

    function playNextTrack() {
        currentTrack++;
        if (currentTrack >= sizeof audioTracks) {
            currentTrack = sizeof audioTracks - 1;
        }

        playCurrentTrack();
    }

    function playPreviousTrack() {
        currentTrack--;
        if (currentTrack < 0) {
            currentTrack = 0;
        }

        playCurrentTrack();
    }


    function playCurrentTrack() {
        if (sizeof audioTracks == 0) {
            return;
        }

        mediaPlayer.stop();

        var audio = audioTracks[currentTrack];
        //setStatus ("Playing Track {currentTrack + 1} of {sizeof audioTracks}");
        nowPlaying = audio.getTitle();

        if (autoPlay) {
            play();
        }
    }

    function updatePlayPause() {
        if (mediaPlayer.status == MediaPlayer.PLAYING) {
            mediaPlayer.pause();
        }
        else {
            play();
        }
    }


    function updatePlayPauseIcon(mpStatus:Integer):Node {
        if (mpStatus == MediaPlayer.PLAYING) {
            pauseIcon;
        }
        else {
            playIcon;
        }

    }


    function play() {
        if (currentAudio != audioTracks[currentTrack]) {
            currentAudio = audioTracks[currentTrack];
            setTrackUrl(currentAudio.getUrl());
        }
        
        mediaPlayer.play();
    }

    function stop() {
        mediaPlayer.stop();
        playPauseButton.icon = pauseIcon;

    }


    function getMediaPlayerStatus(num:Integer):String {
        var mpStatus = if (num == MediaPlayer.BUFFERING) {
            "Buffering"
        } else if (num == MediaPlayer.PAUSED){
            "Paused"
        } else if (num == MediaPlayer.PLAYING) {
            "Playing"
        } else if (num == MediaPlayer.STALLED) {
            "Stalled"
        }
        else {
            "{num}";
        }

        mpStatus;
    }


    function setStatus(message:String) {
        status = message;
        //println("AudioPlayer status: {status}");
       
    }

    public function updateBounds() {
        translateX = explorer.centerX - boundsInLocal.width / 2 + 2;
        translateY = explorer.centerY + explorer.currentNode.defaultHeight / 2;
    }


    public function intro() {
        //dismissTransition.stop();
        //opacity = 1;
        updateBounds();
        introTransition.playFromStart();
    }

    function dismiss() {
        if (opacity == 0) {
            return;
        }
        introTransition.stop();
        opacity = 0;
        //dismissTransition.playFromStart();
    }

    public function hasAudio():Boolean {
        sizeof audioTracks > 0
    }



}

