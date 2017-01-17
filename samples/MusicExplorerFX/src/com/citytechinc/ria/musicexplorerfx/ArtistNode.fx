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

import com.citytechinc.ria.musicexplorerfx.ArtistExplorer;
import com.citytechinc.ria.musicexplorerfx.ArtistNode;
import com.citytechinc.ria.musicexplorerfx.Gauge;
import com.citytechinc.ria.musicexplorerfx.InfoNode;
import com.citytechinc.ria.musicexplorerfx.model.Artist;
import com.citytechinc.ria.musicexplorerfx.SimilarMode;
import javafx.animation.Interpolator;
import javafx.animation.KeyFrame;
import javafx.animation.Timeline;
import javafx.animation.transition.FadeTransition;
import javafx.animation.transition.ParallelTransition;
import javafx.animation.transition.ScaleTransition;
import javafx.animation.transition.SequentialTransition;
import javafx.animation.transition.TranslateTransition;
import javafx.scene.CustomNode;
import javafx.scene.effect.Effect;
import javafx.scene.effect.Glow;
import javafx.scene.Group;
import javafx.scene.image.ImageView;
import javafx.scene.input.MouseEvent;
import javafx.scene.Node;
import javafx.scene.paint.Color;
import javafx.scene.paint.LinearGradient;
import javafx.scene.paint.Stop;
import javafx.scene.shape.Line;
import javafx.scene.shape.Rectangle;
import javafx.scene.text.Font;
import javafx.scene.text.Text;
import javafx.scene.text.TextAlignment;

import javafx.ext.swing.SwingUtils;

/**
 * @author sanderson
 */

public class ArtistNode extends CustomNode {

    public var x: Number;// on replace {updateBounds()};
    public var y: Number;// on replace {updateBounds()};

    public var artist: Artist;
    public var explorer: ArtistExplorer;
    public var similarMode: SimilarMode;
    public var inHistory = false;

    public var infoNodes: InfoNode[];
    public var similar: ArtistNode[];
    public var parentNode: ArtistNode;

    public var line: Line;

    public var action: function(a:ArtistNode):Void;
    public var isCurrent = false;
    public var scaleExempt = false;
    public var ready = false;

    public-read var defaultHeight:Number;

    var w: Number = explorer.nodeWidth;

    var imageWidth: Number = w - 10;

    var historyScale = 0.3;
    var magScale = 0.45;

    var curEffect: Effect;
    var rect: Rectangle;
    var rectHeight:Number;
    

    var magnify: ScaleTransition;
    var demagnify: ScaleTransition;

    var expectedSimilar = 0;
    var numSimilar = 0;
    var familiarity:Gauge;
    var hotness:Gauge;

    var midColor:Color;

    var showAudioTimeline:Timeline;

    override function create():Node {
        cache = true;
        magnify = ScaleTransition {
            toX: magScale
            toY: magScale
            node: this
            duration: 0.5s
        }
        demagnify = ScaleTransition {
            toX: historyScale
            toY: historyScale
            node: this
            duration: 0.2s
        }
        //println ("ArtistNode: imageUrl: {artist.imageUrl} height {y - h / 2 - imageView.boundsInLocal.height}");
        var text = Text {
            cache: true
            fill: Color.WHITE
            content: artist.name
            wrappingWidth: imageWidth
            textAlignment: TextAlignment.CENTER
            font: Font {size:18}

        }

        var centerX = -imageWidth / 2;

        var imageView = ImageView {
            image: SwingUtils.toFXImage(artist.image)
            translateX: centerX
            preserveRatio: true
            fitWidth: imageWidth

        }
        imageView.translateY = -imageView .boundsInLocal.height / 2 + text.boundsInLocal.height / 4; // add an offset for multi-line text
        text.translateX = -text.boundsInLocal.width / 2;
        text.translateY = -imageView .boundsInLocal.height / 2 - text.boundsInLocal.height / 2;

        var gaugeHeight = w / 27;
        var gaugeOffsetY = imageView.boundsInLocal.height / 2 + text.boundsInLocal.height / 2 + gaugeHeight;
        var rectPaddingX =  w - imageWidth;
        var rectPaddingY =  w / 6.75;

        familiarity = Gauge {
            w:  imageWidth
            h:  gaugeHeight
            //value: artist.familiarity
            translateX:  centerX
            translateY:  gaugeOffsetY
            color: Color.rgb(0, 255, 0)
        }
        hotness = Gauge {
            w:  imageWidth
            h:  gaugeHeight
            //value: artist.hotness
            translateX:  centerX
            translateY:  gaugeOffsetY + 15
            color: Color.rgb(255, 200, 0)
        }

        //var topColor = Color {
        //    red: 0.2,
        //    green: 0.4,
        //    blue: 0.6
        //}
        midColor = Color.rgb(65, 100, 140);
        /*
        var midColor = Color {
            red: 0.1,
            green: 0.2,
            blue: 0.4
        }
        */
        //var bottomColor = Color {
        //    red: 0,
        //    green: 0.1,
        //    blue: 0.3
        //}
        rectHeight =  text.boundsInLocal.height + imageView.boundsInLocal.height + rectPaddingY + gaugeHeight * 2;
        defaultHeight = rectHeight;
        //println ("rect height: {rectHeight}, text h {text.boundsInLocal.height}, imageView h {imageView.boundsInLocal.height} rectPadding {rectPadding}");
        rect = Rectangle {
            cache: true
            opacity: 0.4
            arcWidth: 10
            arcHeight: 10
            width:  w
            height: bind rectHeight
            translateX:  centerX - rectPaddingX / 2
            translateY:  text.translateY - rectPaddingY * 0.7
            stroke: Color.WHITESMOKE
            //fill: midColor
            //fill: Color.rgb(10, 10, 10)
 // This gradient is too much of a performance sink...for now.
/*
            fill: LinearGradient {
                startX: 0
                startY: 0
                endX: 0
                endY: 1
                stops: [
                    Stop {
                        offset: 0.0
                        color: topColor
                    },
                    Stop {
                        offset: 0.2
                        color: midColor
                    },
                    Stop {
                        offset: 0.6
                        color: midColor
                    },
                    Stop {
                        offset: 1.0
                        color: bottomColor
                    }
                ]
            }
*/
        };

        updateBounds();

        artist.loadFamiliarityAndHotness(updateGauges);

        Group {
            effect: bind curEffect
            onMouseEntered: function(e:MouseEvent) {
                if (not explorer.active) {
                    return;
                }

                if (not isCurrent) {
                    curEffect = Glow {
                    }
                }
                
                if (inHistory) {
                    demagnify.stop();
                    magnify.play();
                }

            }
            onMouseExited: function(e:MouseEvent) {
                curEffect = null;
                if (inHistory) {
                    magnify.stop();
                    demagnify.play();
                }
            }
            onMouseClicked: function(e:MouseEvent) {
                if (explorer.active) {
                    curEffect = null;
                    action(this);
                }
            }
 
            content: [
                rect,
                text,
                imageView,
                familiarity,
                hotness
            ]
        }

    }

    var updateGauges:function():Void = function():Void {
        familiarity.setValue(artist.familiarity);
        hotness.setValue(artist.hotness);
    };


    public function updateBounds() {

        translateX = x;
        translateY = y;

        if (line != null) {
            line.endX = x;
            line.endY = y;
            line.stroke = LinearGradient {
                proportional: false
                startX: explorer.centerX
                startY: explorer.centerY
                endX: x
                endY: y
                stops: [
                    Stop {
                        offset: 0.0
                        color: Color.BLACK

                    },
                    Stop {
                        offset: 0.4
                        //color: Color {red: 0, green: 0, blue: 0.1}
                        color: Color.rgb(31,48,68)
                    }
                    Stop {
                        offset: 0.8
                        color: midColor
                    }
                    Stop {
                        offset: 1.0
                        color: Color.BLACK
                    }
                ]
            }
            updateScale();
        }

    }


    public function setExpectedSimilar(num:Integer) {
        expectedSimilar = num;
        numSimilar = 0;
    }

    public function incrementSimilar() {
        numSimilar++;
        //if (numSimilar == expectedSimilar) {
        //    similarMode.currentNodeComplete(this);
        //}

    }

    public function removeFromParent() {
        similarMode.removeNode(this);
        similarMode.removeNode(line);
    }

    
    public function dismiss():Void {
        line.visible = false;
        FadeTransition {
            action: function() {
                removeFromParent();
            }
            node: this
            duration: 0.8s
            fromValue: 1
            toValue: 0
        }.play();
    }

    public function moveTo(toX:Number, toY:Number, scale:Number):Void {
        moveTo(toX, toY, scale, null)
    }

    public function moveToHistory(toX:Number, toY:Number):Void {
        moveTo(toX, toY, historyScale);
    }


    public function moveTo(toX:Number, toY:Number, scale:Number, f:function():Void):Void {
        var dur = 0.8s;
        ParallelTransition {
            action: function() {
                if (isCurrent) {
                    ready = true;
                }

                f()
            }
            content: [
                ScaleTransition {
                    fromX: this.scaleX
                    fromY: this.scaleY
                    toX: scale
                    toY: scale
                    node: this
                    duration: dur
                },
                TranslateTransition {
                    node: this
                    duration: dur
                    fromX: this.translateX
                    fromY: this.translateY
                    toX: toX
                    toY: toY
                }
            ]
        }.play();

    }

    function updateScale():Void {
        if (isCurrent or scaleExempt) {
            return;
        }

        var expScale = explorer.width / 1300.0;
        var scale = if (expScale > 1) expScale else 1.0;
        scale *= 0.7;
        if (scale > 0.9) {
            scale = 0.9
        }

        scaleX = scale;
        scaleY = scale;
    }

    public function showAudio(audioPlayer:AudioPlayer):Void {
        var controlsY = explorer.controls.translateY;
        showAudioTimeline = Timeline {
            
            keyFrames: [
                KeyFrame {
                    time: 0s
                    values: [rectHeight => defaultHeight tween Interpolator.EASEBOTH,
                            explorer.controls.translateY => controlsY tween Interpolator.EASEBOTH]
                }
                KeyFrame {
                    action: function() {
                        // check to see if we're still the current node
                        if (isCurrent) {
                            audioPlayer.translateY = explorer.centerY + defaultHeight / 2;
                            audioPlayer.intro();
                        }
                    }
                    time: 0.5s
                    values: [rectHeight => defaultHeight + 80 tween Interpolator.EASEBOTH,
                            explorer.controls.translateY => controlsY + audioPlayer.boundsInLocal.height tween Interpolator.EASEBOTH]
                }
            ]
        }
        showAudioTimeline.play();
    }

    public function hideAudio():Void {
        if (showAudioTimeline != null) {
            showAudioTimeline.stop();
        }

        if (rectHeight != defaultHeight) {
            Timeline {

                keyFrames: [
                    KeyFrame {
                        time: 0s
                        values: [rectHeight => rectHeight tween Interpolator.EASEBOTH]
                    }
                    KeyFrame {
                        time: 0.2s
                        values: [rectHeight => defaultHeight tween Interpolator.EASEBOTH]
                    }
                ]
            }.play();
        }

    }


    public function intro():Void {
        line.opacity = 0;
        line.visible = true;
        updateScale();
        translateX = x;
        translateY = y;
        SequentialTransition {
            action: function() { parentNode.incrementSimilar()
            }
            content: [
                FadeTransition {
                    node: this
                    duration: 1s
                    fromValue: 0
                    toValue: 1
                },
                FadeTransition {
                    node: line
                    duration: 0.2s
                    fromValue: 0
                    toValue: 1
                }
            ]
        }.play();

    }

}
