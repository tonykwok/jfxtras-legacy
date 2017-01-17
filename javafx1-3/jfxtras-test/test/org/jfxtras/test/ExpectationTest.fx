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

package org.jfxtras.test;

import org.jfxtras.lang.*;
import org.jfxtras.test.Expect.*;

/**
 * @author Stephen Chin
 */
public class ExpectationTest extends Test {}

public function run() {
    perform("You can expect", [
        Test {
            say: "anything"
            expect: anything()
        }
        Test {
            say: "equal to"
            do: function() {5}
            expect: equalTo(5)
        },
        Test {
            say: "equal to with different types"
            do: function() {5 as Long}
            expect: equalTo(5)
        },
        Test {
            say: "equal to (fail)"
            do: function() {1}
            expect: equalTo(2)
            expectException: ExpectationException {}.getJFXClass()
        },
        Test {
            say: "equal to (null)"
            do: function() {null}
            expect: equalTo(null)
        },
        Test {
            say: "is equal to"
            do: function() {"boat"}
            expect: is(equalTo("boat"))
        },
        Test {
            say: "is"
            do: function() {5}
            expect: is(5)
        },
        Test {
            say: "is (null)"
            do: function() {null}
            expect: is(null)
        },
        Test {
            say: "is (fail)"
            do: function() {1}
            expect: is(2)
            expectException: ExpectationException {}.getJFXClass()
        },
        Test {
            say: "is not equal to"
            do: function() {"boats"}
            expect: isNot(equalTo("boat"))
        },
        Test {
            say: "is not"
            do: function() {1}
            expect: isNot(2)
        },
        Test {
            say: "is not (fail)"
            do: function() {5}
            expect: isNot(5)
            expectException: ExpectationException {}.getJFXClass()
        },
        Test {
            say: "is not (null)"
            do: function() {null}
            expect: isNot(null)
            expectException: ExpectationException {}.getJFXClass()
        },
        Test {
            say: "type is"
            do: function() {ExpectationException {}}
            expect: typeIs(ExpectationException {}.getJFXClass())
        },
        Test {
            say: "type is"
            do: function() {ExpectationException {}}
            expect: typeIs("org.jfxtras.test.ExpectationException")
        },
        Test {
            say: "type is (fail)"
            do: function() {ExpectationException {}}
            expect: typeIs(XException {}.getJFXClass())
            expectException: "org.jfxtras.test.ExpectationException"
        },
        Test {
            say: "type instance of"
            do: function() {ExpectationException {}}
            expect: instanceOf(XException {}.getJFXClass())
        }
    ]);
}