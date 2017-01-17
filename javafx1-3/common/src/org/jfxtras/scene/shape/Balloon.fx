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

package org.jfxtras.scene.shape;

import javafx.scene.shape.Path;
import javafx.scene.shape.MoveTo;
import javafx.scene.shape.LineTo;
import javafx.scene.shape.ArcTo;
import javafx.util.Math;
import org.jfxtras.util.GeometryUtil;

/**
 * <p>The {@code Balloon} class defines a rectangular shape (with optional
 * rounded corners) and a triangular tab. Commonly used for tooltips and text
 * blurbs in comics.</p>
 *
    @example
    import org.jfxtras.scene.shape.Balloon;
    import javafx.scene.paint.*;

    Balloon {
        x: 10
        y: 10
        width: 50
        height: 50
        arc: 20
        tabWidth: 20
        tabHeight: 10
        tabDisplacement: 0.5
        tabLocation: Balloon.TAB_AT_BOTTOM
        fill: Color.BLACK
    }
    @endexample
 *
 * @profile desktop
 *
 * @author Steven Bixby
 * @author Andres Almiray <aalmiray@users.sourceforge.net>
 */
public class Balloon extends Path {

    init {
        recalculatePath();
    }

    function recalculatePath() {
        var locHWidth;
        var locHHeight;
        def arcRadius = arc/2;
        
        // Game plan:  Start shape with center at 0,0;
        // Build tab at bottom, rotate shape to correct
        // tab location after it's built, then translate
        // to final position.
        
        // Swap height/width if tab is on side.
        if (tabLocation == TAB_AT_BOTTOM or tabLocation == TAB_AT_TOP) {
            locHWidth = width/2;
            locHHeight = height/2;
        } else {
            locHWidth = height/2;
            locHHeight = width/2;
        }

        def locHWidthWArc = locHWidth-arcRadius;
        def locHHeightWArc = locHHeight-arcRadius;

        // tab start (ccw-most)
        def tabStartX = locHWidthWArc - (((2*locHWidthWArc)-tabWidth)*(1-tabDisplacement));
        def tabTipX = if (anglePosition==Balloon.ANGLE_AT_END)
                            then tabStartX
                      else if (anglePosition==Balloon.NONE)
                            then tabStartX-(tabWidth/2)
                      else
                            tabStartX-tabWidth;

        elements = [
            MoveTo { x: tabStartX; y: locHHeight },
            LineTo { x: tabTipX; y: locHHeight + tabHeight },
            LineTo { x: tabStartX-tabWidth; y: locHHeight },
            LineTo { x: -locHWidthWArc; y:locHHeight },

            if (arc > 0) then
                ArcTo  { x: -locHWidth; y: locHHeightWArc; radiusX: arcRadius; radiusY:arcRadius; sweepFlag: true } else null,

            LineTo { x: -locHWidth; y: -locHHeightWArc },

            if (arc > 0) then
                ArcTo  { x: -locHWidthWArc; y: -locHHeight; radiusX: arcRadius; radiusY:arcRadius; sweepFlag: true } else null,

            LineTo { x: locHWidth-arcRadius; y: -locHHeight; },

            if (arc > 0) then
                ArcTo  { x: locHWidth; y: -locHHeightWArc; radiusX: arcRadius; radiusY:arcRadius; sweepFlag: true } else null,

            LineTo { x: locHWidth; y: locHHeightWArc },

            if (arc > 0) then
                ArcTo  { x: locHWidthWArc; y: locHHeight; radiusX: arcRadius; radiusY:arcRadius; sweepFlag: true } else null,

            LineTo { x: tabStartX; y: locHHeight; },
        ];

        if (tabLocation==TAB_AT_LEFT) then
            GeometryUtil.rotatePathElementsAroundPointInPlace(elements, Math.toRadians(90))
        else if (tabLocation==TAB_AT_TOP)
            GeometryUtil.rotatePathElementsAroundPointInPlace(elements, Math.toRadians(180))
        else if (tabLocation==TAB_AT_RIGHT)
            GeometryUtil.rotatePathElementsAroundPointInPlace(elements, Math.toRadians(270));

        if (tabLocation==TAB_AT_LEFT or tabLocation==TAB_AT_RIGHT)
            GeometryUtil.translatePathElementsInPlace(elements, x+locHHeight, y+locHWidth)
        else
            GeometryUtil.translatePathElementsInPlace(elements, x+locHWidth, y+locHHeight);
    }


    /**
     * Defines the position of the angle on the balloon's tab.  Valid values are Balloon.NONE,
     * Balloon.ANGLE_AT_START, and Balloon.ANGLE_AT_END.
     * @defaultvalue Balloon.NONE
     */
    public var anglePosition:Number = Balloon.NONE on replace {
        recalculatePath();
    }

   /**
    * Defines the diameter of the arc at the four corners of the rectangle.
     * @defaultvalue 0
    */
    public var arc:Number on replace {
        recalculatePath();
    }

    /**
     * Defines the height of the balloon excluding the tab.
     * @defaultvalue 50
     */
    public var height:Number = 50 on replace {
        recalculatePath();
    }

    /**
     * Defines the width of the balloon excluding the tab.
     * @defaultvalue 50
     */
    public var width:Number = 50 on replace {
        recalculatePath();
    }

    /**
     * Defines the X coordinate of the upper-left corner of the balloon.
     * @defaultvalue 0
     */
    public var x:Number on replace {
        recalculatePath();
    }

    /**
     * Defines the Y coordinate of the upper-left corner of the balloon.
     * @defaultvalue 0
     */
    public var y:Number on replace {
        recalculatePath();
    }

    /**
     * Defines the height of the balloon's tab.
     * @defaultvalue 10
     */
    public var tabHeight:Number = 10 on replace {
        recalculatePath();
    }

    /**
     * Defines the width of the balloon's tab where it attaches to the balloon.
     * @defaultvalue 20
     */
    public var tabWidth:Number = 20 on replace {
        recalculatePath();
    }

    /**
     * Defines which side of the balloon the tab should appear on.  Valid values are Balloon.TAB_AT_BOTTOM,
     * Balloon.TAB_AT_TOP, Balloon.TAB_AT_LEFT, Balloon.TAB_AT_RIGHT.
     * @defaultvalue Balloon.TAB_AT_BOTTOM
     */
    public var tabLocation:Number = Balloon.TAB_AT_BOTTOM on replace {
        recalculatePath();
    }

    /**
     * Defines the location of the tab along the side of the balloon.  Range is from 0.0 to 1.0.  A value
     * of 0.5 will center the tab along the balloon's side.
     * @defaultvalue 0.5
     */
    public var tabDisplacement:Number = 0.5 on replace {
        recalculatePath();
    }
}

public def NONE = -1;
public def ANGLE_AT_END = 1;
public def ANGLE_AT_START = 0;

public def TAB_AT_BOTTOM = 0;
public def TAB_AT_LEFT = 3;
public def TAB_AT_RIGHT = 1;
public def TAB_AT_TOP = 2;

