/*
 * ExplosionManager.fx
 *
 * Created on 12/11/2008, 2:47:08 PM
 */

package spacemissionfx.explosions;
import javafx.animation.Timeline;
import javafx.animation.KeyFrame;
import javafx.scene.CustomNode;
import javafx.scene.Node;
import javafx.scene.Group;
import java.lang.*;
import java.util.Random;
import spacemissionfx.explosions.Particle;
/**
 * @author macumbem
 */

public class Explosion extends CustomNode {
    var particles:Particle[];
    
    var directionalVectorX = 0;
    var directionalVectorY = 1;
    
    public var startAtX:Number;
    public var startAtY:Number;
    
    public var xpos:Number;
    public var ypos:Number;
    
    //if the explosion is finished
    var finished:Boolean;
    
    public var bigBoom:Boolean = false;
    
    public override function create():Node{

        var directional_vectors = generateDirectionalVectors();

        //generate particles
        var rand = new Random();

        var numOfParticles:Number = 12;//rand.nextInt(20) + 30;

        if (bigBoom) {
            numOfParticles = 75;
        }

        for (num in [1..numOfParticles]){
            insert Particle{
                xpos: xpos; 
                ypos: ypos;
                vectors: directional_vectors;
            } into particles;
        }

        startExplosionTimeLine();

        Group {
            content: bind particles;
        }
    }
    
    function range(min:Number, max:Number, rand:Random):Number {
        var range = max - min + 1;
        (range * rand.nextDouble()) + min;
    }
    
    function generateDirectionalVectors() {
        var radius:Number = 2;
        var sprayAngle:Number = 360;
        var numOfVecs:Number = 16;
        if (bigBoom) {
            numOfVecs = 16;
        }
        var angleOfEachVec:Number = sprayAngle / numOfVecs;
        var newAngle:Number = 0;
        var directional_vectors:Point2D[];

        //rotate clockwise
        for (num in [1..numOfVecs]){
            //find new vector
            var new_xpos = (radius * Math.cos(Math.toRadians(newAngle))) + xpos;
            var new_ypos = (radius * Math.sin(Math.toRadians(newAngle))) + ypos;
            insert Point2D {
                x_point: new_xpos,
                y_point: new_ypos
            } into directional_vectors;
            newAngle += angleOfEachVec;
        }
        
        return directional_vectors;
    }
    
    function startExplosionTimeLine(){
        //update timeline
//        var particleUpdateTimeLine:Timeline = Timeline {
//            repeatCount: Timeline.INDEFINITE
//            keyFrames : [
//                KeyFrame {
//                    time : 65ms
//                    action: function(){
//                        var i:Integer = sizeof particles - 1;
//                        if (i == -1){
//                            finished = true;
//                        } else {
//                            while(i >= 0 ) {
//                                var par:Particle = particles[i];
//                                if(par.isDead()) {
//                                    delete particles[i];
//                                }
//                                i--;
//                            }
//                        }
//                    }
//                }
//            ]
//        };
//        particleUpdateTimeLine.play();
//
//        //manage life time of explosion
//        var lifetime:Timeline = Timeline {
//            repeatCount: Timeline.INDEFINITE
//            keyFrames : [
//                KeyFrame {
//                    time : 1s
//                    action:function(){
//                        //will be true when all particles are gone
//                        if (finished) {
//                            stopExplosion(particleUpdateTimeLine, lifetime);
//                        }
//                    }
//                }
//            ]
//        };
//
//        lifetime.play();
    }
    
    function stopExplosion(tl:Timeline, lifetime:Timeline){
        //stop the update of the particles
        tl.stop();
        
        //stop checking if we should stop checking :)
        lifetime.stop();
    }
}