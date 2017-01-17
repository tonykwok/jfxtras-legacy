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

import javafx.scene.Node;

/*
 * @author joshua@marinacci.org
 */
public class ImageCache {
    public-read var cache:MasterImageCache;
    public-init var deleteOnStart = false;
    public-init var threadCount = 4;
    public-init var cacheName = "FXImageCache";
    
    init {
        cache = new MasterImageCache(deleteOnStart, threadCount, cacheName);
    }

    /*
    width and height are the desired size. the final returned image will be this
    size regardless of the size of the underlying image. If the real image is larger
    than the requested size it will be scaled down. The returned node will display
    the thumbnail image (scaled up) until the real image is available.

    all images will be cached on disk by url
    */
    public function getImage(url:String, thumbUrl:String, width:Integer, height:Integer,
    callback:ImageDownloadCallback):Node {
        return CachedImage {
            imageCache: cache
            url: url 
            thumbUrl: thumbUrl
            width: width
            height: height
            callback: callback
            }
    }

    public function getImage(url:String, thumbUrl:String, width:Integer, height:Integer):Node {
        getImage(url, thumbUrl, width, height, null);
    }

    public function shutdown():Void {
        cache.shutdown();
    }


}
