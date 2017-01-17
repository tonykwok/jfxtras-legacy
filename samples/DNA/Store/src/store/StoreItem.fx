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

import javafx.util.Properties;

/**
An item to store in the persistence storage helper class Store.<p>

@profile desktop/mobile
@author David Armitage
 */

public abstract class StoreItem
  {
/**
The name that this StoreItem will be stored under and referenced by
*/
  public-init var name: String = "";
/**
A helper to indicate that this StringItem is storing a sequence
*/
  public-read var isSequence: Boolean = false;
/**
Resets this StoreItem to it's default value
*/
  public abstract function resetItem(): Void;
/**
Provides the string representation of the StoreItem variable/sequence as it will be stored
*/
  override public abstract function toString(): String;
/**
Rebuilds a stored item back into the required form
*/
  public abstract function rebuild(p: Properties): Void
  }

public class StoreInteger extends StoreItem
  {
  public-init var default: Integer = 0;
  public      var value:   Integer;

  init
    {
    resetItem();
    }

  override public function toString(): String
    {
    return "{value}";
    }

  override public function rebuild(p: Properties): Void
    {
    if (p.get(name) != null)
      {
      try {
        value = Integer.parseInt(p.get(name));
        }
       catch (NumberFormatException) {
        restoreError("StoreInteger", name, p.get(name));
        resetItem();
        return;
        }
      }
     else
      {
      resetItem();
      }
    }

  override public function resetItem(): Void
    {
    value = default;
    }
  }

public class StoreFloat extends StoreItem
  {
  public-init var default: Float = 0;
  public      var value:   Float;

  init
    {
    resetItem();
    }

  override public function toString(): String
    {
    return "{value}";
    }
    
  override public function rebuild(p: Properties): Void
    {
    if (p.get(name) != null)
      {
      try {
        value = Float.parseFloat(p.get(name));
        }
       catch (NumberFormatException) {
        restoreError("StoreFloat", name, p.get(name));
        resetItem();
        return;
        }
      }
     else
      {
      resetItem();
      }
    }

  override public function resetItem(): Void
    {
    value = default;
    }
  }

public class StoreBoolean extends StoreItem
  {
  public-init var default: Boolean = false;
  public      var value:   Boolean;

  init
    {
    resetItem();
    }

  override public function toString(): String
    {
    return "{value}";
    }

  override public function rebuild(p: Properties): Void
    {
    if (p.get(name) != null)
      {
      value = Boolean.parseBoolean(p.get(name));
      }
     else
      {
      resetItem();
      }
    }

  override public function resetItem(): Void
    {
    value = default;
    }
  }

public class StoreString extends StoreItem
  {
  public-init var default: String = "";
  public      var value:   String;

  init
    {
    resetItem();
    }

  override public function toString(): String
    {
    return "{value}";
    }

  override public function rebuild(p: Properties): Void
    {
    if (p.get(name) != null)
      {
      value = p.get(name);
      }
     else
      {
      resetItem();
      }
    }

  override public function resetItem(): Void
    {
    value = default;
    }
  }

public class StoreDuration extends StoreItem
  {
  public-init var default: Duration = 0s;
  public      var value:   Duration;

  init
    {
    resetItem();
    }

  override public function toString(): String
    {
    var ms = value.toMillis();
    return "{ms}";
    }

  override public function rebuild(p: Properties): Void
    {
    if (p.get(name) != null)
      {
      try {
        value = Duration.valueOf(Double.parseDouble(p.get(name)));
        }
       catch (NumberFormatException) {
        restoreError("StoreDuration", name, p.get(name));
        resetItem();
        return;
        }
      }
     else
      {
      resetItem();
      }
    }

  override public function resetItem(): Void
    {
    value = default;
    }
  }



public class StoreIntegerSeq extends StoreItem
  {
  public-init var default: Integer[] = [];
  public      var value:   Integer[];

  init
    {
    isSequence = true;
    resetItem();
    }

  override public function toString(): String
    {
    var separator = getSeparator(value);
    if (separator == null) then return null;
    var s: String;
    for (i in value)
      {
      s = s.concat(separator).concat("{i}");
      }
    return s;
    }

  override public function rebuild(p: Properties): Void
    {
    var stringSeq = getStringSeq(p.get(name));
    if (stringSeq == null)
      {
      resetItem();
      return;
      }
    delete value;
    for (i in stringSeq)
      {
      try {
        insert Integer.parseInt(i) into value;
        }
       catch (NumberFormatException) {
        restoreError("StoreIntegerSeq", name, i);
        resetItem();
        return;
        }
      }
    }

  override public function resetItem(): Void
    {
    value = default;
    }
  }



public class StoreFloatSeq extends StoreItem
  {
  public-init var default: Float[] = [];
  public      var value:   Float[];

  init
    {
    isSequence = true;
    resetItem();
    }

  override public function toString(): String
    {
    var separator = getSeparator(value);
    if (separator == null) then return null;
    var s: String;
    for (i in value)
      {
      s = s.concat(separator).concat("{i}");
      }
    return s;
    }

  override public function rebuild(p: Properties): Void
    {
    var stringSeq = getStringSeq(p.get(name));
    if (stringSeq == null)
      {
      resetItem();
      return;
      }
    delete value;
    for (i in stringSeq)
      {
      try {
        insert Float.parseFloat(i) into value;
        }
       catch (NumberFormatException) {
        restoreError("StoreFloatSeq", name, i);
        resetItem();
        return;
        }
      }
    }

  override public function resetItem(): Void
    {
    value = default;
    }
  }



public class StoreBooleanSeq extends StoreItem
  {
  public-init var default: Boolean[] = [];
  public      var value:   Boolean[];

  init
    {
    isSequence = true;
    resetItem();
    }

  override public function toString(): String
    {
    var separator = getSeparator(value);
    if (separator == null) then return null;
    var s: String;
    for (i in value)
      {
      s = s.concat(separator).concat("{i}");
      }
    return s;
    }

  override public function rebuild(p: Properties): Void
    {
    var stringSeq = getStringSeq(p.get(name));
    if (stringSeq == null)
      {
      resetItem();
      return;
      }
    delete value;
    for (i in stringSeq)
      {
      insert Boolean.parseBoolean(i) into value;
      }
    }

  override public function resetItem(): Void
    {
    value = default;
    }
  }



public class StoreStringSeq extends StoreItem
  {
  public-init var default: String[] = [];
  public      var value:   String[];

  init
    {
    isSequence = true;
    resetItem();
    }

  override public function toString(): String
    {
    var separator = getSeparator(value);
    if (separator == null) then return null;
    var s: String;
    for (i in value)
      {
      s = s.concat(separator).concat("{i}");
      }
    return s;
    }

  override public function rebuild(p: Properties): Void
    {
    var stringSeq = getStringSeq(p.get(name));
    if (stringSeq == null)
      {
      resetItem();
      return;
      }
    delete value;
    for (i in stringSeq)
      {
      insert i into value;
      }
    }

  override public function resetItem(): Void
    {
    value = default;
    }
  }



public class StoreDurationSeq extends StoreItem
  {
  public-init var default: Duration[] = [];
  public      var value:   Duration[];

  init
    {
    isSequence = true;
    resetItem();
    }

  override public function toString(): String
    {
    var separator = getSeparator(value);
    if (separator == null) then return null;
    var s: String;
    for (i in value)
      {
      var ms = i.toMillis();
      s = s.concat(separator).concat("{ms}");
      }
    return s;
    }

  override public function rebuild(p: Properties): Void
    {
    var stringSeq = getStringSeq(p.get(name));
    if (stringSeq == null)
      {
      resetItem();
      return;
      }
    delete value;
    for (i in stringSeq)
      {
      try {
        insert Duration.valueOf(Double.parseDouble(i)) into value;
        }
       catch (NumberFormatException) {
        restoreError("StoreDurationSeq", name, i);
        resetItem();
        return;
        }
      }
    }

  override public function resetItem(): Void
    {
    value = default;
    }
  }



//---- utility functions
/**
Breaks apart the stored string to rebuild into a sequence of the required class

@param s The stored string
@return A string sequence for onward conversion to the required class
*/
  package function getStringSeq(s: String): String[]
    {
    if (s == null or s == "")
      {
      return null;
      }
    var separator = s.substring(0, 3);
    var stringSeq = s.substring(3).split(separator);
    return stringSeq;
    }
/**
Selection of 12 delimiter strings to use for storing sequences.<p>
The first one found not to exist in the sequence to store will be used.
*/
  def separators = [ "QZX","QXZ","XQZ","XZQ","ZQX","ZXQ","WVB","WBV","BWV","BVW","VBW","VWB" ];

/**
Determines the separator to utilise for this sequence and stores with result as first 3 characters.

@param value The sequence to be stored
@return The first separator found not to exist anywhere in the sequence
*/
  function getSeparator(value: Object): String
    {
    for (separator in separators)
      {
      if (not "{value}".contains(separator)) then return separator;
      }
    println("Store cannot save sequence as contains all separator strings currently available.");
    return null;
    }
/**
General error message
*/
  function restoreError(className: String, storeName: String, value: String): Void
    {
    println("{className} error on reading from store:");
    println("    {storeName} received value - {value} - resetting {storeName} to default.");
    }
