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
import javafx.util.Sequences;

/**
 * @author Stephen Chin
 * @author Peter Pilgrim
 */
public class TestTest extends Test {}

public function run() {
    perform("The TestTest", [
        Test {
            say: "(PP+)" // Peter Pilgrim Additions
            test: [
                Test {
                    say: "should be close to with tolerance"
                    do: function() {3.14159627}
                    expect: closeTo(3.15, 0.011)
                }
                Test {
                    say: "should not be close to with tolerance"
                    do: function() {-3.14159627}
                    expect: isNot(closeTo(3.15, 0.011))
                }
                Test {
                    say: "should be less than"
                    do: function() {1.0}
                    expect: lessThan(2.1435)
                }
                Test {
                    say: "should not be less than"
                    do: function() {2.1435}
                    expect: isNot(lessThan(2.1435))
                }
                Test {
                    say: "should not be less than"
                    do: function() {7.0}
                    expect: isNot(lessThan(2.1435))
                }
                Test {
                    say: "should be greater than"
                    do: function() {2.34}
                    expect: greaterThan(-5.5)
                }
                Test {
                    say: "should not be greater than"
                    do: function() {4.25}
                    expect: isNot(greaterThan(4.25))
                }
                Test {
                    say: "should not be greater than"
                    do: function() {0.024}
                    expect: isNot(greaterThan(3.333))
                }
                Test {
                    say: "should be less than or close to"
                    do: function() {2.1436}
                    expect: lessThanOrCloseTo(2.1435, 0.00011)
                }
                Test {
                    say: "should not be less than or close to (out of range)"
                    do: function() {2.1437}
                    expect: isNot(lessThanOrCloseTo(2.1435, 0.00011))
                }
                Test {
                    say: "should be greater than or close to"
                    do: function() {123.0999999}
                    expect: greaterThanOrCloseTo(123.10, 0.0100000)
                }
                Test {
                    say: "should not be greater than or close to (out of range)"
                    do: function() {123.025}
                    expect: isNot(greaterThanOrCloseTo(123.10, 0.00200000))
                }
                Test {
                    say: "should be less than or equal to"
                    do: function() {1.234}
                    expect: lessThanOrEqualTo(2.0)
                }
                Test {
                    say: "should be less than or equal to"
                    do: function() {2.000}
                    expect: lessThanOrEqualTo(2.0)
                }
                Test {
                    say: "should not be less than or close to (out of range)"
                    do: function() {2.1437}
                    expect: isNot(lessThanOrEqualTo(2.0))
                }
                Test {
                    say: "greater than or equals to"
                    do: function() {-4.0505}
                    expect: greaterThanOrEqualTo(-5.05)
                }
                Test {
                    say: "greater than or equals to"
                    do: function() {-5.0505}
                    expect: greaterThanOrEqualTo(-5.0505000)
                }
                Test {
                    say: "not greater than or equals to"
                    do: function() {-100.0}
                    expect: isNot(greaterThanOrEqualTo(-5.0505000))
                }
            ]
        }
        Test {
            say: "has a sequence which"
            var sequence:Integer[];
            do: function() {
                sequence = [1, 2, 3, 4];
                null;
            }
            test: [
                Test {
                    say: "should have a max"
                    do: function() {Sequences.max(sequence)}
                    expect: equalTo(4)
                }
                Test {
                    say: "should have a min"
                    do: function() {Sequences.min(sequence)}
                    expect: equalTo(1)
                }
                Test {
                    say: "expects an exception with the wrong min"
                    do: function():Void {assertThat(2, equalTo(Sequences.min(sequence)))}
                    expectException: ExpectationException {}.getJFXClass()
                }
            ]
        }
        Test {
            say: "launches a test that shouldn't run"
            do: function() {
                var callback = SimpleTestCallback {silent: true};
                Test {
                    say: "shouldn't run..."
                    assume: that(2, equalTo(1))
                    do: function():Void {throw XException{message: "Shouldn't get here!"}}
                }.execute("The nested test", callback);
                callback.results;
            }
            expect: equalTo(TestResults {skipped: 1})
        }
        Test {
            say: "launches a test that expects an exception"
            do: function() {
                var callback = SimpleTestCallback {silent: true};
                Test {
                    say: "that doesn't happen"
                    do: function() {1}
                    expect: equalTo(1)
                    expectException: ExpectationException {}.getJFXClass()
                }.execute("The nested test", callback);
                callback.results;
            }
            expect: equalTo(TestResults {failed: 1})
        }
    ]);
}
