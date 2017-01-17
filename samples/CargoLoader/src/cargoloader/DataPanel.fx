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

import javafx.scene.layout.LayoutInfo;
import org.jfxtras.scene.control.data.ObjectDataProvider;
import org.jfxtras.scene.control.XTableView;
import cargoloader.ParameterValues;
import javafx.scene.CacheHint;
import javafx.scene.CustomNode;
import javafx.scene.Group;
import javafx.scene.Node;
import javafx.scene.effect.Glow;
import javafx.scene.effect.Shadow;
import javafx.scene.paint.Color;
import javafx.scene.shape.Rectangle;
import cargoloader.PlanData;
import org.jfxtras.scene.control.XTableSkin;

/**
 * @author Abhilshit Soni
 */
public class DataPanel extends CustomNode {

    public var cWeight;
    public var cMoment;
    public var tWeight;
    public var tMoment;
    public var cg;
    var charList: ParameterValues[] = [
                ParameterValues {parameter: "Empty Aircraft Weight", value: "{PlanData.basicOperatingWeight} lbs" }
                ParameterValues {parameter: "Empty Aircraft Moment", value: "{PlanData.basicOperatingMoment} lb-in" }
                ParameterValues {parameter: "Empty Aircraft Center of Gravity", value: "{PlanData.basicCG} in" }
                ParameterValues {parameter: "Total Cargo Weight", value: bind "{cWeight} lbs" }
                ParameterValues {parameter: "Total Cargo Moment", value: bind "{cMoment}lb-in" }
                ParameterValues {parameter: "Total Aircraft Weight", value: bind "{tWeight} lbs" }
                ParameterValues {parameter: "Total Aircraft Moment", value: bind "{tMoment} lb-in" }
                ParameterValues {parameter: "Current Center of Gravity", value: bind "{cg} in" }
                ParameterValues {parameter: "Fuel Volume", value: "{PlanData.fuelVolume} gls" }
                ParameterValues {parameter: "Fuel Density @ 25 C", value: "{PlanData.fuelDensity} lb/gls" }
                ParameterValues {parameter: "Fuel Weight", value: "{PlanData.fuelWeight} lbs" }
                ParameterValues {parameter: "Fuel Moment", value: "{PlanData.fuelVolume} lb-in" }
                ParameterValues {parameter: "Crew Members", value: "3" }
                ParameterValues {parameter: "Total Crew Weight", value: "{PlanData.crewWeight}" }
                ParameterValues {parameter: "Total Crew Moment", value: "{PlanData.crewMoment}" }
            ];
    def gridPanel: XTableView = XTableView {
                cache: true
                layoutX: -15
                layoutY: -30
                columnDragging: true
                dataProvider: ObjectDataProvider {
                    override var type = ParameterValues{}.getJFXClass();
                    override








bound function getItems(startIndex:Integer, count:Integer):Object[] {
            for (i in [startIndex..startIndex+count-1]) {
                var model = charList[(i) mod sizeof charList];
                ParameterValues {
                    parameter: model.parameter
                    value: model.value
                }
            }
        }
        rowCount: 15
    }
    rowHeight: 30

    onMouseClicked: function(e) {
        if (e.clickCount == 2) {
          //TODO yet to be implemented
        }
    }
    layoutInfo: LayoutInfo {width: 275 height:365}
    skin:XTableSkin{
       lightTextColor: Color.WHITE
        }

}

    var gridBorder = Rectangle {
                cache: true
                cacheHint: CacheHint.SCALE_AND_ROTATE
                x: gridPanel.translateX - 19
                y: gridPanel.translateY - 30
                fill: Color.CADETBLUE
                width: 281;
                height: 367;
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
    var gridBG = Rectangle {
                cache: true
                x: gridPanel.translateX - 19
                y: gridPanel.translateY - 34
                fill: Color.web("#0093ff")
                width: 281;
                height: 372;
                arcWidth: 15
                arcHeight: 15
            }

    public override function create(): Node {
        return Group {
                    content: [gridBorder, gridBG, gridPanel]
                };
    }

}
