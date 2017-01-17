/*
 * Main.fx
 *
 * Created on 4-sep-2009, 8:41:38
 */

package validatabletextbox;

import javafx.stage.Stage;
import javafx.scene.Scene;
import validatabletextbox.ValidatableTextBox;

import javafx.scene.control.Button;
import javafx.scene.input.MouseEvent;
import javafx.scene.layout.HBox;
import javafx.scene.text.Text;


import javafx.scene.control.CheckBox;


import javafx.ext.swing.SwingComboBox;

import javafx.ext.swing.SwingComboBoxItem;

import javafx.ext.swing.SwingSlider;

import javafx.scene.paint.Paint;



import javafx.scene.control.TextBox;

import javafx.geometry.HPos;
import javafx.scene.layout.Tile;

import javafx.scene.layout.LayoutInfo;

import javafx.scene.text.Font;

import javafx.scene.layout.VBox;



/**
 * @author Yannick
 */

var textBox:ValidatableTextBox;
var requiredBox: CheckBox;
var positionDropDown: SwingComboBox;
var maxWidthSlider: SwingSlider;
var bgDropDown: SwingComboBox;
var borderDropDown: SwingComboBox;
var requiredMsgBox: TextBox;
var regexBox: TextBox;
var regexMsgBox:TextBox;


function intValue(float:Float):Integer {
    float.intValue();
}


Stage {
    title: "Validatable Text Box"
    width: 650
    height: 400
    scene: Scene {
        content: [
            Text {
                font : Font {
                    name: "Arial Black"
                    size: 18
                  }
                content: "Validatable Text Box";
                layoutX: 50
                layoutY: 30
            },
            Tile {
                columns: 2
                nodeHPos: HPos.LEFT
                vgap: 10
                content: [
                    requiredBox = CheckBox {
                        text: "Required"
                    },
                    HBox {
                        spacing: 5
                        content: [
                            Text {
                                content: "Msg (requires revalidation)";
                            },
                            requiredMsgBox = TextBox {
                                text: "required"
                            }
                        ]
                    },
                    HBox {
                        spacing: 5
                        content: [
                            Text {
                                content: "RegexPattern";
                            },
                            regexBox = TextBox {
                            }
                        ]
                    },
                    HBox {
                        spacing: 5
                        content: [
                            Text {
                                content: "Msg (requires revalidation)";
                            },
                            regexMsgBox = TextBox {
                                text: "invalid"
                            }
                        ]
                    },
                    Text {
                        content: "Tooltip position";
                    },
                    positionDropDown = SwingComboBox {
                        selectedIndex: 0
                        items: [
                                SwingComboBoxItem{text: ToolTip.TOOLTIP_RIGHT},
                                SwingComboBoxItem{text: ToolTip.TOOLTIP_LEFT},
                                SwingComboBoxItem{text: ToolTip.TOOLTIP_UP},
                                SwingComboBoxItem{text: ToolTip.TOOLTIP_DOWN},
                                SwingComboBoxItem{text: ToolTip.TOOLTIP_OVER}
                            ]
                        layoutInfo: LayoutInfo {
                            width: 100
                            height: 20
                        }
                    },
                   Text {
                        content: "Tooltip maxWidth";
                    },
                    maxWidthSlider = SwingSlider {
                        minimum: 10
                        maximum: 100
                        value: 60
                    }
               ]
               layoutX: 50,
               layoutY: 50,
            },
            VBox {
                content: [
                    HBox {
                        spacing: 50
                        content: [
                            textBox = ValidatableTextBox {
                                required: bind requiredBox.selected
                                requiredMessage: bind requiredMsgBox.text
                                regexPattern: bind regexBox.text
                                regexPattenMessage: bind regexMsgBox.text
                                skin: ValidatableTextBoxSkin{
                                    tooltip: ToolTip {
                                            position: bind positionDropDown.selectedItem.text
                                            maxWidth: bind intValue(maxWidthSlider.value)
                                        }
                                }
                            },
                            Button {
                                text: "validate!"
                                onMouseClicked: function(me:MouseEvent) {
                                    textBox.validate();
                                }
                                layoutInfo: LayoutInfo {
                                    width: 100
                                    height: 25
                                }
                            }
                         ]
                    },
                    HBox {
                        spacing: 50
                        content: [
                            HBox {
                                content: [
                                    Text {
                                        content: bind "validation state: {textBox.validationState}"
                                    }
                                ]
                            },
                            HBox {
                                content: [
                                    Text {
                                        content: bind "validation message: {textBox.validationMessage}"
                                    }
                                ]
                            }
                        ]
                    }
               ]
               layoutX: 50,
               layoutY: 250
               width: 400
            }

        ]
    }
}

class ColorWrapper extends SwingComboBoxItem {
    var color:Paint on replace {
        value = color;
    }

    var name:String on replace {
        text = name;
    }
}