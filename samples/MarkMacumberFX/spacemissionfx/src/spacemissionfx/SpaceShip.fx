/*
 * SpaceShip.fx
 *
 * Created on 22/10/2008, 7:43:38 PM
 */

package spacemissionfx;

import javafx.scene.paint.Color;
import javafx.scene.transform.Rotate;
import javafx.scene.CustomNode;
import javafx.animation.Timeline;
import javafx.animation.KeyFrame;
import spacemissionfx.explosions.Point2D;
import java.lang.*;
import javafx.scene.shape.Polygon;

/**
 * @author Mark
 */

public class SpaceShip extends CustomNode {
    var tip_x:Number;
    var tip_y:Number;
    var point1_x:Number;
    var point1_y:Number;
    
    var point2_x:Number;
    var point2_y:Number;
    
    public var velX:Number = 0.0;
    public var velY:Number = 0.0;

    public var accX:Number = 0.0;
    public var accY:Number = 0.0;
    
    public var rotationAngle = 0.0;
    public var distance = 15.0;
    
    var friction:Number = 0.005;
    
    //init the starting position
    public var centroid_x = 0.0;
    public var centroid_y = 0.0;
    
    //rockets that the ship shoots
    public var rockets:Rocket[];
    
    //state based booleans
    public var thrusting:Boolean = false;
    public var turningRight:Boolean = false;
    public var turningLeft:Boolean = false;
    public var shooting:Boolean = false;
    public var dead:Boolean = false;
    
    public var maxAcc:Number = 1.0;
    
    var screenWidth = 500;
    var screenHeight = 500;
    
    public var asteroids:Asteroid[];
    
    var triangle:Polygon;

    init {
        centroid_x = 200.0;
        centroid_y = 200.0;
        timeline.play();
    }

    public override function create(){
        //so as not to bind the angle of the 
        //init points to the rotation angle.
        var tempAngle = rotationAngle;

        triangle = Polygon {
            points : bind [ getXPoint(tempAngle, 0) ,  getYPoint(tempAngle, 0),
                            getXPoint(tempAngle, 140), getYPoint(tempAngle, 140),
                            getXPoint(tempAngle, 220), getYPoint(tempAngle, 220) ];

            fill: Color.WHITE

            //rotate around the centroid
            transforms: [Rotate { pivotX: bind centroid_x,
                                  pivotY : bind centroid_y,
                                  angle: bind rotationAngle }]
        }
        
        triangle;
    }
    
    public function getXTipPoint():Number{
        return getXPoint(rotationAngle, 0);
    }

    public function getYTipPoint():Number{
        return getYPoint(rotationAngle, 0);
    }
    
    public function getPointsOfShip():Point2D[]{
        [
            Point2D{x_point: getXPoint(rotationAngle, 0), 
                    y_point: getYPoint(rotationAngle, 0)},
            
            Point2D{x_point: getXPoint(rotationAngle, 140), 
                    y_point: getYPoint(rotationAngle, 140)},
            
            Point2D{x_point: getXPoint(rotationAngle, 220), 
                    y_point: getYPoint(rotationAngle, 220)}
        ];
    }

    
    bound function getXPoint(rotation:Number, offset:Number): Number{
        centroid_x + Math.cos(Math.toRadians(rotation + offset)) * distance;
    }

    bound function getYPoint(rotation:Number, offset:Number): Number {
        centroid_y - Math.sin(Math.toRadians(rotation + offset)) * distance;
    }

    var timeline = Timeline{
        repeatCount: Timeline.INDEFINITE
        keyFrames : [
            KeyFrame {
                time : 5ms
                action : function() {
                    if (accX > 0 or accY > 0) {
                        var velocity_x:Number = 0.0;
                        var velocity_y:Number = 0.0;

                        velocity_x = accX * Math.cos(Math.toRadians(rotationAngle));
                        velocity_y = accY * Math.sin(Math.toRadians(rotationAngle));
                        
                        accX -= friction;
                        accY -= friction;

                        velX = velocity_x;
                        velY = velocity_y;

                        centroid_x += velX;
                        centroid_y += velY;

                        //if off to the left
                        if (centroid_x <= 0) {
                            //move the left most point to the right hand side
                            centroid_x += screenWidth;
                        }

                        //if off to the right
                        if (centroid_x >= screenWidth) {
                            //move the left most point to the right hand side
                            centroid_x -= screenWidth;
                        }

                        //if off to the bottom
                        if (centroid_y >= screenHeight) {
                            //move the left most point to the right hand side
                            centroid_y -= screenHeight;
                        }
                    
                        //if off to the top
                        if (centroid_y <= 0) {
                            //move the left most point to the right hand side
                            centroid_y += screenHeight;
                        } 
                    }
                }
            }
        ]
    }
    
    public function startAcceleration(){
        accel_timeline.play();
    }
    
    public function stopAcceleration(){
        accel_timeline.stop();
    }
    
    public function startTurning(){
        turning_timeline.play();
    }
    
    public function stopTurning(){
        turning_timeline.stop();
    }
    
    var rocketTimeline = Timeline {
        repeatCount: Timeline.INDEFINITE
        keyFrames : [
            KeyFrame {
                time : 0s
                action: function(){
                    var r = createRocket();
                    insert r into rockets;
                    r.rocketArrayIdx = sizeof rockets - 1;
                }
            },
            KeyFrame {
                time : 500ms
                action: function(){
                    var r = createRocket();
                    insert r into rockets;
                    r.rocketArrayIdx = sizeof rockets - 1;
                }
            }
        ]
    }
    
    public function stopShootingRockets():Void{
        if (shooting) {
            shooting = false;
            rocketTimeline.stop();
        }
    }
    
    public function shootRocket():Void {
        if (not shooting) {
            shooting = true;
            rocketTimeline.play();
        }
    }
    
    function createRocket():Rocket {
        var new_rocket = Rocket {
            x_pos: centroid_x
            y_pos: centroid_y
            asteroids: bind asteroids;
        };

        new_rocket.vel_x = getXTipPoint() - centroid_x;
        new_rocket.vel_y = getYTipPoint() - centroid_y;
        return new_rocket;
    }

    
    //timeline to check if the rockets are out of the screen
    //if so, remove them
    var rocketsTimeline = Timeline {
        repeatCount: Timeline.INDEFINITE
        keyFrames : [
            KeyFrame {
                time : 1s
                action: function(){
                    for (r:Rocket in rockets){
                        if (r.x_pos <= 0 or 
                            r.x_pos >= screenWidth or 
                            r.y_pos <= 0 or 
                            r.y_pos >= screenHeight) {
                            delete r from rockets;
                        }
                    }
                }
            }
        ]
    };

    //accelleration timeline for movement
    var accel_timeline = Timeline {
        repeatCount: Timeline.INDEFINITE
        keyFrames : [
            KeyFrame {
                time : 30ms
                action: function(){
                    if (thrusting) {
                        accX += 0.3; 
                        accY += 0.3;
                        if (
                        accX > maxAcc) 
                        accX = maxAcc;
                        if (accY > maxAcc) 
                        accY = maxAcc;
                    }
                }
            }
        ]
    }

    //turnin timeline for the turning of the ship
    var turning_timeline = Timeline {
        repeatCount: Timeline.INDEFINITE
        keyFrames : [
            KeyFrame {
                time :30ms
                action: function() {
                    if(turningRight) {
                        rotationAngle += 8.50;
                    } else if(turningLeft) {
                        rotationAngle -= 8.50;
                    }
                }
            }
        ]
    }
}
