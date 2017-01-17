/*
 * Copyright (c) 2008-2009, JFXtras Group
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
 * SpeedReaderMain.fx -
 * The main script for the SpeedReaderFX application
 *
 * TODO: Truncate data from feeds when too long, before putting it in the Table.
 * TODO: Save all data, including data last used (so that items can optionally
 *       before that date)
 * TODO: [Test] Make Refresh button remove all rows and mark all feeds dirty
 * TODO: Deal with interval updates of feeds, at some point make configurable
 * TODO: Read FaceBook updates
 * TODO: Create menu items that open web pages such as help, jfxtras site, blog
 * TODO: Show thumbnail popups of images/web pages on hover?
 */
package org.jfxtras.speedreader.ui;

import org.jfxtras.speedreader.model.*;
import java.net.URL;
import javafx.scene.*;
import javafx.scene.control.*;
import javafx.scene.image.*;
import javafx.scene.input.*;
import javafx.stage.*;
import javax.jnlp.*;
import org.jfxtras.scene.*;
import org.jfxtras.scene.control.*;
import org.jfxtras.scene.menu.*;
import org.jfxtras.stage.JFXStage;
import org.jfxtras.scene.image.ImageUtil;
import javafx.geometry.HPos;
import javafx.geometry.VPos;
import javafx.scene.layout.LayoutInfo;

/**
 * Reference to the main model for this app
 */
def model = SpeedReaderModel {};

/**
 * Indicator that we're running as an applet
 */
def runningAsApplet:Boolean = AppletStageExtension.eval("2+3") != null;

var splashStageRef:Stage;

if (not runningAsApplet) {
  splashStageRef = Stage {
    title: "BandmatesFX Splash Page"
    style: StageStyle.TRANSPARENT
    icons: [
      Image { url: "{__DIR__}images/JavaFX64_btn.png" }
      Image { url: "{__DIR__}images/JavaFX32_btn.png" }
    ]
    scene: Scene {
      width: 400
      height: 400
      content: {
        ImageView {
          image: Image {
            url: "http://www.jmentor.com/SpeedReaderFX/images/speedreader_splash.png"
          }
        }
      }
    }
  }
}

/**
 * Index of the currently selected FeedTableItem
 * TODO: Consider changing this to selectedFeedTableItem
 */
var selectedFeedTableItemIndex = bind model.selectedFeedTableItemIndex;

var urlTextBox:TextBox;

var sceneRef:Scene;
var criteriaNodeRef:SpeedReaderCriteriaNode;

var tableRef:Table;

var hideDatePublishedColumn:Boolean = false on replace {
  setupTableColumns();
};

function setupTableColumns() {
  tableRef.columns[0].displayName = "Channel";
  tableRef.columns[1].displayName = "Item";
  tableRef.columns[2].displayName = "Title";
  tableRef.columns[3].displayName = "Date Published";
  tableRef.columns[3].visible = not hideDatePublishedColumn;
  tableRef.columns[4].visible = false;
  tableRef.columns[5].visible = false;
}

function openFeedItemLinkInBrowser(feedTableItem:FeedTableItem):Void {
  if (feedTableItem != null) {
    def linkUrl = feedTableItem.link;
    if (linkUrl != null) {
      //println("Opening URL:{feedTableItem.link}");
      if (runningAsApplet) {
        AppletStageExtension.showDocument(linkUrl, "_blank");
      }
      else {
        def basicService:BasicService = ServiceManager.lookup("javax.jnlp.BasicService") as BasicService;
        def url:URL = new URL(linkUrl);
        basicService.showDocument(url);
      }
    }
    else {
      println("url is:{linkUrl}");
    }
  }
}


var menubar: MenuBar;
menubar = MenuBar {
  width: bind sceneRef.width;
  menus: [
    // Feeds menu
    Menu {
      text: "Channels"
      items: [
//        MenuItem {
//          text: "Load"
//          action: function() {
//            model.feedTableItems = [];
//            model.loadData();
//            model.markAllFeedsDirty();
//            model.startFeedTasks();
//          }
//          graphic: ImageView {
//            image: Image {
//              // TODO: Get a "refresh icon"
//              url: "{__DIR__}images/about.png";
//            }
//          }
//        },
        CheckedMenuItem {
          text: "Configure"
          checked: bind model.showCriteria with inverse
          graphic: bind if (model.showCriteria) {
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
          action: function():Void {
            criteriaNodeRef.refreshFromData();
          }
        },
        MenuItem {
          text: "Refresh"
          action: function() {
            model.markAllFeedsDirty();
            // Note: markAllFeedsDirty disables starting the feed reading
            //       during that operation, so must do manually here
            // TODO: Call startFeedTasks() in markAllFeedsDirty()?
            model.startFeedTasks();
          }
          graphic: ImageView {
            image: Image {
              // TODO: Get a "refresh icon"
              url: "{__DIR__}images/about.png";
            }
          }
        }
      ]
    }
    // Items Menu
//    Menu {
//      text: "Items"
//      items: [
//        CheckedMenuItem {
//          //TODO: Either remove this menu option, or make the selectedFeedItem correct when this is selected
//          text: "Hide Items with No Image"
//          checked: bind model.hideRowsWithNoImage with inverse
//          graphic: bind if (model.hideRowsWithNoImage) {
//            ImageView {
//              image: Image {
//                url: "{__DIR__}images/lightbulb_on.png";
//              }
//            }
//          }
//          else {
//            ImageView {
//              image: Image {
//                url: "{__DIR__}images/lightbulb.png";
//              }
//            }
//          }
//        }
//      ]
//    },
    // View menu
    Menu {
      text: "View"
      items: [
        CheckedMenuItem {
          text: "Always on Top"
          checked: bind alwaysOnTop with inverse
          graphic: bind if (alwaysOnTop) {
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
          //TODO: Either remove this menu option, or make the selectedFeedItem correct when this is selected
          text: "Hide Date Published Column"
          checked: bind hideDatePublishedColumn with inverse
          graphic: bind if (hideDatePublishedColumn) {
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
    }
    // Help Menu
    Menu {
      text: "Help"
      items: [
        MenuItem {
          text: "About"
          action: function() {
            Alert.inform("About SpeedReaderFX",
                         "Developed by Jim Weaver/JFXtras team to read "
                         "multiple social network and news feeds, as well as "
                         "to demonstrate some JFXtras features.");
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

var popupMenuPosX:Integer;
var popupMenuPosY:Integer;
var popupMenu: MenuBar;
popupMenu = MenuBar {
  visible: false
  blocksMouse: true
  menus: [
    // Popup menu
    Menu {
      text: "Click"
      items: [
        MenuItem {
          blocksMouse: true
          text: "Open link in browser"
          action: function() {
            popupMenu.visible = false;
            openFeedItemLinkInBrowser(model.selectedFeedTableItem);
          }
        },
        MenuItem {
          blocksMouse: true
          text: "Hide this feed"
          action: function() {
            popupMenu.visible = false;
            def feedInfo:FeedInfo = model.selectedFeedTableItem.feedInfo;
            if (feedInfo != null) {
              feedInfo.setSelected(false);
              feedInfo.setDirty(true);
            }
          }
        },
        MenuItem {
          blocksMouse: true
          text: bind "Hide all {model.selectedFeedTableItem.feedInfo.type}"
          action: function() {
            popupMenu.visible = false;
            def feedType = model.selectedFeedTableItem.feedInfo.type;
            if (feedType != null) {
              model.deSelectFeedsByType(feedType);
              // Note: markFeedsDirtyByType disables starting the feed reading
              //       during that operation, so must do manually here
              // TODO: Call startFeedTasks() in markFeedsDirtyByType()?
              model.startFeedTasks();
            }
          }
        },
        MenuItem {
          blocksMouse: true
          text: "Show only this feed"
          action: function() {
            popupMenu.visible = false;
            def feedInfo:FeedInfo = model.selectedFeedTableItem.feedInfo;
            if (feedInfo != null) {
              for (feed in model.feedsToRead) {
                if (feed != feedInfo) {
                  feed.setSelected(false);
                }
              }
            }
            model.markAllFeedsDirty();
            model.startFeedTasks();
          }
        },
//        MenuItem {
//          // TODO: Fix issue in which showing only feeds of a given type
//          //       causes some feed request to be a blank tag of user name
//          //       (this is likely due to the fact that the selectedness of
//          //       feed is currently being determined by whether or not the
//          //       associated TextBox (if there is one) contains any characters.
//          blocksMouse: true
//          text: bind "Show only {model.selectedFeedTableItem.feedInfo.type}"
//          action: function() {
//            popupMenu.visible = false;
//            def feedType = model.selectedFeedTableItem.feedInfo.type;
//            if (feedType != null) {
//              model.selectOnlyFeedsByType(feedType);
//              // Note: markFeedsDirtyByType disables starting the feed reading
//              //       during that operation, so must do manually here
//              // TODO: Call startFeedTasks() in markFeedsDirtyByType()?
//              model.startFeedTasks();
//            }
//          }
//        }
      ]
    }
  ]
  layoutInfo: LayoutInfo {
    hpos: HPos.LEFT
    vpos: VPos.TOP
  }
}

var alwaysOnTop:Boolean;
var stageRef:JFXStage;
stageRef = JFXStage {
  title: "SpeedReaderFX"
  alwaysOnTop: bind alwaysOnTop
  icons: [        
    Image { url: "{__DIR__}images/JavaFX64_btn.png" }
    Image { url: "{__DIR__}images/JavaFX32_btn.png" }
  ]  
  scene: sceneRef = ResizableScene {
    menuBar: menubar
    width: 900
    height: 720
    content: [
      tableRef = Table {
        rowType: FeedTableItem{}.getJFXClass();
        rows: bind if (not model.hideRowsWithNoImage) {
          //for (ele in model.feedTableItems) ele
          model.feedTableItems
        }
        else {
          for (ele in model.feedTableItems where (
            ImageUtil.imageTypeSupported(ele.feedTitle) or
            ImageUtil.imageTypeSupported(ele.image)
          )) ele
        }
        rowHeight: 80
        selectedRow: bind model.selectedFeedTableItemIndex with inverse
        onMouseClicked: function(me:MouseEvent) {
          popupMenu.visible = false;
          if (me.button == MouseButton.SECONDARY) {
            popupMenu.translateX = me.x;
            popupMenu.translateY = me.y;
            popupMenu.visible = true;
          }
        }
      },
      criteriaNodeRef = SpeedReaderCriteriaNode {
        model: model
        visible: bind model.showCriteria
        width: bind sceneRef.width - 50
      },
      ProgressIndicator {
        opacity: .5
        scaleX: 5.0
        scaleY: 5.0
        visible: bind if (model.numTasksRunning != 0) true else false
        progress: bind if (model.numTasksRunningHighWatermark != 0) {
            (model.numTasksRunningHighWatermark - model.numTasksRunning) / model.numTasksRunningHighWatermark
        } else {
            1.0
        }
        layoutInfo: LayoutInfo {
          hpos: HPos.CENTER
          vpos: VPos.CENTER
        }
      },
      popupMenu
    ]
  }
}

setupTableColumns();

// Hide the splash page stage if we're not running as an applet
if (not runningAsApplet) {
  splashStageRef.close();
}

//model.loadData();

//TODO: Remove/move when enabling persistence
model.markAllFeedsDirty();
model.startFeedTasks();

//TODO: Put back in when enabling persistence
//FX.addShutdownAction(function(): Void {
//    model.saveData();
//  }
//);

