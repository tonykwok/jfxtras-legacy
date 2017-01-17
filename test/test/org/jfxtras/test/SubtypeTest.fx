/*
 * TestSubtype.fx
 *
 * Created on May 10, 2009, 6:34:46 AM
 */

package org.jfxtras.test;

/**
 * @author Steve
 */
public class SubtypeTest extends Test {}

public function run() {
    Test{
        say: "I am a subtype"
    }.perform()
}