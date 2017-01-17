/*
 * LearnHomeGameMain.fx
 *
 */

package com.vnimedia.learnfx.ui;

import javafx.geometry.HPos;
import javafx.scene.*;
import javafx.scene.control.Button;
import javafx.scene.control.CheckBox;
import javafx.scene.control.TextBox;
import javafx.scene.effect.*;
import javafx.scene.image.*;
import javafx.scene.input.*;
import javafx.scene.layout.*;
import javafx.scene.paint.*;
import javafx.scene.shape.Rectangle;
import javafx.scene.text.*;
import javafx.stage.StageStyle;
import org.jfxtras.scene.XScene;
import org.jfxtras.scene.control.*;
import org.jfxtras.scene.layout.*;
import org.jfxtras.stage.XStage;
import org.widgetfx.Widget;
import org.widgetfx.config.Configuration;
import org.widgetfx.config.*;
import com.vnimedia.learnfx.model.LearnHomeGameModel;

var model = LearnHomeGameModel {};

var configScene:XScene;
//var configStage:JFXStage;

var theScene: Scene;

def defaultWidth = 400.0;
def defaultHeight = 360.0;

def minWidth = 300.0;
def minHeight = 300.0;

var mainStageWidth:Number = defaultWidth on replace {
  if (mainStageWidth < minWidth) {
    mainStageWidth = minWidth;
  }
};

;
var mainStageHeight:Number = defaultHeight on replace {
  if (mainStageHeight < minHeight) {
    mainStageHeight = minHeight;
  }
};

var respondentDisplay:LearnHomeGameRespondentDisplay;


var mainStageContainsFocus:Boolean = bind theScene.stage.containsFocus on replace {
  //println("Main Stage now contains focus");
  if (mainStageContainsFocus and respondentDisplay != null) {
    respondentDisplay.answerTextBox.requestFocus();
  }
};


var backGroundBorder:Rectangle = Rectangle {
    fill: bind if (mainStageContainsFocus) Color.web("#A2AEAD") else Color.web("#d7d4f7")
    arcHeight: 20
    arcWidth: 20
    width: bind theScene.width
    height: bind theScene.height
}

var backGround:Rectangle = Rectangle {
//  var startScreenX:Number
//  var startScreenY:Number
//  var startStageX:Number
//  var startStageY:Number
  var startOffsetX:Number
  var startOffsetY:Number
  blocksMouse: true
  //cursor: Cursor.MOVE
  fill: bind model.newQuestionIndicationColor
  arcHeight: 20
  arcWidth: 20
  width: bind theScene.width - 6
  height: bind theScene.height - 6
  layoutX: 3
  layoutY: 3
  onMousePressed: function(me:MouseEvent):Void {
    theScene.stage.toFront();
    startOffsetX = me.screenX - theScene.stage.x;
    startOffsetY = me.screenY - theScene.stage.y;
  }
  onMouseDragged: function(me:MouseEvent):Void {
    theScene.stage.x = me.screenX - startOffsetX;
    theScene.stage.y = me.screenY - startOffsetY;
  }
  onMouseClicked: function(me:MouseEvent):Void {
    if (me.clickCount == 2) {
      theScene.stage.iconified = not theScene.stage.iconified;
    }
  }
};

/**
 * TODO: Perhaps put the config and close buttons in a XHBox
 */
var configBtn:Stack = Stack {
  blocksMouse: true
  layoutX: bind theScene.width - 65
  layoutY: 20
  content: [
    Rectangle {
      fill: bind model.newQuestionIndicationColor
      //stroke: Color.web("#2e4b7c")
      width: 20
      height: 20
      arcHeight: 10
      arcWidth: 10
    },
    ImageView {
      image: Image {
        url: "{__DIR__}resources/configIcon.png"
      }
    }
  ]
  onMouseEntered: function(me:MouseEvent) {
      configBtn.cursor = Cursor.HAND;
      configBtn.effect = DropShadow{color: Color.web("#D7D4F7")};
      //configBtn.effect = DropShadow{color: Color.web("#2e4b1c")};
  }
  onMouseExited: function(me:MouseEvent) {
      configBtn.cursor = Cursor.DEFAULT;
      configBtn.effect = null;
  }
  onMouseClicked: function(me:MouseEvent) {
    configScene.stage.visible = not configScene.stage.visible;
//        addRadio.toFront();
//        addRadio.show();
  }
  effect: null
  //disable: bind configScene.stage.visible
};

var closeBtn:Stack = Stack {
  blocksMouse: true
  layoutX: bind theScene.width - 35
  layoutY: 20
  content: [
    Rectangle {
      fill: bind model.newQuestionIndicationColor
      //stroke: Color.web("#2e4b7c")
      width: 20
      height: 20
      arcHeight: 10
      arcWidth: 10
    },
    ImageView {
      image: Image {
        url: "{__DIR__}resources/closeIcon.png"
      }
    }
  ]
  onMouseEntered: function(me:MouseEvent) {
      closeBtn.cursor = Cursor.HAND;
      closeBtn.effect = DropShadow{color: Color.web("#D7D4F7")};
      //closeBtn.effect = DropShadow{color: Color.web("#2e4b1c")};
  }
  onMouseExited: function(me:MouseEvent) {
      closeBtn.cursor = Cursor.DEFAULT;
      closeBtn.effect = null;
  }
  onMouseClicked: function(me:MouseEvent) {
    theScene.stage.close();
//        addRadio.toFront();
//        addRadio.show();
  }
  effect: null
  disable: bind configScene.stage.visible
};

def resizeBtn:Stack = Stack {
  var stageStartWidth:Number
  var stageStartHeight:Number
  blocksMouse: true
  cursor: Cursor.SE_RESIZE
  layoutX: bind theScene.width - 21 //resizeBtn.layoutBounds.width
  layoutY: bind theScene.height - 21 //resizeBtn.layoutBounds.height
  content: [
    Rectangle {
      fill: bind model.newQuestionIndicationColor
      //stroke: Color.web("#2e4b7c")
      width: 20
      height: 20
      arcHeight: 10
      arcWidth: 10
    },
    ImageView {
      image: Image {
        url: "{__DIR__}resources/resizeIcon.png"
      }
    }
  ]
  onMousePressed: function(me:MouseEvent) {
    //println("theScene.stage.width:{theScene.stage.width}, theScene.width:{theScene.width}");
    stageStartWidth = theScene.stage.width;
    stageStartHeight = theScene.stage.height;
  }
  onMouseDragged: function(me:MouseEvent):Void {
    mainStageWidth = stageStartWidth + me.dragX;
    mainStageHeight = stageStartHeight + me.dragY;
  }
  effect: null
  disable: bind configScene.stage.visible
};

var group:Group = Group {
  content: [
    backGroundBorder,
    backGround,
    configBtn,
    closeBtn,
    resizeBtn
  ]
};

//configStage = JFXStage {
XStage {
  var bgBorder:Rectangle = Rectangle {
      //fill: bind if (not mainStageContainsFocus) Color.web("#d7d4f7") else Color.web("#bdc6c5") //#A2AEAD
      fill: bind if (not mainStageContainsFocus) Color.web("#A2AEAD") else Color.web("#d7d4f7")
      arcHeight: 20
      arcWidth: 20
      width: bind configScene.width
      height: bind configScene.height
  }

  var bg:Rectangle = Rectangle {
    var startOffsetX:Number
    var startOffsetY:Number
    blocksMouse: true
    //cursor: Cursor.MOVE
    fill: bind model.newQuestionIndicationColor
    arcHeight: 20
    arcWidth: 20
    width: bind configScene.width - 6
    height: bind configScene.height - 6
    layoutX: 3
    layoutY: 3
    onMousePressed: function(me:MouseEvent):Void {
      configScene.stage.toFront();
      startOffsetX = me.screenX - configScene.stage.x;
      startOffsetY = me.screenY - configScene.stage.y;
    }
    onMouseDragged: function(me:MouseEvent):Void {
      configScene.stage.x = me.screenX - startOffsetX;
      configScene.stage.y = me.screenY - startOffsetY;
    }
  };
  style: StageStyle.TRANSPARENT
  resizable: false
  visible: false
  alwaysOnTop: true
  title: "LearnFX Configuration"
  scene: configScene = XScene {
    width: 340
    height: 400
    fill: Color.TRANSPARENT
    //fill: Color.web("#2e4b7c")
    content: [
      bgBorder,
      bg,
      XHBox {
        content: [
          XSpacer { w: 20 },

          XVBox {
            spacing: 10
            content: [
              XSpacer { h: 20 },
              XHBox {
                spacing: 10
                content: [
                  ImageView {
                    image: Image {
                      url: "{__DIR__}resources/configIcon.png"
                    }
                  },
                  Text {
                    font: Font.font("Arial Black", 18)
                    fill: Color.web("#f3f3f3")
                    content: "LearnFX Configuration"
                  }
                ]
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
                  },
                  XGridRow {
                    cells: [
                      Text {
                        font: Font.font("Arial", 12)
                        fill: Color.web("#f3f3f3")
                        content: "LearnFX always on top:"
                      },
                      CheckBox {
                        selected: bind model.alwaysOnTop with inverse
                      }
                    ]
                  }
                ]
              },
              XSpacer { h: 20 }
              HtmlNode {
                blocksMouse: true
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
                strong: true
                action: function():Void {
                  configScene.stage.visible = false;
                  model.saveProperties();
                }
                layoutInfo: LayoutInfo {
                  hpos: HPos.RIGHT
                }
              },
              XSpacer { h: 20 }
            ]
          },
          XSpacer { w: 20 }
        ]
      }

    ]
  }
  icons: [
    Image {
      url: "{__DIR__}resources/sponge_32.png"
    },
    Image {
      url: "{__DIR__}resources/sponge_64.png"
    }
  ]
};

var newQuestionArrived:Boolean = bind model.newQuestionArrived on replace {
  if (newQuestionArrived) {
    if (theScene != null) {
      theScene.stage.iconified = false;
    }
  }
};



XStage {
  //var theScene: Scene;
  width: bind mainStageWidth
  height: bind mainStageHeight
  title: "LearnFX"
  style: StageStyle.TRANSPARENT
  //style: StageStyle.UNDECORATED
  alwaysOnTop: bind model.alwaysOnTop and not configScene.stage.visible
  scene: theScene = Scene {
    //width: defaultWidth
    //height: defaultHeight
    stylesheets: "{__DIR__}learnClient.css"
    fill: Color.TRANSPARENT
    content: [
      group,
      respondentDisplay = LearnHomeGameRespondentDisplay {
        width: bind theScene.width - 40
        height: bind theScene.height + 10//- 40
        model: model
        //configStage: bind configScene.stage
        appTitle: "LearnFX"
      }
    ]
  }
  onClose: function():Void {
    FX.exit();
  }
  icons: [
    Image {
      url: "{__DIR__}resources/brain_blue_32.png"
    },
    Image {
      url: "{__DIR__}resources/brain_blue_64.png"
    }
  ]
};

model.loadProperties();
