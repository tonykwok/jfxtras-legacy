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
import javafx.scene.layout.*;
import org.jfxtras.scene.control.*;
import javafx.geometry.Insets;
import javafx.scene.effect.Reflection;

/**
*/
var calendarPicker1 = XCalendarPicker{
	mode: XCalendarPicker.MODE_MULTIPLE
	skin: XCalendarPickerSkinControls{}
	effect: Reflection{topOpacity:0.3}
	layoutInfo: LayoutInfo{margin: Insets{top:10, left:10}}
};
var calendarPicker2 = XCalendarPicker{ 
	skin: XCalendarPickerSkinLight{}
	effect: Reflection{topOpacity:0.3}
	layoutInfo: LayoutInfo{margin: Insets{top:10, left:10}}
};
(calendarPicker2.skin as XCalendarPickerSkinLight).setCaspianScheme();

var calendar1 = bind calendarPicker1.calendar on replace { calendarPicker2.calendar = calendarPicker1.calendar; };
var calendar2 = bind calendarPicker2.calendar on replace { calendarPicker1.calendar = calendarPicker2.calendar; };

Stage {
	title: "XCalendarPicker skins side by side"
	scene: javafx.scene.Scene {
		width: 800
		height: 600
		content: [
			HBox {
				content: [calendarPicker1, calendarPicker2]				
			}
		]
    }
}
