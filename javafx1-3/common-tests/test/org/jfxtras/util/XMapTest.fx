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
package org.jfxtras.util;

import org.jfxtras.test.Expect.*;
import org.jfxtras.test.Test;

/**
 * @author Stephen Chin
 */
public class XMapTest extends Test {}

public function run() {
    Test {
        say: "Maps should"
        var map:XMap;
        do: function() {
            map = XMap {entries: XMap.Entry{key: "default", value: "value"}}
        }
        test: [
            Test {
                say: "initialize"
                do: function() {
                    map.get("default")
                }
                expect: equalTo("value")
            }
            Test {
                say: "accept elements"
                do: function() {
                    map.put("key", "something");
                }
            }
            Test {
                say: "return elements"
                do: function() {
                    map.put("key", "something");
                    map.get("key")
                }
                expect: equalTo("something")
            }
            Test {
                say: "return the last element"
                do: function() {
                    map.put("key", "something");
                    map.put("key", "something else");
                }
                expect: equalTo("something")
            }
            Test {
                say: "contain a key"
                do: function() {
                    map.put("key", "something");
                    map.containsKey("key");
                }
                expect: equalTo(true)
            }
            Test {
                say: "get should be bindable"
                do: function() {
                    var boundResult = bind map.boundGet("something");
                    map.put("something", "got it!");
                    boundResult;
                }
                expect: equalTo("got it!");
            }
            Test {
                say: "should not return something that was removed"
                do: function() {
                    map.remove("default");
                    map.get("default");
                }
                expect: equalTo(null);
            }
        ]
    }.perform();
}
