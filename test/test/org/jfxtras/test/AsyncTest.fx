/*
 * TestAsync.fx
 *
 * Created on Jul 28, 2009, 2:05:46 AM
 */

package org.jfxtras.test;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import javafx.io.http.HttpRequest;
import org.jfxtras.test.Expect.*;

import javafx.scene.shape.Rectangle;
import org.jfxtras.async.XWorker;

import com.sun.javafx.runtime.sequence.ObjectArraySequence;

import javafx.animation.Timeline;

/**
 * @author Stephen Chin
 */
public class AsyncTest extends Test {}

function run() {
    perform("Asynchronous tests", [
        Test {
            var result:String;
            say: "should work with HttpRequests"
            do: function() {
                HttpRequest {
                    location: "http://whoismyrepresentative.com/whoismyrep.php?zip=62246&output=json"
                    onInput: function(input:InputStream) {
                        var buf = new BufferedReader(new InputStreamReader(input));
                        var line:String;
                        while ((line = buf.readLine()) != null) {
                            result += line;
                        }
                        buf.close();
                    }
                    onException: function(e) {
                        result = "{e.getClass().getName()}: {e.getMessage()}";
                    }
                }.start();
                null
            }
            waitFor: function() {result}
            expect: equalTo('\{ "results": [\{"name": "John Shimkus", "state": "IL", "district": "19", "phone": "(202) 225-5271", "office": "2452 Rayburn", "link": "http://www.house.gov/shimkus/" \}]\}')
        }
        Test {
            var rectangles = [Rectangle{}, Rectangle{}];
            var asyncCreatedRects: Rectangle[];
            say: "should work with XWorker"
            do: function() {
                XWorker {
                    inBackground: function() {
                        return rectangles as Object;
                    }
                    onDone: function(result) {
                        // I am pretty sure this is bad gumbo...
                        var r = result as ObjectArraySequence;
                        asyncCreatedRects = r.getSlice(0, r.size()) as Rectangle[];
                    }
                }
            }
            waitFor: function() {asyncCreatedRects as Object}
            expect: equalTo(rectangles)
        }
        Test {
            var initialFalse = false;
            say: "should block"
            do: function() {
                Timeline {
                    keyFrames: at (1s) {initialFalse => true}
                }.play();
                return null;
            }
            waitFor: function() {initialFalse}
            test: [
                Test {
                    say: "subtests"
                    do: function() {initialFalse}
                    expect: equalTo(true)
                }
            ]
        }
    ]);
}
