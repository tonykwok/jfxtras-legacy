/*
 * Main.fx
 *
 * Created on Sep 29, 2009, 10:59:39 AM
 */

package sidehatch;

import javafx.stage.Stage;
import javafx.scene.Scene;
import javafx.scene.text.Text;
import javafx.scene.text.Font;
import javafx.scene.shape.Rectangle;
import javafx.scene.paint.Color;
import javafx.scene.Group;

import javafx.scene.shape.Circle;

import javafx.scene.control.Button;

import javafx.scene.control.Label;

import javafx.scene.layout.VBox;

/**
 * @author josh
 */

Stage {
    title: "Application title"
    width: 600
    height: 600
    scene: Scene {
        content: [
            Rectangle {
                x: 50 y: 50 width: 20 height: 30 fill :Color.RED
            }
            Text {
                font : Font {
                    size : 16
                }
                x: 10
                y: 30
                content: "Application content"
            }
            Group {
                translateX: 200
                translateY: 200
                content: [
                    Circle {
                        centerX: 50
                        centerY: 50
                        fill: Color.BLUE
                        radius: 50
                    }
                    Circle {
                        centerX: 100
                        centerY: 30
                        fill: Color.CHOCOLATE
                        radius: 30
                    }


                ]
            }
            Button {
                translateX: 300 translateY: 20 text: "a button";
            }
            Label {
                translateX: 300 translateY: 50 text: "a label";
            }
            VBox {
                translateX: 400 translateY: 100
                content: [
                    Button { text: "button in vbox 1" }
                    Button { text: "button in vbox 2" }
                    Button { text: "button in vbox 3" }
                    Button { text: "button in vbox 4" }
                    Button { text: "button in vbox 5" }
                ]
            }

        ]
    }
}

sidehatch.SideHatch.activate();
