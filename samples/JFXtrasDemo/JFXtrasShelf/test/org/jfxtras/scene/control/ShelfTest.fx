/*
 * Copyright (c) 2008-2009, JFXtras Group
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
package org.jfxtras.scene.control;

import javafx.animation.Timeline;
import javafx.animation.KeyFrame;
import org.jfxtras.scene.ResizableScene;
import org.jfxtras.scene.border.EmptyBorder;

import javafx.scene.control.CheckBox;

import javafx.scene.control.Slider;

import javafx.scene.control.Label;


import org.jfxtras.scene.layout.ResizableVBox;

import org.jfxtras.scene.layout.ResizableHBox;

import javafx.stage.Stage;

import javafx.scene.image.Image;

/**
 * @author Stephen Chin
 * @author Keith Combs
 */
def NUM_URLS = 47;
var imageUrls:String[];
var imageNames:String[];
var scene:ResizableScene;
Timeline {
    keyFrames: for (i in [1..NUM_URLS]) {
        KeyFrame {
            time: 200ms * i
            action: function() {
                insert "http://jfxtras.org/portal/webdav/liferay.com/guest/document_library/Samples/JFXtrasDemo/JFXtrasShelf/images/image%%20({i}).jpg" into imageUrls;
                insert "image ({i}).jpg" into imageNames;
            }
        }
    }
}.play();

def showText = CheckBox {text: "Image Titles", selected: true}
def showScrollBar = CheckBox {text: "Scroll Bar", selected: true}
def showReflection = CheckBox {text: "Reflection", selected: true}
def preserveRatio = CheckBox {text: "Preserve Ratio", selected: true}
def cacheAt200 = CheckBox {text: "Cache at 200x200", selected: true}
def aspectRatio = Slider {value: 1, max: 2}
def centerGap = Slider {value: 0.5, max: 1}

Stage {
    width: 640
    height: 360
    title: "Shelf Test"
// disabled due to RT-5077 - Stage icons do not work on unsigned applications
//    icons: Image {
//        url: "http://jfxtras.org/portal/webdav/liferay.com/guest/document_library/Samples/JFXtrasDemo/JFXtrasShelf/images/image%%20(9).jpg"
//        width: 32
//        height: 32
//        preserveRatio: true
//    }
    scene: ResizableScene {
        content: EmptyBorder {
            borderWidth: 25
            node: ResizableVBox {
                spacing: 8
                content: [
                    Shelf {
                        centerGap: bind centerGap.value
                        aspectRatio: bind aspectRatio.value
                        preserveRatio: bind preserveRatio.selected
                        showScrollBar: bind showScrollBar.selected
                        showText: bind showText.selected
                        reflection: bind showReflection.selected
                        imageUrls: bind imageUrls
                        imageNames: bind imageNames
                        thumbnailWidth: bind if (cacheAt200.selected) 200 else -1
                        thumbnailHeight: bind if (cacheAt200.selected) 200 else -1
                    }
                    ResizableHBox {
                        spacing: 10
                        content: [
                            showText,
                            showScrollBar,
                            showReflection,
                            preserveRatio,
                            cacheAt200
                        ]
                    }
                    ResizableHBox {
                        spacing: 10
                        content: [
                            Label {text: "Aspect Ratio"}
                            aspectRatio,
                            Label {text: "Center Gap"}
                            centerGap
                        ]
                    }
                ]
            }
        }
    }
}