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

import com.sun.javafx.runtime.SystemProperties;
import javafx.io.*;
import javafx.util.Properties;
import java.lang.*;
import java.lang.Boolean;
import java.lang.String;
import java.lang.Void;

/**
 * A persistence storage helper to ease the creation, storing and reloading of variables and sequences.</p>
 *
 * @profile common
 * @author David Armitage
 */
public class XStore {
    /**
     * A name which will be used for this Store in storage
     */
    public-init var name:String = "default";

    /**
     * The sequence of StoreItem that are part of this Store
     */
    public-init var content:XStoreItem[];
    
    var shutdownId = -1;

    /**
     * Will add a shutdown hook to automatically save the store on application close.
     * <p>
     * Setting this to true will prevent garbage collection of this XStore, so if you
     * want to flush this object out of memory make sure to set this back to false.
     */
    public var saveOnExit = false on replace {
        if (saveOnExit) {
            shutdownId = FX.addShutdownAction(save);
        } else if (shutdownId != -1) {
            FX.removeShutdownAction(shutdownId);
            shutdownId = -1;
        }
    }

    var p:Properties;
    def storage:Storage = bind Storage {source: name}

    init {
        if (SystemProperties.getCodebase() == null) {
            SystemProperties.setCodebase("this is a workaround for a codebase initialization bug when running tests");
        }
        openStore();
        for (xsi in content) {
            xsi.onChange = autoSave;
        }
    }

    function openStore():Void {
        def is = storage.resource.openInputStream();
        p = Properties {}
        p.load(is);
        for (s in content) {
            def value = p.get(s.name);
            if (value == null) {
                s.resetItem();
            } else try {
                s.setStringValue(p.get(s.name));
            } catch (e) {
                println("{s.getClass()} error on reading from store:");
                println("    {s.name} received value - {value} - resetting {s.name} to default.");
                e.printStackTrace();
                s.resetItem();
            }
        }
        is.close();
    }

    /**
     * Save this Store to the storage area
     */
    public function save() {
        def os = storage.resource.openOutputStream(true);
        for (s in content) {
            p.put(s.name, "{s.toString()}");
        }
        p.store(os);
        os.close();
    }
    
    function autoSave(changedItem:XStoreItem):Void {
        if (changedItem.autoSave) {
            save();
        }
    }

    /**
     * Clear this store from storage
     */
    public function clear():Boolean {
        storage.clear();
    }

    /**
     * List the StorageItems and their values that exist in this Store
     */
    public function listItems():Void {
        println("Items in Store - {name}:");
        for (s in content) {
            if (s.isSequence) {
                println("-- {s.name}");
                for (i in XStoreItem.split(s.toString())) {
                    println("   -- {i}");
                }
            } else {
                println("-- {s.name} -- {s.toString()}")
            }
        }
    }

    /**
     * Reload the currentStore overwriting any changes since last saved
     */
    public function reload():Void {
        openStore();
    }

    /**
     * Reset all the StoreItems in this Store to their default values
     */
    public function resetAll():Void {
        for (s in content) {
            s.resetItem();
        }
    }

    /**
     * Reset the named StoreItem to it's default value
     *
     * @param name The name of the StoreItem to reset
     */
    public function reset(name:String):Void {
        for (s in content) {
            if (s.name.equalsIgnoreCase(name)) {
                s.resetItem();
                return;
            }
        }
    }

    /**
     * Get the named item direct from the Store with no interpretation.
     * Provided to allow direct control over what is stored and retrieved.
     * This will not be compatible with a named StoreItem.
     *
     * @param name The name of the item required
     * @return The string vaue retrieved from this Store
     */
    public function getDirect(name:String):String {
        p.get(name);
    }

    /**
     * Set the named item direct with no interpretation.
     * Provided to allow direct storage of an item. This will not be compatible
     * with a named StoreItem.
     *
     * @param name The name to store as
     * @param value The string value to store
     */
    public function setDirect(name:String, value:String):Void {
        p.put(name, value);
    }
}

/**
 * Clear ALL stores from storage
 *
 * @return Success or failure flag
 */
public function clearAll():Boolean {
    Storage.clearAll();
}

/**
 * List the current Stores and a storage space summary
 *
 * @return The list of stored files in this storage area (not necessarily all are Stores)
 */
public function listStores():String[] {
    println("Current stores:");
    for (i in Storage.list()) {
        println("  {i}");
    }
    println("Available storage: {Storage.availableBytes}");
    println("Allotted storage : {Storage.totalBytes}");
    println("Used storage     : {Storage.totalBytes - Storage.availableBytes}");
    Storage.list();
}
