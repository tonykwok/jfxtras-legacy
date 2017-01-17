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
package org.jfxtras.data.pull;

import javafx.io.http.HttpRequest;
import org.jfxtras.test.*;
import org.jfxtras.test.Expect.*;

/**
 * @author jclarke
 */
public class XMLHandlerTest extends Test {}

var geoNames: Geonames;

def urlPostal = "{__DIR__}postalCodeSearch.xml";

var postalHandler = XMLHandler {
    rootPackage: "org.jfxtras.data.pull"
    getVariableName: function(context: String, rawName:String) : String  {
        if (rawName == "postalcode" ) {
            "postalCode";
        } else if(rawName == "name") {
            "placeName";
        } else {
            rawName;
        }
    }
    onDone: function(obj): Void {
        geoNames = obj as Geonames;
    }
}
var req = HttpRequest {
    location: urlPostal
    onInput: function(is: java.io.InputStream) {
        postalHandler.parse(is);
    }
    onException: function(e) {println("error: {e}")}
}

var time: Long = 1236268260000;

public function run() {
    req.start();
    Test {
        say: "XML Handler Tests"
        waitFor: function() {geoNames}
        test: [
            // Postal TEST
            Test {
                say: "There should be 2 results"
                do: function() {
                    geoNames.totalResultsCount;
                }
                expect: equalTo(2);
            }
            Test {
                say: "There should be 2 codes"
                do: function() {
                    sizeof geoNames.code;
                }
                expect: equalTo(2);
            }
            Test {
                say: "Postal Code for second record should be 32795"
                do: function() {
                    geoNames.code[1].postalCode;
                }
                expect: equalTo("32795");
            }
            Test {
                say: "Longitude should be -81.22328"
                do: function() {
                    geoNames.code[1].lng;
                }
                expect: equalTo(-81.22328);
            }
            Test {
                say: "Latitude should be 28.744752"
                do: function() {
                    geoNames.code[1].lat;
                }
                expect: equalTo(28.744752);
            }
            Test {
                say: "AdminName1 should be Florida"
                do: function() {
                    geoNames.code[1].adminName[0];
                }
                expect: equalTo("Florida");
            }
            Test {
                say: "PlaceName should be 'Lake Mary'"
                do: function() {
                    geoNames.code[1].placeName;
                }
                expect: equalTo("Lake Mary");
            }
            Test {
                say: "Postal Code for first record should be 32746"
                do: function() {
                    geoNames.code[0].postalCode;
                }
                expect: equalTo("32746");
            }
            Test {
                say: "Longitude should be -81.350772"
                do: function() {
                    geoNames.code[0].lng;
                }
                expect: equalTo(-81.350772);
            }
            Test {
                say: "Latitude should be 28.7577"
                do: function() {
                    geoNames.code[0].lat;
                }
                expect: equalTo(28.7577);
            }
            Test {
                say: "AdminName1 should be Florida"
                do: function() {
                    geoNames.code[0].adminName[0];
                }
                expect: equalTo("Florida");
            }
            Test {
                say: "PlaceName should be 'Lake Mary'"
                do: function() {
                    geoNames.code[0].placeName;
                }
                expect: equalTo("Lake Mary");
            }
            Test {
                say: "PostalReference 1 should have an id of 839302938420"
                do: function() {
                    geoNames.code[0].postalReference.id;
                }
                expect: equalTo(839302938420);
            }
            Test {
                say: "PostalReference 1 should have a type of 'UPC'"
                do: function() {
                    geoNames.code[0].postalReference.type;
                }
                expect: equalTo("UPC");
            }
            Test {
                say: "PostalReference 2 should have an id of 18293049382732"
                do: function() {
                    geoNames.code[1].postalReference.id;
                }
                expect: equalTo(18293049382732);
            }
            Test {
                say: "PostalReference 2 should have a type of 'GTIN'"
                do: function() {
                    geoNames.code[1].postalReference.type;
                }
                expect: equalTo("GTIN");
            }
        ]
    }.perform();
}
