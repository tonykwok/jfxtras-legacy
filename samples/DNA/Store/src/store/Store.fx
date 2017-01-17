/*
 * Copyright (c) 2008-2009, David Armitage
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 * 1. Redistributions of source code must retain the above copyright notice,
 *    this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 * 3. The names of its contributors may not be used
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

package store;

import javafx.io.*;
import java.io.InputStream;
import java.io.OutputStream;
import javafx.util.Properties;
import java.lang.*;
import store.StoreItem.*;
import java.lang.Boolean;
import java.lang.String;
import java.lang.Void;

/**
 A persistence storage helper to ease the creation, storing and reloading of variables and sequences.</p>
 
 @profile desktop/mobile
 @author David Armitage
 */

public class Store 
    {
/**
A name which will be used for this Store in storage
*/
    public-init var name: String = "default";
/**
The sequence of StoreItem that are part of this Store
*/
    public-init var content: StoreItem[];

    var p: Properties = Properties{};
    var storage: Storage;
    var resource: Resource;
    var is: InputStream;
    var os: OutputStream;

    init
      {
      openStore();
      }

function openStore(): Void
      {
      storage = Storage { source: name };
      resource = storage.resource;
      is = resource.openInputStream();
      p.load(is);
      for (s in content)
        {
        s.rebuild(p);
        }
      is.close();
      }

/**
Save this Store to the storage area
*/
    public function save()
      {
      storage = Storage { source: name };
      resource = storage.resource;
      os = resource.openOutputStream(true);
      for (s in content)
        {
        p.put(s.name, "{s.toString()}");
        }
      p.store(os);
      os.close();
      }

/**
Clear this store from storage
*/
    public function clear(): Boolean
      {
      storage.clear();
      }

/**
Clear ALL stores from storage

@return Success or failure flag
*/
    public function clearAll(): Boolean
      {
      storage.clearAll();
      }

/**
List the current Stores and a storage space summary

@return The list of stored files in this storage area (not necessarily all are Stores)
*/
    public function listStores(): String[]
      {
      println("Current stores:");
      storage = Storage { source: name };
      for (i in storage.list())
        {
        println("  {i}");
        }
      println("Available storage: {storage.availableBytes}");
      println("Allotted storage : {storage.totalBytes}");
      println("Used storage     : {storage.totalBytes - storage.availableBytes}");
      storage.list();
      }

/**
List the StorageItems and their values that exist in this Store
*/
    public function listItems(): Void
      {
      println("Items in Store - {name}:");
      for (s in content)
        {
        if (s.isSequence)
          {
          println("-- {s.name}");
          for (i in s.getStringSeq(s.toString()))
            {
            println("   -- {i}");
            }
          }
         else
          {
          println("-- {s.name} -- {s.toString()}")
          }
        }
      }

/**
Reload the currentStore overwriting any changes since last saved
*/
    public function reload(): Void
      {
      openStore();
      }

/**
Reset all the StoreItems in this Store to their default values
*/
    public function resetAll(): Void
      {
      for (s in content)
        {
        s.resetItem();
        }
      }

/**
Rest the named StoreItem to it's default value

@param name The name of the StoreItem to reset
*/
    public function reset(name: String): Void
      {
      for (s in content)
        {
        if (s.name.equalsIgnoreCase(name))
          {
          s.resetItem();
          return;
          }
        }
      }

/**
Get the named item direct from the Store with no interpretation.
Provided to allow direct control over what is stored and retrieved.
This will not be compatible with a named StoreItem.

@param name The name of the item required
@return The string vaue retrieved from this Store
*/
    public function getDirect(name: String): String
      {
      p.get(name);
      }
/**
Set the named item direct with no interpretation.
Provided to allow direct storage of an item. This will not be compatible
with a named StoreItem.

@param name The name to store as
@param value The string value to store
*/
    public function setDirect(name: String, value: String): Void
      {
      p.put(name, value);
      }

    }


