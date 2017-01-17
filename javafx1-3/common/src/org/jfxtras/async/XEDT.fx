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

package org.jfxtras.async;

import java.awt.EventQueue;
import java.lang.Exception;
import java.lang.Runnable;
import java.lang.reflect.InvocationTargetException;

import com.sun.javafx.runtime.sequence.ObjectArraySequence;

/**
 * Event dispatch thread helper methods.
 * <p>
 * CAUTION!  JavaFX is designed to run entirely on the Event Dispatch Thread,
 * thus using these methods is highly prone to deadlock.  No guarantee is made
 * to the current or future stability of applications that depend on these
 * methods.
 *
 * @author Stephen Chin
 */
public class XEDT {}

/**
 * Invokes the passed in function on the Event Dispatch Thread, and waits
 * for it to finish executing before returning.  Any object returned by function
 * will be passed through, as will any exceptions that occur during execution.
 * <p>
 * This version expects a function that returns an Object sequence.
 */
public function now(func:function():Object[]):Object[] {
    var result:Object[];
    if (EventQueue.isDispatchThread()) {
        result = func();
    } else try {
        EventQueue.invokeAndWait(Runnable {
            override function run() {
                result = func();
            }
        });
    } catch(e:InvocationTargetException) {
        throw e.getCause();
    }
    result;
}

/**
 * Invokes the passed in function on the Event Dispatch Thread, and waits
 * for it to finish executing before returning.  Any object returned by function
 * will be passed through, as will any exceptions that occur during execution.
 */
public function now(func:function():Object):Object {
    var result:Object;
    if (EventQueue.isDispatchThread()) {
        result = func();
    } else try {
        EventQueue.invokeAndWait(Runnable {
            override function run() {
                result = func();
            }
        });
    } catch(e:InvocationTargetException) {
        throw e.getCause();
    }
    result;
}

/**
 * Invokes the passed in function on the Event Dispatch Thread, and waits
 * for it to finish executing before returning.  Any exceptions that occur
 * during execution will be rethrown.
 */
public function now(func:function():Void):Void {
    if (EventQueue.isDispatchThread()) {
        func();
    } else try {
        EventQueue.invokeAndWait(Runnable {
            override function run() {
                func();
            }
        });
    } catch(e:InvocationTargetException) {
        throw e.getCause();
    }
}

/**
 * Invokes the passed in function on the Event Dispatch Thread at some point
 * in the future.  Control is immediately returned to the calling application.
 * <p>
 * The returned function can be used to later fetch the object resulting from
 * the function call.  If any exceptions were thrown by the function invocation
 * they will also be thrown by invoking the returned function.
 * <p>
 * This version expects a function that returns an Object sequence and returns
 * a DeferredSequence.
 */
public function later(func:function():Object[]):DeferredSequence {
    def deferredSequence = DeferredSequence {}
    EventQueue.invokeLater(Runnable {
        override function run() {
            try {
                deferredSequence.result = func();
            } catch (e:Exception) {
                deferredSequence.exception = e;
            }
        }
    });
    deferredSequence
}

/**
 * Invokes the passed in function on the Event Dispatch Thread at some point
 * in the future.  Control is immediately returned to the calling application.
 * <p>
 * The returned function can be used to later fetch the object resulting from
 * the function call.  If any exceptions were thrown by the function invocation
 * they will also be thrown by invoking the returned function.
 */
public function later(func:function():Object):DeferredObject {
    def deferredObject = DeferredObject {}
    EventQueue.invokeLater(Runnable {
        override function run() {
            try {
                deferredObject.result = func();
            } catch (e:Exception) {
                deferredObject.exception = e;
            }
        }
    });
    deferredObject
}

/**
 * Invokes the passed in function on the Event Dispatch Thread at some point
 * in the future.  Control is immediately returned to the calling application.
 */
public function later(func:function():Void):Void {
    EventQueue.invokeLater(Runnable {
        override function run() {
            func();
        }
    })
}

/**
 * Invokes the passed in function on a separate thread in parallel.  Control
 * is immediately returned to the calling application.
 * <p>
 * The returned function can be used to later fetch the object resulting from
 * the function call.  If any exceptions were thrown by the function invocation
 * they will also be thrown by invoking the returned function.
 * <p>
 * This version expects a function that returns an Object sequence and returns
 * a DeferredSequence.
 */
public function outside(func:function():Object[]):DeferredSequence {
    def deferredSequence = DeferredSequence {}
    XWorker {
        inBackground: func
        onDone: function(r) {
            // I am pretty sure this is bad gumbo...
            def objSeq = r as ObjectArraySequence;
            deferredSequence.result = objSeq.getSlice(0, objSeq.size()) as Object[];
        }
        onFailure: function(e) {
            deferredSequence.exception = e.getCause();
        }
    }
    deferredSequence
}

/**
 * Invokes the passed in function on a separate thread in parallel.  Control
 * is immediately returned to the calling application.
 * <p>
 * The returned function can be used to later fetch the object resulting from
 * the function call.  If any exceptions were thrown by the function invocation
 * they will also be thrown by invoking the returned function.
 */
public function outside(func:function():Object):DeferredObject {
    def deferredObject = DeferredObject {}
    XWorker {
        inBackground: func
        onDone: function(r) {
            deferredObject.result = r;
        }
        onFailure: function(e) {
            deferredObject.exception = e.getCause();
        }
    }
    deferredObject
}

/**
 * Invokes the passed in function on a separate thread in parallel.  Control
 * is immediately returned to the calling application.
 */
public function outside(func:function():Void):Void {
    XWorker {
        inBackground: func
    }
}
