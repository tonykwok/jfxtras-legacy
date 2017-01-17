/*
 * Main.fx
 *
 * Created on 26-Sep-2009, 21:46:00
 */

package tango;


import org.jfxtras.scene.control.XPicker;
import org.jfxtras.scene.control.XPickerType.*;
import org.jfxtras.scene.control.XPickerType;
import javafx.scene.layout.Tile;
import javafx.scene.text.Text;
import javafx.animation.Timeline;
import javafx.animation.KeyFrame;
import javafx.scene.Node;
import javafx.animation.transition.Transition;
import javafx.animation.transition.FadeTransition;
import javafx.animation.transition.TranslateTransition;
import javafx.animation.Interpolator;
import javafx.animation.transition.ScaleTransition;
import javafx.animation.transition.RotateTransition;


import javafx.geometry.HPos;
import javafx.geometry.VPos;
import javafx.scene.layout.LayoutInfo;
import javafx.scene.Scene;
import javafx.scene.image.ImageView;
import javafx.scene.layout.HBox;
import javafx.scene.layout.VBox;
import javafx.stage.Stage;


/**
 * @author David
 */

var scaleSize = [1, 16, 24, 32, 64];
var scale = XPicker {
  items: ["Small (16x16 png)", "Small (16x16 fzx)", "Medium (24x24 fzx)", "Large (32x32 fzz)", "Massive (64x64 fzx)"  ]
  pickerType: XPickerType.DROP_DOWN
  onIndexChange: function(index){ test(); } preset: 4
  };

var sectionName = ["actions","apps","categories","devices","emblems","emotes","mimetypes","places","status"];
var section = XPicker {
  items: ["Actions", "Applications", "Categories", "Devices", "Emblems", "Emotes", "Mime types", "Places", "Status" ]
  pickerType: XPickerType.DROP_DOWN
  onIndexChange: function(index){ test(); }
  };

var status = Text { content: "Positioning over icon will display name here" };
var display: Tile;

var display16: Tile =  Tile {
  tileHeight: 16
  tileWidth: 16
  columns: 8
  hgap: 2
  vgap: 2
  content: []};

var display24: Tile =  Tile {
  tileHeight: 24
  tileWidth: 24
  columns: 8
  hgap: 2
  vgap: 2
  content: []};

var display32: Tile =  Tile {
  tileHeight: 32
  tileWidth: 32
  columns: 8
  hgap: 2
  vgap: 2
  content: []};

var display64: Tile =  Tile {
  tileHeight: 64
  tileWidth: 64
  columns: 8
  hgap: 2
  vgap: 2
  content: []};

var fn: Node;

var tl = Timeline{
  repeatCount: Timeline.INDEFINITE
  keyFrames: [
    KeyFrame {
      time: 0.2s
      action: function() { fn.visible = false; }
      },
    KeyFrame {
      time: 0.4s
      action: function() { fn.visible = true; }
      }
    ]
  };

var ft = FadeTransition {
        duration: .3s
        node: bind fn
        fromValue: 1.0
        toValue: 0.0
        repeatCount: Transition.INDEFINITE
        autoReverse: true
        action: function(){fn.opacity = 1.0;}
    };

var st = ScaleTransition {
        duration: .5s
        node: bind fn
        fromX: 0.5
        fromY: 0.5
        toX: 1.0
        toY: 1.0
        repeatCount: Transition.INDEFINITE
        autoReverse: true
        interpolator: Interpolator.EASEBOTH
        action: function(){fn.scaleX = 1.0; fn.scaleY = 1.0;}
    };

var ttx = TranslateTransition {
        duration: .3s
        node: bind fn
        fromX: -5.0
        toX: 5.0
        repeatCount: Transition.INDEFINITE
        autoReverse: true
        interpolator: Interpolator.EASEBOTH
        action: function(){fn.translateX = 0.0;}
    };

var rt = RotateTransition {
        duration: 2s
        node: bind fn
        byAngle: 360
        repeatCount: Transition.INDEFINITE
        action: function(){fn.rotate = 0.0;}
    };

var flist: String[] = Tango.actions;

function test(): Void
  {
  if (sectionName[section.selectedIndex].equals("actions")) then flist = Tango.actions;
  if (sectionName[section.selectedIndex].equals("apps")) then flist = Tango.apps;
  if (sectionName[section.selectedIndex].equals("categories")) then flist = Tango.categories;
  if (sectionName[section.selectedIndex].equals("devices")) then flist = Tango.devices;
  if (sectionName[section.selectedIndex].equals("emblems")) then flist = Tango.emblems;
  if (sectionName[section.selectedIndex].equals("emotes")) then flist = Tango.emotes;
  if (sectionName[section.selectedIndex].equals("mimetypes")) then flist = Tango.mimetypes;
  if (sectionName[section.selectedIndex].equals("places")) then flist = Tango.places;
  if (sectionName[section.selectedIndex].equals("status")) then flist = Tango.status;

  if (scaleSize[scale.selectedIndex] == 1) then  display = display16;
  if (scaleSize[scale.selectedIndex] == 16) then display = display16;
  if (scaleSize[scale.selectedIndex] == 24) then display = display24;
  if (scaleSize[scale.selectedIndex] == 32) then display = display32;
  if (scaleSize[scale.selectedIndex] == 64) then display = display64;

  delete display.content;
  for (i in flist)
    {
    if (scaleSize[scale.selectedIndex] != 1)
      {
      var f = Tango.getFXDNode("{sectionName[section.selectedIndex]}/{i}", scaleSize[scale.selectedIndex]);
        f.layoutInfo = LayoutInfo {
          vpos: VPos.TOP
          hpos: HPos.LEFT
          };
        f.onMouseEntered = function(e)
          {
          var fa = f.getNode("Arrow");
          var fas = f.getNode("Arrows");
          var fg = f.getNode("Glow");
          var far = f.getNode("RotateArrows");
          status.content = i;
          if (fa != null)
            {
            fn = fa;
            ft.playFromStart();
            }
          if (fg != null)
            {
            fn = fg;
            ft.playFromStart();
            }
          if (fas != null)
            {
            fn = fas;
            st.playFromStart();
            }
          if (far != null)
            {
            fn = far;
            rt.playFromStart();
            }
          };
        f.onMouseExited = function(e)
          {
          status.content = i;
          if (ttx.running) then { ttx.stop(); fn.translateX = 0.0; }
          if (ft.running) then { ft.stop(); fn.opacity = 1.0; }
          if (st.running) then { st.stop(); fn.scaleX = 1.0; fn.scaleY = 1.0; }
          if (rt.running) then { rt.stop(); fn.rotate = 0.0; }
          };
      insert f into display.content;
      }
     else
      {
      //var img = Image { url: "{__DIR__}small/{sectionName[section.selectedIndex]}/{i}.png"};
      var iv = ImageView { image: Tango.getIcon("{sectionName[section.selectedIndex]}/{i}") };
      insert iv into display.content;
      }
    }
  }

function run()
  {
    test();
Stage {
    title: "Icons"
    width: 600
    height: 800
    scene: Scene {
      content: [
        VBox {
          layoutX: 10
          layoutY: 10
          spacing: 20
          content: bind [
            HBox {
              spacing: 10
              content: bind [
                scale,
                section,
                Tango.getFXDNode("{sectionName[section.selectedIndex]}/{flist[0]}", 48),
                Tango.getFXDNode("{sectionName[section.selectedIndex]}/{flist[0]}", 32),
                Tango.getFXDNode("{sectionName[section.selectedIndex]}/{flist[0]}", 16),
                ImageView { image: Tango.getIcon("{sectionName[section.selectedIndex]}/{flist[0]}") },
                ]
              },
            display,
            status
            ]
          }
        ]
      }
    }
  }

