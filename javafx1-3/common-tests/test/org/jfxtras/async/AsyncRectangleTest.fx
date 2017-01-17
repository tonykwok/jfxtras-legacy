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

/**
 * @author Stephen Chin
 */
import com.sun.javafx.runtime.sequence.ObjectArraySequence;
import javafx.scene.shape.Rectangle;
import org.jfxtras.async.XWorker;
import org.jfxtras.test.Test;
import org.jfxtras.test.Expect.*;

public class AsyncRectangleTest extends Test {}

public function run() {
    perform([
        Test {
            var rectangles = [Rectangle{}, Rectangle{}];
            var asyncCreatedRects: Rectangle[];
            say: "This is how you would do it with XWorker"
            do: function() {
                XWorker {
                    inBackground: function() {
                        return rectangles as Object;
                    }
                    onDone: function(result) {
                        // I am pretty sure this is bad gumbo...
                        var r = result as ObjectArraySequence;
                        asyncCreatedRects = r.getSlice(0, r.size()) as Rectangle[];
                    }
                }
            }
            waitFor: function() {asyncCreatedRects as Object}
            expect: equalTo(rectangles)
        }
        Test {
            var rectangles = [Rectangle{}, Rectangle{}];
            var asyncCreatedRects:DeferredSequence;
            say: "This is how you would do it with XEDT"
            do: function() {
                asyncCreatedRects = XEDT.outside(function():Object[] {
                    rectangles
                });
            }
            waitFor: function() {asyncCreatedRects.result as Object}
            expect: equalTo(rectangles)
        }
    ]);
}
