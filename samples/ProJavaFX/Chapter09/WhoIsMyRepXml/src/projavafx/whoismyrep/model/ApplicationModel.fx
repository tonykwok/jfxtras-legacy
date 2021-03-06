/*
 * Copyright (c) 2009, Pro JavaFX Authors
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
 * Developed 2009 by Dean Iverson as a JavaFX Script SDK 1.2 example
 * for the Pro JavaFX book.
 */

package projavafx.whoismyrep.model;

import java.io.InputStream;
import javafx.data.pull.Event;
import javafx.data.pull.PullParser;
import javafx.io.http.HttpRequest;

public class ApplicationModel {
  public-read var members: CongressMember[];
  public-read var message: String on replace {
    println( "message: {message}" );
  }

  public var zipcode: String on replace {
    message = "";
    delete members;

    if (zipcode.length() > 0) {
      var url = "http://whoismyrepresentative.com/getall_mems.php?"
                "zip={zipcode}";
      var req: HttpRequest;

      req = HttpRequest {
        method: HttpRequest.GET
        location: url
        onInput: parseResponse
        onDone: function() {
          if (req.responseCode != 200) {
            message = req.responseMessage;
          } else if (sizeof members == 0) {
            message = "No members found for {zipcode}";
          }
        }
        onException: function(ex: java.lang.Exception) {
          println("Exception: {ex.getClass()} {ex.getMessage()}");
        }
      }
      req.start();
    }
  }

  function setMemberProperty( member:CongressMember, name:String, value:String ) {
    if (name == "name") {
      member.name = value;
    } else if (name == "party") {
      member.party = value;
    } else if (name == "state") {
      member.state = value;
    } else if (name == "phone") {
      member.phone = value;
    } else if (name == "office") {
      member.office = value;
    } else if (name == "link") {
      member.website = value;
    } else if (name == "district") {
      member.district = value;
    }
  }

  function parseMemberOfCongress( member:CongressMember, event:Event ) {
    for (qname in event.getAttributeNames()) {
      var value = event.getAttributeValue( qname );
      setMemberProperty( member, qname.name, value );
    }
  }

  function parseResponse( is:InputStream ) {
    try {
      PullParser {
        input: is
        documentType: PullParser.XML;
        onEvent: function( e:Event ) {
          if (e.type == PullParser.START_ELEMENT) {
            if (e.qname.name == "rep") {
              var member = CongressMember {}
              parseMemberOfCongress( member, e );
              insert member into members;
            }
          }
        }
      }.parse();
    } finally {
      is.close();
    }
  }
}
