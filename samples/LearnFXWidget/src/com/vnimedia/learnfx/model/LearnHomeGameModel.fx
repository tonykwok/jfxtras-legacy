/*
 * LearnHomeGameModel.fx
 *
 *
 * Created on Oct 1, 2009, 2:42:52 PM
 */

package com.vnimedia.learnfx.model;
import javafx.async.JavaTaskBase;
import javafx.async.RunnableFuture;
import javafx.data.feed.rss.*;
import javafx.data.feed.FeedTask;
import javafx.util.Sequences;
import org.jfxtras.saas.twitter.TwitterAPI;
import org.jfxtras.saas.twitter.model.Status;

// Only used if we need to persist the configuration data (e.g. when not
// running as a WidgetFX widget.
import java.io.InputStream;
import java.io.IOException;
import java.io.OutputStream;
import javafx.util.Properties;
import javafx.io.Storage;
import javafx.io.Resource;

/**
 * @author jlweaver
 */
public class LearnHomeGameModel extends JavaTaskBase, TickerHandler {
  /**
   *
   */
  public var courseTwitterScreenName:String = "projavafxcourse";

  /**
   *
   */
  //public var correctAnswerImageUrl:String = "{__DIR__}resources/tick_64.png";
  public var correctAnswerImageUrl:String = "http://www.jmentor.com/LearnFXWidget/images/tick_64.png";

  /**
   *
   */
  //public var incorrectAnswerImageUrl:String = "{__DIR__}resources/delete_64.png";
  public var incorrectAnswerImageUrl:String = "http://www.jmentor.com/LearnFXWidget/images/delete_64.png";

  /**
   *
   */
  //public var unknownAnswerImageUrl:String = "{__DIR__}resources/question_64.png";
  public var unknownAnswerImageUrl:String = "http://www.jmentor.com/LearnFXWidget/images/question_64.png";

  /**
   * Determines whether to play a sound alert when a new question arrives
   */
  public var playNewQuestionAlertSound:Boolean = true;

  /**
   * Determines whether the main app window should alway be on top
   */
  public var alwaysOnTop:Boolean = true;

  public var twitterScreenName:String on replace {
    //println("++++++++++++twitterScreenName is now:{twitterScreenName}");
    if (twitterScreenName != "" and twitterPassword != "") {
      twitterApi = createTwitterAPI(twitterScreenName, twitterPassword, "APITest");
    }
  };
  public var twitterPassword:String on replace {
    if (twitterScreenName != "" and twitterPassword != "") {
      twitterApi = createTwitterAPI(twitterScreenName, twitterPassword, "APITest");
    }
  };;

  /**
   * A reference to the Twitter API created with the student's Twitter screen name
   */
  public var twitterApi = createTwitterAPI(twitterScreenName, twitterPassword, "APITest");

  //Need to be stingy with checkForResponses() calls, because they use the common screen name
  public-read var checkForResponsesRequests:Integer on replace {
    //println("----checkForResponsesRequests:{checkForResponsesRequests}");
  };

  /**
   * A reference to
   */
  var storage:Storage;

  /**
   * Creates a TwitterAPI reference
   */
  function createTwitterAPI(username:String, password:String, clientId:String) {
    //println("Creating TwitterAPI for username:{username}");
    return TwitterAPI {
      username: username
      password: password
      clientId: clientId
      errorHandler: function(code:Integer,description:String){
        //println("In TwitterAPI errorHandler, code:{code}, description:{description}");
      }
    }
  }


  /**
   * A reference to the Twitter API
   * TODO: Pass in the Twitter user name/password, and find out what clientId is for.
   */
//  public def twitterApi2 = TwitterAPI {
//    username: "projavafxcourse"
//    password: "one2three4"
//    clientId: "APITest2"
//    errorHandler: function(code:Integer,description:String){
//        //println("Code2:{code},Description2:{description}");
//    }
//  }

  /**
   * The message ID of the most recent tweet that posed a question
   */
  public var latestQuestionTweetId:Long on replace {
    println("latestQuestionTweetId is now:{latestQuestionTweetId}");
    if (latestQuestionTweetId <= 0) {
      // Compute respondents scores before remomoving responses
      maintainRespondentsScores();
      delete respondents;
    }
  };

  /**
   * The text of most recent tweet that posed a question
   */
  //public var textOfLatestQuestionTweet:String;
  public var textOfLatestQuestionTweet:String = "* Initializing...";

  /**
   * The answer to the most recent tweet that posed a question
   */
  public var answerToLatestQuestionTweet:String;

  /**
   * Indicates whether the latest tweet is a question or an answer
   */
  public var latestQuestionTweetIsQuestion:Boolean = false on replace {
    if (latestQuestionTweetIsQuestion) {
      newQuestionArrived = true;
      //println("latestQuestionTweetIsQuestion is now:{latestQuestionTweetIsQuestion}");
      delete respondents;
    }
  };

  /**
   * Indicates that user needs to be notified about a new question
   */
  public var newQuestionArrived:Boolean on replace {
    //println("model newQuestionArrived is now:{newQuestionArrived}");
  };

  /**
   * The color to which the new question indicator is bound
   * TODO: Even though Color is not set here, perhaps Color should
   *       be removed from the model.
   */
  public var newQuestionIndicationColor:javafx.scene.paint.Color;

  /**
   * Latest known time code
   */
  var latestTimeCode:String;

  /**
   * A sequence containing the responses to the most recent question
   */
  public var respondents:Respondent[];

  /**
   * A sequence containing the scores of the respondents
   */
  public var respondentsScores:RespondentScore[];

  /**
   * Send Twitter response to question
   */
  public function sendResponseTweet(msg:String):Void {
    //println("Sending response tweet, tweetId:{latestQuestionTweetId}");
    twitterApi.statusesReply(latestQuestionTweetId, "@{courseTwitterScreenName} Answering JavaFXpert question http://bit.ly/2dn1kK {latestTimeCode} {msg}", null,
      function(status:Status):Void {
        //println("Id:{status.id},inReplyToStatusId:{status.inReplyToStatusId},Text:{status.text}");
        //Update from Twitter
        onTick();
        checkForResponses();
      });
  }



//  public var twitterSearchTask:RssTask = RssTask {
//    location: "http://twitter.com/statuses/user_timeline/projavafxcourse.rss"
//    interval: 10s
//    onException: function(e) {
//      e.printStackTrace();
//    }
//    onChannel: function(channel) {
//      //println("In onChannel");
//    }
//    onItem: function(item) {
//      //println("In onItem, item.title:{item.title}");
//    }
//    onDone: function() {
//      //println("In onDone");
//      //twitterSearchTask.stop();
//    }
//  };

  init {
    this.start();
    //twitterSearchTask.start();
  }

  /**
   * Gets called automatically when twitterController#start invoked
   */
  override public function create():RunnableFuture {
    new Ticker(this);
  }

  /**
   * Asynchronous callback
   * TODO: Consider requesting a comparator in Status so that it can be easily sorted
   */
  override public function onTick():Void {
    //println("In onTick");
    twitterApi.statusesUserTimeline("projavafxcourse",0,0,0,0,
      function (statuses:Status[]) {
        //println("********Printing specific User********");
        //for (status in statuses) {
        if (sizeof statuses > 0) {
          //println (statuses[0].text);
          //TODO: Consider using a delimiter such as "|"
          def spaceLoc = statuses[0].text.indexOf(" ");
          if (spaceLoc > 0) {
            latestTimeCode = statuses[0].text.substring(0, spaceLoc);
            //Determine whether this is a question or an answer
            if (latestTimeCode.endsWith("a")) {
              //This is an answer
              //latestQuestionTweetIsQuestion = false;
              def lastSpaceLoc = statuses[0].text.trim().lastIndexOf(" ");
              answerToLatestQuestionTweet = statuses[0].text.substring(lastSpaceLoc + 1);
              if (sizeof statuses >= 1) {
                //Get the question tweet corresponding to the answer
                latestQuestionTweetId = statuses[1].id;
                textOfLatestQuestionTweet = statuses[1].text;
              }
              if (latestQuestionTweetIsQuestion) {
                latestQuestionTweetIsQuestion = false;
                checkForResponses();
              }
            }
            else {
              //This is a question
              latestQuestionTweetId = statuses[0].id;
              textOfLatestQuestionTweet = statuses[0].text;
              if (not latestQuestionTweetIsQuestion) {
                latestQuestionTweetIsQuestion = true;
                checkForResponses();
              }
            }
          }
        };
        //println("********End Printing specific User********");
        // This makes sure that responses are check at least once shortly after startup
        //if (checkForResponsesRequests == 0) {
          checkForResponses();
        //}
      });
  }

  public function checkForResponses() {
    if (latestQuestionTweetId > 0) {
      checkForResponsesRequests++;
      //twitterApi.search("{latestTimeCode}", null, null, 0, 0, latestQuestionTweetId, null,
      twitterApi.search("{courseTwitterScreenName}", null, null, 0, 0, 0, null,
        function(statuses:Status[]):Void {
          println("Checking Twitter for responses to question with tweetId: {latestQuestionTweetId}, and {sizeof statuses} were returned ...");
          delete respondents;
          //for (status in statuses) {
          //TODO Weed out any statues that don't have a reply to latestQuestionTweetId
          for (i in [sizeof statuses - 1 .. 0 step -1]) {
            def status = statuses[i];
            //println("status.id:{status.id}, status.sender.screenName:{status.sender.screenName}");
            if (status.id > latestQuestionTweetId and status.sender.screenName != courseTwitterScreenName) {
              // Use this response if the user hasn't responded
              // TODO: Delete this response if it is newer than the one that
              // we already have (which means that they answered more than once).
              def respIndexes = for (resp in respondents where status.sender.screenName == resp.screenName) indexof resp;
              if (sizeof respIndexes == 0) {
                //println (status.text);

                var response = status.text.trim();
                var answer = "";
                var lastSpacePos = response.lastIndexOf(" ");
                if (lastSpacePos >= 0) {
                  answer = response.substring(lastSpacePos).trim();
                  //println("answer:{answer}");
                }
                def correct:Boolean = answer.equalsIgnoreCase(answerToLatestQuestionTweet);
                //println("answer:{answer}, answerToLatestQuestionTweet:{answerToLatestQuestionTweet}, correct:{correct}");

                // Retrieve this user's prior score
                def respScoreIndexes = for (rse in respondentsScores where status.sender.screenName == rse.screenName) indexof rse;
                var priorScore:Integer = 0;
                if (sizeof respScoreIndexes > 0) {
                  priorScore = respondentsScores[respScoreIndexes[0]].score;
                }
                def respondent = Respondent {
                  image: status.sender.profileImageUrl
                  screenName: status.sender.screenName
                  response: answer
                  isCorrect: correct
                  correct: if (latestQuestionTweetIsQuestion) unknownAnswerImageUrl else if (correct) correctAnswerImageUrl else incorrectAnswerImageUrl
                  priorScore: priorScore
                  tweetId: status.id
                };
                insert respondent into respondents;
              }
              else {
                println("Ignoring response id:{status.id} from user:{status.sender.screenName}, text:{status.text}");
              }
            }
          }
          respondents = javafx.util.Sequences.sort(respondents) as Respondent[];
          //println("...finished checking Twitter");
        });
      /*
      twitterApi2.statusesMentions(latestQuestionTweetId, 0, 200, 0,
        function(statuses:Status[]):Void {
          //println("Checking Twitter for responses to question with tweetId: {latestQuestionTweetId}, and {sizeof statuses} were returned ...");
          delete respondents;
          //for (status in statuses) {
          for (i in [sizeof statuses - 1 .. 0 step -1]) {
            def status = statuses[i];
            // Use this response if the user jasn't responded
            // TODO: Delete this response if it is newer than the one that
            // we already have (which means that they answered more than once).
            def respIndexes = for (resp in respondents where status.sender.screenName == resp.screenName) indexof resp;
            if (sizeof respIndexes == 0) {
              //println (status.text);

              var response = status.text.trim();
              var answer = "";
              var lastSpacePos = response.lastIndexOf(" ");
              if (lastSpacePos >= 0) {
                answer = response.substring(lastSpacePos).trim();
                //println("answer:{answer}");
              }
              def correct:Boolean = answer.equalsIgnoreCase(answerToLatestQuestionTweet);
              //println("answer:{answer}, answerToLatestQuestionTweet:{answerToLatestQuestionTweet}, correct:{correct}");

              // Retrieve this user's prior score
              def respScoreIndexes = for (rse in respondentsScores where status.sender.screenName == rse.screenName) indexof rse;
              var priorScore:Integer = 0;
              if (sizeof respScoreIndexes > 0) {
                priorScore = respondentsScores[respScoreIndexes[0]].score;
              }
              def respondent = Respondent {
                image: status.sender.profileImageUrl
                screenName: status.sender.screenName
                response: answer
                isCorrect: correct
                correct: if (latestQuestionTweetIsQuestion) unknownAnswerImageUrl else if (correct) correctAnswerImageUrl else incorrectAnswerImageUrl
                priorScore: priorScore
                tweetId: status.id
              };
              insert respondent into respondents;
            }
            else {
              //println("Ignoring response id:{status.id} from user:{status.sender.screenName}, text:{status.text}");
            }

          }
          respondents = javafx.util.Sequences.sort(respondents) as Respondent[];
          //println("...finished checking Twitter");
        });
      */
    };
  }


  function maintainRespondentsScores():Void {
    for (respondent in respondents) {
      var respScoreIndex:Integer;
      def respScoreIndexes = for (rse in respondentsScores where respondent.screenName == rse.screenName) indexof rse;
      if (sizeof respScoreIndexes == 0) {
        // This respondent doesn't have an entry in the respondentsScores sequence
        def newRespondent = RespondentScore {
          image: respondent.image
          screenName: respondent.screenName
          score: 0
        };
        insert newRespondent into respondentsScores;
        respScoreIndex = sizeof respondentsScores - 1;
      }
      else {
        respScoreIndex = respScoreIndexes[0];
      }

      // Award points
      if (respondent.isCorrect) {
        if (indexof respondent == 0) {
          respondentsScores[respScoreIndex].score += 3;
        }
        else if (indexof respondent == 1) {
          respondentsScores[respScoreIndex].score += 2;
        }
        else {
          respondentsScores[respScoreIndex].score += 1;
        }
      }
      // Cause the respondents sequence to be emptied so that a response isn't
      // awarded points more than once
      latestQuestionTweetId = 0;
      //println("respondentsScores:{respondentsScores}");
    }
  }

  // Only used if we need to persist the configuration data (e.g. when not
  // running as a WidgetFX widget.
  public function saveProperties():Void {
    //println("Storage.list():{Storage.list()}");
    storage = Storage {
      source: "learnfx.properties"
    };
    var resource:Resource = storage.resource;
    var properties:Properties = new Properties();
    properties.put("twitterScreenName", twitterScreenName);
    properties.put("twitterPassword", twitterPassword);
    properties.put("playNewQuestionAlertSound", playNewQuestionAlertSound.toString());
    properties.put("alwaysOnTop", alwaysOnTop.toString());
    try {
      var outputStream:OutputStream = resource.openOutputStream(true);
      properties.store(outputStream);
      outputStream.close();
      //println("properties written");
      //println("-twitterScreenName:{twitterScreenName}, twitterPassword:{twitterPassword}, playNewQuestionAlertSound:{playNewQuestionAlertSound}, alwaysOnTop:{alwaysOnTop}");
    }
    catch (ioe:IOException) {
      //println("IOException in saveProperties:{ioe}");
    }
  }

  public function loadProperties():Void {
    //println("Storage.list():{Storage.list()}");
    storage = Storage {
      source: "learnfx.properties"
    };
    var resource:Resource = storage.resource;
    var properties:Properties = new Properties();
    try {
      var inputStream:InputStream = resource.openInputStream();
      properties.load(inputStream);
      inputStream.close();
      twitterScreenName = properties.get("twitterScreenName");
      twitterPassword = properties.get("twitterPassword");
      if (properties.get("playNewQuestionAlertSound") != null) {
        playNewQuestionAlertSound = properties.get("playNewQuestionAlertSound") == "true";
      }
      if (properties.get("alwaysOnTop") != null) {
        alwaysOnTop = properties.get("alwaysOnTop") == "true";
      }
      //println("properties read");
      //println("-twitterScreenName:{twitterScreenName}, twitterPassword:{twitterPassword}, playNewQuestionAlertSound:{playNewQuestionAlertSound}, alwaysOnTop:{alwaysOnTop}");
    }
    catch (ioe:IOException) {
      //println("IOException in loadProperties:{ioe}");
    }
  }
}
