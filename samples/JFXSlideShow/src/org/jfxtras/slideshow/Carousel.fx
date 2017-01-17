package org.jfxtras.slideshow;
/*
 * Carousel.fx
 *
 * Created on Oct 6, 2009, 11:49:08 AM
 */



import javafx.scene.Node;

import javafx.scene.layout.Container;

import javafx.util.Math;

import javafx.scene.layout.Stack;

import javafx.scene.shape.Rectangle;

import javafx.scene.Group;

import javafx.scene.effect.PerspectiveTransform;

import javafx.animation.Timeline;
import javafx.scene.Scene;
import javafx.stage.Stage;


import javafx.scene.layout.VBox;

import javafx.scene.layout.HBox;

import javafx.scene.control.Button;

import javafx.scene.control.Label;

import javafx.animation.KeyFrame;


import java.util.LinkedList;

/**
 * @author jimclarke
 */

def accentColor = com.sun.javafx.scene.control.caspian.Caspian.ACCENT_COLOR;
def baseColor = com.sun.javafx.scene.control.caspian.Caspian.BASE_COLOR;
def strongBaseColor = com.sun.javafx.scene.control.caspian.Caspian.STRONG_BASE_COLOR;
def darkTextColor = com.sun.javafx.scene.control.caspian.Caspian.DARK_TEXT_COLOR;
def textColor = com.sun.javafx.scene.control.caspian.Caspian.TEXT_COLOR;
def lightTextColor = com.sun.javafx.scene.control.caspian.Caspian.LIGHT_TEXT_COLOR;
def markColor = com.sun.javafx.scene.control.caspian.Caspian.MARK_COLOR;
def lightMarkColor = com.sun.javafx.scene.control.caspian.Caspian.LIGHT_MARK_COLOR;

class QEntry {
    public var startNdx: Integer;
    public var targetNdx: Integer;

    override function toString() : String {
        "QENtry: {startNdx} => {targetNdx}";
    }

}


class Slot extends ResizableCustomNode {
    public-init var carousel:Carousel;
    public var node: Node;
    public var ndx: Integer;
    public var minCenter: Number;
    public var maxCenter: Number;
    override function getPrefWidth(w: Number):Number {
        Container.getNodePrefWidth(node);
    }
    override function getPrefHeight(w: Number):Number {
        Container.getNodePrefHeight(node);
    }
    bound function getOpacity():Number {
        var x = layoutX + translateX;
        if(x < minCenter) {
            (x + width/2.0) / minCenter;
        }else if(x > maxCenter) {
            1.0 - (x - maxCenter) / (carousel.width - maxCenter);
        }else {
            1.0;
        }
    }

    var opac: Number = bind getOpacity() on replace {
        this.opacity = opac;
    }

    public var perspectiveSkew = 10.0;

    var ly_offset : Number = bind calcLyOffset();

    var ry_offset : Number = bind calcRyOffset();

    bound function calcRyOffset() : Number {
        var minX = layoutX + translateX;
        var maxX = minX + width;
        if(maxX < minCenter) {
            perspectiveSkew
        }else if(minX > minCenter) {
            0.0
        }else {
            var delta = (minCenter - minX)/width;
            delta * perspectiveSkew
        }
    }
     bound function calcLyOffset() : Number {
        var minX = layoutX + translateX;
        var maxX = minX + width;
        if(minX > maxCenter) {
            perspectiveSkew
        }else if(maxX < maxCenter) {
            0.0
        }else {
            var delta = (maxX - maxCenter)/width;
            delta * perspectiveSkew
        }
    }


    public override function create() : Node {
        Stack {
            width: bind width
            height: bind height
            effect: PerspectiveTransform {
                    ulx: 0.0 uly: bind ly_offset
                    urx: bind width ury: bind ry_offset
                    llx: 0.0 lly: bind height - ly_offset
                    lrx: bind width lry: bind height - ry_offset
                }
            content: [
                Rectangle {
                    width: bind width
                    height: bind height
                    fill: baseColor
                },
                Group { content: bind node }

            ]
        }

    }

}


public class Carousel extends ResizableCustomNode {
    public var slotTranslate: Number;
    public var targetTranslate: Number;
    var slotWidth = bind if(numSlots > 0) (width-spacing*(numSlots+1))/numSlots else 100.0;
    public var minCenter: Number = bind (width-slotWidth) / 2.0 - spacing + 1;
    public var maxCenter: Number = bind (width+slotWidth) / 2.0 + spacing - 1;
    public var animationDuration = 1000ms;
    public var spacing: Number = 10.0 on replace {
        layoutSlots();
    }
    var currentNdx: Integer;

    public var numSlots: Integer = 11 on replace {
        if(numSlots mod 2 == 0) {
            numSlots++;
        } else {
            

            slots = for(i in [0..<numSlots]) {
                Slot {
                    ndx: i-mid
                    carousel: this
                    width: bind slotWidth
                    height: bind height
                    translateX: bind slotTranslate
                    minCenter: bind minCenter
                    maxCenter: bind maxCenter
                }
            }
            layoutSlots();
        }
    }
    var mid = bind numSlots/2;
    var midslot:Slot = bind slots[mid];

    function layoutSlots() {
        //slotWidth = (width-spacing*(numSlots+1))/numSlots;
        var xx = spacing;
        for(s in slots) {
            s.layoutX = xx;
            xx += slotWidth + spacing;
        }
    }


    /**
     * indicates whether the carousel should wrap the nodes or not.
     */
    public var wrap = false;
    var slots: Slot[];


    public var nodes: Node[] on replace oldValues [lo..hi] = newValues {
        for(s in slots) {
            s.node = null;
        }
        var i = -mid;
        for (s in slots[0..<mid]) {
            s.ndx = i;
            i++;
        }

        for( s in slots[mid..] ) {
            s.node = if(i < sizeof nodes)  nodes[i] else null;
            s.ndx = i;
            i++;
        }
        layoutSlots();

    }



    override var width on replace old {
        if(isInitialized(width)) {
          slotTranslate = 0;
          layoutSlots();
          shiftTo(currentNdx);
        }
    }


    public override function getPrefHeight(h: Number) {
        if(sizeof nodes > 0) {
            var hh = 0.0;
            for(n in nodes) {
                hh = Math.max(hh, Container.getNodePrefHeight(n));
            }
            hh;
        } else {
            100.0;
        }
    }

    public override function getPrefWidth(w:Number) {
        if(numSlots > 0 and slotWidth > 0)
            numSlots * slotWidth
        else
            100.0;
    }

    var queue = LinkedList{};

    var shiftLeftTL = Timeline {
        repeatCount: 1
        keyFrames : [
            at(0s) {
                slotTranslate => slotTranslate;
            }
            KeyFrame {
                time: animationDuration
                values: slotTranslate => targetTranslate
                action: function() {
                    while(sizeof slots > numSlots) {
                        slots[0].node = null;
                        delete slots[0];
                    }
                    shifting = false;
                    //println("+++++++ Finished ShiftLeft to {slots[mid].ndx}  +++++++++++");
                    FX.deferAction( function() {
                        drainQueue();
                    });
                }
            }
        ]
    }
    var shiftRightTL = Timeline {
        repeatCount: 1
        keyFrames : [
            at(0s) {
                slotTranslate => slotTranslate;
            }
            KeyFrame {
                time: animationDuration
                values: slotTranslate => targetTranslate
                action: function() {
                    while(sizeof slots > numSlots) {
                        slots[sizeof slots - 1].node = null;
                        delete slots[sizeof slots - 1];
                    }
                    shifting = false;
                    //println("+++++++ Finished ShiftRight to {slots[mid].ndx}  +++++++++++");
                    FX.deferAction( function() {
                        drainQueue();
                    });
                    
                }
            }
        ]
    }

   var shifting = false;

   function drainQueue() : Void {
       if(queue.size() > 0) {
           shifting = true;
           //println(" *** DeQueue *****");
           var startIndex: Integer;
           var endIndex : Integer;
           var startEntry = queue.poll() as QEntry;
           var endEntry:QEntry = if(not queue.isEmpty()) queue.removeLast() as QEntry else null;
           queue.clear();
           var move = if(endEntry == null) startEntry else QEntry{startNdx: startEntry.startNdx, targetNdx: endEntry.targetNdx};
           //println(" *** Dequeue - {move}");
           if(move.startNdx > move.targetNdx) {
               doShiftRight(move);
           }else if(move.startNdx < move.targetNdx) {
               doShiftLeft(move);
           } else {
               shifting = false;
           }
       }


   }


    public function shift(count: Integer) : Void {
        shiftTo(count + currentNdx);
    }

    public function shiftTo(ndx: Integer) : Void {
        if(sizeof nodes == 0) return;
        var entry = QEntry{ startNdx: currentNdx, targetNdx: ndx };
        currentNdx = ndx;
        queue.add(entry);
        //println("********   Enqueue {entry}");
        if(not shifting)
            drainQueue();
    }



    public function shiftLeft(count: Integer) : Void {
       shift(count);
    }

    function doShiftLeft(entry: QEntry) : Void {
       shifting = true;
       var midIndex = slots[mid].ndx;
       if(midIndex < sizeof nodes - 1) {
           var count = entry.targetNdx - entry.startNdx;
           var lastSlot = slots[sizeof slots - 1];
           var lastX = lastSlot.layoutX + lastSlot.layoutBounds.width + spacing;
           var ndx = lastSlot.ndx + 1;
           if(midIndex + count >= sizeof nodes - 1) {
               count = sizeof nodes - midIndex - 1;
           }

           for(i in [0..<count]) {
               var slot:Slot = Slot {
                    carousel: this
                    width: bind slotWidth
                    height: bind height
                    layoutX: lastX
                    translateX: bind slotTranslate
                    ndx: ndx
                    node: nodes[ndx]
                    minCenter: bind minCenter
                    maxCenter: bind maxCenter
                }
                insert slot into slots;
                lastX += spacing + slotWidth;
                ndx++;
            }
            targetTranslate = slotTranslate - count *(slotWidth + spacing);

            shiftLeftTL.playFromStart();

        }
    }

    public function shiftRight(count: Integer): Void {
       shift(-count);
    }
    function doShiftRight(entry: QEntry) : Void {
        shifting = true;
        var midIndex = slots[mid].ndx;
        if(midIndex > 0) {
            var count = entry.startNdx  - entry.targetNdx;
            var ndx = slots[0].ndx - 1;
            if(midIndex - count <= 0) {
               count = midIndex;
            }

            for(i in [0..<count]) {
                var slot:Slot = Slot {
                    carousel: this
                    width: bind slotWidth
                    height: bind height
                    translateX: bind slotTranslate
                    ndx: ndx
                    node: nodes[ndx]
                    layoutX: slots[0].layoutX - spacing - slotWidth
                    minCenter: bind minCenter
                    maxCenter: bind maxCenter
                }
                insert slot before slots[0];
                ndx--;
            }
            targetTranslate = slotTranslate + count * (slotWidth + spacing);
            shiftRightTL.playFromStart();
        }
    }


    postinit {
        layoutSlots();
    }


    public override function create() : Node {
        Group {
            content: bind slots
        }

    }
}


function run() {
    var scene: Scene;
    var hbox: HBox;
    var c: Carousel;
    Stage {
        title : "MyApp"
        scene: scene = Scene {
            width: 600
            height: 100
            content: VBox {
                content: [
                    c= Carousel {
                        width: bind scene.width
                        height: bind scene.height - hbox.layoutBounds.height
                        nodes: for(i in [0..10]) {
                            Label { text: "{i}" }
                        }

                    }
                    hbox = HBox {
                        content: [
                            Button {
                                text: "Left"
                                action: function () {
                                    c.shiftLeft(2);
                                }

                            }
                            Button {
                                text: "Right"
                                action: function () {
                                    c.shiftRight(2);
                                }

                            }
                            Button {
                                text: "Shift 0"
                                action: function () {
                                    c.shiftTo(0);
                                }
                            }
                            Button {
                                text: "Shift 6"
                                action: function () {
                                    c.shiftTo(6);
                                }
                            }
                            Button {
                                text: "Shift 10"
                                action: function () {
                                    c.shiftTo(10);
                                }
                            }

                        ]
                    }



                ]
            }
        }
    }


}
