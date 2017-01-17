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
package org.jfxtras.lang;

import com.sun.javafx.runtime.FXObject;
import javafx.reflect.FXLocal;
import javafx.reflect.FXObjectValue;
import javafx.reflect.FXVarMember;

def context = FXLocal.getContext();

/**
 * Utility class that can be used to bind to a variable by assignment after initialization.  You need to create a new
 * instance of XBind to accomplish this, but can avoid reconstructing a heavyweight object (such as Node).
 *
@example
class SupportsBind {
    var bindable:XBind
}
var supportsBind = SupportsBind {}
var someVariable;
supportsBind.bindable = XBind {ref: bind someVariable}
@endexample
 * @author Keith Combs
 * @author Stephen Chin
 */
public class XBind {
    /**
     * Value to be bound (see example above)
     */
    public var ref:Object on replace oldValue=newValue {
        if (oldValue != newValue) try {
            for (listener in listeners) {
                listener(oldValue, newValue);
            }
        } catch (e:com.sun.javafx.runtime.AssignToBoundException) {
            // ignore bind errors
        }
    }

    public-init var listeners:(function(oldValue:Object, newValue:Object):Void)[];

    public function addListener(listener:function(oldValue:Object, newValue:Object):Void):Void {
        insert listener into listeners;
    }

    public function removeListener(listener:function(oldValue:Object, newValue:Object):Void):Void {
        delete listener from listeners;
    }
}

/**
 * Convenience function to take a sequence of XBinds and convert it into a sequence of Objects.
 */
public bound function wrap(seq:Object[]):XBind[] {
    return for (xb in seq) XBind {ref: bind xb};
}

/**
 * Convenience function to take a sequence of XBinds and convert it into a sequence of Objects.
 */
public bound function unwrap(seq:XBind[]):Object[] {
    return for (xb in seq) xb.ref;
}

/**
 * Creates an XBind object that is bound to a given FXLocation.  This is a simple way to expose
 * binding to a variable via reflection.
 */
public function bindTo(obj:FXObjectValue, variable:FXVarMember):XBind {
    return XDynamicBind {
        obj: obj
        variable: variable
        withInverse: false
    }
}

/**
 * Creates an XBind object that is bijectively bound to a given FXLocation.  This is a simple way to expose
 * binding to a variable via reflection.
 */
public function bindWithInverse(obj:FXObjectValue, variable:FXVarMember):XBind {
    return XDynamicBind {
        obj: obj
        variable: variable
        withInverse: true
    }
}
