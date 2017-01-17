/*
 * TopicMapNavMain.fx
 *
 * Uses Freebase and JFXtras with JavaFX to explore connections
 * between musical artists
 *
 * Developed by James L. Weaver and Sten Anderson to demonstrate
 * using JavaFX and JFXtras
 *
 * TODO: Fix problem of never finishing the JSON read on some machines
 *       (symptom is that progress indicator continuously spins).  This
 *       doesn't occur with the current source code, but when an additional
 *       query part (e.g. astronauts) is uncommented it occurs consistently on some machines.
 * TODO: Fix problem where resizing causes Shelf components to go underneath
 *       the top section of the UI.
 * TODO: Refactor DRY violations, e.g. in the mouse handling code that causes
 *       a browser page to appear.
 * TODO: Provide easy way to start app with a particular artist
 * TODO: Design a control to choose type of relationship to display (e.g. member of groups, albums)?
 */

package org.jfxtras.topicmapnav.ui;

import javafx.geometry.HPos;
import javafx.scene.*;
import javafx.scene.control.Label;
import javafx.scene.control.ListView;
import javafx.scene.control.ProgressIndicator;
import javafx.scene.control.TextBox;
import javafx.scene.image.*;
import javafx.scene.input.*;
import javafx.scene.layout.HBox;
import javafx.scene.layout.LayoutInfo;
import javafx.scene.layout.VBox;
import javafx.scene.text.*;
import javafx.stage.*;

import java.net.URL;
import javax.jnlp.*;

import crudfx.map.*;
import org.jfxtras.scene.control.*;
import org.jfxtras.scene.control.data.SequenceObjectDataProvider;
import org.jfxtras.scene.*;
import org.jfxtras.scene.layout.*;
import org.jfxtras.scene.menu.*;
import org.jfxtras.topicmapnav.model.*;

/**
 * Indicator that we're running as an applet
 */
def runningAsApplet:Boolean = AppletStageExtension.eval("2+3") != null;

var splashStageRef:Stage;

if (not runningAsApplet) {
  splashStageRef = Stage {
    title: "BandmatesFX Splash Page"
    style: StageStyle.TRANSPARENT
    scene: Scene {
      width: 1000
      height: 700
      content: {
        ImageView {
          image: Image {
            url: "http://www.jmentor.com/JavaFX_1-2/BandmatesFXnext/images/guitar.png"
          }
        }
      }
    }
  }
}

/**
 * Reference to the main model for this app
 */
def model:TopicMapNavModel = TopicMapNavModel.getInstance();

var textBoxRef:TextBox;
var listViewRef:ListView;
var selectedNameIndex = bind listViewRef.selectedIndex on replace {
  def selectedId = model.freebaseSearchResult.result[selectedNameIndex].id;
  if (selectedId != "") {
    println("selectedId:{selectedId}");
    model.nameToFind = model.freebaseSearchResult.result[selectedNameIndex].name;
    model.obtainGroupsForArtist(selectedId);
  }
};

/**
 * Controls X position of info box
 */
var infoBoxPosX:Number = 5;

/**
 * Controls Y position of info box
 */
var infoBoxPosY:Number = 5;

var sceneRef:Scene;

/**
 * Reference to the Table that has a list of all of the people of a certain type
 */
var peopleTable:Table;

/**
 * Reference to the data provider for the Table that has a list of all of the people of a certain type
 */
//var peopleDataProvider:SequenceObjectDataProvider;

/**
 * Reference to the container that contains the selected topic, text box, etc.
 */
var upperContainer:Node;

var googleMapRef:GoogleMap;
var googleMapLatitude = bind model.googleMapLatitude on replace {
  googleMapRef.latitude = googleMapLatitude;
};
var googleMapLongitude = bind model.googleMapLongitude on replace {
  googleMapRef.longitude = googleMapLongitude;
};
var googleMapContainer:Node;

var menubar: MenuBar;
menubar = MenuBar {
  width: bind sceneRef.width;
  menus: [
    // View Menu
    Menu {
      text: "View"
      items: [
        CheckedMenuItem {
          text: "Google Map"
          checked: bind model.showLocationMap with inverse
          graphic: bind if (model.showLocationMap) {
            ImageView {
              image: Image {
                url: "{__DIR__}images/lightbulb_on.png";
              }
            }
          }
          else {
            ImageView {
              image: Image {
                url: "{__DIR__}images/lightbulb.png";
              }
            }
          }
        },
        CheckedMenuItem {
          text: "Topics with No Image"
          checked: bind model.showTopicsThatHaveNoImage with inverse
          action: function() {
            model.obtainGroupsForArtist(model.artistToSearch);
          }
          graphic: bind if (model.showTopicsThatHaveNoImage) {
            ImageView {
              image: Image {
                url: "{__DIR__}images/lightbulb_on.png";
              }
            }
          }
          else {
            ImageView {
              image: Image {
                url: "{__DIR__}images/lightbulb.png";
              }
            }
          }
        }
      ]
    },
    // Help Menu
    Menu {
      text: "Help"
      items: [
        MenuItem {
          text: "About"
          action: function() {
            Alert.inform("About BandmatesFX",
                         "Developed by Jim Weaver/JFXtras team to "
                         "demonstrate JFXtras (and Freebase) features.");
          }
          graphic: ImageView {
            image: Image {
              url: "{__DIR__}images/about.png";
            }
         }
        }
      ]
    }
  ]
}

Stage {
  title: bind "TopicMapNavigator - {model.nameToFind}"
  scene: sceneRef = ResizableScene {
    width: 800
    height: 600
    content: [
      ResizableVBox {
        nodeHPos: HPos.CENTER
        spacing: 10
        content: [
          menubar,
          upperContainer = VBox {
            spacing: 10
            content: [
              HBox {
                spacing: 10
                content: [
                  ImageView {
                    image: bind Image {
                      url: "{model.freebaseImageURL}{model.artistToSearch}?maxheight={model.IMAGE_HEIGHT}"
                    }
                    onMousePressed:function(me:MouseEvent) {
                      if (me.button == MouseButton.SECONDARY) {

                        peopleTable.rows = model.allPeopleOfGivenTypeTopics;

                        if (runningAsApplet) {
                          AppletStageExtension.showDocument("http://www.freebase.com/view/{model.artistToSearch}", "_blank");
                        }
                        else {
                          def basicService:BasicService = ServiceManager.lookup("javax.jnlp.BasicService") as BasicService;
                          def url:URL = new URL("http://www.freebase.com/view/{model.artistToSearch}");
                          basicService.showDocument(url);
                        }
                      }
                      /* Experimenting with putting data from a query into a JFXtras Table
                      else {
                        model.obtainNamesForType("/soccer/football_player", peopleTable);
                      }
                      */
                    }
                  },
                  googleMapContainer = VBox {
                    visible: bind model.showLocationMap
                    spacing: 10
                    content: [
                      googleMapRef = GoogleMap {
                        focusTraversable: true
                        //opacity: bind if (model.showLocationMap) 1.0 else 0.0
                        disable: bind not model.showLocationMap
                        width: model.IMAGE_HEIGHT - 24
                        height: model.IMAGE_HEIGHT - 24
                        zoom: 4.0
                        onKeyPressed:function(ke:KeyEvent):Void {
                          println("googleMapRef.zoom:{googleMapRef.zoom}");
                          if (ke.code == KeyCode.VK_UP) {
                            googleMapRef.zoom += 1;
                          }
                          else if (ke.code == KeyCode.VK_DOWN) {
                            googleMapRef.zoom -= 1;
                          }
                        }
                      },
                      Label {
                        text: bind "Place of Birth: {model.freebaseResult.result.peoplePersonPlaceOfBirth.name}"
                        font: Font.font(null, FontWeight.BOLD, 12)
                      }
                    ]
                  },

                  /* Experimenting with putting data from a query into a JFXtras Table
                  peopleTable = Table {
                    //rows: model.allPeopleOfGivenTypeTopics
                    rows: model.dummy
                    rowHeight: 100
                  }
                  */

                ]
              },
              VBox {
                content: [
                  HBox {
                    spacing: 10
                    content: [
                      textBoxRef = TextBox {
                        promptText: "Enter artist name"
                        text: bind model.nameToFind with inverse
                        columns: 20
                        font: Font.font(null, 14)
                        action:function():Void {
                          if (model.nameToFind != "" and (model.req.percentDone == 0.0 or model.req.percentDone == 100.0)) {
                            model.obtainIdForArtistPartialName(model.nameToFind);
                          };
                        }
                        onKeyTyped:function(ke:KeyEvent) {
                          //println("req.percentDone:{req.percentDone}");
                          if (textBoxRef.rawText != "" and (model.req.percentDone == 0.0 or
                                                            model.req.percentDone == 100.0)) {
                            model.obtainIdForArtistPartialName(textBoxRef.rawText);
                          }
                        }
                      },
                      ProgressIndicator {
                        progress: bind model.req.progress
                      }
                    ]
                  },
                  listViewRef = ListView {
                    visible: bind model.suggestionsVisible
                    height: bind if (model.suggestionsVisible) 100 else 0
                    items: bind for (rslt in model.freebaseSearchResult.result) {
                      rslt.name
                    }
                    layoutInfo: LayoutInfo {
                      width: bind textBoxRef.width - 10
                      height: 80
                    }
                  }
                ]
              }
            ]
          },
          Shelf {
            reflection: false
            showScrollBar: false
            showText: true
            centerEventsOnly: false
            imageUrls: bind for (grp in model.teamTopics) {
              "{model.freebaseImageURL}{grp.id}?maxheight={model.IMAGE_HEIGHT}"
            }
            imageNames: bind for (grp in model.teamTopics) {
              grp.name;
            }
            onImagePressed:function(se:ShelfEvent):Void {
              if (se.mouseEvent.button == MouseButton.SECONDARY) {
                def fbId = model.teamTopics[se.index].id;
                if (runningAsApplet) {
                  AppletStageExtension.showDocument("http://www.freebase.com/view/{fbId}", "_blank");
                }
                else {
                  def basicService:BasicService = ServiceManager.lookup("javax.jnlp.BasicService") as BasicService;
                  def url:URL = new URL("http://www.freebase.com/view/{fbId}");
                  basicService.showDocument(url);
                }
              }
              else if (se.center) {
                var mmbr = model.teamTopics[model.groupOneIndex];
                model.nameToFind = mmbr.name;
                model.artistToSearch = mmbr.id;
                model.obtainGroupsForArtist(mmbr.id);
              }
            }
            onImageEntered:function(se:ShelfEvent):Void {
              //println("Entered image:{se.index}, obj:{se.mouseEvent.node}");
              //println(teamTopics[se.index].name);
              model.infoBoxName = model.teamTopics[se.index].name;
              model.infoBoxVisible = true;
              infoBoxPosX = se.mouseEvent.node.localToScene(se.mouseEvent.node.layoutBounds).minX;
              infoBoxPosY = se.mouseEvent.node.localToScene(se.mouseEvent.node.layoutBounds).minY;
            }
            onImageExited:function(se:ShelfEvent):Void {
              model.infoBoxVisible = false;
            }
            index: bind model.groupOneIndex with inverse
            //wrap: true
            thumbnailWidth: model.IMAGE_HEIGHT
            thumbnailHeight: model.IMAGE_HEIGHT
            layoutInfo: LayoutInfo {
              width: bind sceneRef.width
              height: model.IMAGE_HEIGHT + 120
            }
          },
          Shelf {
            opacity: bind model.shelfOpacity
            reflection: false
            showScrollBar: false
            showText: true
            centerEventsOnly: false
            imageUrls: bind for (mmbr in model.teamTopics[model.groupOneIndex].people) {
              "{model.freebaseImageURL}{mmbr.id}?maxheight={model.IMAGE_HEIGHT}"
            }
            imageNames: bind for (mmbr in model.teamTopics[model.groupOneIndex].people) {
              mmbr.name
            }
            onImagePressed:function(se:ShelfEvent):Void {
              if (se.mouseEvent.button == MouseButton.SECONDARY) {
                def fbId = model.teamTopics[model.groupOneIndex].people[se.index].id;
                if (runningAsApplet) {
                  AppletStageExtension.showDocument("http://www.freebase.com/view/{fbId}", "_blank");
                }
                else {
                  def basicService:BasicService = ServiceManager.lookup("javax.jnlp.BasicService") as BasicService;
                  def url:URL = new URL("http://www.freebase.com/view/{fbId}");
                  basicService.showDocument(url);
                }
              }
              else if (se.center) {
                def mmbrs = model.teamTopics[model.groupOneIndex].people;
                def mmbr = for (m in mmbrs where m.imageUrl == se.url) m;
                if (sizeof mmbr > 0) {
                  model.nameToFind = mmbr[0].name;
                  model.artistToSearch = mmbr[0].id;
                  model.obtainGroupsForArtist(mmbr[0].id);
                }
              }
            }
            onImageEntered:function(se:ShelfEvent):Void {
              model.infoBoxName = model.teamTopics[model.groupOneIndex].people[se.index].name;
              model.infoBoxVisible = true;
              infoBoxPosX = se.mouseEvent.node.localToScene(se.mouseEvent.node.layoutBounds).minX;
              infoBoxPosY = se.mouseEvent.node.localToScene(se.mouseEvent.node.layoutBounds).minY;
            }
            onImageExited:function(se:ShelfEvent):Void {
              model.infoBoxVisible = false;
            }
            index: bind model.artistTwoIndex with inverse
            layoutInfo: LayoutInfo {
              width: bind sceneRef.width
              height: model.IMAGE_HEIGHT + 120
            }
          }
        ]
      },
      /* //TODO: Use this hovering-shows-a-node logic in some other way,
         //      perhaps showing the node closer to the mouse
      javafx.scene.Group {
        layoutX: bind infoBoxPosX
        layoutY: bind infoBoxPosY
        visible: bind model.infoBoxVisible
        content:
          Stack {
            content: [
              Rectangle {
                width: 250
                height: 40
                stroke: Color.LIGHTBLUE
                strokeWidth: 3
                fill: Color.WHITE
                arcWidth: 20
                arcHeight: 20
              },
              Text {
                textOrigin: TextOrigin.TOP
                font: Font.font(null, FontWeight.BOLD, 16)
                content: bind model.infoBoxName
              }
            ]
          }
      }
      */
    ]
  }
}

// Hide the splash page stage if we're not running as an applet
if (not runningAsApplet) {
  splashStageRef.close();
}

upperContainer.toFront();
model.obtainGroupsForArtist(model.artistToSearch);

