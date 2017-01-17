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

import javafx.reflect.*;
import javafx.util.Math;

/**
 * Set of common expectations.  This class should be included via a static import.
 *
 * @author Stephen Chin
 * @author Peter Pilgrim
 */
public class Expect {}

/**
 * Asserts that the value passed in to the first parameter meets the expectation
 * passed in as the second parameter, and throws an {@link ExpectationException}
 * if they are not equal.
 */
public function assertThat(value:Object, expects:Expectation):Void {
    expects.check(value);
}

/**
 * Meant to be used in the assume clause of the Test fixture, this is a
 * convenience method to create an assumption with the given actual and
 * expectation.
 */
public function that(actual, expect:Expectation):Assumption {
    Assumption {
        actual: actual
        expect: expect
    }
}

/**
 * An expectation that will always pass.
 */
public function anything():Expectation {
    Expectation {}
}

/**
 * The is expression is syntactic sugar for creating fluent sentences by
 * chaining expectations.  However, in the case where a value is supplied that
 * is not an {@link Expectation}, this method will behave identically to
 * equalTo().
 */
public function is(expected):Expectation {
    Expectation {
        describeAs: bind if (expected instanceof Expectation) "is " else "is equal to \"{expected}\""
        apply: function(actual) {
            if (expected instanceof Expectation) {
                (expected as Expectation).check(actual);
            } else if ((expected != null or actual != null) and not expected.equals(actual)) {
                throw ExpectationException {
                    actual: actual
                }
            }
        }
    }
}

/**
 * The not expression will negate the expectation that is passed in, and is
 * functionally equivalent to expectException, except it can be chained in a
 * series of expectations.  However, in the case where a value is supplied that
 * is not an {@link Expectation}, this method will behave identically to
 * isNot(equalTo(expected)).
 */
public function isNot(expected):Expectation {
    Expectation {
        describeAs: bind if (expected instanceof Expectation) "is not " else "is not equal to \"{expected}\""
        apply: function(actual) {
            if (expected instanceof Expectation) {
                var failed;
                try {
                    (expected as Expectation).check(actual);
                    failed = true;
                } catch (e:ExpectationException) {
                    // pass - we expected an exception
                }
                if (failed) {
                    // fail - we should have gotten an exception
                    throw ExpectationException {
                        actual: actual
                    }
                }
            } else if ((expected == null and actual == null) or expected.equals(actual)) {
                throw ExpectationException {
                    actual: actual
                }
            }
        }
    }
}

/**
 * Expectation that will pass if the actual and expected values pass an equals()
 * test.
 */
public function equalTo(expected):Expectation {
    Expectation {
        describeAs: "equal to \"{expected}\""
        apply: function(actual) {
            if ((expected != null or actual != null) and expected != actual
                    // if both are Numbers, compare equality as doubles (otherwise comparison will fail):
                    // note: the java.lang prefix is needed due to a compiler oddity
                    and (not (expected instanceof java.lang.Number) or not (actual instanceof java.lang.Number) or (expected as Number).doubleValue() != (actual as Number).doubleValue())) {
                throw ExpectationException {
                    actual: actual
                }
            }
        }
    }
}

/** Default tolerance */
def TOLERANCE = 0.0001;

/** Is the actual value close to the expected value with the default tolerance 
 * @param expected the expected value
 */
public function closeTo(expected:Number):Expectation {
    Expectation {
        describeAs: "almost equal to \"{expected}\""
        applyNumber: function(actual) {
            if (Math.abs(expected - actual) > TOLERANCE) {
                throw ExpectationException {
                    actual: actual
                }
            }
        }
    }
}

/**
 * An assertion check for actual (numeric) value is close to the expected 
 * value with the supplied tolerance setting (epsilon).
 * 
 * @param expected the expected value
 * @param tolerance the supplied tolerance
 * @return the expectation 
 *
 * @author Peter Pilgrim
 * @seealso lessThanOrEqualTo
 * @seealso lessThanOrCloseTo
 * @seealso greaterThanOrCloseTo
 * @seealso lessThan
 * @seealso closeTo
 */
public function closeTo(expected, tolerance: Number):Expectation {
    Expectation {
        describeAs: "almost equal to \"{expected}\" with epsilon tolerance \"{tolerance}\""
        applyNumber: function(actual) {
            if (java.lang.Math.abs(expected - actual) > tolerance) {
                throw ExpectationException {
                    actual: actual
                }
            }
        }
    }
}

/**
 * An assertion check for actual (numeric) value is less than the expected 
 * value.
 * 
 * @param expected the expected value
 * @return the expectation 
 *
 * @seealso lessThanOrEqualTo
 * @seealso lessThanOrCloseTo
 * @seealso greaterThanOrCloseTo
 * @seealso greaterThan
 */
public function lessThan(expected):Expectation {
    Expectation {
        describeAs: "less than \"{expected}\""
        applyNumber: function(actual) {
            if (not (actual < expected )) {
                throw ExpectationException {
                    actual: actual
                }
            }
        }
    }
}

/**
 * An assertion check for actual (numeric) value is greater than the expected 
 * value.
 * 
 * @param expected the expected value
 * @return the expectation 
 *
 * @seealso lessThanOrEqualTo
 * @seealso lessThanOrCloseTo
 * @seealso greaterThanOrCloseTo
 */
public function greaterThan(expected):Expectation {
    Expectation {
        describeAs: "greater than \"{expected}\""
        applyNumber: function(actual) {
            if (not (actual > expected)) {
                throw ExpectationException {
                    actual: actual
                }
            }
        }
    }
}

/**
 * An assertion check for actual (numeric) value is less than or close to 
 * the expected value with the supplied tolerance setting (epsilon).
 * 
 * @param expected the expected value
 * @param tolerance the supplied tolerance
 * @return the expectation 
 *
 * @author Peter Pilgrim
 * @seealso lessThanOrEqualTo
 * @seealso greaterThanOrCloseTo
 * @seealso greaterThan
 * @seealso closeTo
 */
public function lessThanOrCloseTo(expected, tolerance: Number):Expectation {
    Expectation {
        describeAs: "less than or close to \"{expected}\" with epsilon tolerance \"{tolerance}\""
        applyNumber: function(actual) {
            if (not (actual <= expected+tolerance)) {
                throw ExpectationException {
                    actual: actual
                }
            }
        }
    }
}

/**
 * An assertion check for actual (numeric) value is greater than or close to 
 * the expected value with the supplied tolerance setting (epsilon).
 * 
 * @param expected the expected value
 * @param tolerance the supplied tolerance
 * @return the expectation 
 *
 * @seealso lessThanOrEqualTo
 * @seealso lessThanOrCloseTo
 * @seealso greaterThanOrCloseTo
 * @seealso greaterThan
 * @seealso lessThan
 * @seealso closeTo
 * @author Peter Pilgrim
 */
public function greaterThanOrCloseTo(expected, tolerance: Number ):Expectation {
    Expectation {
        describeAs: "greater than or close to \"{expected}\" with epsilon tolerance \"{tolerance}\""
        applyNumber: function(actual) {
            if (not (actual >= expected-tolerance)) {
                throw ExpectationException {
                    actual: actual
                }
            }
        }
    }
}

/**
 * An assertion check for actual (numeric) value is less than or equal to 
 * the expected value.
 * 
 * @param expected the expected value
 * @return the expectation 
 *
 * @seealso greaterThanOrEqualTo
 * @seealso greaterThan
 * @seealso lessThan
 */
public function lessThanOrEqualTo(expected):Expectation {
    Expectation {
        describeAs: "less than or equal to \"{expected}\""
        applyNumber: function(actual) {
            if (not (actual <= expected)) {
                throw ExpectationException {
                    actual: actual
                }
            }
        }
    }
}

/**
 * An assertion check for actual (numeric) value is greater than or equal to 
 * the expected value.
 * 
 * @param expected the expected value
 * @return the expectation 
 *
 * @seealso lessThanOrEqualTo
 * @seealso lessThanOrCloseTo
 * @seealso greaterThanOrCloseTo
 */
public function greaterThanOrEqualTo(expected):Expectation {
    Expectation {
        describeAs: "greater than or equal to \"{expected}\""
        applyNumber: function(actual) {
            if (not (actual >= expected)) {
                throw ExpectationException {
                    actual: actual
                }
            }
        }
    }
}


/**
 * Compares the type of the expected object to the FXType that is passed in
 * as the actual value.  As a convenience, the actual value may also be passed
 * in as a String in which case it will be looked up using reflection.
 *
 * @seealso instanceOf(expected)
 */
public function typeIs(expected):Expectation {
    Expectation {
        describeAs: "type is the same as \"{expected}\""
        apply: function(actual) {
            var expectType = if (expected instanceof FXType) expected as FXType else FXContext.getInstance().findClass(expected as String);
            var actualType = FXLocal.getContext().mirrorOf(actual).getType();
            if (not expectType.equals(actualType)) {
                throw ExpectationException {
                    actual: actualType
                }
            }
        }
    }
}

/**
 * Checks if the type of the expected object is an instance of the FXType that
 * is passed in as the actual value.  As a convenience, the actual value may
 * also be passed in as a String in which case it will be looked up using
 * reflection.
 *
 * @seealso typeIs(expected)
 */
public function instanceOf(expected):Expectation {
    Expectation {
        describeAs: "type is instance of \"{expected}\""
        apply: function(actual) {
            var expectType = if (expected instanceof FXType) expected as FXType else FXContext.getInstance().findClass(expected as String);
            var actualType = FXLocal.getContext().mirrorOf(actual).getType();
            if (not expectType.isAssignableFrom(actualType)) {
                throw ExpectationException {
                    actual: actualType
                }
            }
        }
    }
}
