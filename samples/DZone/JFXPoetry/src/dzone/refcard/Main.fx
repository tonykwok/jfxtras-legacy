/*
 * Copyright (c) 2009, Stephen Chin
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
package dzone.refcard;

import javafx.animation.Interpolator;
import javafx.animation.transition.TranslateTransition;
import javafx.scene.control.Button;
import javafx.scene.effect.DropShadow;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;
import javafx.scene.layout.ClipView;
import javafx.scene.media.Media;
import javafx.scene.media.MediaPlayer;
import javafx.scene.paint.Color;
import javafx.scene.Scene;
import javafx.scene.text.Font;
import javafx.scene.text.FontWeight;
import javafx.scene.text.Text;
import javafx.stage.Stage;
import javafx.animation.transition.FadeTransition;

/**
 * @author Stephen Chin
 */
var scene:Scene;
var image:ImageView;
var text:Text;
var button:Button;
Stage {
  title: "Pippa's Song by Robert Browning"
  scene: scene = Scene {
    content: [
      image = ImageView {
        image: bind Image {
          height: scene.height
          preserveRatio: true
          url: "http://farm1.static.flickr.com/39/"
               "121693644_75491b23b0.jpg"
        }
      },
      ClipView {
        width: bind scene.width
        height: bind scene.height
        override var maxClipX = 0
        node: text = Text {
          effect: DropShadow {}
          font: bind Font.font("Serif", FontWeight.BOLD,
                               scene.height / 12.5)
          fill: Color.GOLDENROD
          x: 10
          y: bind scene.height / 6
          content: "The year's at the spring,\n"
                   "And day's at the morn;\n"
                   "Morning's at seven;\n"
                   "The hill-side's dew-pearled;\n"
                   "The lark's on the wing;\n"
                   "The snail's on the thorn;\n"
                   "God's in His heaven--\n"
                   "All's right with the world!"
        },
      }
      button = Button {
        translateX: bind (scene.width - button.width) / 2
        translateY: bind (scene.height - button.height) / 2
        text: "Play Again"
        visible: bind not animation.running
        action: function() {
          animation.playFromStart();
          player.currentTime = 0s;
          player.play();
        }
      }
    ]
  }
}

var player = MediaPlayer {
  autoPlay: true
  media: Media {
    source: "http://video.fws.gov/sounds/35indigobunting.mp3"
  }
}

FadeTransition {
  node: image
  duration: 5s
  fromValue: 0
  toValue: 1
  interpolator: Interpolator.EASEOUT
}.play();

var animation = TranslateTransition {
  duration: 24s
  node: text
  fromY: scene.height
  toY: 0
  interpolator: Interpolator.EASEOUT
}
animation.play();
