/*
 * ToolTip.fx
 *
 * Created on 4-sep-2009, 10:12:27
 */

package validatabletextbox;

import javafx.scene.CustomNode;

import javafx.scene.Node;

import javafx.scene.shape.Rectangle;


import javafx.scene.Group;

import javafx.scene.text.Text;
import javafx.scene.paint.Color;

import javafx.scene.text.Font;

import javafx.scene.paint.LinearGradient;
import javafx.scene.paint.Stop;

/**
 * @author Yannick Van Godtsenhoven
 * <yannick@jfxperience.com>
 */

public def TOOLTIP_RIGHT = "right";
public def TOOLTIP_LEFT = "left";
public def TOOLTIP_UP = "up";
public def TOOLTIP_DOWN = "down";
public def TOOLTIP_OVER = "over";


public class ToolTip extends CustomNode {

    public var maxWidth = 100 on replace {
        if(maxWidth < 10){
            maxWidth = 10
        }
    };
    public var text:String;
    public var position:String = TOOLTIP_RIGHT;
    public var arcValue:Number = 10;
    public var textSize:Number = 12;
    public var tooltipTop = "#E13B06";
    public var tooltipBottom = "#E64310";
    public var tooltipFillTop = "#E13B06";
    public var tooltipFillCenter = "#D13808";
    public var tooltipFillBottom = "#E64310";

    var message:Text;

    var group:Group;

    var tooltipFill: LinearGradient = LinearGradient {
        startX: 0.0, startY: 0.0, endX: 0.0, endY: 1.0
        proportional: true
        stops: [
          Stop { offset: 0.0 color: Color.web(tooltipFillTop) },
          Stop { offset: 0.3 color: Color.web(tooltipFillCenter) },
          Stop { offset: 0.7 color: Color.web(tooltipFillBottom) }
          ]
    };

    var tooltipStroke: LinearGradient = LinearGradient {
    startX: 0.0, startY: 0.0, endX: 0.0, endY: 1.0
    proportional: true
    stops: [
      Stop { offset: 0.0 color: Color.web(tooltipTop) },
      Stop { offset: 1.0 color: Color.web(tooltipBottom) }
      ]
    };

    override public function create():Node {
        group = Group {
            content: bind [
                Rectangle {
                    arcHeight: bind arcValue;
                    arcWidth: bind arcValue;
                    width: bind message.layoutBounds.width + 8
                    height: bind message.layoutBounds.height + 6
                    fill: bind tooltipFill
                    stroke: bind tooltipStroke;
                    strokeWidth: 2
                }
                message = Text {
                    font: Font{
                        size: textSize;
                    }
                    content: bind text;
                    wrappingWidth: bind maxWidth - 9;
                    layoutX: 6
                    layoutY: 15
                }
            ]
        }

    }

}
