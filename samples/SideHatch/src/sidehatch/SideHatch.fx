package sidehatch;

import javafx.scene.CustomNode;
import javafx.scene.shape.Rectangle;
import javafx.scene.Node;
import javafx.scene.paint.Color;
import javafx.scene.text.Text;
import com.sun.javafx.tk.swing.FrameStage;
import javafx.geometry.Bounds;
import javafx.animation.KeyFrame;
import javafx.animation.Timeline;
import javafx.geometry.Point2D;
import javafx.lang.FX;
import javafx.scene.Group;
import javafx.scene.Scene;
import javafx.scene.control.Control;
import javafx.scene.shape.Circle;
import javafx.scene.shape.Line;
import javafx.stage.Stage;
import com.sun.javafx.perf.PerformanceTracker;
import java.lang.Boolean;
import java.lang.String;
import java.lang.Void;
import sidehatch.MainPanel;
import sidehatch.MainPanel.*;
import javafx.geometry.BoundingBox;

import javafx.scene.layout.LayoutInfo;

/**
 * @author joshua@marinacci.org
 */

var sidehatch:SideHatch;
public function activate():Void {
    println("activating sidehatch");
    if(sidehatch == null) {
        sidehatch = SideHatch{}
    }
}

function forceToAlwaysOnTop(stage:Stage):Void {
    try {
        var fs = stage.impl_getPeer() as FrameStage;
        fs.window.setAlwaysOnTop(true);
    } catch (exception:java.lang.Exception) {
        exception.printStackTrace();
    }

}

public class SideHatch {
    var stage:Stage;
    public-read var globalFPS = 0.0;
    var globalNodeCount = 0;
    var overlaySelected = false on replace {
        if(overlaySelected) {
            showOutlineOverlay();
        } else {
            hideOutlineOverlay();
        }
    }

    var tracker: PerformanceTracker;
    var tTracker = Timeline {
      repeatCount: Timeline.INDEFINITE
      keyFrames: [
          KeyFrame {
              time: 500ms
              action: function() {
                  globalFPS = tracker.getInstantFPS();
              }
          }
      ]
    };

    var mainPanel:MainPanel = MainPanel {
        sideHatch: this
        width: bind scene.width
        height: bind scene.height
        overlaySelected: bind overlaySelected with inverse;
    };

    var currentMarker = Rectangle { stroke: Color.RED strokeWidth: 2 strokeDashArray: [10,10] fill: Color.TRANSPARENT layoutInfo: LayoutInfo { managed: false } };
    var selectedNode:NodeProxy = bind mainPanel.selectedNode on replace {
        var n = selectedNode.node;
        var bb: BoundingBox = n.localToScene(n.boundsInLocal) as BoundingBox;
        currentMarker.layoutX = bb.minX;
        currentMarker.layoutY = bb.minY;
        currentMarker.width = bb.width;
        currentMarker.height = bb.height;
        for(s in Stage.stages) {
            if(not isPrivateStage(s)) {
                delete currentMarker from s.scene.content;
                insert currentMarker into s.scene.content;
            }
        }
    };


    var scene:Scene = Scene {
        fill: Color.rgb(200,200,200)
        content: mainPanel
    };
    
    init {

        stage = Stage {
            title: "SideHatch"
            width: 500
            height: 700
            scene: scene
        }
        
        forceToAlwaysOnTop(stage);
        for(s in stage.stages) {
            if(s != stage) {
                stage.x = s.x + s.width - 100;
                stage.y = s.y;
            }
        }
        tTracker.play();
    }
    

    var propStage:Stage;
    function showSystemProperties():Void {
        if(propStage == null) {
            var props = java.lang.System.getProperties();
            var text = "";
            for(key in props.keySet()) {
                var value = props.getProperty(key as String);
                text = "{text}{key} = {value}\n";
            }
            propStage = Stage {
                width: 500
                height: 500
                scene: Scene {
                    content: [
                        Text {
                            content: text
                            x: 5
                            y: 12
                        }
                    ]
                }
            }
        }
        propStage.visible = true;
        forceToAlwaysOnTop(propStage);
    }


    function dumpAllStages():Void {
        for(s in Stage.stages) {
            if(isPrivateStage(s)) continue;
            printStage(s);
        }
    }

    function isPrivateStage(s:Stage):Boolean {
        if(s == stage) return true;
        if(s == propStage) return true;
        return false;
    }


    function printStage(s:Stage):Void {
        p("stage = {s}");
        indent();
        p("title = {s.title}");
        p("visible = {s.visible}");
        p("dimensions = {s.x},{s.y} - {s.width} x {s.height}");
        printScene(s.scene);
    }
    function printScene(s:Scene):Void {
        p("scene = {s}");
        indent();
        p("dimensions = {s.x},{s.y} - {s.width} x {s.height}");
        p("fill = {s.fill}");
        p("content = ");
        indent();
        printNodes(s.content);
    }

    function printNodes(nodes:Node[]):Void {
        for(c in nodes) {
            p("node = {c}");
            p("   bounds = {c.boundsInParent}");
            if(c instanceof Group) {
                indent();
                printNodes((c as Group).content);
            }
        }
    }




    function showOutlineOverlay():Void {
        globalNodeCount = 0;
        for(s in stage.stages) {
            if(not isPrivateStage(s)) {
                var overlay = OutlineOverlay { stage: s sideHatch: this };
                insert overlay into s.scene.content;
            }
        }
    }

    function hideOutlineOverlay():Void {
        for(s in stage.stages) {
            if(not isPrivateStage(s)) {
                for(c in s.scene.content) {
                    if(c instanceof OutlineOverlay) {
                        delete c from s.scene.content;
                    }
                }
            }
        }
    }




    var indentCount = 0;
    var tabString:String;
    function indent():Void {
        indentCount++;
        var str:String;
        for(i in [0..indentCount-1]) {
            str = "{str}  ";
        };
        tabString = str;
    }

    function p(s:String):Void {
        println("{tabString}{s}");
    }

}

class OutlineOverlay extends CustomNode {
    public-init var stage:Stage;
    public-init var sideHatch:SideHatch;

    var selectedNodeBounds:Bounds;
    var selectedNode:Node on replace {
        var bounds = selectedNode.boundsInLocal;
        selectedNodeBounds = selectedNode.localToScene(bounds);
        popup.translateX = selectedNodeBounds.minX + 30;
        popup.translateY = selectedNodeBounds.minY + 100;
    }
    
    var popup = Group {
        visible: bind selectedNode != null
        content:[
            Rectangle {
                x: 10 y: 10
                width: 250
                height: 100
                fill: Color.rgb(255, 255, 255, 0.9);
                stroke: Color.GRAY
            }

            Text {
                x: 3+10 y: 13+10
                content: bind
                    "class = {selectedNode.getClass().getName()}\n"
                    "id = {selectedNode.id}\n"
                    "bounds = {selectedNodeBounds.minX},{selectedNodeBounds.minY} - {selectedNodeBounds.width}x{selectedNodeBounds.height}\n"
                    "blocks mouse = {selectedNode.blocksMouse}\n"
            }
        ]

    };


    def pulseGroup:Group = Group{};

    var cursorX = 0.0;
    var cursorY = 0.0;
    var blockit = true;
    override function create():Node {
        return Group {
            content:[
                //main overlay
                Rectangle {
                    x: stage.scene.x
                    y: stage.scene.y
                    width: stage.scene.width
                    height: stage.scene.height
                    fill: Color.rgb(255,0,0,0.1)
                    blocksMouse: bind blockit
                }

                pulseGroup,
                // overlays for each node
                Group {
                    content: getOverlays(stage.scene.content)
                }

                popup,
                Rectangle {
                    x: stage.scene.x
                    y: stage.scene.y
                    width: stage.scene.width
                    height: stage.scene.height
                    fill: Color.TRANSPARENT
                    onMousePressed: function(e) {
                        var pulseAnim = PulseAnim{ x: e.x y: e.y, target:pulseGroup};
                        pulseAnim.play();
                        var x = e.x;
                        var y = e.y;
                        FX.deferAction(function():Void{
                            blockit = false;
                            sideHatch.mainPanel.coreSampleView.generateSample(stage.scene, Point2D{x: x y: y} );
                            blockit = true;
                        });
                    }
                    onMouseMoved: function(e) {
                        cursorX = e.x;
                        cursorY = e.y;
                    }

                }
                Line {
                    startX: 0
                    endX: bind stage.scene.width
                    startY: bind cursorY
                    endY: bind cursorY
                    stroke: Color.rgb(0,0,0,0.5)
                }
                Line {
                    startX: bind cursorX
                    endX: bind cursorX
                    startY: 0
                    endY: bind stage.scene.height
                    stroke: Color.rgb(0,0,0,0.5)
                }

            ]
        };
    }

    function getOverlays(nodes:Node[]):NodeOverlay[] {
        var level1 = for(c in nodes) {
            if(c == this) {
                null
            } else {
                sideHatch.globalNodeCount++;
                NodeOverlay {
                    node: c
                    overlay: this
                }
            }
        }
        for(c in nodes) {
            if(c instanceof Group) {
                var g = c as Group;
                var level2 = getOverlays(g.content);
                insert level2 into level1;
            }
            else if(c instanceof CustomNode) {
                var g = c as CustomNode;
                var level2 = getOverlays(g.impl_content);
                insert level2 into level1;
            }
            else if (c instanceof Control) {
                var g = (c as Control).skin.node as Group;
                var level2 = getOverlays(g.content);
                insert level2 into level1;
            }
        }

        return level1;
    }

}

class NodeOverlay extends CustomNode {
    public-init var node:Node;
    public-init var overlay:OutlineOverlay;
    override var blocksMouse = true;
    var r:Rectangle;
    override function create():Node {
        var bounds = node.boundsInLocal;
        bounds = node.localToScene(bounds);
        translateX = bounds.minX;
        translateY = bounds.minY;
        r = Rectangle {
            width: bounds.width
            height: bounds.height
            fill: Color.TRANSPARENT
            stroke: Color.rgb(100,0,0,0.4)
            onMouseEntered: function(e) {
                overlay.selectedNode = this.node;
            }
        }
        return Group { content: [r] }
    }
}

class PulseAnim {
    public-init var x = 0.0;
    public-init var y = 0.0;
    public-init var target:Group;

    var radius = 0.0;
    var shape = Group {
        content: [
            Circle { centerX: x centerY: y stroke: Color.BLUE fill: null radius: bind radius strokeWidth: 3}
            Circle { centerX: x centerY: y stroke: Color.LIGHTBLUE fill: null radius: bind radius }
        ]
    }

    
    var anim = Timeline {
        keyFrames: [
            at(0s) { radius => 0; shape.opacity => 1.0 }
            at(0.7s) { radius => 50; shape.opacity => 0.0 }
            KeyFrame {
                time: 1.01s
                action: function() {
                    delete shape from target.content;
                }
            }
        ]
    }

    public function play() {
        insert shape into target.content;
        anim.play();
    }

}
