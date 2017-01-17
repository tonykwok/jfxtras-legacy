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
package org.jfxtras.scene.control.data;

import org.jfxtras.test.Expect.*;
import org.jfxtras.test.Test;
import org.jfxtras.util.XMap;
import org.jfxtras.util.XMap.*;

/**
 * @author Stephen Chin
 */
public class SequenceDataRowTest extends Test {}

public function run() {
    perform("A SequenceDataRow should", [
        Test {
            say: "update when the sequence changes"
            do: function() {
                var data = [1, 2, 3];
                def sdr = SequenceDataRow {data: bind data}
                def boundData = sdr.getData();
                data[2] = 4;
                boundData[2].ref;
            }
            expect: equalTo(4);
        }
        Test {
            say: "write the changed value back to the sequence"
            do: function() {
                var data:Object[] = [1, 2, 3];
                def sdr = SequenceDataRow {data: bind data with inverse}
                def boundData = sdr.getData();
                boundData[2].ref = 4;
                data[2];
            }
            expect: equalTo(4);
        }
    ]);
}
