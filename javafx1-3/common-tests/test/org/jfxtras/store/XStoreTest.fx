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
package org.jfxtras.store;

import org.jfxtras.lang.XSeq;
import org.jfxtras.test.Test;
import org.jfxtras.test.Expect.*;

/**
 * @author David
 * @author Stephen Chin
 */
public class XStoreTest extends Test {}

var integerVar:Integer = 0;
var longVar:Long = 0;
var floatVar:Float = 0.0;
var doubleVar:Double = 0.0;
var boolVar:Boolean = false;
var stringVar:String = "";
var durVar:Duration = 0s;
var integerSeqVar:Integer[] = [0];
var longSeqVar:Long[] = [0];
var floatSeqVar:Float[] = [0.0];
var doubleSeqVar:Double[] = [0.0];
var boolSeqVar:Boolean[] = [false];
var stringSeqVar:String[] = [""];
var durSeqVar:Duration[] = [0s];

var integerStore = XStoreInteger {name: "integerTest", default: 1, value: bind integerVar with inverse}
var longStore = XStoreLong {name: "longTest", default: 1, value: bind longVar with inverse}
var floatStore = XStoreFloat {name: "floatTest", default: 1.1, value: bind floatVar with inverse}
var doubleStore = XStoreDouble {name: "doubleTest", default: 1.1, value: bind doubleVar with inverse}
var boolStore = XStoreBoolean {name: "boolTest", default: false, value: bind boolVar with inverse}
var stringStore = XStoreString {name: "stringTest", default: "Hello", value: bind stringVar with inverse}
var durStore = XStoreDuration {name: "durTest", default: 1s, value: bind durVar with inverse}
var integerSeqStore = XStoreIntegerSeq {name: "integerSeqTest", default: [1, 3, 5], value: bind integerSeqVar with inverse}
var longSeqStore = XStoreLongSeq {name: "longSeqTest", default: [1, 3, 5], value: bind longSeqVar with inverse}
var floatSeqStore = XStoreFloatSeq {name: "floatSeqTest", default: [1.1, 3.3, 5.5], value: bind floatSeqVar with inverse }
var doubleSeqStore = XStoreDoubleSeq {name: "doubleSeqTest", default: [1.1, 3.3, 5.5], value: bind doubleSeqVar with inverse }
var boolSeqStore = XStoreBooleanSeq {name: "boolSeqTest", default: [false, true, false], value: bind boolSeqVar with inverse }
var stringSeqStore = XStoreStringSeq {name: "stringSeqTest", default: [ "Monday","Tuesday","Wednesday" ], value: bind stringSeqVar with inverse}
var durSeqStore = XStoreDurationSeq {name: "durSeqTest", default: [ 1ms, 1s, 1m, 1h], value: bind durSeqVar with inverse}

var storeTest = XStore {
    name: "storeTest"
    content: [
        integerStore,
        longStore,
        floatStore,
        doubleStore,
        boolStore,
        stringStore,
        durStore,
        integerSeqStore,
        longSeqStore,
        floatSeqStore,
        doubleSeqStore,
        boolSeqStore,
        stringSeqStore,
        durSeqStore,
    ]
}

public function run() {
    storeTest.resetAll(); // reset everything to start tests
    perform([
// Sequence storage functions
        Test {
            def sequences = [
                XSeq {seq: ["a", "b", "c"]}
                XSeq {seq: ["include,commas", "escape\\,commas", "include\\escapes", "escape\\\\escapes"]}
            ];
            say: "Sequence storage should"
            test: for (xs in sequences) {
                Test {
                    say: "handle: {xs}"
                    do: function() {
                        def encoded = XStoreItem.generateSeqString(xs.seq, function(o) {o.toString()});
                        XStoreItem.parseSeqString(encoded, function (s) {s}) as Object;
                    }
                    expect: equalTo(xs.seq);
                }
            }
        }

// Integer singletons
        Test {
            say: "Integer -"
            test: [
                Test {
                    say: "getting default should return 1"
                    do: function() {
                        return integerStore.default;
                    }
                    expect: equalTo(1);
                }
                Test {
                    say: "getting value should return 1 as reset"
                    do: function() {
                        return integerStore.value;
                    }
                    expect: equalTo(1);
                }
                Test {
                    say: "setting bound value should give 2 from value"
                    do: function() {
                        integerVar = 2;
                        return integerStore.value;
                    }
                    expect: equalTo(2);
                }
                Test {
                    say: "resetting store item should give 1"
                    do: function() {
                        storeTest.reset("integerTest");
                        return integerStore.value;
                    }
                    expect: equalTo(1);
                }
            ]
        }

// Long singletons
        Test {
            say: "Long -"
            test: [
                Test {
                    say: "getting default should return 1"
                    do: function() {
                        return longStore.default;
                    }
                    expect: equalTo(1);
                }
                Test {
                    say: "getting value should return 1 as reset"
                    do: function() {
                        return longStore.value;
                    }
                    expect: equalTo(1);
                }
                Test {
                    say: "setting bound value should give 2 from value"
                    do: function() {
                        longVar = 2;
                        return longStore.value;
                    }
                    expect: equalTo(2);
                }
                Test {
                    say: "resetting store item should give 1"
                    do: function() {
                        storeTest.reset("longTest");
                        return longStore.value;
                    }
                    expect: equalTo(1);
                }
            ]
        }

// Float singletons
        Test {
            say: "Float -"
            test: [
                Test {
                    say: "getting default should return 1.1"
                    do: function() {
                        return floatStore.default;
                    }
                    expect: equalTo(1.1);
                }
                Test {
                    say: "getting value should return 1.1 as reset"
                    do: function() {
                        return floatStore.value;
                    }
                    expect: equalTo(1.1);
                }
                Test {
                    say: "setting bound value should give 2.2 from value"
                    do: function() {
                        floatVar = 2.2;
                        return floatStore.value;
                    }
                    expect: equalTo(2.2);
                }
                Test {
                    say: "resetting store item should give 1.1"
                    do: function() {
                        storeTest.reset("floatTest");
                        return floatStore.value;
                    }
                    expect: equalTo(1.1);
                }
            ]
        }

// Double singletons
        Test {
            say: "Double -"
            test: [
                Test {
                    say: "getting default should return 1.1"
                    do: function() {
                        return doubleStore.default;
                    }
                    expect: equalTo(1.1);
                }
                Test {
                    say: "getting value should return 1.1 as reset"
                    do: function() {
                        return doubleStore.value;
                    }
                    expect: equalTo(1.1);
                }
                Test {
                    say: "setting bound value should give 2.2 from value"
                    do: function() {
                        doubleVar = 2.2;
                        return doubleStore.value;
                    }
                    expect: equalTo(2.2);
                }
                Test {
                    say: "resetting store item should give 1.1"
                    do: function() {
                        storeTest.reset("doubleTest");
                        return doubleStore.value;
                    }
                    expect: equalTo(1.1);
                }
            ]
        }

// Boolean singletons
        Test {
            say: "Boolean -"
            test: [
                Test {
                    say: "getting default should return false"
                    do: function() {
                        return boolStore.default;
                    }
                    expect: equalTo(false);
                }
                Test {
                    say: "getting value should return false as reset"
                    do: function() {
                        return boolStore.value;
                    }
                    expect: equalTo(false);
                }
                Test {
                    say: "setting bound value should give true from value"
                    do: function() {
                        boolVar = true;
                        return boolStore.value;
                    }
                    expect: equalTo(true);
                }
                Test {
                    say: "resetting store item should give false"
                    do: function() {
                        storeTest.reset("boolTest");
                        return boolStore.value;
                    }
                    expect: equalTo(false);
                }
            ]
        }

// String singletons
        Test {
            say: "String -"
            test: [
                Test {
                    say: "getting default should return 'Hello'"
                    do: function() {
                        return stringStore.default;
                    }
                    expect: equalTo("Hello");
                }
                Test {
                    say: "getting value should return 'Hello' as reset"
                    do: function() {
                        return stringStore.value;
                    }
                    expect: equalTo("Hello");
                }
                Test {
                    say: "setting bound value should give 'Goodbye' from value"
                    do: function() {
                        stringVar = "Goodbye";
                        return stringStore.value;
                    }
                    expect: equalTo("Goodbye");
                }
                Test {
                    say: "resetting store item should give 'Hello'"
                    do: function() {
                        storeTest.reset("stringTest");
                        return stringStore.value;
                    }
                    expect: equalTo("Hello");
                }
            ]
        }

// Duration singletons
        Test {
            say: "Duration -"
            test: [
                Test {
                    say: "getting default should return 1s"
                    do: function() {
                        return durStore.default;
                    }
                    expect: equalTo(1s);
                }
                Test {
                    say: "getting value should return 1s as reset"
                    do: function() {
                        return durStore.value;
                    }
                    expect: equalTo(1s);
                }
                Test {
                    say: "setting bound value should give 2s from value"
                    do: function() {
                        durVar = 2s;
                        return durStore.value;
                    }
                    expect: equalTo(2s);
                }
                Test {
                    say: "resetting store item should give 1s"
                    do: function() {
                        storeTest.reset("durTest");
                        return durStore.value;
                    }
                    expect: equalTo(1s);
                }
            ]
        }

// now the sequence stores
// Integer sequences
        Test {
            say: "Integer Sequence -"
            test: [
                Test {
                    say: "getting default should return [1, 3, 5]"
                    do: function() {
                        return integerSeqStore.default as Object;
                    }
                    expect: equalTo([1, 3, 5]);
                }
                Test {
                    say: "getting value should return [1, 3, 5] as reset"
                    do: function() {
                        return integerSeqStore.value as Object;
                    }
                    expect: equalTo([1, 3, 5]);
                }
                Test {
                    say: "setting bound value should give [2, 4, 6, 8] from value"
                    do: function() {
                        integerSeqVar = [2, 4, 6, 8];
                        return integerSeqStore.value as Object;
                    }
                    expect: equalTo([2, 4, 6, 8]);
                }
                Test {
                    say: "resetting SeqStore item should give [1, 3, 5]"
                    do: function() {
                        storeTest.reset("integerSeqTest");
                        return integerSeqStore.value as Object;
                    }
                    expect: equalTo([1, 3, 5]);
                }
            ]
        }

// Long sequences
        Test {
            say: "Long Sequence -"
            test: [
                Test {
                    say: "getting default should return [1, 3, 5]"
                    do: function() {
                        return longSeqStore.default as Object;
                    }
                    expect: equalTo([1, 3, 5] as Long[]);
                }
                Test {
                    say: "getting value should return [1, 3, 5] as reset"
                    do: function() {
                        return longSeqStore.value as Object;
                    }
                    expect: equalTo([1, 3, 5] as Long[]);
                }
                Test {
                    say: "setting bound value should give [2, 4, 6, 8] from value"
                    do: function() {
                        longSeqVar = [2, 4, 6, 8];
                        return longSeqStore.value as Object;
                    }
                    expect: equalTo([2, 4, 6, 8] as Long[]);
                }
                Test {
                    say: "resetting SeqStore item should give [1, 3, 5]"
                    do: function() {
                        storeTest.reset("longSeqTest");
                        return longSeqStore.value as Object;
                    }
                    expect: equalTo([1, 3, 5] as Long[]);
                }
            ]
        }

// Float Sequences
        Test {
            say: "Float Sequence -"
            test: [
                Test {
                    say: "getting default should return [1.1, 3.3, 5.5]"
                    do: function() {
                        return floatSeqStore.default as Object;
                    }
                    expect: equalTo([1.1, 3.3, 5.5]);
                }
                Test {
                    say: "getting value should return [1.1, 3.3, 5.5] as reset"
                    do: function() {
                        return floatSeqStore.value as Object;
                    }
                    expect: equalTo([1.1, 3.3, 5.5]);
                }
                Test {
                    say: "setting bound value should give [2.2, 4.4, 6.6, 8.8] from value"
                    do: function() {
                        floatSeqVar = [2.2, 4.4, 6.6, 8.8];
                        return floatSeqStore.value as Object;
                    }
                    expect: equalTo([2.2, 4.4, 6.6, 8.8]);
                }
                Test {
                    say: "resetting SeqStore item should give [1.1, 3.3, 5.5]"
                    do: function() {
                        storeTest.reset("floatSeqTest");
                        return floatSeqStore.value as Object;
                    }
                    expect: equalTo([1.1, 3.3, 5.5]);
                }
            ]
        }

// Double Sequences
        Test {
            say: "Double Sequence -"
            test: [
                Test {
                    say: "getting default should return [1.1, 3.3, 5.5]"
                    do: function() {
                        return doubleSeqStore.default as Object;
                    }
                    var dResult:Double[] = [1.1, 3.3, 5.5]; // typed variable needed to avoid Float precision errors
                    expect: equalTo(dResult);
                }
                Test {
                    say: "getting value should return [1.1, 3.3, 5.5] as reset"
                    do: function() {
                        return doubleSeqStore.value as Object;
                    }
                    var dResult:Double[] = [1.1, 3.3, 5.5]; // typed variable needed to avoid Float precision errors
                    expect: equalTo(dResult);
                }
                Test {
                    say: "setting bound value should give [2.2, 4.4, 6.6, 8.8] from value"
                    do: function() {
                        doubleSeqVar = [2.2, 4.4, 6.6, 8.8];
                        return doubleSeqStore.value as Object;
                    }
                    var dResult:Double[] = [2.2, 4.4, 6.6, 8.8]; // typed variable needed to avoid Float precision errors
                    expect: equalTo(dResult);
                }
                Test {
                    say: "resetting SeqStore item should give [1.1, 3.3, 5.5]"
                    do: function() {
                        storeTest.reset("doubleSeqTest");
                        return doubleSeqStore.value as Object;
                    }
                    var dResult:Double[] = [1.1, 3.3, 5.5]; // typed variable needed to avoid Float precision errors
                    expect: equalTo(dResult);
                }
            ]
        }

// Boolean Sequences
        Test {
            say: "Boolean Sequence -"
            test: [
                Test {
                    say: "getting default should return [false, true, false]"
                    do: function() {
                        return boolSeqStore.default as Object;
                    }
                    expect: equalTo([false, true, false]);
                }
                Test {
                    say: "getting value should return [false, true, false] as reset"
                    do: function() {
                        return boolSeqStore.value as Object;
                    }
                    expect: equalTo([false, true, false]);
                }
                Test {
                    say: "setting bound value should give [true, true, false, true, false] from value"
                    do: function() {
                        boolSeqVar = [true, true, false, true, false];
                        return boolSeqStore.value as Object;
                    }
                    expect: equalTo([true, true, false, true, false]);
                }
                Test {
                    say: "resetting SeqStore item should give [false, true, false]"
                    do: function() {
                        storeTest.reset("boolSeqTest");
                        return boolSeqStore.value as Object;
                    }
                    expect: equalTo([false, true, false]);
                }
            ]
        }

// String Sequences
        Test {
            say: "String Sequence -"
            test: [
                Test {
                    say: "getting default should return [\"Monday\", \"Tuesday\", \"Wednesday\"]"
                    do: function() {
                        return stringSeqStore.default as Object;
                    }
                    expect: equalTo(["Monday", "Tuesday", "Wednesday"]);
                }
                Test {
                    say: "getting value should return [\"Monday\", \"Tuesday\", \"Wednesday\"] as reset"
                    do: function() {
                        return stringSeqStore.value as Object;
                    }
                    expect: equalTo(["Monday", "Tuesday", "Wednesday"]);
                }
                Test {
                    say: "setting bound value should give [\"Thursday\", \"Friday\", \"Saturday\", \"Sunday\"] from value"
                    do: function() {
                        stringSeqVar = ["Thursday", "Friday", "Saturday", "Sunday"];
                        return stringSeqStore.value as Object;
                    }
                    expect: equalTo(["Thursday", "Friday", "Saturday", "Sunday"]);
                }
                Test {
                    say: "resetting SeqStore item should give [\"Monday\", \"Tuesday\", \"Wednesday\"]"
                    do: function() {
                        storeTest.reset("stringSeqTest");
                        return stringSeqStore.value as Object;
                    }
                    expect: equalTo(["Monday", "Tuesday", "Wednesday"]);
                }
            ]
        }

// Duration Sequences
        Test {
            say: "Duration Sequence -"
            test: [
                Test {
                    say: "getting default should return [1ms, 1s, 1m, 1h]"
                    do: function() {
                        return durSeqStore.default as Object;
                    }
                    expect: equalTo([1ms, 1s, 1m, 1h]);
                }
                Test {
                    say: "getting value should return [1ms, 1s, 1m, 1h] as reset"
                    do: function() {
                        return durSeqStore.value as Object;
                    }
                    expect: equalTo([1ms, 1s, 1m, 1h]);
                }
                Test {
                    say: "setting bound value should give [2ms, 2.2s, 2.2m, 2.2h] from value"
                    do: function() {
                        durSeqVar = [2ms, 2.2s, 2.2m, 2.2h];
                        return durSeqStore.value as Object;
                    }
                    expect: equalTo([2ms, 2.2s, 2.2m, 2.2h]);
                }
                Test {
                    say: "resetting SeqStore item should give [1ms, 1s, 1m, 1h]"
                    do: function() {
                        storeTest.reset("durSeqTest");
                        return durSeqStore.value as Object;
                    }
                    expect: equalTo([1ms, 1s, 1m, 1h]);
                }
            ]
        }
    ]);
}
