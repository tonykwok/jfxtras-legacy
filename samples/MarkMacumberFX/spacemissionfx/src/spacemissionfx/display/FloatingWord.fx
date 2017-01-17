/*
 * FloatingWord.fx
 *
 * Created on 17/11/2008, 9:44:36 AM
 */

package spacemissionfx.display;

import javafx.scene.CustomNode;
import javafx.scene.Node;
import javafx.scene.text.Text;
import javafx.scene.text.Font;
import java.lang.*;
import java.util.Random;
import javafx.animation.Timeline;
import javafx.animation.KeyFrame;
import javafx.animation.Interpolator;
import javafx.scene.paint.Color;
/**
 * @author macumbem
 */

public class FloatingWord extends CustomNode {

    var opac:Number = 0.0;
    
    var listOfStrings:String[] =
        ["Nice", "Great Shot", "Awesome", "I Dont Believe It",
          "Sweeeeet", "Wonderful"];

    public var xpos:Number;
    public var ypos:Number;

    var rand = new Random();
    
    var lifeTime:Timeline = Timeline {
        keyFrames : [
            KeyFrame {
                time : 0s
                values: [opac => 0.0]
            },
            KeyFrame {
                time : 500ms
                values: [opac => 1.0 tween Interpolator.LINEAR]
            },
            KeyFrame {
                time : 1s
                values: [opac => 0.0 tween Interpolator.LINEAR]
                action: function() {
                    lifeTime.stop();
                }
            }
        ]
    }

    public override function create():Node{
        lifeTime.play();
        Text {
            font: Font { 
                size: 14
            }
            fill: Color.WHITE;
            x: xpos, y: ypos
            content: pickText();
            opacity: bind opac;
        };
    }

    function pickText():String{
        listOfStrings[rand.nextInt(sizeof listOfStrings)];
    }
}
