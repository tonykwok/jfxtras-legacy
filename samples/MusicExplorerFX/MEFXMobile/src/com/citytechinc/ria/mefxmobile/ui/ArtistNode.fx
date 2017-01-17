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
package com.citytechinc.ria.mefxmobile.ui;

import javafx.scene.CustomNode;
import javafx.scene.Group;
import javafx.scene.image.ImageView;
import javafx.scene.Node;
import javafx.scene.paint.Color;
import javafx.scene.shape.Rectangle;
import javafx.scene.text.Font;
import javafx.scene.text.Text;
import javafx.scene.text.TextAlignment;

import javafx.scene.input.MouseEvent;
import com.citytechinc.ria.mefxmobile.model.Artist;

import javafx.scene.image.Image;


/**
 * @author sanderson
 */

public class ArtistNode extends CustomNode {

    public var x: Number;
    public var y: Number;

    public var artist: Artist;
    public var action: function():Void;
    public var width: Number;

    var imageWidth: Number = width - 10;
    var rect: Rectangle;
    def rectHeight = width * 0.87;
    def rectTranslateY = rectHeight / 2;

    var familiarity:Gauge;
    var hotness:Gauge;

    var imageView:ImageView;
    var centerX = -imageWidth / 2;

    override function create():Node {
        cache = true;
        var textPaddingY = width * 0.02;
        var imagePaddingY = width * 0.04;

        var text = Text {
            fill: Color.WHITE
            content: artist.name
            wrappingWidth: imageWidth
            textAlignment: TextAlignment.CENTER
            font: Font {size: width / 20}
            translateY: -rectTranslateY + width * 0.067
        }
        text.translateX = -text.boundsInLocal.width / 2;
        var gaugeHeight = width / 40;
        var rectPaddingX =  width - imageWidth;
        var gaugePaddingY = 3;

        familiarity = Gauge {
            w:  imageWidth
            h:  gaugeHeight
            translateX:  centerX
            translateY: rectTranslateY - (gaugeHeight + gaugePaddingY * 2);
            color: Color.rgb(0, 255, 0)
        }
        hotness = Gauge {
            w:  imageWidth
            h:  gaugeHeight
            translateX:  centerX
            translateY: rectTranslateY - gaugePaddingY;
            color: Color.rgb(255, 200, 0)
        }

       // println ("rect height: {rectHeight}, text h {text.boundsInLocal.height}, imageView h {imageView.boundsInLocal.height} rectPadding {rectPaddingY}");
        rect = Rectangle {
            opacity: 0.8
            arcWidth: 10
            arcHeight: 10
            width: width
            height: rectHeight
            translateX:  centerX - rectPaddingX / 2
            translateY:  -rectTranslateY
            stroke: Color.WHITESMOKE
        };

        translateX = x + width / 2;
        translateY = y + rectHeight / 2;

        artist.loadProfileImage(createImageView);
        artist.loadFamiliarity(updateFamiliarity);
        artist.loadHotness(updateHotness);

        Group {
            onMouseClicked: function(e:MouseEvent) {
                action();
            }

            content: bind [
                rect,
                imageView,
                text,
                familiarity,
                hotness
            ]
        }

    }

    var createImageView:function (:Image) = function(image:Image) {
        imageView = ImageView {
            image: image
            //translateX: bind -imageView.boundsInLocal.width / 2
            //translateX: bind updateImageView()
            translateY: -rectTranslateY + width * 0.1
            preserveRatio: true
            fitWidth: imageWidth
            fitHeight: imageWidth * 0.7

        }
        imageView.translateX = -imageView.boundsInLocal.width / 2
    }

    var updateFamiliarity:function():Void = function():Void {
        familiarity.setValue(artist.familiarity);
    };

    var updateHotness:function():Void = function():Void {
        hotness.setValue(artist.hotness);
    };


}
