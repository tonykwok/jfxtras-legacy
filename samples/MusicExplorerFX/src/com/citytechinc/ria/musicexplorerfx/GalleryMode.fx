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

import com.citytechinc.ria.musicexplorerfx.Mode;
import com.citytechinc.ria.musicexplorerfx.model.Artist;
import javafx.animation.Interpolator;
import javafx.animation.KeyFrame;
import javafx.animation.Timeline;
import javafx.animation.transition.AnimationPath;
import javafx.animation.transition.ParallelTransition;
import javafx.animation.transition.PathTransition;
import javafx.animation.transition.ScaleTransition;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;
import javafx.scene.shape.MoveTo;
import javafx.scene.shape.Path;
import javafx.scene.shape.QuadCurveTo;

/**
 * @author sanderson
 */

public class GalleryMode extends Mode {

    var imageSlots: ImageSlot[];
    var currentSlotIndex = -1;
    var currentImageIndex = -1;

    var imageTimer: Timeline;
    var stopped = true;

    postinit {
        var offsetX = 400;
        imageSlots = [
            ImageSlot {
                x: bind explorer.centerX - offsetX
                y: 500
                initialX: 1000
                initialY: -400
            }
            ImageSlot {
                x: bind explorer.centerX + offsetX //1045
                y: 500
                initialX: -200
                initialY: -400
            }
        ];

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
                imageUrl: "ClonesIcon.png"
                w: buttonWidth
                action: function() {
                    explorer.switchToSimilarMode()
                }

            }
            into buttons;

        imageTimer = Timeline {
            repeatCount: Timeline.INDEFINITE
            keyFrames: [
                KeyFrame {
                    action: function() {
                        showNextImage()
                    }
                    time: 5s
                }

            ]
        }

    }

    override public function start():Void {
        stopped = false;
        explorer.startProgress();
        explorer.modeStarted(this);
        explorer.currentNode.artist.loadImageGallery(explorer.flickrManager, showGallery);
    }

    override public function stop():Void {
        stopped = true;
        imageTimer.stop();
        explorer.dismissProgress();
        dismissImages();

        dismissButtons();

        for (slot in imageSlots) {
            slot.reset();
        }

    }

    function dismissImages() {
        for (slot in imageSlots) {
            slot.hide();
        }
    }

    override public function updateBounds():Void {
        dismissImages();
    }

    var showGallery = function(a:Artist):Void {
        if (explorer.currentNode.artist != a) {
            return;
        }
        explorer.dismissProgress();
        if (sizeof a.imageUrls == 0) {
            explorer.showStatus("No Images Found");
            return;
        }

        //println ("images loaded {a} {sizeof a.imageUrls}");
        showNextImage();
        showNextImage();
        imageTimer.playFromStart();
    }

    function showNextImage() {
        var artist = explorer.currentNode.artist;
        currentSlotIndex++;
        if (currentSlotIndex >= sizeof imageSlots) {
            currentSlotIndex = 0;
        }
        currentImageIndex++;
        if (currentImageIndex >= sizeof artist.imageUrls) {
            currentImageIndex = 0;
        }
        //println ("Gallery: {currentSlotIndex} {currentImageIndex} showing next image");
        imageSlots[currentSlotIndex].show(artist.imageUrls[currentImageIndex]);
    }


}

class ImageSlot {

    var x: Number;
    var y: Number;
    var initialX: Number;
    var initialY: Number;
    var currentImage: ImageView;
    var nextImage: ImageView;
    var outPath: Path;
    var inPath: Path;

    postinit {
        inPath = Path {
            elements: [
                MoveTo {
                    x: initialX
                    y: initialY
                }
                QuadCurveTo {
                    controlX: 600
                    controlY: 600
                    x: bind x
                    y: y
                }
            ]
        }
        outPath = Path {
            elements: [
                MoveTo {
                    x: bind x
                    y: y
                }
                QuadCurveTo {
                    controlX: 600
                    controlY: 600
                    x: initialX
                    y: 2500
                }


            ]
        }
    }

    function reset():Void {
        currentImage = null;
        nextImage = null;
    }


    function show(url:String):Void {
        if (stopped) {
            return;
        }

        hide();
        //if (nextImage != null) {
        //    println ("{x} nextImage progress: {nextImage.image.progress}");
        //}

        var newImage = ImageView {
            image: Image {
                url: url
            }
            fitWidth: 450
            preserveRatio: true
            scaleX: 0
            scaleY: 0

        }
        
        currentImage = nextImage;
        nextImage = newImage;
        if (currentImage == null) {
            return;
        }
        insert currentImage into nodes;
        //println ("{x} showing current image");
        ParallelTransition {
            content: [
                PathTransition {
                    node: currentImage
                    duration: 2s
                    interpolator: Interpolator.EASEBOTH
                    path: AnimationPath.createFromPath(inPath);
                }
                ScaleTransition {
                    node: currentImage
                    duration: 2s
                    fromX: 0
                    fromY: 0
                    toX: 1
                    toY: 1
                }
            ]
        }.play();
    }

    function hide() {
        if (currentImage == null) {
            return;
        }
        var oldImage = currentImage;
        //println ("{x} hiding currentImage");
        ParallelTransition {
            action: function() { delete oldImage from nodes
            }
            content: [
                PathTransition {
                    node: oldImage
                    duration: 3s
                    interpolator: Interpolator.EASEBOTH
                    path: AnimationPath.createFromPath(outPath);
                }
                ScaleTransition {
                    node: oldImage
                    duration: 3s
                    fromX: 1
                    fromY: 1
                    toX: 0
                    toY: 0
                }

            ]
        }.play();

    }


}

