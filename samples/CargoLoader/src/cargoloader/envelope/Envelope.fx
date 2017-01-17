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
package cargoloader.envelope;

import javafx.scene.chart.part.NumberAxis;
import javafx.scene.text.Font;
import javafx.scene.CustomNode;
import javafx.scene.Node;
import javafx.scene.chart.LineChart;
import javafx.scene.chart.part.Side;
import javafx.scene.Group;
import cargoloader.envelope.DataUtil;
import cargoloader.PlanData;
import javafx.scene.paint.Color;
import javafx.scene.layout.LayoutInfo;

/**
 * the aircraft envelope of operational limits
 * @author Abhilshit Soni
 */
public var dataSeries: LineChart.Series[] = [
            LineChart.Series {name: "Take-Off Limit A" }
            LineChart.Series {name: "Take-off Limit B" }
            LineChart.Series {name: "Zero Fuel Limit" }
        ];
public var plotSeries: LineChart.Series[] = [
            LineChart.Series {
            }
        ];

public class Envelope extends CustomNode {

    public var tempPlotSeries = bind plotSeries;
    public var isEnlarged: Boolean = false;

    init {
        if (not isEnlarged) {
            DataUtil.populateTakeOffLimA();
            DataUtil.populateTakeOffLimB();
            DataUtil.populateZFLim();
            DataUtil.populateCGData(PlanData.initialTotalWeight / 100, PlanData.initialCG);
        }
    }

    var envelope = LineChart {
                translateX: 10
                translateY: 35
                showSymbols: false
                legendSide: Side.BOTTOM
                legendVisible: false
                data: dataSeries
                horizontalGridLineStroke: Color.WHITE
                verticalGridLineStroke: Color.WHITE
                titleSide: Side.BOTTOM
                xAxis: NumberAxis {
                    lowerBound: 260
                    upperBound: 320
                    tickUnit: 10
                    label: "Center of Gravity (inches from datum)"
                    labelFont: Font {size: 10 }
                    tickLabelTickGap: 10
                    tickLabelFont: Font {size: 9 }
                    labelTickGap: 10
                    tickMarkLength: 10
                    tickLabelFill: Color.WHITE
                    labelFill: Color.WHITE
                }
                yAxis: NumberAxis {
                    lowerBound: 0
                    upperBound: 180
                    tickUnit: 15
                    label: "Weight x 100"
                    labelFont: Font {size: 10 }
                    tickLabelTickGap: 10
                    tickLabelFont: Font {size: 9 }
                    labelTickGap: 10
                    tickMarkLength: 10
                    tickMarkVisible: true
                    tickLabelFill: Color.WHITE
                    labelFill: Color.WHITE
                }
                height: 400
                width: 400
            }
    var envelopeRotate = LineChart {
                translateX: 77
                translateY: -22
                showSymbols: true
                legendVisible: false
                legendSide: Side.BOTTOM
                //data: bind  plotSeries
                titleSide: Side.BOTTOM
                xAxis: NumberAxis {
                    lowerBound: 260
                    upperBound: 320
                    tickUnit: 10
                    label: " "
                    labelFont: Font {size: 10 }
                    tickLabelTickGap: 10
                    tickLabelFont: Font {size: 9 }
                    labelTickGap: 10
                    tickMarkLength: 10
                    side: Side.TOP
                    tickLabelFill: Color.WHITE
                    labelFill: Color.WHITE
                }
                yAxis: NumberAxis {
                    lowerBound: 0
                    upperBound: 180
                    tickUnit: 15
                    label: " "
                    labelFont: Font {size: 10 }
                    tickLabelTickGap: 10
                    tickLabelFont: Font {size: 9 }
                    labelTickGap: 10
                    tickMarkLength: 10
                    tickMarkVisible: true
                    side: Side.RIGHT
                    tickLabelFill: Color.WHITE
                    labelFill: Color.WHITE
                }
                height: 400
                width: 400
            }
    public var cgPlot = LineChart {
                translateX: 29
                translateY: 34
                showSymbols: true
                legendVisible: false
                legendSide: Side.BOTTOM
                data: bind tempPlotSeries
                titleSide: Side.BOTTOM
                xAxis: NumberAxis {
                    lowerBound: 260
                    upperBound: 320
                    tickUnit: 10
                    label: " "
                    labelFont: Font {size: 12 }
                    tickLabelTickGap: 10
                    tickLabelFont: Font {size: 11 }
                    labelTickGap: 10
                    tickMarkLength: 10
                    tickLabelsVisible: false
                    tickLabelFill: Color.WHITE
                    labelFill: Color.WHITE
                }
                yAxis: NumberAxis {
                    lowerBound: 0
                    upperBound: 180
                    tickUnit: 15
                    label: " "
                    labelFont: Font {size: 12 }
                    tickLabelTickGap: 10
                    tickLabelFont: Font {size: 11 }
                    labelTickGap: 10
                    tickMarkLength: 10
                    tickMarkVisible: true
                    tickLabelsVisible: false;
                    tickLabelFill: Color.WHITE
                    labelFill: Color.WHITE
                }
                layoutInfo: LayoutInfo {width: 480 height: 403 };
            }
    var chartGroup = Group {
                content: [envelopeRotate, envelope, cgPlot]
            }

    override protected function create(): Node {
        return chartGroup
    }

    }
