
/*
 * PDFDocument.fx
 *
 * Created on Jul 9, 2009, 6:10:19 PM
 */
package org.jfxtras.pdf;

/**
 * @author jclarke
 */

import com.sun.pdfview.PDFFile;

import javafx.io.http.HttpRequest;
import java.io.ByteArrayOutputStream;
import java.nio.ByteBuffer;
import com.sun.pdfview.PDFDestination;
import com.sun.pdfview.action.GoToAction;
import com.sun.pdfview.action.PDFAction;
import java.io.IOException;


public class PDFDocument {
    public-read var locked = false;
    public-read  var pdfFile: PDFFile on replace {
        if(pdfFile != null) {
            var iter = pdfFile.getMetadataKeys();
            delete metaKeys;
            while(iter.hasNext()) {
                var key = iter.next() as String;
                insert key into metaKeys;
            }
            outline = getOutline();

        }

    }

    public var location: String on replace old {
        println("Location = {location}, old = {old}");
        if(location != null and location != old) {
           locked = true;
           var httpRequest:HttpRequest = HttpRequest {
               location: location
               sink: ByteArrayOutputStream {};
               onDone: function() {
                   var byteArray = (httpRequest.sink as ByteArrayOutputStream).toByteArray();
                   var buf = ByteBuffer.allocate(byteArray.length);
                   buf.put(byteArray);
                   pdfFile = new PDFFile(buf);
                   locked = false;
                   println("HTTP Request: pdfFile = {pdfFile}");
               }
           };
           httpRequest.start();
        }
    }

    public-read var numPages: Integer = bind pdfFile.getNumPages();
    public-read var printable = bind pdfFile.isPrintable();
    public-read var readonly = bind not pdfFile.isSaveable();
    public-read var majorVersion = bind pdfFile.getMajorVersion();
    public-read var minorVersion = bind pdfFile.getMinorVersion();

    public-read var metaKeys: String[];
 
    public-read var outline : Outline;

    function getOutline() : Outline {
        // find the outlines entry in the root object
        var root = pdfFile.getRoot();
        var oroot = root.getDictRef("Outlines");
        var work:Outline = null;
        var outline:Outline = null;
        if (oroot != null) {
            // find the first child of the outline root
            var scan = oroot.getDictRef("First");
            outline = work = Outline{ title: "<top>"};

            // scan each sibling in turn
            while (scan != null) {
                // add the new node with it's name
                var title = scan.getDictRef("Title").getTextStringValue();
                var build = Outline{title: title};
                insert build into work.children;

                // find the action
                var action:PDFAction = null;

                var actionObj = scan.getDictRef("A");
                if (actionObj != null) {
                    action = PDFAction.getAction(actionObj, root);
                } else {
                    // try to create an action from a destination
                    var destObj = scan.getDictRef("Dest");
                    if (destObj != null) {
                        try {
                            var dest =
                                    PDFDestination.getDestination(destObj, root);

                            action = new GoToAction(dest);
                        } catch ( ioe: IOException ) {
                            // oh well
                        }
                    }
                }

                // did we find an action?  If so, add it
                if (action != null) {
                    build.action = action;
                }

                // find the first child of this node
                var kid = scan.getDictRef("First");
                if (kid != null) {
                    work = build;
                    scan = kid;
                } else {
                    // no child.  Process the next sibling
                    var next = scan.getDictRef("Next");
                    while (next == null) {
                        scan = scan.getDictRef("Parent");
                        next = scan.getDictRef("Next");
                        work =  work.parent;
                        if (work == null) {
                            break;
                        }
                    }
                    scan = next;
                }
            }
        }
        return outline;
    }


    public function getMetaData(key: String) : String {
        if(pdfFile != null) {
            pdfFile.getStringMetadata(key);
        }else {
            null;
        }


    }


    public function getPage(page:Integer) : PDFPage {
        if(pdfFile != null) {
            PDFPage { 
                document: this
                pageNumber: page
            }
        } else {
            null;
        }
    }



}
