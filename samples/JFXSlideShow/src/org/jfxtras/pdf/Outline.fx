/*
 * Outline.fx
 *
 * Created on Jul 10, 2009, 11:40:41 AM
 */

package org.jfxtras.pdf;

import com.sun.pdfview.action.PDFAction;

/**
 * @author jclarke
 */

public class Outline {
    public var title: String;

    public var parent: Outline;
    public var children: Outline[] on replace old[lo..hi] = newv {
        for(o in old) {
            o.parent = null;
        }
        for(o in newv) {
            o.parent = this;
        }
    }

    public var action: PDFAction;

}
