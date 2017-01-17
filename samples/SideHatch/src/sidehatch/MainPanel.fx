/*
 * MainPanel.fx
 *
 * Created on Sep 29, 2009, 5:48:56 PM
 */

package sidehatch;

import javafx.scene.Scene;
import javafx.stage.Stage;
import sidehatch.util.*;


import javafx.scene.control.ListView;
import javafx.scene.layout.Panel;
import javafx.scene.control.ToggleGroup;
import javafx.util.Sequences;
import java.lang.String;
import sidehatch.util.StretchyBox;

import javafx.animation.KeyFrame;
import javafx.animation.Timeline;
import javafx.geometry.HPos;
import javafx.geometry.VPos;
import javafx.scene.CustomNode;
import javafx.scene.Group;
import javafx.scene.Node;
import javafx.scene.control.Control;
import javafx.scene.control.Label;
import javafx.scene.control.ToggleButton;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;
import javafx.scene.layout.Stack;
import javafx.scene.layout.VBox;
import javafx.scene.paint.Color;
import javafx.scene.paint.LinearGradient;
import javafx.scene.paint.Stop;
import javafx.scene.shape.Shape;

/**
 * @author josh
 */

public class MainPanel extends Panel {
    public-init var sideHatch:SideHatch;
    public var overlaySelected = false;
    public var coreSampleView:CoreSampleView = CoreSampleView { mainPanel: this };
    var usedMem = 0.0;
    var totalMem = 0.0;
    
    var listItems:Object[] = ["nothing"];
    var listView = ListView {
        layoutInfo: StretchyBox.GROW
        items: bind listItems
    }
    public var selectedNode:NodeProxy;
    var selectedItem = bind listView.selectedItem on replace {
        if(selectedItem instanceof NodeProxy){
            selectedNode = selectedItem as NodeProxy;
        }
    }
    
    var toggle = ToggleGroup { }

    var infoButton:ToggleButton = ToggleButton { text: "info" focusTraversable: false
        toggleGroup: toggle
        graphic: ImageView {
            image: Image {
                url: "{__DIR__}help-contents.png"
            }
        }
        graphicHPos: HPos.CENTER
        graphicVPos: VPos.BOTTOM
    };
    var graphButton = ToggleButton { text: "graph" focusTraversable: false
        toggleGroup: toggle
        graphic: ImageView {
            image: Image {
                url: "{__DIR__}view-tree.png"
            }
        }
        graphicHPos: HPos.CENTER
        graphicVPos: VPos.BOTTOM
    };

    
    var selectedToggle = bind toggle.selectedButton on replace {
        if(selectedToggle == infoButton) {
           infoAction();
        } else {
            graphAction();
        }
    }



    
    init {
        content = StretchyVBox {
            width: bind width
            height: bind height
            content:[
                //toolbar
                StretchyHBox {
                    spacing: 10
                    content:[
                        infoButton,
                        graphButton,
                        StretchyBox.Spacer{ width: 5}
                        ToggleButton { text: "overlay" focusTraversable: false
                            graphic: ImageView {
                                image: Image {
                                    url: "{__DIR__}system-search.png"
                                }
                            }
                            graphicHPos: HPos.CENTER
                            graphicVPos: VPos.BOTTOM
                            selected: bind overlaySelected with inverse;
                        }
                    ]
                }

                // core sample and main area
                StretchyHBox {
                    layoutInfo: StretchyBox.GROW
                    content: [
                        listView,
                        coreSampleView,
                    ]
                }
                Stack {
                    content: [
                        ResizeRect { fill: LinearGradient {
                            startX: 0 endX: 1 startY: 0 endY: 0 proportional: true
                            stops: [
                                Stop { offset: 0 color: Color.rgb(100,100,100) }
                                Stop { offset: 1 color: Color.rgb(130,130,130) }
                            ]
                        }}
                        VBox {
                            spacing: 4
                            content:[
                                Label { text: bind "class: {selectedNode.node.getClass().getName()}" textFill: Color.WHITE }
                                Label { text: bind "id: {selectedNode.node.id}" textFill: Color.WHITE }
                                Label { text: bind "blocksMouse: {selectedNode.node.blocksMouse}" textFill: Color.WHITE }
                                Label { text: bind "bounds: {selectedNode.node.boundsInLocal}" textFill: Color.WHITE }
                                Label { text: bind "fill: {getFill(selectedNode.node)}" textFill: Color.WHITE }
                            ]
                        }
                    ]
                }

                Stack {
                    content: [
                        ResizeRect { fill: LinearGradient {
                            startX: 0 endX: 0 startY: 0 endY: 1 proportional: true
                            stops: [
                                Stop { offset: 0 color: Color.rgb(70,70,70) }
                                Stop { offset: 1 color: Color.rgb(0,0,0) }
                            ]
                        }}
                        StretchyHBox {
                            spacing: 10
                            content: [
                                Label { text: bind "System FPS {sideHatch.globalFPS}" textFill: Color.WHITE }
                                Label { text: bind " mem {%.1f usedMem/1024.0/1024.0}Mb/{%.1f totalMem/1024.0/1024.0}Mb" textFill: Color.WHITE }
                            ]
                        }
                    ]
                }

            ]
        }

        memWatcher = Timeline {
            repeatCount: Timeline.INDEFINITE
            keyFrames: KeyFrame {
                time: 1s
                action: function() {
                    var runtime = java.lang.Runtime.getRuntime();
                    totalMem = runtime.totalMemory();
                    var freeMem = runtime.freeMemory();
                    usedMem = totalMem-freeMem;
                }
            }
        };
        memWatcher.play();
    }

    function getFill(node:Node):String {
        if(node instanceof Shape) {
            var shape = node as Shape;
            if(shape.fill instanceof Color) {
                var color = shape.fill as Color;
                return "({%.2f color.red},{%.2f color.green},{%.2f color.blue})a={%.2f color.opacity}";
            }
        }
        return "--";
    }


    var memWatcher:Timeline;

    function infoAction():Void {
        var props = java.lang.System.getProperties();
        var text = "";
        var strings = for(key in props.keySet()) {
            key as String;
        }

        listItems = for(key in Sequences.sort(strings)) {
            var value = props.getProperty(key as String);
            "{key} = {value}";
        }
    }

    var graphItems:NodeProxy[];
    function clearItems():Void {
        graphItems = null;
    }
    function p(s:String):Void {
        insert NodeProxy { string: s } into graphItems;
    }
    function p(s:String, node:Node):Void {
        insert NodeProxy { string: s node:node } into graphItems;
    }
    
    function printStage(s:Stage):Void {
        p("stage = {s}");
        printScene(s.scene);
    }
    function printScene(s:Scene):Void {
        p("scene = {s}");
        printNodes(s.content,"  ");
    }

    function printNodes(nodes:Node[],tab:String):Void {
        for(c in nodes) {
            p("{tab}{c}",c);
            if(c instanceof Group) {
                printNodes((c as Group).content,"{tab}|  ");
            }
            else if (c instanceof CustomNode) {
                printNodes ((c as CustomNode).impl_content,"{tab}|  ");
            }
            else if (c instanceof Control) {
                printNodes (((c as Control).skin.node as Group).content,"{tab}|  ");
            }
        }
    }


    function graphAction():Void {
        clearItems();
        for(s in Stage.stages) {
            if(s == this.scene.stage) continue;
            printStage(s);
        }
        listItems = graphItems;
    }

    public function selectNode(node:Node) {
        for(item in graphItems) {
            if(item.node == node) {
                listView.select(indexof item);
            }
        }
    }


}
function run() {

    var scene:Scene = Scene {
        fill: Color.rgb(150,150,150)
        content: MainPanel {
            width: bind scene.width
            height: bind scene.height
        }
    }

    Stage {
        width: 500
        height: 700
        scene: scene
        title: "SideHatch"
    }

}

public class NodeProxy {
    public-init var string:String;
    public-init var node:Node;
    override function toString():String {
        return string;
    }
}
