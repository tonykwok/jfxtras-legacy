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

/**
 * @author Stephen Chin
 */
public class SequenceTest extends Test {}

public function run() {
    perform("JavaFX Sequence", [
        Test {
            say: "creation should support"
            test: [
                Test {
                    say: "ranges"
                    do: function():Object {
                        [1..3]
                    }
                    expect: equalTo([1, 2, 3])
                }
                Test {
                    say: "steps"
                    do: function():Object {
                        [1..5 step 2]
                    }
                    expect: equalTo([1, 3, 5])
                }
                Test {
                    say: "negative steps"
                    do: function():Object {
                        [5..1 step -2]
                    }
                    expect: equalTo([5, 3, 1])
                }
                Test {
                    say: "exclusive ends"
                    do: function():Object {
                        [1..<4]
                    }
                    expect: equalTo([1, 2, 3])
                }
            ]
        }
        Test {
            say: "slices should allow"
            var seq = [1, 3, 5, 7, 9];
            test: [
                Test {
                    say: "ranges"
                    do: function():Object {
                        seq[0..2]
                    }
                    expect: equalTo([1, 3, 5])
                }
                Test {
                    say: "exclusive ends"
                    do: function():Object {
                        seq[0..<2]
                    }
                    expect: equalTo([1, 3])
                }
                Test {
                    say: "open ends"
                    do: function():Object {
                        seq[2..]
                    }
                    expect: equalTo([5, 7, 9])
                }
                Test {
                    say: "open exclusive ends"
                    do: function():Object {
                        seq[2..<]
                    }
                    expect: equalTo([5, 7])
                }
            ]
        }
        Test {
            say: "subsets should allow"
            var seq = [1, 3, 5, 7, 9];
            test: [
                Test {
                    say: "greater than"
                    do: function():Object {
                        seq[k | k > 6]
                    }
                    expect: equalTo([7, 9])
                }
                Test {
                    say: "index of"
                    do: function():Object {
                        seq[k | indexof k < 2]
                    }
                    expect: equalTo([1, 3])
                }
                Test {
                    say: "empty set"
                    do: function():Object {
                        seq[k | k > 10]
                    }
                    expect: equalTo([])
                }
            ]
        }
    ]);
}
