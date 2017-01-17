/*
 * LearnFXWidget.fx
 *
 */

package com.vnimedia.learnfx.ui;

import javafx.geometry.HPos;
import javafx.scene.*;
import javafx.scene.layout.*;
import javafx.scene.control.Button;
import javafx.scene.control.CheckBox;
import javafx.scene.control.TextBox;
import javafx.scene.paint.*;
import javafx.scene.shape.Rectangle;
import javafx.scene.text.*;
import org.jfxtras.scene.XScene;
import org.jfxtras.scene.control.*;
import org.jfxtras.scene.layout.*;
import org.widgetfx.Widget;
import org.widgetfx.config.Configuration;
import org.widgetfx.config.*;
import com.vnimedia.learnfx.model.LearnHomeGameModel;

var model = LearnHomeGameModel {};
var configScene:XScene;

def defaultWidth = 320.0;
def defaultHeight = 400.0;

var backGroundBorder:Rectangle = Rectangle {
    fill: Color.web("#D7D4F7")
    arcHeight: 20
    arcWidth: 20
    width: bind widget.width
    height: bind widget.height
}

var backGround:Rectangle = Rectangle {
    //fill: Color.web("#2e4b7c")
    fill: bind model.newQuestionIndicationColor
    arcHeight: 20
    arcWidth: 20
    width: bind widget.width - 6
    height: bind widget.height - 6
    layoutX: 3
    layoutY: 3
}

var group:Group = Group {
        content: [
            backGroundBorder,
            backGround
        ]
    };

def config:Configuration = Configuration {
  properties: [
    StringProperty {
      name: "twitterScreenName"
      value: bind model.twitterScreenName with inverse
      autoSave: true
    },
    StringProperty {
      name: "twitterPassword"
      value: bind model.twitterPassword with inverse
      autoSave: true
    },
    BooleanProperty {
      name: "playNewQuestionAlertSound"
      value: bind model.playNewQuestionAlertSound with inverse
      autoSave: true
    }
  ]
  scene: configScene = XScene {
    width: 320
    height: 380
    fill: Color.web("#2e4b7c")
    content: [
      XHBox {
        content: [
          XSpacer { w: 10 },

          XVBox {
            spacing: 10
            content: [
              XSpacer { h: 10 },
              Text {
                font: Font.font("Arial Black", 18)
                fill: Color.web("#f3f3f3")
                content: "LearnFX Widget Configuration"
              },
              XGrid {
                hgap: 5
                vgap: 10
                rows: [
                  XGridRow {
                    cells: [
                      Text {
                        font: Font.font("Arial", 12)
                        fill: Color.web("#f3f3f3")
                        content: "Twitter Screen Name:"
                      },
                      TextBox {
                        text: bind model.twitterScreenName with inverse
                        promptText: "Twitter screen name"
                      }
                    ]
                  },
                  XGridRow {
                    cells: [
                      Text {
                        font: Font.font("Arial", 12)
                        fill: Color.web("#f3f3f3")
                        content: "Twitter Password:"
                      },
                      TextBox {
                        text: bind model.twitterPassword with inverse
                        promptText: "Twitter password"
                        skin: XPasswordBoxSkin {}
                      }
                    ]
                  },
                  XGridRow {
                    cells: [
                      Text {
                        font: Font.font("Arial", 12)
                        fill: Color.web("#f3f3f3")
                        content: "Play sound on new question:"
                      },
                      CheckBox {
                        selected: bind model.playNewQuestionAlertSound with inverse
                      }
                    ]
                  }
                ]
              },
              XSpacer { h: 20 }
              HtmlNode {
                blocksMouse: false
                text: "LearnFX Widget developed by: <br/><br/> James L. Weaver http://javafxpert.com <br/><br/> with the help of friends involved with the http://JFXtras.org and http://widgetfx.org open source projects"
                width: 300
                //width: origWidth
                height: 150
              },

//              Text {
//                font: Font.font("Arial", 12)
//                fill: Color.web("#f3f3f3")
//                content: "\n\nLearnFX Widget developed by \nJames L. Weaver \njim.weaver@javafxpert.com \nwith the help of JFXtras.org\n and WidgetFX.org"
//              },
              XSpacer { h: 10 },
              Button {
                text: "OK"
                action: function():Void {
                  configScene.stage.visible = false;
                }
                layoutInfo: LayoutInfo {
                  hpos: HPos.RIGHT
                }
              },
              XSpacer { h: 10 }
            ]
          },
          XSpacer { w: 10 }
        ]
      }

    ]
  }
}

def widget:Widget = Widget {
  width: defaultWidth
  height: defaultHeight
  //aspectRatio: defaultWidth / defaultHeight
  configuration: config
  //stylesheets: "{__DIR__}audioPlayer.css"
  content: [
    group,
    LearnHomeGameRespondentDisplay {
      width: bind widget.width - 40
      height: bind widget.height + 10//- 40
      model: model
      //configStage: bind configScene.stage
      appTitle: "LearnFX Widget"
    }
  ]
}
return widget;