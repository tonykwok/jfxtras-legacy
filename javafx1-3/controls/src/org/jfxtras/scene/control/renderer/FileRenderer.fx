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

package org.jfxtras.scene.control.renderer;

import java.io.File;
import javafx.geometry.HPos;
import javafx.geometry.VPos;
import javafx.scene.Group;
import javafx.scene.Node;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;
import javafx.scene.layout.Container;
import javafx.scene.layout.LayoutInfo;
import javafx.scene.layout.Panel;
import javafx.scene.paint.Paint;
import javafx.scene.text.Font;
import org.jfxtras.lang.XBind;

/**
 * @author jimclarke
 */
// TODO add File icons and directory icon.
def folderImage = Image { url: "{__DIR__}folder.png" };
public class FileRenderer extends CachingNodeRenderer {
    public var font:Font;
    public var fill:Paint;
    public var selectedFont:Font;
    public var selectedFill:Paint;
    public var spacing = 5.0;

    override function createNode():Node {
        var panel: Panel =
        Panel {
            onLayout: function() {
                var xx = 0.0;
                for(n in Container.getManaged(panel.content)) {
                    if(n.visible) {
                         Container.layoutNode(n, xx, 0, Container.getNodePrefWidth(n), Container.getNodePrefHeight(n),
                            HPos.LEFT, VPos.CENTER);
                         xx += n.layoutBounds.width + spacing;
                    }
                }

            }

            content: [
                 ImageView {
                     layoutInfo: LayoutInfo {
                         vpos: VPos.CENTER
                     }
                 }
                 SelectableText {
                    defaultFill: fill
                    defaultFont: font
                    selectedFill: selectedFill
                    selectedFont: selectedFont
                }
            ]
        }
    }

    override function populateNode(node:Node, data:XBind, index:Integer, width:Number, height:Number):Void {
        def group = node as Group;
        var file = data.ref as File;
        var imageView = group.content[0] as ImageView;
        var text = group.content[1] as SelectableText;
        text.content = file.getCanonicalFile().getName();
        if(file.isDirectory()) {
            imageView.visible = true;
            imageView.image =  folderImage;
            imageView.fitHeight = height;
            imageView.fitWidth = height;
        }else {
            imageView.visible = false;
            imageView.image = null;
        }

    }

}
