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

import javafx.stage.*;
import javafx.scene.control.Label;
import javafx.scene.control.ListView;
import org.jfxtras.scene.*;
import org.jfxtras.scene.layout.XGridLayoutInfo.*;
import javafx.scene.control.ProgressBar;
import javafx.scene.control.Button;
import javafx.scene.layout.LayoutInfo;
import javafx.scene.layout.Priority;

def fileList = ListView {
    items: [
        "ACF6BAB.jpg",
        "yello.gif",
        for (i in [4..30]) {
            "Item Number {i}"
        }
    ]
    layoutInfo: LayoutInfo {hgrow: Priority.SOMETIMES}
}
def duplicateList = ListView {
    items: [
        "D:\\My Documents\\Beth Hamidrash\\Copy of images\\purple.gif",
        "D:\\My Documents\\Beth Hamidrash\\images\\purple.gif"
    ]
}
def progressBar = ProgressBar {}
progressBar.layoutInfo = XGridLayoutInfo {hspan: 2, hfill: true}
def statusText = Label {text: "there are 89655 duplicate bytes in 8 duplicate files"
                       layoutInfo: XGridLayoutInfo {hgrow: ALWAYS}}
def deleteButton = Button {text: "Delete"}

/**
 * This is based on a sample provided by Eric Kolotyluk
 *
 * @author Stephen Chin
 */
var innerGrid:XGrid;
Stage {
    title: "Find Duplicate Files"
    scene: XScene {
        padding: insets(15)
        width: 640
        height: 480
        content: XGrid {
            rows: [
                row([fileList, duplicateList]),
                row(progressBar),
                row(innerGrid = XGrid {
                    rows: row([statusText, deleteButton])
                    layoutInfo: XGridLayoutInfo {hspan: 2}
                })
            ]
        }
    }
}
