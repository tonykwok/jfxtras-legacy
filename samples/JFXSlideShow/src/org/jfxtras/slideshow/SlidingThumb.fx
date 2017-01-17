/*
 * SlidingThumb.fx
 *
 * Created on Sep 22, 2009, 10:09:17 AM
 */

package org.jfxtras.slideshow;

import javafx.scene.control.Button;
import javafx.scene.image.ImageView;
import javafx.util.Math;
import org.jfxtras.pdf.PDFDocument;


import javafx.scene.paint.Color;




import javafx.stage.Stage;
import javafx.scene.Scene;

import java.io.File;



import javafx.scene.shape.Rectangle;

import javafx.scene.Group;

import java.awt.image.BufferedImage;
import java.lang.Void;
import org.jfxtras.pdf.ImageListener;
import org.jfxtras.pdf.PDFPage;



import javafx.scene.control.Slider;

import javafx.util.Sequences;
import java.util.Comparator;

import javafx.scene.input.KeyEvent;

import javafx.scene.effect.Reflection;

import javafx.scene.control.ProgressBar;

import javafx.scene.layout.VBox;

import javafx.geometry.HPos;
import javafx.scene.image.Image;


import javafx.scene.layout.HBox;

import javafx.geometry.VPos;


import javafx.scene.layout.Panel;

import javafx.scene.layout.Container;

/**
 * @author jimclarke
 */


class ButtonHolder extends Button {
    public var index: Integer;
}

def accentColor = com.sun.javafx.scene.control.caspian.Caspian.ACCENT_COLOR;
def baseColor = com.sun.javafx.scene.control.caspian.Caspian.BASE_COLOR;
def strongBaseColor = com.sun.javafx.scene.control.caspian.Caspian.STRONG_BASE_COLOR;
def darkTextColor = com.sun.javafx.scene.control.caspian.Caspian.DARK_TEXT_COLOR;
def textColor = com.sun.javafx.scene.control.caspian.Caspian.TEXT_COLOR;
def lightTextColor = com.sun.javafx.scene.control.caspian.Caspian.LIGHT_TEXT_COLOR;
def markColor = com.sun.javafx.scene.control.caspian.Caspian.MARK_COLOR;
def lightMarkColor = com.sun.javafx.scene.control.caspian.Caspian.LIGHT_MARK_COLOR;

public class SlidingThumb extends ResizableCustomNode {
    public var padding = 10.0;
    public var fill = Color.web("#333");
    var carousel: Carousel; 
    var slider:Slider;
    public var spacing = 5.0 on replace {
         node.requestLayout();
    }

    public var action: function(pageNum: Integer, clearCache: Boolean) : Void ;

    public var thumbWidth = 96.0 on replace {
         node.requestLayout();
    }

    public var thumbHeight = 96.0 on replace {
        node.requestLayout();
    }
    public function reset(location: String) : Void {
        if(document.location != location) {
            loadingDone = false;
            numLoaded = 0;
            numPages = 0;
            delete stagingButtons;
            delete buttons;
            document.location = location;
        }
    }

    function reset() : Void {
            loadingDone = false;
            numLoaded = 0;
            numPages = 0;
            delete stagingButtons;
            delete buttons;
            document.location = "";
    }


    var loadingDone = false;
    public-read var progress = bind progressBar.progress on replace {
        if(progress == 1.0) {
                progressBar.visible = false;
                node.requestLayout();
                //progressBar = null;
        }

    }

    var thumbsLoaded = bind numPages > 0 and numPages == sizeof stagingButtons
        on replace {
            if(thumbsLoaded and not loadingDone) {
                loadingDone = true;
                // sort buttons based on id (index)
                buttons = Sequences.sort(stagingButtons, Comparator {
                    override function compare(a: Object, b: Object) : Integer {
                        var ab = a as ButtonHolder;
                        var bb = b as ButtonHolder;
                        return ab.index - bb.index;
                    }
                    override function equals(o: Object) {
                        compare(this, o) == 0;
                    }
                }) as ButtonHolder[];
                
                node.requestLayout();
                currentIndex = 1;
                currentIndex = 0;
                //carousel.shiftTo(0);
                //action(currentIndex);
                //println("ThumbsLoaded currentIndex = {currentIndex}");
            }

    }
    var progressBar: ProgressBar;
    var numLoaded: Integer on replace {
        node.requestLayout();
        //println("loaded { numLoaded} of {numPages}");
    }

    public-read var numPages:Integer on replace {
        //println("numPages {numPages}");

    }

    public var document: PDFDocument;
    var stagingButtons: ButtonHolder[];
    var buttons: ButtonHolder[];

    var documentLocked = bind document.locked on replace old {
        if(isInitialized(documentLocked) and not documentLocked and documentLocked != old) {
            var inew = (currentIndex + 0.5).intValue();
            carousel.shiftTo(inew+1);
            carousel.shiftTo(inew);
            action(inew, true);
        }
    }


    public var currentIndex: Number  on replace {
        if(isInitialized(currentIndex) and not documentLocked  ) {
            var inew = (currentIndex + 0.5).intValue();
            carousel.shiftTo(inew);
            action(inew, false);
        }
    }

    function createProgressBar() : Void {
        progressBar = ProgressBar {
            width: bind width/2.0
            visible: true
        }
    }


    var pdfFile = bind document.pdfFile on replace old {
        //println("pdfFile = {pdfFile}");
        if(pdfFile != null and not FX.isSameObject(pdfFile, old)) {
            numPages = pdfFile.getNumPages();
            createProgressBar();
            for (p in [1..numPages] ) {
                var page = pdfFile.getPage(p, true);
                var wid = Math.ceil((thumbWidth-padding*2) * page.getAspectRatio()).intValue();
                PDFPage.getImage(page, wid, thumbHeight.intValue()-padding*2,
                    ImageListener {
                        override function imageLoaded(img:java.awt.Image) : Void {
                            addButton(p-1, img as BufferedImage);

                        }
                    }

                );
             }

        }else {
            //println("pdfFile = null");
            reset();
        }
    }

    public function addButton(pIndex: Integer, img: BufferedImage) : Void {
        var iv = ImageView {
            image: Image.impl_fromPlatformImage(img as BufferedImage);
        }
        var button:ButtonHolder = ButtonHolder {
            index: pIndex
            id: "{pIndex}"

            width: bind iv.image.width + padding*2
            height: bind thumbHeight
            graphic: iv
            scaleX: bind if(currentIndex.intValue() == button.index) 1.2 else 1.0
            scaleY: bind if(currentIndex.intValue() == button.index) 1.2 else 1.0

            //graphicHPos: HPos.CENTER
            action: function() {
                currentIndex = pIndex;
                
            }
        }
        insert button into stagingButtons;
        numLoaded++;
        //println("numLoaded = {numLoaded}, numPages = {numPages}, progress = {ProgressBar.computeProgress(numPages, numLoaded)}, {numLoaded/numLoaded}");
        progressBar.progress = ProgressBar.computeProgress(numPages, numLoaded);
        //println("progressBar.progress = {progressBar.progress}");

    }


    override function getPrefHeight(h: Number)  {
        thumbHeight;
    }
    override function getPrefWidth(w: Number) {
        thumbWidth * 10.4;
    }

    override var width on replace {
        if(width > 0) {
            node.requestLayout();
        }

    }
    override var height on replace { 
        if(height > 0) {
            node.requestLayout();
        }
    }
    var node: Group;
    var panelX: Number;


    override function create() {
        var vbox: VBox;
        var pbGroup: Group;
        node = Panel {
            onLayout: function() {
                Container.layoutNode(carousel,
                    0, 0,
                    width, height,
                    HPos.CENTER, VPos.CENTER);
                Container.positionNode(slider,
                    (width - slider.layoutBounds.width)/2.0 - slider.layoutBounds.minX,
                    carousel.layoutBounds.height
                );
                if(pbGroup.visible) {
                 Container.positionNode(pbGroup,
                    0, 0,
                    width, height,
                    HPos.CENTER, VPos.CENTER);
                }
            }

            content: [
                Rectangle {
                    width: bind width
                    height: bind height
                    fill: bind fill
                    onKeyReleased: function(e: KeyEvent) {
                        // TODO
                        //println(e);
                    }

                }
                carousel = Carousel {
                        effect: Reflection{}
                        width: bind width
                        height: bind height
                        nodes: bind buttons
                },
                slider = Slider {
                    vertical: false
                    width: bind width/3.0
                    max: bind sizeof buttons -1
                    value: bind currentIndex with inverse
                    blockIncrement: 1
                    snapToTicks: true
                    majorTickUnit: 1
                    //clickToPosition: true
                    minorTickCount: 1


                }
                pbGroup = Group { content: bind progressBar }
            ]
        }
    }
}

function run() {
    def file = new File("JavaFX_1.2_Golden_Pitch_26.07.09.pdf");
    var scene: Scene;
    Stage {
        title : "MyApp"
        scene: scene = Scene {
            width: 800
            height: 120
            content: [
                SlidingThumb {
                    width: bind scene.width
                    height: bind scene.height
                    thumbWidth: 64
                    thumbHeight: 64
                    document: PDFDocument{ location: "{file.toURL()}" };
                }

            ]
        }
    }


}

