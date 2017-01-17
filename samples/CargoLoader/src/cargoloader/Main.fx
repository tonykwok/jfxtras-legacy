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
package cargoloader;

import javafx.lang.FX;
import javafx.scene.Group;
import javafx.scene.Scene;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;
import javafx.scene.input.MouseEvent;
import javafx.scene.paint.Color;
import javafx.scene.shape.Rectangle;
import javafx.scene.text.Text;
import javafx.stage.Stage;
import javafx.stage.StageStyle;
import java.lang.Boolean;
import java.lang.String;
import java.lang.Void;
import cargoloader.DeckNode;
import cargoloader.DeckPanel;
import cargoloader.PositionNode;
import javafx.scene.layout.Panel;
import javafx.scene.layout.Container;
import dnd.DraggableNode;
import dnd.DroppableNode;
import javafx.scene.control.Button;
import javafx.stage.AppletStageExtension;
import cargoloader.WeightCoverageChart;
import com.javafx.preview.control.ToolBar;
import javafx.scene.control.Separator;
import cargoloader.AboutPanel;
import javafx.scene.paint.LinearGradient;
import javafx.scene.paint.Stop;
import javafx.scene.layout.LayoutInfo;
import javafx.geometry.Insets;
import javafx.scene.Cursor;
import javafx.scene.Node;

/**
 * the Main script file
 * @author Abhilshit Soni
 */
var stageDragInitialX: Number;
var stageDragInitialY: Number;
var inBrowser = "true".equals(FX.getArgument("isApplet") as String);
var draggable = AppletStageExtension.appletDragSupported;
var allDraggables = [];
var allDroppables = [];
var revertButton: Button = null;

revertButton = Button {
            cache: true;
            text: "Reset Containers"
            action: function () {
                revertBack();
                dataPanel.requestFocus();
            }
            layoutInfo: LayoutInfo {margin: Insets {left: 10 } }
            onMouseEntered: function (e: MouseEvent): Void {
                showHandCursor(revertButton);
            }
            onMouseExited: function (e: MouseEvent): Void {
                showDefaultCursor(revertButton);
            }
        };

function revertBack() {
    for (i in allDraggables) {
        (i as DraggableNode).revertBack();
    }
}

function showHandCursor(node: Node) {
    node.cursor = Cursor.HAND;
}

function showDefaultCursor(node: Node) {
    node.cursor = Cursor.HAND;
}

var stage: Stage;
var aboutButton: Button = null;

aboutButton = Button {
            cache: true;
            text: "About Beechcraft Cargoloader"
            action: function () {
                insert AboutPanel {} into stage.scene.content;
            }
            onMouseEntered: function (e: MouseEvent): Void {
                showHandCursor(aboutButton);
            }
            onMouseExited: function (e: MouseEvent): Void {
                showDefaultCursor(aboutButton);
            }
            layoutInfo: LayoutInfo {margin: Insets {left: 10 } };
        };

var helpButton: Button = null;

helpButton = Button {
            cache: true;
            text: "Help"
            action: function () {
                insert HelpPanel {} into stage.scene.content;
            }
            onMouseEntered: function (e: MouseEvent): Void {
                showHandCursor(helpButton);
            }
            onMouseExited: function (e: MouseEvent): Void {
                showDefaultCursor(helpButton);
            }
            layoutInfo: LayoutInfo {margin: Insets {left: 10 } };
        };

function disableAnimation() {
    for (i in allDraggables) {
        (i as DraggableNode).dragAnimate = false;
    }
}

function enableAnimation() {
    for (i in allDraggables) {
        (i as DraggableNode).dragAnimate = true;
    }
}

var disableAnimationButton: Button = null;
var animationEnabled = true;

disableAnimationButton = Button {
            cache: true;
            styleClass: "animationButtonToogled";
            text: "Disable Animation"
            action: function () {
                if (animationEnabled) {
                    disableAnimation();
                    disableAnimationButton.text = "Enable Animation";
                    disableAnimationButton.styleClass = "animationButton";
                    animationEnabled = false;
                } else {
                    enableAnimation();
                    disableAnimationButton.text = "Disable Animation";
                    disableAnimationButton.styleClass = "animationButtonToogled";
                    animationEnabled = true;
                }
            }
            onMouseEntered: function (e: MouseEvent): Void {
                showHandCursor(disableAnimationButton);
            }
            onMouseExited: function (e: MouseEvent): Void {
                showDefaultCursor(disableAnimationButton);
            }
            layoutInfo: LayoutInfo {margin: Insets {left: 10 } width: 120 };
        };

var weightViewButton: Button = null;
var weightViewDisabled = true;

weightViewButton = Button {
            cache: true;
            styleClass: "animationButtonToogled";
            text: "View Weights"
            action: function () {
                if (weightViewDisabled) {
                    showWeightView();
                    weightViewButton.text = "Hide Weights";
                    weightViewButton.styleClass = "animationButton";
                    weightViewDisabled = false;
                } else {
                    hideWeightView();
                    weightViewButton.text = "View Weights";
                    weightViewButton.styleClass = "animationButtonToogled";
                    weightViewDisabled = true;
                }
            }
            onMouseEntered: function (e: MouseEvent): Void {
                showHandCursor(weightViewButton);
            }
            onMouseExited: function (e: MouseEvent): Void {
                showDefaultCursor(weightViewButton);
            }
            layoutInfo: LayoutInfo {margin: Insets {left: 10 } width: 120 };
        };

function showWeightView() {
    for (i in uldPanel.content) {
        if (i instanceof ULDNode) {
            var curULDNode: ULDNode = (i as ULDNode);
            var uld: ULD = curULDNode.dataObject as ULD;
            curULDNode.uldImage.visible = false;
        }
    }
}

function hideWeightView() {
    for (i in uldPanel.content) {
        if (i instanceof ULDNode) {
            var curULDNode: ULDNode = (i as ULDNode);
            var uld: ULD = curULDNode.dataObject as ULD;
            curULDNode.uldImage.visible = true;
        }
    }
}

var sepWidth = 23;
var toolbar: ToolBar = ToolBar {
            cache:true
            styleClass: "glossy";
            translateX: 270 translateY: 245
            items: [revertButton,
                Separator {vertical: true layoutInfo: LayoutInfo {height: 15 width: sepWidth margin: Insets {left: 10 } } },
                disableAnimationButton,
                Separator {vertical: true layoutInfo: LayoutInfo {height: 15 width: sepWidth margin: Insets {left: 10 } } },
                weightViewButton,
                Separator {vertical: true layoutInfo: LayoutInfo {height: 15 width: sepWidth margin: Insets {left: 10 } } },
                aboutButton,
                Separator {vertical: true layoutInfo: LayoutInfo {height: 15 width: sepWidth margin: Insets {left: 10 } } },
                helpButton]
            layoutInfo: LayoutInfo {height: 32 width: 640 }
        }
var dragRect: Rectangle = Rectangle {x: 0 y: 0 width: 950 height: 25 fill: Color.GREY
             cache: true;
            onMousePressed: function (e) {
                stageDragInitialX = (e.screenX - stage.x);
                stageDragInitialY = e.screenY - stage.y;
            }
            onMouseDragged: function (e) {
                stage.x = e.screenX - stageDragInitialX;
                stage.y = e.screenY - stageDragInitialY;
            }
        };
var dragTextVisible = bind inBrowser and draggable and dragRect.hover;
var dragControl: Group = Group {
            content: [
                Text {x: 430 y: 17 content: "Drag out of Browser" fill: Color.WHITE visible: bind dragTextVisible },
                ImageView {x: 920 y: 8 image: Image {url: "{__DIR__}images/close_rollover.png" }
                    visible: bind not inBrowser
                },
                ImageView {x: 570 y: 8 image: Image {url: "{__DIR__}images/dragOut_rollover.png" }
                    visible: bind inBrowser and draggable
                },
                Rectangle {x: 920 y: 8 width: 10 height: 10 fill: Color.TRANSPARENT
                    onMouseClicked: function (e: MouseEvent): Void {
                        stage.close();
                    }
                }
            ]
        };
var width = 950;
var height = 670;
var dataPanel = DataPanel {
            translateX: 270, translateY: 320 };
var planData = PlanData {dataPanel: dataPanel };
var uldPanel = ULDPanel {};
var deckPanel = DeckPanel {};
var graph = GraphPanel {id: "graph" };
var weightCoverageChart = WeightCoverageChart {
            translateX: 7
            planData: planData
        }

for (i in deckPanel.content) {
    (i as PositionNode).planData = planData;
}

var miscPanel: Panel = Panel {
            id: "misc"
            content: [Rectangle {
                    cache: true
                    width: width
                    height: height
                    fill: LinearGradient {
                        startX: 0
                        startY: 0
                        endX: 0
                        endY: 1
                        stops: [
                            Stop {
                                offset: 0.0
                                color: Color.rgb(102, 102, 102)
                            },
                            Stop {
                                offset: 0.5
                                color: Color.rgb(0, 0, 0)
                            },
                            Stop {
                                offset: 1.0
                                color: Color.rgb(102, 102, 102)
                            },
                        ]
                    }
                }, DeckNode {
                    cache: true
                    translateX: 260, translateY: 45
                },
                deckPanel, toolbar,
                weightCoverageChart, dataPanel, graph, uldPanel,
                dragControl]
        }

stage = Stage {
            title: "Weight and Balance"
            visible: true
            resizable: false
            style: StageStyle.UNDECORATED
            scene: Scene {
                stylesheets: "{__DIR__}styles.css";
                content: [
                    miscPanel,// OptionsPanel {}
                ]
            }
            extensions: [
                AppletStageExtension {
                    shouldDragStart: function (e): Boolean {
                        return inBrowser and e.primaryButtonDown and dragRect.hover;
                    }
                    onDragStarted: function () {
                        inBrowser = false;
                    }
                    onAppletRestored: function () {
                        inBrowser = true;
                    }
                    useDefaultClose: false
                }
            ]
        }

// Insert dragRect here to avoid possible cycle during initialization
insert dragRect before dragControl.content[0];
stage;

dataPanel.requestFocus();
populateDroppables();
populateDraggables();

function populateDroppables(): Void {
    var container = stage.scene;
    for (i in container.content) {
        if (i instanceof DroppableNode) {
            insert i into allDroppables;
        } else if (i instanceof Container) {
            populateDroppablesFromContainer(i as Container);
        }

    }
}

function populateDroppablesFromContainer(container: Container): Void {
    for (i in container.content) {
        if (i instanceof DroppableNode) {
            insert i into allDroppables;
        } else if (i instanceof Container) {
            populateDroppablesFromContainer(i as Container);
        }

    }
}

function populateDraggables(): Void {
    var container = stage.scene;
    for (i in container.content) {
        if (i instanceof DraggableNode) {
            insert i into allDraggables;
        } else if (i instanceof Container) {
            populateDraggablesFromContainer(i as Container);
        }

    }
}

function populateDraggablesFromContainer(container: Container): Void {
    for (i in container.content) {
        if (i instanceof DraggableNode) {
            insert i into allDraggables;
        } else if (i instanceof Container) {
            populateDraggablesFromContainer(i as Container);
        }

    }
}

for (i in allDraggables) {
    (i as DraggableNode).allDraggables = allDraggables;
    (i as DraggableNode).allDroppables = allDroppables;
}
