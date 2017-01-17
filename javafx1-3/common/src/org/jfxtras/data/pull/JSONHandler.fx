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

var DEBUG = false;
def context:FXLocal.Context = FXLocal.getContext();

class JSONObjectRef extends ObjectRef {
    override function initialize(parent:ObjectRef):Void {
        if (DEBUG) println("CURRENT.initialize({parent})");
        this.parent = parent;
        if (parent == null) {
            if (rootClass.endsWith("[]")) {
                baseType = context.findClass(rootClass.substring(0, rootClass.length() - 2));
                type = baseType.getSequenceType();
            } else {
                classRef = context.findClass(rootClass);
                fxObject = classRef.allocate();
                if (fxObject instanceof FXObjectValue) (fxObject as FXObjectValue).initialize();
            }
        } else {
            if (parent.type instanceof FXSequenceType) {
                type = (parent.type as FXSequenceType).getComponentType();
                classRef = context.findClass(type.getName());
                fxObject = classRef.allocate();
                if (fxObject instanceof FXObjectValue) (fxObject as FXObjectValue).initialize();
            } else {
                member = parent.classRef.getVariable(fxName);
                type = member.getType();
                if (type instanceof FXSequenceType) baseType = (type as FXSequenceType).getComponentType();
                fxObject = parent.fxObject;
                if (type instanceof FXClassType) {
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
    }

    public override function toString() {
        "json = {name}\n fx = {fxName}\n member= {member}\n type = {type}\n sequenceBuilder = {sequenceBuilder}";
    }
}

/**
 * Generic handler for parsing JSON into a JavaFX Object.
 * <p>
 * Typical usage is with the javafx.io.http.HttpRequest class.
 * <pre><code>
 * import org.jfxtras.data.pull.JsonHandler;
 * import javafx.io.http.HttpRequest;
 *
 * def urlPostal = "{__DIR__}postalCodeSearchJSON";
 * var postalHandler = JSONHandler {
 *    rootClass: "org.jfxtras.data.pull.PostalCode[]"
 *    onDone: function(obj, isSequence):Void {
 *        postalCodes = obj as PostalCodes[];
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
public class JSONHandler extends BaseHandler {
    def documentType:String = PullParser.JSON;

    /**
     * The root class name for the JSON data stream.
     * The handler will create a JavaFX object using this class name
     * and this object will hold the JavaFX contents resulting from
     * parsing the JSON data stream.
     */
    public-init var rootClass:String;

    /**
     * Handles JSON Parsing events.
     *
     * @param event PullParser event
     */
    function jsonHandler(event:Event):Void {
        if (DEBUG) println(event);
        if (event.type == PullParser.START_ELEMENT) {
            if (current != null) {
                parent = stack.push(current) as JSONObjectRef;
            }
            current = JSONObjectRef {rootClass: rootClass}
            if (DEBUG) println("START_ELEMENT push current parent: {parent.fxName} stack = {stack.size()}");
        } else if (event.type == PullParser.END_ELEMENT) {
            if (not stack.empty())
            current = stack.pop() as JSONObjectRef;
            parent = if (stack.empty()) null else stack.peek() as JSONObjectRef;
            if (DEBUG) println("END_ELEMENT pop current {current.fxName} parent: {parent.fxName} stack = {stack.size()}");
        } else if (event.type == PullParser.START_VALUE) {
            current.name = event.name;
            current.fxName = getVariableName(getContext(), current.name);
            current.initialize(parent);
            if (DEBUG) println("START_VALUE: current {current}\n parent: {parent.fxName} stack = {stack.size()}")
        } else if (event.type == PullParser.START_ARRAY) {
            current.startSequence();
        } else if (event.type == PullParser.END_ARRAY) {
            current.closeSequence();
        } else if (event.type == PullParser.START_DOCUMENT) {
            current = parent = null;
            stack.clear();
            if (not rootClass.endsWith("[]")) {
                current = JSONObjectRef {rootClass: rootClass}
                current.fxName = "::ROOT::";
                current.name = "::JSON::";
                current.initialize(null);
            }
        } else if (event.type == PullParser.START_ARRAY_ELEMENT) {
            if (current != null) {
                parent = stack.push(current) as JSONObjectRef;
            }
            current = JSONObjectRef {rootClass: rootClass}
            current.name = parent.name;
            current.fxName = parent.fxName;
            current.initialize(parent);
            if (DEBUG) println("START_ARRAY_ELEMENT push current {current.fxName} parent: {parent.fxName} stack = {stack.size()}");
        } else if (event.type == PullParser.END_ARRAY_ELEMENT) {
            if (DEBUG) println("END_ARRAY_ELEMENT current = {current.fxName} : {current.fxObject.getValueString()} : {current.sequenceBuilder}");
            def val = current.fxObject;
            if (not stack.empty()) current = stack.pop() as JSONObjectRef;
            parent = if (stack.empty()) null else stack.peek() as JSONObjectRef;
            current.addElement(val);
            if (DEBUG) println("END_ARRAY_ELEMENT pop current {current.fxName} parent: {parent.fxName} stack = {stack.size()}");
        } else if (event.type == PullParser.TEXT) {
            processText(current.type.getName(), event.text);
        } else if (event.type == PullParser.INTEGER) {
            def type = current.type.getName();
            if (type == "Number" or type == "Float") {
                current.setValue(context.mirrorOf(java.lang.Float.valueOf(event.integerValue)));
            } else if (type == "Integer") {
                current.setValue(context.mirrorOf(java.lang.Integer.valueOf(event.integerValue)));
            } else if (type == "Boolean") {
                def val = (event.integerValue != 0);
                current.setValue(context.mirrorOf(val));
            } else { // assume String
                current.setValue(context.mirrorOf(java.lang.String.valueOf(event.integerValue)));
            }
        } else if (event.type == PullParser.NUMBER) {
            def type = current.type.getName();
            if (type ==  "Number" or type == "Float") {
                current.setValue(context.mirrorOf(java.lang.Float.valueOf(event.numberValue)));
            } else if (type == "Integer") {
                current.setValue(context.mirrorOf(java.lang.Integer.valueOf(event.numberValue.intValue())));
            } else if (type == "Boolean") {
                def val = (event.numberValue != 0);
                current.setValue(context.mirrorOf(val));
            } else { // assume String
                current.setValue(context.mirrorOf(java.lang.String.valueOf(event.numberValue)));
            }
        } else if (event.type == PullParser.FALSE or event.type == PullParser.TRUE) {
            def type = current.type.getName();
            def val = event.booleanValue;
            if (type ==  "Number" or type == "Float") {
                def nval = if (val) 1.0 else 0.0;
                current.setValue(context.mirrorOf(nval));
            } else if (type == "Integer") {
                def ival = if (val) 1 else 0;
                current.setValue(context.mirrorOf(ival));
            } else if (type == "Boolean") {
                current.setValue(context.mirrorOf(val));
            } else { // assume String
                current.setValue(context.mirrorOf(val));
            }
        } else if (event.type == PullParser.NULL) {
            if (DEBUG) println("Unhandled NULL event");
        }
    }

    /**
     * Fetches the JSON data from the URL and parses into a JavaFX Object.
     * When complete, the onDone function will be called.
     */     
    public function parse(in:InputStream):Void {
        def parser:PullParser = PullParser {
            documentType: documentType
            input: in
            onEvent: jsonHandler
        }
        parser.parse();
        parseCompleteTime = System.currentTimeMillis();
        if (current.sequenceBuilder != null) {
            // workaround, because sequence types get destroyed in the asObject() conversion, so we have to rebuild it.
            def seq = current.sequenceBuilder.getSequence();
            onDone(seq, true);
            onSeqDone(for (i in [0..seq.getItemCount()]) (seq.getItem(i) as FXLocal.Value).asObject());
        } else {
            def model = (current.fxObject as FXLocal.Value).asObject();
            onDone(model, false);
            onSeqDone(model);
        }
    }

    function getContext():String {
        if (parent.type == null) then parent.rootClass else parent.type.getName();
    }

    /**
     * Invoked when the parsing is successfully completed.
     * The model parameter is the object that is created by the parser.
     * <p>
     * If you have multiple results, isSeq will be true.  In this case the model
     * will be a raw ObjectArraySequence.  Rather than dealing with the associated
     * type issues, it is recommended to use the onSeqDone callback instead.
     */
    public var onDone:function(model:Object, isSeq:Boolean):Void;

    /**
     * Invoked when the parsing is successfully completed.
     * The model parameter is the object the sequence of objects that were created
     * by the parser.  If only one object was created, model will be a list with
     * a single element.
     */
    public var onSeqDone:function(model:Object[]):Void;
}
