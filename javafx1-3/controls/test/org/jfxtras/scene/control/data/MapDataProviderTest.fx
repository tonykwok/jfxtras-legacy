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

import org.jfxtras.lang.XBind;
import org.jfxtras.test.Expect.*;
import org.jfxtras.test.Test;
import org.jfxtras.util.XMap;
import org.jfxtras.util.XMap.*;

/**
 * @author Stephen Chin
 */
public class MapDataProviderTest extends Test {}

public function run() {
    def mdp = MapDataProvider {
        data: for (row in [0..3])[
            XMap {entries: for (col in [0..3]) [
                Entry {key: "column{col}", value: "cell:{row},{col}"}
            ]}
        ]
    }
    perform("A MapDataProvider should", [
        // corner cases to add:
        // missing cells
        // requesting data out of range
        Test {
            say: "return a cell"
            do: function() {
                mdp.getCell(1, "column1").ref;
            }
            expect: equalTo("cell:1,1");
        }
        Test {
            say: "return a column"
            do: function() {
                XBind.unwrap(mdp.getColumn(0, 4, "column1")) as Object;
            }
            expect: equalTo(["cell:0,1", "cell:1,1", "cell:2,1", "cell:3,1"]);
        }
        Test {
            say: "return a row"
            do: function() {
                XBind.unwrap(mdp.getRow(1, ["column1", "column2", "column3"])) as Object;
            }
            expect: equalTo(["cell:1,1", "cell:1,2", "cell:1,3"]);
        }
        Test {
            say: "allow binding"
            do: function() {
                def entry = Entry {key: "bound", value: "original"}
                def mdp = MapDataProvider {
                    data: XMap {entries: entry}
                }
                def result = bind mdp.getCell(0, "bound").ref;
                entry.value = "new";
                result;
            }
            expect: equalTo("new");
        }
        Test {
            say: "allow inverse binding"
            do: function() {
                def entry = Entry {key: "bound", value: "original"}
                def mdp = MapDataProvider {
                    data: XMap {entries: entry}
                }
                def result = bind mdp.getCell(0, "bound").ref;
                entry.value = "new";
                result;
            }
            expect: equalTo("new");
        }
    ]);
}
