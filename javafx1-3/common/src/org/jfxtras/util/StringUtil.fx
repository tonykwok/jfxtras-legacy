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
package org.jfxtras.util;

import java.lang.StringBuilder;

/**
 * Set of string utilities to perform common functions.  All of these functions
 * are static, so they can be called without an instance of this class.
 *
 * @author Stephen Chin
 */
public class StringUtil {}

/**
 * Converts a string in camel case to title case complete with spaces and
 * capitalization.
 * <p>
 * For example the string "iLikeCheese" would convert to "I Like Cheese"
 */
public function camelToTitleCase(camelCase:String):String {
    if (camelCase.length() == 0) return camelCase;
    def chars = camelCase.toCharArray();
    def result = StringBuilder{};
    for (char in chars) {
        if (indexof char == 0) {
            result.append(Character.toUpperCase(char));
        } else if (Character.isUpperCase(char)) {
            result.append(" ");
            result.append(char);
        } else {
            result.append(char);
        }
    }
    return result.toString();
}

/**
 * A function for variable name translation that converts an arbitrary String to
 * CamelCase. The rule is that any letter following ' ', '_', ':', or '/' will be
 * capitalized, unless the special character is first.
 * For example, "foo" returns "foo", "_foo" returns "foo",
 * "foo/bar" returns "fooBar", and "/foo/bar" return "fooBar"
 */
public function camelCase(s:String):String {
    if (s.length() == 0) return s;
    def chars = s.toCharArray();
    def result = StringBuilder{};
    var capNextChar = false;
    for (char in chars) {
        if (Character.isLetter(char) and capNextChar) {
            result.append(Character.toUpperCase(char));
            capNextChar = false;
        } else if (char == 0x20 /* ' ' */ or char == 0x3A /* ':' */ or char == 0x5F /* '_' */ or char == 0x2F /* '/' */) {
            if (indexof char > 0) {
                capNextChar = true;
            }
        } else {
            result.append(char);
            capNextChar = false;
        }
    }
    return result.toString();
}

/**
 * Capitalizes the first letter of the passed in String.
 */
public function capitalize(s:String):String {
    if (s.length() == 0) return s;
    def result = StringBuilder{};
    result.append(Character.toUpperCase(s.charAt(0)));
    result.append(s.substring(1));
    result.toString();
}
