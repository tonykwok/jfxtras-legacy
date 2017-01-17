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
package org.jfxtras.scene.layout;

import javafx.geometry.BoundingBox;
import javafx.scene.Node;
import javafx.scene.Group;
import javafx.scene.control.Label;
import javafx.scene.shape.Rectangle;
import javafx.scene.text.Text;
import org.jfxtras.scene.shape.ResizableRectangle;
import org.jfxtras.scene.layout.XLayoutInfo;
import org.jfxtras.scene.layout.XLayoutInfo.*;
import org.jfxtras.test.Test;
import org.jfxtras.test.Expect.*;

/**
 * @author Stephen Chin
 */
public class XContainerTest extends Test {}

function getParentBounds(node:Node) {
    node.localToParent(node.layoutBounds);
}

public function run() {
    perform("XContainer", [
        Test {
            say: "resizing should"
            test: [
                Test {
                    say: "not resize non-resizable nodes"
                    do: function() {
                        var node = Rectangle {width: 50, height: 52}
                        XContainer.layoutNode(node, 0, 0, 100, 100, null, null);
                        return getParentBounds(node);
                    }
                    expect: equalTo(BoundingBox {minX: 25, minY: 24, width: 50, height: 52})
                }
                Test {
                    say: "resize resizable nodes"
                    do: function() {
                        var node = ResizableRectangle {}
                        XContainer.layoutNode(node, 0, 0, 100, 102, null, null);
                        return getParentBounds(node);
                    }
                    expect: equalTo(BoundingBox {width: 100, height: 102})
                }
                Test {
                    say: "never get larger than max"
                    do: function() {
                        var node = ResizableRectangle {
                            override public function getMaxWidth() {100}
                            override public function getMaxHeight() {102}
                        }
                        XContainer.layoutNode(node, 0, 0, 200, 204, null, null);
                        return getParentBounds(node);
                    }
                    expect: equalTo(BoundingBox {minX: 50, minY: 51, width: 100, height: 102})
                }
                Test {
                    say: "never get smaller than min"
                    do: function() {
                        var node = ResizableRectangle {
                            override public function getMinWidth() {20}
                            override public function getMinHeight() {22}
                        }
                        XContainer.layoutNode(node, 0, 0, 10, 11, null, null);
                        return getParentBounds(node);
                    }
                    expect: equalTo(BoundingBox {minX: -5, minY: -5.5, width: 20, height: 22})
                }
                Test {
                    say: "never get larger than pref (when not filling)"
                    do: function() {
                        var node = ResizableRectangle {
                            override public function getPrefWidth(height) {100}
                            override public function getPrefHeight(width) {102}
                            override public function getHFill() {false}
                            override public function getVFill() {false}
                        }
                        XContainer.layoutNode(node, 0, 0, 200, 204, null, null);
                        return getParentBounds(node);
                    }
                    expect: equalTo(BoundingBox {minX: 50, minY: 51, width: 100, height: 102})
                }
            ]
        }
        Test {
            say: "margins should"
            test: [
                Test {
                    say: "use margin"
                    do: function() {
                        var node = ResizableRectangle {layoutInfo: XLayoutInfo {margin: insets(10)}}
                        XContainer.layoutNode(node, 0, 0, 100, 100, null, null);
                        return getParentBounds(node);
                    }
                    expect: equalTo(BoundingBox {minX: 10, minY: 10, width: 80, height: 80})
                }
            ]
        }
        Test {
            say: "getNodeHPos should"
            test: [
                Test {
                    say: "return the layoutInfo value first"
                    do: function() {XContainer.getNodeHPos(ResizableRectangle {layoutInfo: XLayoutInfo {hpos: RIGHT}}, LEFT)}
                    expect: equalTo(RIGHT)
                }
                Test {
                    say: "return the fallback second"
                    do: function() {XContainer.getNodeHPos(Label {}, RIGHT)}
                    expect: equalTo(RIGHT)
                }
                Test {
                    say: "return the global default last"
                    do: function() {XContainer.getNodeHPos(Group {})}
                    expect: equalTo(null)
                }
            ]
        }
        Test {
            say: "getNodeVPos should"
            test: [
                Test {
                    say: "return the layoutInfo value first"
                    do: function() {XContainer.getNodeVPos(ResizableRectangle {layoutInfo: XLayoutInfo {vpos: BOTTOM}}, TOP)}
                    expect: equalTo(BOTTOM)
                }
                Test {
                    say: "return the fallback second"
                    do: function() {XContainer.getNodeVPos(Text {}, BOTTOM)}
                    expect: equalTo(BOTTOM)
                }
                Test {
                    say: "return the global default last"
                    do: function() {XContainer.getNodeVPos(Group {})}
                    expect: equalTo(null)
                }
            ]
        }
        Test {
            say: "getNodeMaxHeight should"
            test: [
                Test {
                    say: "return the layoutInfo value first"
                    do: function() {XContainer.getNodeMaxHeight(ResizableRectangle {
                            layoutInfo: XLayoutInfo {maxHeight: 33}
                            override public function getMaxHeight() {83}
                    })}
                    expect: equalTo(33.0)
                }
                Test {
                    say: "return the Resizable default last"
                    do: function() {XContainer.getNodeMaxHeight(ResizableRectangle {
                            override public function getMaxHeight() {83}
                    })}
                    expect: equalTo(83.0)
                }
                Test {
                    say: "return the layoutInfo height for non-Resizable nodes"
                    do: function() {XContainer.getNodeMaxHeight(Rectangle {width: 52, height: 24})}
                    expect: equalTo(24.0)
                }
            ]
        }
        Test {
            say: "getNodeMaxWidth should"
            test: [
                Test {
                    say: "return the layoutInfo value first"
                    do: function() {XContainer.getNodeMaxWidth(ResizableRectangle {
                            layoutInfo: XLayoutInfo {maxWidth: 33}
                            override public function getMaxWidth() {83}
                    })}
                    expect: equalTo(33.0)
                }
                Test {
                    say: "return the Resizable default last"
                    do: function() {XContainer.getNodeMaxWidth(ResizableRectangle {
                            override public function getMaxWidth() {83}
                    })}
                    expect: equalTo(83.0)
                }
                Test {
                    say: "return the layoutInfo width for non-Resizable nodes"
                    do: function() {XContainer.getNodeMaxWidth(Rectangle {width: 52, height: 24})}
                    expect: equalTo(52.0)
                }
            ]
        }
        Test {
            say: "getNodeMinHeight should"
            test: [
                Test {
                    say: "return the layoutInfo value first"
                    do: function() {XContainer.getNodeMinHeight(ResizableRectangle {
                            layoutInfo: XLayoutInfo {minHeight: 33}
                            override public function getMinHeight() {83}
                    })}
                    expect: equalTo(33.0)
                }
                Test {
                    say: "return the Resizable default last"
                    do: function() {XContainer.getNodeMinHeight(ResizableRectangle {
                            override public function getMinHeight() {83}
                    })}
                    expect: equalTo(83.0)
                }
                Test {
                    say: "return the layoutInfo height for non-Resizable nodes"
                    do: function() {XContainer.getNodeMinHeight(Rectangle {width: 52, height: 24})}
                    expect: equalTo(24.0)
                }
            ]
        }
        Test {
            say: "getNodeMinWidth should"
            test: [
                Test {
                    say: "return the layoutInfo value first"
                    do: function() {XContainer.getNodeMinWidth(ResizableRectangle {
                            layoutInfo: XLayoutInfo {minWidth: 33}
                            override public function getMinWidth() {83}
                    })}
                    expect: equalTo(33.0)
                }
                Test {
                    say: "return the Resizable default last"
                    do: function() {XContainer.getNodeMinWidth(ResizableRectangle {
                            override public function getMinWidth() {83}
                    })}
                    expect: equalTo(83.0)
                }
                Test {
                    say: "return the layoutInfo width for non-Resizable nodes"
                    do: function() {XContainer.getNodeMinWidth(Rectangle {width: 52, height: 24})}
                    expect: equalTo(52.0)
                }
            ]
        }
        Test {
            say: "getNodePrefHeight should"
            test: [
                Test {
                    say: "return the layoutInfo value first"
                    do: function() {XContainer.getNodePrefHeight(ResizableRectangle {
                            layoutInfo: XLayoutInfo {height: 33}
                            override public function getPrefHeight(width) {83}
                    })}
                    expect: equalTo(33.0)
                }
                Test {
                    say: "return the Resizable default last"
                    do: function() {XContainer.getNodePrefHeight(ResizableRectangle {
                            override public function getPrefHeight(width) {83}
                    })}
                    expect: equalTo(83.0)
                }
                Test {
                    say: "return the layoutInfo height for non-Resizable nodes"
                    do: function() {XContainer.getNodePrefHeight(Rectangle {width: 52, height: 24})}
                    expect: equalTo(24.0)
                }
            ]
        }
        Test {
            say: "getNodePrefWidth should"
            test: [
                Test {
                    say: "return the layoutInfo value first"
                    do: function() {XContainer.getNodePrefWidth(ResizableRectangle {
                            layoutInfo: XLayoutInfo {width: 33}
                            override public function getPrefWidth(height) {83}
                    })}
                    expect: equalTo(33.0)
                }
                Test {
                    say: "return the Resizable default last"
                    do: function() {XContainer.getNodePrefWidth(ResizableRectangle {
                            override public function getPrefWidth(height) {83}
                    })}
                    expect: equalTo(83.0)
                }
                Test {
                    say: "return the layoutInfo width for non-Resizable nodes"
                    do: function() {XContainer.getNodePrefWidth(Rectangle {width: 52, height: 24})}
                    expect: equalTo(52.0)
                }
            ]
        }
        Test {
            say: "getNodeFill should"
            test: [
                Test {
                    say: "return the global default last"
                    do: function() {XContainer.getNodeHFill(Group {})}
                    expect: equalTo(false)
                }
                Test {
                    say: "return the node default next"
                    do: function() {XContainer.getNodeHFill(ResizableRectangle {})}
                    expect: equalTo(true)
                }
                Test {
                    say: "return the layoutInfo value first"
                    do: function() {XContainer.getNodeHFill(ResizableRectangle {layoutInfo: XLayoutInfo {hfill: false}})}
                    expect: equalTo(false)
                }
            ]
        }
        Test {
            say: "getNodeHGrow should"
            test: [
                Test {
                    say: "return the global default last"
                    do: function() {XContainer.getNodeHGrow(Group {})}
                    expect: equalTo(NEVER)
                }
                Test {
                    say: "return the node default next"
                    do: function() {XContainer.getNodeHGrow(ResizableRectangle {})}
                    expect: equalTo(SOMETIMES)
                }
                Test {
                    say: "return the layoutInfo value first"
                    do: function() {XContainer.getNodeHGrow(ResizableRectangle {layoutInfo: XLayoutInfo {hgrow: ALWAYS}})}
                    expect: equalTo(ALWAYS)
                }
            ]
        }
        Test {
            say: "getNodeVGrow should"
            test: [
                Test {
                    say: "return the global default last"
                    do: function() {XContainer.getNodeVGrow(Group {})}
                    expect: equalTo(NEVER)
                }
                Test {
                    say: "return the node default next"
                    do: function() {XContainer.getNodeVGrow(ResizableRectangle {})}
                    expect: equalTo(SOMETIMES)
                }
                Test {
                    say: "return the layoutInfo value first"
                    do: function() {XContainer.getNodeVGrow(ResizableRectangle {layoutInfo: XLayoutInfo {vgrow: ALWAYS}})}
                    expect: equalTo(ALWAYS)
                }
            ]
        }
        Test {
            say: "getNodeHShrink should"
            test: [
                Test {
                    say: "return the global default last"
                    do: function() {XContainer.getNodeHShrink(Group {})}
                    expect: equalTo(NEVER)
                }
                Test {
                    say: "return the node default next"
                    do: function() {XContainer.getNodeHShrink(ResizableRectangle {})}
                    expect: equalTo(ALWAYS)
                }
                Test {
                    say: "return the layoutInfo value first"
                    do: function() {XContainer.getNodeHShrink(ResizableRectangle {layoutInfo: XLayoutInfo {hshrink: NEVER}})}
                    expect: equalTo(NEVER)
                }
            ]
        }
        Test {
            say: "getNodeVShrink should"
            test: [
                Test {
                    say: "return the global default last"
                    do: function() {XContainer.getNodeVShrink(Group {})}
                    expect: equalTo(NEVER)
                }
                Test {
                    say: "return the node default next"
                    do: function() {XContainer.getNodeVShrink(ResizableRectangle {})}
                    expect: equalTo(ALWAYS)
                }
                Test {
                    say: "return the layoutInfo value first"
                    do: function() {XContainer.getNodeVShrink(ResizableRectangle {layoutInfo: XLayoutInfo {vshrink: NEVER}})}
                    expect: equalTo(NEVER)
                }
            ]
        }
        Test {
            say: "defaults should"
        }
        Test {
            say: "maxPriority should return the greatest value"
            do: function() {
                XContainer.maxPriority([NEVER, ALWAYS, SOMETIMES])
            }
            expect: equalTo(ALWAYS)
        }
        Test {
            say: "minPriority should return the least value"
            do: function() {
                XContainer.minPriority([NEVER, ALWAYS, SOMETIMES])
            }
            expect: equalTo(NEVER)
        }
    ]);
}
