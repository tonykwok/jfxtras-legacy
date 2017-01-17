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

import javafx.scene.Group;
import javafx.scene.Node;
import javafx.scene.control.TextBox;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;
import javafx.scene.layout.VBox;
import javafx.scene.paint.Color;
import javafx.scene.text.Font;
import javafx.scene.text.Text;

import javafx.geometry.HPos;
import javafx.scene.layout.HBox;


import com.citytechinc.ria.mefxmobile.model.EchoNestSearchRequest;
import com.citytechinc.ria.mefxmobile.model.EchoNestTopRequest;

import com.citytechinc.ria.mefxmobile.model.Artist;
import com.citytechinc.ria.mefxmobile.ui.widget.ImageButton;
import com.citytechinc.ria.mefxmobile.ui.widget.ArtistList;

import javafx.scene.control.ProgressIndicator;

import javafx.util.Math;


/**
 * @author sanderson
 */

public class ArtistSearch extends Display {
        
    var textbox: TextBox;

    var showProgress = false;
    var beforeSearch = true;
    var showNotFound = false;
    var searchResults:Artist[];

    override public function create():Node {
        var textSize = width / 25;
        textbox = TextBox {
            columns: 15
            selectOnFocus: true
            action: function() {
                doSearch()
            }
            font: Font {
                size: textSize
            }

        };
        var searchButton = ImageButton {
            imageUrl: "IconsPhoneSearch"
            w: 74
            translateY: -4
            action: function() {
                doSearch()
            }
        }
        var surpriseButton = ImageButton {
            imageUrl: "IconsPhoneSurprise"
            w: 120
            action: function() {
                pickRandomTopArtist();
            }

        }


        var enLogo = ImageView {
            image: Image {
                //url: "{__DIR__}../images/ENLogo.png"
                url: "{__DIR__}ENLogo.png"
                preserveRatio: true
                width: 200
            }
            translateY: height * 0.77
            translateX: width * 0.55
        }

        var lastfmLogo = Text {
            fill: Color.WHITESMOKE
            content: "Images provided by the Last.fm API"
            font: Font {
                size: 12
            }
            translateY: height * 0.95
        }
        lastfmLogo.translateX = width / 2 - lastfmLogo.boundsInLocal.width / 2;

        var ctLogo = ImageView {
            image: Image {
                //url: "{__DIR__}../images/ct-logo.PNG"
                url: "{__DIR__}ct-logo.PNG"
                preserveRatio: true
                width: 130
            }
            translateY: height * 0.4
            translateX: 20
        }

        var logosGroup = Group {
            content: [enLogo, ctLogo, lastfmLogo]
            visible: bind beforeSearch
        }

        Group {
            content: [
                VBox {
                    spacing: 10
                    nodeHPos: HPos.CENTER
                    hpos: HPos.CENTER
                    width: bind width
                    content: [
                        Text {
                            fill: Color.WHITE
                            content: "Enter an Artist Name to Begin"
                            font: Font {
                                size: textSize
                            }

                        },
                        HBox {
                            spacing: 2
                            content: [
                                textbox,
                                searchButton,
                            ]
                        },
                        surpriseButton,
                        ProgressIndicator {
                            progress: -1
                            visible: bind showProgress
                        },
                        Text {
                            content: "No Artists Found. Try a Different Search."
                            visible: bind showNotFound
                            fill: Color.RED
                            translateY: -20
                            font: Font {
                                size: textSize
                            }

                        },

                    ]
                 }
                ArtistList {
                    artists: bind searchResults
                    visible: bind sizeof searchResults > 0
                    w: width
                    h: height * 0.6
                    x: width / 2
                    y: height * 0.3
                    action: function(artist:Artist) {
                        musicExplorer.setCurrentArtist(artist);
                        setCurrentDisplay("explorer");
                    }

                }    
                logosGroup

            ]
        }

    }

    function pickRandomTopArtist() {
        showProgress = true;
        showNotFound = false;
        EchoNestTopRequest {
            onDone: doPickRandomArtist
        }.start();

    }

    function doPickRandomArtist(artists:Artist[]) {
        showProgress = false;
        var index = (Math.random() * sizeof artists) as Integer;
        musicExplorer.setCurrentArtist(artists[index]);
        setCurrentDisplay("explorer");
    }

    function doSearch():Void {
        // seems to be a bug with textbox not always updating its "text" variable.
        if (textbox.rawText.equals("")) {
            return;
        }
        if (showProgress) {
            return;
        }
        showNotFound = false;
        showProgress = true;
        beforeSearch = false;
        delete searchResults;
        EchoNestSearchRequest {
            searchFor: textbox.rawText
            onDone: parseResults
        }.start();

    }

    function parseResults(artists:Artist[]) {
        showProgress = false;

        if (sizeof artists == 1) {
            musicExplorer.setCurrentArtist(artists[0]);
            setCurrentDisplay("explorer");          
        }
        else {
            searchResults = artists;
            showNotFound = sizeof searchResults == 0;
        }

    }

    override public function getName():String {
        "search"
    }


}
