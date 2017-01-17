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

import org.jfxtras.test.*;
import org.jfxtras.test.Expect.*;

/**
 * @author Stephen Chin
 */
public class StringUtilTest extends Test {}

public function run() {
    perform("String Utils", [
        Test {
            def camelToTitleCase = function(s:String) {function() {StringUtil.camelToTitleCase(s)}}
            say: "should title case"
            test: [
                Test {
                    say: "words"
                    do: camelToTitleCase("iLikeCheese");
                    expect: equalTo("I Like Cheese")
                }
                Test {
                    say: "single letter"
                    do: camelToTitleCase("a");
                    expect: equalTo("A")
                }
                Test {
                    say: "null"
                    do: camelToTitleCase(null);
                    expect: equalTo(null)
                }
            ]
        }
        Test {
            def camelCase = function(s:String) {function() {StringUtil.camelCase(s)}}
            say: "should camel case"
            test: [
                Test {
                    say: "words"
                    do: camelCase("camel case");
                    expect: equalTo("camelCase")
                }
                Test {
                    say: "punctuation"
                    do: camelCase("camel_case:is/the stuff");
                    expect: equalTo("camelCaseIsTheStuff")
                }
                Test {
                    say: "letters"
                    do: camelCase("a");
                    expect: equalTo("a")
                }
                Test {
                    say: "null"
                    do: camelCase(null);
                    expect: equalTo(null)
                }
            ]
        }
        Test {
            def capitalize = function(s:String) {function() {StringUtil.capitalize(s)}}
            say: "should capitalize"
            test: [
                Test {
                    say: "words"
                    do: capitalize("capme")
                    expect: equalTo("Capme")
                }
                Test {
                    say: "single letters"
                    do: capitalize("a")
                    expect: equalTo("A")
                }
                Test {
                    say: "empty strings"
                    do: capitalize("")
                    expect: equalTo("")
                }
                Test {
                    say: "null strings"
                    do: capitalize(null)
                    expect: equalTo(null)
                }
            ]
        }
    ]);
}
