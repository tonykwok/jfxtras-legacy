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
package com.citytechinc.ria.mefxmobile.ui.widget;

import javafx.scene.CustomNode;
import javafx.scene.Node;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;
import javafx.scene.input.MouseEvent;

/**
 * @author sanderson
 */

public class ImageButton extends CustomNode {

    public var x: Number;
    public var y: Number;
    public var w: Number;

    public var imageUrl: String on replace {createImages()};
    public var enabled = true;
    public var active = true;
    public var action: function():Void;

    var imageView:ImageView;

    var currentImage:Image;
    var image:Image;
    var pressedImage:Image;

    override function create():Node {
        imageView = ImageView {
            image: bind currentImage
            translateX: bind x
            translateY: bind y

            onMousePressed: function(me:MouseEvent):Void {
                if (not enabled or not active) {
                    return;
                }
                currentImage = pressedImage;
            }
            onMouseReleased: function(me:MouseEvent):Void {
                if (not active) {
                    return;
                }
                currentImage = image;
                if (enabled) {
                    action();
                }
            }
        }

        imageView
    }

    function createImages():Void {
        //var imagePath = "{__DIR__}../../images/{imageUrl}.png";
        var imagePath = "{__DIR__}{imageUrl}.png";
        //var pressedImagePath = "{__DIR__}../../images/{imageUrl}Glow.png";
        var pressedImagePath = "{__DIR__}{imageUrl}Glow.png";
        //var imagePath = "/com/citytechinc/ria/mefxmobile/images/SearchIcon.png";
        image = Image {
            url: imagePath
            preserveRatio: true
            width: w
        }
        pressedImage = Image {
            url: pressedImagePath
            preserveRatio: true
            width: w
        }

        currentImage = image;
    }

}