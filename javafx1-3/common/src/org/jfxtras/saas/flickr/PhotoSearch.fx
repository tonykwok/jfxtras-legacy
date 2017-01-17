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
package org.jfxtras.saas.flickr;

import javafx.io.http.HttpRequest;

/**
 * @author Stephen Chin
 */
public class PhotoSearch {
    /**
     * Your API application key.
     */
    public-init var apiKey:String;

    /**
     * A list of tags. Photos with one or more of the tags listed will be returned.
     */
    public var tags:String[];

    /**
     * Either TagMode.ANY for an OR combination of tags, or TagMode.ALL for an AND combination. Defaults to ANY if not specified.
     */
    public var tagMode:TagMode;

    /**
     * A free text search. Photos who's title, description or tags contain the text will be returned.
     */
    public var text:String;

    /**
     * Number of photos to return per page. If this argument is omitted, it defaults to 100. The maximum allowed value is 500.
     */
    public var perPage:Integer;

    /**
     * The page of results to return. If this argument is omitted, it defaults to 1.
     */
    public var page:Integer;

    public function search() {
        HttpRequest {

        }
    }
}
