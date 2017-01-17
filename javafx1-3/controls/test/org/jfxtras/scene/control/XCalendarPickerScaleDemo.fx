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

import javafx.scene.shape.*;
import javafx.stage.*;
import javafx.scene.layout.*;
import javafx.scene.paint.*;
import javafx.scene.control.*;
import org.jfxtras.scene.control.*;

/**
Test if the control scales up correctly.
TODO: light skin does not scale correctly
*/
//var calendarPicker = XCalendarPicker{ layoutInfo: LayoutInfo { hfill:true vfill:true } };
//var calendarPicker = XCalendarPicker{ skin: XCalendarPickerSkinControls{}, layoutInfo: LayoutInfo { hfill:true vfill:true } };
var calendarPicker = XCalendarPicker{ skin: XCalendarPickerSkinLight{}, layoutInfo: LayoutInfo { hfill:true vfill:true } };
	
var stage: Stage = Stage {
     title: "Test if picker scales up"
    scene: org.jfxtras.scene.XScene {
       width: 800
      height: 600
      content: [calendarPicker]
    }
  }

/* 
println( "calendarPicker.layoutBounds: {calendarPicker.layoutBounds}" );
println( "calendarPicker.boundsInLocal: {calendarPicker.boundsInLocal}" );
println( "calendarPicker.boundsInParent: {calendarPicker.boundsInParent}" );

var lb = bind calendarPicker.layoutBounds on replace {
    println( "layoutBounds: {lb}" );
  }
var bl = bind calendarPicker.boundsInLocal on replace {
    println( "boundsInLocal: {bl}" );
  }
var bp = bind calendarPicker.boundsInParent on replace {
    println( "boundsInParent: {bp}" );
  }
*/

var w = bind calendarPicker.width on replace {
    println( "width {w}" );
  }
var h = bind calendarPicker.height on replace {
    println( "height {h}" );
  }