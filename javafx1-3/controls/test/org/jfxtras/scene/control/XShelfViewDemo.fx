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
package org.jfxtras.scene.control;

import javafx.animation.KeyFrame;
import javafx.animation.Timeline;
import javafx.scene.control.Button;
import javafx.scene.control.CheckBox;
import javafx.scene.control.Label;
import javafx.scene.control.Slider;
import javafx.scene.image.Image;
import javafx.stage.Stage;
import org.jfxtras.scene.FPSMonitor;
import org.jfxtras.scene.XScene;
import org.jfxtras.scene.border.XEmptyBorder;
import org.jfxtras.scene.layout.XHBox;
import org.jfxtras.scene.layout.XVBox;
import org.jfxtras.stage.XDialog;

/**
 * @author Stephen Chin
 * @author Keith Combs
 */
def NUM_URLS = 47;
var imageUrls:String[];
var imageNames:String[];
var scene:XScene;
Timeline {
    keyFrames: for (i in [1..NUM_URLS]) {
        KeyFrame {
            time: 200ms * i
            action: function() {
                insert "{__DIR__}TestImageLibrary/image ({i}).jpg" into imageUrls;
                insert "image ({i}).jpg" into imageNames;
            }
        }
    }
}.play();

def showText = CheckBox {text: "Image Titles", selected: true}
def showScrollBar = CheckBox {text: "Scroll Bar", selected: false}
def showReflection = CheckBox {text: "Reflection", selected: true}
def wrap = CheckBox {text: "Wrap", selected: false}
def preserveRatio = CheckBox {text: "Preserve Ratio", selected: true}
def cacheAt200 = CheckBox {text: "Cache at 200x200", selected: false}
def aspectRatio = Slider {value: 1, max: 2}
def centerGap = Slider {value: 0.5, max: 1}
def trackEvents:Button = Button {text: "Track Events", action: createEventTracker}
var eventList:XShelfEvent[];

function createEventTracker():Void {
    XDialog {
        width: 200
        height: 300
        title: "Event Tracker"
        owner: stage
        scene: XScene {
            content: XTableView {
                rows: bind eventList
            }
        }
    }
}

function addEvent(eventType:String, event:XShelfEvent) {
    insert event into eventList;
}

var stage = Stage {
    width: 640
    height: 360
    title: "XShelfView Test"
    icons: Image {
        url: "{__DIR__}TestImageLibrary/image (9).jpg"
        width: 32
        height: 32
        preserveRatio: true
    }
    var shelf:XShelfView = XShelfView {
        centerGap: bind centerGap.value
        centerEventsOnly: false
        aspectRatio: bind aspectRatio.value
        preserveRatio: bind preserveRatio.selected
        showScrollBar: bind showScrollBar.selected
        showText: bind showText.selected
        reflection: bind showReflection.selected
        wrap: bind wrap.selected
        imageUrls: bind imageUrls
        imageNames: bind imageNames
        thumbnailWidth: bind if (cacheAt200.selected) 200 else -1
        thumbnailHeight: bind if (cacheAt200.selected) 200 else -1
        onImagePressed: function(e) {addEvent("Pressed", e)}
        onImageClicked: function(e) {addEvent("Clicked", e)}
        onImageReleased: function(e) {addEvent("Released", e)}
        onImageEntered: function(e) {addEvent("Entered", e)}
        onImageExited: function(e) {addEvent("Exited", e)}
        action: function(e) {addEvent("Action", e)}
    };
    scene: XScene {
        content: FPSMonitor {
            node: XEmptyBorder {
                borderWidth: 25
                node: XHBox {
                    spacing: 10
                    content: bind [
                        XVBox {
                            spacing: 8
                            content: [ shelf,
                                XHBox {
                                    spacing: 10
                                    content: [
                                        showText,
                                        showScrollBar,
                                        showReflection,
                                        wrap,
                                        preserveRatio,
                                        cacheAt200
                                    ]
                                }
                                XHBox {
                                    spacing: 10
                                    content: [
                                        Label {text: "Aspect Ratio"}
                                        aspectRatio,
                                        Label {text: "Center Gap"}
                                        centerGap,
                                        trackEvents
                                    ]
                                }
                            ]
                        }
                    ]
                }
            }
        }
    }
}