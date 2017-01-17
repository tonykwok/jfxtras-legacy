/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package org.jfxtras.pdf;

import com.sun.javafx.runtime.Entry;
import com.sun.pdfview.PDFPage;
import java.awt.Image;
import javafx.async.RunnableFuture;

/**
 *
 * @author jimclarke
 */
public class PDFImageLoader implements RunnableFuture {
    PDFPage page;
    int width;
    int height;
    ImageListener listener;
    public PDFImageLoader(PDFPage page, int width, int height, ImageListener listener) {
        this.page = page;
        this.width = width;
        this.height = height;
        this.listener= listener;
    }
    public void run() {
        final Image img = page.getImage(width, height, null, null, true, true);
        Entry.deferAction(new Runnable() {
            public void run() {
                listener.imageLoaded(img);
            }
        });
    }

}
