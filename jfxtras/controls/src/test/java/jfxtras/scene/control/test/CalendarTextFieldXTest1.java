/**
 * Copyright (c) 2011, JFXtras
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *     * Redistributions of source code must retain the above copyright
 *       notice, this list of conditions and the following disclaimer.
 *     * Redistributions in binary form must reproduce the above copyright
 *       notice, this list of conditions and the following disclaimer in the
 *       documentation and/or other materials provided with the distribution.
 *     * Neither the name of the <organization> nor the
 *       names of its contributors may be used to endorse or promote products
 *       derived from this software without specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */
package jfxtras.scene.control.test;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.GregorianCalendar;

import javafx.application.Application;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.layout.VBox;
import javafx.stage.Stage;
import jfxtras.scene.control.CalendarTextFieldX;

/**
 * @author Tom Eugelink
 */
public class CalendarTextFieldXTest1 extends Application {
	
    public static void main(String[] args) {
    	//java.util.Locale.setDefault(new java.util.Locale("de")); // weeks starts on monday
    	jfxtras.application.Application.prelaunch();
        launch(args);       
    }

	@Override
	public void start(Stage stage) {

		// a layout
		VBox lVBox = new VBox();
		
        // add a node
		CalendarTextFieldX lCalendarTextFieldX = new CalendarTextFieldX();
		lCalendarTextFieldX.valueProperty().set(new GregorianCalendar(2011, 2, 01)); // set a value
		lVBox.getChildren().add(lCalendarTextFieldX);
        
		// button
		Button lButton = new Button("test");
		lVBox.getChildren().add(lButton);
		
        // create scene
        Scene scene = new Scene(lVBox, 350, 100);

        // create stage
        stage.setTitle("CalendarTextBoxX");
        stage.setScene(scene);
        stage.show();
    }
	
	/*
	 * 
	 */
	static protected String quickFormatCalendar(Calendar value)
	{
		SimpleDateFormat lSimpleDateFormat = (SimpleDateFormat)SimpleDateFormat.getDateInstance(SimpleDateFormat.LONG);
		lSimpleDateFormat.applyPattern("yyyy-MM-dd");
		return value == null ? "null" : lSimpleDateFormat.format(value.getTime());
	}

}
