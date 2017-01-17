/*
 * Asteroid.fx
 *
 * Created on 11/11/2008, 8:45:50 PM
 */

package spacemissionfx;

import javafx.scene.CustomNode;
import javafx.scene.Node;
import javafx.scene.shape.Polygon;
import javafx.scene.shape.Rectangle;
import java.util.*;
import javafx.scene.transform.Translate;
import javafx.scene.paint.Color;
import javafx.animation.Timeline;
import javafx.animation.KeyFrame;
import spacemissionfx.Rocket;

/**
 * @author Mark
 */

public class Asteroid extends CustomNode {

    //maximum lines that the asteroid will have
    public var maxLines = 11;
    
    //min angle difference between points on the asteroid
    public var minimumAngleDiff = 10;
    
    //starting x and y positions
    public var cirCenterX = 250;
    public var cirCenterY = 250;
    
    //maximum screen space
    public var maxAvailableX:Integer;
    public var maxAvailableY:Integer;
    
    //radius of the asteroid
    public var cirRadiusConst;
    var cirRadius;
    
    //speed
    var speed:Number = 1.5;

    //directional velocity
    var velocityX:Number = 1;
    var velocityY:Number = 0;

    //x and y translation
    var xTranslation:Number;
    var yTranslation:Number;

    //represents the asteroid
    var asteroid:Polygon;
    var asteroidPoints:Number[];

    //populate the lines array
    var rand = new Random();

    //the spaceship's location
    public var shipX:Number;
    public var shipY:Number;
    var shipBufferRadius:Number = 120;
    
    var asteroidRotation:Number = 5;
    
    var hitPoints:Integer = 1;
    var hitPointsMax:Integer = 3;
    var hitPointsMin:Integer = 1;
    
    var lifeColor:Color;
    
    var lifeColors:Color[] = [
        Color.BLACK,        //Weak
        Color.GREY,         //Average
        Color.LIGHTGREY     //Strong
    ];
    
    var movementTimeline = Timeline {
        repeatCount: Timeline.INDEFINITE
        keyFrames : [
            KeyFrame {
                time : 30ms
                action : function() {
                    xTranslation += velocityX * speed;
                    yTranslation += velocityY * speed;

                    var x_pos = cirCenterX + xTranslation;
                    var y_pos = cirCenterY + yTranslation;

                    if (x_pos + cirRadiusConst <= 0){
                        xTranslation = (495 - cirCenterX) + cirRadiusConst;
                    } else if (x_pos - cirRadiusConst >= 500){
                        xTranslation = -cirCenterX - cirRadiusConst;
                    } else if (y_pos - cirRadiusConst > 500) {
                        yTranslation = -cirCenterY - cirRadiusConst;
                    } else if (y_pos + cirRadiusConst < 0){
                        yTranslation = (500 - cirCenterY) + cirRadiusConst
                    }
                }
            }
        ]
    }
    
    var rotationTimeline = Timeline {
        repeatCount: Timeline.INDEFINITE
        keyFrames : [
            KeyFrame {
                time : 20ms
                action : function() {
                    asteroidRotation += 0.50;
                }
            }
        ]
    }
    
    public override function create():Node{
        cirRadiusConst = pickRadius();
        
        var degrees = 360;
        var n = degrees / maxLines;
        var lastAngle = 0;
        var plvDiff = cirRadiusConst / 3;
        
        //velocity
        velocityX = rand.nextGaussian();
        velocityY = rand.nextGaussian();
        
        //pick starting x and y positions
        var bufferRect = Rectangle{
            width: shipBufferRadius * 2;
            height: shipBufferRadius * 2;
            x: shipX - shipBufferRadius;
            y: shipY - shipBufferRadius;
        };
        
        cirCenterX = pickStartX();
        cirCenterY = pickStartY();
        
        while (bufferRect.boundsInParent.contains(cirCenterX, cirCenterY)){
            cirCenterX = pickStartX();
            cirCenterY = pickStartY();
        }

        for(val in [0..maxLines - 1]) {
            cirRadius = cirRadiusConst;
            
            var lower = lastAngle;
            var upper = (n * (val + 1) - 1);
            var angle = rand.nextInt(upper);

            while (
            angle < lower or angle > upper or angle < (lastAngle + plvDiff)) {
                angle = rand.nextInt(upper);
            }

            //pont length variance
            cirRadius = rand.nextInt(plvDiff + plvDiff) + (cirRadius - plvDiff);

            //get x and y of line
            var xpos = bind calcXPos(velocityX, angle);
            var ypos = bind calcYPos(velocityY, angle);

            insert xpos into asteroidPoints;
            insert ypos into asteroidPoints;

            lastAngle = angle;
        }
        
        //determine life points of asteroid
        hitPoints = rand.nextInt(hitPointsMax) + hitPointsMin;
        lifeColor = lifeColors[hitPoints - 1];
        
        asteroid = Polygon {
            points: bind asteroidPoints;
            stroke:Color.WHITE;
            transforms: bind [Translate.rotate(asteroidRotation, cirCenterX, cirCenterY)];
            translateX: bind xTranslation;
            translateY: bind yTranslation;
            fill: bind lifeColor;
        }

        rotationTimeline.play();
        movementTimeline.play();
        
        return asteroid;
    }

    public function isPointInsideAsteroid(argx:Number, argy:Number):Boolean{
        asteroid.boundsInParent.contains(argx, argy);
    }
    
    public function shootAsteroid(rocket:Rocket):Boolean{
        if (asteroid.boundsInParent.contains(rocket.x_pos, rocket.y_pos)){
            //decrement life points
            hitPoints--;

            //change color
            if (hitPoints > 0) {
                lifeColor = lifeColors[hitPoints - 1];
            }

            //shot was sucessful
            return true;
        }
        //missed
        return false;
    }
    
    public function isDead():Boolean{
        hitPoints == 0;
    }
    
    function calcXPos(velocityX, angle){
        (cirRadius * java.lang.Math.cos(angle * (java.lang.Math.PI / 180))) + cirCenterX
    }

    function calcYPos(velocityY, angle){
        (cirRadius * java.lang.Math.sin(angle * (java.lang.Math.PI / 180))) + cirCenterY
    }

    function pickRadius():Integer{
        rand.nextInt(45) + 10;
    }

    function pickStartX():Integer{
        rand.nextInt(maxAvailableX - cirRadiusConst);
    }

    function pickStartY():Integer{
        rand.nextInt(maxAvailableY - cirRadiusConst);
    }
    
    public function stopLife(){
        movementTimeline.stop();
        rotationTimeline.stop();
    }
}
