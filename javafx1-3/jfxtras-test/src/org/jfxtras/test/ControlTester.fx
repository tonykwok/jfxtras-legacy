/*
 * Copyright (c) 2008-2010, JFXtras Group
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
 */
package org.jfxtras.test;

import javafx.stage.Stage;
import javafx.scene.Scene;
import javafx.scene.layout.Panel;
import javafx.scene.shape.Rectangle;
import javafx.scene.paint.Color;
import javafx.scene.layout.Container;
import com.javafx.preview.layout.Grid;
import javafx.geometry.Insets;
import com.javafx.preview.layout.GridRow;
import javafx.scene.control.Slider;
import com.javafx.preview.layout.GridLayoutInfo;
import javafx.geometry.HPos;
import javafx.scene.paint.LinearGradient;
import javafx.scene.paint.Stop;
import javafx.scene.Node;
import javafx.scene.Group;
import javafx.scene.layout.Resizable;
import javafx.scene.layout.VBox;
import javafx.scene.control.TextBox;
import javafx.scene.layout.HBox;
import javafx.scene.layout.LayoutInfo;
import javafx.geometry.VPos;
import javafx.scene.control.Button;
import javafx.scene.control.ToggleButton;
import javafx.scene.effect.DropShadow;
import javafx.scene.control.CheckBox;
import javafx.scene.control.Tooltip;
import javafx.scene.image.ImageView;
import javafx.scene.image.Image;
import javafx.scene.CustomNode;
import javafx.scene.paint.Paint;
import java.lang.Math;
import javafx.reflect.*;
import javafx.scene.Node;

public function run( args : String[] ){
    if (sizeof args == 0){
        println( "Need the fully qualyified class name of the control under test as parameter.");
        return null;
    }

    var controlTypeName = args[0];

    var context = FXLocal.getContext();
    var controlType = context.findClass( controlTypeName );

    var control:Node = controlType.allocate().initialize().asObject() as Node;

    println("Instantiating control tester with control under test <{control}>");

    ControlTester {
        component: control
    }
}



public class ControlTester {
  function getComponentPrefWidth() {
    if ( componentIsResizable )
      componentAsResizable.getPrefWidth( 0 )
    else 0
  }

  function getComponentPrefHeight() {
    if ( componentIsResizable )
      componentAsResizable.getPrefHeight( 0 )
    else 0
  }

  var bgFillValue = Color.DARKGRAY.blue on replace {
    if ( bgFillValue < 0 ) bgFillValue = 0;
    if ( bgFillValue > 255 ) bgFillValue = 255;
  };
  var backgroundFill = bind Color.rgb( bgFillValue, bgFillValue, bgFillValue );
  var bgPicOpacity = 0.0;
  public-init var panelHeight = 600;
  public-init var panelWidth = 800;
  var componentIsResizable = bind component instanceof Resizable;
  var componentAsResizable = bind if ( componentIsResizable ) component as Resizable else null;
  public-init var component: Node;
  public var bg1 = Color.LIGHTGRAY;
  public var bg2 = Color.DARKGRAY;
  public var minSizeColor = Color.BLUE;
  public var layoutBoundsColor = Color.ORANGE;
  public var boundsInLocalColor = Color.RED;
  var selectedWidth: Number = getComponentPrefWidth() on replace {
    if ( selectedWidth < 1 ) {
      selectedWidth = 1;
    }
    if ( selectedWidth > panelWidth ) {
      selectedWidth = panelWidth;
    }

    if ( componentIsResizable ) {
      componentAsResizable.width = selectedWidth;
    }
  };
  var selectedHeight: Number = getComponentPrefHeight() on replace {
    if ( selectedHeight < 1 ) {
      selectedHeight = 1
    }
    if ( selectedHeight > panelHeight ) {
      selectedHeight = panelHeight
    }

    if ( componentIsResizable ) {
      componentAsResizable.height = selectedHeight;
    }
  };
  var dropShadowAdded: Boolean on replace {
    component.effect = if ( dropShadowAdded ) DropShadow {} else null
  }
  var layoutBoundsVisible: Boolean = true;
  var boundsInLocalVisible: Boolean = true;
  public var bgImage = Image {
      url: "{__DIR__}coffee.jpg"
       width: panelWidth
      height: panelHeight
    }

  init {
    def stage: Stage = Stage {
      resizable: false
        title: "Testing Component <{component}>"
         scene: Scene {
          var panel: Panel
                    
          content: [
            //Background
            Rectangle {
              id: "background"
              width: bind stage.scene.width
              height: bind stage.scene.height
              fill: bind LinearGradient {
                stops:  [
                  Stop {
                    color:  bg1
                  },
                  Stop {
                    color:  bg2
                    offset:  1.0
                  },
                ]
              }
            },
            Grid {
              def space = 5;
              padding: bind Insets { bottom:  space, left:  space, right:  space, top:  space }
              width: bind stage.scene.width - space * 2 - 10
              height: bind stage.scene.height - space * 2 - 10
              hgap: 10
              vgap: 10
              rows: [
                GridRow {
                  cells: [
                    Group {},
                    HBox {
                      layoutInfo: GridLayoutInfo {
                        hspan: 2
                      }
                      spacing: space
                      nodeVPos: VPos.CENTER
                      content: [
                        Slider {
                          disable: bind not componentIsResizable
                          min: 1
                          max: panelWidth
                          blockIncrement: 10
                          value: bind selectedWidth with inverse
                          vertical: false
                          layoutInfo: LayoutInfo {
                            hfill: true
                          }
                        }
                        TextBox {
                          text: bind "{%.0f selectedWidth}"
                          editable: false
                          columns: 4
                          selectOnFocus: true
                            layoutInfo: LayoutInfo {
                            hfill: false
                          }
                        }
                        Button {
                          disable: bind not componentIsResizable
                          text: "Pref"
                          action: function() {
                            setToPrefSize();
                          }
                        }
                        Button {
                          disable: bind not componentIsResizable
                          text: "Min"
                          action: function() {
                            setToMinSize();
                          }
                        }
                        Button {
                          disable: bind not componentIsResizable
                          text: "Max"
                          action: function() {
                            setToMaxSize();
                          }
                        }
                        ToggleButton {
                            text: "DropShadow"
                            selected: bind dropShadowAdded with inverse
                        }
                      ]
                    },
                  ]
                },
                GridRow {
                  vfill: true
                  cells: [
                    VBox {
                      nodeHPos:HPos.CENTER
                      spacing: space
                      content: [
                        Slider {
                          disable: bind not componentIsResizable
                          min: 1
                          max: panelHeight
                          blockIncrement: 10
                          value: bind selectedHeight with inverse
                          vertical: true
                          layoutInfo: GridLayoutInfo {
                            vfill: true
                          }
                        },
                        TextBox {
                          editable: false
                          text: bind "{%.0f selectedHeight}"
                          columns: 4
                          selectOnFocus: true
                        },
                        CheckBox {
                          text: "lb"
                          selected: bind layoutBoundsVisible with inverse
                          tooltip: Tooltip{
                            text: "Whether the layoutBounds are shown"
                          }
                        }
                        CheckBox {
                          text: "bil"
                          selected: bind boundsInLocalVisible with inverse
                          tooltip: Tooltip {
                            text: "Whether the boundsInLocal are shown"
                          }
                        },
                        Slider {
                          min: 0
                          max: 255
                          vertical: true
                          value: bind bgFillValue with inverse;
                        }
                        Slider {
                          vertical:true
                          min: 0
                          max: 1
                          value: bind bgPicOpacity with inverse
                        }
                      ]
                    },
                    {
                      panel = Panel {
                          minWidth: function () {
                            panelWidth
                          }
                          minHeight: function () {
                            panelHeight
                          }
                          prefWidth: function ( n ) {
                            panelWidth
                          }
                          prefHeight: function ( n ) {
                            panelHeight
                          }
                          onLayout: function (): Void {
                            for ( node in Container.getManaged( panel.content ) ) {
                              var x = panel.width / 2 - node.layoutBounds.width / 2;
                              var y = panel.height / 2 - node.layoutBounds.height / 2;

                              Container.positionNode( node, x, y, true );
                            }
                          }
                          content: [
                            Background {
                              stroke: Color.DARKGRAY
                              fill: bind backgroundFill
                            }
                            ImageView {
                              image: bind bgImage
                              opacity: bind bgPicOpacity
                            }
                            Background {
                              fill: null
                              stroke: bind minSizeColor
                              strokeDashArray: [ 1, 3 ]
                              strokeDashOffset: 1                              
                              height: bind Container.getNodeMinHeight( component )
                              visible: bind layoutBoundsVisible
                              opacity: 0.5
                            }
                            Background {
                              fill: null
                              stroke: bind minSizeColor
                              strokeDashArray: [ 1, 3 ]
                              strokeDashOffset: 1
                              width: bind Container.getNodeMinWidth( component )
                              visible: bind layoutBoundsVisible
                              opacity: 0.5
                            }
                            Background {
                              fill: null
                              stroke: bind layoutBoundsColor
                              strokeDashArray: [ 1, 3 ]
                              strokeDashOffset:1
                              width: bind component.layoutBounds.width
                              visible: bind layoutBoundsVisible
                              opacity:0.5
                            }
                            Background {
                              fill: null
                              stroke: bind layoutBoundsColor
                              strokeDashArray: [ 1, 3 ]
                              strokeDashOffset: 1
                              height: bind component.layoutBounds.height
                              visible:bind layoutBoundsVisible
                              opacity: 0.5
                            }
                            Background {
                              fill: null
                              stroke: bind boundsInLocalColor
                              strokeDashArray: [1,3]
                              width: bind component.boundsInLocal.width
                              visible: bind boundsInLocalVisible
                              opacity: 0.5
                            }
                            Background {
                              fill: null
                              stroke: bind boundsInLocalColor
                              strokeDashArray: [ 1, 3 ]
                              height: bind component.boundsInLocal.height
                              visible: bind boundsInLocalVisible
                              opacity: 0.5
                            }
                            component
                          ]
                        }

                      setToPrefSize();
                      panel
                    },
                    Rectangle {
                      width: 3
                      height: bind component.layoutBounds.height
                      fill: layoutBoundsColor
                    }
                  ] },
                GridRow {
                  hpos: HPos.CENTER
                  hfill: true
                  cells: [
                    Group {
                    },
                    Rectangle {
                      height: 3
                      width: bind component.layoutBounds.width
                      fill: layoutBoundsColor
                      layoutInfo: GridLayoutInfo {
                        hpos: HPos.CENTER
                      }
                    }
                  ]
                }
              ]
            },
          ]
        }
      }

      setToPrefSize();
      bgFillValue = 255;
  }


  function setToPrefSize(){
    selectedHeight = Container.getNodePrefHeight( component );
    selectedWidth = Container.getNodePrefWidth( component );
  }

  function setToMinSize(){
    selectedHeight = Container.getNodeMinHeight( component );
    selectedWidth = Container.getNodeMinWidth( component );
  }

  function setToMaxSize(){
    selectedHeight = Math.min( Container.getNodeMaxHeight( component ), panelHeight );
    selectedWidth = Math.min( Container.getNodeMaxWidth( component ), panelWidth );
  }
}


//Does there exist any component like that? Is this useful?
public class Background extends CustomNode {
  public var fill: Paint = Color.DARKGRAY;
  public var stroke: Paint = Color.DARKGRAY;
  public var width: Number on replace {
    requestLayout();
  }
  public var height: Number on replace {
    requestLayout();
  }
  public var strokeDashArray: Number[ ];
  public var strokeDashOffset: Number;

  init {
    children = [
        Rectangle {
          width: bind if ( width > 0 ) width else ( parent as Resizable ).width
          height: bind if ( height > 0 ) height else ( parent as Resizable ).height
          fill: bind fill
          stroke: bind stroke
          strokeDashArray: bind strokeDashArray
          strokeDashOffset: bind strokeDashOffset
        }
      ];
  }

}
