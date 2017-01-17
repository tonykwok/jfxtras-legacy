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

import org.jfxtras.lang.XBind;

/**
 * This class provides a bindable map implementation for JavaFX.  Unlike a standard
 * Java HashMap where you are not able to bind to returned values, XMap lets you
 * bind to values that may not even be inserted yet.  Upon insertion, your binding
 * will get updated, replacing it with the new value automatically.
 * <p>
 * In addition to the binding support, this class is optimized for declarative
 * use with a convenience constructor that takes a sequence of key/value pairs.
 * <p>
@example
def map = XMap {entries: XMap.Entry{key: "default", value: "value"}}
var boundResult = bind map.boundGet("something");
map.put("something", "got it!");
println(boundResult);  // prints the newly inserted value
@endexample
 *
 * @author Stephen Chin
 *
 * bindable sequence support - functions to get keys/entries/values should all return a pure JavaFX sequence that is bindable
 * bound lookups - get should be bindable for updates
 * bound values - it should be possible to bind individual values associated with a key (for insert, but not update)
 * bound construction - there should be a sequence-based constructor that produces a bound map -- changes to the input sequence will directly affect the map contents
 * bound functional operations - map, fold, filter operations that accept functions as parameters and return a bindable result
 * JavaFX map to HashMap conversion - there should be convenience functions for going from one to the other and vice versa
 */
public class XMap {
    def backingMap = IntMap {}
    public-init var entries:Entry[];
    var freeList:Integer[];

    init {
        for (entry in entries) {
            // todo 1.3 - for some reason this blows up with an NPE without an exception block around the put
            // ...must be a code generation issue, probably needs to be filed
            try {
                backingMap.put(entry.key, indexof entry);
            } catch (e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * Adds an element to the map.  If the key already exists it will replace the
     * value, otherwise it will add a new entry.  This may trigger a bind update if
     * someone has retrieved a value using boundGet (even if this is a new entry).
     */
    public function put(key:Object, value:Object):Object {
        def entry = getEntry(key);
        def old = entry.value;
        entry.value = value;
        old;
    }

    /**
     * Gets the full entry for the given key.  The entry includes the key and value,
     * and the contained value can be bound against to get future updates.
     */
    function getEntry(key:Object):Entry {
        var index = backingMap.get(key);
        if (index == null) {
            if (sizeof freeList > 0) {
                index = freeList[sizeof freeList - 1];
                delete freeList[sizeof freeList - 1];
                backingMap.put(key, index);
                def entry = entries[index];
                entries[index].key = key;
                entries[index].value = null;
                entry;
            } else {
                def entry = Entry {key: key, value: null}
                insert entry into entries;
                backingMap.put(key, sizeof entries - 1);
                entry;
            }
        } else {
            entries[index]
        }
    }

    /**
     * Returns the value for a given key.  This function will not automatically update a bind expression
     * when the value is changed in the map.  For this use case see {@link #boundGet(Object)}
     */
    public function get(key:Object):Object {
        def index = backingMap.get(key);
        return if (index == null) null else entries[index].value;
    }

    /**
     * Returns the value for a given key.  This function can be bound and will update automatically
     * when a value with that key is inserted or changed.  If there is no existing record in the table,
     * a placeholder will be created.  This placeholder must be manually removed to free up the memory,
     * so be careful using this function to search the map.  The regular {@link #get(Object)} function is
     * preferable for lookups where no binding is required.
     * <p>
     * Due to some compiler funk, you may need to cast the input parameter to an Object.  For example,
     * you may need to call this function as follows:
     @example
     map.boundGet(key as Object);
     @endexample
     */
    public bound function boundGet(key:Object):Object {
        return getEntry(key).value;
    }

    public function getXBind(key:Object):XBind {
        XBind {
            def entry = getEntry(key);
            ref: bind entry.value with inverse
        }
    }

    public function remove(key:Object):Object {
        def index = backingMap.remove(key);
        return if (index == null) null else {
            def entry = entries[index];
            // todo - add to free list for recycling
            insert index into freeList;
            entry;
        }
    }

    /**
     * Return trueif the map contains the given key
     */
    public function containsKey(key:Object):Boolean {
        def index = backingMap.get(key);
        return index != null and entries[index].value != null;
    }
}

public class Entry {
    public-init var key:Object;
    public var value:Object;
}
