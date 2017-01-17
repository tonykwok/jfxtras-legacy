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

package com.citytechinc.ria.mefxmobile.model;

import com.citytechinc.ria.mefxmobile.util.KeyHelper;

import javafx.io.http.HttpRequest;

import javafx.data.pull.Event;
import javafx.data.pull.PullParser;
import java.io.InputStream;

import javafx.io.http.URLConverter;

/**
 * @author sanderson
 */

public class LastFmImageRequest {

    def API_KEY = KeyHelper.getAPIKey("lastfm");
    def BASE_URL = "http://ws.audioscrobbler.com/2.0/";

    public-init var artist:Artist;
    public-init var done:function(:String):Void;
    
    var request:HttpRequest;
    var converter = URLConverter {};

    var currentWidth:Number = 0;
    var shouldReadName = false;
    var imageUrl:String;

    postinit {
        var encodedName = converter.encodeString(artist.name);
        var location = "{BASE_URL}?method=artist.getimages&limit=10&artist={encodedName}&api_key={API_KEY}";
        //println ("LastFmImageRequest location: {location}");
        request = HttpRequest {
            location: location
            onException: function(ex: java.lang.Exception) {
                println("LastFmImageRequest exception: {ex.getClass()} {ex.getMessage()}");
            }
            onDone: function() {done(imageUrl)}
            onInput: readResponse
        }

    }

    public function start() {
        request.start();
    }

    function readResponse(in:InputStream) {
        try {
            PullParser {
                input: in
                documentType: PullParser.XML
                onEvent: function (e:Event) {
                    //println("LastFmImageRequest event:{e.typeName} Name:{e.qname.name}, text:{e.text} attrs:{e.getAttributeNames()} e:{e}");
                    if (e.type == PullParser.START_ELEMENT and e.qname.name.equals("size")) {
                        var width:Number = java.lang.Integer.parseInt(e.getAttributeValue("width"));
                        var height:Number = java.lang.Integer.parseInt(e.getAttributeValue("height"));
                        var aspectPercentage = java.lang.Math.abs(1 - width / height);
                        if (e.getAttributeValue("name").equals("original") and width > currentWidth and width <= 500) {

                            currentWidth = width;
                            shouldReadName = true;
                        }

                    }

                    if (shouldReadName and e.type == PullParser.TEXT) {
                        imageUrl = e.text;
                        shouldReadName = false;
                    }
                }

            }.parse();
        }
        finally {
            in.close();
        }

    }

}
