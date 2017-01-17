/*
 * Copyright (c) 2008-2010, JFXtras Group
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
package org.jfxtras.data.pull;

import java.io.InputStream;
import java.lang.System;
import javafx.data.pull.Event;
import javafx.data.pull.PullParser;
import javafx.reflect.*;
import org.jfxtras.util.StringUtil;
import javafx.data.xml.QName;

class XMLObjectRef extends ObjectRef {
    override function initialize(parent:ObjectRef):Void {
        if (DEBUG) println("CURRENT.initialize({parent})");
        this.parent = parent;
        if (parent == null) {
            def baseClassName = StringUtil.capitalize(fxName);
            def rootClass = if (rootPackage == "") then baseClassName else "{rootPackage}.{baseClassName}";
            type = classRef = context.findClass(rootClass);
            fxObject = classRef.allocate();
            if (fxObject instanceof FXObjectValue)
                (fxObject as FXObjectValue).initialize();
        } else {
            member = if (parent.isSequence) then
                    parent.baseClassRef.getVariable(fxName)
                else
                    parent.classRef.getVariable(fxName);
            type = member.getType();
            fxObject = parent.fxObject;
            if (type instanceof FXSequenceType) {
                seqFxObject = member.getValue(fxObject as FXObjectValue) as FXSequenceValue;
                baseType = (type as FXSequenceType).getComponentType();
                baseClassRef = context.findClass(baseType.getName());
                fxObject = baseClassRef.allocate();
                isSequence = true;
            } else if (type instanceof FXClassType) {
                def ltype = type as FXLocal.ClassType;
                classRef = ltype;
                if (type.getName() != "java.lang.String" and
                    type.getName() != "java.util.Calendar" and
                    type.getName() != "java.util.Date" and
                    type.getName() != "javafx.date.DateTime")
                {
                    var val = member.getValue(fxObject as FXObjectValue);
                    if (val.isNull()) {
                        val = ltype.newInstance();
                        setValue(val);
                    }
                    fxObject = member.getValue(fxObject as FXObjectValue);
                }
            }
        }
    }

    public override function toString() {
        "xml = {name}\n fx = {fxName}\n member= {member}\n type = {type}\n isSequence = {isSequence}";
    }
}

/**
 * Generic handler for parsing XML into a JavaFX Object.
 * <p>
 * Typical usage is with the javafx.io.http.HttpRequest class.
 * <pre><code>
 * import org.jfxtras.data.pull.JsonHandler;
 * import javafx.io.http.HttpRequest;
 *
 * def urlPostal = "{__DIR__}postalCodeSearchXML";
 * var postalHandler = XMLHandler {
 *    rootClass: "org.jfxtras.data.pull.PostalCodeSearch"
 *    onDone: function(obj, isSequence):Void {
 *        postalCode = obj as PostalCodeSearch;
 *    }
 * };
 * var req = HttpRequest {
 *    location: urlPostal
 *    onInput: function(is:java.io.InputStream) {
 *        postalHandler.parse(is);
 *    }
 * };
 * req.start();
 * </code></pre>
 *
 * @profile desktop
 *
 * @author jclarke
 * @author Stephen Chin
 */
public class XMLHandler extends BaseHandler {
    def documentType:String = PullParser.XML;

    /**
     * The root package name for the XML data stream.
     * The handler will create a JavaFX object using this package name
     * combined with the first element name
     * This object will hold the JavaFX contents resulting from
     * parsing the XML data stream.
     */
    public-init var rootPackage:String;

    var attributes:AttributePair[];

    /**
     * Handles XML Parsing events.
     *
     * @param event PullParser event
     */
    function xmlHandler(event:Event):Void {
        if (DEBUG) println(event);
        if (event.type == PullParser.START_ELEMENT) {
            attributes = getAttributes(event);
            if (current != null) {
                parent = stack.push(current) as XMLObjectRef;
            }
            current = XMLObjectRef {}
            // What about Namespase??
            current.rootPackage = rootPackage;
            current.name = event.qname.name;
            current.fxName = getVariableName(getContext(), current.name);
            current.initialize(parent);
            if (DEBUG) println("START_ELEMENT push current pare: {parent.fxName} stack = {stack.size()}");
        } else if (event.type == PullParser.END_ELEMENT) {
            if (event.text.trim().length() > 0) {
                def type = if (current.isSequence) then current.baseType.getName() else current.type.getName();
                processText(type, event.text);
            }
            processAttributes(attributes);
            if (current.isSequence) {
                current.addElement(parent);
            }
            if (not stack.empty()) current = stack.pop() as XMLObjectRef;
            parent = if (stack.empty()) null else stack.peek() as XMLObjectRef;
            if (DEBUG) println("END_ELEMENT pop current {current.fxName} par: {parent.fxName} stack = {stack.size()}");
        } else if (event.type == PullParser.START_DOCUMENT) {
            current = parent = null;
            stack.clear();
        }
    }

    function getAttributes(event:Event):AttributePair[] {
        for (qname in event.getAttributeNames()) AttributePair {
            qname: qname
            value: event.getAttributeValue(qname)
        }
    }

    function processAttributes(attributes:AttributePair[]):Void {
        for (attr in attributes) {
            if (current != null) {
                parent = stack.push(current) as XMLObjectRef;
            }
            current = XMLObjectRef {}
            // What about Namespase??
            current.name = attr.qname.name;
            current.fxName = getVariableName(getContext(), current.name);
            current.initialize(parent);
            processText(current.type.getName(), attr.value);
            if (not stack.empty()) current = stack.pop() as XMLObjectRef;
            parent = if (stack.empty()) null else stack.peek() as XMLObjectRef;
        }

    }

    function getContext():String {
        if (parent.baseType == null) then parent.type.getName() else parent.baseType.getName();
    }

    /**
     * Fetches the XML data from the URL and parses into a JavaFX Object.
     * When complete, the onDone function will be called.
     */
    public function parse(in:InputStream):Void {
        def parser:PullParser = PullParser {
            documentType: documentType
            input: in
            onEvent: xmlHandler
            ignoreWhiteSpace: true
        };
        parser.parse();
        parseCompleteTime = System.currentTimeMillis();
        onDone((current.fxObject as FXLocal.Value).asObject());
    }

    function getClassNameDefault(rawClass:String):String {
        def sb = java.lang.StringBuffer{};
        var capNextChar = true;
        for(i in [0..<rawClass.length()]) {
            def a:Character = rawClass.charAt(i);
            if (java.lang.Character.isLetter(a) and capNextChar) {
                sb.append(java.lang.Character.toUpperCase(a));
                capNextChar = false;
                continue;
            }
            if (a == 0x3A /* ':' */ or a == 0x5F /* '_' */ or a == 0x2F /* "/" */) {
                capNextChar = true;
            } else {
                sb.append(a);
                capNextChar = false;
            }
        }
        sb.toString();
    }

    /**
     * Invoked when the parsing is successfully completed.
     * The model parameter is the object that is created by the parser. The isSequence
     * parameter indicates whether or not the model object is a sequence or not.
     */
    public var onDone:function( model:Object):Void;
}

class AttributePair {
    var qname:QName;
    var value:String;
}
