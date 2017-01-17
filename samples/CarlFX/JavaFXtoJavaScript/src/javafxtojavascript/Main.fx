/*
 * Copyright (c) 2009, Carl Dea
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 * 1. Redistributions of source code must retain the above copyright notice,
 *    this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 * 3. Neither the name of JFXtras nor the names of its contributors may be used
 *    to endorse or promote products derived from this software without
 *    specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */
package javafxtojavascript;

import javafx.scene.paint.Color;
import java.util.Random;
import javafx.scene.Scene;
import javafx.stage.AppletStageExtension;
import javafx.stage.Stage;
import javafx.animation.Timeline;
import javafx.animation.KeyFrame;
import javafx.scene.Node;
import java.lang.System;
import javafx.scene.control.ToggleButton;
import javafx.scene.input.MouseEvent;
import java.awt.Point;
import javafx.scene.CustomNode;
import javafx.scene.Group;
import javafx.scene.shape.Circle;
import javafx.scene.paint.RadialGradient;
import javafx.scene.paint.Stop;
import javafx.animation.Interpolator;
import javafx.scene.shape.Rectangle;

/**
 * @author cdea
 */

// create a random number generator
var random = Random{};
random.setSeed(System.currentTimeMillis());

// colors to choose from 
var colors = [Color.BLUE, Color.CYAN,Color.GREEN, Color.MAGENTA,Color.YELLOW, Color.RED, Color.WHITE, Color.ORANGE, Color.LIGHTGRAY];

// script level function to gen random color
function getRndColor(): Color {
    var pick = colors[random.nextInt(9)];
    return pick;
}

// script level function to gen random radius for balls
function getRndRadius(): Integer {
    var pick = random.nextInt(35) + 5;
    return pick;
}

// script level function to gen center point for a ball
function getRndCenter(width:Integer, height:Integer, radius:Integer): Point {
    var x = random.nextInt(width);

    // prevent ball center's to create on the edge.
    if (x+radius >= width) {
        x = x - radius;
    }
    if (x-radius <= 0) {
        x = x + radius;
    }
    var y = random.nextInt(height);
    if (y+radius >= height) {
        y = y - radius;
    }
    if (y-radius <= 0) {
        y = y + radius;
    }

    var pt:Point = Point{};
    pt.x = x;
    pt.y = y;
    return pt;
}


class Velocity {
    public var xVelocity:Float;
    public var yVelocity:Float;
}

function getRndVelocity(): Velocity {
    var r = Random{};
    r.setSeed(System.currentTimeMillis());
    var xDir = r.nextInt(1); // negative or positive
    var xMV = r.nextInt(5);
    var xV = r.nextFloat() + xMV;

    var yDir = r.nextInt(1);
    var yMV = r.nextInt(5);
    var yV = r.nextFloat() + yMV;
    var velocity:Velocity = Velocity{
        xVelocity:xV;
        yVelocity:yV;
    }

}

class Ball extends CustomNode {
    public var velocity:Velocity;
    public var centerX:Integer=100;
    public var centerY:Integer=100;
    public var radius:Integer;
    public var fill:Color;
    protected override function create(): Node {
        var circle:Circle = Circle {
                centerX: centerX, centerY: centerY
                radius: radius
                fill: RadialGradient {
                        centerX: centerX - radius / 3
                        centerY: centerY - radius / 3
 
                        radius: radius
                        proportional: false
                        stops: [
                            Stop {
                                offset: 0.0
                                color: getRndColor()
                            },
                            Stop {
                                offset: 1.0
                                color: Color.BLACK
                            }
                        ] // stops
                } // RadialGradient
                //effect: DropShadow { offsetX: 3 offsetY:3}
        } // circle
        var ball = Group{
            content:[circle];
            onMousePressed: function( e: MouseEvent ):Void {
                delete this from gameArea;
                numBalls--;
            }
//            onMouseReleased:function( e: MouseEvent ):Void {
//                delete this from gameArea;
//                numBalls--;
//            }
        } // Group

        return ball;
    } // create()
} // Ball


// create an initial ball to float around.
var initialBallRadius = getRndRadius();
var rndCenter:Point = getRndCenter(500, 400, initialBallRadius);
var firstBall = Ball{
    velocity:getRndVelocity()
    centerX: rndCenter.x
    centerY: rndCenter.y
    radius: initialBallRadius
    fill: getRndColor()
};


var applet: AppletStageExtension;
var numBalls:Integer = 1 on replace {
    applet.eval("document.getElementById('numBalls').value = {numBalls}");
};

var gameLoop:Timeline = Timeline {
    repeatCount: Timeline.INDEFINITE
    keyFrames : [
        KeyFrame {
            time: 1s / 50
            canSkip : true
            action: function() {
                // todo: check collision before next move
                //var balls = gameArea[c | c instanceof Ball];
                for (node:Node in gameArea) {
                    if (not (node instanceof Ball)){
                        continue;
                    }
                    var ball = node as Ball;
                    var xMin = ball.boundsInParent.minX;
                    var yMin = ball.boundsInParent.minY;
                    var xMax = ball.boundsInParent.maxX;
                    var yMax = ball.boundsInParent.maxY;
                    //println("---> xMin={xMin}, yMin={yMin} - xMax={xMax}, yMax={yMax}");
                    if (xMin < scene.x or xMax > scene.width){
                       ball.velocity.xVelocity = ball.velocity.xVelocity * -1;
                    }
                    if (yMin < scene.y or yMax > scene.height){
                       ball.velocity.yVelocity = ball.velocity.yVelocity * -1;
                    }
                    //println("   scene.y={scene.y}, scene.height={scene.height}   scene.x={scene.x}, scene.width={scene.width}");
                    //println("ball.translateX={ball.translateX}, ball.translateY={ball.translateY}");
                    ball.translateX = ball.translateX + ball.velocity.xVelocity;
                    ball.translateY = ball.translateY + ball.velocity.yVelocity;
                }
            } // action
        } //
    ]
};
gameLoop.play();


// This button will stop and start the balls animation
var toggleAnimationButton:ToggleButton = ToggleButton {
        selected:true
        text: "Stop/Start Ball(s)"
        onMouseReleased: function (evt:MouseEvent){
            if (toggleAnimationButton.selected == true){
                gameLoop.play();
            }
            else
            {
                gameLoop.pause();
            }

        }
}

var mainScreenOpacity = .5;
var fade = Timeline {
    keyFrames: [
        at(0s) { mainScreenOpacity => 0.4 tween Interpolator.LINEAR },
        at(0.5s) { mainScreenOpacity => 0.9 tween Interpolator.LINEAR },
    ]
};
var mainRectRegion = Rectangle {
                width: 500
                height: 400
                fill:Color.TRANSPARENT
                //fill: Color.rgb(0,0,0,0)
                onMouseEntered: function(e:MouseEvent) {
                    fade.rate = 1.0;
                    fade.play();
                }
                onMouseExited: function(e:MouseEvent) {
                    fade.rate = -1.0;
                    fade.play();
                }
};

var gameArea:Node[] = [firstBall, toggleAnimationButton, mainRectRegion];
var scene:Scene = Scene {
        content: bind gameArea
        fill:Color.TRANSPARENT
};

Stage {
    title: "Application title"
    width: 500
    height: 400
    opacity: bind mainScreenOpacity;
    scene: scene
}

// This function is called from the JavaScript button and numBallsToAdd field
function addBalls(num:Integer) : Void {
    FX.deferAction(function() : Void {
        for( i in [1..num]){
            var curBallRadius = getRndRadius();
            var rndCenter:Point = getRndCenter(500, 400, curBallRadius);
            var b = Ball{
                velocity:getRndVelocity()
                centerX: rndCenter.x
                centerY: rndCenter.y
                radius: curBallRadius
                fill: getRndColor()
            };
            insert b into gameArea;
            numBalls++;
        }
    });
}

