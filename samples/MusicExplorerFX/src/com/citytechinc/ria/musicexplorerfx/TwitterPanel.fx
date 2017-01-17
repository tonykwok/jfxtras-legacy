/*
 * Copyright (c) 2009, Sten Anderson, CITYTECH, INC.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 * 1. Redistributions of source code must retain the above copyright notice,
 *    this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 * 3. Neither the name of CITYTECH, INC. nor the names of its contributors may be used
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
 
package com.citytechinc.ria.musicexplorerfx;

import javafx.animation.transition.FadeTransition;
import javafx.scene.control.TextBox;
import javafx.scene.CustomNode;
import javafx.scene.Group;



import javafx.scene.Node;
import javafx.scene.control.Button;
import javafx.scene.layout.HBox;
import javafx.scene.layout.VBox;
import javafx.scene.paint.Color;
import javafx.scene.shape.Rectangle;
import javafx.scene.text.Font;
import javafx.scene.text.Text;
import com.citytechinc.ria.musicexplorerfx.util.TwitterHelper;
import java.lang.Void;

import javafx.geometry.HPos;

import javafx.scene.effect.BoxBlur;

/**
 * Handles the Twitter functionality for the app (also see TwitterHelper).
 *
 * @author sanderson
 */

public class TwitterPanel extends CustomNode {

    public-init var x:Number;
    public-init var y:Number;
    public-init var explorer:ArtistExplorer;

    def w:Number = 240;
    def h:Number = 230;

    var username:TextBox;
    var password:TextBox;
    var twitterStatus:String;
    var status:String = "";
    var passwordBlur:BoxBlur;

    override public function create():Node {
        opacity = 0;
        translateX = x;
        translateY = y;
        var text = Text {
            fill: Color.WHITESMOKE
            content: "Enter Your Twitter Info"
            //y: 30
            font: Font {
                size: 18
            }

        }
        
        var button = Button {
            text: "Tweet!"
            action: function() {tweet()}
        }
        var cancel = Button {
            text: "Cancel"
            action: function() {dismiss()}
        }
        var numCols = 20;
        username = TextBox {
            promptText: "Username"
            columns: numCols
        }
        passwordBlur = BoxBlur {iterations:3};
        password = TextBox {
            promptText: "Password"
            columns: numCols
            effect: bind if (password.rawText.length() > 0) passwordBlur else null
        }
        var previewText = Text {
            content: bind "Preview: '{twitterStatus}'"
            fill: Color.WHITESMOKE
            wrappingWidth: w - 20
        }
        var statusText = Text {
            content: bind status
            fill: Color.WHITESMOKE
        }

        var vbox = VBox {
            translateY: 10
            spacing: 8
            nodeHPos: HPos.CENTER
            hpos: HPos.CENTER
            content: [
                text,
                username,
                password,
                HBox {
                    spacing: 5
                    content: [
                        button,
                        cancel
                        ]
                    },
                statusText,
                previewText
                ]
            }
        center(vbox);

        Group {
            content: [
                Rectangle {
                    opacity: 0.4
                    stroke: Color.WHITESMOKE
                    arcHeight: 5
                    arcWidth: 5
                    width: w
                    height: h
                },
                vbox
            ]
        }
    }

    function center(node:Node) {
        node.translateX = w/2 - node.boundsInLocal.width / 2;
    }

    function tweet():Void {
        var twitter = new TwitterHelper();
        var success = twitter.tweet(twitterStatus, username.text, password.text);
        if (success) {
            status = "Successfully Tweeted";
            dismiss();
        }
        else {
            status = "Error Tweeting";

        }

    }

    public function dismiss():Void {
        FadeTransition {
            node: this
            duration: 0.7s
            toValue: 0
        }.play();
        explorer.setEnabled(true);
    }

    public function intro(twitterStatus:String):Void {
        this.status = "";
        this.twitterStatus = twitterStatus;
        FadeTransition {
            node: this
            duration: 0.7s
            toValue: 1.0
        }.play();

    }
}