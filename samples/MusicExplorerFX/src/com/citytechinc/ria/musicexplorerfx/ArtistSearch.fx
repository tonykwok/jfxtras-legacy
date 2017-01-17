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

import com.citytechinc.ria.musicexplorerfx.ImageButton;
import com.citytechinc.ria.musicexplorerfx.model.Artist;
import com.citytechinc.ria.musicexplorerfx.model.EchoNestManager;
import com.citytechinc.ria.musicexplorerfx.model.LastfmManager;
import com.citytechinc.ria.musicexplorerfx.ProgressBar;
import com.citytechinc.ria.musicexplorerfx.util.JFXTask;
import com.sun.labs.aura.music.web.flickr.FlickrManager;
import javafx.animation.transition.FadeTransition;
import javafx.animation.transition.ParallelTransition;
import javafx.animation.transition.ScaleTransition;
import javafx.animation.transition.SequentialTransition;
import javafx.animation.transition.TranslateTransition;
import javafx.scene.control.TextBox;
import javafx.scene.CustomNode;
import javafx.scene.Group;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;
import javafx.scene.input.MouseEvent;
import javafx.scene.layout.HBox;
import javafx.scene.layout.VBox;
import javafx.scene.Node;
import javafx.scene.paint.Color;
import javafx.scene.text.Font;
import javafx.scene.text.Text;
import com.citytechinc.ria.musicexplorerfx.util.BareBonesBrowserLauncher;

import java.util.List;

/**
 * This is the initial search screen. From here, control is typically transfered
 * to the ArtistExplorer.
 *
 * @author sanderson
 */

public class ArtistSearch extends CustomNode {

    public var width: Number;
    public var height: Number;
    public var action: function(artist:Artist):Void;

    public var echoNestManager: EchoNestManager;
    public var flickrManager: FlickrManager;
    public var lastfmManager: LastfmManager;
    public var explorer: ArtistExplorer;

    var searchStr = "Enter an Artist Name to Begin";
    var pickStr = "Click on an Artist to Explore";

    //var results: SearchResultNode[];
    var results: ArtistNode[];
    var resultsGroup:Group;
    var showNoResults = false;
    var searchText = searchStr;
    var progress:ProgressBar;

    var searchTextNode: Text;
    var statusNode: Text;
    var statusStr: String;

    var totalResults: Integer;
    var curResult: Integer;

    var textbox: TextBox;
    var searchButton: ImageButton;

    var searchId = 0;
    var logo: ImageView;
    var searchGroup: Group;
    var travelled = false;

    var ctLogo:Node;
    var enLogo:Node;
    var lastfmLogo:Node;
    var webSite:Node;
    var originalWidth:Number;
    var originalHeight:Number;
    var g:Group;

    var centerX:Number;
    var centerY:Number;


    override public function create():Node {
        originalWidth = width;
        originalHeight = height;
        textbox = TextBox {
            columns: 30
            selectOnFocus: true
            action: function() {
                doSearch()
            }
        };
        searchButton = ImageButton {
            imageUrl: "SearchButtonRound.png"
            w: 45
            translateY: -4 // compensate for the layout manager's odd placement
            action: function() {
                doSearch()
            }
        }
        logo = ImageView {
            image: Image {
                url: "{__DIR__}images/MusicExplorerFX3.png"
                preserveRatio: true
                smooth: true
                width: 900
            }
            onMouseClicked: function (e:MouseEvent) {
                BareBonesBrowserLauncher.openURL("http://www.musicexplorerfx.com");
            }
            //translateY: 150
        }

        enLogo = ImageView {
            image: Image {
                url: "{__DIR__}images/ENLogo.png"
                preserveRatio: true
                width: 170
            }
            onMouseClicked: function (e:MouseEvent) {
                BareBonesBrowserLauncher.openURL("http://the.echonest.com/");
            }
        }

        lastfmLogo = Text {
            fill: Color.WHITESMOKE
            content: "Images provided by the Last.fm and Flickr APIs"
            font: Font {
                size: 12
            }

        }

        webSite = Text {
            fill: Color.WHITESMOKE
            content: "www.musicexplorerfx.com"
            font: Font {
                size: 16
            }
            onMouseClicked: function (e:MouseEvent) {
                BareBonesBrowserLauncher.openURL("http://www.musicexplorerfx.com");
            }

        }


        ctLogo = ImageView {
            image: Image {
                url: "{__DIR__}images/ct-logo.gif"
                preserveRatio: true
                width: 110
            }
            onMouseClicked: function (e:MouseEvent) {
                BareBonesBrowserLauncher.openURL("http://www.citytechinc.com");
            }

        }

        searchGroup = Group {
            content: bind [
                VBox {
                    spacing: 5
                    content: [
                        searchTextNode = Text {
                            fill: Color.WHITE
                            content: bind searchText
                            font: Font {
                                size: 24
                                autoKern: true

                            }

                        },
                        HBox {
                            spacing: 2
                            content: [
                                textbox,
                                searchButton,
                            ]
                        },
                        progress = ProgressBar {
                            w: 300
                        }
                        Text {
                            visible: bind showNoResults
                            content: "No Results Found. Try a Different Search."
                            fill: Color.RED
                            translateY: 80
                            font: Font {
                                size: 18
                            }

                        }

                    ]
                },

            ]
        }

        resultsGroup = Group {
            content: bind [ results ]
        }
        g = Group {
            content: [
                logo,
                ctLogo,
                webSite,
                lastfmLogo,
                enLogo,
                searchGroup,
                resultsGroup
            ]
        }

        updateBounds();

        searchButton.intro();

        g

    }

    function getScaledWidth() {
        width
    }

    function getScaledHeight() {
        height
    }

    public function updateBounds() {

        searchGroup.translateX = getScaledWidth() / 2 - searchGroup.boundsInLocal.width * g.scaleX / 2;

        if (not travelled) {
            searchGroup.translateY = getScaledHeight() / 2 - searchGroup.boundsInLocal.height / 2;
            logo.translateX = getScaledWidth() / 2 - logo.boundsInLocal.width / 2;
            logo.translateY = getScaledHeight() * 0.2;
        }
        
        //enLogo.translateX = width - enLogo.boundsInLocal.width * scaleX * 1.5;
        enLogo.translateX = getScaledWidth() - enLogo.boundsInLocal.width  * 1.5;
        enLogo.translateY = getScaledHeight() - enLogo.boundsInLocal.height * 1.65;

        lastfmLogo.translateX = getScaledWidth() / 2 - lastfmLogo.boundsInLocal.width / 2;
        lastfmLogo.translateY = getScaledHeight() - lastfmLogo.boundsInLocal.height * 2.5;

        webSite.translateX = getScaledWidth() / 2 - webSite.boundsInLocal.width / 2;
        webSite.translateY = getScaledHeight() - webSite.boundsInLocal.height * 2.5 - 30;

        ctLogo.translateY = getScaledHeight() - ctLogo.boundsInLocal.height * 1.15;
        ctLogo.translateX = 10;

        centerX = width / 2;
        centerY = height / 2;

        updateSearchResultsBounds();

    }


    function updateSearchResultsBounds() {
        var scale = 1.0;

        var effectiveWidth = width - 20;
        if (resultsGroup.boundsInLocal.width > effectiveWidth) {
            scale = effectiveWidth / resultsGroup.boundsInLocal.width;

        }
        if (sizeof results > 5) {
            scale -= 0.2;
            resultsGroup.translateY = -250
        }
        else {
            resultsGroup.translateY = 0
        }

        
        resultsGroup.scaleX = scale;
        resultsGroup.scaleY = scale;
        resultsGroup.translateX = getScaledWidth() / 2 - resultsGroup.boundsInLocal.width / 2 + explorer.nodeWidth / 2;
        //resultsGroup.translateY = height / 2 - resultsGroup.boundsInLocal.height / 2;
        //resultsGroup.translateY = - resultsGroup.boundsInLocal.height / 3;
    }

    function doSearch() {
        if (textbox.text.equals("")) {
            return;
        }

        searchButton.enabled = false;
        textbox.disable = true;
        progress.setIndeterminate();
        delete results;
        showNoResults = false;
        JFXTask {
            inBackground: function():List {
                return echoNestManager.searchArtist(textbox.text);
            }

            onDone: function(result) {
                var seq:Artist[];
                for (a in result as List) {
                    insert a as Artist into seq;
                }

                travel (seq);
            }

        }
        
    }

    public function dismiss(artist:Artist):Void {
        FadeTransition {
            action: function() {action(artist)}
            node: this
            duration: 1s
            fromValue: 1
            toValue: 0
        }.play();
    }

    public function intro() {
        FadeTransition {
            node: this
            duration: 1s
            fromValue: 0
            toValue: 1
        }.play();
    }


    function displayResults(artists:Artist[]) {
        searchId++;
        totalResults = sizeof artists;
        curResult = 0;
        if (sizeof artists == 0) {
            showNoResults = true;
            progress.dismiss();
            searchButton.enabled = true;
            textbox.disable = false;
            return;
        }
        progress.stop();
        progress.setProgress(curResult, totalResults);
        for (a in artists) {
            a.searchId = searchId;
            a.loadArtistData(lastfmManager, function() {
                addSearchResult(a);
            });
        }
        searchButton.enabled = true;
        textbox.disable = false;
    }

    function travel(result:Artist[]):Void {
        if (travelled) {
            displayResults(result);
            return;
        }
        travelled = true;

        var dur = 0.8s;
        ParallelTransition {
            action: function() {displayResults(result)}
            content: [
                TranslateTransition {
                    node: searchGroup
                    fromY: searchGroup.translateY
                    toY: 100
                    duration: dur
                },
                TranslateTransition {
                    node: logo
                    fromX: logo.translateX
                    fromY: logo.translateY
                    toX: -210
                    toY: 0
                    duration: dur
                },
                ScaleTransition {
                    node: logo
                    fromX: 1.0
                    fromY: 1.0
                    toX: 0.5
                    toY: 0.5
                    duration: dur
                }

                SequentialTransition {
                    content: [
                        FadeTransition {
                            node: searchTextNode
                            fromValue: 1.0
                            toValue: 0
                            duration: dur * 0.75
                            action: function() {
                                searchText = pickStr
                            }
                        },
                        FadeTransition {
                            node: searchTextNode
                            fromValue: 0
                            toValue: 1
                            duration: dur
                        }

                    ]
                }

            ]
        }.play();

    }

    function addSearchResult(artist:Artist) {
        if (artist.searchId != searchId) {
            println ("ArtistSearch skipping {artist} from old search");
            return;
        }

        curResult++;
        progress.setProgress(curResult, totalResults);
        if (curResult == totalResults) {
            progress.dismiss();
        }

        var artistY = if (sizeof results < 5) centerY else centerY + 500;

        var offsetX = explorer.nodeWidth / 6;

        var result = ArtistNode {
            scaleExempt: true
            x: (explorer.nodeWidth + offsetX) * (sizeof results mod 5)
            y: artistY
            artist: artist
            explorer: explorer
            action: function(a:ArtistNode):Void { dismiss(artist) }
        }
        insert result into results;
        result.intro();

        updateSearchResultsBounds();

    }

}