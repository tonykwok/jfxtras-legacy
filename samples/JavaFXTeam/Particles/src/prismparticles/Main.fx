/*
 * Copyright (c) 2009, Joshua Marinacci
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
package prismparticles;

import javafx.stage.Stage;
import javafx.scene.Scene;
import javafx.scene.Group;
import javafx.animation.Timeline;
import javafx.animation.KeyFrame;
import javafx.scene.shape.Circle;
import javafx.scene.effect.BoxBlur;
import javafx.scene.paint.Color;
import javafx.util.Math;
import javafx.scene.shape.Rectangle;
import javafx.scene.input.MouseEvent;
import javafx.scene.layout.VBox;
import javafx.scene.layout.HBox;
import javafx.scene.control.Label;
import javafx.scene.control.Slider;
import javafx.scene.control.RadioButton; 
import javafx.scene.control.ToggleGroup;
import javafx.scene.control.ToggleButton;
import javafx.scene.control.ListView;
import javafx.scene.layout.LayoutInfo;
import javafx.scene.image.ImageView;
import javafx.scene.Node;
import javafx.scene.shape.Shape;
import javafx.scene.image.Image;
import javafx.scene.shape.Line;

mixin class Particle {
    var angle = 0.0;
    var gravityY = 0.0;
};

class CircleParticle extends Circle, Particle { }
class RectangleParticle extends Rectangle, Particle { }
class ImageViewParticle extends ImageView, Particle { }

function rand(lower:Float, upper:Float) {
    return Math.random()*(upper-lower)+lower;
}
function randJitter(value:Float, jitter:Float):Float {
    return value + jitter*(Math.random()-0.5);
}

var c1 = Color.BLUE;
var c2 = Color.GREEN;
var c3 = Color.RED;

var colorSet:Color[];
colorSet = [Color.RED,Color.GREEN,Color.BLACK];
var colorSplit = 0.5;
var fireballImage = Image { url: "{__DIR__}fireball1.png" };


function colorTerp(t:Float):Color {


    var r = 0.0;
    var g = 0.0;
    var b = 0.0;

    var split = colorSplit;

    var c1x = colorSet[0];
    var c2x = colorSet[1];
    var t2 = t/split;
    if(t > split) {
        c1x = colorSet[1];
        c2x = colorSet[2];
        t2 = (t-split)/(1-split);
    }

    r = c1x.red +   (c2x.red   - c1x.red) * t2;
    g = c1x.green + (c2x.green - c1x.green) * t2;
    b = c1x.blue +  (c2x.blue  - c1x.blue) * t2;
    

    return Color { red: r green: g blue: b };
}


var radius = 20.0;
var radiusJitter = 5.0;
var centerJitter = 20.0;
var particleCount = 0.0;

var placeAtMouse = false;
var placeAtCenter = false;
var placeAtOrbit = true;

var particlesPerTick = 5.0;
var fadeSpeed = 4.0;
var blurRadius = 10.0;
var rotateSpeedRaw = 25.0;
var rotateSpeed = bind rotateSpeedRaw - 25.0;

var buttonGroup = ToggleGroup{};
var floatGroup = ToggleGroup{};
var shapeGroup = ToggleGroup{};


// ======== gradient selection
var gradientList = ListView {
        items: ["red","blue","green","white","fire","gold","purple / white / purple"]
        layoutInfo: LayoutInfo { height: 70 width: 100 }
    };

var switchGrad = bind gradientList.selectedItem on replace {
    if(switchGrad == "red") {
        colorSet = [Color.RED,Color.DARKRED,Color.BLACK];
    }
    if(switchGrad == "blue") {
        colorSet = [Color.BLUE,Color.DARKBLUE,Color.BLACK];
    }
    if(switchGrad == "green") {
        colorSet = [Color.GREEN,Color.DARKGREEN,Color.BLACK];
    }
    if(switchGrad == "white") {
        colorSet = [Color.WHITE,Color.WHITE,Color.rgb(100,100,100,0.5)];
    }
    if(switchGrad == "fire") {
        colorSet = [Color.YELLOW,Color.RED,Color.rgb(150,0,0)];
    }
    if(switchGrad == "gold") {
        colorSet = [Color.YELLOW,Color.ORANGE,Color.WHITE];
    }
    if(switchGrad == "purple / white / purple") {
        colorSet = [Color.PURPLE, Color.WHITE, Color.PURPLE];
    }

}


// ==================== Presets List

def preset_PixieDust = "Pixie Dust";
def preset_DarkStar = "Dark Star";
def preset_Smoke = "Smoke";
def preset_Snow = "Snow";
def preset_Petri = "Petri";
def preset_Genesis = "Genesis Effect";
def preset_ChurnFlame = "Churning Flame";
def preset_DarkBlueBlobs = "Dark Blue Blobs";
def preset_Fountain = "Fountain";
def preset_SideFlame = "Side Flame";
var presetsList = ListView {
    items: [preset_PixieDust, preset_DarkStar, preset_Smoke, preset_Snow, preset_Petri, preset_Genesis, preset_ChurnFlame, preset_DarkBlueBlobs, preset_Fountain, preset_SideFlame]
    layoutInfo: LayoutInfo { height: 70 width: 200 }
};

var switchPreset = bind presetsList.selectedItem on replace {
    if(switchPreset == preset_PixieDust) {
        particlesPerTick = 5;
        placeAtOrbit = true;
        shapeGroup.selectedButton = shapeGroup.buttons[1]; // rect
        radius = 5.0;
        radiusJitter = 20.0;
        centerJitter = 50.0;
        blurRadius = 10.0;
        fadeSpeed = 2.7;

        gradientList.select(5);
        rotateSpeedRaw = 25+0;
        angleRaw = 180.0;
        angleJitter = 0;
        angleSpread = 78.5;
        velocity = 10.0;
        gravity = 0;
        
    }
    if(switchPreset == preset_DarkStar) {
        particlesPerTick = 1;
        placeAtCenter = true;
        shapeGroup.selectedButton = shapeGroup.buttons[0]; // circle
        radius = 32.5;
        radiusJitter = 2.5;
        centerJitter = 0;
        blurRadius = 9;
        fadeSpeed = 2.7;
        gradientList.select(4);
        rotateSpeedRaw = 25+0;
        angleRaw = 0;
        angleJitter = 0;
        angleSpread = 360;
        velocity = 0.5;
        gravityRaw = 100+0;
    }
    if(switchPreset == preset_Smoke) {
        particlesPerTick = 4;
        placeAtCenter = true;
        shapeGroup.selectedButton = shapeGroup.buttons[0]; // circle
        radius = 8.47;
        radiusJitter = 30;
        centerJitter = 0;
        blurRadius = 8.5;
        fadeSpeed = 1.7;
        gradientList.select(3);
        rotateSpeedRaw = 25+0;
        angleRaw = 180+-43;
        angleJitter = 0;
        angleSpread = 35;
        velocity = 2.7;
        gravityRaw = 100+0;
    }
    if(switchPreset == preset_Snow) {
        particlesPerTick = 2;
        placeAtOrbit = true;
        shapeGroup.selectedButton = shapeGroup.buttons[0]; // circle
        radius = 5.0;
        radiusJitter = 0.0;
        centerJitter = 50.0;
        blurRadius = 5.0;
        fadeSpeed = 0.5;

        gradientList.select(3);
        rotateSpeedRaw = 25+0;
        angleRaw = 180.0 + -23;
        angleJitter = 25.0;
        angleSpread = 90.0;
        velocity = 4.1;
        gravityRaw = 100+1;

    }

    if(switchPreset == preset_Petri) {
        particlesPerTick = 1;
        placeAtCenter = true;
        shapeGroup.selectedButton = shapeGroup.buttons[0]; // circle
        radius = 5.0;
        radiusJitter = 0.0;
        centerJitter = 0.0;
        blurRadius = 5.0;
        fadeSpeed = 0.3;

        gradientList.select(2);
        rotateSpeedRaw = 25+0;
        angleRaw = 180.0 + 0;
        angleJitter = 180.0;
        angleSpread = 360.0;
        velocity = 5.0;
        gravityRaw = 100+0;
    }

    if(switchPreset == preset_Genesis) {
        particlesPerTick = 4;
        placeAtCenter = true;
        shapeGroup.selectedButton = shapeGroup.buttons[0]; // circle
        radius = 7.5;
        radiusJitter = 0.0;
        centerJitter = 0.0;
        blurRadius = 8.5;
        fadeSpeed = 1.6;

        gradientList.select(4); // fire
        rotateSpeedRaw = 25+0;
        angleRaw = 180.0 + -155;
        angleJitter = 0.0;
        angleSpread = 180.0;
        velocity = 6.5;
        gravityRaw = 100+0;
    }

    if(switchPreset == preset_ChurnFlame) {
        particlesPerTick = 2;
        placeAtCenter = true;
        shapeGroup.selectedButton = shapeGroup.buttons[1]; // rect
        radius = 35.74;
        radiusJitter = 18.0;
        centerJitter = 23.0;
        blurRadius = 12.3;
        fadeSpeed = 1.6;

        gradientList.select(4); // fire
        rotateSpeedRaw = 25+7.5;
        angleRaw = 180.0 + -155;
        angleJitter = 0.0;
        angleSpread = 0.0;
        velocity = 4.1;
        gravityRaw = 100+0;
    }

    if(switchPreset == preset_DarkBlueBlobs) {
        particlesPerTick = 2;
        placeAtCenter = true;
        shapeGroup.selectedButton = shapeGroup.buttons[0]; // circle
        radius = 16.0;
        radiusJitter = 30.0;
        centerJitter = 0.0;
        blurRadius = 7.0;
        fadeSpeed = 1.3;

        gradientList.select(1); // blue
        rotateSpeedRaw = 25+0;
        angleRaw = 180.0 + 0;
        angleJitter = 0.0;
        angleSpread = 360.0;
        velocity = 5.1;
        gravityRaw = 100+0;
    }

    if(switchPreset == preset_Fountain) {
        particlesPerTick = 3;
        placeAtCenter = true;
        shapeGroup.selectedButton = shapeGroup.buttons[0]; // circle
        radius = 7.0;
        radiusJitter = 3.0;
        centerJitter = 0.0;
        blurRadius = 11.0;
        fadeSpeed = 0.6;

        gradientList.select(1); // blue
        rotateSpeedRaw = 25+0;
        angleRaw =  180+ -180;
        angleJitter = 0.0;
        angleSpread = 35.0;
        velocity = 11.6;
        gravityRaw = 100+47;
    }

    if(switchPreset == preset_SideFlame) {
        particlesPerTick = 2;
        placeAtCenter = true;
        shapeGroup.selectedButton = shapeGroup.buttons[1]; // rect
        radius = 27.0;
        radiusJitter = 18.00;
        centerJitter = 34.0;
        blurRadius = 12.5;
        fadeSpeed = 1.6;

        gradientList.select(4); // fire
        rotateSpeedRaw = 25+8;
        angleRaw =  180+ -55;
        angleJitter = 0.0;
        angleSpread = 0.0;
        velocity = 6.5;
        gravityRaw = 100-29;
    }

}


var cx = 0.0;
var cy = 0.0;
var parts:Node[];

var loopCount = 0;
var angleRaw = 0.0;
var angle = bind angleRaw - 180.0;
var velocity = 10.0;
var angleJitter = 0.0;
var angleSpread = 0.0;
var gravityRaw = 100.0;
var gravity = bind (gravityRaw -100.0)/100.0;

function loop():Void {
    loopCount++;


    if(placeAtCenter) {
        cx = (scene.width-300)/2;
        cy = (scene.height)/2;
    }

    if(placeAtOrbit) {
        cx = 250 + Math.sin(Math.toRadians(5)*loopCount) * 150;
        cy = 50 + Math.cos(Math.toRadians(5)*loopCount) * 30;
    }


    for(i in [0..(particlesPerTick as Integer)-1]) {
        var ang = randJitter(angle,angleSpread);
        
        if(shapeGroup.selectedButton.id == "image") {
            insert ImageViewParticle {
                x: randJitter(cx, centerJitter)
                y: randJitter(cy, centerJitter)
                scaleX: randJitter(radius,radiusJitter)/10.0;
                scaleY: randJitter(radius,radiusJitter)/10.0;
                effect: BoxBlur { height: blurRadius width: blurRadius }
                angle: ang
                image: fireballImage
            } into parts;
        }

        if(shapeGroup.selectedButton.id == "rect") {
            insert RectangleParticle {
                x: randJitter(cx, centerJitter)
                y: randJitter(cy, centerJitter)
                width: randJitter(radius,radiusJitter)
                height: randJitter(radius,radiusJitter)
                fill: Color.RED
                effect: BoxBlur { height: blurRadius width: blurRadius }
                angle: ang
            } into parts;
        } 
        if(shapeGroup.selectedButton.id == "circle") {
            insert CircleParticle {
                centerX: randJitter(cx,centerJitter)
                centerY: randJitter(cy, centerJitter)
                radius: randJitter(radius,radiusJitter)
                fill: Color.RED
                effect: BoxBlur { height: blurRadius width: blurRadius }
                angle: ang
            } into parts;
        }
    }

    for(part in parts) {
        var p = part as Particle;
        part.translateX += Math.sin(Math.toRadians(randJitter(p.angle,angleJitter)))*velocity;
        part.translateY += Math.cos(Math.toRadians(randJitter(p.angle,angleJitter)))*velocity;
        p.gravityY += gravity;
        part.translateY += p.gravityY;
        if(part.opacity > 0.1) {
            part.opacity += -fadeSpeed/100;
        } else {
            part.opacity = 0;
        }
        
        if(part instanceof Shape) {
            var ps = part as Shape;
            ps.fill = colorTerp(1-part.opacity);
        }
        part.rotate += rotateSpeed;
    }

    for(part in parts) {
        if(part.opacity == 0) {
            delete part from parts;
        }
    }

    particleCount = parts.size();

}

var anim = Timeline {
    keyFrames: [
        KeyFrame {
            time: 33ms
            action: loop
        }
    ]
    repeatCount: Timeline.INDEFINITE
}

var inset = 20.0;

var scene:Scene = Scene {
        width: 950
        height: 700
        content: [
            Rectangle {
                width: bind scene.width - 300 height: bind scene.height fill: Color.BLACK
                onMouseMoved: function(e:MouseEvent):Void {
                    cx = e.x;
                    cy = e.y;
                }

            }

            Group {
                content: bind parts
            }

            Rectangle { width: 300 height: bind scene.height fill: Color.rgb(200, 200, 200) x: bind scene.width - 300 }
            VBox {
                translateX: bind scene.width - 300
                layoutX: 5
                width: 200
                spacing: 8
                content: [
                    Label { text: bind "Particle Count {particleCount as Integer}" }
                    Line { startX: 0 startY: 0 endX: 270 endY: 0 },
                    Label { text: "Presets" }
                    presetsList,
                    Line { startX: 0 startY: 0 endX: 270 endY: 0 },
                    VBox {
                        translateX: inset
                        spacing: 5
                        content: [
                            HBox { content: [
                                Label { text: "New Particles Per Tick:" }
                                Slider { min: 1.0 max: 10.0 value: bind particlesPerTick with inverse width: 50 layoutInfo: LayoutInfo { width: 60 }  }
                                Label { text: bind "{%d particlesPerTick as Integer}" }
                                ]}
                            HBox { content: [
                                Label { text: "Postion: " },
                                RadioButton { text: "Follow Mouse" selected: bind placeAtMouse with inverse toggleGroup: buttonGroup }
                                RadioButton { text: "Center" selected: bind placeAtCenter with inverse toggleGroup:buttonGroup }
                                RadioButton { text: "Orbit" selected: bind placeAtOrbit with inverse toggleGroup: buttonGroup }
                                ]}
                        ]
                    }

                    Label { text: "Particle Shape & Size" }
                    VBox {
                        translateX: inset
                        spacing: 5
                        content: [
                            HBox { content: [
                                ToggleButton { text: "Circle" toggleGroup: shapeGroup selected: true id:"circle" }
                                ToggleButton { text: "Rect" toggleGroup: shapeGroup selected: true id:"rect" }
                                ToggleButton { text: "Image" toggleGroup: shapeGroup selected: true id:"image" }
                                ]}
                            HBox { content: [
                                Label { text: "Radius" }
                                Slider { min: 1 max: 50 value: bind radius with inverse width: 100 }
                                Label { text: bind "{%.2f radius}" }
                                ]}
                            HBox { content: [
                                Label { text: "Radius Jitter" }
                                Slider { min: 0 max: 30 value: bind radiusJitter with inverse width: 100 }
                                Label { text: bind "{%.2f radiusJitter}" }
                                ]}
                            HBox { content: [
                                Label { text: "Center Jitter" }
                                Slider { min: 0 max: 50 value: bind centerJitter with inverse width: 100 }
                                Label { text: bind "{%.2f centerJitter}" }
                                ]}
                        ]
                    }

                    Label { text: "Particle Color and Form" }
                    VBox {
                        translateX: inset
                        spacing: 5
                        content: [
                            HBox { content: [
                                Label { text: "Blur Radius" }
                                Slider { min: 0 max: 20 value: bind blurRadius with inverse width: 100 }
                                Label { text: bind "{%.2f blurRadius}" }
                                ]}
                            HBox { content: [
                                Label { text: "Fade Speed" }
                                Slider { min: 0.1 max: 5 value: bind fadeSpeed with inverse width: 100 }
                                Label { text: bind "{%.1f fadeSpeed}" }
                                ]}
                            Label { text: "Gradient" },
                            gradientList,
                        ]
                    }

                    Label { text: "Physics" }
                    VBox {
                        translateX: inset
                        spacing: 5
                        content: [
                            HBox { content: [
                                Label { text: "Rotation Speed" }
                                Slider { min: 0 max: 50 value: bind rotateSpeedRaw with inverse width: 100 }
                                Label { text: bind "{%.1f rotateSpeed}" }
                                ]}
                            HBox { content: [
                                Label { text: "Launch Angle" }
                                Slider { min: 0.0 max: 360.0 value: bind angleRaw with inverse width: 100 }
                                Label { text: bind "{%.1f angle}" }
                                ]}
                            HBox { content: [
                                Label { text: "Wobble" }
                                Slider { min: 0 max: 180 value: bind angleJitter with inverse width: 100 }
                                Label { text: bind "{%.1f angleJitter}" }
                                ]}
                            HBox { content: [
                                Label { text: "Angle Spread" }
                                Slider { min: 0 max: 360 value: bind angleSpread with inverse width: 100 }
                                Label { text: bind "{%.1f angleSpread}" }
                                ]}
                            HBox { content: [
                                Label { text: "Velocity" }
                                Slider { min: 0 max: 20 value: bind velocity with inverse width: 100 }
                                Label { text: bind "{%.1f velocity}" }
                                ]}
                            HBox { content: [
                                Label { text: "Gravity" }
                                Slider { min: 0 max: 200.0 value: bind gravityRaw with inverse width: 100 }
                                Label { text: bind "{%.2f gravity}" }
                                ]}

                        ]
                    }

                ]
            }

        ]
    };

Stage {
    title: "JavaFX Particle-o-rama"
    resizable: true
    scene: scene
}

anim.play();