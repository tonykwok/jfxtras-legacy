/*
 * Copyright (c) 2008-2010, JFXtras Group
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 * 1. Redistributions of source code must retain the above copyright notice,
 *		this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 *		this list of conditions and the following disclaimer in the documentation
 *		and/or other materials provided with the distribution.
 * 3. Neither the name of JFXtras nor the names of its contributors may be used
 *		to endorse or promote products derived from this software without
 *		specific prior written permission.
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

package org.jfxtras.scene.control;
import javafx.scene.*;
import javafx.scene.paint.*;
import javafx.scene.shape.*;
import javafx.scene.input.MouseEvent;
import javafx.animation.*;
import org.jfxtras.scene.shape.MultiRoundRectangle;
import org.jfxtras.scene.control.skin.AbstractSkin;
import javafx.geometry.Insets;
import org.jfxtras.scene.control.skin.XCaspian;

// dangerous imports
import com.sun.javafx.scene.layout.Region;
import com.sun.javafx.scene.layout.region.BackgroundFill;
import javafx.scene.control.Button;

/**
 * @author Tom Eugelink
 */

public class XNudgerSkinCaspian extends AbstractSkin
{
	// ===========================================================================================
	// behavior

	// create the behavior that comes with this control
	override protected var behavior = XNudgerBehavior{};
	var behaviorXNudger : XNudgerBehavior = bind behavior as XNudgerBehavior;

	// create a bind variable of the active control
	public var controlXNudger : XNudger = bind control as XNudger;

	// ===========================================================================================
	// layout

    var markHighlightFill = BackgroundFill {
        offsets: Insets { top: 1, left: 0, bottom: -1, right: 0 }
        fill:  XCaspian.fxMarkHighlightColor
    };
    var markFill = BackgroundFill {
        fill: XCaspian.fxMarkColor
    };

	/*
	 * a button gives us a nice canvas / background to draw our arrows upon
	 * and we can abuse it to handle the mouse events
	 */
    package var button: Button = Button {
        id: "background-button"
        width: bind control.layoutBounds.width
        height: bind control.layoutBounds.height
		onMouseWheelMoved:  function(mouseEvent : MouseEvent) : Void {
			behaviorXNudger.add( -1 * mouseEvent.wheelRotation );
		}
		onMouseDragged: function(mouseEvent : MouseEvent) : Void {
			var lAdd = (mouseEvent.dragX / 2);
			repeatAnimation(lAdd);
			behaviorXNudger.repeatingAdd( lAdd );
		}
		onMouseReleased: function(mouseEvent : MouseEvent) : Void {
			behaviorXNudger.repeatingStop();
			repeatAnimationStop();
		}
		onMousePressed: function(mouseEvent : MouseEvent) : Void {
			behaviorXNudger.add( if(mouseEvent.x < control.layoutBounds.width /2) -1 else 1 );
		}
    };

    /*
     * Region available for appropriate left arrow shape to be styled by CSS
     * Placed in an area 2 * size so translate by half size to be in middle
     */
    var leftArrow: Region = Region {
        id: "left-arrow"
        translateX: bind (control.layoutBounds.width / 3) - (leftArrow.layoutBounds.width / 2) + leftArrowOffset // base is at 1/3 of the width
        translateY: bind (control.layoutBounds.height / 2) - (leftArrow.layoutBounds.height / 2) // centered
        shape: SVGPath { content: "M 0 0 v 7 l -4,-3.5 z" }
        padding: Insets { top: 3 left: 3.5 bottom: 3 right: 3.5 }
        backgroundFills: [ markHighlightFill, markFill ]
    };
	var leftArrowOffset = 0;

    /*
     * Region available for appropriate right arrow shape to be styled by CSS
     * Placed in an area 2 * size so translate by -3/2 size to be in middle at end
     */
    var rightArrow: Region = Region {
        id: "right-arrow"
        translateX: bind (control.layoutBounds.width / 3 * 2) - (leftArrow.layoutBounds.width / 2) + rightArrowOffset  // base is at 2/3 of the width
        translateY: bind (control.layoutBounds.height / 2) - (leftArrow.layoutBounds.height / 2) // centered
        shape: SVGPath { content: "M 0 0 v 7 l 4,-3.5 z" }
        padding: Insets { top: 3 left: 3.5 bottom: 3 right: 3.5 }
        backgroundFills: [ markHighlightFill, markFill ]
    };
	var rightArrowOffset = 0;


	// build scene
	init {
		node = Group {
			content: [ button, leftArrow, rightArrow];
		}
	}

	// ===========================================================================================
	// animation
	// we use two external booleans to tell the timelines if they should stop or not
	// this allows us to stop the timelines at the keyframes @0s
	// which is required to have the animated values stop at their start value

	function repeatAnimation(add) {
		if (add < 0) {
			iLeftRepeatTimelineRunning = true;
			iLeftRepeatTimeline.play();
			iRightRepeatTimelineRunning = false;
		}
		if (add > 0) {
			iLeftRepeatTimelineRunning = false;
			iRightRepeatTimelineRunning = true;
			iRightRepeatTimeline.play();
		}
	}

	function repeatAnimationStop() {
		iLeftRepeatTimelineRunning = false;
		iRightRepeatTimelineRunning = false;
	}

	var iLeftRepeatTimeline : Timeline = Timeline {
		repeatCount:Timeline.INDEFINITE
		keyFrames: [
			KeyFrame {
				time: 0ms;
				values: leftArrowOffset => 0;
				action: function() {
					if (not iLeftRepeatTimelineRunning) iLeftRepeatTimeline.pause();
				}
			}
			KeyFrame {
				time: 500ms;
				values: leftArrowOffset => (control.layoutBounds.width / -6 as Integer);
			}
		]
	};
	var iLeftRepeatTimelineRunning : Boolean = false;

	var iRightRepeatTimeline : Timeline = Timeline {
		repeatCount:Timeline.INDEFINITE
		keyFrames: [
			KeyFrame {
				time: 0ms;
				values: rightArrowOffset => 0;
				action: function() {
					if (not iRightRepeatTimelineRunning) iRightRepeatTimeline.pause();
				}
			}
			KeyFrame {
				time: 500ms;
				values: rightArrowOffset => (control.layoutBounds.width / 6 as Integer);
			}
		]
	};
	var iRightRepeatTimelineRunning : Boolean = false;

	// ===========================================================================================
	// focus

	var focussed = bind control.focused
	on replace {
		button.requestFocus();
	};

	// ===========================================================================================
	// size

	override function getMinHeight() : Number {
		return 10;
	}
	override function getMinWidth() : Number {
		return 25;
	}

	override function getPrefHeight(width : Number) : Number {
		return 20;
	}
	override function getPrefWidth(height : Number) : Number {
		return 30;
	}
}

