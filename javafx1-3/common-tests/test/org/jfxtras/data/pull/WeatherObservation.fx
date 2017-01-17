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


import javafx.date.DateTime;

/**
 * @author jclarke
 */

public class WeatherObservation {
    public var clouds: String;
    public var weatherCondition: String;
    public var observation: String;
    public var windDirection: Integer;
    public var ICAO: String;
    public var elevation: Integer;
    public var countryCode: String;
    public var lng: Number;
    public var lat: Number;
    public var temperature: Number;
    public var dewPoint: Number;
    public var windSpeed: Number;
    public var humidity: Number;
    public var stationName: String;
    public var datetime: DateTime;
    public var hectoPascAltimeter: Number;
    public var seaLevelPressure: Number;

    public function toFarenheit(temp: Number) {
        1.8 * temp + 32;
    }


    override function toString(): String {
        "clouds = {clouds},\n"
        "weatherCondition = {weatherCondition},\n"
        "windDirection = {windDirection},\n"
        "ICAO = {ICAO},\n"
        "elevation = {elevation},\n"
        "countryCode = {countryCode},\n"
        "lng = {lng},\n"
        "lat = {lat},\n"
        "temperature = {temperature},\n"
        "temperature F = {toFarenheit(temperature)},\n"
        "dewPoint = {dewPoint},\n"
        "dewPoint F = {toFarenheit(dewPoint)},\n"
        "windSpeed = {windSpeed},\n"
        "humidity = {humidity},\n"
        "stationName = {stationName},\n"
        "datetime = {datetime.impl_toString()},\n"
        "hectoPascAltimeter = {hectoPascAltimeter},\n"
        "seaLevelPressure = {seaLevelPressure},\n"
        "observation = {observation} ";
    }
}
