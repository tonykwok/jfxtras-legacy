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
package org.jfxtras.redfx.client.rest;

import javafx.io.http.HttpRequest;
import java.io.InputStream;
import java.lang.String;
import javafx.data.Pair;
import javafx.io.http.URLConverter;
import java.lang.Exception;
import javafx.io.http.HttpHeader;
import javafx.data.pull.PullParser;

/**
 * @author johan
 */
package var cacheEnabled: Boolean = false;
package var cacheTimeout: Integer = 10; // 60 seconds default timeout
package var cache: RestCache = new RestCache();
// public var responseType = "json";

public function enableCaching() {
    cacheEnabled = true;
}

public function disableCaching() {
    cacheEnabled = false;
}

public function setCacheTimeout(seconds: Integer) {
    cacheTimeout = seconds;
}

public function getUri(uri: String, clazz: String, callback: function(loc: String, obj: Object): Void,
        errorCallback: function(msg: String): Void, responseType: String): Void {
    getUri(uri, clazz, callback, errorCallback, null, null, responseType);
}

public function getUri(uri: String, clazz: String, callback: function(loc: String, obj: Object): Void,
        errorCallback: function(msg: String): Void, username: String, password: String, responseType: String): Void {

    if (cacheEnabled) {
        var result: Object = cache.hasValidEntry(uri);
        if (result != null) {
            println("[RedFX] return cached result");
            callback(uri, result);
            return;
        }
    }

    var xmlParser: PullParser = RestXMLParser {
                uri: uri;
                clazz: clazz;
                callback: callback;
            };
    var jsonParser: PullParser = RestParser {
                uri: uri;
                clazz: clazz;
                callback: callback;
            };
    var myparser: PullParser = bind
            if (responseType == "json")
                jsonParser else
                xmlParser;

    var req: HttpRequest = HttpRequest {
                headers: if (username != null) {
                    HttpHeader.basicAuth(username, password);
                } else { null }
                location: uri
                onInput: function(is: InputStream) {
                    myparser.input = is;
                    myparser.parse();
                    is.close();
                }
                onException: function(ex : Exception) {
                    errorCallback("{ex.getClass()}: {ex.getMessage()}");
                }
            }
    println("[RedFX] myparsing {uri}");
    req.start();
}

public function postUri(uri: String, params: Pair[], clazz: String,
        callback: function(loc: String, obj: Object): Void,
        errorCallback: function(msg: String): Void, responseType: String): Void {
    postUri(uri, params, clazz, callback, errorCallback, null, null, responseType)
}

public function postUri(uri: String, params: Pair[], clazz: String,
        callback: function(loc: String, obj: Object): Void,
        errorCallback: function(msg: String): Void,
        username: String, password: String, responseType: String): Void {
    var myparser: RestParser = RestParser {
                uri: uri;
                clazz: clazz;
                callback: callback;
            }

    var req: HttpRequest = HttpRequest {
                headers: if (username != null) {
                    HttpHeader.basicAuth(username, password);
                } else { null }
                location: uri
                onInput: function(is: InputStream) {
                    myparser.input = is;
                    myparser.parse();
                    is.close();
                }
                onOutput: function(os: java.io.OutputStream) {
                    try {
                        var converter: URLConverter = URLConverter {};
                        os.write(converter.encodeParameters(params).getBytes());
                        os.close();
                    } catch (ex: Exception) { println("exception: {ex}") } finally {
                        os.close();
                    }
                }
                onException: function(ex: Exception) {
                    errorCallback("{ex.getClass()}: {ex.getMessage()}");
                }

            }
    req.start();

}
