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
package org.jfxtras.scene.border;

/**
 * @author jclarke
 * @author Stephen Chin
 */
import javafx.stage.Stage;
import javafx.scene.shape.Rectangle;
import javafx.scene.paint.*;
import javafx.scene.image.Image;

import javafx.scene.CustomNode;
import javafx.scene.Group;
import javafx.scene.Node;
import javafx.scene.text.Text;
import javafx.scene.effect.*;
import javafx.geometry.*;
import org.jfxtras.scene.layout.XGrid;
import org.jfxtras.scene.layout.XLayoutInfo;
import org.jfxtras.scene.layout.XGridLayoutInfo.*;
import org.jfxtras.scene.shape.Star2;

import javafx.scene.layout.LayoutInfo;

import org.jfxtras.scene.XScene;

import javafx.scene.layout.Resizable;

class ANode extends CustomNode, Resizable {
    public var text:String;
    override function getPrefWidth(height) {100}
    override function getPrefHeight(width) {100}
    public var raised: Boolean;

    override var layoutInfo = XLayoutInfo {
        hpos: CENTER
    }

    public override function create(): Node {
        var txt:Text;
        return Group {
            content: [
                Rectangle {
                    width: bind width
                    height: bind height
                    fill: Color.WHITESMOKE
                    onMouseClicked: function(e):Void {
                        raised = not raised;
                    }

                },
                txt = Text {
                    translateX: bind (width - txt.layoutBounds.width)/2.0 - txt.layoutBounds.minX
                    translateY: bind (height - txt.layoutBounds.height)/2.0 - txt.layoutBounds.minY
                    content: bind text
                }
            ]
        };
    }
}

Stage {
    title: "JFXtras Border Demo in a Grid"
    width: 800
    height: 800
    scene: XScene {
        fill: Color.WHITE
        content: XGrid {
            rows: [
                row([
                    XBevelBorder {
                        var anode: ANode;
                        raised: bind anode.raised
                        node: anode = ANode { text: "BevelBorder" }
                    },
                    XEllipseBorder {
                        var anode: ANode;
                        raised: bind anode.raised
                        node: anode = ANode { text: "EllipseBorder" }
                    },
                    Group {
                        var border: XBorder;
                        content: [
                            Rectangle { // shows the positioning of the content
                                        // within the  Border
                                translateX: bind border.layoutBounds.minX
                                translateY: bind border.layoutBounds.minY
                                width: bind border.layoutBounds.width
                                height: bind border.layoutBounds.height;
                                fill: null
                                stroke: Color.BLACK
                                strokeWidth: 0.0
                                strokeDashArray: [4.0, 4.0]

                            },
                            border = XEmptyBorder {
                                shapeToFit: false
                                nodeHPos: HPos.LEFT
                                nodeVPos: VPos.TOP
                                layoutInfo: LayoutInfo {
                                    width: 150
                                    height: 150
                                }

                                node: ANode { text: "EmptyBorder- TopLeft" }
                            },
                        ]
                    },
                    XEtchedBorder {
                        var anode: ANode;
                        raised: bind anode.raised
                        node: anode = ANode { text: "EtchedBorder" }
                    }
                ]),
                row([
                    XFrameBorder {
                        id: "MainFrame"
                        var anode: ANode;
                        raised: bind anode.raised

                        node: anode = ANode { text: "FrameBorder" }
                    },
                    XLineBorder {
                        id: "MainLine"
                        node: ANode { text: "LineBorder" }
                    },
                    XMetallicBorder {
                        var anode: ANode;
                        raised: bind anode.raised
                        node: anode = ANode { text: "MetallicBorder" }
                    },
                    XPipeBorder {
                        var anode: ANode;
                        raised: bind anode.raised
                        node: anode = ANode { text: "PipeBorder" }
                    }
                ]),
                row([
                    XSoftBevelBorder {
                        var anode: ANode;
                        raised: bind anode.raised
                        node: anode = ANode { text: "SoftBevelBorder" }
                    },
                    XTitledBorder {
                        var anode: ANode;
                        id: "MainTitle"
                        text: "Sample Title"
                        titleHPos: HPos.LEFT
                        node: XFrameBorder {
                            raised: bind anode.raised
                            node: anode = ANode {
                                text: "TitledBorder"
                            }
                        }
                    },
                    XLineBorder {
                        id: "LineShadowBorder"
                        effect: DropShadow{};
                        node: ANode { text: "Line Shadow" }
                    },
                    XRoundedRectBorder {
                        effect: DropShadow{};
                        var anode: ANode;
                        raised: bind anode.raised
                        node: anode = ANode { text: "Rounded\nShadow" }
                    }
                ]),
                row([
                    XImageBorder {
                        image: Image{ url: "{__DIR__}AusArt.jpg" }
                        node: ANode { text: "Image" }
                    },
                    Group {
                        var border: XBorder;
                        content: [
                            Rectangle { // shows the positioning of the content
                                        // within the  Border, should be centered.
                                translateX: bind border.layoutBounds.minX
                                translateY: bind border.layoutBounds.minY
                                width: bind border.layoutBounds.width
                                height: bind border.layoutBounds.height;
                                fill: null
                                stroke: Color.BLACK
                                strokeWidth: 0.0
                                strokeDashArray: [4.0, 4.0]

                            },
                            border = XEmptyBorder {
                                shapeToFit: false
                                layoutInfo : LayoutInfo {
                                    width: 150
                                    height: 150
                                }

                                node:
                                ANode { text: "Centered-Border" }
                            },
                        ]
                    },
                    // Demonstrates a Combo Border
                    XTitledBorder {
                        text: "Combo Border"
                        id: "Combo"
                        node: XFrameBorder {
                            var anode: ANode;
                            raised: bind anode.raised
                            node: XImageBorder {
                                image: Image{ url: "{__DIR__}AusArt.jpg" }
                                node: anode = ANode { text: "Image" }
                            }
                        }
                    },
                    XShapeBorder {
                        var anode: ANode;
                        shape: Star2 {
                            centerX: bind anode.layoutBounds.width/2
                            centerY: bind anode.layoutBounds.height/2
                            outerRadius: bind anode.layoutBounds.width/2
                            innerRadius: bind anode.layoutBounds.width/4
                            count: 5
                        }
                        node:
                            anode = ANode { text: "Shape Border" }
                    },
                ])
            ]
        }
    }
}
