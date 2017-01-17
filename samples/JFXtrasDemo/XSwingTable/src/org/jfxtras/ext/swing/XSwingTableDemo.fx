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

package org.jfxtras.ext.swing;

import org.jfxtras.ext.swing.XSwingTable;
import org.jfxtras.ext.swing.table.IntegerCell;
import org.jfxtras.ext.swing.table.ListSelectionMode;
import org.jfxtras.ext.swing.table.ObjectSequenceTableModel;
import org.jfxtras.ext.swing.table.Row;
import org.jfxtras.ext.swing.table.StringCell;
import org.jfxtras.ext.swing.table.TableResizeMode;
import org.jfxtras.scene.layout.MigNodeLayoutInfo;
import org.jfxtras.scene.layout.MigLayout;
import org.jfxtras.scene.XScene;

import javafx.animation.Interpolator;
import javafx.animation.KeyFrame;
import javafx.animation.Timeline;
import javafx.ext.swing.SwingButton;
import javafx.ext.swing.SwingLabel;
import javafx.ext.swing.SwingScrollPane;
import javafx.ext.swing.SwingTextField;
import javafx.scene.shape.Rectangle;
import javafx.stage.Stage;

/**
 * @author John Freeman
 */

class Person {
    var forename:String;
    var surname:String;
    var age:Integer;

    function copyTo(to:Person) {
        to.forename = forename;
        to.surname = surname;
        to.age = age;
    }
}

var people = [
  Person {
      forename: "Joe"
      surname: "Bloggs"
      age: 45
  }
  Person {
      forename: "Jane"
      surname: "Doe"
      age: 35
  }
  Person {
      forename: "Fred"
      surname: "Bloggs"
      age: 60
  }
];

var selectedPerson:Person = null on replace {
    if (selectedPerson == null) {
        Person{}.copyTo(detailPerson);
    } else {
        selectedPerson.copyTo(detailPerson);
    }
}

// unfortunatly we can't use selectedPerson directly because
// you can't bind with inverse to the property of a var
def detailPerson = Person {}

var detailPanel:MigLayout;
var swingTable:XSwingTable;
Stage {
    width: 350
    height: 300
    title: ##[app_title]"XSwingTable Demo"
    scene: XScene  {
        content: MigLayout {
            constraints: "wrap 1"
            rows: "[]unrel[]"
            content: [
                SwingScrollPane {
                    view: swingTable = XSwingTable {
                        autoResizeMode: TableResizeMode.AUTO_RESIZE_OFF
                        tableModel: ObjectSequenceTableModel {
                            override function transformEntry(entry) {
                                def person:Person = entry as Person;
                                return Row {
                                    cells: [
                                        StringCell { value: bind person.forename }
                                        StringCell { value: bind person.surname }
                                        IntegerCell { 
                                            value: bind person.age with inverse
                                            editable: true
                                        }
                                    ]
                                }
                            }
                            columnLabels: [##[forename_label]"Forename", ##[surname_label]"Surname", ##[age_label]"Age"]
                            sequence: bind people
                        }
                        rowSelectionMode: ListSelectionMode.SINGLE_SELECTION;
                        onSelectedRowChanged: function(selectedRowIndex) {
                            Timeline {
                                keyFrames : [
                                    KeyFrame {
                                        time : 0.4s
                                        canSkip : true
                                        values : [
                                            detailPanel.opacity => 0 tween Interpolator.LINEAR,
                                            detailPanel.translateY => - detailPanel.height tween Interpolator.LINEAR
                                        ]
                                    }
                                    KeyFrame {
                                        time : 0.4s
                                        canSkip : false
                                        values : [
                                            detailPanel.opacity => 1
                                        ]
                                        action: function() {
                                            selectedPerson = if (selectedRowIndex == null) 
                                                then null
                                                else people[selectedRowIndex];
                                        }
                                    }
                                    KeyFrame {
                                        time : 0.8s
                                        canSkip : true
                                        values : [
                                            detailPanel.translateY => 0 tween Interpolator.LINEAR
                                        ]
                                    }
                                ]
                            }.play();
                        }
                    }
                }
                detailPanel = MigLayout {
                    clip: Rectangle {
                        y: bind -detailPanel.translateY
                        width: bind detailPanel.width
                        height: bind detailPanel.height - detailPanel.translateY
                    }

                    constraints: "insets 0, wrap 2"
                    rows: "[]unrel[]"
                    content: [
                        SwingLabel {
                            text: ##[forename_label]"Forename"
                        }
                        SwingTextField {
                            text: bind detailPerson.forename with inverse
                            columns: 12
                        }

                        SwingLabel {
                            text: ##[surname_label]"Surname"
                        }
                        SwingTextField {
                            text: bind detailPerson.surname with inverse
                            columns: 12
                        }

                        SwingLabel {
                            text: ##[age_label]"Age"
                        }
                        SwingIntegerField {
                            value: bind detailPerson.age with inverse
                            columns: 3
                        }

                        SwingButton {
                            layoutInfo: MigNodeLayoutInfo {
                                constraints: "spanx 2, split 3"
                            }
                            disable: bind selectedPerson == null
                            text: ##[update_button]"Update"
                            action: function () {
                                detailPerson.copyTo(selectedPerson);
                            }
                        }
                        SwingButton {
                            text: ##[add_button]"Add"
                            action: function () {
                                def newPerson = Person {}
                                detailPerson.copyTo(newPerson);
                                insert newPerson into people;

                                // select new row
                                var newSelectionIndex = sizeof people - 1;
                                var jTable = swingTable.getJTable();
                                var selectionModel = jTable.getSelectionModel();
                                selectionModel.setSelectionInterval(newSelectionIndex, newSelectionIndex);
                                // scroll to new row
                                jTable.scrollRectToVisible(jTable.getCellRect(newSelectionIndex, 0, true));
                            }
                        }
                        SwingButton {
                            text: ##[delete_button]"Delete"
                            disable: bind selectedPerson == null
                            action: function () {
                                Timeline {
                                    keyFrames : [
                                        KeyFrame {
                                            time : 0.4s
                                            canSkip : false
                                            values : [
                                                detailPanel.opacity => 0 tween Interpolator.LINEAR,
                                                detailPanel.translateY => detailPanel.height tween Interpolator.LINEAR
                                            ]
                                            action: function() {
                                                delete selectedPerson from people;
                                            }
                                        }
                                    ]
                                }.play();
                            }
                        }
                    ]
                }
            ]
        }
    }
}
