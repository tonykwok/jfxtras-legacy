/**
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

package org.jfxtras.util;

import javafx.geometry.*;

/**
 * Library to do simple planar 3d calculations.  This class will take coordinates
 * on the unit square ([0,0] to [1,1]) and map them to the given quadrilateral.
 * <p>
 * Useful to calculate the hit
 * bounds of a Node with a PerpectiveTransform effect applied.
 *
 * @author Stephen Chin
 */
public class PerspectiveTransformer {
  /** Upper left x coord of the destination quadrilateral */
  public-init var ulx:Number;
  /** Upper left y coord of the destination quadrilateral */
  public-init var uly:Number;
  /** Upper right x coord of the destination quadrilateral */
  public-init var urx:Number;
  /** Upper right y coord of the destination quadrilateral */
  public-init var ury:Number;
  /** Lower left x coord of the destination quadrilateral */
  public-init var llx:Number;
  /** Lower left y coord of the destination quadrilateral */
  public-init var lly:Number;
  /** Lower right x coord of the destination quadrilateral */
  public-init var lrx:Number;
  /** Lower right y coord of the destination quadrilateral */
  public-init var lry:Number;

  var m00:Number;
  var m01:Number;
  var m02:Number;
  var m10:Number;
  var m11:Number;
  var m12:Number;
  var m20:Number;
  var m21:Number;
  var m22:Number;

  init {
    buildUnitToQuadMatrix();
  }

  function buildUnitToQuadMatrix() {
    def dx1 = urx - lrx;
    def dx2 = llx - lrx;
    def dx3 = ulx - urx + lrx - llx;
    def dy1 = ury - lry;
    def dy2 = lly - lry;
    def dy3 = uly - ury + lry - lly;

    def inverseDeterminate = 1.0/(dx1*dy2 - dx2*dy1);
    m20 = (dx3*dy2 - dx2*dy3)*inverseDeterminate;
    m21 = (dx1*dy3 - dx3*dy1)*inverseDeterminate;
    m22 = 1.0;
    m00 = urx - ulx + m20*urx;
    m01 = llx - ulx + m21*llx;
    m02 = ulx;
    m10 = ury - uly + m20*ury;
    m11 = lly - uly + m21*lly;
    m12 = uly;
  }

  /**
   * Converts a point from source (unit square) to destination (quadrilateral)
   * coordinates.
   */
  public function transform(x:Number, y:Number):Point2D {
    def w = m20 * x + m21 * y + m22;
    return Point2D {
        x: (m00 * x + m01 * y + m02) / w
        y: (m10 * x + m11 * y + m12) / w
    }
  }
}
