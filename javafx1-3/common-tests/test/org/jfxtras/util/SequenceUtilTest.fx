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
 * @author Keith Combs
 */
public class SequenceUtilTest extends Test {}

public function run() {
    perform("Sequence Utils", [
        Test {
            say: "should add numbers"
            do: function() {
                SequenceUtil.sum([10.4, 20.3]);
            }
            expect: closeTo(30.7)
        },
        Test {
            say: "should add integers"
            do: function() {
                SequenceUtil.sum([5, 6, 9]);
            }
            expect: equalTo(20)
        },
        Test {
            say: "should multiply numbers"
            do: function() {
                SequenceUtil.product([10.4, 20.3]);
            }
            expect: closeTo(211.11998)
        },
        Test {
            say: "should multiply integers"
            do: function() {
                SequenceUtil.product([5, 6, 9]);
            }
            expect: equalTo(270)
        },
        Test {
            say: "should average numbers"
            do: function() {
                SequenceUtil.avg([10.4, 20.3]);
            }
            expect: closeTo(15.349999)
        },
        Test {
            say: "should average integers (with a nice cast)"
            do: function() {
                SequenceUtil.avg([5, 6, 9] as Number[]);
            }
            expect: closeTo(6.6666665)
        },
        Test {
            say: "should return false if the sequence is empty for 'any'"
            do: function() {
                SequenceUtil.any([]);
            }
            expect: equalTo(false)
        },
        Test {
            say: "should return true if any value is true for 'any'"
            do: function() {
                SequenceUtil.any([false, true, false]);
            }
            expect: equalTo(true)
        },
        Test {
            say: "should return false if all values are false for 'any'"
            do: function() {
                SequenceUtil.any([false, false, false]);
            }
            expect: equalTo(false)
        },
        Test {
            say: "should return true if the sequence is empty for 'all'"
            do: function() {
                SequenceUtil.all([]);
            }
            expect: equalTo(true)
        },
        Test {
            say: "should return false if any values is false for 'all'"
            do: function() {
                SequenceUtil.all([true, false, true]);
            }
            expect: equalTo(false)
        },
        Test {
            say: "should return true if all values are true for 'all'"
            do: function() {
                SequenceUtil.all([true, true, true]);
            }
            expect: equalTo(true)
        },
        Test {
            say: "should concatenate Strings"
            do: function() {
                SequenceUtil.concat(["red", "fire", "truck"]);
            }
            expect: equalTo("redfiretruck")
        },
        Test {
            say: "should join Strings with delimiters"
            do: function() {
                SequenceUtil.join(["red", "fire", "truck"], "|");
            }
            expect: equalTo("red|fire|truck")
        },
        Test {
            say: "should join Strings with delimiters (empty)"
            do: function() {
                SequenceUtil.join([], "|");
            }
            expect: equalTo("")
        },
        Test {
            say: "should return the input string when joining a 1 element sequence"
            do: function() {
                SequenceUtil.join(["justme"], "|");
            }
            expect: equalTo("justme")
        },
        Test {
            say: "should produce a one-character sequence given equivalent arguments"
            do: function() {
                SequenceUtil.characterSequence("a", "a") as Object;
            }
            expect: equalTo(["a"])
        },
        Test {
            say: "should produce an ascending character sequence"
            do: function() {
                SequenceUtil.characterSequence("a", "c") as Object;
            }
            expect: equalTo(["a", "b", "c"])
        },
        Test {
            say: "should produce an decending character sequence"
            do: function() {
                SequenceUtil.characterSequence("f", "d") as Object;
            }
            expect: equalTo(["f", "e", "d"])
        },
        Test {
            say: "should produce one-character sequences even if given multi-character strings"
            do: function() {
                SequenceUtil.characterSequence("apple", "cowboy") as Object;
            }
            expect: equalTo(["a", "b", "c"])
        }
        Test {
            say: "should produce a sequence of digits as strings"
            do: function() {
                SequenceUtil.characterSequence("0", "9") as Object;
            }
            expect: equalTo(["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"])
        }
        Test {
            say: "Stable Update should"
            var original = ["a", "b", "c"];
            var backwards = ["c", "b", "a"];
            var extra = ["a", "b", "c", "d"];
            var extraBackwards = ["d", "c", "b", "a"];
            var missing = ["a", "b"];
            var missingBackwards = ["b", "a"];
            var both = ["a", "b", "d"];
            var duplicates = ["a", "b", "c", "d", "d"];
            test: [
                Test {
                    say: "not affect identical sequences"
                    do: function() {
                        SequenceUtil.stableUpdate(original, original) as Object;
                    }
                    expect: equalTo(original)
                }
                Test {
                    say: "not be affected by order"
                    do: function() {
                        SequenceUtil.stableUpdate(original, backwards) as Object;
                    }
                    expect: equalTo(original)
                }
                Test {
                    say: "add extra elements"
                    do: function() {
                        SequenceUtil.stableUpdate(original, extra) as Object;
                    }
                    expect: equalTo(extra)
                }
                Test {
                    say: "add extra elements to the end"
                    do: function() {
                        SequenceUtil.stableUpdate(original, extraBackwards) as Object;
                    }
                    expect: equalTo(extra)
                }
                Test {
                    say: "remove elements"
                    do: function() {
                        SequenceUtil.stableUpdate(original, missing) as Object;
                    }
                    expect: equalTo(missing)
                }
                Test {
                    say: "remove elements preserving order"
                    do: function() {
                        SequenceUtil.stableUpdate(original, missingBackwards) as Object;
                    }
                    expect: equalTo(missing)
                }
                Test {
                    say: "add and remove elements together"
                    do: function() {
                        SequenceUtil.stableUpdate(original, both) as Object;
                    }
                    expect: equalTo(both)
                }
                Test {
                    say: "keep duplicates in original"
                    do: function() {
                        SequenceUtil.stableUpdate(duplicates, extra) as Object;
                    }
                    expect: equalTo(duplicates)
                }
                Test {
                    say: "keep duplicates in updated"
                    do: function() {
                        SequenceUtil.stableUpdate(original, duplicates) as Object;
                    }
                    expect: equalTo(duplicates)
                }
            ]
        }
        Test {
            say: "Update Window"
            var seq:Object[];
            do: function() {
                seq = for (i in [0..10]) {i}
                return null;
            }
            var removeFunction = function(o, i:Integer):Void {
                seq[i] = 'r';
            }
            var addFunction = function(o, i:Integer):Void {
                seq[i] = 'a';
            }
            test: [
                Test {
                    say: "should grow"
                    do: function() {
                        SequenceUtil.updateWindow(seq, 4, 6, 2, 8, removeFunction, addFunction);
                        seq as Object
                    }
                    expect: equalTo([0, 1, 'a', 'a', 4, 5, 6, 'a', 'a', 9, 10])
                }
                Test {
                    say: "should shrink"
                    do: function() {
                        SequenceUtil.updateWindow(seq, 2, 8, 4, 6, removeFunction, addFunction);
                        seq as Object
                    }
                    expect: equalTo([0, 1, 'r', 'r', 4, 5, 6, 'r', 'r', 9, 10])
                }
                Test {
                    say: "should translate right (w/overlap)"
                    do: function() {
                        SequenceUtil.updateWindow(seq, 2, 6, 4, 8, removeFunction, addFunction);
                        seq as Object
                    }
                    expect: equalTo([0, 1, 'r', 'r', 4, 5, 6, 'a', 'a', 9, 10])
                }
                Test {
                    say: "should translate left (w/overlap)"
                    do: function() {
                        SequenceUtil.updateWindow(seq, 4, 8, 2, 6, removeFunction, addFunction);
                        seq as Object
                    }
                    expect: equalTo([0, 1, 'a', 'a', 4, 5, 6, 'r', 'r', 9, 10])
                }
                Test {
                    say: "should translate right (no overlap)"
                    do: function() {
                        SequenceUtil.updateWindow(seq, 2, 4, 7, 9, removeFunction, addFunction);
                        seq as Object
                    }
                    expect: equalTo([0, 1, 'r', 'r', 'r', 5, 6, 'a', 'a', 'a', 10])
                }
                Test {
                    say: "should translate left (no overlap)"
                    do: function() {
                        SequenceUtil.updateWindow(seq, 7, 9, 2, 4, removeFunction, addFunction);
                        seq as Object
                    }
                    expect: equalTo([0, 1, 'a', 'a', 'a', 5, 6, 'r', 'r', 'r', 10])
                }
            ]
        }
    ]);
}
