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
import javafx.util.Sequences;

// constants for the mode
public def MODE_SINGLE = 0;
public def MODE_RANGE = 1;
public def MODE_MULTIPLE = 2;

/**
 * <p>A DatePicker using the Calendar class inspirated by the many other date pickers out there.</p>
 *
 * <p>The locale only determines the language that is used, settings like "first day of week" are set by the calendar.
 * So it is possible to have english calendar settings (e.g. first day of week is monday) with french texts.</p>
 *
 @example

	XCalendarPicker {
		  mode: XCalendarPicker.MODE_MULTIPLE
		  calendar: java.util.Calendar.getInstance(Locale.ENGLISH) // the locale determine the first-day-of-week
		  locale: Locale.ENGLISH // this locale determines the month and weekday names
	};

 @endexample
 *
 * <ul>
 * <li>mode - The selection mode; XCalendarPicker.MODE_SINGLE (default), MODE_RANGE or MODE_MULTIPLE</li>
 * <li>calendar - The (last) selected calendar, also determines first-day-of-week. Default: Calendar.getInstance() </li>
 * <li>calendars - The selected calendars, in case of SINGLE this contains only one Calendar. Default: [Calendar.getInstance()] </li>
 * <li>locale - The locale for month and weekday names. Default: Locale.getDefault() </li>
 * <li>allowNull - Allows no day to be selected (otherwise always one is selected). Default: true </li>
 *
 * @author Tom Eugelink
 */
public class XCalendarPicker extends Control
{
	// default style class
	public override var styleClass = "xcalendarpicker";

	// ===========================================================================================
	// variables

	override var skin = XCalendarPickerSkinControls{ };
    public-read var pickerSkin = bind skin as XCalendarPickerSkin;
    public-read var pickerBehavior = bind skin.behavior as XCalendarPickerBehavior;

	// selection mode
	public var mode = MODE_SINGLE
	on replace
	{
		//println("mode on replace: set to {mode}");
		calendars = [java.util.Calendar.getInstance()];
	}
	;

	// is null allowed for the calendar variable?
	public var nullAllowed : Boolean = true
	on replace
	{
		//println("nullAllowed on replace: set to {mode}");
		if (not nullAllowed and calendar == null) 
		{
			calendar = java.util.Calendar.getInstance();
			(skin as XCalendarPickerSkin).refresh_calendar();
		}
	}
	;
	
    // the selected calendar
	// this value can be null depending on the value of nullAllowed
	public var calendar : java.util.Calendar // is set by the on replace trigger on mode = java.util.Calendar.getInstance()
	on replace
	{
		//XCalendarPickerSkinControls.printlnCalendar("calendar on replace: set to", calendar);
		// if the calendar is not present in calendars
		if (calendar != null and calendars != null and Sequences.indexOf(calendars, calendar) < 0) // not found
		{
			// modify the range
			//XCalendarPickerSkinControls.printlnCalendar("calendar on replace: updating range", calendar);
			calendars = [calendar];
			(skin as XCalendarPickerSkin).refresh_calendar();
		}

		// remember the last one, so we know what the first-day-of-week is
		if (calendar != null) calendarForConfig = calendar;
	};
	public-read var calendarForConfig : java.util.Calendar;

	// the calendars
	// the collection can contain one or more calendars but also none
	public var calendars : java.util.Calendar[] // is set be the on replace trigger on calendar = [java.util.Calendar.getInstance()]
	on replace
	{
		//println("calendars on replace: set to {sizeof calendars}");
		// check if the calendar is a valid sequence, if not make it a sequence of one
		if (sizeof calendars == 0) { calendar = null; }
		// check if the calendar is present in calendars
		else
		{
			// if the calendar is not present in calendars
			if ( calendar == null
			  or (calendar != null and calendars != null and Sequences.indexOf(calendars, calendar) < 0) // not found
			   )
			{
				// set calendar to the first value in the range
				calendar = calendars[0];
				(skin as XCalendarPickerSkin).refresh_calendar();
			}
		}
	};
	
	// the locale under which we are running
	public var locale : java.util.Locale = java.util.Locale.getDefault()
	on replace { if (locale == null) throw new java.lang.IllegalArgumentException("Null not allowed"); }
	;

	// ===========================================================================================
	// logic

	/**
	 * determine if a date is selected
	 */
	public function isSelected(calendar : java.util.Calendar) : Boolean
	{
		// null is always false
		if (calendar == null) return false;

		// determine
		var lYear = calendar.get(java.util.Calendar.YEAR);
		var lMonth = calendar.get(java.util.Calendar.MONTH);
		var lDay = calendar.get(java.util.Calendar.DATE);

		// scan all
		for (c in calendars)
		{
			// determine
			var lControlYear = c.get(java.util.Calendar.YEAR);
			var lControlMonth = c.get(java.util.Calendar.MONTH);
			var lControlDay = c.get(java.util.Calendar.DATE);

			// determine
			var lFound = (lControlYear == lYear and lControlMonth == lMonth and lControlDay == lDay);
			if (lFound == true) return true;
		}

		// not found
		return false;
	}


	// ===========================================================================================
	// control
	
	init
	{
	}

	override function getMinHeight() : Number
	{
		return skin.getMinHeight();
	}	
	override function getMinWidth() : Number
	{
		return skin.getMinWidth();
	}	
	override function getPrefHeight(width : Number) : Number
	{
		return getMinHeight();
	}	
	override function getPrefWidth(height : Number) : Number
	{
		return getMinWidth();
	}
}

