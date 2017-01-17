/*
 * Main.fx
 *
 * Created on Sep 18, 2009, 8:19:42 PM
 */

package jfxslideshow;

import javafx.scene.Scene;
import javafx.scene.image.Image;
import org.jfxtras.slideshow.PDFView;
import org.jfxtras.slideshow.SlidingThumb;
import java.util.HashMap;
import java.util.Map;
import javafx.animation.Timeline;
import javafx.animation.KeyFrame;
import javafx.scene.Group;
import javafx.scene.paint.Color;
import javafx.scene.shape.Rectangle;
import javafx.stage.Stage;
import java.awt.image.BufferedImage;
import org.jfxtras.pdf.PDFDocument;
import javafx.scene.input.KeyEvent;
import javafx.scene.control.Button;
import javafx.scene.shape.Polygon;
import javafx.scene.input.KeyCode;

import javafx.scene.input.MouseEvent;

import org.jfxtras.stage.XDialog;
import javafx.scene.input.MouseButton;

import javafx.scene.layout.VBox;

import javafx.geometry.HPos;
import javafx.scene.layout.HBox;

import javafx.scene.control.Label;

import javafx.scene.control.TextBox;

import javafx.geometry.VPos;


import javafx.scene.control.ProgressIndicator;

import javafx.scene.Node;

import java.net.MalformedURLException;
import java.net.URL;

import java.io.File;

import org.jfxtras.slideshow.Overlay;




/**
 * @author jimclarke
 */

def imageCache: Map = HashMap{};
def overlayMap = HashMap{};
def args = FX.getArguments();



var scene: Scene;
var currentImage1: Image;
var currentImage2: Image;
var currentOverlay1: Node;
var currentOverlay2: Node;
var thumb: SlidingThumb;

var progress = bind thumb.progress on replace {
    if(progress == 1.0) {
        imageCache.clear();
        pb.visible = false;
    }
}

var group: Group;
var alternate: Boolean;
var slideHeight = bind scene.height - thumb.boundsInParent.height-10;
def pdf1: PDFView = PDFView {
    width: bind scene.width
    height: bind slideHeight
    image: bind currentImage1
    overlay: bind currentOverlay1
};
def pdf2: PDFView = PDFView {
    width: bind scene.width
    height: bind slideHeight
    image: bind currentImage2
    overlay: bind currentOverlay2
    opacity: 0.0
};


var background: Rectangle;
var rightButton: Button;


function showPDFDialog(owner:Stage):Void {
    var textBox: TextBox;
    var thisDialog:XDialog = XDialog {
        owner: owner;
        resizable: false;
        modal: false;
        scene: Scene {
            
            content: VBox {
                nodeHPos: HPos.CENTER
                spacing: 10
                content: [
                    HBox {
                        spacing: 10
                        nodeVPos: VPos.CENTER
                        content: [
                            Label { text: "Location URL:" },
                            textBox = TextBox {
                                columns: 80
                                text: url
                                action: function () {
                                    println("new url = {textBox.text}");
                                    url = textBox.text;
                                    thisDialog.close();
                                }

                            }
                        ]
                    },
                    HBox {
                        spacing: 20
                        nodeVPos: VPos.CENTER
                        content: [
                            Button {
                                 text: "Cancel"
                                 action: function() {
                                     thisDialog.close();
                                 }
                             }
                            Button {
                                 text: "Ok"
                                 action: function() {
                                     println("OK new url = {textBox.text}");
                                     url = textBox.text;
                                     thisDialog.close();
                                 }
                             }
                        ]
                    }


                ]
            }

        }
    }
}
var pb:ProgressIndicator;

var stage: Stage = Stage {
    title : "JavaFX Slide Show"
    scene: scene = Scene {
        
        width: 1000
        height: 700
        fill: Color.web("#333")
        content: group = Group {
            content: [
                Group {
                    content: [
                        background = Rectangle {
                            width: bind scene.width
                            height: bind slideHeight
                            fill: Color.TRANSPARENT
                            onMousePressed: function(event: MouseEvent) {
                                if(event.button == MouseButton.SECONDARY)
                                    showPDFDialog(stage);
                            }

                            onKeyReleased: function(event: KeyEvent) {
                                if(event.code == KeyCode.VK_RIGHT) {
                                    if(thumb.currentIndex < thumb.numPages - 1 )
                                        thumb.currentIndex++;
                                }else if(event.code == KeyCode.VK_LEFT) {
                                    if(thumb.currentIndex > 0 )
                                        thumb.currentIndex--;
                                        /****
                                }else if(event.code == KeyCode.VK_ESCAPE) {
                                    println(event);
                                    println(stage.fullScreen);
                                    stage.fullScreen = not stage.fullScreen;
                                    println(stage.fullScreen);
                                 ****/
                                }
                            }
                        }


                        Button { // fullscreen, uppr left
                            action: function() {
                                stage.fullScreen = not stage.fullScreen;
                            }
                        },
                        pdf1,
                        pdf2,
                        Button {
                            layoutX: 5
                            layoutY: bind slideHeight/2.0
                            //graphicHPos: HPos.CENTER
                            //graphicVPos: VPos.CENTER
                            graphic: Polygon {
                                points: [
                                    0, 0,
                                    10, -10,
                                    10, 10
                                ]
                                fill: Color.rgb(64,64,64)
                            }

                            action: function() {
                                if(thumb.currentIndex > 0)
                                    thumb.currentIndex--;
                            }
                        },
                        rightButton = Button {
                            layoutX: bind scene.width - rightButton.width - 5
                            layoutY: bind slideHeight/2.0
                            //graphicHPos: HPos.CENTER
                            //graphicVPos: VPos.CENTER
                            graphic: Polygon {
                                points: [
                                    0, -10,
                                    10, 0,
                                    0, 10
                                ]
                                fill: Color.rgb(64,64,64)
                            }

                            action: function() {
                                if(thumb.currentIndex < thumb.numPages - 1 )
                                    thumb.currentIndex++;
                            }
                        }
                    ]
                }
                thumb = SlidingThumb {
                    layoutY: bind scene.height - 98
                    width: bind scene.width
                    height: bind 50
                    thumbWidth: 48
                    thumbHeight: 48
                    document: PDFDocument{ /**location: url**/ };
                    action: function(ndx: Integer, clearCache: Boolean) {
                        println("Action({ndx})");
                        if(clearCache) imageCache.clear();
                        var img = imageCache.get(ndx) as Image;
                        if(img == null) {
                            var page = thumb.document.pdfFile.getPage(ndx+1);
                            var awtImage = page.getImage(page.getWidth(), page.getHeight(), null, null, true, true);
                            img = Image.impl_fromPlatformImage(awtImage as BufferedImage);
                            imageCache.put(ndx, img);
                            println("imageCache.put({ndx}, {img})");
                        }
                        if(alternate) {
                            println("Play 2) {img}");
                            currentImage2 = img;
                            currentOverlay2 = overlayMap.get(ndx) as Node;
                            pdf2.requestLayout();
                            fade1.stop();
                            fade2.playFromStart();
                        } else {
                            println("Play 1) {img}");
                            currentImage1 = img;
                            currentOverlay1 = overlayMap.get(ndx) as Node;
                            pdf1.requestLayout();
                            fade2.stop();
                            fade1.playFromStart();
                        }
                    }


                },
                pb = ProgressIndicator {
                    layoutX: bind (scene.width - pb.layoutBounds.width)/2.0 - pb.layoutBounds.minX
                    layoutY: bind (scene.height - pb.layoutBounds.height)/2.0 - pb.layoutBounds.minY
                }
            ]
        }
    }
}
background.requestFocus();
var fade1 = Timeline {
    repeatCount: 1
    keyFrames : [
        at(0s) {
            pdf2.opacity => 1.0;
            pdf1.opacity => 0.0;
            pdf2.scaleX => 1;
            pdf2.scaleY => 1;
        }
        at(500ms) {
            pdf1.opacity => 0.0;
            pdf1.scaleX => 0.25;
            pdf1.scaleY => 0.25;
        }

        at(750ms) {
            pdf2.opacity => 0.0;
            pdf2.scaleX => 0.25;
            pdf2.scaleY => 0.25;
        }
        KeyFrame  {
            time: 1.5s
            values: [
                pdf1.opacity => 1.0,
                pdf1.scaleX => 1.0,
                pdf1.scaleY => 1.0,
            ]
            action: function() {
                alternate = not alternate;
            }

        }
    ]
};
var fade2 = Timeline {
    repeatCount: 1
    keyFrames : [
        at(0s) {
            pdf2.opacity => 0.0;
            pdf1.opacity => 1.0;
            pdf1.scaleX => 1.0;
            pdf1.scaleY => 1.0;
        }
        at(500ms) {
            pdf2.opacity => 0.0;
            pdf2.scaleX => 0.25;
            pdf2.scaleY => 0.25;
        }

        at(750ms) {
            pdf1.opacity => 0.0;
            pdf1.scaleX => 0.25;
            pdf1.scaleY => 0.25;
        }

        KeyFrame  {
            time: 1.5s
            values: [
                pdf2.opacity => 1.0,
                pdf2.scaleX => 1.0,
                pdf2.scaleY => 1.0,
            ]
            action: function() {
                alternate = not alternate;
            }

        }
    ]
};



var url:String  on replace old {
    println("url = {url} old = {old}");
    if(url != old) {
        pb.visible = true;
        alternate = false;
        currentImage1 = null;
        currentImage2 = null;
        currentOverlay1 = null;
        currentOverlay2 = null;
        pdf1.opacity = 1.0;
        pdf2.opacity = 0.0;
        imageCache.clear();
        thumb.reset(url);
        thumb.requestLayout();
        pdf1.requestLayout();
    }
 }
 // if not a url string assume it is a file string
function getURL(str: String) : String {
    var result: String;
    try {
        var url = new URL(str);
        result = "{url}";
    }catch(ex: MalformedURLException) {
       var file = new File(str);
       result = "{file.toURL()}";
    }
    result;
}

var i:Integer;
while(i <sizeof args) {
    if(args[i] == "-o") {
        var overlay = Overlay {
            location: getURL(args[++i])
            map: overlayMap
        }

    }
    else {
        url = getURL(args[i]);
    }
    i++;
}
if(url == "")
     showPDFDialog(stage);