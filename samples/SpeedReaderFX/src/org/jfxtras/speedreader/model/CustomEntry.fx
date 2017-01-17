/*
 * Copyright (c) 2009, JFXtras Group
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
 *
 * Developed 2009 by James L. Weaver with the JFXtras Group
 * to read multiple social network and news feeds, as well
 * as to demonstrate some JFXtras features.
 *
 * CustomItem.fx
 */

package org.jfxtras.speedreader.model;

import java.lang.Exception;
import java.util.Calendar;
import java.util.GregorianCalendar;
//import java.util.SimpleTimeZone;
import javafx.date.DateTime;
import javafx.data.feed.atom.*;
import javafx.data.pull.PullParser;

/**
 * Customize Item so as to override tryParseDate
 *
 * @author Rakesh Menon
 * @author Jim Weaver
 */
public class CustomEntry extends Entry {

  public-read var pubDateText : String;
  public-read var pubDateIfBadFormat:DateTime;

  function parseReallyLongDateTime(dateStr:String): DateTime {
    var dt:DateTime;
    var calDate:GregorianCalendar = new GregorianCalendar();
    if (dateStr.indexOf(",") == 3 and dateStr.length() >= 25) {
      // Guessing format is Mon, 14 Sep 2009 19:29:00 EST
      // TODO: Bulletproof this and cover more cases
      // TODO: Correct the time zone logic
      //var tz:SimpleTimeZone = new SimpleTimeZone(0, text.substring(26, 29));
      //calDate = new GregorianCalendar(tz);
      var month:Integer = "JanFebMarAprMayJunJulAugSepOctNovDec".indexOf(dateStr.substring(8, 11)) / 3;
      calDate.set(Calendar.YEAR, Integer.parseInt(dateStr.substring(12, 16)));
      calDate.set(Calendar.MONTH, month);
      calDate.set(Calendar.DATE, Integer.parseInt(dateStr.substring(5, 7)));
      calDate.set(Calendar.HOUR_OF_DAY, Integer.parseInt(dateStr.substring(17, 19)));
      calDate.set(Calendar.MINUTE, Integer.parseInt(dateStr.substring(20, 22)));
      calDate.set(Calendar.SECOND, Integer.parseInt(dateStr.substring(23, 25)));
    }
    dt = DateTime {
      instant: calDate.getTimeInMillis()
    }
    //println("dt is:{dt}");
    return dt;
  }

    
  override function fromXML(parser: PullParser): Void {
    if (parser.event.qname == PUBLISHED or parser.event.qname == UPDATED) {
      //println("In CustomEntry#fromXML-PUBLISHED: parser.event.text:{parser.event.text}");
      if ((parser.event.type == PullParser.TEXT) or
          (parser.event.type == PullParser.CDATA)) {
          //println("Before stripCDATA pubDateText:{parser.event.text}");
          pubDateText = stripCDATA(parser.event.text);
          //println("After stripCDATA pubDateText:{pubDateText}");
          //pubDateIfBadFormat = parseReallyLongDateTime(pubDateText);
          pubDateIfBadFormat = tryParseDate(pubDateText);
          //println("In CustomEntry#fromXML: pubDateIfBadFormat:{pubDateIfBadFormat}");
      }
    }
    else if(parser.event.qname == TITLE) {
      //println("In CustomEntry#fromXML-TITLE: parser.event.text:{parser.event.text}");
      title = Content {text: stripCDATA(parser.event.text)};
    }
    else if(parser.event.qname == CONTENT) {
      //println("In CustomEntry#fromXML-LOGO: parser.event.text:{parser.event.text}");
      content = Content {text: stripCDATA(parser.event.text)};
    }
    else {
      println("In CustomEntry#fromXML-ELSE: parser.event.qname:{parser.event.qname}, parser.event.text:{parser.event.text}");
      super.fromXML(parser);
    }
  }

  public override function tryParseDate(text:String):DateTime {
    //println("text:{text}");
    var dateTime:DateTime;
    try {
      dateTime = super.tryParseDate(text);
    }
    catch (e:Exception) {
      //println("Error parsing date:{text}")
    }
    if (dateTime == null) {
      //println("Problem parsing date:{text}");
      dateTime = parseReallyLongDateTime(text);
    }
    return dateTime;
  }
}

