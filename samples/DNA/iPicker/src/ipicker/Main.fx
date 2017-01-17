/*
 * Copyright (c) 2008-2009, David Armitage
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 * 1. Redistributions of source code must retain the above copyright notice,
 *    this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 * 3. The names of its contributors may not be used
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

package ipicker;

import javafx.stage.Stage;
import javafx.scene.text.Font.*;
import javafx.scene.paint.Color;
import javafx.scene.text.Font;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.geometry.HPos;
import javafx.scene.layout.HBox;
import javafx.scene.text.FontWeight;
import javafx.scene.layout.VBox;
import javafx.scene.text.Text;
import java.util.Date;
import javafx.animation.Timeline;
import javafx.animation.KeyFrame;
import javafx.geometry.VPos;
import javafx.util.Math.*;

/**
 * @author David
 */
  var months = [ "January", "February", "March", "April", "May", "June",
                   "July", "August", "September", "October", "November", "December" ];

  var iPicker1 = IPicker {
    content: [
      IPickerWheel { 
        name: "Wheel1"
        hpos: HPos.LEFT
        font: Font { name: "Arial Black" size: 20}
        content: [ "Harry","George","Hilda","aaaaaa","bbbbbb","jjjjjj","William","Albert","Julia","Helen" ]
        visibleItems: 3 },
      IPickerWheel { 
        name: "Wheel2"
        hpos: HPos.LEFT
        font: Font { name: "Arial Black" size: 20}
        content: [ "01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20" ]
        visibleItems: 1
        },
      IPickerWheel {
        name: "Wheel3"
        hpos: HPos.LEFT
        font: Font { name: "Arial Black" size: 20}
        content: months
        visibleItems: 1
        onIndexChange: function(i){println("Month {i} - {months[i]} under selector")};
        },
      IPickerWheel {
        name: "Wheel4"
        hpos: HPos.LEFT
        font: Font { name: "Arial Black" size: 20}
        content: [ "01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20" ]
        visibleItems: 1
        },
      ]
    };

  var iPicker2 = IPicker {
    textPadding: -10
    verticalPaddingFactor: 1.0
    showFocus: true
    endAdjust: 0
    content: [
      IPickerWheel {
        name: "Months"
        hpos: HPos.CENTER
        font: Font.font("Comic Sans MS", 20)
        content: [ "January", "February", "March", "April", "May", "June",
                   "July", "August", "September", "October", "November", "December" ]
        visibleItems: 5
        },
      ]
    };

  var iPicker3 = IPicker {
    textPadding: 5
    showFocus: true
    content: [
      IPickerWheel {
        name: "Numbers"
        hpos: HPos.CENTER
        font: Font { size: 12 }
        content: [ "01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20" ]
        visibleItems: 7
        },
      ]
    };

  var iPicker4 = IPicker {
    textPadding: 5
    endAdjust: 0.65
    content: [
      IPickerWheel {
        name: "Hours"
        hpos: HPos.RIGHT
        font:  Font.font("Georgia", FontWeight.BOLD, 18)
        content:  for (i in [0..23]) { i.toString(); }
        visibleItems: 3
        },
      IPickerWheel {
        name: "Minutes"
        hpos: HPos.LEFT
        font: Font.font("Georgia", 18)
        content:  for (i in [0..59]) { i.toString(); }
        visibleItems: 3
        },
      ]
    };

  var clock = IPicker {
    selector: false
    endAdjust: 0
    playSound: false
    content: [
      IPickerWheel {
        name: "Hours"
        hpos: HPos.CENTER
        font: Font { name: "Arial Black" size: 20}
        content:  for (i in [0..23]) { "{%02d i}" }
        visibleItems: 1
        noFlick: true
        },
      IPickerWheel {
        name: "Minutes"
        hpos: HPos.CENTER
        font: Font { name: "Arial Black" size: 20}
        content:  for (i in [0..59]) { "{%02d i}" }
        visibleItems: 1
        noFlick: true
        },
      IPickerWheel {
        name: "Seconds"
        hpos: HPos.CENTER
        font: Font { name: "Arial Black" size: 20}
        content:  for (i in [0..59]) { "{%02d i}" }
        visibleItems: 1
        noFlick: true
        },
      ]
    };
  var destinations = [ "STOUGHTON","GREENBUSH","NEEDHAM HEIGHTS","PROVIDENCE","FARMOUNT","WORCESTER","KINGSTON","MIDDLEBOROUGH","FRANKLIN" ];
  var railway = IPicker {
    selector: false
    endAdjust: 0
    content: [
      IPickerWheel {
        name: "Destination"
        hpos: HPos.CENTER
        font: Font { name: "Arial Black" size: 20}
        content: [ destinations ]
        visibleItems: 1
        noFlick: true
        },
       ]
    };

  var clockTL = Timeline {
    repeatCount: Timeline.INDEFINITE
    keyFrames : [
      KeyFrame {
        time: .1s
        action: function() { syncTime() }
        }
      ]
    };

  var prevSeconds = 0;

  function syncTime()     // inefficient but ... :-)
    {
    var now = new Date();
    var minutes = now.getMinutes();
    var seconds = now.getSeconds();
    var hours = now.getHours();
    if (seconds mod 10 == 0 and prevSeconds != seconds )
      {
      prevSeconds = seconds;
      railway.scrollToItem("Destination", destinations[(9.0 * random()) as Integer]);
      }

    clock.scrollToIndex("Hours", hours);
    clock.scrollToIndex("Minutes", minutes);
    clock.scrollToIndex("Seconds", seconds);
    }

  public function run()
    {
    clockTL.playFromStart();
    Stage {
      title: "JavaFX - iPicker Examples"
      scene: Scene {
        width: 800
        height: 400
        fill: Color.LIGHTGREY
        content: [
          VBox {
            layoutY: 15
            layoutX: 10
            spacing: 10
            content: [
              HBox {
                vpos: VPos.CENTER
                spacing: 20
                content: [ iPicker1, iPicker2, iPicker3, iPicker4 ]
                },
              HBox {
                vpos: VPos.CENTER
                spacing: 10
                content: [
                  Button { layoutY: 350 layoutX: 10  text: "Set to August" action: function(){ iPicker1.setSelectedItem("Wheel3", "August");  } }
                  Button { layoutY: 350 layoutX: 110 text: "Scroll to 14" action: function(){ iPicker1.scrollToIndex("Wheel2", 13);  } }
                  Button { layoutY: 350 layoutX: 200 text: "Scroll to Month in picker2" action: function(){ iPicker1.scrollToItem("Wheel3", iPicker2.getSelectedItem("Months")); } }
                  ]
                },
              HBox {
                vpos: VPos.CENTER
                spacing: 20
                content: [ Text { content: "Other ideas?" }, clock, Text { content: "Railway?" }, railway ]
                },
              ]
            }
          ]
        }
      };
    }