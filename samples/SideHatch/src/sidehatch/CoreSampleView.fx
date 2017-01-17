/*
 * CoreSampleView.fx
 *
 * Created on Sep 29, 2009, 8:41:39 PM
 */

package sidehatch;


import javafx.scene.Group;
import javafx.scene.Node;

import javafx.scene.shape.Rectangle;


import javafx.scene.paint.LinearGradient;

import javafx.scene.paint.Stop;

import javafx.geometry.Point2D;

import javafx.scene.Scene;

import javafx.scene.text.Text;


import javafx.scene.paint.Paint;

import javafx.scene.control.Control;
import javafx.scene.layout.Container;
import javafx.scene.paint.Color;

import javafx.scene.shape.Shape;

import javafx.scene.layout.Panel;
import javafx.util.Sequences;

import javafx.scene.CustomNode;
import javafx.scene.layout.Resizable;

import javafx.scene.input.MouseEvent;

/**
 * @author josh
 */

function colorToHSB(color:Color):Float[] {
    var c1a = new java.awt.Color(color.red,color.green,color.blue);
    var c1 = java.awt.Color.RGBtoHSB(c1a.getRed(), c1a.getGreen(), c1a.getBlue(),null);
    c1[0] = c1[0]*360;
    return c1;
}


public class CoreSampleView extends Panel {
    public-init var mainPanel:MainPanel;

    override var onLayout = function():Void {
        var count = getManaged(content).size();
        var h:Float = (height-1)/count;

        for(node in getManaged(content)) {
            resizeNode(node,width,h);
            positionNode(node,0,indexof node * h)
        }
    }


    init {
        content = [
            Sample { height: 100/2 }
            Sample { height: 100/2}
        ];
    }

    override function getPrefHeight(width: Number) : Number {
        return 100;
    }

    override function getPrefWidth(height: Number) : Number {
        return 80;
    }
    

function getGrad(color:Color):LinearGradient {
    var c1 = colorToHSB(color);
    var c1a = Color.hsb(c1[0],c1[1],0.5);
    var c1b = Color.hsb(c1[0],c1[1],1.0);
    LinearGradient {
        startX: 0 startY: 0 endX: width endY: 0 proportional: false
        stops: [
            Stop{ offset: 0 color: c1a }
            Stop{ offset: 1 color: c1b }
        ]
    }
}

    function pickNodes(nodes:Node[], point:Point2D):Node[] {
        var results:Node[];
        for(n in nodes) {
            var pt = n.sceneToLocal(point);
            if(n.contains(pt)) {
                insert n into results;
            }
            if(n instanceof Group) {
                insert pickNodes((n as Group).content, point) into results;
            }
        }
        return results;
    }

    function getNodeColor(node:Node):Paint {
        if(node instanceof Container) {
            return TexturePaint{};
        }
        if(node instanceof Control) {
            return Color.LIGHTBLUE;
        }
        if(node instanceof Shape) {
            var shape = node as Shape;
            return shape.fill;
        }
        if(node instanceof Group) {
            return TexturePaint{};
        }
        return Color.GRAY;
    }


    public function generateSample(scene:Scene, selectedXY:Point2D):Void {
        println("doing a core sample in scene {scene} at {selectedXY}");
        //var list = scene.impl_pick(selectedXY.x, selectedXY.y);
        var list = pickNodes(scene.content,selectedXY);
        var n = list.size();
        content = for(o in Sequences.reverse(list)) {
            println("found : {o}");
            var node = o as Node;
            Sample {
                node: node
                height: height/n
                panel: mainPanel
            }
        }
    }
}

class Sample extends CustomNode, Resizable {
    override function getPrefHeight(width: Number) : Number {
        return 20;
    }

    override function getPrefWidth(height: Number) : Number {
        return 20;
    }
    
    public-init var node:Node;
    public-init var panel:MainPanel;

    var rect = Rectangle {
        height: bind height
        width: bind width
        fill: LinearGradient {
            startX: 0 startY: 0 endX: 20 endY: 0 proportional: false
            stops: [
                Stop { offset: 0 color: Color.rgb(0,0,0,0.3) }
                Stop { offset: 0.49 color: Color.rgb(0,0,0,0.0) }
                Stop { offset: 0.51 color: Color.rgb(255,255,255,0.0) }
                Stop { offset: 1.0 color: Color.rgb(255,255,255,0.3) }
           ]
        }
    }

    
    override var width on replace {
        rect.fill = LinearGradient {
            startX: 0 startY: 0 endX: width endY: 0 proportional: false
            stops: [
                Stop { offset: 0 color: Color.rgb(0,0,0,0.3) }
                Stop { offset: 0.49 color: Color.rgb(0,0,0,0.0) }
                Stop { offset: 0.51 color: Color.rgb(255,255,255,0.0) }
                Stop { offset: 1.0 color: Color.rgb(255,255,255,0.3) }
           ]
        };
    }

    override var onMouseClicked = function(e:MouseEvent):Void {
        println("clicked on a sample");
        panel.selectNode(node);
    }



    override function create():Node {
        var c = getNodeColor(node);
        var flip = false;
        if(c instanceof Color) {
            var b = colorToHSB(c as Color)[2];
            var s = colorToHSB(c as Color)[1];
            println("brightness = {b}");
            if(b < 0.7 or s > 0.5) {
                flip = true;
            }
        }



        return Group {
            content:[
                Rectangle {
                    height: bind height-1
                    width: bind width-2
                    fill: c
                    stroke: Color.BLACK
                }
                rect,
                Text {
                    x: 5
                    y: 16
                    content: "{node.getClass().getSimpleName()}"
                    fill: if(flip) Color.BLACK else Color.WHITE
                }
                Text {
                    x: 5
                    y: 15
                    content: "{node.getClass().getSimpleName()}"
                    fill: if(flip) Color.WHITE else Color.BLACK
                }
            ]
        }

    }
}
