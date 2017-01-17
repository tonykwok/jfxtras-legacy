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

import javafx.stage.Alert;
import javafx.scene.control.Button;
import javafx.scene.effect.Reflection;
import javafx.scene.image.ImageView;
import javafx.scene.text.Font;
import javafx.scene.text.Text;
import org.jfxtras.jugspinner.data.Member;
import org.jfxtras.scene.XCustomNode;
import org.jfxtras.scene.control.XTableColumn;
import org.jfxtras.scene.control.XTableView;
import org.jfxtras.scene.control.renderer.ImageRenderer;
import org.jfxtras.scene.control.renderer.TextRenderer;
import org.jfxtras.scene.image.XImage;
import org.jfxtras.scene.layout.XGridLayoutInfo;
import org.jfxtras.scene.layout.XGridLayoutInfo.*;
import org.jfxtras.scene.layout.XHBox;
import org.jfxtras.scene.layout.XVBox;
import org.jfxtras.scene.layout.XSpacer;
import org.jfxtras.scene.layout.XStack;

/**
 * @author Stephen Chin
 */
public class JUGWinnerDisplay extends XCustomNode {
    var winners = bind JUGSpinnerModel.winners with inverse;
    var members = bind JUGSpinnerModel.members with inverse;

    public function showWinner(position:Integer) {
        winnerTable.selectedRow = position;
        winnerTable.scrollToSelected();
    }

    def placeholder = XImage {
        url: "{__DIR__}ImagePlaceholder.png";
    }
    def winnerTable = XTableView {
        effect: Reflection {topOffset: 10, fraction: .5, topOpacity: 0.3}
        rowType: Member {}.getJFXClass();
        rows: bind winners
        columns: [
            XTableColumn {
                displayName: "#"
                id: "place"
                prefWidth: 10
                renderer: TextRenderer {}
            }
            XTableColumn {
                displayName: "Photo"
                id: "photoUrl"
                prefWidth: 30
                renderer: ImageRenderer {
                    missing: placeholder
                    placeholder: placeholder
                }
            }
            XTableColumn {
                displayName: "Name"
                id: "name"
                prefWidth: 300
                renderer: TextRenderer {}
            }
        ]
        rowHeight: 50
    }
    def removeButton = Button {
        text: "Remove from Winners"
        disable: bind winnerTable.selectedRow < 0 or winnerTable.selectedRow >= sizeof winners
        action: function() {
            delete winners[winnerTable.selectedRow];
            JUGSpinnerModel.fixWinnerPlaces();
        }
    }
    def deleteButton = Button {
        text: "Delete User"
        disable: bind winnerTable.selectedRow < 0 or winnerTable.selectedRow >= sizeof winners
        action: function() {
            def user = winners[winnerTable.selectedRow];
            if (Alert.confirm("Confirmation", "Are you sure you want to delete {user.name} from the list of attendees?")) {
                delete winners[winnerTable.selectedRow];
                delete user from members;
                JUGSpinnerModel.fixWinnerPlaces();
            }
        }
    }

    function getPlaceName(place:Integer) {
        var suffix:String;
        if (place >= 11 and place <= 13) {
            suffix = "th"
        } else if (place mod 10 == 1) {
            suffix = "st"
        } else if (place mod 10 == 2) {
            suffix = "nd"
        } else if (place mod 10 == 3) {
            suffix = "rd"
        } else {
            suffix = "th"
        }
        return "{place}{suffix}";
    }

    override function create() {
        XStack {
            content: [
//                ResizableRectangle {fill: Color.color(0, 0, 0, .2)}
        XVBox {
            spacing: 10
            var winner = bind winners[winnerTable.selectedRow];
            content: [
                Text {
                    content: bind "{getPlaceName(winner.place)} Place"
                    font: Font.font(null, 30)
                }
                XHBox {
                    spacing: 10
                    content: [
                        ImageView {
                            preserveRatio: true
                            image: bind XImage {
                                backgroundLoading: true
                                url: winner.photoUrl
                                placeholder: placeholder
                            }
                            fitHeight: 150
                        },
                        XVBox {
                            spacing: 8
                            content: [
                                Text {
                                    content: bind "Name: {winner.name}"
                                    font: Font.font(null, 18)
                                }
                                Text {
                                    content: bind "Comment:"
                                    font: Font.font(null, 12)
                                }
                                Text {
                                    content: bind winner.comment
                                    font: Font.font(null, 12)
                                    wrappingWidth: 200
                                    layoutInfo: XGridLayoutInfo {width: 200, hgrow: SOMETIMES, minWidth: 100}
                                }
                            ]
                            layoutInfo: XGridLayoutInfo {minHeight: 150}
                        }
                    ]
                },
                XHBox {
                    spacing: 10
                    content: [Text {content: "List of Winners:", font: Font.font(null, 18)}, XSpacer {}, removeButton, deleteButton]
                },
                winnerTable
            ]
            layoutInfo: XGridLayoutInfo {hgrow: ALWAYS}
        }
            ]
        }
    }
}
