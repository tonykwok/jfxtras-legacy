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

import java.io.InputStream;
import javafx.data.pull.Event;
import javafx.data.pull.PullParser;
import javafx.data.xml.QName;

/*
 * @author joshua@marinacci.org
 */
public class PhotoPullParser {

    // Error Message (if any)
    public var errorMessage = "";

    // Information about all interesting photos
    public-read var photos: Photo[];

    // Completion callback that also delivers parsed photo metadata
    public var onDone: function(data : Photo[]) = null;

    public function parse(input: InputStream) {
        var currentPhoto:Photo;
        var inTitle = false;
        
        // Parse the input data (Photo Metadata) and construct Photo instance
        def parser = PullParser {

            input: input

            onEvent: function(event: Event) {
                if (event.type == PullParser.TEXT and inTitle) {
                    currentPhoto.title = event.text;

                }
                if (event.type == PullParser.START_ELEMENT) {
                    if(event.qname.name == "item") {
                         currentPhoto = Photo { };
                    }
                    if(event.qname.name == "title") {
                        currentPhoto.title = event.text;
                        //println("title = { currentPhoto.title}");
                        inTitle = true;
                    }


                    if(event.qname.name == "content") {
                        currentPhoto.url = event.getAttributeValue("url");
                        insert currentPhoto into photos;
                        //println("url  = { currentPhoto.url}");
                    }
                    if(event.qname.name == "thumbnail") {
                        currentPhoto.thumbUrl = event.getAttributeValue("url");
                        //println("thumb = { currentPhoto.thumbUrl}");
                        // a hack to get a larger photo that's not the huge original
                        // strip the _s part from the thumbnail url
                        var url = currentPhoto.thumbUrl;
                        var ext = url.substring(url.lastIndexOf("."));
                        var prefix = url.substring(0, url.lastIndexOf("_s"));
                        currentPhoto.url = "{prefix}{ext}";
                    }
                }
                if(event.type == PullParser.END_ELEMENT and event.qname.name == "title") {
                    inTitle = false;
                }

            }
        }

        parser.parse();
    }
}
