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
import org.jfxtras.scene.control.Picker;
import org.jfxtras.scene.control.PickerType;
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
  var twitPicQtyPicker:Picker;

  var tweeTubeFeedComponents:Node[];
  var tweeTubeQtyPicker:Picker;

  var twitterFeedComponents:Node[];
  var twitterQtyPicker:Picker;

  var flickrFeedComponents:Node[];
  var flickrQtyPicker:Picker;

  var deliciousFeedComponents:Node[];
  var deliciousQtyPicker:Picker;

  var youTubeFeedComponents:Node[];
  var youTubeQtyPicker:Picker;

  var yahooFeedComponents:CheckBox[];
  var yahooQtyPicker:Picker;

  var msnbcFeedComponents:CheckBox[];
  var msnbcQtyPicker:Picker;

  var iTunesFeedComponents:CheckBox[];
  var iTunesQtyPicker:Picker;

  var gizmodoCheckBoxRef:CheckBox;
  var engadgetCheckBoxRef:CheckBox;
  var engadgetVideoCheckBoxRef:CheckBox;
  var techCrunchCheckBoxRef:CheckBox;
  var dilbertCheckBoxRef:CheckBox;
  var geekStuffQtyPicker:Picker; //TODO Use this in code

  var otherFeedComponents:Row[];
  var otherQtyPicker:Picker; //TODO Use this in code

  def logoHeight:Integer = 30;

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
          borderWidth: 12
          layoutInfo: ExtendedLayoutInfo { hpos: HPos.LEFT, vpos: VPos.TOP }
          node: 
            ResizableVBox {
              spacing: 20
              content: [
                Text {
                  // TODO: Bind the font size to a function of the scene
                  font:Font.font(null, FontWeight.BOLD, 24)
                  content: "SpeedReaderFX Criteria"
                  fill: Color.WHITESMOKE
                },
              Grid {
                hgap: 5
                vgap: 10
                rows: [
                  Row {
                    cells: [
                    //cells: [
//                      ResizableHBox {
//                        hpos: HPos.RIGHT
//                        spacing: 5
//                        content: [
                          ImageView {
                            image: Image {
                              url: "http://twitpic.com/images/twitpic-logo.png"
                            }
                            fitHeight: logoHeight
                            preserveRatio: true
                          },
                          twitPicQtyPicker = Picker {
                            items: [ 1..20 ]
                            firstLetter: true
                            pickerType: PickerType.THUMB_WHEEL
                            layoutInfo: LayoutInfo {
                              width: 50
                            }
                            // Update numItemsToShow when picker value changes
                            onIndexChange: function(index:Integer):Void {
                              for (feedInfo in model.twitPicFeedInfo) {
                                feedInfo.numItemsToShow = twitPicQtyPicker.selectedItem as Integer;
                              }
                            }
//                          }
//                        ]
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
                                //TODO: Move next two statements into FeedInfo class argument trigger?
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
                                  //refreshFromData();
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
//                      ResizableHBox {
//                        hpos: HPos.RIGHT
//                        spacing: 5
//                        content: [
                          ImageView {
                            image: Image {
                              url: "http://www.tweetube.com/images/logo.png"
                            }
                            fitHeight: logoHeight
                            preserveRatio: true
                          },
                          tweeTubeQtyPicker = Picker {
                            items: [ 1..20 ]
                            firstLetter: true
                            pickerType: PickerType.THUMB_WHEEL
                            layoutInfo: LayoutInfo {
                              width: 50
                            }
                            // Update numItemsToShow when picker value changes
                            onIndexChange: function(index:Integer):Void {
                              for (feedInfo in model.tweeTubeFeedInfo) {
                                feedInfo.numItemsToShow = tweeTubeQtyPicker.selectedItem as Integer;
                              }
                            }
//                          }
//                        ]
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
                                //TODO: Move next two statements into FeedInfo class argument trigger?
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
                                  //refreshFromData();
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
//                      ResizableHBox {
//                        hpos: HPos.RIGHT
//                        spacing: 5
//                        content: [
                          ImageView {
                            image: Image {
                              url: "http://apiwiki.twitter.com/f/twitterapi_logo.png"
                            }
                            fitHeight: logoHeight
                            preserveRatio: true
                          },
                          twitterQtyPicker = Picker {
                            items: [ 1..20 ]
                            firstLetter: true
                            pickerType: PickerType.THUMB_WHEEL
                            layoutInfo: LayoutInfo {
                              width: 50
                            }
                            // Update numItemsToShow when picker value changes
                            onIndexChange: function(index:Integer):Void {
                              for (feedInfo in model.twitterFeedInfo) {
                                feedInfo.numItemsToShow = twitterQtyPicker.selectedItem as Integer;
                              }
                            }
//                          }
//                        ]
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
                                //TODO: Move next two statements into FeedInfo class argument trigger?
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
                                  //refreshFromData();
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
//                      ResizableHBox {
//                        hpos: HPos.RIGHT
//                        spacing: 5
//                        content: [
                          ImageView {
                            image: Image {
                              // TODO: Identify simpler, well-known Yahoo logo URL
                              url: "http://l.yimg.com/a/i/brand/purplelogo/uh/us/news.gif"
                            }
                            //fitHeight: logoHeight
                            fitWidth: logoHeight * 4
                            preserveRatio: true
                          },
                          yahooQtyPicker = Picker {
                            items: [ 1..20 ]
                            firstLetter: true
                            pickerType: PickerType.THUMB_WHEEL
                            layoutInfo: LayoutInfo {
                              width: 50
                            }
                            // Update numItemsToShow when picker value changes
                            onIndexChange: function(index:Integer):Void {
                              for (feedInfo in model.yahooFeedInfo) {
                                feedInfo.numItemsToShow = yahooQtyPicker.selectedItem as Integer;
                              }
                            }
//                          }
//                        ]
                      },
                      Cell {
                        // This cell will span the entire grid width
                        hspan: sizeof model.twitPicNames
                        content: Tile {
                          columns: 6
                          hgap: 10
                          vgap: 5
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
//                      ResizableHBox {
//                        hpos: HPos.RIGHT
//                        spacing: 5
//                        content: [
                          ImageView {
                            image: Image {
                              url: "http://www.flickr.com/images/flickr_logo_gamma.gif"
                            }
                            fitHeight: logoHeight
                            preserveRatio: true
                          },
                          flickrQtyPicker = Picker {
                            items: [ 1..20 ]
                            firstLetter: true
                            pickerType: PickerType.THUMB_WHEEL
                            layoutInfo: LayoutInfo {
                              width: 50
                            }
                            // Update numItemsToShow when picker value changes
                            onIndexChange: function(index:Integer):Void {
                              for (feedInfo in model.flickrFeedInfo) {
                                feedInfo.numItemsToShow = flickrQtyPicker.selectedItem as Integer;
                              }
                            }
//                          }
//                        ]
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
                                //TODO: Move next two statements into FeedInfo class argument trigger?
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
                                  //refreshFromData();
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
//                      ResizableHBox {
//                        hpos: HPos.RIGHT
//                        spacing: 5
//                        content: [
                          ImageView {
                            image: Image {
                              //TODO: Find URL for delicious logo
                              url: "{__DIR__}images/delicious_logo.jpg"
                            }
                            fitHeight: logoHeight
                            preserveRatio: true
                          },
                          deliciousQtyPicker = Picker {
                            items: [ 1..20 ]
                            firstLetter: true
                            pickerType: PickerType.THUMB_WHEEL
                            layoutInfo: LayoutInfo {
                              width: 50
                            }
                            // Update numItemsToShow when picker value changes
                            onIndexChange: function(index:Integer):Void {
                              for (feedInfo in model.deliciousFeedInfo) {
                                feedInfo.numItemsToShow = deliciousQtyPicker.selectedItem as Integer;
                              }
                            }
//                          }
//                        ]
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
                                //TODO: Move next two statements into FeedInfo class argument trigger?
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
                                  //refreshFromData();
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
//                      ResizableHBox {
//                        hpos: HPos.RIGHT
//                        spacing: 5
//                        content: [
                          ImageView {
                            image: Image {
                              url: "http://code.google.com/apis/youtube/images/logo.gif"
                            }
                            fitHeight: logoHeight
                            preserveRatio: true
                          },
                          youTubeQtyPicker = Picker {
                            items: [ 1..20 ]
                            firstLetter: true
                            pickerType: PickerType.THUMB_WHEEL
                            layoutInfo: LayoutInfo {
                              width: 50
                            }
                            // Update numItemsToShow when picker value changes
                            onIndexChange: function(index:Integer):Void {
                              for (feedInfo in model.youTubeFeedInfo) {
                                feedInfo.numItemsToShow = youTubeQtyPicker.selectedItem as Integer;
                              }
                            }
//                          }
//                        ]
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
                                //println("In SRCN, feedInfo.youTubeTag:{feedInfo.youTubeTag}");
                                //TODO: Move next two statements into FeedInfo class argument trigger?
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
                                  //refreshFromData();
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
//                      ResizableHBox {
//                        hpos: HPos.RIGHT
//                        spacing: 5
//                        content: [
                          ImageView {
                            image: Image {
                              url: "http://msnbcmedia.msn.com/i/msnbc/SiteManagement/SiteWide/Images/msnbc_logo.gif"
                            }
                            fitHeight: logoHeight
                            preserveRatio: true
                          },
                          msnbcQtyPicker = Picker {
                            items: [ 1..20 ]
                            firstLetter: true
                            pickerType: PickerType.THUMB_WHEEL
                            layoutInfo: LayoutInfo {
                              width: 50
                            }
                            // Update numItemsToShow when picker value changes
                            onIndexChange: function(index:Integer):Void {
                              for (feedInfo in model.msnbcFeedInfo) {
                                feedInfo.numItemsToShow = msnbcQtyPicker.selectedItem as Integer;
                              }
                            }
//                          }
//                        ]
                      },
                      Cell {
                        // This cell will span the entire grid width
                        hspan: sizeof model.twitPicNames
                        content: Tile {
                          columns: 6
                          hgap: 10
                          vgap: 5
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
                  Row {
                    cells: [
//                      ResizableHBox {
//                        hpos: HPos.RIGHT
//                        spacing: 5
//                        content: [
                          ImageView {
                            image: Image {
                              url: "http://itunes.apple.com/images/rss/badge.gif"
                            }
                            fitHeight: logoHeight
                            preserveRatio: true
                          },
                          iTunesQtyPicker = Picker {
                            items: [ 1..20 ]
                            firstLetter: true
                            pickerType: PickerType.THUMB_WHEEL
                            layoutInfo: LayoutInfo {
                              width: 50
                            }
                            // Update numItemsToShow when picker value changes
                            onIndexChange: function(index:Integer):Void {
                              for (feedInfo in model.iTunesFeedInfo) {
                                feedInfo.numItemsToShow = iTunesQtyPicker.selectedItem as Integer;
                              }
                            }
//                          }
//                        ]
                      },
                      Cell {
                        // This cell will span the entire grid width
                        hspan: sizeof model.twitPicNames
                        content: Tile {
                          columns: 6
                          hgap: 10
                          vgap: 5
                          content: [
                            iTunesFeedComponents = for (feedInfo in model.iTunesFeedInfo) {
                              var checkBoxRef:CheckBox;
                              checkBoxRef = CheckBox {
                                text: model.iTunesTopicNames[indexof feedInfo]
                                selected: model.iTunesTopicsSelected[indexof feedInfo]
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
                          url: "{__DIR__}images/geek-toys.jpg"
                        }
                        fitHeight: logoHeight
                        preserveRatio: true
                      },
                      geekStuffQtyPicker = Picker {
                        items: [ 1..20 ]
                        firstLetter: true
                        pickerType: PickerType.THUMB_WHEEL
                        layoutInfo: LayoutInfo {
                          width: 50
                        }
                        // Update numItemsToShow when picker value changes
                        onIndexChange: function(index:Integer):Void {
                          for (feedInfo in model.feedsToRead where feedInfo.type == "geekStuff") {
                            feedInfo.numItemsToShow = geekStuffQtyPicker.selectedItem as Integer;
                          }
                        }
                      },
                      Cell {
                        // This cell will span the entire grid width
                        hspan: sizeof model.twitPicNames
                        content: Tile {
                          columns: 6
                          hgap: 10
                          vgap: 5
                          content: [
                            gizmodoCheckBoxRef = CheckBox {
                              text: "Gizmodo"
                              selected: model.gizmodoFeedInfo.isSelected
                              onMouseClicked: function(me:MouseEvent):Void {
                                model.gizmodoFeedInfo.setSelected(gizmodoCheckBoxRef.selected);
                                model.gizmodoFeedInfo.setDirty(true);
                                refreshFromData();
                               }
                              onKeyReleased: function(ke:KeyEvent):Void {
                                model.gizmodoFeedInfo.setSelected(gizmodoCheckBoxRef.selected);
                                model.gizmodoFeedInfo.setDirty(true);
                                refreshFromData();
                              }
                            },
                            engadgetCheckBoxRef = CheckBox {
                              text: "Engadget"
                              selected: model.engadgetFeedInfo.isSelected
                              onMouseClicked: function(me:MouseEvent):Void {
                                model.engadgetFeedInfo.setSelected(engadgetCheckBoxRef.selected);
                                model.engadgetFeedInfo.setDirty(true);
                                refreshFromData();
                               }
                              onKeyReleased: function(ke:KeyEvent):Void {
                                model.engadgetFeedInfo.setSelected(engadgetCheckBoxRef.selected);
                                model.engadgetFeedInfo.setDirty(true);
                                refreshFromData();
                              }
                            },
                            engadgetVideoCheckBoxRef = CheckBox {
                              text: "Engadget vid"
                              selected: model.engadgetVideoFeedInfo.isSelected
                              onMouseClicked: function(me:MouseEvent):Void {
                                model.engadgetVideoFeedInfo.setSelected(engadgetVideoCheckBoxRef.selected);
                                model.engadgetVideoFeedInfo.setDirty(true);
                                refreshFromData();
                               }
                              onKeyReleased: function(ke:KeyEvent):Void {
                                model.engadgetVideoFeedInfo.setSelected(engadgetVideoCheckBoxRef.selected);
                                model.engadgetVideoFeedInfo.setDirty(true);
                                refreshFromData();
                              }
                            },
                            techCrunchCheckBoxRef = CheckBox {
                              text: "TechCrunch"
                              selected: model.techCrunchFeedInfo.isSelected
                              onMouseClicked: function(me:MouseEvent):Void {
                                model.techCrunchFeedInfo.setSelected(techCrunchCheckBoxRef.selected);
                                model.techCrunchFeedInfo.setDirty(true);
                                refreshFromData();
                               }
                              onKeyReleased: function(ke:KeyEvent):Void {
                                model.techCrunchFeedInfo.setSelected(techCrunchCheckBoxRef.selected);
                                model.techCrunchFeedInfo.setDirty(true);
                                refreshFromData();
                              }
                            },
                            dilbertCheckBoxRef = CheckBox {
                              text: "Dilbert"
                              selected: model.dilbertFeedInfo.isSelected
                              onMouseClicked: function(me:MouseEvent):Void {
                                model.dilbertFeedInfo.setSelected(dilbertCheckBoxRef.selected);
                                model.dilbertFeedInfo.setDirty(true);
                                refreshFromData();
                               }
                              onKeyReleased: function(ke:KeyEvent):Void {
                                model.dilbertFeedInfo.setSelected(dilbertCheckBoxRef.selected);
                                model.dilbertFeedInfo.setDirty(true);
                                refreshFromData();
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
                          hspan: sizeof model.twitPicNames + 2
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
                                    //TODO: Move next two statements into FeedInfo class argument trigger?
                                    feedInfo.setSelected(feedInfo.urla.trim() != "");
                                    feedInfo.setDirty(true);
                                    refreshFromData();
                                  }
                                  //TODO: Also update the model when focus is lost
                                  onKeyTyped:function(ke:KeyEvent):Void {
                                    feedInfo.urla = textBoxRef.rawText;
                                    if (feedInfo.urla.trim() == "") {
                                      feedInfo.setSelected(false);
                                      activeCheckBoxRef.selected = false;
                                      feedInfo.setDirty(true);
                                      //refreshFromData();
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
                                  //selected: bind feedInfo.isSelected with inverse
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
    //println("In refreshFromData");
    for (node in twitPicFeedComponents) {
      def argumentTextBox = (node as ResizableHBox).content[0] as TextBox;
      def selectedCheckBox = (node as ResizableHBox).content[1] as CheckBox;
      argumentTextBox.text = model.twitPicFeedInfo[indexof node].argument;
      selectedCheckBox.selected = model.twitPicFeedInfo[indexof node].isSelected;
      //println("Setting TextBox to:{model.twitPicFeedInfo[indexof node].argument}");
    };
    twitPicQtyPicker.selectItem(model.twitPicFeedInfo[0].numItemsToShow);

    for (node in tweeTubeFeedComponents) {
      def argumentTextBox = (node as ResizableHBox).content[0] as TextBox;
      def selectedCheckBox = (node as ResizableHBox).content[1] as CheckBox;
      argumentTextBox.text = model.tweeTubeFeedInfo[indexof node].argument;
      selectedCheckBox.selected = model.tweeTubeFeedInfo[indexof node].isSelected;
      //println("Setting TextBox to:{model.tweeTubeFeedInfo[indexof node].argument}");
    };
    tweeTubeQtyPicker.selectItem(model.tweeTubeFeedInfo[0].numItemsToShow);

    for (node in twitterFeedComponents) {
      def argumentTextBox = (node as ResizableHBox).content[0] as TextBox;
      def selectedCheckBox = (node as ResizableHBox).content[1] as CheckBox;
      argumentTextBox.text = model.twitterFeedInfo[indexof node].argument;
      selectedCheckBox.selected = model.twitterFeedInfo[indexof node].isSelected;
      //println("Setting TextBox to:{model.twitterFeedInfo[indexof node].argument}");
    };
    twitterQtyPicker.selectItem(model.twitterFeedInfo[0].numItemsToShow);

    for (node in flickrFeedComponents) {
      def argumentTextBox = (node as ResizableHBox).content[0] as TextBox;
      def selectedCheckBox = (node as ResizableHBox).content[1] as CheckBox;
      argumentTextBox.text = model.flickrFeedInfo[indexof node].argument;
      selectedCheckBox.selected = model.flickrFeedInfo[indexof node].isSelected;
      //println("Setting TextBox to:{model.flickrFeedInfo[indexof node].argument}");
    };
    flickrQtyPicker.selectItem(model.flickrFeedInfo[0].numItemsToShow);

    for (node in deliciousFeedComponents) {
      def argumentTextBox = (node as ResizableHBox).content[0] as TextBox;
      def selectedCheckBox = (node as ResizableHBox).content[1] as CheckBox;
      argumentTextBox.text = model.deliciousFeedInfo[indexof node].argument;
      selectedCheckBox.selected = model.deliciousFeedInfo[indexof node].isSelected;
      //println("Setting TextBox to:{model.deliciousFeedInfo[indexof node].argument}");
    };
    deliciousQtyPicker.selectItem(model.deliciousFeedInfo[0].numItemsToShow);

    for (node in youTubeFeedComponents) {
      def argumentTextBox = (node as ResizableHBox).content[0] as TextBox;
      def selectedCheckBox = (node as ResizableHBox).content[1] as CheckBox;
      argumentTextBox.text = model.youTubeFeedInfo[indexof node].youTubeTag;
      selectedCheckBox.selected = model.youTubeFeedInfo[indexof node].isSelected;
      //println("Setting TextBox to:{model.youTubeFeedInfo[indexof node].youTubeTag}");
    };
    youTubeQtyPicker.selectItem(model.youTubeFeedInfo[0].numItemsToShow);

    for (checkBox in yahooFeedComponents) {
      checkBox.selected = model.yahooFeedInfo[indexof checkBox].isSelected;
    };
    yahooQtyPicker.selectItem(model.yahooFeedInfo[0].numItemsToShow);

    for (checkBox in msnbcFeedComponents) {
      checkBox.selected = model.msnbcFeedInfo[indexof checkBox].isSelected;
    };
    msnbcQtyPicker.selectItem(model.msnbcFeedInfo[0].numItemsToShow);

    
    for (checkBox in iTunesFeedComponents) {
      checkBox.selected = model.iTunesFeedInfo[indexof checkBox].isSelected;
    };
    iTunesQtyPicker.selectItem(model.iTunesFeedInfo[0].numItemsToShow);

    gizmodoCheckBoxRef.selected = model.gizmodoFeedInfo.isSelected;
    engadgetCheckBoxRef.selected = model.engadgetFeedInfo.isSelected;
    engadgetVideoCheckBoxRef.selected = model.engadgetVideoFeedInfo.isSelected;
    techCrunchCheckBoxRef.selected = model.techCrunchFeedInfo.isSelected;
    dilbertCheckBoxRef.selected = model.dilbertFeedInfo.isSelected;
    geekStuffQtyPicker.selectItem(model.gizmodoFeedInfo.numItemsToShow);

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
