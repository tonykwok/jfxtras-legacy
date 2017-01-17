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
package jfxtras.scene.control;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.atomic.AtomicInteger;

import javafx.beans.property.BooleanProperty;
import javafx.beans.value.ChangeListener;
import javafx.beans.value.ObservableValue;
import javafx.collections.ListChangeListener;
import javafx.event.EventHandler;
import javafx.geometry.Pos;
import javafx.scene.control.Label;
import javafx.scene.control.ToggleButton;
import javafx.scene.layout.ColumnConstraints;
import javafx.scene.layout.GridPane;
import javafx.scene.layout.Priority;
import jfxtras.scene.control.SpinnerX.CycleEvent;

/**
 * This skin uses regular JavaFX controls
 * @author Tom Eugelink
 *
 */
public class CalendarPickerXControlSkin extends CalendarPickerXMonthlySkinAbstract<CalendarPickerXControlSkin>
{
	// ==================================================================================================================
	// CONSTRUCTOR
	
	/**
	 * 
	 */
	public CalendarPickerXControlSkin(CalendarPickerX control)
	{
		super(control);
		construct();
	}

	/*
	 * construct the component
	 */
	private void construct()
	{
		// setup component
		createNodes();
		
		// start listening to changes
		// if the calendar changes, the display calendar will jump to show that
		getSkinnable().calendarProperty().addListener(new ChangeListener<Calendar>()  
		{
			@Override
			public void changed(ObservableValue<? extends Calendar> observable, Calendar oldValue, Calendar newValue)
			{
				if (newValue != null) {
					setDisplayedCalendar(newValue);
				}
			} 
		});
		if (getSkinnable().getCalendar() != null) {
			setDisplayedCalendar(getSkinnable().getCalendar());
		}
		
		// if the calendars change, the selection must be refreshed
		getSkinnable().calendars().addListener(new ListChangeListener<Calendar>()  
		{
			@Override
			public void onChanged(javafx.collections.ListChangeListener.Change<? extends Calendar> arg0)
			{
				refreshSelection();
			} 
		});
		
		// if the displayed calendar changes, the screen must be refreshed
		displayedCalendar().addListener(new ChangeListener<Calendar>()  
		{
			@Override
			public void changed(ObservableValue<? extends Calendar> observable, Calendar oldValue, Calendar newValue)
			{
				refresh();
			} 
		});
		
		// update the data
		refresh();
	}
	
	// ==================================================================================================================
	// PROPERTIES
	

	// ==================================================================================================================
	// DRAW
	
	/**
	 * construct the nodes
	 */
	private void createNodes()
	{
		// the result
		GridPane lGridPane = new GridPane();
		lGridPane.setVgap(2.0);
		lGridPane.setHgap(2.0);
		
		// setup the grid so all weekday togglebuttons will grow, but the weeknumbers do not
		ColumnConstraints lColumnConstraintsAlwaysGrow = new ColumnConstraints();
		lColumnConstraintsAlwaysGrow.setHgrow(Priority.ALWAYS);
		ColumnConstraints lColumnConstraintsNeverGrow = new ColumnConstraints();
		lColumnConstraintsNeverGrow.setHgrow(Priority.NEVER);
		lGridPane.getColumnConstraints().addAll(lColumnConstraintsNeverGrow, lColumnConstraintsAlwaysGrow, lColumnConstraintsAlwaysGrow, lColumnConstraintsAlwaysGrow, lColumnConstraintsAlwaysGrow, lColumnConstraintsAlwaysGrow, lColumnConstraintsAlwaysGrow, lColumnConstraintsAlwaysGrow);

		// month spinner
		List<String> lMonthLabels = getMonthLabels();
		monthXSpinner = new SpinnerX<String>(lMonthLabels).withIndex(Calendar.getInstance().get(Calendar.MONTH)).withCyclic(Boolean.TRUE);
		// on cycle overflow to year
		monthXSpinner.setOnCycle(new EventHandler<SpinnerX.CycleEvent>()
		{
			@Override
			public void handle(CycleEvent evt)
			{
				// if we've cycled down
				if (evt.cycledDown()) 
				{
					yearXSpinner.increment();
				}
				else 
				{
					yearXSpinner.decrement();				
				}
					 
			}
		});
		// if the value changed, update the displayed calendar
		monthXSpinner.valueProperty().addListener(new ChangeListener<String>()
		{
			@Override
			public void changed(ObservableValue arg0, String arg1, String arg2)
			{
				setDisplayedCalendarFromSpinners();
			}
		});
		lGridPane.add(monthXSpinner, 0, 0, 5, 1); // col, row, hspan, vspan
		
		// year spinner
		yearXSpinner = new SpinnerX<Integer>(new SpinnerXIntegerList()).withValue(Calendar.getInstance().get(Calendar.YEAR));
		// if the value changed, update the displayed calendar
		yearXSpinner.valueProperty().addListener(new ChangeListener<Integer>()
		{
			@Override
			public void changed(ObservableValue arg0, Integer oldValue, Integer newValue)
			{
				setDisplayedCalendarFromSpinners();
			}
		});
		lGridPane.add(yearXSpinner, 5, 0, 3, 1); // col, row, hspan, vspan
		
		// weekday labels
		for (int i = 0; i < 7; i++)
		{
			// create buttons
			Label lLabel = new Label("" + i);
			// style class is set together with the label
			lLabel.setAlignment(Pos.CENTER);
			
			// add it
			lGridPane.add(lLabel, i + 1, 1);  // col, row
			
			// remember it
			weekdayLabels.add(lLabel);
			lLabel.setAlignment(Pos.BASELINE_CENTER); // TODO: not working
		}
		
		// weeknumber labels
		for (int i = 0; i < 6; i++)
		{
			// create buttons
			Label lLabel = new Label("" + i);
			lLabel.getStyleClass().add("weeknumber");
			lLabel.setAlignment(Pos.BASELINE_RIGHT);
			
			// remember it
			weeknumberLabels.add(lLabel);

			// first of a row: add the weeknumber
			lGridPane.add(weeknumberLabels.get(i), 0, i + 2);  // col, row
		}
		
		// setup: 6 rows of 7 days per week (which is the maximum number of buttons required in the worst case layout)
		for (int i = 0; i < 6 * 7; i++)
		{
			// create buttons
			ToggleButton lToggleButton = new ToggleButton("" + i);
			lToggleButton.getStyleClass().add("day");
			lToggleButton.selectedProperty().addListener(dayToggleButtonSelectedPropertyChangeListener);
			
			// remember which bean belongs to this property
			booleanPropertyToDayToggleButtonMap.put(lToggleButton.selectedProperty(), lToggleButton);
			
			// add it
			lGridPane.add(lToggleButton, (i % 7) + 1, (i / 7) + 2);  // col, row
			lToggleButton.setMaxWidth(Double.MAX_VALUE); // make the button grow to fill a GridPane's cell
			lToggleButton.setAlignment(Pos.BASELINE_CENTER);
			
			// remember it
			dayButtons.add(lToggleButton);
		}

		// add to self
		this.getStyleClass().add(this.getClass().getSimpleName()); // always add self as style class, because CSS should relate to the skin not the control
		getChildren().add(lGridPane);
	}
	private SpinnerX<String> monthXSpinner = null;
	private SpinnerX<Integer> yearXSpinner = null;
	final private List<Label> weekdayLabels = new ArrayList<Label>();
	final private List<Label> weeknumberLabels = new ArrayList<Label>();
	final private List<ToggleButton> dayButtons = new ArrayList<ToggleButton>();
	final private Map<BooleanProperty, ToggleButton> booleanPropertyToDayToggleButtonMap = new HashMap<BooleanProperty, ToggleButton>();
	final private ChangeListener<Boolean> dayToggleButtonSelectedPropertyChangeListener = new ChangeListener<Boolean>()
	{
		@Override
		public void changed(ObservableValue<? extends Boolean> observableValue, Boolean oldValue, Boolean newValue)		
		{
			// if we're refreshing, do not react to changes
			if (iRefreshingSelection.get() > 0) return;
			
			// selected or deselected
			boolean lSelected = newValue;
			
			// base reference
			ToggleButton lToggleButton = booleanPropertyToDayToggleButtonMap.get(observableValue);
			int lDayToggleButtonIdx = dayButtons.indexOf(lToggleButton);
			
			// calculate the day-of-month
			int lFirstOfMonthIdx = determineFirstOfMonthDayOfWeek();
			int lDayOfMonth = lDayToggleButtonIdx - lFirstOfMonthIdx + 1;
	
			// create calendar representing the date that was toggled
			Calendar lToggledCalendar = (Calendar)getDisplayedCalendar().clone();
			lToggledCalendar.set(Calendar.YEAR, getDisplayedCalendar().get(Calendar.YEAR));
			lToggledCalendar.set(Calendar.MONTH, getDisplayedCalendar().get(Calendar.MONTH));
			lToggledCalendar.set(Calendar.DATE, lDayOfMonth);
	
			// add or remove?
			List<Calendar> lCalendars = getSkinnable().calendars();
			if (lSelected) 
			{
				// only add if not present
				if (!lCalendars.contains(lToggledCalendar)) 
				{
					lCalendars.add(lToggledCalendar);
				}
				// make sure it adheres to the mode
				// SINGLE: clear all but the last selected
				while (getSkinnable().getMode() == CalendarPickerX.Mode.SINGLE && lCalendars.size() > 1) 
				{
					lCalendars.remove(0);
				}
				// TODO: range
			}
			else 
			{
				// only remove when present
				if (lCalendars.contains(lToggledCalendar)) 
				{
					lCalendars.remove(lToggledCalendar);
				}
			}	
		}
	};

	/*
	 * 
	 */
	private void setDisplayedCalendarFromSpinners()
	{
		// get spinner values
		int lYear = yearXSpinner.getValue().intValue();
		int lMonth = monthXSpinner.getIndex();
		
		// get new calendar to display
		Calendar lCalendar = (Calendar)getDisplayedCalendar().clone();
		lCalendar.set(Calendar.YEAR, lYear);
		lCalendar.set(Calendar.MONTH, lMonth);
		
		// set it
		setDisplayedCalendar(lCalendar);
	}
	
	
	/**
	 * refresh all
	 */
	private void refresh()
	{
		refreshSpinner();
		refreshWeekdayLabels();
		refreshWeeknumberLabels();
		refreshDayButtons();
		refreshSelection();
	}
	
	/*
	 * 
	 */
	private void refreshSpinner()
	{
		// get calendar
		Calendar lCalendar = (Calendar)getDisplayedCalendar();

		// get the value for the corresponding index and set that
		List<String> lMonthLabels = getMonthLabels();
		String lMonthLabel = lMonthLabels.get( lCalendar.get(Calendar.MONTH) ); 
		monthXSpinner.setValue( lMonthLabel );
		
		// set value
		yearXSpinner.setValue(lCalendar.get(Calendar.YEAR));
		
	}
	
	/*
	 * 
	 */
	private void refreshWeekdayLabels()
	{
		// get labels
		List<String> lWeekdayLabels = getWeekdayLabels();
		
		// set them
		for (int i = 0; i < weekdayLabels.size(); i++)
		{
			Label lLabel = weekdayLabels.get(i);
			lLabel.setText( lWeekdayLabels.get(i) );
			lLabel.getStyleClass().remove("weekend");
			lLabel.getStyleClass().remove("weekday");
			lLabel.getStyleClass().add(isWeekdayWeekend(i) ? "weekend" : "weekday"); 
		}
	}
	
	/*
	 * 
	 */
	private void refreshWeeknumberLabels()
	{
		// get labels
		List<Integer> lWeeknumbers = getWeeknumbers();
		
		// set them
		for (int i = 0; i < lWeeknumbers.size(); i++)
		{
			weeknumberLabels.get(i).setText( (lWeeknumbers.get(i).intValue() < 10 ? "0" : "") + lWeeknumbers.get(i).toString() );
		}
	}
	
	/*
	 * 
	 */
	private void refreshDayButtons()
	{
		// setup the buttons [0..(6*7)-1]
		// displayed calendar always points to the 1st of the month
		int lFirstOfMonthIdx = determineFirstOfMonthDayOfWeek();

		// hide the preceeding buttons
		for (int i = 0; i < lFirstOfMonthIdx; i++)
		{
			dayButtons.get(i).setVisible(false);
		}
		// make all weeklabels invisible
		for (int i = 1; i < 6; i++)
		{
			weeknumberLabels.get(i).setVisible(false);
		}
		
		// set the month buttons
		int lDaysInMonth = determineDaysInMonth();
		Calendar lCalendar = (Calendar)getDisplayedCalendar().clone();
		for (int i = 1; i <= lDaysInMonth; i++)
		{
			// set the date
			lCalendar.set(java.util.Calendar.DATE, i);

			// determine the index in the buttons
			int lIdx = lFirstOfMonthIdx + i - 1;

			// update the button
			ToggleButton lToggleButton = dayButtons.get(lIdx); 
			lToggleButton.setVisible(true);
			lToggleButton.setText("" + i);
			lToggleButton.getStyleClass().remove("weekend");
			lToggleButton.getStyleClass().remove("weekday");
			lToggleButton.getStyleClass().add(isWeekdayWeekend(lIdx % 7) ? "weekend" : "weekday"); 

			// make the corresponding weeklabel visible
			weeknumberLabels.get(lIdx / 7).setVisible(true);

			// highlight today
			if (isToday(lCalendar))
			{
				lToggleButton.getStyleClass().add("today");
			}	
			else
			{
				lToggleButton.getStyleClass().remove("today");
			}
		}

		// hide the trailing buttons
		for (int i = lFirstOfMonthIdx + lDaysInMonth; i < 6*7; i++)
		{
			dayButtons.get(i).setVisible(false);
		}
	}

	/*
	 * 
	 */
	private void refreshSelection()
	{
		iRefreshingSelection.addAndGet(1);
		try
		{
			// setup the buttons [0..(6*7)-1]
			// displayed calendar always points to the 1st of the month
			int lFirstOfMonthIdx = determineFirstOfMonthDayOfWeek();
			List<Calendar> lCalendars = getSkinnable().calendars();
			
			// set the month buttons
			int lDaysInMonth = determineDaysInMonth();
			Calendar lCalendar = (Calendar)getDisplayedCalendar().clone();
			for (int i = 1; i <= lDaysInMonth; i++)
			{
				// set the date
				lCalendar.set(java.util.Calendar.DATE, i);
	
				// determine the index in the buttons
				int lIdx = lFirstOfMonthIdx + i - 1;
	
				// is selected
				boolean lSelected = lCalendars.contains(lCalendar);
				dayButtons.get(lIdx).setSelected( lSelected );
			}
		}
		finally
		{
			iRefreshingSelection.addAndGet(-1);
		}
	}
	final private AtomicInteger iRefreshingSelection = new AtomicInteger(0);
}
