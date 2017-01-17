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
package org.jfxtras.scene.layout;

import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.stage.Stage;
import org.jfxtras.scene.layout.XGridRow;
import org.jfxtras.scene.layout.XGrid;
import org.jfxtras.scene.layout.XGridLayoutInfo;

/**
 * @author Amy Fowler
 */
def s = Stage {
   title: "XGrid"
   scene: Scene {
       content: [
            XGrid {
                id: "debug"
               rows: [
                   XGridRow { cells: [
                       Button { text: "labrador" }
                       Button { text: "poodle"}
                       Button { text: "boxer" }
                   ] }
                   XGridRow { cells: [
                       Button { text: "labrador-2" layoutInfo: XGridLayoutInfo { hspan: 2 hfill: true} }
                       Button { text: "poodle-2"}
                       Button { text: "boxer-2" }
                   ] }
                   XGridRow { cells: [
                       Button { text: "labrador-3" layoutInfo: XGridLayoutInfo { vspan: 2 vfill: true} }
                       Button { text: "poodle-3"}
                       Button { text: "boxer-3" }
                   ] }
                   XGridRow { cells: [
                       Button { text: "labrador-4" layoutInfo: XGridLayoutInfo { vspan: 2 hspan: 2 hfill: true vfill: true} }
                       Button { text: "poodle-4"}
                       Button { text: "boxer-4" }
                   ] }
                   XGridRow { cells: [
                       Button { text: "labrador-5" }
                       Button { text: "poodle-5"}
                       Button { text: "boxer-5" }
                   ] }
               ]
           }
       ]
   }
}
