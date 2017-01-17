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

import javafx.reflect.FXLocal;
import org.jfxtras.test.Test;
import org.jfxtras.test.Expect.*;

/**
 * @author Stephen Chin
 * @author Keith Combs
 */
public class XBindTest extends Test {}

def context = FXLocal.getContext();

class ReflectionTarget {
    public var fieldA:String;
    public var fieldB:String;
}

class SupportsBind {
    var bindable:XBind
}

public function run() {
    perform("XBind should", [
        Test {
            say: "be bindable after initialization"
            do: function() {
                def supportsBind = SupportsBind {}
                var something = 10;
                supportsBind.bindable = XBind {ref: bind something}
                something = 20;
                supportsBind.bindable.ref
            }
            expect: equalTo(20)
        }
        Test {
            say: "call on replace after invocation"
            do: function() {
                def supportsBind = SupportsBind {}
                var something = 10;
                var result;
                supportsBind.bindable = XBind {ref: bind something, listeners: function(o, n):Void {result = n}}
                something = 20;
                result;
            }
            expect: equalTo(20)
        }
        Test {
            say: "bind to a field"
            do: function() {
                def reflectionTarget = ReflectionTarget {fieldA: "A"}
                def mirror = context.mirrorOf(reflectionTarget);
                def xbind = XBind.bindTo(mirror, mirror.getType().getVariable("fieldA"));
                reflectionTarget.fieldA = "B";
                xbind.ref;
            }
            expect: equalTo("B")
        }
        Test {
            say: "bijective bind to a field backwards"
            do: function() {
                def reflectionTarget = ReflectionTarget {fieldA: "A"}
                def mirror = context.mirrorOf(reflectionTarget);
                def xbind = XBind.bindWithInverse(mirror, mirror.getType().getVariable("fieldA"));
                xbind.ref = "B";
                reflectionTarget.fieldA;
            }
            expect: equalTo("B")
        }
        Test {
            say: "bijective bind to a field forwards (after assignment)"
            do: function() {
                def reflectionTarget = ReflectionTarget {fieldA: "A"}
                def mirror = context.mirrorOf(reflectionTarget);
                def xbind = XBind.bindWithInverse(mirror, mirror.getType().getVariable("fieldA"));
                xbind.ref = "B";
                reflectionTarget.fieldA = "C";
                xbind.ref;
            }
            expect: equalTo("C")
        }
    ]);
}
