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

import java.lang.InterruptedException;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.CancellationException;
import java.lang.Object;

/**
 * JavaFXWorker is a SwingWorker equivalent for JavaFX Script to allow execution
 * of asynchronous operations in the background with notification and completion
 * callbacks on the Event Dispatch Thread (EDT).
 * <p>
 * Here is an example that will load an Image and set it to a variable when the
 * load is completed:<blockquote><pre>
 * var currentImage:Image;
 * var worker = JavaFXWorker {
 *     inBackground: function() {
 *         return Image {url: currentFile.toURL().toString(), height: imageHeight};
 *     }
 *     onDone: function(result) {
 *         currentImage = result as Image;
 *     }
 * }
 * </pre></blockquote>
 * <p>
 * Both the inBackground and onDone handlers are required to be set.  Upon initialization
 * the worker will automatically start execution on a background thread and can be
 * later stopped by calling cancel.  Any results of execution in the background thread
 * will be saved to the result var and also passed in to the onDone handler.
 *
 * @profile desktop
 *
 * @author Stephen Chin
 */
public class XWorker {
    var worker:ObjectSwingWorker;

    /**
     * Function that will be executed on a background thread.  If an exception is
     * thrown while executing this function the failed var will be set to true
     * and failedText will be set to the exception message.
     * <p>
     * Since this method is executed asynchronous to other UI operations, it is not
     * safe to make calls that will modify the UI state.  This includes most JavaFX
     * Script library operations.
     */
    public-init protected var inBackground:function():Object;

    /**
     * Function that will be called once inBackground completes.  The result of the
     * background function will be passed in to the result parameter when this function
     * is called.
     * <p>
     * This function is guaranteed to be called on the Event Dispatch thread, and
     * can safely make changes to the UI state.
     */
    public-init protected var onDone:function(result:Object):Void;

    /**
     * Function that will be called if inBackground fails due to an exception.  The
     * exception is passed in as a parameter when this function is called, and the
     * attributes failed and failureText will be set to 'true' and the message of the
     * exception, respectively.
     * <p>
     * This function is guaranteed to be called on the Event Dispatch thread, and
     * can safely make changes to the UI state.
     * <p>
     * This var may be left null if no special handling of exceptions is required.
     */
    public-init protected var onFailure:function(e:ExecutionException):Void;

    /**
     * This var gets set to the result returned by the inBackground method
     * if it is successful, and will also be passed in to the onDone handler.
     */
    public-read var result:Object;

    /**
     * A read-only variable that indicates if this worker has been cancelled
     * by calling the cancel() function. Should be used to break out of any
     * background processing loops so the task ends promptly.
     */
    public-read var cancelled = false;

    /**
     * Allows data to be incrementally processed on the event dispatch thread.
     * This function is safe to call from inBackground, and will pass an
     * aggregated sequence of data to the process method.
     */
    public function publish(data:Object[]):Void {
        worker.publicPublish(data);
    }

    /**
     * This function is called on the event dispatch thread to process incremental
     * data from the publish method. Multiple invocations of publish may occur
     * before this method is called, and the list of data passed in will be the
     * aggregated values from all the publish calls.
     * <p>
     * Since this function is guaranteed to be called on the Event Dispatch thread,
     * you can safely make changes to the UI state.
     */
    public-init protected var process:function(data:Object[]):Void;

    function processProxy(data:Object[]):Void {
        process(data);
    }

    /**
     * Immediately cancels the background thread if it is executing by throwing
     * an interruped exception.
     */
    public function cancel():Void {
        cancelled = true;
        worker.cancel(true);
    }

    init {
        start();
    }

    function start():Void {
        worker = ObjectSwingWorker {
            override function doInBackground():Object {
                return inBackground();
            }

            override function objectProcess(data):Void {
                processProxy(data);
            }

            override function done():Void {
                try {
                    onDone(get());
                } catch (e1:InterruptedException) {
                    // ignore
                } catch (e3:CancellationException) {
                    // ignore
                } catch (e2:ExecutionException) {
                    if (onFailure != null) {
                        onFailure(e2);
                    }
                }
            }
        };
        worker.execute();
    }
}
