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

import javafx.io.http.HttpRequest;

import com.citytechinc.ria.mefxmobile.util.KeyHelper;

import javafx.data.pull.Event;
import javafx.data.pull.PullParser;
import java.io.InputStream;

/**
 * @author sanderson
 */

package abstract class EchoNestRequest {

    def API_KEY = KeyHelper.getAPIKey("echonest");
    def BASE_URL = "http://developer.echonest.com/api/";

    package var command;
    package var value;
    package var param;
    
    var request:HttpRequest;

    postinit {
        var location = "{BASE_URL}{command}?api_key={API_KEY}&version=3&{param}={value}";
        //println ("EchoNestRequest location: {location}");
        request = HttpRequest {
            location: location
            onException: function(ex: java.lang.Exception) {
                println("EchoNestRequest exception: {ex.getClass()} {ex.getMessage()}");
            }
            onDone: done
            onInput: readResponse
        }

    }

    package abstract function done():Void;

    package abstract function onEvent(name:String, text:String):Void;

    public function start() {
        request.start();
    }

    function readResponse(in:InputStream) {
        try {
            PullParser {
                input: in
                documentType: PullParser.XML
                onEvent: function (e:Event) {
                    if (e.type == PullParser.TEXT) {
                        //println("EchoNestRequest event:{e.typeName} Name:{e.qname.name}, text:{e.text}");
                        onEvent(e.qname.name, e.text);
                    }
                }

            }.parse();
        }
        finally {
            in.close();
        }

    }

}
