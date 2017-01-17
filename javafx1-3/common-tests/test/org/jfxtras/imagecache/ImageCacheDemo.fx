/*
 * Copyright (c) 2008-2010, JFXtras Group
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 * 1. Redistributions of source code must retain the above copyright notice,
 *    this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 * 3. Neither the name of JFXtras nor the names of its contributors may be used
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
package org.jfxtras.imagecache;

// standard javafx imports
import javafx.stage.Stage;
import javafx.scene.*;
import javafx.scene.shape.*;
import javafx.scene.paint.*;

// caching library

// flickr stuff
/**
 * This is a test app which lets you quickly scroll through 100 photos.
 * it only shows enough photos to fill the screen. When you scroll it
 * will delete the photos that are now off the screen and add new photos
 * at the other end.
 *
 * This app also demonstrates how to query flickr for photos and get the URLs
 *
 * @author joshua@marinacci.org
 */

var len = 6;
var photos:Photo[];
var cache = ImageCache { deleteOnStart: false threadCount: 10 cacheName: "FlickrTest" };
var count = 0;
var visibleNodes:Node[];
var prevStart = -1;

var feedurl = "http://api.flickr.com/services/feeds/photos_public.gne?tags=cat&lang=en-us&format=rss_200_enc";
var req:PhotoRequest = PhotoRequest {
    url: feedurl
    onDone: function() {
        // only use the first five photos. change to use all if you want
        photos = req.photos;
        visibleNodes = for(photo in photos[0..len]) {
            Group {
                translateX: indexof photo * 150
                content: [
                    Rectangle { width: 150 height: 150 fill: Color.GRAY stroke: Color.DARKGRAY },
                    CachedImageView {
                        url: photo.url
                        thumbnailURL: photo.thumbUrl
                        width: 150
                        height: 150
                        imageCache: cache
                        sizingMethod: SizingMethod.Crop
                    }
                ]
            }
        }
    }
};
req.request.start();


var scrollOffset = 0.0 on replace {
    //println("offset = {scrollOffset}");
    var start:Integer = scrollOffset/150 as Integer;
    if(start != prevStart) {
        //println("start = {start}");
        // if at the start, don't go further
        if(start <=0) {
            start = 0;
            scrollOffset = 0;
        } else {
            // calc start & end and do the remove/add
            var end = start+len;
            removeAndAddPhoto(start,end);
            prevStart = start;
        }
    }
}

function removeAndAddPhoto(start:Integer, end:Integer):Void {
    //println("end = {end}");

    // if we scrolled right, delete the first node and add a the end
    if(prevStart < start) {
        delete visibleNodes[0] from visibleNodes;
        //println("removing {0},{start}");
        var photo = photos[end];
        insert Group {
            translateX: end * 150
            content: [
                Rectangle { width: 150 height: 150 fill: Color.GRAY stroke: Color.DARKGRAY },
                CachedImageView {
                    url: photo.url
                    thumbnailURL: photo.thumbUrl
                    width: 150
                    height: 150
                    imageCache: cache
                    sizingMethod: SizingMethod.Crop
                }
            ]
        } into visibleNodes;
    } else {
        // scrolled left, delete last node, add at start
        var lst = visibleNodes.size()-1;
        //println("removing = {lst},{end}");
        delete visibleNodes[lst] from visibleNodes;
        var photo = photos[start];
        insert Group {
            translateX: start * 150
            content: [
                Rectangle { width: 150 height: 150 fill: Color.GRAY stroke: Color.DARKGRAY },
                CachedImageView {
                    url: photo.url
                    thumbnailURL: photo.thumbUrl
                    width: 150
                    height: 150
                    imageCache: cache
                    sizingMethod: SizingMethod.Crop
                }
            ]
        } before visibleNodes[0];
    }


}


var view = Group {
    translateX: bind -scrollOffset
    content: bind visibleNodes
};


// show the photos on screen
var scene:Scene = Scene {
    width: 150*len
    height: 150
    content: [
        Rectangle { width: 150*len height: 150 fill: Color.RED },
        view,
        Rectangle {
            width: bind scene.width height: 150 fill: Color.TRANSPARENT
            var sx = 0.0;
            onMousePressed : function(e) {
                sx = scrollOffset;
            }
            onMouseDragged: function(e) {
                scrollOffset = sx-e.dragX;
            }

        }
    ]
};

Stage {
    title: "Scrolling Flickr Test"
    scene: scene
}