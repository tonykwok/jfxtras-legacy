/*
 * Main.fx
 *
 * Created on 20/10/2008, 8:23:30 PM
 */
package spacemissionfx;

import javafx.animation.KeyFrame;
import javafx.animation.Timeline;
import javafx.scene.Group;
import javafx.scene.input.KeyEvent;
import javafx.scene.input.MouseEvent;
import javafx.scene.paint.Color;
import javafx.scene.shape.Rectangle;
import javafx.scene.text.Font;
import javafx.scene.text.Text;
import javafx.stage.Stage;
import spacemissionfx.display.FloatingWord;
import spacemissionfx.display.GameOverPanel;
import spacemissionfx.explosions.Explosion;
import spacemissionfx.explosions.Point2D;
import spacemissionfx.Rocket;
import spacemissionfx.SpaceShip;
import spacemissionfx.Star;
import javafx.scene.Scene;

import javafx.scene.input.KeyCode;

/**
 * @author Mark Macumber
 */

 //Screen Vars
var screenWidth = 500;
var screenHeight = 500;

//asteroids
var asteroids:Asteroid[];

//explosions
var explosions:Explosion[];

//floating words that get displayed when you shoot an asteroid
var floatingWords:FloatingWord[];

//array so we can easily remove the ship from the game
//when the user dies.
var spaceShipArr:SpaceShip[];

//spaceship
var spaceShip:SpaceShip = SpaceShip {
    asteroids: bind asteroids;
}

//game over panel
var gameOverPanel:GameOverPanel = GameOverPanel{};

insert spaceShip into spaceShipArr;

populateAsteroids();

//stars
var stars:Star[];
var numOfStars = 35;
for (idx in [1..numOfStars]){
    var s = Star{
        screenWidthMax: screenWidth;
        screenHeightMax: screenHeight;
    };
    insert s into stars;
}

function populateAsteroids():Void{
    var numOfAsteroids = 12;
    for (num in [1..numOfAsteroids]){
        var a = Asteroid{
            maxAvailableX: screenWidth; 
            maxAvailableY: screenHeight;
            shipX: spaceShip.centroid_x;
            shipY: spaceShip.centroid_y;
        };
        insert a into asteroids;
    }
}

function resetGame(){
    
    //its not game over anymore
    gameOverPanel.hidePanel();

    //clear all asteroids 
    delete asteroids;
    
    spaceShip = SpaceShip {
        asteroids: bind asteroids;
    };

    insert spaceShip into spaceShipArr;

    populateAsteroids();
}

var space = Rectangle {
        x: 0,
        y: 0
        width: screenWidth,
        height: screenHeight
        fill: Color.BLACK

        onKeyReleased: function( e: KeyEvent ):Void {
            if (not spaceShip.dead) {
                if(e.code == KeyCode.VK_UP) {
                    spaceShip.thrusting = false;
                    spaceShip.stopAcceleration();
                } else if(e.code == KeyCode.VK_RIGHT) {
                    //move right
                    spaceShip.turningRight =
                    spaceShip.turningLeft = false;
                    spaceShip.stopTurning();
                } else if(e.code == KeyCode.VK_LEFT) {
                    //move left
                    spaceShip.turningRight =
                    spaceShip.turningLeft = false;
                    spaceShip.stopTurning();
                } else if(e.code == KeyCode.VK_SPACE) {
                    spaceShip.stopShootingRockets();
                }
            }
        }

        onKeyPressed: function( e: KeyEvent ):Void {
            if (not spaceShip.dead) {
                if (e.code == KeyCode.VK_UP) {
                    //move up
                    spaceShip.thrusting = true;
                    spaceShip.startAcceleration();
                //} else if(e.getKeyText().equals("Down")) {
                    //slow down/reverse?

                } else if(e.code == KeyCode.VK_RIGHT) {
                    //move right
                    if (not spaceShip.turningRight){
                        spaceShip.turningRight = true;
                        spaceShip.turningLeft = false;
                        spaceShip.startTurning();
                    }
                } else if(e.code == KeyCode.VK_LEFT) {
                    //move left
                    if (not spaceShip.turningLeft) {
                        spaceShip.turningRight = false;
                        spaceShip.turningLeft = true;
                        spaceShip.startTurning();
                    }
                } else if(e.code == KeyCode.VK_SPACE) {
                    spaceShip.shootRocket();
                }
            }
        }

        onMouseClicked: function( e: MouseEvent ):Void {
            if (spaceShip.dead) {
                resetGame();
            }
        }
};

//collosion detection
var collisionDetection = Timeline {
    repeatCount: Timeline.INDEFINITE
    keyFrames: [
        KeyFrame {
            time: 55ms
            action:function(){
                if (not spaceShip.dead){
                    //test for collision between rockets and asteroids
                    for (r:Rocket in spaceShip.rockets){
                        for(a:Asteroid in asteroids){
                            if (a.shootAsteroid(r)){
                                r.stopLife();
                                delete r from spaceShip.rockets;

                                if (a.isDead()){
                                    a.stopLife();
                                    delete a from asteroids;

                                    insert FloatingWord{
                                        xpos: r.x_pos;
                                        ypos: r.y_pos;
                                    } into floatingWords;

                                    insert Explosion {
                                        xpos: r.x_pos;
                                        ypos: r.y_pos;
                                    } into explosions;

                                    if (sizeof asteroids == 0){
                                        populateAsteroids();
                                    }
                                }
                            }
                        }
                    }

                    //test for collision between ship and asteroids
                    for(a:Asteroid in asteroids){
                        for (p:Point2D in spaceShip.getPointsOfShip()){
                            if (a.isPointInsideAsteroid(p.x_point, p.y_point)){
                                spaceShip.dead = true;
                                //ship blows up now
                                insert Explosion {
                                    xpos: p.x_point;
                                    ypos: p.y_point;
                                    bigBoom: true;
                                } into explosions;

                                spaceShip.stopShootingRockets();
                                delete spaceShipArr[0];

                                //show game over panel
                                gameOverPanel.showPanel();
                            }
                        }
                    }
                }
            }
        }
    ]
}
collisionDetection.play();

Stage {
    title: "Space Mission"
    width: screenWidth
    height: screenHeight
    onClose: function() {
        java.lang.System.exit( 0 ); 
    }
    visible: true

    scene: Scene {
        content: [
            space,

            Group{
                content: bind stars;
            },
            
            Group{
                content: bind spaceShipArr;
            },

            Group{
                content: bind spaceShip.rockets;
            },
            
            Group{
                content: bind asteroids;
            },
            
            Group{
                content: bind explosions;
            },
            
            Group{
                content: bind floatingWords;
            },
            
            gameOverPanel,

            Text {
                font: Font { 
                    size: 12 
                }
                x: 375
                y: 450
                fill: Color.WHITE
                content: bind "Asteroids Left: {sizeof asteroids}"
            }
        ]
     }
}

space.requestFocus();