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

package org.jfxtras.async;

import org.jfxtras.test.Test;
import org.jfxtras.test.Expect.*;
import org.jfxtras.test.ExpectationException;

/**
 * @author Stephen Chin
 */
public class XEDTTest extends Test {}

public function run() {
    perform("XEDT", [
        Test {
            say: "now"
            test: [
                Test {
                    say: "should execute void"
                    do: function() {
                        var result;
                        XEDT.now(function():Void {
                            result = "success";
                        });
                        result
                    }
                    expect: equalTo("success")
                }
                Test {
                    say: "should execute void with exception"
                    do: function() {
                        XEDT.now(function():Void {
                            throw ExpectationException {}
                        });
                        null
                    }
                    expectException: ExpectationException {}.getJFXClass()
                }
                Test {
                    say: "should execute Object"
                    do: function() {
                        XEDT.now(function():Object {
                            "success";
                        })
                    }
                    expect: equalTo("success")
                }
                Test {
                    say: "should execute Object with exception"
                    do: function() {
                        XEDT.now(function():Object {
                            throw ExpectationException {}
                        })
                    }
                    expectException: ExpectationException {}.getJFXClass()
                }
                Test {
                    say: "should execute Object[]"
                    do: function() {
                        var obj:Object[] = XEDT.now(function():Object[] {
                            ["one", "two", "three"];
                        });
                        obj as Object
                    }
                    expect: equalTo(["one", "two", "three"])
                }
                Test {
                    say: "should execute Object[] with exception"
                    do: function() {
                        XEDT.now(function():Object[] {
                            throw ExpectationException {}
                        });
                        null
                    }
                    expectException: ExpectationException {}.getJFXClass()
                }
            ]
        }
        Test {
            say: "later"
            test: [
                Test {
                    var result;
                    say: "should execute void"
                    do: function() {
                        XEDT.later(function():Void {
                            result = "success";
                        });
                        null
                    }
                    waitFor: function() {result}
                    expect: equalTo("success")
                }
                Test {
                    var result:DeferredObject;
                    say: "should execute Object"
                    do: function() {
                        result = XEDT.later(function() {
                            "success";
                        })
                    }
                    waitFor: function() {result.get()}
                    expect: equalTo("success")
                }
                Test {
                    var result:DeferredObject;
                    say: "should execute Object with exception"
                    do: function() {
                        result = XEDT.later(function():Object {
                            throw ExpectationException {}
                        })
                    }
                    waitFor: function() {result.get()}
                    expectException: ExpectationException {}.getJFXClass()
                }
                Test {
                    var result:DeferredSequence;
                    say: "should execute Object[]"
                    do: function() {
                        result = XEDT.later(function() {
                            ["one", "two", "three"];
                        });
                        null
                    }
                    waitFor: function() {result.get() as Object}
                    expect: equalTo(["one", "two", "three"])
                }
                Test {
                    var result:DeferredSequence;
                    say: "should execute Object[] with exception"
                    do: function() {
                        result = XEDT.later(function():Object[] {
                            throw ExpectationException {}
                        });
                        null
                    }
                    waitFor: function() {result.get() as Object}
                    expectException: ExpectationException {}.getJFXClass()
                }
            ]
        }
        Test {
            say: "outside"
            test: [
                Test {
                    var result;
                    say: "should execute void"
                    do: function() {
                        XEDT.outside(function():Void {
                            result = "success";
                        });
                        null
                    }
                    waitFor: function() {result}
                    expect: equalTo("success")
                }
                Test {
                    var result:DeferredObject;
                    say: "should execute Object"
                    do: function() {
                        result = XEDT.outside(function() {
                            "success";
                        })
                    }
                    waitFor: function() {result.get()}
                    expect: equalTo("success")
                }
                Test {
                    var result:DeferredObject;
                    say: "should execute Object with exception"
                    do: function() {
                        result = XEDT.outside(function():Object {
                            throw ExpectationException {}
                        })
                    }
                    waitFor: function() {result.get()}
                    expectException: ExpectationException {}.getJFXClass()
                }
                Test {
                    var result:DeferredSequence;
                    say: "should execute Object[]"
                    do: function() {
                        result = XEDT.outside(function() {
                            ["one", "two", "three"];
                        });
                        null
                    }
                    waitFor: function() {result.get() as Object}
                    expect: equalTo(["one", "two", "three"])
                }
                Test {
                    var result:DeferredSequence;
                    say: "should execute Object[] with exception"
                    do: function() {
                        result = XEDT.outside(function():Object[] {
                            throw ExpectationException {}
                        });
                        null
                    }
                    waitFor: function() {result.get() as Object}
                    expectException: ExpectationException {}.getJFXClass()
                }
            ]
        }
    ]);
}
