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

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Stack;
import javafx.date.DateTime;
import javafx.reflect.*;
import org.jfxtras.util.StringUtil;

protected var DEBUG = false;
protected def context:FXLocal.Context = FXLocal.getContext();

/**
 * A function for variable name translation that merely returns the
 * JSON name.
 */
public def IDENTITY = function (context:String, rawName:String):String {rawName}

/**
 * A function for variable name translation that converts the raw name to
 * CamelCase. There rules are any letter following '_', ':', or '/' will be
 * capitalized, unless the special character is first.
 * For example, "foo" returns "foo", "_foo" returns "foo",
 * "foo/bar" returns "fooBar", and "/foo/bar" return "fooBar"
 */
public def CAMEL_CASE = function (context:String, rawName:String):String {StringUtil.camelCase(rawName)}

/**
 * @author Stephen Chin
 */
public abstract class BaseHandler {
    /**
     * Holds the start time for parsing.
     */
    public-read protected var startTime:Long;

    /**
     * Holds the finish time for parsing.
     */
    public-read protected var parseCompleteTime:Long;

    /**
     * holds a function to translate the JSON Object name to the FX variable name.
     * @defaultValue CAMEL_CASE
     */
    public var getVariableName:function(context:String, rawName:String):String = CAMEL_CASE;
    
    /**
     * Format for parsing datetime strings based on java.text.SimpleDateFormat
     *
     * @defaultValue "yyyy-MM-dd HH:mm:ss"
     * @see java.text.SimpleDateFormat
     */
    public var dateFormat = "yyyy-MM-dd HH:mm:ss" on replace {
        df = new SimpleDateFormat(dateFormat);
    }

    protected var df:SimpleDateFormat;

    /**
     * Set to true to enable warnings on unmapped values.  The default value is false.
     */
    public-init var warn = false;

    /** The current object being parsed */
    protected var current:ObjectRef;
    /** The parent of the current object being parsed */
    protected var parent:ObjectRef;
    /** Holds the stack of ObjectRef's during parsing */
    protected def stack:Stack = Stack {}

    protected function processText(type:String, text:String):Void {
        if (type ==  "Integer") {
            current.setValue(context.mirrorOf(Integer.valueOf(text)));
        } else if (type ==  "Long") {
            current.setValue(context.mirrorOf(Long.valueOf(text)));
        } else if (type == "Number" or type == "Float") {
            current.setValue(context.mirrorOf(Float.valueOf(text)));
        } else if (type == "Double") {
            current.setValue(context.mirrorOf(Double.valueOf(text)));
        } else if (type == "Boolean") {
            def val = text.equalsIgnoreCase("true") or text.equalsIgnoreCase("yes") or text.equalsIgnoreCase("Y");
            current.setValue(context.mirrorOf(val));
        } else if (type == "java.lang.String") {
            current.setValue(context.mirrorOf(text));
        } else if (type == "java.util.Calendar" or type == "java.util.Date") {
            try {
                def date = df.parse(text);
                if (type == "java.util.Date") {
                    current.setValue(context.mirrorOf(date));
                } else { // java.util.Calendar
                    def cal = Calendar.getInstance();
                    cal.setTime(date);
                    current.setValue(context.mirrorOf(cal));
                }
            } catch (e:java.text.ParseException) { //not a known date, so lets see if it is long millis.
                def millis = Long.valueOf(text);
                def cal = Calendar.getInstance();
                cal.setTimeInMillis(millis);
                current.setValue(context.mirrorOf(cal));
            }
        } else if (type == "javafx.date.DateTime") {
            var dt:DateTime;
            try {
                // Try XML Date first
               dt = DateTime.impl_parseXMLDateTime(text);
            } catch (e:java.lang.Exception) {
                try {
                    // RFC822 Date next
                    dt = DateTime.impl_parseRFC822DateTime(text);
                } catch (e1:java.lang.Exception) {
                    try {
                        // Date Format next
                        def date = df.parse(text);
                        dt = DateTime {instant: date.getTime() };
                    } catch (e2:java.lang.Exception) {
                        // Last we assume it is in millis.
                        def millis = Long.valueOf(text);
                        dt = DateTime {instant: millis};
                    }
                }
            }
            if (dt != null) {
                current.setValue(context.mirrorOf(dt));
            }
        } else {
            if (DEBUG) println("Current - {current}");
            if (warn) println("WARNING - Unhandled type: {type}::{text}");
        }
    }
}
