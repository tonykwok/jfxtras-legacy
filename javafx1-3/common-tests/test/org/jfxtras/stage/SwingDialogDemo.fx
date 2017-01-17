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
package org.jfxtras.stage;

import javafx.ext.swing.SwingButton;
import javafx.ext.swing.SwingLabel;
import javafx.ext.swing.SwingList;
import javafx.ext.swing.SwingListItem;
import javafx.ext.swing.SwingTextField;
import javafx.scene.Scene;
import javafx.scene.image.Image;
import javafx.scene.layout.HBox;
import java.lang.String;
import org.jfxtras.scene.layout.XGrid;
import org.jfxtras.scene.layout.XGridLayoutInfo;
import org.jfxtras.scene.layout.XGridLayoutInfo.*;

import javafx.scene.control.Button;

/**
 * @author Stephen Chin
 * @author Keith Combs
 */
var widgetList = SwingList {
    items: for (i in [0..20]) {
        SwingListItem {
            text: "This is row number {i}"
        }
    }
    layoutInfo: XGridLayoutInfo {hspan: 2, height: 200}
}
var myDialog : XDialog;
var listLabel = SwingLabel {text: "Recent Widgets:", labelFor: widgetList}
var jarField = SwingTextField {columns: 30};
var jarLabel = SwingLabel {text: "Widget URL:", labelFor: jarField};
var browseButton:SwingButton = SwingButton {
    text: "Browse...";
    action: function() {
        println("browse pressed");
    }
}

function showDialog():Void {
     myDialog = XDialog {
        title: "Add Widget"
        resizable: false
        icons: Image {
            url: "{__DIR__}images/WidgetFXIcon16.png"
        }
        scene: Scene {
            var grid:XGrid;
            content: grid = XGrid {
                // todo - fix this: growRows: [1]
                var box:HBox;
                rows: [
                    row([XGrid {
                        // todo - set margins to 0
                        // todo - fix this: growRows: [1]
                        rows: [
                            row([listLabel, widgetList]),
                            row([jarLabel, jarField, browseButton])
                        ]
                    }]),
                    row([box = HBox {
                        translateX: bind grid.getPrefWidth(-1) - box.boundsInLocal.width // todo need a way to get margins ( - grid.border * 2)
                        content: [
                            SwingButton {text: "Add", action: function() {println("add pressed")}},
                            SwingButton {text: "Cancel", action: function() {myDialog.close()}}
                        ]
                    }])
                ]
            }
        }
        onClose:function(){
            println("on close()")
        }

    }
}

Button {
    text: "Show Dialog..."
    action: function(){showDialog()};
}
