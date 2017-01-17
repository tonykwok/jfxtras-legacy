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


import com.citytechinc.ria.mefxmobile.model.LastFmImageRequest;

import javafx.scene.image.Image;

/**
 * @author sanderson
 */

// define these at the script level so there's just one copy for all Artists.
var loadingImage = Image {
    url: "{__DIR__}IconsPhoneLoading1.jpg"
    smooth: true
};

var noImage = Image {
    url: "{__DIR__}IconsPhoneNoImage1.jpg"
    smooth: true
}

public class Artist {

    var image = loadingImage;
    var imageWidth = 0;

    public-init var name: String;
    public-init var id: String;

    public var hotness: Number = 0 on replace {hotnessLoaded = hotness > 0};
    public-read var familiarity: Number;

    var audioLoaded = false;
    var galleryLoaded = false;
    var hotnessLoaded = false;
    var familiarityLoaded = false;
    var loadedImage = false;

    public function loadProfileImage(f:function(:Image)) {
        f(image);
        if (loadedImage) {
            return;
        }
        loadedImage = true;
        
        LastFmImageRequest {
            artist: this
            done: function(imageUrl:String) {
                //println("Loading image from {imageUrl}");
                image = if (imageUrl != null and not imageUrl.endsWith("gif")) {
                    Image {
                        //backgroundLoading: true
                        //placeholder: loadingImage
                        url: imageUrl
                    }
                    
                }
                else {
                    noImage
                }
                f(image);
            }
        }.start();

    }

    public function loadFamiliarity(f:function():Void) {
        if (familiarityLoaded) {
            f();
            return;
        }
        familiarityLoaded = true;

        EchoNestFamiliarityRequest {
            artist:this
            onDone: function(fam:Number) { familiarity = fam; f();}
        }.start();

    }

    public function loadHotness(f:function():Void) {
        if (hotnessLoaded) {
            f();
            return;
        }
        hotnessLoaded = true;

        EchoNestHotnessRequest {
            artist:this
            onDone: function(hot:Number) { hotness = hot; f();}
        }.start();

    }

    override public function equals(other) {
        if (other == null or not (other instanceof Artist)) {
            return false
        }

        var otherArtist = other as Artist;

        this.id.equals(otherArtist.id)
    }


    override public function toString():String {
       name
    }

}
