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
import javafx.scene.control.*;
import javafx.scene.paint.*;
import javafx.scene.effect.*;
import org.jfxtras.scene.control.*;
import org.jfxtras.scene.layout.XMigLayout;
import javafx.scene.Group;
import net.miginfocom.layout.CC;
import javafx.scene.shape.Rectangle;
import net.miginfocom.layout.LC;
import java.util.concurrent.atomic.AtomicInteger;
import net.miginfocom.layout.AC;
import org.jfxtras.scene.control.XPicker;
import javafx.geometry.HPos;

/**
 * @author Tom Eugelink
 * TODO: keyboard navigation
 * TODO: determine minimum and maximum size by using the version without bind w & h? http://blog.cedarsoft.com/2010/04/javafx-and-custom-controls/
 */

public class XCalendarPickerSkinControls extends XCalendarPickerSkinAbstract
{
	// ===========================================================================================
	// controls

	// maximum 6 week each with 7 buttons
	var buttons : ToggleButton[] = for (i in [0..(6*7)-1]) ToggleButton
	{
		text: "?"
		// we use released instead of clicked, because if the user holds the button too long when clicking the focus logic goes wrong
		onMouseReleased: function (mouseEvent): Void { clicked(buttons[i].text, mouseEvent.shiftDown, mouseEvent.controlDown);  }
	};

	// week
	var weekLabels : Label[] = for (i in [0..5]) Label { text: "wk{i}" };

	// day
	var dayLabels : Label[] = for (i in [0..6]) Label { text: "dy{i}" };

	// month
	var monthPicker = XPicker // we use XPicker we use it for the year; ChoiceBox
	{ items: [ "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December" ]
	, pickerType: XPickerType.SIDE_SCROLL
    , dropDown: true
    , cyclic: true
    , hpos: HPos.CENTER
//,id: "monthPicker" // for debugging xmiglayout
    };
	// detect changed selected item
	var monthPickerSelectedIndex: Integer = bind monthPicker.selectedIndex on replace
    {
		var lCalendar = calendar.clone() as java.util.Calendar;
		lCalendar.set(java.util.Calendar.MONTH, monthPickerSelectedIndex);
		calendar = lCalendar; // we use a clone calendar in order to allow binding. Setting the value directly will not trigger the bind
    };
	// detect if we cycle end->begin or vice versa and update the year accordingly
	var monthPickerCycleChange: Integer = bind monthPicker.cycleChange on replace
    {
		yearPicker.select(yearPicker.selectedIndex + monthPickerCycleChange);
    };

	// year
	var yearPicker = XPicker // we use XPicker because it has a mode without a drop down box; ChoiceBox
	{ items: [1900..1902]
	, pickerType: XPickerType.SIDE_SCROLL
    , hpos: HPos.CENTER
    };

	// detect changed selected item
	var yearPickerSelectedItem: Object = bind yearPicker.selectedItem on replace
    {
		if (yearPickerIsModifying.get() == 0)
		{
			var lYear : Integer = yearPickerSelectedItem as Integer;
			var lCalendar = calendar.clone() as java.util.Calendar;
			lCalendar.set(java.util.Calendar.YEAR, lYear);
			calendar = lCalendar; // we use a clone calendar in order to allow binding. Setting the value directly will not trigger the bind
		}
    };
	var yearPickerIsModifying : AtomicInteger = new AtomicInteger();

	// just for accessing the colors
	var dummyLabel = Label{ text: "dummy" };


	// ===========================================================================================
	// layout

	// the picker itself
	var picker = XMigLayout
	{ constraints: LC{}.fill()//.debug(1000)
	, columns: AC{}
	, rows: AC{}
	, content: 
		[ XMigLayout.migNode( monthPicker, CC{}.skip(1).width("10px").growX().spanX(4) ), XMigLayout.migNode( yearPicker, CC{}.width("10px").growX().spanX(3).wrap() ) // we need to set a small preferred size, because the default preferred size is very large
		,													  	     for (i in [0..(6-1)])       XMigLayout.migNode( dayLabels[i],  CC{}.alignX("center").skip(if(i==0) 1 else 0) ), XMigLayout.migNode( dayLabels[6], CC{}.alignX("center").wrap() )
		, XMigLayout.migNode( weekLabels[0], CC{}.alignX("right") ), for (i in [(0*7)..(1*7)-2]) XMigLayout.migNode( buttons[i], CC{}.grow().push() ),							 XMigLayout.migNode( buttons[(1*7)-1], CC{}.grow().push().wrap() )
		, XMigLayout.migNode( weekLabels[1], CC{}.alignX("right") ), for (i in [(1*7)..(2*7)-2]) XMigLayout.migNode( buttons[i], CC{}.grow().push() ),							 XMigLayout.migNode( buttons[(2*7)-1], CC{}.grow().push().wrap() )
		, XMigLayout.migNode( weekLabels[2], CC{}.alignX("right") ), for (i in [(2*7)..(3*7)-2]) XMigLayout.migNode( buttons[i], CC{}.grow().push() ),							 XMigLayout.migNode( buttons[(3*7)-1], CC{}.grow().push().wrap() )
		, XMigLayout.migNode( weekLabels[3], CC{}.alignX("right") ), for (i in [(3*7)..(4*7)-2]) XMigLayout.migNode( buttons[i], CC{}.grow().push() ),							 XMigLayout.migNode( buttons[(4*7)-1], CC{}.grow().push().wrap() )
		, XMigLayout.migNode( weekLabels[4], CC{}.alignX("right") ), for (i in [(4*7)..(5*7)-2]) XMigLayout.migNode( buttons[i], CC{}.grow().push() ),							 XMigLayout.migNode( buttons[(5*7)-1], CC{}.grow().push().wrap() )
		, XMigLayout.migNode( weekLabels[5], CC{}.alignX("right") ), for (i in [(5*7)..(6*7)-2]) XMigLayout.migNode( buttons[i], CC{}.grow().push() ),							 XMigLayout.migNode( buttons[(6*7)-1], CC{}.grow().push().wrap() )
		]
	, width: bind boundControl.width
	, height: bind boundControl.height
	};

	// the outer border
	public-init var borderTop : Color = Color.web("#95989E");
	public-init var borderBottom : Color = Color.web("#585B61");
	public-init var borderGradientOuterColor : Color = Color.WHITE;
	public-init var borderGradientMiddleColor : Color = Color.web("#dddfe5");
	var border : Rectangle = Rectangle 
	{ x:0, y:0
	, width: bind boundControl.width		
	, height: bind boundControl.height			
    , arcWidth: 10
    , arcHeight: 10
	, stroke: LinearGradient
		{ startX: 0.0, startY: 0.0, endX: 0.0, endY: 1.0
		, proportional: true
		, stops:
			[ Stop { offset: 0.0 color: borderTop }
			, Stop { offset: 1.0 color: borderBottom }
			]
		}
    , fill: LinearGradient
		{ startX: 0.0, startY: 0.0, endX: 0.0, endY: 1.0
		, proportional: true
		, stops:
			[ Stop { offset: 0.0 color: borderGradientOuterColor }
			, Stop { offset: 0.4 color: borderGradientMiddleColor }
			, Stop { offset: 0.9 color: borderGradientOuterColor }
			]
		}
    };

	init
	{
		node = Group { content: [border, picker ] }
	}

	// ===========================================================================================
	// event

	function clicked(idx : String, range : Boolean, extend : Boolean)
	{
		// get date
		var lIdx = java.lang.Integer.parseInt(idx);

		// create the calendar
		var lCalendar = boundControl.calendarForConfig.clone() as java.util.Calendar;
		lCalendar.set(java.util.Calendar.YEAR, yearPicker.selectedItem as Integer);
		lCalendar.set(java.util.Calendar.MONTH, monthPicker.selectedIndex);
		lCalendar.set(java.util.Calendar.DATE, lIdx);

		// set it
		(behavior as XCalendarPickerBehavior).select(lCalendar, range, extend, false);
	}


	// ===========================================================================================
	// XCalendarPickerSkin interface

	override public function refresh_context() : Void
	{
		// month
		monthPicker.items = getMonthNames();

		// setup the dayLabels
		var lWeekdayNames = getWeekdayNames();
		for (i in  [0..6])
		{
			// assign day
			dayLabels[i].text = lWeekdayNames[i];
			dayLabels[i].textFill = if ( isWeekdayWeekend(i) ) Color.RED else dummyLabel.textFill; // TODO: colors customizable
		}
	}

	override public function refresh_calendar() : Void
	{
		// year
		var lYear : Integer = calendar.get(java.util.Calendar.YEAR);
		// change the yearPicker's item range
		if (yearPickerIsModifying.get() != 0) return;
		else
		{
			// set a new item range on the yearPicker
			yearPickerIsModifying.incrementAndGet();
			try
			{
				yearPicker.items = [lYear - 1, lYear, lYear + 1];
				yearPicker.select(1);
			}
			finally
			{
				yearPickerIsModifying.decrementAndGet();
			}
		}

		// month
		var lMonth : Integer = calendar.get(java.util.Calendar.MONTH);
		monthPicker.select(lMonth);

		// setup the weekLabels
		var lWeekLabels = getWeekLabels();
		for (i in [0..5])
		{
			// set label
			weekLabels[i].text = "{lWeekLabels[i]}";

			// first hide
			weekLabels[i].visible = false;
		}

		// setup the buttons [0..(6*7)-1]
		// determine with which button to start
		var lFirstOfMonthIdx = determineFirstOfMonthDayOfWeek();

		// hide the preceeding buttons
		for (i in [0..lFirstOfMonthIdx - 1])
		{
			buttons[i].visible = false;
		}
		
		// set the month buttons
		var lDaysInMonth = determineDaysInMonth();
		var lCalendar = calendar.clone() as java.util.Calendar;
		for (i in [1..lDaysInMonth])
		{
			// set the date
			lCalendar.set(java.util.Calendar.DATE, i);

			// determine the index in the buttons
			var lIdx = lFirstOfMonthIdx + i - 1;

			// update the button
			buttons[lIdx].visible = true;
			buttons[lIdx].text = "{i}";

			// make the corresponding weeklabel visible
			weekLabels[lIdx / 7].visible = true;

			// highlight today
			buttons[lIdx].effect = if (isToday(lCalendar)) InnerShadow {color: Color.BLACK} else null; // TODO: color custom
		}

		// hide the trailing buttons
		for (i in [lFirstOfMonthIdx + lDaysInMonth..(6*7)-1])
		{
			buttons[i].visible = false;
		}

		// request relayout
		picker.requestLayout();

		// also update the selection
		refresh_selection();
	}
	
	override public function refresh_selection() : Void
	{
		// setup the buttons [0..(6*7)-1]
		// determine with which button to start
		var lFirstOfMonthIdx = determineFirstOfMonthDayOfWeek();

		// set the month buttons
		var lDaysInMonth = determineDaysInMonth();
		var lCalendar = calendar.clone() as java.util.Calendar;
		for (i in [1..lDaysInMonth])
		{
			// set the date
			lCalendar.set(java.util.Calendar.DATE, i);

			// determine the index in the buttons
			var lIdx = lFirstOfMonthIdx + i - 1;

			// is this date selected
			buttons[lIdx].selected = boundControl.isSelected(lCalendar);
		}
	}

	override function getMinHeight() : Number
	{
		return getPrefHeight(0);
	}
	override function getMinWidth() : Number
	{
		return getPrefWidth(0);
	}

	override function getPrefHeight(width : Number) : Number
	{
		return 220;
	}
	override function getPrefWidth(height : Number) : Number
	{
		return 300;
	}
}