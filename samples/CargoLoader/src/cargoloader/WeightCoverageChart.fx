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

import javafx.scene.CustomNode;
import javafx.scene.chart.PieChart;
import javafx.scene.Group;
import javafx.scene.Node;
import javafx.scene.CacheHint;
import javafx.scene.effect.Glow;
import javafx.scene.effect.Shadow;
import javafx.scene.paint.Color;
import javafx.scene.shape.Rectangle;
import cargoloader.EnLargedWeightCoverage;
import javafx.scene.input.MouseEvent;
import cargoloader.PlanData;

/**
 * the pie chart showing weight on each section of the main deck of the aircraft.
 * @author Abhilshit Soni
 */
public class WeightCoverageChart extends CustomNode {

    public var anotherChart: Node;
    public var planData: PlanData;
    var pie = PieChart {
                titleFill: Color.WHITE
                scaleX: 0.45 scaleY: 0.48
                translateX: -130, translateY: 353
                id: "pie"
                title: "Weight Coverage"
                pieLabelFill: Color.WHITE
                data: [
                    //couldn't understand why it gets stucked when I have 0 as the data value or 0 in the 'then' condition of the "bind : if 0 then 1 else "
                    PieChart.Data {label: "A" value: bind (if ((planData.weightAR + planData.weightAL) == 0) then 0.0 else (planData.weightAR + planData.weightAL)) }
                    PieChart.Data {label: "B" value: bind (if ((planData.weightBR + planData.weightBL) == 0) then 0.0 else (planData.weightBR + planData.weightBL)) }
                    PieChart.Data {label: "C" value: bind (if ((planData.weightCR + planData.weightCL) == 0) then 0.0 else (planData.weightCR + planData.weightCL)) }
                    PieChart.Data {label: "D" value: bind (if ((planData.weightDR + planData.weightDL) == 0) then 0.0 else (planData.weightDR + planData.weightDL)) }
                    PieChart.Data {label: "E" value: bind (if ((planData.weightER + planData.weightEL) == 0) then 0.0 else (planData.weightER + planData.weightEL)) }
                    PieChart.Data {label: "F" value: bind (if ((planData.weightFR + planData.weightFL) == 0) then 0.0 else (planData.weightFR + planData.weightFL)) }
                    PieChart.Data {label: "G" value: bind (if ((planData.weightGR + planData.weightGL) == 0) then 0.0 else (planData.weightGR + planData.weightGL)) }
                    PieChart.Data {label: "H" value: bind (if ((planData.weightHR + planData.weightHL) == 0) then 0.0 else (planData.weightHR + planData.weightHL)) }
                    PieChart.Data {label: "I" value: bind (if ((planData.weightIR + planData.weightIL) == 0) then 0.0 else (planData.weightIR + planData.weightIL)) }
                    PieChart.Data {label: "Crew" value: PlanData.crewWeight }
                    PieChart.Data {label: "Fuel" value: PlanData.fuelWeight }
                ]
            }
    public var enlargedPie = EnLargedWeightCoverage {
                pie: bind this.pie
            };

    init {
        cache = true;
        onMouseClicked = function (e: MouseEvent): Void {
                    delete pie from scene.content;
                    pie.scaleX = 1;
                    pie.scaleY = 1;
                    pie.translateX = 200;
                    pie.translateY = 80;
                    delete pie from enlargedPie.finalGroup.content;
                    insert pie into scene.content;
                    insert enlargedPie into scene.content;
                    for (i in scene.content) {
                        // println("id's {id}");
                        if (i.id.equals("pie")) {
                            i.toFront();
                            break;
                        }

                    }
                }
    }

    var pieBorder = Rectangle {
                scaleX: 0.52 scaleY: 0.50
                cache: true
                cacheHint: CacheHint.SCALE_AND_ROTATE
                x: pie.translateX + 18
                y: pie.translateY + 8
                fill: Color.CADETBLUE
                width: 459;
                height: 395;
                arcWidth: 15
                arcHeight: 15
                effect: Glow {
                    level: 1
                    input: Shadow {
                        // offsetX: -5
                        // offsetY: 5
                        width: 5
                        color: Color.CADETBLUE
                        radius: 15
                    }
                }
                opacity: 0.5
            }
    var pieeBG = Rectangle {
                scaleX: 0.52 scaleY: 0.50
                cache: true
                x: pie.translateX + 20
                y: pie.translateY + 12
                fill: Color.BLACK
                width: 454;
                height: 387;
                arcWidth: 15
                arcHeight: 15
            }

    public override function create(): Node {
        return Group {
                    content: [pieBorder, pieeBG, pie]
                };
    }

}
