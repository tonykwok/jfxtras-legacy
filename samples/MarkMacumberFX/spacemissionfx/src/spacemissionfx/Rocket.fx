/*
 * Rocket.fx
 *
 * Created on 01/11/2008, 1:31:44 PM
 */

package spacemissionfx;


import javafx.scene.CustomNode;
import javafx.scene.paint.Color;
import javafx.animation.Timeline;
import javafx.animation.KeyFrame;
import javafx.scene.shape.Circle;

/**
 * @author Mark
 */

public class Rocket extends CustomNode {
    public var x_pos:Number;
    public var y_pos:Number;

    public var vel_x:Number;
    public var vel_y:Number;

    var speed:Number = 1.0;
    
    var screenWidth = 500;
    var screenHeight = 500;

    public var rocketArray:Rocket[];
    public var rocketArrayIdx:Integer;
    
    public var asteroids:Asteroid[];

    var movementTimeLine = Timeline {
        repeatCount: Timeline.INDEFINITE
        keyFrames : [
            KeyFrame {
                time : 30ms
                action: function() {
                    x_pos = x_pos + (vel_x * speed);
                    y_pos = y_pos - (vel_y * speed);
                }
            }
        ]
    }

    init{
        movementTimeLine.play();
    }

    public override function create(){
        return Circle {
            centerX: bind x_pos,
            centerY: bind y_pos
            radius: 2
            fill: Color.WHITE
        }
    }
    
    public function stopLife(){
        movementTimeLine.stop();
    }

}