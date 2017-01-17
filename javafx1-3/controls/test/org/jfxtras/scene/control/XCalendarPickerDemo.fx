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

import javafx.stage.*;
import javafx.scene.*;
import javafx.scene.control.*;
import javafx.scene.layout.*;
import javafx.scene.effect.Reflection;

// the picker
var calendarPicker = XCalendarPicker
{
	//calendar: java.util.Calendar.getInstance( java.util.Locale.FRANCE ); // first day of week is Mon
	//calendar: java.util.Calendar.getInstance( java.util.Locale.ENGLISH ); // first day of week is Sun
	//calendar: new java.util.GregorianCalendar(2009, 7, 13);  // has 5 weeks

	//locale: java.util.Locale.FRENCH

	//mode: XCalendarPicker.MODE_RANGE
	//mode: XCalendarPicker.MODE_MULTIPLE	
};


// mode
var modePicker : ChoiceBox = ChoiceBox
{ items: [ "SINGLE", "RANGE",  "MULTIPLE"]
};
modePicker.select(0);
var modeSelectedIndex = bind modePicker.selectedIndex // on change event
on replace
{
	// update the calendar
	if (modeSelectedIndex == 0) calendarPicker.mode = XCalendarPicker.MODE_SINGLE;
	if (modeSelectedIndex == 1) calendarPicker.mode = XCalendarPicker.MODE_RANGE;
	if (modeSelectedIndex == 2) calendarPicker.mode = XCalendarPicker.MODE_MULTIPLE;
};

// locales
var localePicker : ChoiceBox = ChoiceBox
{	items: []
};
insert "" into localePicker.items;
for ( lLocale in java.util.Locale.getAvailableLocales() )
{
	insert lLocale.getDisplayName() into localePicker.items;
}
localePicker.items = javafx.util.Sequences.sort(localePicker.items as java.lang.Comparable[]);
localePicker.select(0);
var localeSelectedItem = bind localePicker.selectedItem 
on replace // on change event
{
	// update the calendar
	for ( lLocale in java.util.Locale.getAvailableLocales() )
	{
		if (lLocale.getDisplayName().equals( localeSelectedItem ))
		{
			calendarPicker.calendar = java.util.Calendar.getInstance(lLocale);
			calendarPicker.locale = lLocale;
		}
	}
};

// skin
var skinPicker : ChoiceBox = ChoiceBox
{	items: [ "Light", "Control"]
};
var skinPickerIndex = bind skinPicker.selectedIndex // on change event
on replace
{
	// update the calendar
	if (skinPickerIndex == 0) // light
	{
		calendarPicker.skin = XCalendarPickerSkinLight{};
		schemePicker.visible = true;
		schemePicker.select(0);
		(calendarPicker.skin as XCalendarPickerSkinLight).setCaspianScheme();
		calendarPicker.effect = Reflection{};
	}
	if (skinPickerIndex == 1) // control
	{
		calendarPicker.skin = XCalendarPickerSkinControls{};
		schemePicker.visible = false;
		calendarPicker.effect = null;
	}
};
skinPicker.select(1);

// mode
var schemePicker : ChoiceBox = ChoiceBox
{	items: [ "Caspian", "Gray"]
};
schemePicker.select(0);
var schemePickerIndex = bind schemePicker.selectedIndex // on change event
on replace
{
	// update
	if (skinPicker.selectedIndex == 0)
	{
		if (schemePickerIndex == 0) (calendarPicker.skin as XCalendarPickerSkinLight).setCaspianScheme();
		if (schemePickerIndex == 1) (calendarPicker.skin as XCalendarPickerSkinLight).setGreyScheme();
	}
};

// is null allowed
var nullAllowedCheckbox : CheckBox = CheckBox
{ selected: calendarPicker.nullAllowed
}
;
var nullAllowedSelected : Boolean = bind nullAllowedCheckbox.selected
on replace
{
	calendarPicker.nullAllowed = nullAllowedSelected;
}
;

// show weeknumbers
//var showWeeknumbersCheckbox : CheckBox = CheckBox {
//	selected: (calendarPicker.skin as XCalendarPickerSkinAbstract).showWeeknumbers
//};
//var showWeeknumbersSelected : Boolean = bind showWeeknumbersCheckbox.selected
//on replace {
//	(calendarPicker.skin as XCalendarPickerSkinAbstract).showWeeknumbers = showWeeknumbersSelected;
//};

// current picker value
var currentCalendarTextBox = TextBox{editable: false};
var currentCalendar = bind calendarPicker.calendar
on replace
{
	var c = calendarPicker.calendar;
	if (c == null) { currentCalendarTextBox.text = "null"; }
	else { currentCalendarTextBox.text = "{c.get(java.util.Calendar.YEAR)}-{c.get(java.util.Calendar.MONTH) + 1}-{c.get(java.util.Calendar.DATE)}"; }
};
var currentCalendarsTextBox = TextBox{editable: false};
var currentCalendars = bind calendarPicker.calendars
on replace
{
	var c = calendarPicker.calendars;
	currentCalendarsTextBox.text = "{sizeof(c)}";
};

// stage
Stage
{
	width: 800;
	height: 700;
	scene: Scene
	{
		///stylesheets: ["{__DIR__}style.css"],
		content:
		[	VBox
			{
				content:
				[	Tile
					{
						columns: 2
						content:
						[	Label {text: "Null allowed"}, nullAllowedCheckbox
						,	Label {text: "Select locale"}, localePicker
						,	Label {text: "Select mode"}, modePicker
						,	Label {text: "Select skin"}, skinPicker
						,	Label {text: ""}, Label {text: "Switching to the light skin has some initial animation artifacts;"}
						,	Label {text: ""}, Label {text: "the skin was not designed to be hotswappable"}
//						,	Label {text: "Show weeknumbers"}, showWeeknumbersCheckbox
						,	Label {text: "Select scheme"}, schemePicker
						,	Label {text: "Current picker value"}, currentCalendarTextBox
						,	Label {text: "Number of selected dates"}, currentCalendarsTextBox
						]
					}
				,	Label { layoutInfo: LayoutInfo{height: 50} }
				,	calendarPicker
				]
			}
		]
	}

}

