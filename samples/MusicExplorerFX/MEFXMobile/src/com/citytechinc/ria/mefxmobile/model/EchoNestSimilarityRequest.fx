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

import javafx.io.http.URLConverter;

/**
 * @author sanderson
 */

public class EchoNestSimilarityRequest extends EchoNestRequest {

    public-init var similarArtist:Artist;
    public-init var onDone:function(Artist[]):Void;

    var artists:Artist[];

    var curId:String;
    var curName:String;
    var encoder = URLConverter {};

    init {
        command = "get_similar";
        param = "id";
        value = encoder.encodeString(similarArtist.id);
    }

    override package function done():Void {
        onDone(artists);
    }

    override package function onEvent(name:String, text:String):Void {
        if (name.equals("id")) {
            curId = text;
        }
        else if (name.equals("name")) {
            curName = text;
        }
        if (curId != null and curName != null) {
            createArtist();
        }

    }

    function createArtist() {
        var artist = Artist {
            id: curId
            name: curName
        };
        insert artist into artists;

        curId = null;
        curName = null;
    }


}
