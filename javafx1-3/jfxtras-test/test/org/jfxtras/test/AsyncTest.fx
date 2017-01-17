/**
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

/*
 * TestAsync.fx
 *
 * Created on Jul 28, 2009, 2:05:46 AM
 */

package org.jfxtras.test;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import javafx.io.http.HttpRequest;
import org.jfxtras.test.Expect.*;

import javafx.scene.shape.Rectangle;
import org.jfxtras.async.XWorker;

import com.sun.javafx.runtime.sequence.ObjectArraySequence;

import javafx.animation.Timeline;

/**
 * @author Stephen Chin
 */
public class AsyncTest extends Test {}

function run() {
    perform("Asynchronous tests", [
        Test {
            var result:String;
            say: "should work with HttpRequests"
            do: function() {
                HttpRequest {
                    location: "http://whoismyrepresentative.com/whoismyrep.php?zip=62246&output=json"
                    onInput: function(input:InputStream) {
                        var buf = new BufferedReader(new InputStreamReader(input));
                        var line:String;
                        while ((line = buf.readLine()) != null) {
                            result += line;
                        }
                        buf.close();
                    }
                    onException: function(e) {
                        result = "{e.getClass().getName()}: {e.getMessage()}";
                    }
                }.start();
                null
            }
            waitFor: function() {result}
            expect: equalTo('\{ "results": [\{"name": "John Shimkus", "state": "IL", "district": "19", "phone": "(202) 225-5271", "office": "2452 Rayburn", "link": "http://www.house.gov/shimkus/" \}]\}')
        }
        Test {
            var rectangles = [Rectangle{}, Rectangle{}];
            var asyncCreatedRects: Rectangle[];
            say: "should work with XWorker"
            do: function() {
                XWorker {
                    inBackground: function() {
                        return rectangles as Object;
                    }
                    onDone: function(result) {
                        // I am pretty sure this is bad gumbo...
                        var r = result as ObjectArraySequence;
                        asyncCreatedRects = r.getSlice(0, r.size()) as Rectangle[];
                    }
                }
            }
            waitFor: function() {asyncCreatedRects as Object}
            expect: equalTo(rectangles)
        }
        Test {
            var initialFalse = false;
            say: "should block"
            do: function() {
                Timeline {
                    keyFrames: at (1s) {initialFalse => true}
                }.play();
                return null;
            }
            waitFor: function() {initialFalse}
            test: [
                Test {
                    say: "subtests"
                    do: function() {initialFalse}
                    expect: equalTo(true)
                }
            ]
        }
    ]);
}
