/*
 * Particle.fx
 *
 * Created on 11/11/2008, 4:14:56 PM
 */

package spacemissionfx.explosions;

import java.util.Random;
import javafx.animation.Interpolator;
import javafx.animation.KeyFrame;
import javafx.animation.Timeline;
import javafx.scene.CustomNode;
import javafx.scene.Node;
import javafx.scene.paint.Color;
import javafx.scene.shape.Circle;
import javafx.scene.shape.Rectangle;
import javafx.scene.transform.Rotate;
import spacemissionfx.explosions.Particle;
import spacemissionfx.explosions.Point2D;

/**
 * @author macumbem
 */

public class Particle extends CustomNode {

    public var xpos:Number;
    public var ypos:Number;
    
    var vec_x:Number;
    var vec_y:Number;
    
    var life_d_min:Number = 4;
    var life_d_max:Number = 8;
    public var life_depletion_interval:Number;
    public var life_points:Number = 100;
    
    var speedMax:Number = 4;
    var speedMin:Number = 3;
    public var speed:Number;
    
    var sizeMin = 1;
    var sizeMax = 4;
    public var size:Number = 2;

    public var CIRCLE = 0;
    public var RECTANGLE = 1;
    public var TRIANGLE = 2;
    
    var selectedType:Integer = 0;
    
    public var vectors:Point2D[];
    
    var rotateAngle:Integer = 5;
    
    public var selfArray:Particle[];
    
    //public var white_intensity:Number = 255;
    
    //    var rotationalTimeline = Timeline {
    //        repeatCount: Timeline.INDEFINITE
    //        keyFrames : [ KeyFrame { time : 30ms, action: function(){ rotateAngle += 2; } } ]
    //    };
    //
    //    var updateTimeline:Timeline = Timeline {
    //        repeatCount: Timeline.INDEFINITE
    //        keyFrames : [ KeyFrame { time : 40ms, action: function(){ update(); } } ]
    //    };

    var movementTimeline = Timeline {
        keyFrames: [
            KeyFrame {
                time: 0s
                canSkip: false
                values: [xpos => xpos,
                    ypos => ypos,
                    rotateAngle => 0,
                    life_points => 100]
            },
            KeyFrame {
                time: 1.4s
                canSkip: false
                values: [xpos => 
                    xpos + (vec_x * speed) tween Interpolator.LINEAR,
                    ypos => ypos + (vec_y * speed) tween Interpolator.LINEAR,
                    rotateAngle => 720,
                    life_points => 0]
            }
        ]
    };
    
    /*
    1. Pick random directional vector
     Pick random speed
     Pick random lifetime
     Pick random size
     Pick random colour

     2. Repeat for all particles

     3. Update each particle according to its speed+vector
     4. if dead (based on lifetime) remove from array
     */
    public override function create():Node{
        var rand = new Random();
        
        //directional vector
        var randInt = rand.nextInt(sizeof vectors - 1);
        var directionalVec = vectors[randInt];
        
        vec_x = directionalVec.x_point;
        vec_y = directionalVec.y_point;
        
        vec_x = vec_x - xpos;
        vec_y = vec_y - ypos;

        //speed, between min and max
        speed = range(speedMin, speedMax, rand);
        
        //lifetime, just faster/slower fadeout
        life_depletion_interval = rand.nextInt(life_d_max) + life_d_min;
        
        //size, between range
        size = range(sizeMin, sizeMax, rand);

        //color
        var colorNumDec = range(9, 15, rand);
        var fillOrNot = rand.nextInt(2);
        var hex = Integer.toString(colorNumDec, 16);
        var fillColor:Color;
        
        if (fillOrNot == 0) {
            fillColor = Color.BLACK;
        } else {
            fillColor = Color.web("#{hex}{hex}{hex}{hex}{hex}{hex}");
        }

        var strokeColor = Color.web("#{hex}{hex}{hex}{hex}{hex}{hex}");
        
        //pick a random particle type
        selectedType = rand.nextInt(3);
        
        //updateTimeline.play();
        movementTimeline.play();
        
        if (selectedType == CIRCLE){
            return Circle {
                centerX: bind xpos, 
                centerY: bind ypos
                radius: 7
                fill: fillColor;
                stroke: strokeColor;
                opacity: bind (life_points / 100);
            }
        //} else if (selectedType == RECTANGLE){

        } else {
            //rotationalTimeline.play();
            return Rectangle {
                x: bind xpos,
                y: bind ypos
                width: 14,
                height: 14
                fill: fillColor
                stroke: strokeColor
                opacity: bind (life_points / 100);
                transforms: bind [Rotate {
                        pivotX: xpos + 7,
                        pivotY: ypos + 7,
                        angle: rotateAngle }]
            }
        }
        
        //triangle
//        var rotation = 0.0;

//        var tip_x = xpos + Math.cos(Math.toRadians(rotateAngle + 0)) * 8;
//        var tip_y = ypos - Math.sin(Math.toRadians(rotateAngle + 0)) * 8;
//
//        var point1_x = xpos + Math.cos(Math.toRadians(rotateAngle + 120)) * 8;
//        var point1_y = ypos - Math.sin(Math.toRadians(rotateAngle + 120)) * 8;
//
//        var point2_x = xpos + Math.cos(Math.toRadians(rotateAngle + 240)) * 8;
//        var point2_y = ypos - Math.sin(Math.toRadians(rotateAngle + 240)) * 8;

//        rotationalTimeline.start();
//        
//        var points:Number[] = [
//            getXPoint(rotateAngle, 0), getYPoint(rotateAngle, 0), 
//            getXPoint(rotateAngle, 140), getYPoint(rotateAngle, 140), 
//            getXPoint(rotateAngle, 220), getYPoint(rotateAngle, 220)
//        ];
//
//        Group {
//            content: [
//                Polygon {
//                    points : bind [ points ]
////                    points : bind [ tip_x , tip_y,
////                                    point1_x, point1_y,
////                                    point2_x, point2_y]
//                    fill: Color.RED
//                    
//                    //opacity: bind (life_points / 100);
//                    
//                    //rotate around the centroid
//                    transform: Rotate { x : bind xpos, y : bind ypos, 
//                                             angle: bind rotateAngle }
//                },
//
//                Circle {
//                    centerX: bind xpos, centerY: bind ypos
//                    radius: 5
//                    fill: Color.GREEN
//                }
//            ]
//        }

    }

//    public function stopLife(){
//        rotationalTimeline.stop();
//        updateTimeline.stop();
//    }

    
//    public function update():Void{
//        //update x and y pos
//        xpos = xpos + (vec_x * speed);
//        ypos = ypos + (vec_y * speed);
//
//        //decrement life points
//        if (life_points - life_depletion_interval < 0){
//            life_points = 0;
//            stopLife();
//        } else {
//            life_points -= life_depletion_interval;
//        }
//    }

    //check if dead
//    public function isDead():Boolean{
//        life_points <= 0
//    }

    function range(min:Number, max:Number, rand:Random):Number {
        var range = max - min + 1;
        var fraction:Number = (range * rand.nextDouble());
        return fraction + min;
    }
}
