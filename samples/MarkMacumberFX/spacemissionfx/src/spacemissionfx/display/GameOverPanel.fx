/*
 * GameOverPanel.fx
 *
 * Created on 14/11/2008, 12:04:38 PM
 */

package spacemissionfx.display;

import javafx.scene.CustomNode;
import javafx.scene.Node;
import javafx.scene.shape.Rectangle;
import javafx.scene.paint.Color;
import javafx.scene.text.Text;
import javafx.scene.Group;
import javafx.scene.text.Font;
import javafx.scene.text.FontPosition;
import javafx.animation.Timeline;
import javafx.animation.KeyFrame;
import javafx.animation.Interpolator;
import java.lang.*;
import javafx.scene.input.MouseEvent;

/**
 * @author macumbem
 */

public class GameOverPanel extends CustomNode {

    public var screenWidth = 500;
    public var screenHeight = 500;
    
    var gameOverGroup:Group;
    
    var panelOpacity:Number = 0.0;
    
    public override function create():Node{
        //game over panel
        var h = 60;
        var w = 200;
        var panel_x = screenWidth / 2 - (w / 2);
        var panel_y = screenHeight / 2 - (h / 2);
        
        var gameOverPanel = Rectangle {
            width: w, 
            height: h
            x: panel_x, 
            y: panel_y
            fill: Color.WHITE
        }

        var gameOverText = Text {
            font: Font { 
                size: 24 
            }
            fill: Color.BLACK;
            x: panel_x + 40, y: panel_y + 30
            content: "You Dead"
        }
        
        var instructions = Text {
            font: Font { 
                size: 12
            }
            fill: Color.BLACK;
            x: panel_x + 90, y: panel_y + 58
            content: "click to start again..."
        }

        gameOverGroup = Group{
            content: [gameOverPanel, gameOverText, instructions];
            opacity: bind panelOpacity;
        }

        return gameOverGroup;
    }
    
    var gameOvertimeline = Timeline {
        keyFrames : [
            KeyFrame {
                time : 1s
                values: {panelOpacity => 0.0}
            },
            KeyFrame {
                time : 3s
                values: {panelOpacity => 1.0 tween Interpolator.LINEAR}
            }
        ]
    };

    public function showPanel(){
        gameOvertimeline.play();
    }

    public function hidePanel() {
        gameOvertimeline.stop();
        panelOpacity = 0.0;
    }

}
