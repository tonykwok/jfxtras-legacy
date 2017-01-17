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
package org.jfxtras.util;

import org.jfxtras.test.*;
import org.jfxtras.test.Expect.*;
import javafx.geometry.*;

/**
 * @author Stephen Chin
 */
public class GeometryUtilTest extends Test {}

public function run() {
    var canonicalJavaFXPoint = Point2D {x: 1, y: 2};
    var canonicalJavaPoint = new java.awt.Point(1, 2);
    var canonicalJavaFXRectangle = Rectangle2D {minX: 1, minY: 2, width: 3, height: 4};
    var canonicalJavaRectangle = new java.awt.Rectangle(1, 2, 3, 4);
    perform("We should be able to convert from", [
        Test {
            say: "a JavaFX point to a Java point"
            do: function() {
                GeometryUtil.pointToJava(canonicalJavaFXPoint);
            }
            expect: [
                instanceOf("java.awt.geom.Point2D"),
                equalTo(canonicalJavaPoint)
            ]
        },
        Test {
            say: "a null JavaFX point to a Java point"
            do: function() {
                GeometryUtil.pointToJava(null);
            }
            expect: equalTo(null)
        },
        Test {
            say: "a Java point to a JavaFX point"
            do: function() {
                GeometryUtil.pointToJavaFX(canonicalJavaPoint);
            }
            expect: [
                instanceOf("javafx.geometry.Point2D"),
                equalTo(canonicalJavaFXPoint)
            ]
        }
        Test {
            say: "a null Java point to a JavaFX point"
            do: function() {
                GeometryUtil.pointToJavaFX(null);
            }
            expect: equalTo(null)
        }
        Test {
            say: "a JavaFX rectangle to a Java rectangle"
            do: function() {
                GeometryUtil.rectangleToJava(canonicalJavaFXRectangle);
            }
            expect: [
                instanceOf("java.awt.geom.Rectangle2D"),
                equalTo(canonicalJavaRectangle)
            ]
        },
        Test {
            say: "a null JavaFX rectangle to a Java rectangle"
            do: function() {
                GeometryUtil.rectangleToJava(null);
            }
            expect: equalTo(null)
        },
        Test {
            say: "a Java rectangle to a JavaFX rectangle"
            do: function() {
                GeometryUtil.rectangleToJavaFX(canonicalJavaRectangle);
            }
            expect: [
                instanceOf("javafx.geometry.Rectangle2D"),
                equalTo(canonicalJavaFXRectangle)
            ]
        }
        Test {
            say: "a null Java rectangle to a JavaFX rectangle"
            do: function() {
                GeometryUtil.rectangleToJavaFX(null);
            }
            expect: equalTo(null)
        }
    ]);
}
