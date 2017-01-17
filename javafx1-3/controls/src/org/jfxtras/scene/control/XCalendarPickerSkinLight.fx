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

package org.jfxtras.scene.control;

import javafx.scene.*;
import javafx.scene.text.*;
import org.jfxtras.scene.*;
import javafx.scene.control.*;
import javafx.scene.shape.Rectangle;
import javafx.scene.paint.Color;
import java.util.Random;
import javafx.scene.paint.*;
import javafx.scene.input.MouseEvent;
import org.jfxtras.scene.control.XCalendarPickerBehavior;
import javafx.animation.*;
import javafx.scene.effect.DropShadow;
import org.jfxtras.scene.control.skin.XCaspian;

/**
 * @author Tom Eugelink
 * TODO: scale with the available size
 * TODO: use CSS to skin
 */

public class XCalendarPickerSkinLight extends XCalendarPickerSkinAbstract
{
	// ===========================================================================================
	// controls

	// the font to use
	public-init var font = XCaspian.fxFont;
	public-init var fontHeader = font;

	// color (defaults = Caspian)
	public-init var headerColor : Color = Color.BLACK;
	public-init var weekendColor : Paint = Color.rgb(0, 153, 255);
	public-init var weekdayColor : Paint = Color.GRAY;
	public-init var weekColor : Paint = Color.GRAY;
	public-init var dayColor : Paint = Color.BLACK;
	public-init var gridColor : Paint = Color.DARKGRAY;
	public-init var selectedColor : Color = Color.rgb(0, 153, 255);
	public-init var todayColor : Paint = Color.rgb(153, 204, 255);
	public-init var backgroundColor : Paint = Color.WHITE;
	public-init var focusColor : Color = XCaspian.fxFocusColor;

	public function setCaspianScheme()
	{
		font = (Label{text:"bla"}).font;
		fontHeader = font;

		headerColor = Color.BLACK;
		weekendColor = Color.rgb(0, 153, 255);
		weekdayColor = Color.DARKGRAY;
		weekColor = Color.DARKGRAY;
		dayColor = Color.BLACK;
		gridColor = Color.DARKGRAY;
//		gridColor = LinearGradient
//		{ startX: 0.0, startY: 0.0, endX: 0.0, endY: 1.0
//		, proportional: true
//		, stops:
//			[ Stop { offset: 0.0 color: Color.LIGHTGRAY }
//			, Stop { offset: 0.3 color: Color.DARKGRAY }
//			, Stop { offset: 1.0 color: Color.DARKGRAY }
//			]
//		}
		selectedColor = Color.rgb(0, 153, 255);
		todayColor = Color.rgb(153, 204, 255);
		backgroundColor = Color.WHITE;
		focusColor = Color.rgb(0, 124, 216);

		refresh();
	}

	public function setGreyScheme()
	{
		font = Font.font("sans-serif", FontWeight.BOLD, 10);
		fontHeader = Font.font("sans-serif", FontWeight.BOLD, 12);

		headerColor = Color.WHITE;
		weekendColor = Color.RED;
		weekdayColor = Color.GRAY;
		weekColor = Color.GRAY;
		dayColor = Color.WHITE;
		gridColor = Color.GRAY;
		selectedColor = Color.BLUE;
		todayColor = Color.RED;
		backgroundColor = Color.BLACK;
		focusColor = Color.BLUE;

		refresh();
	}


	// ===========================================================================================
	// controls

	// month and year
	var headerLabel : HeaderNode = HeaderNode { text: "month year" };
	var monthXNudger : XNudger = XNudger{ id: "monthNudger" value: calendar.get(java.util.Calendar.MONTH), skin: XNudgerSkinLight{ } };
	var monthXNudgerValue : Integer = bind monthXNudger.value
	on replace
	{
		if (monthXNudgerValue < 0)
		{
			monthXNudger.value = 11;
      calendar.set(java.util.Calendar.MONTH, monthXNudgerValue);
      yearXNudger.value = calendar.get(java.util.Calendar.YEAR);
		}
		else if (monthXNudgerValue > 11)
		{
			monthXNudger.value = 0;
      calendar.set(java.util.Calendar.MONTH, monthXNudgerValue);
      yearXNudger.value = calendar.get(java.util.Calendar.YEAR);
		}
		else
		{
  		calendar.set(java.util.Calendar.MONTH, monthXNudgerValue);
		}
  	refresh_calendar();
	};
	var yearXNudger : XNudger = XNudger{ id: "yearNudger" value: calendar.get(java.util.Calendar.YEAR), skin: XNudgerSkinLight{ } };
	var yearXNudgerValue : Integer = bind yearXNudger.value
	on replace
	{
		calendar.set(java.util.Calendar.YEAR, yearXNudgerValue);
		refresh_calendar();
	};

	// dayOfWeek
	var dayOfWeekLabels : DayOfWeekNode[] = for (i in [0..6]) DayOfWeekNode { text: "wk{i}" };

	// week
	var weekLabels : WeekNode[] = for (i in [0..5]) WeekNode{ weeknr: i };

	// days
	var dayButtons : DayNode[] = for (i in [1..31]) DayNode{ daynr: i };
	
	// background
	var rectangle : Rectangle = Rectangle{ x:0, y:0, width: bind control.width, height: bind control.height, fill: bind backgroundColor };

	// since we are not layout by a container but do it ourselves, we need to respond to when the container changed the size of the control
	var width = bind control.width on replace { refresh_calendar(); }
	var height =  bind control.height on replace { refresh_calendar(); }




	/**
	 * visualize the focus
	 */
	var hasFocus : Boolean = bind control.focused
	on replace
	{
		// this is a highly unsatifying effect, we require something like a "border"
		headerLabel.effect = if(hasFocus) DropShadow{color: focusColor, radius: 5.0} else null;
	};

	// ===========================================================================================
	// layout

	// build scene
	init {
		setCaspianScheme();
		node = Group {
			content: [ rectangle, 
               Group {
                   content: monthXNudger
                   scaleX: 1.5
                   scaleY: 1.5
               },
               headerLabel,
               Group {
                   content: yearXNudger
                   scaleX: 1.5
                   scaleY: 1.5
               },
               dayOfWeekLabels, weekLabels, dayButtons
					 ];
		}
	}

	// ===========================================================================================
	// refresh

	/**
	 *
	 */
	override public function refresh_context() : Void {
		// set dayOfWeeklabels
		var lDayOfWeekLabel : String[] = getWeekdayNames();
		for (i in [0..6])  {
			dayOfWeekLabels[i].text = lDayOfWeekLabel[i];
			dayOfWeekLabels[i].weekend = isWeekdayWeekend(i)
		}

		// we need to refresh the rest as well
		refresh_calendarActual();
	}

	/**
	 *
	 */
	override public function refresh_calendar() : Void {
		refreshHeaderText();
		refreshHeaderPosition();
		if (iFirstTime) {
			iFirstTime = false;
			refresh_calendarActual();
		}
		else {
			iRefreshCalendarTimeline.playFromStart();
		}
	}
	var iFirstTime : Boolean = true;
	var iRefreshCalendarTimeline = Timeline { repeatCount:1, keyFrames:
	[
		KeyFrame {
			time: 300ms;
			action: function() {
				refresh_calendarActual();
			};
		}
	]};

	/**
	 *
	 */
	public function refresh_calendarActual() : Void
	{
		//println("refreshActual();");

		// set dayOfWeeklabels
		for (i in [0..6]) {
			var lText : DayOfWeekNode = dayOfWeekLabels[i];
		}

		// set weekLabels 
		var lWeekLabel = getWeekLabels();
		for (i in [0..5]) {
			var lText : WeekNode = weekLabels[i];
			lText.weeknr = lWeekLabel[i];
		}

		// -----------------------
		// layout prep

		// determine header sisze
		// header is already refreshed: refreshHeaderText();
		var lHeaderHeighest = HeaderNode{ text: "W", }.textNode.layoutBounds.height;

		// determine week label width
		var lWeekLabelWidest = WeekNode{ weeknr:88 }.textNode.layoutBounds.width;

		// determine day of week height
		var lDayOfWeekLabelHeighest = DayOfWeekNode{ text: "W" }.textNode.layoutBounds.height;

		// determine the grid size
		var lGridBlockWidth = (control.width - (2*iMargin) - lWeekLabelWidest) / 7 ;
		var lGridBlockHeight = (control.height - (3*iMargin) - lHeaderHeighest - lDayOfWeekLabelHeighest) / 6 ;
		//println("lGridBlock={lGridBlockWidth}x{lGridBlockHeight}");

		// -----------------------
		// layout

		// layout dayOfWeekLabel
		for (i in [0..6]) {
			dayOfWeekLabels[i].width = lGridBlockWidth;
			dayOfWeekLabels[i].setFill(); // force color change if the size did not change
			dayOfWeekLabels[i].jumpXTo( iMargin + lWeekLabelWidest + iMargin + (i * lGridBlockWidth) );
			dayOfWeekLabels[i].jumpYTo( iMargin + lHeaderHeighest + iMargin - 1 );
		}

		// layout weekLabels
		for (i in [0..5]) {
			weekLabels[i].height = lGridBlockHeight;
			weekLabels[i].jumpXTo( iMargin );
			weekLabels[i].jumpYTo( iMargin + lHeaderHeighest + iMargin + lDayOfWeekLabelHeighest + iMargin + (i * lGridBlockHeight) );
		}

		// layout days
		var lCalendar : java.util.Calendar = (calendar.clone() as java.util.Calendar);
		var lDayOfWeekCol = determineFirstOfMonthDayOfWeek();
		var lDaysInMonth = determineDaysInMonth();
		var lWeekRow = 0;
		var lWeekRowLastVisible = lWeekRow;

    var lStartupDelay = Duration.valueOf(0);
		var lDuration = Duration.valueOf(100);

      for (i in [0..30]) {
			
			// determine the calendar
			lCalendar.set(java.util.Calendar.DATE, (i+1));

			// put in some randomness so the neetness goes out of the animation
//			var lStartupDelay = Duration.valueOf(iRandom.nextInt(100));
//			var lDuration = Duration.valueOf(250 + iRandom.nextInt(100));

			// position
			dayButtons[i].animateXTo( iMargin + lWeekLabelWidest + iMargin + (lDayOfWeekCol * lGridBlockWidth), lDuration, lStartupDelay );
			dayButtons[i].animateYTo( iMargin + lHeaderHeighest + iMargin + lDayOfWeekLabelHeighest + iMargin + (lWeekRow * lGridBlockHeight), lDuration, lStartupDelay );
			dayButtons[i].width = lGridBlockWidth;
			dayButtons[i].height = lGridBlockHeight;
			dayButtons[i].isToday = isToday(lCalendar);
			dayButtons[i].fillRectangle(); // force color setting

			// visible or not (only 29..31)
			if (i > 27) {
				dayButtons[i].animateOpacityTo( (if ((i+1) > lDaysInMonth) 0.0 else 1.0), lDuration, lStartupDelay );
			}
			if ((i+1) <= lDaysInMonth) lWeekRowLastVisible = lWeekRow;

			// next
			lDayOfWeekCol++;
			if (lDayOfWeekCol > 6) {
				lDayOfWeekCol = 0;
				lWeekRow++;
			}
		}

		// should the last weeklabels be hidden?
		for (i in [4..5]) {
			weekLabels[i].animateOpacityTo( (if (lWeekRowLastVisible < i) 0.0 else 1.0), lDuration, lStartupDelay  );
		}

		// header
		refreshHeaderPosition();
		monthXNudger.translateX = iMargin;
		monthXNudger.translateY = iMargin - 2;
		yearXNudger.translateX = rectangle.width - yearXNudger.width - iMargin;
		yearXNudger.translateY = iMargin - 2;

		// selection
		refresh_selection();
	}
	var iRandom : Random = new Random();
	var iMargin = 2;

	/**
	 *
	 */
	override public function refresh_selection() : Void
	{
		// layout days
		var lCalendar : java.util.Calendar = (calendar.clone() as java.util.Calendar);
		for (i in [0..30]) {
			
			// determine the calendar
			lCalendar.set(java.util.Calendar.DATE, (i+1));

			// is selected
			dayButtons[i].isSelected = (control as XCalendarPicker).isSelected(lCalendar);
		}
	}

	/**
	 *
	 */
	function refreshHeaderText() : Void {
		// set header
		headerLabel.text = "{getMonthName()} {calendar.get(java.util.Calendar.YEAR)}";
	}
	function refreshHeaderPosition() : Void {
		// position header
		headerLabel.jumpXTo( (rectangle.width - headerLabel.textNode.layoutBounds.width) / 2 );
		headerLabel.jumpYTo( iMargin );
	}

	override function getMinHeight() : Number
	{
		return 200;
	}
	override function getMinWidth() : Number
	{
		return 200;
	}

	override function getPrefHeight(width : Number) : Number
	{
		return width;
	}
	override function getPrefWidth(height : Number) : Number
	{
		return height;
	}
}

class HeaderNode extends AutoAnimatingCustomNode
{
	var textNode : Text = Text { id: "headerText" content: "?", fill: bind headerColor, font: bind fontHeader, textOrigin: TextOrigin.TOP };

	public var text : String
	on replace
	{
		textNode.content = text;
	};

	public override function create(): Node
	{
		return textNode;
	}

}

class DayOfWeekNode extends AutoAnimatingCustomNode
{
	var textNode : Text = Text { id: "dayOfWeekText" content: "?", font: bind font, textOrigin: TextOrigin.TOP }; // TODO: why can't I bind hete but can in HeaderNode: fill: bind weekdayColor,

	public var text : String
	on replace
	{
		textNode.content = text;
	};

	public var weekend : Boolean
	on replace
	{
			setFill();
	};
	public function setFill()
	{
		textNode.fill = if (weekend) weekendColor else weekdayColor;
	}


	public var width : Number
	on replace
	{
		// center
		textNode.x = ((width - textNode.layoutBounds.width) / 2);
	};

	public override function create(): Node
	{
		return textNode;
	}

}

class WeekNode extends AutoAnimatingCustomNode
{
	var textNode : Text = Text { id: "weekText" x:0, y:0, content: "?", font: bind font, fill: weekColor, textOrigin: TextOrigin.TOP };

	public var weeknr : Integer
	on replace
	{
		textNode.content = "{weeknr}";
	};

	public var height : Number
	on replace
	{
		// center 
		textNode.y = ((height - textNode.layoutBounds.height) / 2) - iMargin + 1;
	};
	
	public override function create(): Node
	{
		return textNode;
	}
}

class DayNode extends AutoAnimatingCustomNode
{
	var textNode : Text = Text 
	{ id: "dayText"
	, x:0, y:0
	, content: "?"
	, fill: bind dayColor
	, font: bind font
	, textOrigin: TextOrigin.TOP
	};

	var rectangleNode : Rectangle = Rectangle
	{ id: "dayRectangle"
	, x:0, y:0
	, fill: gridColor
	, stroke: Color.TRANSPARENT
//	, arcHeight: 5, arcWidth: 5
	};
									
	public var daynr : Integer
	on replace
	{
		textNode.content = "{daynr}";
	};

	public var width : Number
	on replace
	{
		textNode.x = ((width - textNode.layoutBounds.width) / 2) - iMargin + 1;
		rectangleNode.width = width - (2 * iMargin);
	};

	public var height : Number
	on replace
	{
		textNode.y = ((height - textNode.layoutBounds.height) / 2) - iMargin + 1;
		rectangleNode.height = height - (2 * iMargin);
	};

	public var isSelected : Boolean = false
	on replace
	{
		fillRectangle();
	};

	public var isToday : Boolean = false
	on replace
	{
		fillRectangle();
	};

	function fillRectangle()
	{
		rectangleNode.fill = if (isSelected) selectedColor else (if (isToday) todayColor else gridColor);
	}


	public override function create(): Node
	{
		onMouseClicked = function(mouseEvent : MouseEvent) : Void
		{
			var lCalendar = (calendar.clone() as java.util.Calendar);
			lCalendar.set(java.util.Calendar.DATE, daynr);
			(behavior as XCalendarPickerBehavior).select(lCalendar, mouseEvent.shiftDown, mouseEvent.controlDown, true);
		};
		
		return Group
		       {
				   content: 
				   [ rectangleNode
				   , textNode
				   ]
			   };
	}
}

