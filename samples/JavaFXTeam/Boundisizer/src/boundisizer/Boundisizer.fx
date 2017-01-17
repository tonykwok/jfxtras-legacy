/*
 * Copyright (c) 2009, Amy Fowler
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
package boundisizer;

import java.text.DecimalFormat;

import javafx.stage.Stage;
import javafx.geometry.*;
import javafx.scene.*;
import javafx.scene.control.*;
import javafx.scene.effect.*;
import javafx.scene.layout.*;
import javafx.scene.paint.*;
import javafx.scene.shape.*;
import javafx.scene.transform.Rotate;
import javafx.scene.transform.Scale;
import javafx.scene.transform.Translate;

/**
 * Little demo which shows how node bounds are affected when
 * tweaking various node variables
 *
 * @author aim
 */
 def LabelLAYOUT = LayoutInfo { width: 150 hpos: HPos.RIGHT };
 def SliderLAYOUT = LayoutInfo { width: 70 };
 def MARGIN = 4;
 def f = new DecimalFormat("0.0#");

Stage {
    var scene:Scene;
    var canvas:Panel;
    var rect:Rectangle;

    var xySlider:Slider;
    var sizeSlider:Slider;
    var strokeWidthSlider:Slider;
    var effectCheckBox:CheckBox;
    var clipCheckBox:CheckBox;
    var scaleSlider:Slider;
    var rotateSlider:Slider;
    var translateXSlider:Slider;
    var translateYSlider:Slider;
    var visibleCheckBox:CheckBox;

    var localGridCheckBox:CheckBox;
    var parentGridCheckBox:CheckBox;
    var localBoundsCheckBox:CheckBox;
    var layoutBoundsCheckBox:CheckBox;
    var parentBoundsCheckBox:CheckBox;

    title: "Boundisizer"
    scene: Scene {
        width: 640
        height: 300
        content: HBox {
            width: bind scene.width
            height: bind scene.height
            content: [
                VBox {
                    layoutInfo: LayoutInfo { width: 340 height: 300 }
                    spacing: 2
                    content: [
                        Rectangle {
                            fill: Color.TRANSPARENT
                            height: 2
                        }
                        HBox {
                            spacing: MARGIN
                            content: [
                                Label { text: "Show Local Grid"
                                    textFill: Color.BLUE
                                    layoutInfo: LabelLAYOUT hpos: HPos.RIGHT}
                                localGridCheckBox = CheckBox { }
                            ]
                        }
                        HBox {
                            spacing: MARGIN
                            content: [
                                Label { text: "Show Parent Grid"
                                    textFill: Color.RED
                                    layoutInfo: LabelLAYOUT hpos: HPos.RIGHT}
                                parentGridCheckBox = CheckBox { selected: true }
                            ]
                        }
                        Rectangle {
                            fill: Color.TRANSPARENT
                            height: MARGIN
                        }
                        HBox {
                            spacing: MARGIN
                            content: [
                                Label { text: "X/Y:" layoutInfo: LabelLAYOUT hpos: HPos.RIGHT },
                                xySlider = Slider { translateY: 2 min: 0 max: 200 value: 100 layoutInfo: SliderLAYOUT}
                                Label { text: bind "{xySlider.value}" }
                            ]
                        }
                        HBox {
                            spacing: MARGIN
                            content: [
                                Label { text: "Width/Height" layoutInfo: LabelLAYOUT hpos: HPos.RIGHT },
                                sizeSlider = Slider { translateY: 2 min: 0 max: 100 value: 50 layoutInfo: SliderLAYOUT}
                                Label { text: bind "{sizeSlider.value + 50}" }
                            ]
                        }
                        HBox {
                            spacing: MARGIN
                            content: [
                                Label { text: "Stroke Width" layoutInfo: LabelLAYOUT hpos: HPos.RIGHT },
                                strokeWidthSlider = Slider { translateY: 2 min: 0 max: 10 value: 0 layoutInfo: SliderLAYOUT}
                                Label { text: bind "{strokeWidthSlider.value}" }
                            ]
                        }
                        HBox {
                            spacing: MARGIN
                            content: [
                                Label { text: "Effect" layoutInfo: LabelLAYOUT hpos: HPos.RIGHT}
                                effectCheckBox = CheckBox { }
                            ]
                        }
                        HBox {
                            spacing: MARGIN
                            content: [
                                Label { text: "Clip" layoutInfo: LabelLAYOUT hpos: HPos.RIGHT}
                                clipCheckBox = CheckBox { }
                            ]
                        }
                        HBox {
                            spacing: MARGIN
                            content: [
                                Label { text: "Rotate" layoutInfo: LabelLAYOUT hpos: HPos.RIGHT },
                                rotateSlider = Slider { translateY: 2 min: 0 max: 360 value: 0 layoutInfo: SliderLAYOUT}
                                Label { text: bind "{rotateSlider.value}" }
                            ]
                        }
                        HBox {
                            spacing: MARGIN
                            content: [
                                Label { text: "Scale" layoutInfo: LabelLAYOUT hpos: HPos.RIGHT },
                                scaleSlider = Slider { translateY: 2 min: 0 max: 100 value: 50 layoutInfo: SliderLAYOUT }
                                Label { text: bind "{(scaleSlider.value + 50)/100}" }
                            ]
                        }
                        HBox {
                            spacing: MARGIN
                            content: [
                                Label { text: "translateX" layoutInfo: LabelLAYOUT hpos: HPos.RIGHT },
                                translateXSlider = Slider { translateY: 2 min: 0 max: 50 value: 0 layoutInfo: SliderLAYOUT }
                                Label { text: bind "{translateXSlider.value}" }
                            ]
                        }
                        HBox {
                            spacing: MARGIN
                            content: [
                                Label { text: "translateY" layoutInfo: LabelLAYOUT hpos: HPos.RIGHT },
                                translateYSlider = Slider { translateY: 2 min: 0 max: 50 value: 0 layoutInfo: SliderLAYOUT }
                                Label { text: bind "{translateYSlider.value}" }
                            ]
                        }
                        HBox {
                            spacing: MARGIN
                            content: [
                                Label { text: "Visible" layoutInfo: LabelLAYOUT hpos: HPos.RIGHT}
                                visibleCheckBox = CheckBox { selected: true }
                            ]
                        }
                        Rectangle {
                            fill: Color.TRANSPARENT
                            height: MARGIN
                        }
                        HBox {
                            spacing: MARGIN
                            content: [
                                Label { text: "Show Local Bounds"
                                    textFill: Color.BLUE
                                    layoutInfo: LabelLAYOUT hpos: HPos.RIGHT}
                                localBoundsCheckBox = CheckBox { }
                                Label { 
                                    textFill: Color.BLUE
                                    text: bind "{f.format(rect.boundsInLocal.minX)},{f.format(rect.boundsInLocal.minY)} {f.format(rect.boundsInLocal.width)}x{f.format(rect.boundsInLocal.height)}"
                                    visible: bind localBoundsCheckBox.selected
                                }
                            ]
                        }
                        HBox {
                            spacing: MARGIN
                            content: [
                                Label { text: "Show Bounds in Parent"
                                textFill: Color.RED
                                layoutInfo: LabelLAYOUT hpos: HPos.RIGHT}
                                parentBoundsCheckBox = CheckBox { }
                                Label { 
                                    textFill: Color.RED
                                    text: bind "{f.format(rect.boundsInParent.minX)},{f.format(rect.boundsInParent.minY)} {f.format(rect.boundsInParent.width)}x{f.format(rect.boundsInParent.height)}"
                                    visible: bind parentBoundsCheckBox.selected
                                }
                            ]
                        }
                        HBox {
                            spacing: MARGIN
                            content: [
                                Label { text: "Show Layout Bounds"
                                    textFill: Color.GREEN
                                    layoutInfo: LabelLAYOUT hpos: HPos.RIGHT}
                                layoutBoundsCheckBox = CheckBox { }
                                Label { 
                                    textFill: Color.GREEN
                                    text: bind "{f.format(rect.layoutBounds.minX)},{f.format(rect.layoutBounds.minY)} {f.format(rect.layoutBounds.width)}x{f.format(rect.layoutBounds.height)}"
                                    visible: bind layoutBoundsCheckBox.selected
                                }
                            ]
                        }                        
                    ]
                }
                canvas = Panel {
                    prefHeight: function(width:Number):Number { 300 }
                    prefWidth: function(height:Number):Number { 300 }
                    clip: Rectangle { width: 300 height: 300 }
                    content: [
                        LineGrid {
                            id: "parent-grid"
                            lineStroke: Color.rgb(255,0,0,.3);
                            width : bind canvas.width
                            height :bind canvas.height
                            visible: bind parentGridCheckBox.selected
                        }
                        LineGrid {
                            id: "rect-grid"
                            lineStroke: Color.rgb(0,0,255,.5)
                            opacity: .8
                            width: bind rect.boundsInLocal.width + 400
                            height: bind rect.boundsInLocal.height + 400
                            visible: bind localGridCheckBox.selected
                            transforms: [
                                // need to keep grid in sync with coordinate space of rectangle
                                // as it scales/rotates
                                Translate {
                                    x: bind rect.boundsInLocal.minX + (rect.boundsInLocal.width/2)
                                    y: bind rect.boundsInLocal.minY + (rect.boundsInLocal.height/2)
                                }
                                Scale {
                                    x: bind (scaleSlider.value + 50)/100 y: bind (scaleSlider.value + 50)/100
                                }
                                Rotate {
                                    angle: bind rotateSlider.value
                                }
                                Translate {
                                    x: bind -(rect.boundsInLocal.minX + (rect.boundsInLocal.width/2))
                                    y: bind -(rect.boundsInLocal.minY + (rect.boundsInLocal.height/2))
                                }
                            ]
                            translateX: bind translateXSlider.value
                            translateY: bind translateYSlider.value
                        }
                        rect = Rectangle {
                            id: "rect"
                            opacity: .50
                            x: bind xySlider.value
                            y: bind xySlider.value
                            arcWidth:  40
                            arcHeight: 40
                            width: bind sizeSlider.value + 50
                            height: bind sizeSlider.value + 50
                            strokeWidth: bind strokeWidthSlider.value
                            stroke: bind if (rect.strokeWidth > 0) then Color.BLACK else null
                            fill: Color.rgb(100, 100, 255)
                            effect: bind if (effectCheckBox.selected) DropShadow { offsetX:10 offsetY: 10 } else null
                            clip: bind if (clipCheckBox.selected) Ellipse { centerX: 150 centerY: 150 radiusX: 25 radiusY: 15 } else null
                            scaleX: bind (scaleSlider.value + 50)/100
                            scaleY: bind (scaleSlider.value + 50)/100
                            rotate: bind rotateSlider.value
                            translateX: bind translateXSlider.value
                            translateY: bind translateYSlider.value
                            visible: bind visibleCheckBox.selected
                         }
                         Rectangle {
                            id: "boundsInLocal-rect"
                            x: bind rect.boundsInLocal.minX
                            y: bind rect.boundsInLocal.minY
                            width: bind rect.boundsInLocal.width
                            height: bind rect.boundsInLocal.height
                            fill: null
                            strokeWidth: 2
                            stroke: Color.BLUE
                            visible: bind localBoundsCheckBox.selected
                            scaleX: bind (scaleSlider.value + 50)/100
                            scaleY: bind (scaleSlider.value + 50)/100
                            rotate: bind rotateSlider.value
                            translateX: bind translateXSlider.value
                            translateY: bind translateYSlider.value
                        }
                        Rectangle {
                            id: "boundsInParent-rect"
                            x: bind rect.boundsInParent.minX
                            y: bind rect.boundsInParent.minY
                            width: bind rect.boundsInParent.width
                            height: bind rect.boundsInParent.height
                            fill: null
                            strokeWidth: 2
                            stroke: Color.RED
                            visible: bind parentBoundsCheckBox.selected
                        }
                        Rectangle {
                            id: "layoutBounds-rect"
                            x: bind rect.layoutBounds.minX
                            y: bind rect.layoutBounds.minY
                            width: bind rect.layoutBounds.width
                            height: bind rect.layoutBounds.height
                            fill: null
                            strokeWidth: 2
                            strokeDashArray: [3,3]
                            stroke: Color.GREEN
                            visible: bind layoutBoundsCheckBox.selected
                        }
                    ]
                }
            ]
        }
    }
}