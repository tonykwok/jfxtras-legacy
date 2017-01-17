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
package org.jfxtras.scene.image;

import javafx.animation.KeyFrame;
import javafx.animation.Timeline;
import javafx.ext.swing.SwingList;
import javafx.ext.swing.SwingListItem;
import javafx.scene.image.Image;
import javafx.stage.Stage;
import org.jfxtras.scene.XCustomNode;
import org.jfxtras.scene.XScene;
import org.jfxtras.scene.image.XImageView;
import org.jfxtras.scene.layout.XGrid;
import org.jfxtras.scene.layout.XGridLayoutInfo.*;

/**
 * @author Stephen Chin
 */
var items1:SwingListItem[];
var items2:SwingListItem[];

class ListWrapper extends XCustomNode {
    public var items:SwingListItem[];
    override function create() {
        SwingList {
            items: bind items;
        }
    }
}

Timeline {
    keyFrames: [
        KeyFrame {
            time: 1s
            action: function() {
                items1 = for (i in [0..30]) {
                    SwingListItem {
                        text: "Wrapped Item Number {i}"
                    }
                }
            }
        }
        KeyFrame {
            time: 2s
            action: function() {
                items2 = for (i in [0..30]) {
                    SwingListItem {
                        text: "Unwrapped Item Number {i}"
                    }
                }
            }
        }
    ]
}.play();

Stage {
    width: 699
    height: 374
    scene: XScene {
        content: XGrid {
            // todo - set margins to 0
            rows: [
                row([
                    ListWrapper {items: bind items1}
                    XImageView {
                        preserveRatio: true
                        smooth: true
                        image: Image {
                            url: "{__DIR__}BakuretsuTenshi.jpg"
                        }
                    }
                    SwingList {
                        items: bind items2
                    }
                ])
            ]
        }
    }
}
