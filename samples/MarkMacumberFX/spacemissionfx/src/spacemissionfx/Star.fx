/*
 * Star.fx
 *
 * Created on 19/11/2008, 9:27:09 AM
 */

package spacemissionfx;

import javafx.scene.CustomNode;
import javafx.scene.Node;
import javafx.scene.shape.Circle;
import javafx.scene.paint.Color;
import javafx.animation.Timeline;
import javafx.animation.KeyFrame;
import javafx.lang.Duration;
import java.lang.*;
import java.util.Random;
import javafx.scene.shape.Rectangle;
/**
 * @author macumbem
 */

public class Star extends CustomNode {
    
    public var screenWidthMax:Number = 0.0;
    public var screenHeightMax:Number = 0.0;
    
    var xpos:Number = 0.0;
    var ypos:Number = 0.0;
    
    var offColor:Color = Color.web("#222222");
    var onColor:Color = Color.WHITE;
    
    var currentColor:Color = onColor;
    
    var rand = new Random();
    
    var durations:Integer = 4;

    var twinkleTimeline:Timeline = Timeline {
        repeatCount: Timeline.INDEFINITE
        keyFrames : bind for (idx:Integer in [1..durations]){
           KeyFrame {
                time : Duration.valueOf(getRandomDuration(idx));
                action: function(){
                    if (idx mod 2 == 0){
                        currentColor = onColor;
                    } else {
                        currentColor = offColor;
                    }
                }
            } 
        }
    };
    
    function getRandomDuration(index:Integer):Number{
        /*
          Get number between last index and next index:
          between 0(index - 1) and 1(index) (i.e. 0.87)
          between 1(index - 1) and 2(index) (i.e. 1.23)
          between 2(index - 1) and 3(index) (i.e. 2.40)
        */
        range(index - 1, index) * 1000;
    }

    function range(min:Number, max:Number):Number {
        var range = max - min + 1;
        var fraction:Number = (range * rand.nextDouble());
        return fraction + min;
    }

    init{
        twinkleTimeline.play();
    }

    public override function create():Node{

        xpos = rand.nextInt(screenWidthMax);
        ypos = rand.nextInt(screenHeightMax);
        
        var w = 2;
        var h = 2;
        Rectangle {
            x: xpos - w/2, y: ypos - h/2
            width: w, height: h
            fill: bind currentColor
        }
    }
}
