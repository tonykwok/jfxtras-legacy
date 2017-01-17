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
package org.jfxtras.store;

import java.lang.StringBuilder;

/**
 * An item to store in the persistence storage helper class XStore.<p>
 *
 * @profile common
 * @author David Armitage
 */
public abstract class XStoreItem {
    /**
     * The name that this StoreItem will be stored under and referenced by
     */
    public-init var name:String;

    /**
     * A helper to indicate that this StringItem is storing a sequence
     */
    public-read protected var isSequence:Boolean = false;

    /**
     * If set to true, the state of this propery will be persisted whenever the
     * value changes.  The default is false so that unnecessary state persistence
     * is not performed.
     */
    public-init var autoSave:Boolean;

    /**
     * Change listener hook for implementing auto save (should not be called by
     * subclasses).
     */
    package var onChange:function(changedItem:XStoreItem):Void;

    /**
     * Should be implemented by subclasses to provide conversion of values to a common
     * String representation.
     */
    public abstract function getStringValue():String;

    /**
     * Should be implemented by subclasses to provide conversion of values from a common
     * String representation.
     */
    public abstract function setStringValue(value:String):Void;

    /**
     * Should be implemented by suclasses to reset this StoreItem to it's default value
     */
    public abstract function resetItem():Void;

    init {
        resetItem();
    }

    /**
     * Should be called by subclasses whenever the item value changes
     */
    protected function fireOnChange() {
        if (onChange != null) {
            onChange(this);
        }
    }

    override function toString() {
        getStringValue();
    }
}

//---- Utility Functions
def separaterChar:Character = 0x2C /* ',' */;
def escapeChar:Character = 0x5C /* '\' */;

/**
 * Generates a string representation of a sequence of objects.
 * <p>
 * The generated string will use commas as the separater character, and escape
 * any raw commas or backslashes with a preceding backslash.
 *
 * @param seq the sequence that will be converted into a string
 * @param convert conversion function that will be called on each object to get the string representation
 */
public function generateSeqString(seq:Object[], convert:function(:Object):String) {
    var sb = new StringBuilder();
    for (o in seq) {
        if (indexof o != 0) {
            sb.append(separaterChar);
        }
        sb.append(escape(convert(o)));
    }
    return sb.toString();
}

/**
 * Breaks apart the stored string to rebuild it into a sequence of the required class.
 *
 * @param string string that will be split and processed
 * @param parse function that will be called on each of the substrings to create objects
 */
public function parseSeqString(string:String, parse:function(:String):Object):Object[] {
    def stringSeq = split(string);
    for (s in stringSeq) {
        parse(s);
    }
}

package function escape(unescaped:String):String {
    var result = unescaped.replace("\\", "\\\\");
    result = result.replace(",", "\\,");
    return result;
}

package function split(s:String):String[] {
    if (s.length() == 0) return null;
    def chars = s.toCharArray();
    var results:String[];
    def result = StringBuilder{};
    var nextEscaped = false;
    for (char in chars) {
        if (not nextEscaped and char == escapeChar) {
            nextEscaped = true;
        } else if (not nextEscaped and char == separaterChar) {
            insert result.toString() into results;
            result.setLength(0);
        } else {
            result.append(char);
            nextEscaped = false;
        }
    }
    if (result.length() > 0) {
        insert result.toString() into results;
    }
    return results;
}
