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
package org.jfxtras.test;

import java.lang.*;
import javafx.reflect.*;
import org.jfxtras.async.XEDT;
import org.jfxtras.lang.XException;
import org.jfxtras.lang.XObject;

/**
 * JavaFX Unit Test base class for creating declarative, fluent, behavior-driven
 * tests.  Tests can be run individually by using the perform() method, or
 * executed in larger suites by using a classpath traversing test runner (in-progress).
 * <p>
 * Here is an example of a simple test:
 * <blockquote><pre>
 * import org.jfxtras.test.Expect.*;
 * public BasicTest extends Test {}
 * public function run() {
 *     Test {
 *         say: "Sequences.max should return the maximum value"
 *         do: function() {Sequences.max([3, -1, 4, 0])}
 *         expect: equalTo(4)
 *     }.perform();
 * }
 * </pre></blockquote>
 * <p>
 * For more information about writing tests, please refer to the test examples in
 * the JavaFX source code, or see my blog:
 * <a href="http://steveonjava.com/">http://steveonjava.com/</a>
 *
 * @author Stephen Chin
 * @author Keith Combs
 */
public class Test extends TestBase, XObject {
    /**
     * Verbal requirement for what this test should accomplish.  For nested tests
     * this will be concatenated with whatever the enclosing test says.
     */
    public-init var say:String;

    /**
     * Conditions which must be met for this test to be run.  This is particularly
     * useful for parameterized testing where a large set of tests are
     * setup, but only a limited set are valid scenarios.
     */
    public-init var assume:Assumption[];

    /**
     * Main execution block of the unit test.  This should perform whatever test
     * steps are required, and return a value that can be checked by the expect
     * clause.  Any exceptions thrown in this block will be counted towards a
     * test failure unless they are defined in expectException.
     */
    public-init var do:function():Object;

    /**
     * A condition to wait for before executing the expect block.  This function
     * should return null to continue waiting, or a valid object to continue with
     * the test.  The object returned will be used as the expected value rather
     * than the result of the do block.
     */
    public-init var waitFor:function():Object;

    /**
     * The main form of declarative assertions, this is a list of {@link Expectation}s
     * that if not true will fail the test.  For a full list of built-in expectations,
     * see {@link Expect}.
     */
    public-init var expect:Expectation[];

    /**
     * For tests that are designed to test failure conditions, this can be set
     * to the type of the expected exception.  This method accepts either a
     * typed FXClassType or a String value.  If a String is used, it will be
     * converted to an FXClassType by using reflection.  As a convenience, all built-in
     * exceptions inherit {@link org.jfxtras.lang.JFXObject#getJFXClass()}, which
     * gives you a convenient and type-safe mechanism for fetching an exception.
     */
    public-init var expectException:Object;

    /**
     * A list of subtests that share this test's assume/do/waitFor/cleanup clauses.
     * A common usage of this is to group related tests with an outer test
     * that has no expectations.  In this case the outer test will not get
     * counted towards the results.
     */
    public-init var test:Test[] on replace =newTests {
        for (t in newTests) {
            t.parentTest = this;
        }
    }

    /**
     * Cleanup function called after the test execution has completed.
     * <p>
     * Interesting grammatical fact: cleanup is one word when used as a noun
     * (such as cleanup function) and two words when used as a verb.
     */
    public-init var cleanup:function():Void;

    /**
     * The full name of this test as it will be printed out in the test results.
     */
    public-read var sentence:String = bind lazy if (parentTest == null) say else "{parentTest.sentence} {say}";

    /**
     * The test in which this test is contained.  The result of adding a test to multiple
     * parents is undefined; don't do this!
     */
    public-read var parentTest:Test;

    /**
     * Whether this test will be executed.  To be runnable a test must have an expect or
     * expectException clause.  Tests that have no children are also run.
     */
    public-read var isRunnable = not expect.isEmpty() or expectException != null or test.isEmpty();

    function getRunnableTests():Test[] {
        [
            if (isRunnable) this else [],
            for (t in test) {
                t.getRunnableTests();
            }
        ]
    }

    /**
     * Single test runner action.  This should be called for all tests and
     * will be intelligently disabled if a suite runner is used instead.
     *
     * return The current test instance to facilitate runs of suites
     */
    override function perform() {
        return perform(this);
    }

    /**
     * Returns a textual description for this test
     */
    override function getDescription(context:String) {
        return if (context == null) sentence else "{context} sentence";
    }

    function executeWrapped(execute:function(result:Object):Boolean):Boolean {
        var wrapped = function(r):Boolean {
            try {
                for (assumption in assume) {
                    XEDT.now(assumption.check);
                }
            } catch (e:ExpectationException) {
                return false;
            }
            try {
                var result = XEDT.now(do);
                if (waitFor != null) {
                    while (true) {
                        result = XEDT.now(waitFor);
                        if (result != null and result != "" and result != false and sizeof result > 0) {
                            break;
                        }
                        Thread.sleep(100);
                    }
                }
                return execute(result);
            } finally {
                if (cleanup != null) {
                    XEDT.now(cleanup);
                }
            }
        }
        return if (parentTest == null) {
            wrapped(null);
        } else {
            parentTest.executeWrapped(wrapped);
        }
    }

    override function execute(context:String, callback:TestCallback) {
        var text = if (context == null) sentence else "{context} {sentence}";
        if (not isRunnable) {
            throw XException {message: "Test is not runnable: {text}"}
        }

        callback.testStarted(this, text);
        try {
            var executed = executeWrapped(function(result):Boolean {
                XEDT.now(function() {
                    for (ex in expect) {
                        ex.check(result);
                    }
                });
                return true;
            });
            if (not executed) {
                callback.testSkipped(this, text);
            } else if (expectException != null) {
                callback.testFailure(this, ExpectedException{exception: expectException});
            } else {
                callback.testSuccess(this);
            }
        } catch (e:Throwable) {
            handleException(e, callback, text);
        }
    }

    function handleException(t:Throwable, callback:TestCallback, text:String):Void {
        var exception = if (expectException instanceof String) {
            FXContext.getInstance().findClass(expectException as String);
        } else {
            expectException as FXClassType;
        }
        if (exception.isAssignableFrom(FXLocal.getContext().mirrorOf(t).getClassType())) {
            callback.testSuccess(this);
        } else {
            callback.testFailure(this, t);
        }
    }

    override function toString() {sentence}
}

public function perform(tests:Test[]):TestSet {
    perform(null, tests);
}

public function perform(name:String, tests:Test[]):TestSet {
    var runnable = for (test in tests) test.getRunnableTests();
    if (runIndividual) {
        XEDT.outside(function() {
            var callback = SimpleTestCallback {}
            for (test in runnable) {
                test.execute(name, callback);
            }
            callback.results.print();
            FX.exit();
        });
    }
    return new TestSet(name, runnable as nativearray of Test);
}
