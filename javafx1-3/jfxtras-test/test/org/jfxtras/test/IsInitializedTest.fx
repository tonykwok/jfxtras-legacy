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

import org.jfxtras.test.Test;
import org.jfxtras.test.Expect.*;
import javafx.scene.image.Image;

/**
 * @author Stephen Chin
 */
public class IsInitializedTest extends Test {}

class TestClass {
    public var name:String;
}

public function run() {
    perform("is initialized", [
        Test {
            say: "should return false for uninitialized fields"
            do: function() {
                def test = TestClass {}
                isInitialized(test.name);
            }
            expect: equalTo(false)
        }
        Test {
            say: "should return true for initialized fields"
            do: function() {
                def test = TestClass {name: "test"}
                isInitialized(test.name);
            }
            expect: equalTo(true)
        }
        Test {
            say: "should throw an NPE (until JFXC-4334 is fixed)"
            do: function() {
                def test:TestClass = null;
                isInitialized(test.name);
            }
            expectException: "java.lang.NullPointerException"
        }
    ])
}
