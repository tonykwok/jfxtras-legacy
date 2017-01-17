/*
Copyright (c) 2009, Mark Macumber
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the author (Mark Macumber) nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY Mark Macumber "AS IS" AND ANY
EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL MARK MACUMBER BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

package hudsongraphs;

import javafx.stage.Stage;
import javafx.scene.Scene;
import javafx.scene.chart.BarChart;
import javafx.scene.chart.part.CategoryAxis;
import javafx.scene.chart.part.NumberAxis;
import javafx.scene.text.Font;
import javafx.scene.paint.Color;

import javafx.scene.input.MouseEvent;
import javafx.scene.shape.Rectangle;
import javafx.scene.text.Text;

import hudsonremoteaccess.Hudson;

import org.dom4j.Document;
import org.dom4j.tree.DefaultElement;

/**
 * Hudson Graphing:
 * Sample JavaFX application that will make a remote call to the Hudson
 * API's, parse the XML and generate a nice bar-graph of build information.
 * @author Mark Macumber
 */
var hudson:Hudson = new Hudson();

/*
XML Document in the format of:
<build>
    <duration>10979169</duration>
    <fullDisplayName>FindBugs #34</fullDisplayName>
    <number>34</number>
    <result>SUCCESS</result>
</build>
*/
var xmlDoc:Document = hudson.getXMLHudsonQuery();
var builds = xmlDoc.selectNodes("//build");

var numbers:String[] = [];

//the actual bar char data
var barChartData:BarChart.Data[];

var currentMouseX:Number = 0;
var currentMouseY:Number = 0;

//Text that will float in the dialog
var buildText:Text = Text {
    font : Font { size: 12 }
    x: bind currentMouseX + 12,
    y: bind currentMouseY + 20
};

//floating rectangle that will follow the mouse on each build
var floatingRect:Rectangle = Rectangle{
    width: 120
    height: 50
    arcHeight: 5
    arcWidth: 5
    fill: Color.WHITESMOKE
    stroke: Color.BLACK
    x: bind currentMouseX
    y: bind currentMouseY
    visible: false
};

for (build in builds) {
    var idx = indexof build;
    var bDuration = getElement(build as DefaultElement, "duration");
    var durationInMilliseconds = Number.valueOf(bDuration);
    var durationInMinutes = ((durationInMilliseconds/1000)/60);

    var bNumber = getElement(build as DefaultElement, "number");
    var bResult = getElement(build as DefaultElement, "result");
    var bDisplayName = getElement(build as DefaultElement, "fullDisplayName");

    insert bNumber into numbers;

    var barChart:BarChart.Data =
        BarChart.Data {
            category: bNumber
            value: durationInMinutes
        };

    var chartNode = Rectangle{
        onMouseMoved: function( e: MouseEvent ):Void {
            currentMouseX = e.sceneX + 15;
            currentMouseY = e.sceneY + 5;
            floatingRect.visible = true;
            buildText.content = "{bDisplayName}\nDuration: {durationInMinutes as Integer}mins";
        }
        x: 0
        y: 0
        width: bind barChart.width
        height: bind barChart.height
        fill: if (bResult == "SUCCESS") Color.GREEN else Color.RED;
    };
    
    barChart.bar = chartNode;
    insert barChart into barChartData;
}

function getElement(element:DefaultElement, xpath:String):String{
    (element.selectNodes(xpath).get(0) as DefaultElement).getData() as String;
}

Stage {
  title: "Hudson Build Duration Timeline"
  width: 800
  height: 450
  scene: Scene {
    content: [
      BarChart {
        title: "Hudson Build Duration Timeline"
        width: 750
        titleFont: Font { size: 24 }
        categoryGap: 2
        categoryAxis: CategoryAxis {
          categories: numbers
        }
        valueAxis: NumberAxis {
          label: "Build Duration (minutes)"
          upperBound: 500
          tickUnit: 100
        }
        data: [
          BarChart.Series {
            name: "Build #'s"
            fill: Color.GREEN
            data: barChartData
          }
        ]
      },
      floatingRect,
      buildText
    ]
  }
}