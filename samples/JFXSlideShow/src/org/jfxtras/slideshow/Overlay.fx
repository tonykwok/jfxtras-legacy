/*
 * Overlay.fx
 *
 * Created on Oct 21, 2009, 4:20:14 PM
 */

package org.jfxtras.slideshow;

import java.util.HashMap;
import java.util.Map;
import javafx.reflect.FXLocal;

import javafx.data.pull.Event;
import javafx.data.pull.PullParser;
import javafx.io.http.HttpRequest;
import java.io.InputStream;

import javafx.scene.Node;


import java.net.URLClassLoader;

import java.net.URL;

import java.io.File;
import java.net.MalformedURLException;






/**
 * @author jimclarke
 */

public class Overlay {
    public var map: Map = HashMap{};
    public var location: String on replace {
        if(location != null)
            load();
    }
    def context = FXLocal.getContext();
    var classLoader: URLClassLoader;
    var pathElements: URL[];

    /****** Example XML
 <overlays>
    <classpath>
        <pathelement path="foo.jar" />
    </classpath>
    <overlay index="2" class="jfxslideshow.TestOverlay" />
</overlays>
    *******/
    function handler(ev: Event) : Void {
        if(ev.type == PullParser.START_ELEMENT) {
            if(ev.qname.name == "overlay") {
                //println(ev);
                var index = java.lang.Integer.valueOf(ev.getAttributeValue("index"));
                var classname = ev.getAttributeValue("class");
                var cls = if(classLoader == null) context.findClass(classname)
                    else context.findClass(classname, classLoader);
                var fxvalue = cls.newInstance();
                var node: Node = (fxvalue as FXLocal.ObjectValue).asObject() as Node;
                map.put(index, node);
            }else if(ev.qname.name == "pathelement") {
                var path = getURL(ev.getAttributeValue("path"));
                //println("Add Path {path}");
                insert path into pathElements;
            }
        }else if(ev.type == PullParser.END_ELEMENT) {
            if(ev.qname.name == "classpath" and sizeof pathElements > 0) {
                classLoader = new URLClassLoader(pathElements, this.getClass().getClassLoader());
            }

        }

    }

    function getURL(str: String) : URL {
     var url: URL;
        try {
            url = new URL(str);
        }catch(ex: MalformedURLException) {
           var file = new File(str);
           url = file.toURL();
        }
        url;
    }


    function load () : Void {
        var request = HttpRequest {
            location: location
            onInput: function(input: InputStream) : Void {
                try {
                    var parser = PullParser {
                        documentType: PullParser.XML
                        input: input
                        onEvent: handler
                    }
                    parser.parse();
                } finally {
                    input.close();
                }
            }

        }
        request.start();

    }


}
