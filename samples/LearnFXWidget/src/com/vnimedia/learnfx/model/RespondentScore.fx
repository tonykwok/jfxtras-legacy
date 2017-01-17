/*
 * RespondentScore.fx
 *
 */

package com.vnimedia.learnfx.model;
import java.lang.Comparable;
import org.jfxtras.lang.XObject;

public class RespondentScore extends Comparable, XObject {
  /**
   *
   */
  public var image:String;

  /**
   *
   */
  public var screenName:String;

  /**
   * Number of points that this student has accumulated
   */
  public var score:Integer;

  /**
   * TODO: Flesh this out with data comparison if needed
   */
  override public function compareTo(respondent:Object):Integer {
    return score.compareTo((respondent as RespondentScore).score);
  };

  /**
   *
   */
  override public function toString():String {
    return "screenName:{screenName}, score:{score}";
  };
}
