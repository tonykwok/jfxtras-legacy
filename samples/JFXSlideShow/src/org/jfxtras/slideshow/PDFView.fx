/*
 * PDFView.fx
 *
 * Created on Sep 23, 2009, 2:39:59 PM
 */

package org.jfxtras.slideshow;

import javafx.scene.image.Image;
import javafx.scene.image.ImageView;
import javafx.scene.layout.Panel;

import javafx.scene.layout.Container;

import javafx.geometry.HPos;
import javafx.geometry.VPos;

import javafx.scene.shape.Rectangle;

import javafx.scene.paint.Color;

import javafx.scene.Node;

import javafx.scene.Group;

/**
 * @author jimclarke
 */

public class PDFView extends ResizableCustomNode { 
    public var fill = Color.web("#333");
    public var overlay: Node;
    var imageView: ImageView;
    var panel: Panel;
    public var image: Image on replace {
        panel.requestLayout();
    }

    override function getPrefHeight(h: Number)  {
        500.0;
    }
    override function getPrefWidth(w: Number) {
        500.0;
    }

    override var width on replace {
        panel.requestLayout();
    }
    override var height on replace {
        panel.requestLayout();
    }

    override function create() {

        panel = Panel {
            width: bind width
            height: bind height
            onLayout: function() {
                for(p in panel.content) {
                    Container.layoutNode(p,
                        0, 0, width, height,
                        HPos.CENTER, VPos.CENTER);
                }
            }

            content: [
                Rectangle {
                    width: bind width
                    height: bind height
                    fill: bind fill
                }

                ImageView {
                    image: bind image
                    preserveRatio: true
                    fitHeight: bind height
                    fitWidth: bind width
                }
                Group { content: bind overlay }

            ]
        }


    }

}
