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

import java.awt.image.BufferedImage;
import javafx.scene.CustomNode;
import javafx.scene.Node;
import javafx.scene.Group;
import javafx.scene.image.*;
import javafx.ext.swing.SwingUtils;

/*
 * @author joshua@marinacci.org
 */
public class CachedImage extends CustomNode {
    public-init var imageCache:MasterImageCache;
    public-init var url:String;
    public-init var thumbUrl:String;
    public-init var width:Integer;
    public-init var height:Integer;
    public-init var callback:ImageDownloadCallback;



    var fullImage:ImageView;
    var thumbImage:ImageView;
    init {
        imageCache.getImage(url, thumbUrl, width, height, SizingMethod.Stretch, MasterImageCache.Callback {
            override public function fullImageLoaded(image:BufferedImage) {
                //println("image fully loaded: {image}");
                def fxImage = SwingUtils.toFXImage(image);
                fullImage = ImageView {
                    image: fxImage
                }
                callback.fullImageLoaded(fxImage);
            }
            override public function thumnailImageLoaded(image:BufferedImage) {
                //println("thumb fully loaded {image}");
                def fxImage = SwingUtils.toFXImage(image);
                thumbImage = ImageView {
                    fitWidth: width
                    fitHeight: height
                    image: fxImage
                }
                callback.thumnailImageLoaded(fxImage);
            }
            override public function error() {
                callback.error();
            }
        });

    }



    override public function create():Node {
        return Group { content: bind [thumbImage, fullImage] };
    }

}
