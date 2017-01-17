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
 * FeedInfo.fx
 *
 * TODO: For uniformity and abstraction, consider removing youTubeTag
 *       and use argument (or url) instead.
 */
package org.jfxtras.speedreader.model;

/**
 * Represents a feed or social network request.  For example, a FeedInfo
 * instance could hold the URL for an Flickr feed along with the search tags
 * that the user would like to use in the request.
 *
 * @author Jim Weaver
 */
public class FeedInfo {
  /**
   * Reference to the main model for this app
   */
  public var model:SpeedReaderModel;

  public var type:String = "Unknown";
  public var name:String;
  public var url:String = bind "{urla}{argument}{urlb}";
  public var urla:String;
  public var urlb:String;
  public var argument:String;
  public var numItemsToShow:Integer = 10;
  public var isAtom:Boolean; //Set by program
  public var isTwitter:Boolean; // Discovered from feed
  public var youTubeTag:String;
  
  //TODO: Consider changing setSelected() and getSelected() back to just isSelected
  public var isSelected:Boolean = false on replace {
    //setSelected(isSelected);
  };
  public function setSelected(selected:Boolean):Void {
    isSelected = selected;
  }
  public function getSelected():Boolean {
    return isSelected;
  }

  var isDirty:Boolean = true;
  public function setDirty(dirty:Boolean):Void {
    isDirty = dirty;
    if (isDirty and model.updateFromFeedsOnDirty) {
      model.startFeedTasks();
      isDirty = false;
    }
  }
  public function getDirty():Boolean {
    return isDirty;
  }

  public var feedLogo:String on replace {
    if (feedLogo != "") {
      // Update the FeedTitle variable in corresponding instances of the
      // FeedTableItem sequence that backs the Table
      // TODO: Improve the technique for replacing
      for (feedTableItem in model.feedTableItems) {
        if (feedTableItem.feedInfo == this) {
          feedTableItem.feedTitle = feedLogo;
        }
      }
    }
  };

  package function deleteFeedTableItems():Void {
    for (feedTableItem in model.feedTableItems) {
      if (feedTableItem.feedInfo == this) {
        delete feedTableItem from model.feedTableItems;
      }
    }
  }

  override public function toString():String {
    return "type:{type}, urla:{urla}, urlb:{urlb}, argument:{argument}, "
           "isAtom:{isAtom}, youTubeTag:{youTubeTag}, isSelected:{isSelected}";
  }
}
