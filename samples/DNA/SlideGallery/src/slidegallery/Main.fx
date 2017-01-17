package slidegallery;

import javafx.stage.Stage;
import javafx.scene.Scene;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;
import javafx.scene.control.Button;
import javafx.scene.layout.HBox;
import javafx.stage.StageStyle;
import javafx.animation.Timeline;
import javafx.scene.paint.Color;

def images = [
    Image {url: "{__DIR__}images/image1.jpg"},
    Image {url: "{__DIR__}images/image2.jpg"},
    Image {url: "{__DIR__}images/image3.jpg"},
    Image {url: "{__DIR__}images/image4.jpg"},
    Image {url: "{__DIR__}images/image5.jpg"},
    ];

var icons: ImageView[] = for (i in images) { ImageView { image: i fitHeight: 20 preserveRatio: true } };

def bounce = SpringInterpolator { bounce: false stiffness: 6.0 };
var bounceX:Number;
var bounceAnim = Timeline {
      keyFrames: [
          at(0s) { bounceX => 550 },
          at(1.5s) { bounceX => 0 tween bounce}
          ]
      };

var currentImage = 0 on replace {
      bounceAnim.time = 0s;
      bounceAnim.play();
      };

var imageView = ImageView {
    layoutX: bind bounceX
    image: bind images[currentImage]
    preserveRatio: true
    };

Stage {
    title: "JavaFX SlideGallery"
    width: 550
    height: 400
    style: StageStyle.UNDECORATED
    scene: Scene {
        fill: Color.WHITESMOKE
        content: [
            imageView,
            HBox {
                opacity: 0.8
                layoutY: 370 layoutX: 10
                spacing: 10
                content: [ 
                    for (i in [0..4])
                        Button { graphic: icons[i] action: function(){ currentImage = i; }}
                    ]
                }
            ]
        }
    }
