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
public class JSONHandlerTest extends Test {}

var postalCodes: PostalCode[];
var weather: WeatherICAO;
var albumResult: AlbumResult;

def urlPostal = "{__DIR__}postalCodeSearchJSON";
def urlWeather = "{__DIR__}weatherIcaoJSON";
def urlAlbum = "{__DIR__}AlbumJSON";

var postalHandler = JSONHandler {
    rootClass: "org.jfxtras.data.pull.PostalCode[]"
    onSeqDone: function(obj): Void {
        postalCodes = obj as PostalCode[];
    }
}
var postalReq = HttpRequest {
    location: urlPostal
    onInput: function(is: java.io.InputStream) {
        postalHandler.parse(is);
    }
    onException: function(e) {println("error: {e}")}
}

var weatherHandler = JSONHandler {
    rootClass: "org.jfxtras.data.pull.WeatherICAO"
    dateFormat: "yyyy-MM-dd HH:mm:ss z"
    onDone: function(obj, isSequence): Void {
        weather = obj as WeatherICAO;
    }
};
var weatherReq = HttpRequest {
    location: urlWeather
    onInput: function(is: java.io.InputStream) {
        weatherHandler.parse(is);
    }
    onException: function(e) {println("error: {e}")}
};

var albumHandler = JSONHandler {
    rootClass: "org.jfxtras.data.pull.AlbumResult"
    onDone: function(obj, isSequence): Void {
        albumResult = obj as AlbumResult;
    }
};
var albumReq = HttpRequest {
    location: urlAlbum
    onInput: function(is: java.io.InputStream) {
        albumHandler.parse(is);
    }
    onException: function(e) {println("error: {e}")}
};

var time: Long = 1236268260000;

public function run() {
    postalReq.start();
    weatherReq.start();
    albumReq.start();
    Test {
        say: "JSON Handler"
        test: [
            Test {
                say: "Postal Test - "
                waitFor: function() {postalCodes as Object}
                test: [
                    Test {
                        say: "There should be 2 records"
                        do: function() {
                            sizeof postalCodes;
                        }
                        expect: equalTo(2);
                    }
                    Test {
                        say: "Postal Code for second record should be 32795"
                        do: function() {
                            postalCodes[1].postalCode;
                        }
                        expect: equalTo("32795");
                    }
                    Test {
                        say: "Longitude should be -81.22328"
                        do: function() {
                            postalCodes[1].lng;
                        }
                        expect: equalTo(-81.22328);
                    }
                    Test {
                        say: "Latitude should be 28.744752"
                        do: function() {
                            postalCodes[1].lat;
                        }
                        expect: equalTo(28.744752);
                    }
                    Test {
                        say: "AdminName1 should be Florida"
                        do: function() {
                            postalCodes[1].adminName[0];
                        }
                        expect: equalTo("Florida");
                    }
                    Test {
                        say: "PlaceName should be 'Lake Mary'"
                        do: function() {
                            postalCodes[1].placeName;
                        }
                        expect: equalTo("Lake Mary");
                    }
                    Test {
                        say: "Postal Code for first record should be 32746"
                        do: function() {
                            postalCodes[0].postalCode;
                        }
                        expect: equalTo("32746");
                    }
                    Test {
                        say: "Longitude should be -81.350772"
                        do: function() {
                            postalCodes[0].lng;
                        }
                        expect: equalTo(-81.350772);
                    }
                    Test {
                        say: "Latitude should be 28.7577"
                        do: function() {
                            postalCodes[0].lat;
                        }
                        expect: equalTo(28.7577);
                    }
                    Test {
                        say: "AdminName1 should be Florida"
                        do: function() {
                            postalCodes[0].adminName[0];
                        }
                        expect: equalTo("Florida");
                    }
                    Test {
                        say: "PlaceName should be 'Lake Mary'"
                        do: function() {
                            postalCodes[0].placeName;
                        }
                        expect: equalTo("Lake Mary");
                    }
                ]
            }
            Test {
                say: "Weather Test - "
                waitFor: function() {weather}
                test: [
                    Test {
                        say: "ICAO should be 'KLGA'"
                        do: function() {
                            weather.weatherObservation.ICAO;
                        }
                        expect: equalTo("KLGA");
                    }
                    Test {
                         say: "clouds should be 'few clouds'"
                        do: function() {
                            weather.weatherObservation.clouds;
                        }
                        expect: equalTo("few clouds");
                    }
                    Test {
                        say: "weatherCondition should be 'n/a'"
                        do: function() {
                            weather.weatherObservation.weatherCondition;
                        }
                        expect: equalTo("n/a");
                    }
                    Test {
                         say: "observation should be 'KLGA 051551Z 04006KT 10SM FEW250 03/M09 A3048 RMK AO2 SLP319 T00281089'"
                        do: function() {
                            weather.weatherObservation.observation;
                        }
                        expect: equalTo("KLGA 051551Z 04006KT 10SM FEW250 03/M09 A3048 RMK AO2 SLP319 T00281089");
                    }
                    Test {
                         say: "windDirection should be 40"
                        do: function() {
                            weather.weatherObservation.windDirection;
                        }
                        expect: equalTo(40);
                    }
                    Test {
                         say: "elevation should be 11"
                        do: function() {
                            weather.weatherObservation.elevation;
                        }
                        expect: equalTo(11);
                    }
                    Test {
                         say: "countryCode should be 'US'"
                        do: function() {
                            weather.weatherObservation.countryCode;
                        }
                        expect: equalTo("US");
                    }
                    Test {
                         say: "lng should be -73.8833333333333"
                        do: function() {
                            weather.weatherObservation.lng;
                        }
                        expect: equalTo(-73.8833333333333);
                    }
                    Test {
                         say: "lat should be 40.7833333333333"
                        do: function() {
                            weather.weatherObservation.lat;
                        }
                        expect: equalTo(40.7833333333333);
                    }
                    Test {
                         say: "temperature should be 2.8"
                        do: function() {
                            weather.weatherObservation.temperature;
                        }
                        expect: equalTo(2.8);
                    }
                    Test {
                         say: "dewPoint should be -8.9"
                        do: function() {
                            weather.weatherObservation.dewPoint;
                        }
                        expect: equalTo(-8.9);
                    }
                    Test {
                         say: "windSpeed should be 6.0"
                        do: function() {
                            weather.weatherObservation.windSpeed;
                        }
                        expect: equalTo(6.0);
                    }
                    Test {
                         say: "humidity should be 41.0"
                        do: function() {
                            weather.weatherObservation.humidity;
                        }
                        expect: equalTo(41.0);
                    }
                    Test {
                         say: "stationName should be 'New York, La Guardia Airport'"
                        do: function() {
                            weather.weatherObservation.stationName;
                        }
                        expect: equalTo("New York, La Guardia Airport");
                    }
                    Test {
                         say: "datetime should be {time} millis"
                        do: function() {
                            weather.weatherObservation.datetime.instant;
                        }
                        expect: equalTo(time);
                    }
                    Test {
                         say: "hectoPascAltimeter should be 0.0"
                        do: function() {
                            weather.weatherObservation.hectoPascAltimeter;
                        }
                        expect: equalTo(0.0);
                    }
                    Test {
                         say: "seaLevelPressure should be 1031.9"
                        do: function() {
                            weather.weatherObservation.seaLevelPressure;
                        }
                        expect: equalTo(1031.9);
                    }
                ]
            }
            Test {
                say: "Album Test - "
                waitFor: function() {albumResult}
                test: [
                    Test {
                         say: "Album code should be \"/api/status/ok\""
                        do: function() {
                            albumResult.code;
                        }
                        expect: equalTo("/api/status/ok");
                    }
                    Test {
                         say: "Album status should be \"200 OK\""
                        do: function() {
                            albumResult.status;
                        }
                        expect: equalTo("200 OK");
                    }
                    Test {
                         say: "Album transactionId should be \"cache;cache02.p01.sjc1:8101;2009-05-21T18:33:27Z;0010\""
                        do: function() {
                            albumResult.transactionId;
                        }
                        expect: equalTo("cache;cache02.p01.sjc1:8101;2009-05-21T18:33:27Z;0010");
                    }
                    Test {
                         say: "Album result should not null"
                        do: function() {
                            albumResult.result;
                        }
                        expect: isNot(null);
                    }
                    Test {
                         say: "sizeof Album result.commonTopicImage should be 2"
                        do: function() {
                            sizeof albumResult.result.commonTopicImage;
                        }
                        expect: equalTo(2)
                    }
                    Test {
                         say: "result.commonTopicImage[0].id should be \"/wikipedia/images/en_id/1292839\""
                        do: function() {
                            albumResult.result.commonTopicImage[0].id;
                        }
                        expect: equalTo("/wikipedia/images/en_id/1292839")
                    }
                    Test {
                         say: "result.commonTopicImage[1].id should be \"/wikipedia/images/en_id/969104\""
                        do: function() {
                            albumResult.result.commonTopicImage[1].id;
                        }
                        expect: equalTo("/wikipedia/images/en_id/969104")
                    }
                    Test {
                         say: "result.id should be \"/en/bob_seger\""
                        do: function() {
                            albumResult.result.id;
                        }
                        expect: equalTo("/en/bob_seger")
                    }
                    Test {
                         say: "result.name should be \"Bob Seger\""
                        do: function() {
                            albumResult.result.name;
                        }
                        expect: equalTo("Bob Seger")
                    }
                    Test {
                         say: "result.type should be \"/music/artist\""
                        do: function() {
                            albumResult.result.type;
                        }
                        expect: equalTo("/music/artist")
                    }
                    Test {
                         say: "sizeof Album result.musicArtistContribution should be 1"
                        do: function() {
                            sizeof albumResult.result.musicArtistContribution;
                        }
                        expect: equalTo(1)
                    }
                    Test {
                         say: "result.musicArtistContribution[0].id should be \"/guid/9202a8c04000641f800000000394f17c\""
                        do: function() {
                            albumResult.result.musicArtistContribution[0].id;
                        }
                        expect: equalTo("/guid/9202a8c04000641f800000000394f17c")
                    }
                    Test {
                         say: "result.musicArtistContribution[0].album.name should be \"Let It Roll\""
                        do: function() {
                            albumResult.result.musicArtistContribution[0].album.name;
                        }
                        expect: equalTo("Let It Roll")
                    }
                    Test {
                         say: "sizeof result.musicArtistContribution[0].album.commonTopicImage should be 1"
                        do: function() {
                            sizeof albumResult.result.musicArtistContribution[0].album.commonTopicImage;
                        }
                        expect: equalTo(1)
                    }
                    Test {
                         say: "result.musicArtistContribution[0].album.commonTopicImage[0].id should be \"/wikipedia/images/en_id/1043391\""
                        do: function() {
                            albumResult.result.musicArtistContribution[0].album.commonTopicImage[0].id;
                        }
                        expect: equalTo("/wikipedia/images/en_id/1043391")
                    }
                    Test {
                         say: "sizeof result.musicArtistContribution[0].album.track should be 10"
                        do: function() {
                            sizeof albumResult.result.musicArtistContribution[0].album.track;
                        }
                        expect: equalTo(10)
                    }
                    Test {
                         say: "result.musicArtistContribution[0].album.track[0].name should be \"Hate to Lose Your Lovin'\""
                        do: function() {
                            albumResult.result.musicArtistContribution[0].album.track[0].name;
                        }
                        expect: equalTo("Hate to Lose Your Lovin'")
                    }
                    Test {
                         say: "result.musicArtistContribution[0].album.track[0].length should be 262"
                        do: function() {
                            albumResult.result.musicArtistContribution[0].album.track[0].length;
                        }
                        expect: equalTo(262.0)
                    }
                    Test {
                         say: "result.musicArtistContribution[0].album.track[4].name should be \"Let It Roll\""
                        do: function() {
                            albumResult.result.musicArtistContribution[0].album.track[4].name;
                        }
                        expect: equalTo("Let It Roll")
                    }
                    Test {
                         say: "result.musicArtistContribution[0].album.track[4].length should be 270.826"
                        do: function() {
                            albumResult.result.musicArtistContribution[0].album.track[4].length;
                        }
                        expect: equalTo(270.826)
                    }
                    Test {
                         say: "result.musicArtistContribution[0].album.track[9].name should be \"Hangin' on to the Good Times\""
                        do: function() {
                            albumResult.result.musicArtistContribution[0].album.track[9].name;
                        }
                        expect: equalTo("Hangin' on to the Good Times")
                    }
                    Test {
                         say: "result.musicArtistContribution[0].album.track[9].length should be 286.4"
                        do: function() {
                            albumResult.result.musicArtistContribution[0].album.track[9].length;
                        }
                        expect: equalTo(286.4)
                    }
                ]
            }
        ]
    }.perform();
}
