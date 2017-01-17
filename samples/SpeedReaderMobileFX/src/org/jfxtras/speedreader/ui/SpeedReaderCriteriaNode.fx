/*
 * Copyright (c) 2009, JFXtras Group
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
 *
 * Developed 2009 by James L. Weaver with the JFXtras Group
 * to read multiple social network and news feeds, as well
 * as to demonstrate some JFXtras features.
 *
 * SpeedReaderCriteriaNode.fx
 *
 * TODO: Create a CheckBox subclass to make the event handling straightforward
 * TODO: Lots of opportunities for refactoring here.  Take them.
 */

package org.jfxtras.speedreader.ui;

import org.jfxtras.speedreader.model.*;

import javafx.scene.*;
import javafx.scene.control.*;
import javafx.scene.image.*;
import javafx.scene.input.*;
import javafx.scene.layout.*;
import javafx.scene.paint.*;
import javafx.scene.text.*;
import org.jfxtras.scene.*;
import org.jfxtras.scene.border.EmptyBorder;
import org.jfxtras.scene.layout.*;
import org.jfxtras.scene.shape.ResizableRectangle;
import javafx.geometry.HPos;
import javafx.geometry.VPos;

/**
 * Dialog that enables the user to enter criteria for feeds, etc. to
 * be displayed in the items display page.
 *
 * @author Jim Weaver
 */
public class SpeedReaderCriteriaNode extends ResizableCustomNode {
  /**
   * Reference to the main model for this app
   */
  public-init var model:SpeedReaderModel;

  var twitPicFeedComponents:Node[];
  var tweeTubeFeedComponents:Node[];
  var twitterFeedComponents:Node[];
  var flickrFeedComponents:Node[];
  var deliciousFeedComponents:Node[];
  var youTubeFeedComponents:Node[];
  var yahooFeedComponents:CheckBox[];
  var msnbcFeedComponents:CheckBox[];
  var otherFeedComponents:Row[];

  def logoHeight:Integer = 40;

  override var defaultLayoutInfo = ExtendedLayoutInfo {
    fill: Fill.NONE
  }

  override public function create():Node {
    Deck {
      content: [
        ResizableRectangle {
          fill: Color.DARKGRAY
          arcHeight: 20
          arcWidth: 20
          opacity: 0.96
          blocksMouse: true
        },
        CloseButton {
          blocksMouse: true
          model: model
          translateX: 5
          translateY: -5
          layoutInfo: ExtendedLayoutInfo { hpos: HPos.RIGHT, vpos: VPos.TOP }
        },
        EmptyBorder {
          borderWidth: 15
          layoutInfo: ExtendedLayoutInfo { hpos: HPos.LEFT, vpos: VPos.TOP }
          node: 
            ResizableVBox {
              spacing: 20
              content: [
                Text {
                  font:Font.font(null, FontWeight.BOLD, 24)
                  content: "SpeedReaderFX Criteria"
                  fill: Color.WHITESMOKE
                },
              Grid {
                hgap: 5
                rows: [
                  Row {
                    cells: [
                      ImageView {
                        image: Image {
                          url: "http://twitpic.com/images/twitpic-logo.png"
                        }
                        fitHeight: logoHeight
                        preserveRatio: true
                      },
                      twitPicFeedComponents = for (feedInfo in model.twitPicFeedInfo) {
                        var checkBoxRef:CheckBox;
                        var textBoxRef:TextBox;
                        ResizableHBox {
                          content: [
                            textBoxRef = TextBox {
                              text: feedInfo.argument
                              promptText: "username"
                              action:function():Void {
                                feedInfo.argument = textBoxRef.text;
                                feedInfo.setSelected(feedInfo.argument.trim() != "");
                                feedInfo.setDirty(true);
                                refreshFromData();
                              }
                              onKeyTyped:function(ke:KeyEvent):Void {
                                feedInfo.argument = textBoxRef.rawText;
                                if (feedInfo.argument.trim() == "") {
                                  feedInfo.setSelected(false);
                                  checkBoxRef.selected = false;
                                  feedInfo.setDirty(true);
                                }
                              }
                            },
                            checkBoxRef = CheckBox {
                              disable: bind textBoxRef.rawText == ""
                              selected: feedInfo.isSelected
                              onMouseClicked: function(me:MouseEvent):Void {
                                feedInfo.setSelected(checkBoxRef.selected);
                                feedInfo.setDirty(true);
                                refreshFromData();
                              }
                              onKeyReleased: function(ke:KeyEvent):Void {
                                feedInfo.setSelected(checkBoxRef.selected);
                                feedInfo.setDirty(true);
                                refreshFromData();
                              }
                            }
                          ]
                        }
                      }
                    ]
                  },
                  Row {
                    cells: [
                      ImageView {
                        image: Image {
                          url: "http://www.tweetube.com/images/logo.png"
                        }
                        fitHeight: logoHeight
                        preserveRatio: true
                      },
                      tweeTubeFeedComponents = for (feedInfo in model.tweeTubeFeedInfo) {
                        var checkBoxRef:CheckBox;
                        var textBoxRef:TextBox;
                        ResizableHBox {
                          content: [
                            textBoxRef = TextBox {
                              text: feedInfo.argument
                              promptText: "username"
                              action:function():Void {
                                feedInfo.argument = textBoxRef.text;
                                feedInfo.setSelected(feedInfo.argument.trim() != "");
                                feedInfo.setDirty(true);
                                refreshFromData();
                              }
                              onKeyTyped:function(ke:KeyEvent):Void {
                                feedInfo.argument = textBoxRef.rawText;
                                if (feedInfo.argument.trim() == "") {
                                  feedInfo.setSelected(false);
                                  checkBoxRef.selected = false;
                                  feedInfo.setDirty(true);
                                }
                              }
                            },
                            checkBoxRef = CheckBox {
                              disable: bind textBoxRef.rawText == ""
                              selected: feedInfo.isSelected
                              onMouseClicked: function(me:MouseEvent):Void {
                                feedInfo.setSelected(checkBoxRef.selected);
                                feedInfo.setDirty(true);
                                refreshFromData();
                              }
                              onKeyReleased: function(ke:KeyEvent):Void {
                                feedInfo.setSelected(checkBoxRef.selected);
                                feedInfo.setDirty(true);
                                refreshFromData();
                              }
                            }
                          ]
                        }
                      }
                    ]
                  },
                  Row {
                    cells: [
                      ImageView {
                        image: Image {
                          url: "http://apiwiki.twitter.com/f/twitterapi_logo.png"
                        }
                        fitHeight: logoHeight
                        preserveRatio: true
                      },
                      twitterFeedComponents = for (feedInfo in model.twitterFeedInfo) {
                        var checkBoxRef:CheckBox;
                        var textBoxRef:TextBox;
                        ResizableHBox {
                          content: [
                            textBoxRef = TextBox {
                              text: feedInfo.argument
                              promptText: "username"
                              action:function():Void {
                                feedInfo.argument = textBoxRef.text;
                                feedInfo.setSelected(feedInfo.argument.trim() != "");
                                feedInfo.setDirty(true);
                                refreshFromData();
                              }
                              onKeyTyped:function(ke:KeyEvent):Void {
                                feedInfo.argument = textBoxRef.rawText;
                                if (feedInfo.argument.trim() == "") {
                                  feedInfo.setSelected(false);
                                  checkBoxRef.selected = false;
                                  feedInfo.setDirty(true);
                                }
                              }
                            },
                            checkBoxRef = CheckBox {
                              disable: bind textBoxRef.rawText == ""
                              selected: feedInfo.isSelected
                              onMouseClicked: function(me:MouseEvent):Void {
                                feedInfo.setSelected(checkBoxRef.selected);
                                feedInfo.setDirty(true);
                                refreshFromData();
                              }
                              onKeyReleased: function(ke:KeyEvent):Void {
                                feedInfo.setSelected(checkBoxRef.selected);
                                feedInfo.setDirty(true);
                                refreshFromData();
                              }
                            }
                          ]
                        }
                      }
                    ]
                  },
                  Row {
                    cells: [
                      ImageView {
                        image: Image {
                          url: "http://l.yimg.com/a/i/brand/purplelogo/uh/us/news.gif"
                        }
                        fitWidth: logoHeight * 4
                        preserveRatio: true
                      },
                      Cell {
                        // This cell will span the entire grid width
                        hspan: sizeof model.twitPicNames
                        content: Tile {
                          columns: 6
                          hgap: 10
                          vgap: 10
                          content: [
                            yahooFeedComponents = for (feedInfo in model.yahooFeedInfo) {
                              var checkBoxRef:CheckBox;
                              checkBoxRef = CheckBox {
                                text: feedInfo.argument
                                selected: model.yahooNewsTopicsSelected[indexof feedInfo]
                                onMouseClicked: function(me:MouseEvent):Void {
                                  feedInfo.setSelected(checkBoxRef.selected);
                                  feedInfo.setDirty(true);
                                  refreshFromData();
                                 }
                                onKeyReleased: function(ke:KeyEvent):Void {
                                  feedInfo.setSelected(checkBoxRef.selected);
                                  feedInfo.setDirty(true);
                                  refreshFromData();
                                }
                              }
                            }
                          ]
                        }
                      }
                    ]
                  },
                  Row {
                    cells: [
                      ImageView {
                        image: Image {
                          url: "http://www.flickr.com/images/flickr_logo_gamma.gif"
                        }
                        fitHeight: logoHeight
                        preserveRatio: true
                      },
                      flickrFeedComponents = for (feedInfo in model.flickrFeedInfo) {
                        var checkBoxRef:CheckBox;
                        var textBoxRef:TextBox;
                        ResizableHBox {
                          content: [
                            textBoxRef = TextBox {
                              text: feedInfo.argument
                              promptText: "tag,tag"
                              action:function():Void {
                                feedInfo.argument = textBoxRef.text;
                                feedInfo.setSelected(feedInfo.argument.trim() != "");
                                feedInfo.setDirty(true);
                                refreshFromData();
                              }
                              onKeyTyped:function(ke:KeyEvent):Void {
                                feedInfo.argument = textBoxRef.rawText;
                                if (feedInfo.argument.trim() == "") {
                                  feedInfo.setSelected(false);
                                  checkBoxRef.selected = false;
                                  feedInfo.setDirty(true);
                                }
                              }
                            },
                            checkBoxRef = CheckBox {
                              disable: bind textBoxRef.rawText == ""
                              selected: feedInfo.isSelected
                              onMouseClicked: function(me:MouseEvent):Void {
                                feedInfo.setSelected(checkBoxRef.selected);
                                feedInfo.setDirty(true);
                                refreshFromData();
                              }
                              onKeyReleased: function(ke:KeyEvent):Void {
                                feedInfo.setSelected(checkBoxRef.selected);
                                feedInfo.setDirty(true);
                                refreshFromData();
                              }
                            }
                          ]
                        }
                      }
                    ]
                  },
                  Row {
                    cells: [
                      ImageView {
                        image: Image {
                          url: "{__DIR__}images/delicious_logo.jpg"
                        }
                        fitHeight: logoHeight
                        preserveRatio: true
                      },
                      deliciousFeedComponents = for (feedInfo in model.deliciousFeedInfo) {
                        var checkBoxRef:CheckBox;
                        var textBoxRef:TextBox;
                        ResizableHBox {
                          content: [
                            textBoxRef = TextBox {
                              text: feedInfo.argument
                              promptText: "tag"
                              action:function():Void {
                                feedInfo.argument = textBoxRef.text;
                                feedInfo.setSelected(feedInfo.argument.trim() != "");
                                feedInfo.setDirty(true);
                                refreshFromData();
                              }
                              onKeyTyped:function(ke:KeyEvent):Void {
                                feedInfo.argument = textBoxRef.rawText;
                                if (feedInfo.argument.trim() == "") {
                                  feedInfo.setSelected(false);
                                  checkBoxRef.selected = false;
                                  feedInfo.setDirty(true);
                                }
                              }
                            },
                            checkBoxRef = CheckBox {
                              disable: bind textBoxRef.rawText == ""
                              selected: feedInfo.isSelected
                              onMouseClicked: function(me:MouseEvent):Void {
                                feedInfo.setSelected(checkBoxRef.selected);
                                feedInfo.setDirty(true);
                                refreshFromData();
                              }
                              onKeyReleased: function(ke:KeyEvent):Void {
                                feedInfo.setSelected(checkBoxRef.selected);
                                feedInfo.setDirty(true);
                                refreshFromData();
                              }
                            }
                          ]
                        }
                      }
                    ]
                  },
                  Row {
                    cells: [
                      ImageView {
                        image: Image {
                          url: "http://code.google.com/apis/youtube/images/logo.gif"
                        }
                        fitHeight: logoHeight
                        preserveRatio: true
                      },
                      youTubeFeedComponents = for (feedInfo in model.youTubeFeedInfo) {
                        var checkBoxRef:CheckBox;
                        var textBoxRef:TextBox;
                        ResizableHBox {
                          content: [
                            textBoxRef = TextBox {
                              text: feedInfo.youTubeTag
                              promptText: "tag+tag"
                              action:function():Void {
                                feedInfo.youTubeTag = textBoxRef.text;
                                feedInfo.setSelected(feedInfo.youTubeTag.trim() != "");
                                feedInfo.setDirty(true);
                                refreshFromData();
                              }
                              onKeyTyped:function(ke:KeyEvent):Void {
                                feedInfo.youTubeTag = textBoxRef.rawText;
                                if (feedInfo.youTubeTag.trim() == "") {
                                  feedInfo.setSelected(false);
                                  checkBoxRef.selected = false;
                                  feedInfo.setDirty(true);
                                }
                              }
                            },
                            checkBoxRef = CheckBox {
                              disable: bind textBoxRef.rawText == ""
                              selected: feedInfo.isSelected
                              onMouseClicked: function(me:MouseEvent):Void {
                                feedInfo.setSelected(checkBoxRef.selected);
                                feedInfo.setDirty(true);
                                refreshFromData();
                              }
                              onKeyReleased: function(ke:KeyEvent):Void {
                                feedInfo.setSelected(checkBoxRef.selected);
                                feedInfo.setDirty(true);
                                refreshFromData();
                              }
                            }
                          ]
                        }
                      }
                    ]
                  },
                  Row {
                    cells: [
                      ImageView {
                        image: Image {
                          url: "http://msnbcmedia.msn.com/i/msnbc/SiteManagement/SiteWide/Images/msnbc_logo.gif"
                        }
                        fitHeight: logoHeight
                        preserveRatio: true
                      },
                      Cell {
                        // This cell will span the entire grid width
                        hspan: sizeof model.twitPicNames
                        content: Tile {
                          columns: 6
                          hgap: 10
                          vgap: 10
                          content: [
                            msnbcFeedComponents = for (feedInfo in model.msnbcFeedInfo) {
                              var checkBoxRef:CheckBox;
                              checkBoxRef = CheckBox {
                                text: model.msnbcTopicNames[indexof feedInfo]
                                selected: model.msnbcTopicsSelected[indexof feedInfo]
                                onMouseClicked: function(me:MouseEvent):Void {
                                  feedInfo.setSelected(checkBoxRef.selected);
                                  feedInfo.setDirty(true);
                                  refreshFromData();
                                 }
                                onKeyReleased: function(ke:KeyEvent):Void {
                                  feedInfo.setSelected(checkBoxRef.selected);
                                  feedInfo.setDirty(true);
                                  refreshFromData();
                                }
                              }
                            }
                          ]
                        }
                      }
                    ]
                  },
                  otherFeedComponents = for (feedInfo in model.otherFeedInfo) {
                    Row {
                      cells: [
                        Cell {
                          hspan: sizeof model.twitPicNames + 1
                          content:
                            ResizableHBox {
                              var textBoxRef:TextBox;
                              var atomCheckBoxRef:CheckBox;
                              var activeCheckBoxRef:CheckBox;
                              spacing: 10
                              content: [
                                Label {
                                  text: "Feed URL:"
                                },
                                textBoxRef = TextBox {
                                  text: feedInfo.urla
                                  action:function():Void {
                                    feedInfo.urla = textBoxRef.text;
                                    feedInfo.setSelected(feedInfo.urla.trim() != "");
                                    feedInfo.setDirty(true);
                                    refreshFromData();
                                  }
                                  onKeyTyped:function(ke:KeyEvent):Void {
                                    feedInfo.urla = textBoxRef.rawText;
                                    if (feedInfo.urla.trim() == "") {
                                      feedInfo.setSelected(false);
                                      activeCheckBoxRef.selected = false;
                                      feedInfo.setDirty(true);
                                    }
                                  }
                                },
                                atomCheckBoxRef = CheckBox {
                                  text: "Atom feed"
                                  selected: feedInfo.isAtom
                                  onMouseClicked: function(me:MouseEvent):Void {
                                    feedInfo.isAtom = atomCheckBoxRef.selected;
                                    feedInfo.setSelected(activeCheckBoxRef.selected);
                                    feedInfo.setDirty(true);
                                    refreshFromData();
                                  }
                                  onKeyReleased: function(ke:KeyEvent):Void {
                                    feedInfo.isAtom = atomCheckBoxRef.selected;
                                    feedInfo.setSelected(activeCheckBoxRef.selected);
                                    feedInfo.setDirty(true);
                                    refreshFromData();
                                  }
                                },
                                activeCheckBoxRef = CheckBox {
                                  disable: bind textBoxRef.rawText == ""
                                  text: "Active"
                                  selected: feedInfo.isSelected
                                  onMouseClicked: function(me:MouseEvent):Void {
                                    feedInfo.setSelected(activeCheckBoxRef.selected);
                                    feedInfo.setDirty(true);
                                    refreshFromData();
                                  }
                                  onKeyReleased: function(ke:KeyEvent):Void {
                                    feedInfo.setSelected(activeCheckBoxRef.selected);
                                    feedInfo.setDirty(true);
                                    refreshFromData();
                                  }
                                }
                              ]
                            }
                        }
                      ]
                    }
                  }
                ]
              }
            ]
          }
        }
      ]
    }
  }

  /**
   * Updates the data in this dialog.  This is an alternative to binding to
   * the model, and still avoids instantiating the dialog box to display
   * updated data.  TODO: It is, however, very scene graph specific, so another
   * approach to accomplish the same thing should be considered.
   */
  public function refreshFromData() {
    for (node in twitPicFeedComponents) {
      def argumentTextBox = (node as ResizableHBox).content[0] as TextBox;
      def selectedCheckBox = (node as ResizableHBox).content[1] as CheckBox;
      argumentTextBox.text = model.twitPicFeedInfo[indexof node].argument;
      selectedCheckBox.selected = model.twitPicFeedInfo[indexof node].isSelected;
    };
    for (node in tweeTubeFeedComponents) {
      def argumentTextBox = (node as ResizableHBox).content[0] as TextBox;
      def selectedCheckBox = (node as ResizableHBox).content[1] as CheckBox;
      argumentTextBox.text = model.tweeTubeFeedInfo[indexof node].argument;
      selectedCheckBox.selected = model.tweeTubeFeedInfo[indexof node].isSelected;
    };
    for (node in twitterFeedComponents) {
      def argumentTextBox = (node as ResizableHBox).content[0] as TextBox;
      def selectedCheckBox = (node as ResizableHBox).content[1] as CheckBox;
      argumentTextBox.text = model.twitterFeedInfo[indexof node].argument;
      selectedCheckBox.selected = model.twitterFeedInfo[indexof node].isSelected;
    };
    for (node in flickrFeedComponents) {
      def argumentTextBox = (node as ResizableHBox).content[0] as TextBox;
      def selectedCheckBox = (node as ResizableHBox).content[1] as CheckBox;
      argumentTextBox.text = model.flickrFeedInfo[indexof node].argument;
      selectedCheckBox.selected = model.flickrFeedInfo[indexof node].isSelected;
    };
    for (node in deliciousFeedComponents) {
      def argumentTextBox = (node as ResizableHBox).content[0] as TextBox;
      def selectedCheckBox = (node as ResizableHBox).content[1] as CheckBox;
      argumentTextBox.text = model.deliciousFeedInfo[indexof node].argument;
      selectedCheckBox.selected = model.deliciousFeedInfo[indexof node].isSelected;
    };
    for (node in youTubeFeedComponents) {
      def argumentTextBox = (node as ResizableHBox).content[0] as TextBox;
      def selectedCheckBox = (node as ResizableHBox).content[1] as CheckBox;
      argumentTextBox.text = model.youTubeFeedInfo[indexof node].youTubeTag;
      selectedCheckBox.selected = model.youTubeFeedInfo[indexof node].isSelected;
    };
    for (checkBox in yahooFeedComponents) {
      checkBox.selected = model.yahooFeedInfo[indexof checkBox].isSelected;
    };
    for (checkBox in msnbcFeedComponents) {
      checkBox.selected = model.msnbcFeedInfo[indexof checkBox].isSelected;
    };
    for (row in otherFeedComponents) {
      def urlaTextBox = ((row.cells[0] as Cell).content as ResizableHBox).content[1] as TextBox;
      def atomCheckBox = ((row.cells[0] as Cell).content as ResizableHBox).content[2] as CheckBox;
      def selectedCheckBox = ((row.cells[0] as Cell).content as ResizableHBox).content[3] as CheckBox;
      urlaTextBox.text = model.otherFeedInfo[indexof row].urla;
      atomCheckBox.selected = model.otherFeedInfo[indexof row].isAtom;
      selectedCheckBox.selected = model.otherFeedInfo[indexof row].isSelected;
    };
  }
}
