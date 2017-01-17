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

import com.citytechinc.ria.musicexplorerfx.model.Artist;
import com.citytechinc.ria.musicexplorerfx.util.JFXTask;
import java.lang.Math;
import javafx.scene.shape.Line;


import java.util.List;

import java.util.ArrayList;

/**
 * @author sanderson
 */

public class SimilarMode extends Mode {

    //var slots:Number[] = [315, 0, 45, 135, 180, 225];
//    var slots:Number[] = [325, 0, 35, 145, 180, 215];
    var slots:Number[] = [327, 0, 33, 147, 180, 213];

    var curIteration = 0;
    //var curSimilar = 0;

    var notFoundStr = "Couldn't Find Any Similar Artists.";

    var stopped = true;

    postinit {
        insert
            ImageButton {
                x: bind buttonSlots[1]
                imageUrl: "InfoIcon.png"
                w: buttonWidth
                action: function() {
                    explorer.switchToArtistInfoMode()
                }

            }
            into buttons;
       insert
            ImageButton {
                x: bind buttonSlots[2]
                imageUrl: "ImagesIcon.png"
                w: buttonWidth
                action: function() {
                    explorer.switchToGalleryMode()
                }

            }
            into buttons;
        
    }

    override public function start():Void {
        stopped = false;
        findSimilar();
        explorer.modeStarted(this);
    }

    override public function stop():Void {
        curIteration++;
        if (stopped) {
            return;
        }

        stopped = true;
        dismissButtons();
        for (n in explorer.currentNode.similar) {
            n.dismiss();
        }
        delete explorer.currentNode.similar;

    }

    override public function updateBounds():Void {
        for (n in explorer.currentNode.similar) {
            var points = getRadialPosition(indexof n);
            n.x = points[0];
            n.y = points[1];
            n.updateBounds();
        }

    }

    function findSimilar():Void {
        var currentNode = explorer.currentNode;
        if (sizeof currentNode.similar > 0) {
            currentNode.setExpectedSimilar(sizeof currentNode.similar);
            for (s in currentNode.similar) {
                insert s.line into nodes;
                insert s into nodes;
                s.intro();
            }
            return;
        }
        explorer.startProgress();
        var iteration = ++curIteration;
        JFXTask {
            //inBackground: function():Artist[] {
            inBackground: function():List {
                return explorer.echoNestManager.findSimilar(currentNode.artist, 0);
            }

            onDone: function(result) {
                var artists:Artist[];
                for (a in result as List) {
                    insert a as Artist into artists;
                }

                //var result = explorer.echoNestManager.findSimilar(currentNode.artist, 0);
                if (sizeof result == 0) { // nothing to do from here...
                    explorer.showStatus(notFoundStr);
                    //explorer.modeStarted(this);
                    return;
                }
                //println ("size of similar {sizeof result} {result.getClass()} {result}");
                //printSequence(result as Object[]);
                explorer.hideStatus();
                //explorer.modeStarted(this);

                //var artists:Artist[] = [];
                //var objs = (result as Object[])[0] as Object[];
                //println ("size of objs {sizeof objs} {objs}");
                //for (o in objs) {
                //    println ("o class {o.getClass()} {o}");

                    //insert o as Artist into artists;
                //}


                //var artists = result as Artist[];
                var checkedArtists: Artist[];
                for (a in artists) {
                    a.iterationNumber = iteration;
                    if (checkArtist(a, sizeof checkedArtists)) {
                        insert a into checkedArtists;
                    }
                }
                currentNode.setExpectedSimilar(sizeof checkedArtists);
                for (checked in checkedArtists) {
                    checked.loadArtistData(explorer.lastfmManager, function() {
                        addSimilar(checked, sizeof checkedArtists);
                    })
                }

            }

        }
    }
/*
    function printSequence(seq:Object[]):Void {
        for (s in seq) {
            println ("s: {s.getClass().getName()}");
            if (s instanceof Sequence) {
                println ("s size {sizeof s}");
                printSequence(s as Object[]);
            }
        }

    }
*/

    function checkArtist(artist:Artist, currentSize:Integer):Boolean {
        if (currentSize >= sizeof slots) {
            //println ("similar full, skipping {artist}");
            return false;
        }
        for (a in explorer.history) {
            if (a.artist.name.equals(artist.name)) {
                //println ("skipping artist in history: {artist}");
                return false;
            }

        }
        true
    }

    function addSimilar(artist:Artist, totalExpected:Integer):Void {
        if (artist.iterationNumber != curIteration) {
            //println ("skipping similar artist from old iteration: {artist}");
            return;
        }
        
        var point = getNextRadialPosition();
        var line = createLine(point[0], point[1]);

        var node = ArtistNode {
            opacity: 0
            //w: explorer.nodeWidth
            x: point[0]
            y: point[1]
            artist: artist
            explorer: explorer
            similarMode: this
            line: line
            parentNode: explorer.currentNode
            action: explorer.nodeClicked
        }

        insert node into explorer.currentNode.similar;
        insert node into nodes;

        explorer.setProgress(sizeof explorer.currentNode.similar, totalExpected);
        if (sizeof explorer.currentNode.similar == totalExpected) {
            explorer.dismissProgress();
        }

        node.intro();
    }

    function createLine(x:Number, y:Number):Line {
        var line = Line {
            //opacity: 0.6
            cache: true
            opacity: 0
            strokeWidth: 2
            startX: bind explorer.centerX
            startY: bind explorer.centerY
            endX: x
            endY: y
        }
        insert line into nodes;

        line;
    }

    function getNextRadialPosition():Number[] {
        getRadialPosition(sizeof explorer.currentNode.similar);
    }

    function getRadialPosition(index:Integer):Number[] {
        var radius = if (index == 1 or index == 4) {
            explorer.width * 0.4
        }
        else {
            explorer.width * 0.27
        }

        getRadialPosition(slots[index], radius);
    }


    function getRadialPosition(theta:Number, radius:Number) {
        [polarToX(theta, radius), polarToY(theta, radius)]
    }

    function polarToX(theta:Number, r:Number):Number {
        r * Math.cos(Math.toRadians(theta)) + explorer.centerX;
    }

    function polarToY(theta:Number, r:Number):Number {
        r * Math.sin(Math.toRadians(theta)) + explorer.centerY;
    }

/*
    public function currentNodeComplete(artistNode:ArtistNode) {
        if (artistNode == explorer.currentNode) {
            explorer.modeStarted(this);
        }
    }
*/
}
