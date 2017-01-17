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
 
package com.citytechinc.ria.musicexplorerfx.model;

import com.citytechinc.ria.musicexplorerfx.InfoItem;
import com.citytechinc.ria.musicexplorerfx.model.Artist;
import com.citytechinc.ria.musicexplorerfx.model.EchoNestManager;
import com.citytechinc.ria.musicexplorerfx.model.LastfmManager;
import com.citytechinc.ria.musicexplorerfx.model.Link;
import com.citytechinc.ria.musicexplorerfx.util.JFXTask;
import com.echonest.api.v3.artist.*;
import com.sun.labs.aura.music.web.flickr.FlickrManager;
import java.awt.image.BufferedImage;
import java.net.URL;
import javax.swing.ImageIcon;
import java.util.List;

/**
 * @author sanderson
 */

public class Artist {

    public var imageUrl: String;
    public var name: String;
    public var id: String;
    public var audio: Audio[];
    public var reviews: Review[];
    public var news: News[];
    public var videos: Video[];
    public var blogs: Blog[];
    public var imageUrls: String[];
    public var links:Link[];

    public var hotness: Number;
    public var familiarity: Number;

    public var echoNestManager: EchoNestManager;

    public var iterationNumber: Integer;
    public var searchId: Integer;

    public-read var image: BufferedImage;

    var scaledWidth:Number = 260;

    var audioLoaded = false;
    var reviewsLoaded = false;
    var newsLoaded = false;
    var videoLoaded = false;
    var blogsLoaded = false;
    var galleryLoaded = false;
    var linksLoaded = false;
    var hotnessLoaded = false;

    public function loadArtistData(lastfm:LastfmManager, f:function():Void) {
        //println ("Arist {this} loadArtistData");
        JFXTask {
            inBackground: function() {
                loadLastfmImage(lastfm);

                //var startTime = java.lang.System.currentTimeMillis();
                //echoNestManager.loadFamiliarityAndHotness(this);
                //println ("fam time for {name} {java.lang.System.currentTimeMillis() - startTime}");

                return null;
            }

            onDone: function(result) {
                f();
            }
        }
    }

    public function loadFamiliarityAndHotness(f:function():Void) {
        if (hotnessLoaded) {
            f();
            return;
        }

        JFXTask {
            inBackground: function() {
                echoNestManager.loadFamiliarityAndHotness(this);
                return null;
            }

            onDone: function(result) {
                hotnessLoaded = true;
                f();
            }
        }
    }


    public function loadReviews(f:function(artist:Artist):Void):Void {
        if (reviewsLoaded) {
            f(this);
            return;
        }

        reviewsLoaded = true;
        JFXTask {
            inBackground: function():List {
                return echoNestManager.loadReviews(this);
            }

            onDone: function(result) {
                for (r in (result as List)) {
                    insert r as Review into reviews;
                }

                //reviews = result as Review[];
                //println ("Artist {this} found {sizeof reviews} reviews");
                f(this);
            }

        }
    }

    public function loadNews(f:function(artist:Artist):Void):Void {
        if (newsLoaded) {
            f(this);
            return;
        }

        newsLoaded = true;
        JFXTask {
            inBackground: function():List {
                return echoNestManager.loadNews(this);
            }

            onDone: function(result) {
                for (n in (result as List)) {
                    insert n as News into news
                }

                //news = result as News[];
                //println ("Artist {this} found {sizeof news} news");
                f(this);
            }

        }
    }

    public function loadLinks(f:function(artist:Artist):Void):Void {
        if (linksLoaded) {
            f(this);
            return;
        }

        linksLoaded = true;
        JFXTask {
            inBackground: function():List {
                return echoNestManager.loadLinks(this);
            }

            onDone: function(result) {
                for (link in (result as List)) {
                    insert link as Link into links;
                }

                //links = result as Link[];
                //println ("{this} found {sizeof links} links");
                f(this);
            }

        }
    }

    public function loadVideo(f:function(artist:Artist):Void):Void {
        if (videoLoaded) {
            f(this);
            return;
        }

        videoLoaded = true;
        JFXTask {
            inBackground: function():List {
                return echoNestManager.loadVideo(this);
            }

            onDone: function(result) {
                for (v in (result as List)) {
                    insert v as Video into videos;
                }

                //println ("Artist {this} found {sizeof videos} videos");
                f(this);
            }

        }
    }

    public function loadBlogs(f:function(artist:Artist):Void):Void {
        if (blogsLoaded) {
            f(this);
            return;
        }

        blogsLoaded = true;
        JFXTask {
            inBackground: function():List {
                return echoNestManager.loadBlogs(this);
            }

            onDone: function(result) {
                for (b in (result as List)) {
                    insert b as Blog into blogs;
                }

                //blogs = result as Blog[];
                //println ("Artist {this} found {sizeof blogs} blogs");
                f(this);
            }

        }

    }


    public function loadAudio(f:function(a:Artist)) {
        if (audioLoaded) {
            f(this);
            return;
        }

        audioLoaded = true;

        JFXTask {
            inBackground: function() {
                echoNestManager.loadAudio(this);
                return null;
            }

            onDone: function(result) {
                f(this);
            }

        }
    }


    function loadArtistImages(flickr:FlickrManager) {
        var img = flickr.getImage(name);

        if (img != null) {
            image = new BufferedImage
                (img.getWidth(null),
                img.getHeight(null), BufferedImage.TYPE_INT_ARGB);
            image.getGraphics().drawImage(img, 0, 0, null);

        }

    }

    function loadLastfmImage(lastfm:LastfmManager) {
        lastfm.loadArtistImage(this);
        if (imageUrl != null) {
            //println ("Artist loadLastfmImage {name}: {imageUrl}");
            var icon:ImageIcon = new ImageIcon(new URL(imageUrl));
            var img = icon.getImage();
            //println ("Artist img: {name} w:{img.getWidth(null)} h:{img.getHeight(null)}");
            var imgWidth:Number = img.getWidth(null);
            var imgHeight:Number = img.getHeight(null);
            if (imgWidth > 0 and imgHeight > 0) {
                if (imgWidth > scaledWidth) {
                    var w:Number = scaledWidth;
                    var h:Number = imgHeight / imgWidth * w;
                    //println ("Artist scaled img: w {w} h {h}");
                    image = new BufferedImage(w, h, BufferedImage.TYPE_INT_ARGB);
                    image.getGraphics().drawImage(img, 0, 0, w, h, 0, 0, imgWidth, imgHeight, null);
                }
                else {
                    image = new BufferedImage(imgWidth, imgHeight, BufferedImage.TYPE_INT_ARGB);
                    image.getGraphics().drawImage(img, 0, 0, null);
                }

            }

        }

    }


    public function loadImageGallery(flickr:FlickrManager, f:function(Artist):Void) {
        if (galleryLoaded) {
            f(this);
            return;
        }
        galleryLoaded = true;

        JFXTask {
            inBackground: function():List {
                return flickr.getImageUrls(name);
            }

            onDone: function(result) {
                var urls:List = result as List;
                imageUrls = for (url in urls) {
                    url as String
                }
                f(this);
            }

        }

    }


    public function getReviews():InfoItem[] {
        for (r in reviews) {
            InfoItem {
                title: if (r.getName() == null) "Untitled Review"  else r.getName()
                summary: r.getSummary()
                url: r.getURL()
            }
        }

    }

    public function getLinks():InfoItem[] {
        for (l in links){
            InfoItem {
                title: l.title
                url: l.url
            }

        }

        /*
         [
         InfoItem {
         title: "Fake Links"
         summary: "Amid the bleak backdrop of imminent economic collapse, worried observers got some good news last October when executives from the nation's top 10 failing companies celebrated the historic $700 billion government bailout with an ultra- extravagant $800 billion party aimed at restoring confidence and bolstering their resolve."
         url: "http://blogs.citytechinc.com/sanderson/"
         },
         InfoItem {
         title: "Fake Links"
         summary: "Three thousand guests were reportedly flown on 750 separate private jets to the Caribbean, where they commemorated the last-minute financial aid package—which saved their companies from the subprime mortgage crisis that has left thousands of Americans without homes—with 4-tons of Beluga caviar, $250,000 bottles of vintage Dom Pérignon served over precious gems, a 36-hour fireworks display, an additional loan of $200 billion to cover the costs of the gala, and a private concert for each attendee with rock legend Rod Stewart."
         url: "http://blogs.citytechinc.com/sanderson/"
         }

         ]
*/
         }


         public function getNews():InfoItem[] {
         /*
         [
         InfoItem {
         title: "Fake News"
         summary: "Amid the bleak backdrop of imminent economic collapse, worried observers got some good news last October when executives from the nation's top 10 failing companies celebrated the historic $700 billion government bailout with an ultra- extravagant $800 billion party aimed at restoring confidence and bolstering their resolve."
         url: "http://blogs.citytechinc.com/sanderson/"
         },
         InfoItem {
         title: "Fake News II"
         summary: "Three thousand guests were reportedly flown on 750 separate private jets to the Caribbean, where they commemorated the last-minute financial aid package—which saved their companies from the subprime mortgage crisis that has left thousands of Americans without homes—with 4-tons of Beluga caviar, $250,000 bottles of vintage Dom Pérignon served over precious gems, a 36-hour fireworks display, an additional loan of $200 billion to cover the costs of the gala, and a private concert for each attendee with rock legend Rod Stewart."
         url: "http://blogs.citytechinc.com/sanderson/"
         }

         ]
         */
        for (n in news) {
            InfoItem {
                title: n.getName()//"{n.getName()} - {n.getDateFound()}"
                summary: n.getSummary()
                url: n.getURL()
            }

        }

    }

    public function getVideos():InfoItem[] {
        for (v in videos) {
            InfoItem {
                title: if (v.getTitle() != null) "{v.getTitle()} ({v.getSite()})" else "Untitled Video"
                url: v.getURL()
            }
        }
    }

    public function getBlogs():InfoItem[] {
/*
        [
            InfoItem {
                title: "Fake Blog"
                summary: "Amid the bleak backdrop of imminent $700 billion government bailout with an ultra- extravagant $800 billion party aimed at restoring confidence and bolstering their resolve."
                url: "http://blogs.citytechinc.com/sanderson/"
            },
            InfoItem {
                title: "Fake Blog"
                summary: "Three thousand guests were reportedly financial aid package—which saved their companies from the subprime mortgage crisis that has left thousands of Americans without homes—with 4-tons of Beluga caviar, $250,000 bottles of vintage Dom Pérignon served over precious gems, a 36-hour fireworks display, an additional loan of $200 billion to cover the costs of the gala, and a private concert for each attendee with rock legend Rod Stewart."
                url: "http://blogs.citytechinc.com/sanderson/"
            }

        ]
*/
        for (b in blogs) {
            InfoItem {
                title: b.getName()
                summary: b.getSummary()
                url: b.getURL()
            }

        }

    }


    override public function toString():String {
        "Artist: {name}";
    }

}
