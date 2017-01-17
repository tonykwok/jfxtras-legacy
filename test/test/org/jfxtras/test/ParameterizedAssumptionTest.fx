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

import org.jfxtras.test.Expect.*;
import javafx.util.Math.*;

/**
 * @author Dean Iverson
 * @author Stephen Chin
 */
public class ParameterizedAssumptionTest extends Test {}

public function run() {
    Test {
        say: "should be able to multiply"
        var testKeys = function(i) {
            function() {
                var result = i * 1.5;
                if (floor(result) == result) {
                    "{result as Integer}"
                } else {
                    "{result}"
                }
            }
        }
        test: [
            for (i in [0..9]) {
                Test {
                    assume: that(i*1.5, closeTo(floor(i*1.5)))
                    say: "{i} x 1.5 without a decimal"
                    do: testKeys(i)
                    expect: equalTo("{(i*1.5) as Integer}")
                }
            }
            for (i in [0..9]) {
                Test {
                    assume: that(i*1.5, isNot(closeTo(floor(i*1.5))))
                    say: "{i} x 1.5 with a decimal"
                    do: testKeys(i)
                    expect: equalTo("{i*1.5}")
                }
            }
        ]
    }.perform();
}