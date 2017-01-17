/*
 * Copyright (c) 2008-2009, JFXtras Group
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
package org.jfxtras.jugspinner;

import java.text.SimpleDateFormat;
import java.util.Date;
import javafx.data.pull.PullParser;
import javafx.io.http.HttpRequest;
import javafx.stage.Alert;
import org.jfxtras.data.pull.JSONHandler;
import org.jfxtras.data.pull.XMLHandler;
import org.jfxtras.jugspinner.data.Member;
import org.jfxtras.jugspinner.data.MemberSearch;
import org.jfxtras.jugspinner.data.Attendee;
import org.jfxtras.jugspinner.data.Attendees;
import org.jfxtras.saas.twitter.TwitterAPI;
import org.jfxtras.saas.twitter.model.Status;
import org.jfxtras.util.BrowserUtil;

/**
 * @author Stephen Chin
 */
// note: this API key is for use with the JUGSpinner application only, please do not redistribute
public var apiKey:String = "674c23774778173d75445a7321263731";
public var eventBriteKey:String="ZTYxMDMwNTFlZTc0";
public var eventBriteId:String="466728999";
public var groupId:String;
public var twitterId:String;

public var prizeCountString:String;
public var shouldCountDown = bind prizeCountString != "";
public var prizeCount = bind if (shouldCountDown) Integer.parseInt(prizeCountString) else 0;
public var excludeAnswers:String;

public var loaded:Boolean;
public var fast:Boolean;

public var members:Member[];
public var winners:Member[];

public def jugSpinnerWheel = JUGSpinnerWheel {}
public def winnerDisplay = JUGWinnerDisplay {}

public function processArgs(args:String[]):Void {
    for (arg in args) {
        if (arg.equals("apiKey")) {
            apiKey = args[indexof arg + 1];
        } else if (arg.equals("groupId")) {
            groupId = args[indexof arg + 1];
            loadEvent();
            loaded = true;
        }
    }
}

public function loadEvent():Void {
    def today = new SimpleDateFormat("MMddyyyy").format(new Date());
    def eventQuery = "http://api.meetup.com/events.json/?after={today}&group_id={groupId}&key={apiKey}";
    HttpRequest {
        location: eventQuery
        onInput: function(is) {
            var eventId = PullParser {
                input: is
                documentType: PullParser.JSON
            }.seek("id").forward().event.text;
            loadAttendees(eventId, 0);
        }
    }.start();
}

public function loadAttendees(eventId:String, offset:Integer):Void {
    def rsvpQuery = "http://api.meetup.com/rsvps.json/?event_id={eventId}&page=200&offset={offset}&key={apiKey}";
    println("query = {rsvpQuery}");
    HttpRequest {
        location: rsvpQuery
        onInput: function(is) {
            var memberParser = JSONHandler {
                rootClass: "org.jfxtras.jugspinner.data.MemberSearch"
                onDone: function(obj, isSequence): Void {
                    var results = (obj as MemberSearch).results;
                    insert results[m|(m.response == "yes" or m.response == "maybe") and (excludeAnswers == "" or sizeof m.answers[a|a.contains(excludeAnswers)] == 0)] into members;
                    if (sizeof results == 200) {
                        loadAttendees(eventId, offset + 1);
                    }
                }
            }
            memberParser.parse(is);
        }
    }.start();
}

public function loadEventBriteAttendees() {
    var attendeeQuery = "https://www.eventbrite.com/xml/event_list_attendees?app_key={eventBriteKey}&id={eventBriteId}";
    println("query = {attendeeQuery}");
    HttpRequest {
        location: attendeeQuery
        onInput: function(is) {
            var memberParser = XMLHandler {
                rootPackage: "org.jfxtras.jugspinner.data"
                onDone: function(obj): Void {
                    var results = (obj as Attendees).attendee;
                    println("got this many results: {sizeof results}");
                    insert for (result in results) Member {name: "{result.firstName} {result.lastName}"} into members;
                }
            }
            memberParser.parse(is);
        }
    }.start();
}


var twitterApi:TwitterAPI;

var latestQuestionTweetId:Long on replace {
    println("last question is: {latestQuestionTweetId}");
    twitterApi.search("{twitterId}", null, null, 0, 0, 0, null,
        function(statuses:Status[]):Void {
            for (i in [sizeof statuses - 1 .. 0 step -1]) {
                def status = statuses[i];
                for (member in members) if (member.name == status.sender.screenName) continue;
                if (status.id > latestQuestionTweetId and status.sender.screenName != twitterId) {
                    insert Member {
                        name: status.sender.screenName
                        photoUrl: status.sender.profileImageUrl
                        comment: status.text.trim();
                    } into members;
                }
            }
        }
    );
}

public function loadTweets() {
    twitterApi = TwitterAPI {clientId: twitterId}
    twitterApi.statusesUserTimeline("projavafxcourse",0,0,0,0, function (statuses:Status[]) {
        if (sizeof statuses > 0) {
            def spaceLoc = statuses[0].text.indexOf(" ");
            if (spaceLoc > 0) {
                var latestTimeCode = statuses[0].text.substring(0, spaceLoc);
                // Skip answers
                if (not latestTimeCode.endsWith("a")) {
                    latestQuestionTweetId = statuses[0].id;
                }
            }
        }
    });
}

public function loadManualAttendees(attendees:String[]):Void {
    insert for (attendee in attendees) Member {
        name: attendee
    } into members;
}

public function spin():Void {
    if (shouldCountDown) {
        if (prizeCount == sizeof winners) {
            Alert.inform("Out of Prizes!", "No need to spin the wheel, all "
                         "of your prizes have been awarded!");
            return;
        }
    } else {
        if (sizeof members == sizeof winners) {
            Alert.inform("Congratulations!", "No need to spin the wheel, all "
                         "of your members are winners already!");
            return;
        }
    }
    jugSpinnerWheel.spin(fast);
}

public function pickWinner(newWinner:Integer):Void {
    if (shouldCountDown) {
        members[newWinner].place = prizeCount - sizeof winners;
        insert members[newWinner] before winners[0];
        winnerDisplay.showWinner(0);
    } else {
        members[newWinner].place = sizeof winners + 1;
        insert members[newWinner] into winners;
        winnerDisplay.showWinner(sizeof winners - 1);
    }
}

public function fixWinnerPlaces() {
    if (shouldCountDown) {
        for (winner in winners) {
            winner.place = prizeCount - sizeof winners + indexof winner + 1;
        }
    } else {
        for (winner in winners) {
            winner.place = indexof winner + 1;
        }
    }
}
