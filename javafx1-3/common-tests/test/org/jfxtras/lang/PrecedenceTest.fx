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
package org.jfxtras.lang;

import org.jfxtras.test.Test;
import org.jfxtras.test.Expect.*;

/**
 * Simple test to check operator precedence rules (mostly just to figure stuff out)
 *
 * @author Stephen Chin
 */
public class PrecedenceTest extends Test {}

public function run() {
    perform("Precedence of", [
        Test {
            say: "++ should be higher than *"
            do: function() {
                var foo = 6;
                ++foo * 5;
            }
            expect: equalTo(35)
        }
        Test {
            say: "sizeof should be higher than *"
            do: function() {
                var foo = 6;
                sizeof foo * 5;
            }
            expect: equalTo(5)
        }
        Test {
            say: "== should be higher than and"
            do: function() {
                false == true and false == false
            }
            expect: equalTo(false)
        }
        Test {
            say: "instanceof should be higher than and"
            do: function() {
                var test = Test{};
                true and test instanceof Test
            }
            expect: equalTo(true)
        }
        Test {
            say: "* should be higher than as"
            do: function() {
                var test = 1.2;
                5 * test as Integer;
            }
            expect: equalTo(6)
        }
        Test {
            say: "and should be higher than or"
            do: function() {
                false and true or true
            }
            expect: equalTo(true)
        }
        Test {
            say: "+= should be the same as ="
            do: function() {
                var result = 5;
                var foo = 1;
                foo = result += 6;
            }
            expect: equalTo(11)
        }
        Test {
            say: "= should be the same as +="
            do: function() {
                var result = 5;
                var foo = 1;
                foo += result = 6;
            }
            expect: equalTo(7)
        }
    ]);
}
