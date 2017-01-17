/*
 * PDFPage.fx
 *
 * Created on Jul 9, 2009, 6:16:55 PM
 */

package org.jfxtras.pdf;

import javafx.scene.image.Image;


import java.awt.image.BufferedImage;

import javafx.async.JavaTaskBase;

import javafx.async.RunnableFuture;

/**
 * @author jclarke
 */
public function getImage(page:com.sun.pdfview.PDFPage, width: Number, height: Number, listener: ImageListener) : Void {
     var task = JavaTaskBase {

        protected override function create() : RunnableFuture {
            new PDFImageLoader(page, width, height, listener);
        }
     }
     task.start();
}
public class PDFPage extends ImageListener {
    var page: com.sun.pdfview.PDFPage;
    public-init var document: PDFDocument;
    public-read var image: Image;
    public var pageNumber: Integer on replace {
        if(isInitialized(pageNumber)) {
            page = document.pdfFile.getPage(pageNumber );
        }
    }

    public function getImage(width: Number, height: Number, listener: ImageListener) : Void {
        getImage(page, width, height, listener);
    }
    public function getImage(width: Number, height: Number) : Void {
        getImage(page, width, height, this);
    }
    override function imageLoaded(img:java.awt.Image) : Void {
        image = Image.impl_fromPlatformImage(img as BufferedImage);
    }






}
