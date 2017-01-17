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
package org.jfxtras.jugspinner;

import javafx.scene.control.Button;
import javafx.scene.control.Label;
import javafx.scene.control.ListView;
import javafx.scene.control.RadioButton;
import javafx.scene.control.TextBox;
import javafx.scene.control.ToggleGroup;
import javafx.scene.text.Font;
import javafx.scene.text.Text;
import org.jfxtras.scene.XCustomNode;
import org.jfxtras.scene.control.XMultiLineTextBox;
import org.jfxtras.scene.layout.XGrid;
import org.jfxtras.scene.layout.XGridLayoutInfo;
import org.jfxtras.scene.layout.XGridLayoutInfo.*;
import org.jfxtras.scene.layout.XHBox;
import org.jfxtras.scene.layout.XSpacer;
import org.jfxtras.util.XMap;

/**
 * @author Stephen Chin
 */
public class JUGUserScreen extends XCustomNode {
    var meetupEntry = true;
    var eventBriteEntry = false;
    var twitterEntry = false;
    var toggleGroup = ToggleGroup {}
    var jugs = XMap {
        entries: [
            XMap.Entry {key: "Silicon Valley Web JUG", value: "1381525"}
            XMap.Entry {key: "San Francisco JUG", value: "930480"}
            XMap.Entry {key: "Silicon Valley JavaFX Users Group", value: "1520539"}
            XMap.Entry {key: "San Francisco PHP Group", value: "120903"}
            XMap.Entry {key: "San Francisco Agile Software Group", value: "936565"}
            XMap.Entry {key: "The SiliconValley NewTech Meetup Group", value: "221224"}
        ]
    }
    var list:ListView;
    var selected = bind list.selectedItem on replace {
        JUGSpinnerModel.groupId = jugs.get(selected) as String;
    }
    var meetupSelector = XGrid {
        rows: [
            row(list = ListView {
                items: for (entry in jugs.entries) entry.key as String
                layoutInfo: XGridLayoutInfo {hspan: 2}
            }),
            row([Label {text: "Meetup.com Group ID:"}, TextBox {text: bind JUGSpinnerModel.groupId with inverse}]),
            row([Label {text: "Exclude answers containing:"}, TextBox {text: bind JUGSpinnerModel.excludeAnswers with inverse}])
        ]
        layoutInfo: XGridLayoutInfo {hspan: 4}
    }
    var eventBriteSelector = XGrid {
        rows: row([Label {text: "EventBrite ID:"}, TextBox {text: bind JUGSpinnerModel.eventBriteId with inverse}])
        layoutInfo: XGridLayoutInfo {hspan: 4}
    }
    var twitterSelector = XGrid {
        rows: row([Label {text: "Twitter Account ID:"}, TextBox {text: bind JUGSpinnerModel.twitterId with inverse}])
        layoutInfo: XGridLayoutInfo {hspan: 4}
    }
    var manualSelector = XMultiLineTextBox {width: 269, height: 253, layoutInfo: XGridLayoutInfo {hspan: 4}}

    override function create() {
        XGrid {
            layoutInfo: XGridLayoutInfo {margin: insets(10)}
            hgap: 10
            vgap: 10
            rows: bind [
                row(Text {content: "Load Prize Contestants", font: Font.font(null, 24), layoutInfo: XGridLayoutInfo {hspan: 4}}),
                row([Label {text: "Number of Prizes (optional):", layoutInfo: XGridLayoutInfo {hspan: 3}}, TextBox {text: bind JUGSpinnerModel.prizeCountString with inverse}]),
                row([
                    RadioButton{text: "Meetup.com", toggleGroup: toggleGroup, selected: bind meetupEntry with inverse}
                    RadioButton{text: "EventBrite", toggleGroup: toggleGroup, selected: bind eventBriteEntry with inverse}
                    RadioButton{text: "Twitter", toggleGroup: toggleGroup, selected: bind twitterEntry with inverse}
                    RadioButton{text: "Manual Entry", toggleGroup: toggleGroup}
                ]),
                row(if (meetupEntry) meetupSelector else if (eventBriteEntry) eventBriteSelector else if (twitterEntry) twitterSelector else manualSelector),
                row(XSpacer {}),
                row(XHBox {content: [
                    XSpacer {vgrow: NEVER},
                    Button {text: "Load", action: function() {load(true)}},
                    Button {text: "Load and Start", action: function() {load(false)}, strong: true}
                ], spacing: 8, layoutInfo: XGridLayoutInfo {hspan: 4}})
            ]
        }
    }

    function load(keepOpen:Boolean) {
        if (meetupEntry) {
            JUGSpinnerModel.loadEvent();
        } else if (eventBriteEntry) {
            JUGSpinnerModel.loadEventBriteAttendees();
        } else if (twitterEntry) {
            JUGSpinnerModel.loadTweets();
        } else {
            var attendees = manualSelector.getText().split("\n");
            JUGSpinnerModel.loadManualAttendees(attendees);
        }
        if (not keepOpen) {
            JUGSpinnerModel.loaded = true;
        }
    }
}
