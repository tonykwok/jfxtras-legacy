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

import com.citytechinc.ria.musicexplorerfx.model.Artist;
import com.citytechinc.ria.musicexplorerfx.model.AudioHelper;
import com.echonest.api.v3.artist.*;
import java.lang.Exception;
import java.util.List;
import java.util.Map;
import javafx.lang.FX;

import java.util.ArrayList;

import com.citytechinc.ria.musicexplorerfx.util.KeyHelper;

/**
 * @author sanderson
 */

public class EchoNestManager {

    var userHome = FX.getProperty("javafx.user.home");
    var pathSep = FX.getProperty("javafx.file.separator");
    var cachePath = "{userHome}{pathSep}.MusicExplorerFX";
    var cacheFullPath = "{cachePath}{pathSep}cache.dat";
    var echoNest: ArtistAPI = new ArtistAPI(KeyHelper.getAPIKey("echonest"));
    var audioHelper: AudioHelper = new AudioHelper();
    var debug = false;

    postinit {
        //echoNest.setTrace(true);
        loadCache();
        //echoNest.setMaxCacheTime(0);
    }

    //public function findSimilar(artist:Artist, startRow:Integer):Artist[] {
    public function findSimilar(artist:Artist, startRow:Integer):List {
        if (debug) println ("EchoNestManager findSimilar {artist.id} {artist.name}, startRow: {startRow}");
        var similar: Artist[];

        var list: List = echoNest.getSimilarArtists(artist.id, startRow, 15);
        if (debug) println ("Found {list.size()} similar artists");
        var similarList:List = new ArrayList();
        for (a in list) {
            var scored = a as Scored;
            var enArtist =
            scored.getItem() as com.echonest.api.v3.artist.Artist;

            if (debug) println ("Artist {enArtist.getName()} ID: {enArtist.getId()}");
/*
            insert 
            Artist {
                name: enArtist.getName(),
                id: enArtist.getId()
                echoNestManager: this
            } into similar;
        */
            var a2 = Artist {
                name: enArtist.getName(),
                id: enArtist.getId()
                echoNestManager: this
            };
            similarList.add(a2);
        };

        similarList;
        //similar
    }

    public function saveCache() {
        if (debug) println ("EchoNestManager: saving cache to {cacheFullPath}");

        CacheHelper.verifyCacheFile(cachePath, cacheFullPath);

        echoNest.saveCache(cacheFullPath);
    }

    function loadCache() {
        if (debug) println ("EchoNestManager: loading cache from {cacheFullPath}");
        echoNest.loadCache(cacheFullPath);
    }



    public function loadFamiliarityAndHotness(artist:Artist) {
        if (debug) println ("EchoNestManager getFamiliarityAndHotness {artist.id} {artist.name}");

        artist.familiarity = echoNest.getFamiliarity(artist.id);
        
        // BUG this doesn't seem to work at the EN right now
        artist.hotness = echoNest.getHotness(artist.id);
        //artist.hotness = 0.7;


    }


    public function loadAudio(artist:Artist):Void {
        var docList: List;
        try {
            docList = echoNest.getAudio(artist.id, 0, 5).getDocuments();
        } catch (e:Exception) {
            println ("EchoNestManager exception");
            e.printStackTrace();
        }

        if (debug) println ("EchoNestManager found {docList.size()} audio tracks for {artist}");

        var audio: Audio[];
        for (i in [0..<
            docList.size()]) {
            var a: Audio =
            docList.get(i) as Audio;
            if (audioHelper.checkAudio(a)) {
                if (debug) println ("EchoNestManager inserting Audio {a.getUrl()}");
                insert a into audio;
            }
        }
        artist.audio = audio;
    }

    public function searchArtist(name:String):List {
        if (debug) println ("EchoNestManager: attempting to search for {name}");
        var list: List = echoNest.searchArtist(name, true);

        var artists: Artist[];
        var artistList = new ArrayList();
        if (debug) println ("EchoNestManager: Found {list.size()} artists");
        for (a in list) {
            var enArtist = a as com.echonest.api.v3.artist.Artist;

            if (debug) println ("EchoNestManager: Artist {enArtist.getName()} ID: {enArtist.getId()}");
/*
            insert 
            Artist {
                name: enArtist.getName(),
                id: enArtist.getId()
                echoNestManager: this
            } into artists;
            */
            var a2 = Artist {
                name: enArtist.getName(),
                id: enArtist.getId()
                echoNestManager: this
            };
            artistList.add(a2);
        };

        //artists
        artistList
    }

    public function loadVideo(artist:Artist):List {
        var list: List = echoNest.getVideo(artist.id, 0, 10).getDocuments();

        /*var videos:Video[];
        for (v in list) {
            var video = v as Video;

            insert video into videos;

            if (debug) println ("Found Video for {artist}: {video.getTitle()} {video.getSite()} {video.getURL()} {video.getDateFound()}");
        }
        */
        list
    }

    public function loadLinks(artist:Artist):List {
        var map: Map = echoNest.getUrls(artist.id);

        var list:List = new ArrayList();
        for (e in map.entrySet()) {
            var entry = e as java.util.Map.Entry;
            var l = Link {
                title: formatLink(entry.getKey().toString())
                url: entry.getValue().toString()
            }
            list.add(l);

        }
        list
    }

    function formatLink(str:String):String {
        if (str.startsWith("amazon")) {
            "Amazon"
        }
        else if (str.startsWith("itunes")) {
            "iTunes"
        }
        else if (str.startsWith("mb")) {
            "Music Brainz"
        }
        else if (str.startsWith("aol")) {
            "AOL Music"
        }
        else if (str.startsWith("last")) {
            "Last.fm"
        }
        else {
            str
        }


    }



    public function loadNews(artist:Artist):List {
        var list: List = echoNest.getNews(artist.id, 0, 5).getDocuments();

        /*var newsItems: News[];
        for (n in list) {
            var news = n as News;

            insert news into newsItems;

            if (debug) println ("Found News for {artist}: {news.getName()} {news.getSummary()} {news.getURL()} {news.getDateFound()}");
        }
        newsItems;
        */

        list
    }

    public function loadReviews(artist:Artist):List {
        var list: List = echoNest.getReviews(artist.id, 0, 5).getDocuments();

/*
        var reviews: Review[];
        for (r in list) {
            var review = r as Review;

            insert review into reviews;

            if (debug) println ("Found Review for {artist}: {review.getName()} {review.getSummary()} {review.getURL()} {review.getDateFound()}");
        }
        reviews;
        */

        list
    }

    public function loadBlogs(artist:Artist):List {
        var list: List = echoNest.getBlogs(artist.id, 0, 5).getDocuments();

/*
        var blogs: Blog[];
        for (b in list) {
            var blog = b as Blog;

            insert blog into blogs;

            if (debug) println ("Found Blog for {artist}: {blog.getName()} {blog.getSummary()} {blog.getURL()} {blog.getDateFound()}");
        }

        blogs
        */
        list
    }


}
