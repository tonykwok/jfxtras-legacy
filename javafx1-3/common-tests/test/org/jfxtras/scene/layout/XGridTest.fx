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

import javafx.geometry.Bounds;
import javafx.geometry.BoundingBox;
import javafx.scene.Node;
import org.jfxtras.test.Test;
import org.jfxtras.test.Expect.*;
import org.jfxtras.scene.layout.XGridLayoutInfo.*;
import org.jfxtras.scene.shape.ResizableRectangle;


/**
 * @author Stephen Chin
 * @author Keith Combs
 *
 * - Additional Test Cases:
 * - percentages - add unit tests (and make sure they do what I want)
 * - span - make sure span doesn't push the row end
 * - span - make sure spanned cell constraints are honored
 * - rowspan - need some tests for this
 * - spanToRowEnd - need some more tests for this
 */
public class XGridTest extends Test {}

function getParentBounds(node:Node) {
    node.localToParent(node.layoutBounds);
}

public function gridSingle(node:Node):Bounds {
    XGrid {
        width: 100, height: 100
        rows: row(node)
    }.doLayout();
    return getParentBounds(node);
}

public function gridHorizontal(nodes:Node[]):Bounds[] {
    gridHorizontal(nodes, 0);
}

public function gridHorizontal(nodes:Node[], gap:Integer):Bounds[] {
    XGrid {
        hgap: gap
        width: 100, height: 100
        rows: row(nodes)
    }.doLayout();
    return for (node in nodes) getParentBounds(node);
}

public function gridVertical(nodes:Node[]):Bounds[] {
    gridVertical(nodes, 0);
}

public function gridVertical(nodes:Node[], gap:Integer):Bounds[] {
    XGrid {
        vgap: gap
        width: 100, height: 100
        rows: for (node in nodes) row(node)
    }.doLayout();
    return for (node in nodes) getParentBounds(node);
}

public function grid(rows:XGridRow[]):Bounds[] {
    grid(rows, 0);
}

public function grid(rows:XGridRow[], columns:XGridColumn[]):Bounds[] {
    grid(rows, columns, 0);
}

public function grid(rows:XGridRow[], gap:Integer):Bounds[] {
    grid(rows, null, gap);
}

public function grid(rows:XGridRow[], columns:XGridColumn[], gap:Integer):Bounds[] {
    XGrid {
        hgap: gap
        vgap: gap
        width: 100, height: 100
        rows: rows
        columns: columns
    }.doLayout();
    return for (row in rows, node in row.cells) getParentBounds(node);
}

public function run() {
    perform("XContainer should", [
        Test {
            say: "layout a Rectangle"
            do: function() {
                gridSingle(ResizableRectangle {})
            }
            expect: equalTo(BoundingBox {width: 100, height: 100})
        }
        Test {
            say: "layout a Rectangle with margins"
            do: function() {
                gridSingle(ResizableRectangle {
                    layoutInfo: XLayoutInfo {margin: insets(10)}
                })
            }
            expect: equalTo(BoundingBox {minX: 10, minY: 10, width: 80, height: 80})
        }
        Test {
            say: "never shrink when shrink is NEVER"
            do: function() {
                gridSingle(ResizableRectangle {
                    layoutInfo: XLayoutInfo {hshrink: NEVER, vshrink: NEVER}
                })
            }
            expect: equalTo(BoundingBox {width: 200, height: 200})
        }
        Test {
            say: "shrink ALWAYS equally horizontal"
            do: function() {
                gridHorizontal([
                    ResizableRectangle {
                        layoutInfo: XLayoutInfo {hshrink: ALWAYS, vshrink: ALWAYS}
                    }
                    ResizableRectangle {
                        layoutInfo: XLayoutInfo {hshrink: ALWAYS, vshrink: ALWAYS}
                    }
                ]) as Object
            }
            expect: equalTo([BoundingBox {width: 50, height: 100}, BoundingBox {minX: 50, width: 50, height: 100}])
        }
        Test {
            say: "shrink ALWAYS equally vertical"
            do: function() {
                gridVertical([
                    ResizableRectangle {
                        layoutInfo: XLayoutInfo {hshrink: ALWAYS, vshrink: ALWAYS}
                    }
                    ResizableRectangle {
                        layoutInfo: XLayoutInfo {hshrink: ALWAYS, vshrink: ALWAYS}
                    }
                ]) as Object
            }
            expect: equalTo([BoundingBox {width: 100, height: 50}, BoundingBox {minY: 50, width: 100, height: 50}])
        }
        Test {
            say: "shrink SOMETIMES equally horizontal"
            do: function() {
                gridHorizontal([
                    ResizableRectangle {
                        layoutInfo: XLayoutInfo {hshrink: SOMETIMES, vshrink: SOMETIMES}
                    }
                    ResizableRectangle {
                        layoutInfo: XLayoutInfo {hshrink: SOMETIMES, vshrink: SOMETIMES}
                    }
                ]) as Object
            }
            expect: equalTo([BoundingBox {width: 50, height: 100}, BoundingBox {minX: 50, width: 50, height: 100}])
        }
        Test {
            say: "shrink SOMETIMES equally vertical"
            do: function() {
                gridVertical([
                    ResizableRectangle {
                        layoutInfo: XLayoutInfo {hshrink: SOMETIMES, vshrink: SOMETIMES}
                    }
                    ResizableRectangle {
                        layoutInfo: XLayoutInfo {hshrink: SOMETIMES, vshrink: SOMETIMES}
                    }
                ]) as Object
            }
            expect: equalTo([BoundingBox {width: 100, height: 50}, BoundingBox {minY: 50, width: 100, height: 50}])
        }
        Test {
            say: "shrink ALWAYS before SOMETIMES horizontal"
            do: function() {
                gridHorizontal([
                    ResizableRectangle {
                        layoutInfo: XLayoutInfo {hshrink: SOMETIMES, vshrink: SOMETIMES}
                    }
                    ResizableRectangle {
                        layoutInfo: XLayoutInfo {hshrink: ALWAYS, vshrink: ALWAYS}
                    }
                ]) as Object
            }
            expect: equalTo([BoundingBox {width: 100, height: 100}, BoundingBox {minX: 100, width: 0, height: 100}])
        }
        Test {
            say: "shrink ALWAYS before SOMETIMES vertical"
            do: function() {
                gridVertical([
                    ResizableRectangle {
                        layoutInfo: XLayoutInfo {hshrink: SOMETIMES, vshrink: SOMETIMES}
                    }
                    ResizableRectangle {
                        layoutInfo: XLayoutInfo {hshrink: ALWAYS, vshrink: ALWAYS}
                    }
                ]) as Object
            }
            expect: equalTo([BoundingBox {width: 100, height: 100}, BoundingBox {minY: 100, width: 100, height: 0}])
        }
        Test {
            say: "shrink ALWAYS up to SOMETIMES horizontal"
            do: function() {
                grid([
                    row([
                        ResizableRectangle {
                            layoutInfo: XLayoutInfo {hshrink: ALWAYS, vshrink: SOMETIMES, width: 75}
                        }
                        ResizableRectangle {
                            layoutInfo: XLayoutInfo {hshrink: ALWAYS, vshrink: SOMETIMES, width: 75}
                        }
                    ]),
                    row([
                        ResizableRectangle {
                            layoutInfo: XLayoutInfo {hshrink: SOMETIMES, vshrink: ALWAYS, width: 50}
                        }
                    ])
                ])[0..1] as Object
            }
            expect: equalTo([BoundingBox {width: 62.5, height: 100}, BoundingBox {minX: 62.5, width: 37.5, height: 100}])
        }
        Test {
            say: "shrink ALWAYS up to SOMETIMES vertical"
            do: function() {
                grid([
                    row([
                        ResizableRectangle {
                            layoutInfo: XLayoutInfo {hshrink: SOMETIMES, vshrink: ALWAYS, height: 75}
                        }
                        ResizableRectangle {
                            layoutInfo: XLayoutInfo {hshrink: ALWAYS, vshrink: SOMETIMES, height: 50}
                        }
                    ]),
                    row([
                        ResizableRectangle {
                            layoutInfo: XLayoutInfo {hshrink: SOMETIMES, vshrink: ALWAYS, height: 75}
                        }
                    ])
                ])[x|indexof x != 1] as Object
            }
            expect: equalTo([BoundingBox {width: 100, height: 62.5}, BoundingBox {minY: 62.5, width: 100, height: 37.5}])
        }
        Test {
            say: "shrink SOMETIMES up to NEVER horizontal"
            do: function() {
                grid([
                    row([
                        ResizableRectangle {
                            layoutInfo: XLayoutInfo {hshrink: SOMETIMES, vshrink: SOMETIMES, width: 75}
                        }
                        ResizableRectangle {
                            layoutInfo: XLayoutInfo {hshrink: SOMETIMES, vshrink: SOMETIMES, width: 75}
                        }
                    ]),
                    row([
                        ResizableRectangle {
                            layoutInfo: XLayoutInfo {hshrink: NEVER, vshrink: ALWAYS, width: 50}
                        }
                    ])
                ])[0..1] as Object
            }
            expect: equalTo([BoundingBox {width: 62.5, height: 100}, BoundingBox {minX: 62.5, width: 37.5, height: 100}])
        }
        Test {
            say: "shrink SOMETIMES up to NEVER vertical"
            do: function() {
                grid([
                    row([
                        ResizableRectangle {
                            layoutInfo: XLayoutInfo {hshrink: SOMETIMES, vshrink: SOMETIMES, height: 75}
                        }
                        ResizableRectangle {
                            layoutInfo: XLayoutInfo {hshrink: ALWAYS, vshrink: NEVER, height: 50}
                        }
                    ]),
                    row([
                        ResizableRectangle {
                            layoutInfo: XLayoutInfo {hshrink: SOMETIMES, vshrink: SOMETIMES, height: 75}
                        }
                    ])
                ])[x|indexof x != 1] as Object
            }
            expect: equalTo([BoundingBox {width: 100, height: 62.5}, BoundingBox {minY: 62.5, width: 100, height: 37.5}])
        }
        Test {
            say: "should skip over columns"
            do: function() {
                grid([
                    XGridRow {
                        cells: [ResizableRectangle {}, ResizableRectangle {}]
                    }
                    XGridRow {
                        column: 1
                        cells: ResizableRectangle {}
                    }
                ])[2]
            }
            expect: equalTo(BoundingBox {minX: 50, minY: 50, width: 50, height: 50})
        }
        Test {
            say: "should extend the grid by skipping"
            do: function() {
                grid([
                    XGridRow {
                        column: 10
                        cells: ResizableRectangle {}
                    }
                ])[0]
            }
            expect: equalTo(BoundingBox {width: 100, height: 100})
        }
        Test {
            say: "should honor Row preference for"
            test: [
                Test {
                    say: "minHeight"
                    do: function() {
                        grid([
                            XGridRow {
                                minHeight: 200
                                cells: ResizableRectangle {}
                            }
                        ])[0]
                    }
                    expect: equalTo(BoundingBox {width: 100, height: 200})
                }
                Test {
                    say: "height"
                    do: function() {
                        grid([
                            XGridRow {
                                vgrow: NEVER
                                height: 50
                                cells: ResizableRectangle {layoutInfo: XLayoutInfo {}}
                            }
                        ])[0]
                    }
                    expect: equalTo(BoundingBox {width: 100, height: 50})
                }
            ]
        }
        Test {
            say: "should honor Column preference for"
            test: [
                Test {
                    say: "minWidth"
                    do: function() {
                        grid(
                            XGridRow {
                                cells: ResizableRectangle {}
                            },
                            XGridColumn {
                                minWidth: 200
                            }
                        )[0]
                    }
                    expect: equalTo(BoundingBox {width: 200, height: 100})
                }
                Test {
                    say: "width"
                    do: function() {
                        grid(
                            XGridRow {
                                cells: ResizableRectangle {}
                            },
                            XGridColumn {
                                hgrow: NEVER
                                width: 50
                            }
                        )[0]
                    }
                    expect: equalTo(BoundingBox {width: 50, height: 100})
                }
            ]
        }
    ]);
}
