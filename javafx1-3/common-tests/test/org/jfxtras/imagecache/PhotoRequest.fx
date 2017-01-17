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

import javafx.io.http.HttpRequest;
import java.lang.Exception;

/*
 * @author joshua@marinacci.org
 */
public class PhotoRequest {
    public-init var url:String;
    public-read var photos:Photo[];
    var httpRequestError = false;

    public-init var onDone:function():Void;

    public-read var request: HttpRequest = HttpRequest {
        location: url
        method: HttpRequest.GET
        onRead: function(bytes: Long) {
            // The toread variable is non negative only if the server provides the content length
            //def loadProgress = if (request.toread > 0) "{(bytes * 100 / request.toread)}%" else "";
            //description = "Loading Photos... ({loadProgress})";
        }

        onException: function(exception: Exception) {
            exception.printStackTrace();
            httpRequestError = true;
        }

        onResponseCode: function(responseCode:Integer) {
            if (responseCode != 200) {
                println("failed, response: {responseCode} {request.responseMessage}");
            }
        }

        onInput: function(input: java.io.InputStream) {
            try {
                var parser = PhotoPullParser { };
                parser.parse(input);
                //println("got photos {parser.photos.size()}");
                photos = parser.photos;
                if(parser.errorMessage.length() > 0) {
                    httpRequestError = true;
                }

                if(onDone != null) {
                    onDone();
                }

            } finally {
                input.close();
            }
        }
    }
}
