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


import javafx.ext.swing.SwingButton;
import javafx.ext.swing.SwingComponent;
import javafx.scene.text.Text;
import javafx.stage.Stage;
import org.jfxtras.scene.XScene;
import org.jfxtras.scene.layout.XMigLayout.*;

import javafx.ext.swing.SwingList;
import javafx.ext.swing.SwingListItem;

def fileList = SwingList {
    items: [
        SwingListItem {text: "<html><font color=#FF00FF>masthead3.gif</font></html>"}
        SwingListItem {text: "RealSwingList.jpg"}
        SwingListItem {text: "yellow.gif"}
    ]
}
def duplicateList = SwingList {
    items: [
        SwingListItem {text: "D:\\My Documents\\Beth Hamidrash\\Copy of images\\purple.gif"}
        SwingListItem {text: "D:\\My Documents\\Beth Hamidrash\\images\\purple.gif"}
    ]
}

def progressBar = SwingComponent.wrap(new javax.swing.JProgressBar());
def statusText = Text {content: "there are 89655 duplicate bytes in 8 duplicate files"}
def deleteButton = SwingButton {text: "Delete"}

/**
 * This is based on a sample provided by Eric Kolotyluk
 *
 * @author Stephen Chin
 * @author Dean Iverson
 */
Stage {
    title: "Find Duplicate Files"
    scene: XScene {
        width: 640
        height: 480
        content: XMigLayout {
            constraints: "fill"
            columns: "20[]10[]20"
            rows: "20[]10[]10[]20"
            content: [
                migNode( fileList,      "grow, push" ),
                migNode( duplicateList, "grow, push, wrap" ),
                migNode( progressBar,   "growx, span, wrap" ),
                migNode( statusText,    "growx, span, split" ),
                migNode( deleteButton,  "gapleft push" )
            ]
        }
    }
}
