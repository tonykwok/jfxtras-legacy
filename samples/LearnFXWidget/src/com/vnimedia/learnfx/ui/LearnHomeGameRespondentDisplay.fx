/*
 * LearnHomeGameRespondentDisplay.fx
 *
 * Created on Oct 4, 2009, 7:59:39 AM
 */

package com.vnimedia.learnfx.ui;
import com.vnimedia.learnfx.model.*;
import javafx.animation.*;
import javafx.scene.*;
import javafx.scene.control.*;
import javafx.scene.image.*;
import javafx.scene.layout.*;
import javafx.scene.media.*;
import javafx.scene.paint.Color;
import javafx.scene.shape.Rectangle;
import javafx.scene.text.*;
import javafx.stage.Stage;
import javafx.geometry.HPos;
import javafx.geometry.VPos;
import org.jfxtras.scene.control.*;
import org.jfxtras.scene.*;
import org.jfxtras.scene.border.EmptyBorder;
import org.jfxtras.scene.layout.*;
import org.jfxtras.scene.shape.ResizableRectangle;

/**
 * @author jlweaver
 */

public class LearnHomeGameRespondentDisplay extends XCustomNode {
  public var model:LearnHomeGameModel;
  public-init var appTitle = "AchieveFX";
  //public var configStage:Stage;

  var IMAGE_HEIGHT:Integer = 160;
  var tableRef:XTable;

  //TODO: Find more elegant way of allowing focus on the stage to request focus in this TextBox
  public var answerTextBox:TextBox;

  var newQuestionIndicatorNormalColor = Color.web("#2e4b7c");
  var newQuestionIndicatorFlashColor = Color.web("#FF9900");

  def newQuestionAlertSoundPlayer = MediaPlayer {
    media: Media {
      source: "{__DIR__}resources/newQuestionAlert.mp3"
    }
  }

  var newQuestionAlertTimeline = Timeline {
    keyFrames: [
      at(0.0s) {model.newQuestionIndicationColor => newQuestionIndicatorNormalColor},
      at(0.5s) {model.newQuestionIndicationColor => newQuestionIndicatorFlashColor},
      at(1.0s) {model.newQuestionIndicationColor => newQuestionIndicatorNormalColor},
      at(1.5s) {model.newQuestionIndicationColor => newQuestionIndicatorFlashColor},
      at(2.0s) {model.newQuestionIndicationColor => newQuestionIndicatorNormalColor},
      at(2.5s) {model.newQuestionIndicationColor => newQuestionIndicatorFlashColor},
      at(3.0s) {model.newQuestionIndicationColor => newQuestionIndicatorNormalColor},
      at(3.5s) {model.newQuestionIndicationColor => newQuestionIndicatorFlashColor},
      KeyFrame {
        time: 4.0s
        values: model.newQuestionIndicationColor => newQuestionIndicatorNormalColor
        action: function():Void {
          model.newQuestionArrived = false;
        }
      }
    ]
  };

  var newQuestionArrived:Boolean = bind model.newQuestionArrived on replace {
    //println("============New question arrived=============");
    if (newQuestionArrived) {
      answerTextBox.text = "";
      newQuestionAlertTimeline.playFromStart();
      if (model.playNewQuestionAlertSound) {
        newQuestionAlertSoundPlayer.currentTime = 0s;
        newQuestionAlertSoundPlayer.play();
      }
    }
  };


  override public function create():Node {
    model.newQuestionIndicationColor = newQuestionIndicatorNormalColor;
    var node:Node;
    node = XStack {
      content: [
        XHBox {
          content: [
            Rectangle {
              width: 20
              height: 1
              fill: Color.TRANSPARENT
            },
            XVBox {
              spacing: 10
              content: [
                Rectangle {
                  width: 1
                  height: 5
                  fill: Color.TRANSPARENT
                },
                XHBox {
                  spacing: 10
                  content: [
                    ImageView {
                      image: Image {
                        url: "{__DIR__}resources/brain_32.png"
                      }
                    },
                    Text {
                      font: Font.font("Arial Black", 18)
                      fill: Color.web("#f3f3f3")
                      content: appTitle
                    },
                    XVBox {
                      //spacing: 2
                      visible: bind model.twitterScreenName == "" or
                                    model.twitterPassword == ""
                      content: [
                        Text {
                          font: Font.font("Arial", 12)
                          fill: Color.web("#f3f3f3")
                          content: "Please supply login"
                        },
                        Text {
                          font: Font.font("Arial", 12)
                          fill: Color.web("#f3f3f3")
                          content: "info in config panel"
                        }
                      ]
                    }
//                    Button {
//                      text: "Ok"
//                      action: function():Void {
//                        configStage.visible = true;
//                      }
//                    },
                  ]
                },
                tableRef = XTable {
                  styleClass: "tables"
                  id: "table"
                  rowType: Respondent{}.getJFXClass()
                  rows: bind model.respondents
                  //rowHeight: 60
                  rowHeight: bind (height / 14) as Integer
                },
                HtmlNode {
                  blocksMouse: true
                  //scaleX: bind width / origWidth
                  //scaleY: bind width / origWidth
                  //TODO: Put the removal of the timecode from the beginning somewhere else, and cleaner
                  text: bind "{model.textOfLatestQuestionTweet.substring(model.textOfLatestQuestionTweet.indexOf(" "))}{if (model.latestQuestionTweetIsQuestion) "" else " <br/><p class='answer'>Answer: {model.answerToLatestQuestionTweet}</p>"}"
                  width: bind width
                  //width: origWidth
                  height: 140
                },

//                Stack {
//                  content: [
//                    Rectangle {
//                      width: bind width
//                      height: 150
//                      fill: Color.WHITE
//                    },
//                    Text {
//                      content: bind "{model.textOfLatestQuestionTweet}{if (model.latestQuestionTweetIsQuestion) "" else "\n{model.answerToLatestQuestionTweet}"}"
//                      textAlignment: TextAlignment.LEFT
//                      wrappingWidth: bind width
//                      styleClass: "displayText"
//                    },
//                  ]
//                },
                XHBox {
                  spacing: 10
                  content: [
                    answerTextBox = TextBox {
                      blocksMouse: true
                      focusTraversable: true
                      columns: 20
                      disable: bind not model.latestQuestionTweetIsQuestion
                      action: function():Void {
                        model.sendResponseTweet(answerTextBox.text);
                        answerTextBox.text = "";
                      }
                    },
                    Button {
                      blocksMouse: true
                      //disable: bind not model.latestQuestionTweetIsQuestion
                      disable: bind (not model.latestQuestionTweetIsQuestion) or answerTextBox.rawText.trim() == ""
                      text: "Send"
                      strong: true
                      action: function():Void {
                        model.sendResponseTweet(answerTextBox.text);
                        answerTextBox.text = "";
                      }
                    },
                    Button {
                      //TODO: Disable when already in LearnHomeGameModel#onTick() ?
                      //TODO: Show this button when not using projavafxcourse Twitter account
                      //      to get the responses (Twitter rate limit problem).
                      blocksMouse: true
                      text: "Refresh"
                      action: function():Void {
                        //println("Refresh button clicked");
                        model.onTick();
                        model.checkForResponses();
                      }
                    }
                  ]
                },
                Rectangle {
                  width: 1
                  height: 20
                  fill: Color.TRANSPARENT
                }
              ]
            },
            Rectangle {
              width: 20
              height: 1
              fill: Color.TRANSPARENT
            },
          ]
        }
      ]
    };
    tableRef.columns[0].displayName = "Pic";
    tableRef.columns[1].displayName = "Name";
    tableRef.columns[2].displayName = "Resp";
    tableRef.columns[3].displayName = "?";
    tableRef.columns[4].visible = false;
    tableRef.columns[5].visible = false;
    tableRef.columns[6].visible = false;
    answerTextBox.requestFocus();
    return node;
  }
}
