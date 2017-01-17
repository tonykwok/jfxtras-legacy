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
 * FeedTableModel.fx
 *
 * TODO: Implement Engadget feeds after date problem is rectified (file JIRA?)
 * http://www.engadget.com/rss.xml
 * http://www.engadget.com/tag/video/rss.xml
 */
package org.jfxtras.feedtable.model;
import javafx.data.feed.rss.*;
import javafx.data.feed.atom.*;
import javafx.data.feed.FeedTask;
import javafxyt.YTDataTask;
import javafxyt.model.*;

import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.InputStream;
import java.io.IOException;
import java.io.OutputStream;
import javafx.data.pull.Event;
import javafx.data.pull.PullParser;
import javafx.io.Storage;
import javafx.io.Resource;
import javafx.io.http.HttpRequest;

function replaceEntities(content:String):String {
  var retStr = content;
  retStr = retStr.replaceAll("&lt;", "<");
  retStr = retStr.replaceAll("&gt;", ">");
  retStr = retStr.replaceAll("&quot;", "\"");
  retStr = retStr.replaceAll("&amp;", "&");
  retStr = retStr.replaceAll("&#039;", "'");
  retStr = retStr.replaceAll("&#39;", "'");
  retStr = retStr.replaceAll("<!\\[CDATA\\[", "");
  retStr = retStr.replaceAll("\\]\\]>", "");
  return retStr;
}

function scrapeImageUrl(inContent:String):String {
  def startSrc = "src=";
  def endSrc = "\"";
  def jpgExt = ".jpg";
  def pngExt = ".png";
  def gifExt = ".gif";

  var begPos = 0;
  var endPos = 0;
  var retStr:String;

  // Remove entites
  var content = replaceEntities(inContent);

  // See if there is an img src tag
  begPos = content.indexOf(startSrc) + startSrc.length() + 1;
  if (begPos >= 0) {
    ("There is an img src tag, begPos:{begPos}, content:{content}");

    // Find a JPG extension //TODO: Add checks for capitalized versions of graphic extensions
    endPos = content.indexOf(jpgExt, begPos);
    if (endPos >= begPos) {
      retStr = content.substring(begPos, endPos + jpgExt.length());
      return retStr;
    }

    // Find a PNG extension
    endPos = content.indexOf(pngExt, begPos);
    if (endPos >= begPos) {
      retStr = content.substring(begPos, endPos + pngExt.length());
      return retStr;
    }

    // Find a GIF extension
    endPos = content.indexOf(gifExt, begPos);
    if (endPos >= begPos) {
      retStr = content.substring(begPos, endPos + gifExt.length());
      return retStr;
    }

    // Find the end of the img src tag
    endPos = content.indexOf(endSrc, begPos);
    if (endPos >= begPos) {
      retStr = content.substring(begPos, endPos);
      return retStr;
    }
  }
  return retStr;
}

/**
 * Main model class for the SpeedReaderFX application
 *
 * @author Jim Weaver
 */
public class FeedTableModel {
  var feedTask:FeedTask; //TODO: Move to a function?
  //var feedLogo:String;

  public var showCriteria:Boolean = false;

  public var twitPicNames:String[] = ["",
                                      "",
                                      "",
                                      "",
                                      "",
                                      ""];

  public var tweeTubeNames:String[] = ["",
                                       "",
                                       "",
                                       "",
                                       "",
                                       ""];

  public var twitterNames:String[] = ["javafxpert",
                                      "steveonjava",
                                      "",
                                      "",
                                      "",
                                      ""];

  public var flickrTags:String[] = ["australia,sunrise",
                                   "",
                                   "",
                                   "",
                                   "",
                                   ""];

  public var deliciousTags:String[] = ["",
                                       "",
                                       "",
                                       "",
                                       "",
                                       ""];

  public var youTubeTags:String[] = ["",
                                     "",
                                     "",
                                     "",
                                     "",
                                     ""];

  public var yahooNewsTopics:String[] = ["topstories",
                                          "world",
                                          "us",
                                          "business",
                                          "tech",
                                          "sports",
                                          "entertainment",
                                          "health",
                                          "oddlyenough",
                                          "science"];

  public var yahooNewsTopicsSelected:Boolean[] =
    [true, false, false, false, false, false, false, false, false, false];

  // MSNBC video feed info
  public var msnbcTopicIds:String[] = ["21426262", // US news
                                        "21426473", // World news
                                        "18424694", // Business
                                        "18424734", // Politics
                                        "18424692", // Entertainment
                                        "21427299", // Health
                                        "21426493", // Sports
                                        "18424747", // Tech/science
                                        "21427411"]; // Travel

  public var msnbcTopicNames:String[] = ["US news", // US news
                                        "World news", // World news
                                        "Business", // Business
                                        "Politics", // Politics
                                        "Entertainment", // Entertainment
                                        "Health", // Health
                                        "Sports", // Sports
                                        "Tech/science", // Tech/science
                                        "Travel"]; // Travel

  public var msnbcTopicsSelected:Boolean[] =
    [false, false, false, false, false, false, false, true, false];



  /**************** FeedInfo instances ******************/

  /**
   * The FeedInfo instances for Flickr feed
   */
  public var twitPicFeedInfo = for (twitPicName in twitPicNames) {
    FeedInfo {
      model: this
      type: "TwitPic"
      //url: "http://twitpic.com/photos/{twitPicName}/feed.rss"
      urla: "http://twitpic.com/photos/"
      urlb: "/feed.rss"
      argument: twitPicName
      isAtom: false
      isSelected: twitPicName != ""
    }
  };

  /**
   * The FeedInfo instances for TweeTube feed
   */
  public var tweeTubeFeedInfo = for (tweeTubeName in tweeTubeNames) {
    FeedInfo {
      model: this
      type: "TweeTube"
      //url: "http://www.tweetube.com/users/{tweeTubeName}.rss"
      urla: "http://www.tweetube.com/users/"
      urlb: ".rss"
      argument: tweeTubeName
      isAtom: false
      isSelected: tweeTubeName != ""
    }
  };

  /**
   * The FeedInfo instances for TweeTube feed
   */
  public var twitterFeedInfo = for (twitterName in twitterNames) {
    FeedInfo {
      model: this
      type: "Twitter"
      //url: "http://twitter.com/statuses/user_timeline/{twitterName}.rss"
      urla: "http://twitter.com/statuses/user_timeline/"
      urlb: ".rss"
      argument: twitterName
      isAtom: false
      isSelected: twitterName != ""
    }
  };

  /**
   * The FeedInfo instances for Flickr feed
   */
  public var flickrFeedInfo = for (flickrTag in flickrTags) {
    FeedInfo {
      model: this
      type: "Flickr"
      //url: "http://api.flickr.com/services/feeds/photos_public.gne?tags={flickrTag}"
      urla: "http://api.flickr.com/services/feeds/photos_public.gne?tags="
      urlb: ""
      argument: flickrTag
      isAtom: true
      isSelected: flickrTag != ""
    }
  };

  /**
   * The FeedInfo instances for delicious feeds
   * TODO: Offer delicious "popular" feed as well:
   * http://feeds.delicious.com/v2/rss/?count=20
   * TODO: Allow user to choose # of results
   */
  public var deliciousFeedInfo = for (deliciousTag in deliciousTags) {
    FeedInfo {
      model: this
      type: "Delicious"
      //url: "http://feeds.delicious.com/v2/rss/tag/javafx?count=20"
      urla: "http://feeds.delicious.com/v2/rss/tag/"
      urlb: "?count=10"
      argument: deliciousTag
      isAtom: false
      isSelected: deliciousTag != ""
    }
  };

  /**
   * The FeedInfo instances for YouTube searches
   */
  public var youTubeFeedInfo = for (youTubeTag in youTubeTags) {
    FeedInfo {
      model: this
      type: "YouTube"
      youTubeTag: youTubeTag
      isAtom: false
      isSelected: youTubeTag != ""
    }
  };

  /**
   * The FeedInfo instances for Yahoo News categories
   */
  public var yahooFeedInfo = for (yahooNewsTopic in yahooNewsTopics) {
    FeedInfo {
      model: this
      type: "Yahoo"
      //url: "http://rss.news.yahoo.com/rss/{yahooNewsFeed}"
      urla: "http://rss.news.yahoo.com/rss/"
      urlb: ""
      argument: yahooNewsTopic
      isAtom: false
      isSelected: yahooNewsTopicsSelected[indexof yahooNewsTopic]
    }
  };

  /**
   * The FeedInfo instances for MSNBC News categories
   */
  public var msnbcFeedInfo = for (msnbcTopicId in msnbcTopicIds) {
    FeedInfo {
      model: this
      type: "MSNBC"
      //url: "http://pheedo.msnbc.msn.com/id/{msnbcTopicId}/device/rss/"
      urla: "http://pheedo.msnbc.msn.com/id/"
      urlb: "/device/rss/"
      argument: msnbcTopicId
      isAtom: false
      isSelected: msnbcTopicsSelected[indexof msnbcTopicId]
    }
  };

  /**
   * The FeedInfo instances for miscellaneous feed
   */
  public var otherFeedInfo = [
    FeedInfo {
      model: this
      type: "Blog"
      urla: "http://blogs.sun.com/rakeshmenonp/en_US/feed/entries/atom"
      isAtom: true
      isSelected: false
    },
    FeedInfo {
      model: this
      type: "Blog"
      urla: "http://www.weiqigao.com/blog/atom.xml"
      isAtom: true
      isSelected: false
    },
    FeedInfo {
      model: this
      type: "Blog"
      urla: "http://steveonjava.com/feed/"
      isAtom: false
      isSelected: false
    },
    FeedInfo {
      model: this
      type: "Blog"
      urla: "http://pleasingsoftware.blogspot.com/feeds/posts/default"
      isAtom: true
      isSelected: false
    },
    FeedInfo {
      model: this
      type: "Blog"
      urla: "http://feeds.feedburner.com/JamesWeaversJavafxBlog"
      isAtom: true
      isSelected: false
    },
    FeedInfo {
      model: this
      type: "Misc"
      urla: "http://feeds.dilbert.com/DilbertDailyStrip"
      isAtom: false
      isSelected: false
    }
    FeedInfo {
      model: this
      type: "Misc"
      urla: ""
      isAtom: true
      isSelected: false
    },
  ];

  /** 
   * Sequence of feeds to request items from
   * Note: Here is a list of feed examples that work with this program so far:
   */

  public var feedsToRead:FeedInfo[] = bind [
    twitPicFeedInfo,
    tweeTubeFeedInfo,
    twitterFeedInfo,
    flickrFeedInfo,
    deliciousFeedInfo,
    youTubeFeedInfo,
    yahooFeedInfo,
    msnbcFeedInfo,
    otherFeedInfo
  ];

  public var feedTableItems:FeedTableItem[];

  /**
   * The index of the currently selected iten in the feedTableItems sequence
   * TODO: Protect te integrity of this when the Table contents are filtered
   *       (e.g. with hideRowsWithNoImages
   */
  public var selectedFeedTableItemIndex:Integer on replace {
    //TOOD: Consider using bind in the selectedFeedTableItem instead
    if (selectedFeedTableItemIndex >= 0) {
      selectedFeedTableItem = feedTableItems[selectedFeedTableItemIndex];
    }
  };

  /**
   * The currently selected FeedTableItem
   * TODO: Protect te integrity of this when the Table contents are filtered
   *       (e.g. with hideRowsWithNoImages
   */
  public var selectedFeedTableItem:FeedTableItem;

  public var hideRowsWithNoImage:Boolean = false;
  public var updateFromFeedsOnDirty:Boolean = true;

  /**
   * Largest number of tasks running at a time in the current request.  Is
   * used in conjunction with numTasksRunning to calculate percentage complete.
   */
  public var numTasksRunningHighWatermark:Number;
  
  /**
   * Number of tasks currently running
   */
  public var numTasksRunning:Number = 0 on replace {
    //println("numTasksRunning:{numTasksRunning}");
    if (numTasksRunning > numTasksRunningHighWatermark) {
      numTasksRunningHighWatermark = numTasksRunning;
    }
    if (numTasksRunning <= 0) {
      sortFeedItemsByDate();
      numTasksRunning = 0;
      numTasksRunningHighWatermark = 0;
    }
  };

  public function startFeedTasks():Void {
    numTasksRunning = 0;

    for (feedToRead in feedsToRead where feedToRead.getDirty()) {
      feedToRead.setDirty(false);
      // Delete feedTableItem entries for this feed
      feedToRead.deleteFeedTableItems();
      // Only read feeds that are selected
      if (feedToRead.getSelected()) {
        if (feedToRead.url != "") {
          if (feedToRead.isAtom) {
            feedTask = AtomTask {
              location: feedToRead.url
              interval: 1000m
              onException: function(e) {
                numTasksRunning--;
                e.printStackTrace();
              }
              onFeed: function(feed) {
                if (feed.logo.uri != "") {
                  feedToRead.feedLogo = feed.logo.uri;
                }
                else {
                  feedToRead.feedLogo = replaceEntities(feed.title.text);
                }
              }
              onEntry: function(item) {
                def date = new java.util.Date(item.published.datetime.instant);
                def feedTableItem = FeedTableItem {
                  feedTitle: feedToRead.feedLogo
                  image: scrapeImageUrl("{item.content.text} {item.title.text}");
                  title: "{replaceEntities(item.title.text)}"
                  published: "{%tF date} {%tR date}"
                  link: "{replaceEntities(item.links[0].href)}"
                  feedInfo: feedToRead
                };
                insert feedTableItem into feedTableItems;
              }
              onDone: function() {
                numTasksRunning--;
                feedTask.stop();
              }
            };
          }
          else {
            feedTask = RssTask {
              location: feedToRead.url
              interval: 1000m
              onException: function(e) {
                numTasksRunning--;
                e.printStackTrace();
              }
              onChannel: function(channel) {
                def twitterTitleStart = "Twitter / ";
                def tweetTubeTitleStart = "Tweetube.com - ";
                if (channel.link.startsWith("http://twitpic.com")) {
                  //This is a Twitpic.com feed, so use the user's Twitter
                  //picture as the feed logo
                  retrieveTwitterProfilePicture(channel.link.substring(channel.link.lastIndexOf("/") + 1), feedToRead);
                  return;
                }
                if (channel.title.startsWith(tweetTubeTitleStart)) {
                  //This is a Tweetube.com feed, so use the user's picture as the
                  //feed logo
                  def username = channel.title.substring(tweetTubeTitleStart.length(),
                                                               channel.title.indexOf("'"));
                  retrieveTwitterProfilePicture(username, feedToRead);
                  return;
                }
                if (channel.image.url != "") {
                  feedToRead.feedLogo = channel.image.url;
                  //println("feed logo:{channel.image.url}");
                  return;
                }

                feedToRead.feedLogo = replaceEntities(channel.title);
                if (feedToRead.feedLogo.startsWith(twitterTitleStart)) {
                  //This is a Twitter feed, so use the user's picture as the
                  //feed logo
                  feedToRead.isTwitter = true;
                  retrieveTwitterProfilePicture(feedToRead.feedLogo.substring(twitterTitleStart.length()), feedToRead);
                  return;
                }
              }
              onItem: function(item) {
                def date = new java.util.Date(item.pubDate.instant);
                def feedTableItem = FeedTableItem {
                  feedTitle: feedToRead.feedLogo
                  image: scrapeImageUrl("{item.description} {item.title}");
                  title: "{replaceEntities(item.title)}"
                  published: "{%tF date} {%tR date}"
                  link: "{replaceEntities(item.link)}"
                  feedInfo: feedToRead
                };
                insert feedTableItem into feedTableItems;
              }
              onDone: function() {
                numTasksRunning--;
                feedTask.stop();
              }
            };
          }
          feedTask.start();
          numTasksRunning++;
        }
        else if (feedToRead.youTubeTag.trim() != "") {
          def ytDataTask : YTDataTask = YTDataTask {
            maxResults: 20
            tag: feedToRead.youTubeTag
            interval: 1000m
            onException: function(e) {
              numTasksRunning--;
              e.printStackTrace();
            }
            onDone: function(videos : Video[]) {
              numTasksRunning--;
              var dateStr:String;
              for (video in videos) {
                if (video.uploaded.length() >= "YYYY-MM-DD HH:MM".length()) {
                  //TODO: Parse date instead so that the time zone is local
                  dateStr = "{video.uploaded.substring(0, 10)} {video.uploaded.substring(11, 16)}";
                }
                insert FeedTableItem {
                  feedTitle: "http://code.google.com/apis/youtube/images/logo.gif"
                  image: video.thumbnail[0].url
                  title: "{video.title}\nKeywords: {video.keywords}"
                  published: dateStr
                  link: "http://www.youtube.com/watch?v={video.videoid}"
                  feedInfo: feedToRead
                } into feedTableItems;
              }
              ytDataTask.stop();
            }
          };
          ytDataTask.start();
          numTasksRunning++;
        }
        else {
          println("Feed not processed");
        }
      }
    }
  }

  public function sortFeedItemsByDate():Void {
    feedTableItems = javafx.util.Sequences.sort(feedTableItems) as FeedTableItem[];
  }

  /**
   * Marks all feeds dirty, but inhibits the feeds from being updated,
   * regardless of the updateFromFeedsOnDirty flag. Therefore, collers of
   * this function need to refresh the feeds (by calling startFeedTasks).
   */
  public function markAllFeedsDirty() {
    def tempUpdateFromFeedsOnDirty = updateFromFeedsOnDirty;
    updateFromFeedsOnDirty = false;
    for (feedToRead in feedsToRead) {
      feedToRead.setDirty(true);
    }
    updateFromFeedsOnDirty = tempUpdateFromFeedsOnDirty;
  }

  /**
   * Sets the selected state of all feeds of a given type to false.  This also marks
   * all feeds of the given type dirty, but inhibits the feeds from being updated,
   * regardless of the updateFromFeedsOnDirty flag. Therefore, collers of
   * this function need to refresh the feeds (by calling startFeedTasks).
   */
  public function deSelectFeedsByType(feedType:String) {
    def tempUpdateFromFeedsOnDirty = updateFromFeedsOnDirty;
    updateFromFeedsOnDirty = false;
    for (feedToRead in feedsToRead) {
      if (feedToRead.type == feedType) {
        feedToRead.setSelected(false);
        feedToRead.setDirty(true);
      }
    }
    updateFromFeedsOnDirty = tempUpdateFromFeedsOnDirty;
  }

  /**
   * Sets the selected state of all feeds of a given type to true,
   * and the selected state of all other feeds to false.  This also marks
   * all feeds of the given type dirty, but inhibits the feeds from being updated,
   * regardless of the updateFromFeedsOnDirty flag. Therefore, collers of
   * this function need to refresh the feeds (by calling startFeedTasks).
   */
  public function selectOnlyFeedsByType(feedType:String) {
    def tempUpdateFromFeedsOnDirty = updateFromFeedsOnDirty;
    updateFromFeedsOnDirty = false;
    for (feedToRead in feedsToRead) {
      feedToRead.setSelected(feedToRead.type == feedType);
      feedToRead.setDirty(true);
    }
  }

  function retrieveTwitterProfilePicture(username:String, feedToRead:FeedInfo) {

    var parseTwitterProfileResponse = function(is:InputStream) {
      try {
        PullParser {
          input: is
          documentType: PullParser.XML;
          onEvent: function( e:Event ) {
            if (e.type == PullParser.END_ELEMENT) {
              if (e.qname.name == "profile_image_url") {
                textRead = e.text;
              }
            }
          }
        }.parse();
      } finally {
        is.close();
      }
    }

    var url = "http://twitter.com/users/show/{username}.xml";
    var req: HttpRequest;
    var textRead:String;

    req = HttpRequest {
      method: HttpRequest.GET
      location: url
      onInput: parseTwitterProfileResponse
      onDone: function() {
        feedToRead.feedLogo = textRead;
      }
      onException: function(ex: java.lang.Exception) {
        println("Exception: {ex.getClass()} {ex.getMessage()}");
      }
    }
    req.start();
  }

  var storageEntry:Storage;

  public function saveData():Void {
    storageEntry = Storage {
      source: "speedreaderfx.data"
    };
    var resource:Resource = storageEntry.resource;

    try {
      var outputStream:OutputStream = resource.openOutputStream(true);
      var dos = new DataOutputStream(outputStream);

      // Write the version number of this SpeedReaderFX data format
      dos.writeInt(1);

      // Write the number of FeedInfo instances to be written
      dos.writeInt(sizeof feedsToRead);
      for (fi in feedsToRead) {
        dos.writeUTF(fi.type);
        dos.writeUTF(fi.urla);
        dos.writeUTF(fi.urlb);
        dos.writeUTF(fi.argument);
        dos.writeBoolean(fi.isAtom);
        dos.writeUTF(fi.youTubeTag);
        dos.writeBoolean(fi.isSelected);
        println("Write FeedInfo: {fi}");
      }
      dos.close();
      outputStream.close();
      println("Dsts written");
    }
    catch (ioe:IOException) {
      println("IOException in saveProperties:{ioe}");
    }
  }

  public function loadData():Void {
    println("------------ In loadData() reading feed info ---------------");
    storageEntry = Storage {
      source: "speedreaderfx.data"
    };
    var resource:Resource = storageEntry.resource;
    
    var dataVersion:Integer;
    var numFeeds:Integer;
    var fi:FeedInfo;

    // Empty out the feed info sequences
    // TODO: Consider making these a sequence
    twitPicFeedInfo = [];
    tweeTubeFeedInfo = [];
    twitterFeedInfo = [];
    flickrFeedInfo = [];
    deliciousFeedInfo = [];
    youTubeFeedInfo = [];
    yahooFeedInfo = [];
    otherFeedInfo = [];

    try {
      var inputStream:InputStream = resource.openInputStream();
      var dis = new DataInputStream(inputStream);

      // Write the version number of this SpeedReaderFX data format
      dataVersion = dis.readInt();
      println("* Data version:{dataVersion}");

      // Read the number of FeedInfo instances
      numFeeds = dis.readInt();
      for (i in [1..numFeeds]) {
        fi = FeedInfo {
          model: this
          type: dis.readUTF()
          urla: dis.readUTF()
          urlb: dis.readUTF()
          argument: dis.readUTF()
          isAtom: dis.readBoolean()
          youTubeTag: dis.readUTF()
          isSelected: dis.readBoolean()
        };
        println("Read FeedInfo: {fi}");
        if (fi.type == "TwitPic") {
          insert fi into twitPicFeedInfo;
        }
        else if (fi.type == "TweeTube") {
          insert fi into tweeTubeFeedInfo;
        }
        else if (fi.type == "Twitter") {
          insert fi into twitterFeedInfo;
          println("Inserting:{fi} into twitterFeedInfo");
        }
        else if (fi.type == "Flickr") {
          insert fi into flickrFeedInfo;
        }
        else if (fi.type == "Delicious") {
          insert fi into deliciousFeedInfo;
        }
        else if (fi.type == "YouTube") {
          insert fi into youTubeFeedInfo;
        }
        else if (fi.type == "Yahoo") {
          insert fi into yahooFeedInfo;
        }
        else {
          insert fi into otherFeedInfo;
        }
        //feedsToRead[indexof i] = fi;
      }
      inputStream.close();
      dis.close();
      println("Finished reading data");
      //feedsToRead = feeds;

      for (feedInfo in twitterFeedInfo) {
        println("++++++++++++Twitter feedInfo.argument:{feedInfo.argument}");
      }

    }
    catch (ioe:IOException) {
      println("IOException in saveProperties:{ioe}");
    }
  }
}
