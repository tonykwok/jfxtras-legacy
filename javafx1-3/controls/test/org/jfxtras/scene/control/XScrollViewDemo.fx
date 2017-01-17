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

import javafx.scene.*;
import javafx.scene.control.ScrollBar;
import javafx.scene.layout.LayoutInfo;
import javafx.scene.paint.*;
import javafx.scene.shape.*;
import javafx.scene.text.*;
import javafx.stage.Stage;
import org.jfxtras.scene.layout.XGrid;
import org.jfxtras.scene.layout.XGridLayoutInfo.*;

/**
 * Test for scroll bars.
 * @author jclarke
 */
class ANode extends CustomNode {
    public var width: Number = 500;
    public var height: Number = 500;
    public var content: String;

    override var layoutInfo = LayoutInfo {
        hpos: CENTER
    }

    public override function create(): Node {
        var text: Text;
        return Group {
            cache: true
            content: [
                Rectangle {
                    width: bind width
                    height: bind height
                    fill: LinearGradient {
                        endY: 1.0
                        endX: 1.0
                        stops: [
                            Stop {
                                offset: 0
                                color: Color.BLUE
                            },
                            Stop {
                                offset: 1.0
                                color: Color.RED
                            }
                        ]
                    }
                },
                text = Text {
                    translateX: 20
                    translateY: 20
                    content: bind content
                    font: Font{size: 36
                    }
                    textOrigin: TextOrigin.TOP
                    fill: Color.WHITE
                }

            ]
        };
    }
}




Stage {
    var hscroll: ScrollBar;
    var vscroll: ScrollBar;


    var hvalue: String on replace {
        if(hvalue != "") {
            var v: Number = java.lang.Float.valueOf(hvalue);
            if(v != hscroll.value)
            hscroll.value = v;
        }
    }
    var vvalue: String on replace {
        if(vvalue != "") {
            var v: Number = java.lang.Float.valueOf(vvalue);
            if(v != vscroll.value)
            vscroll.value = v;
        }
    }
    var hval = bind hscroll.value  on replace {
        hvalue = "{hval}";
    }
    var vval = bind vscroll.value  on replace {
        vvalue = "{vval}";
    }
    title: "ScrollBar View Test"
    scene: Scene {
        width: 840
        height: 800
        stylesheets: "{__DIR__}Scroll.css"
        fill: Color.YELLOW
        content: XGrid {
            hgap: 10
            vgap: 10
            rows: [
                row([
                    XScrollView {
                        layoutInfo : LayoutInfo {
                            height: 200
                            width: 200
                        }
                        position: ScrollPosition.TOP
                        node: ANode{content: "Top" }
                    },
                    XScrollView {
                        layoutInfo : LayoutInfo {
                            height: 200
                            width: 200
                        }
                        position: ScrollPosition.BOTTOM
                        node: ANode{content: "Bottom" }
                    },
                    XScrollView {
                        layoutInfo : LayoutInfo {
                            height: 200
                            width: 200
                        }
                        position: ScrollPosition.LEFT
                        node: ANode{content: "Left"  }
                    },
                    XScrollView {
                        layoutInfo : LayoutInfo {
                            height: 200
                            width: 200
                        }
                        position: ScrollPosition.RIGHT
                        node: ANode{content: "Right"  }
                    }
                ]),
                row([
                    XScrollView {
                        layoutInfo : LayoutInfo {
                            height: 200
                            width: 200
                        }
                        position: ScrollPosition.TOP_LEFT
                        node: ANode{content: "Top\nLeft" }
                    },
                    XScrollView {
                        layoutInfo : LayoutInfo {
                            height: 200
                            width: 200
                        }
                        position: ScrollPosition.TOP_RIGHT
                        node: ANode{content: "Top\nRight" }
                    },
                    XScrollView {
                        layoutInfo : LayoutInfo {
                            height: 200
                            width: 200
                        }
                        position: ScrollPosition.BOTTOM_LEFT
                        node: ANode{content: "Bottom\nLeft" }
                    },
                    XScrollView {
                        layoutInfo : LayoutInfo {
                            height: 200
                            width: 200
                        }
                        position: ScrollPosition.BOTTOM_RIGHT
                        node: ANode{content: "Bottom\nRight" }
                    }
                ]),
                row([
                    XScrollView {
                        layoutInfo : LayoutInfo {
                            height: 200
                            width: 200
                        }
                        position: ScrollPosition.BOTTOM_RIGHT
                        node: ANode{content: "Wider" height: 150}
                    },
                    XScrollView {
                        layoutInfo : LayoutInfo {
                            height: 200
                            width: 200
                        }
                        position: ScrollPosition.BOTTOM_RIGHT
                        node: ANode{content: "Taller" width: 150}
                    },
                ]),
            ]
        }
    }
}