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


/**
 * @author Tom Eugelink
 */
public class XCalendarPickerBehavior extends javafx.scene.control.Behavior
{
	public function select(calendar : java.util.Calendar, range : Boolean, extend : Boolean, requestFocus : Boolean)
	{
		//XCalendarPickerSkinControls.printlnCalendar("select", calendar);
		var lControl = (skin.control as XCalendarPicker);

		// for a range determine start and end
		var lStart : java.util.Calendar = if (lControl.calendar != null and lControl.calendar.before(calendar)) lControl.calendar else calendar;
		var lEnd : java.util.Calendar = if (lControl.calendar == null or lControl.calendar.before(calendar)) calendar else lControl.calendar;
		lStart = lStart.clone() as java.util.Calendar;
		
		// Single
		if ( lControl.mode == XCalendarPicker.MODE_SINGLE )
		{
			// if already present
			if (Sequences.indexOf(lControl.calendars, calendar) >= 0) // found
			{
				// remove
				if (lControl.nullAllowed) lControl.calendars = [];
			}
			else
			{
				// set one value
				lControl.calendars = [calendar];
			}
		}

		// range or multiple without extend active
		if ( (lControl.mode == XCalendarPicker.MODE_RANGE)
		  or (lControl.mode == XCalendarPicker.MODE_MULTIPLE and extend == false)
		   )
		{
			if (range == false) 
			{
				// if already present and only a range of one
				if (sizeof(lControl.calendars) == 1 and Sequences.indexOf(lControl.calendars, calendar) >= 0) // found
				{
					// remove
					if (lControl.nullAllowed) lControl.calendars = [];
				}
				else
				{
					// set one value
					lControl.calendars = [calendar];
				}
			}
			else
			{
				// add all dates to a new range
				var lSequence : java.util.Calendar[] = [];
				while (lStart.before(lEnd) or lStart.equals(lEnd))
				{
					var lCalendar = lStart.clone() as java.util.Calendar;
					insert lCalendar into lSequence;
					lStart.add(java.util.Calendar.DATE, 1);
				}
				lControl.calendars = lSequence;
				lControl.calendar = calendar;
			}
		}

		// multiple with extend active
		if ( lControl.mode == XCalendarPicker.MODE_MULTIPLE and extend == true)
		{
			if (range == false)
			{
				// if already present and only a range of one
				if (sizeof(lControl.calendars) == 1 and Sequences.indexOf(lControl.calendars, calendar) >= 0) // found
				{
					// remove
					if (lControl.nullAllowed) lControl.calendars = [];
				}
				// if already present
				else if (Sequences.indexOf(lControl.calendars, calendar) >= 0) // found
				{
					// remove
					delete calendar from lControl.calendars;
				}
				else
				{
					// add one value
					insert calendar into lControl.calendars;
					lControl.calendar = calendar;
				}
			}
			else if (range == true)
			{
				// add all dates to the range
				while (lStart.before(lEnd) or lStart.equals(lEnd))
				{
					// if the calendar is not present in calendars
					if (Sequences.indexOf(lControl.calendars, lStart) < 0) // not found
					{
						var lCalendar = lStart.clone() as java.util.Calendar;
						insert lCalendar into lControl.calendars;
					}
					lStart.add(java.util.Calendar.DATE, 1);
				}
				lControl.calendar = calendar;
			}
		}

		// handle focus
		if (not skin.control.focused and requestFocus) skin.control.requestFocus();

		// always force refresh
		(skin as XCalendarPickerSkin).refresh_selection();
	}
}