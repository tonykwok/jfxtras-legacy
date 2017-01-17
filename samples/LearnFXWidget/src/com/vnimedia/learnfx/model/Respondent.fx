/*
 * Respondent.fx
 *
 */

package com.vnimedia.learnfx.model;
import java.lang.Comparable;
import org.jfxtras.lang.XObject;

public class Respondent extends Comparable, XObject {
  /**
   *
   */
  public var image:String;

  /**
   *
   */
  public var screenName:String;

  /**
   *
   */
  public var response:String;

  /**
   * Could be "yes", "no", or a URL to an image
   */
  public var correct:String;

  /**
   * Prior score
   */
  public var priorScore:Integer;

  /**
   * Could be "yes", "no", or a URL to an image
   */
  public var tweetId:Integer;

  /**
   * Indicates whether the response is correct
   */
  public var isCorrect:Boolean;

  /**
   * TODO: Flesh this out with data comparison if needed
   */
  override public function compareTo(respondent:Object):Integer {
    def isCorrectCompare = (respondent as Respondent).isCorrect.compareTo(isCorrect);
    def tweetIdCompare = tweetId.compareTo((respondent as Respondent).tweetId);
    if (isCorrectCompare != 0) {
      return isCorrectCompare;
    }
    else {
      return tweetIdCompare;
    }
  }
}
