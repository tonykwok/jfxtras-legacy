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

import java.util.Arrays;

import javafx.beans.property.ObjectProperty;
import javafx.beans.property.SimpleObjectProperty;
import javafx.beans.value.ChangeListener;
import javafx.beans.value.ObservableValue;
import javafx.collections.FXCollections;
import javafx.collections.ListChangeListener;
import javafx.collections.ObservableList;
import javafx.event.Event;
import javafx.event.EventHandler;
import javafx.event.EventTarget;
import javafx.event.EventType;
import javafx.scene.Node;
import javafx.scene.control.Control;
import javafx.scene.control.Label;
import javafx.util.Callback;
import javafx.util.StringConverter;

/**
 * This is a spinner, showing one value at a time.
 * Basically a spinner shows a list of values and can do "next" or "previous" on this.
 * SpinnerX has some convenience constructors.
 * 
 * SpinnerX can be editable, the user can then type a value instead of selecting it.
 * If the value exists in the list, the spinner will simply jump to it. 
 * If the value does not exist, if defined the AddCallback is called.
 * - If the AddCallback returns null, spinner will refresh showing the selected index
 * - If the AddCallback returns an Integer, spinner will jump to that index (usually the index where the new value was added).   
 * 
 * @author Tom Eugelink
 */
public class SpinnerX<T> extends Control
{
	// ==================================================================================================================
	// CONSTRUCTOR

	/**
	 */
	public SpinnerX()
	{
		construct();
	}

	// ------------
	// model
	
	/**
	 * @param model
	 * @param startValue
	 */
	public SpinnerX(ObservableList<T> items)
	{
		construct();
		setItems(items);
		first();
	}

	/**
	 * @param model
	 * @param startValue
	 */
	public SpinnerX(ObservableList<T> items, T startValue)
	{
		construct();
		setItems(items);
		setValue(startValue);
	}

	// ------------
	// convenience
	
	/**
	 * 
	 * @param list
	 */
	public SpinnerX(java.util.List<T> list)
	{
		this( FXCollections.observableList(list) );
	}

	/**
	 * 
	 * @param list
	 */
	public SpinnerX(T... list)
	{
		this( Arrays.asList(list) );
	}

	// ------------
	
	/*
	 * 
	 */
	private void construct()
	{
		// setup the CSS
		// the -fx-skin attribute in the CSS sets which Skin class is used
		this.getStyleClass().add(this.getClass().getSimpleName().toLowerCase());
		
		// react to changes of the value
		this.valueObjectProperty.addListener(new ChangeListener<T>()
		{
			@Override
			public void changed(ObservableValue<? extends T> property, T oldValue, T newValue)
			{
				// get the value of the new index
				int lIdx = getItems().indexOf(newValue);
				
				// set the value
				if (SpinnerX.equals(indexObjectProperty.getValue(), lIdx) == false)
				{
					indexObjectProperty.setValue(lIdx);
				}
			}
		});
		
		// react to changes of the index
		this.indexObjectProperty.addListener(new ChangeListener<Integer>()
		{
			@Override
			public void changed(ObservableValue<? extends Integer> property, Integer oldIndex, Integer newIndex)
			{
				// get the value of the new index
				T lValue = newIndex < 0 ? null : getItems().get(newIndex);
				
				// set the value
				if (SpinnerX.equals(valueObjectProperty.getValue(), lValue) == false)
				{
					valueObjectProperty.setValue(lValue);
				}
			}
		});
		
		// react to changes of the items
		this.itemsObjectProperty.addListener(new ChangeListener<ObservableList<T>>()
		{
			@Override
			public void changed(ObservableValue<? extends ObservableList<T>> property, ObservableList<T> oldList, ObservableList<T> newList)
			{
				if (oldList != null) oldList.removeListener(listChangeListener);
				if (newList != null) newList.addListener(listChangeListener);
			}
		});
	}
	
	/*
	 * react to observable list changes
	 * TODO: what is sticky, index or value? Now: index
	 */
	private ListChangeListener<T> listChangeListener = new ListChangeListener<T>()
	{
		@Override
		public void onChanged(javafx.collections.ListChangeListener.Change<? extends T> change)
		{
			// get current index
			int lIndex = getIndex();
			
			// is it still valid?
			if (lIndex >= getItems().size()) 
			{
				lIndex = getItems().size() - 1;
				setIndex(lIndex);
				return;
			}
			
			// (re)set the value of the index
			valueObjectProperty.setValue( getItems().get(lIndex) );
		}
	};

	/**
	 * Return the path to the CSS file so things are setup right
	 */
	@Override protected String getUserAgentStylesheet()
	{
		return this.getClass().getResource(this.getClass().getSimpleName() + ".css").toString();
	}
	
	// ==================================================================================================================
	// PROPERTIES
	
	/** Value: */
	public ObjectProperty<T> valueProperty() { return this.valueObjectProperty; }
	final private ObjectProperty<T> valueObjectProperty = new SimpleObjectProperty<T>(this, "value", null);
	// java bean API
	public T getValue() { return this.valueObjectProperty.getValue(); }
	public void setValue(T value) { this.valueObjectProperty.setValue(value); }
	public SpinnerX<T> withValue(T value) { setValue(value); return this; }
	
	/** Index: */
	public ObjectProperty<Integer> indexProperty() { return this.indexObjectProperty; }
	final private ObjectProperty<Integer> indexObjectProperty = new SimpleObjectProperty<Integer>(this, "index", null);
	// java bean API
	public Integer getIndex() { return this.indexObjectProperty.getValue(); }
	public void setIndex(Integer value) { this.indexObjectProperty.setValue(value); }
	public SpinnerX<T> withIndex(Integer value) { setIndex(value); return this; }
	
	/** Cyclic: */
	public ObjectProperty<Boolean> cyclicProperty() { return this.cyclicObjectProperty; }
	final private ObjectProperty<Boolean> cyclicObjectProperty = new SimpleObjectProperty<Boolean>(this, "cyclic", false);
	// java bean API
	public Boolean isCyclic() { return this.cyclicObjectProperty.getValue(); }
	public void setCyclic(Boolean value) { this.cyclicObjectProperty.setValue(value); }
	public SpinnerX<T> withCyclic(Boolean value) { setCyclic(value); return this; }

	/** Editable: */
	public ObjectProperty<Boolean> editableProperty() { return this.editableObjectProperty; }
	final private ObjectProperty<Boolean> editableObjectProperty = new SimpleObjectProperty<Boolean>(this, "editable", false);
	// java bean API
	public Boolean isEditable() { return this.editableObjectProperty.getValue(); }
	public void setEditable(Boolean value) { this.editableObjectProperty.setValue(value); }
	public SpinnerX<T> withEditable(Boolean value) { setEditable(value); return this; }

	/** Items: */
	public ObjectProperty<ObservableList<T>> itemsProperty() { return this.itemsObjectProperty; }
	final private ObjectProperty<ObservableList<T>> itemsObjectProperty = new SimpleObjectProperty<ObservableList<T>>(this, "items", null);
	// java bean API
	public ObservableList<T> getItems() { return this.itemsObjectProperty.getValue(); }
	public void setItems(ObservableList<T> value) { this.itemsObjectProperty.setValue(value); }
	public SpinnerX<T> withItems(ObservableList<T> value) { setItems(value); return this; }

	/** CellFactory: */
	public ObjectProperty<Callback<SpinnerX<T>, Node>> cellFactoryProperty() { return this.cellFactoryObjectProperty; }
	final private ObjectProperty<Callback<SpinnerX<T>, Node>> cellFactoryObjectProperty = new SimpleObjectProperty<Callback<SpinnerX<T>, Node>>(this, "cellFactory", new DefaultCellFactory());
	// java bean API
	public Callback<SpinnerX<T>, Node> getCellFactory() { return this.cellFactoryObjectProperty.getValue(); }
	public void setCellFactory(Callback<SpinnerX<T>, Node> value) { this.cellFactoryObjectProperty.setValue(value); }
	public SpinnerX<T> withCellFactory(Callback<SpinnerX<T>, Node> value) { setCellFactory(value); return this; }

	/** StringConverter<T>: */
	public ObjectProperty<StringConverter<T>> stringConverterProperty() { return this.stringConverterObjectProperty; }
	final private ObjectProperty<StringConverter<T>> stringConverterObjectProperty = new SimpleObjectProperty<StringConverter<T>>(this, "stringConverter", new DefaultStringConverter());
	// java bean API
	public StringConverter<T> getStringConverter() { return this.stringConverterObjectProperty.getValue(); }
	public void setStringConverter(StringConverter<T> value) { this.stringConverterObjectProperty.setValue(value); }
	public SpinnerX<T> withStringConverter(StringConverter<T> value) { setStringConverter(value); return this; }

	/** ArrowDirection: */
	public ObjectProperty<ArrowDirection> arrowDirectionProperty() { return this.arrowDirectionObjectProperty; }
	final private ObjectProperty<ArrowDirection> arrowDirectionObjectProperty = new SimpleObjectProperty<ArrowDirection>(this, "arrowDirection", ArrowDirection.HORIZONTAL);
	// java bean API
	public ArrowDirection getArrowDirection() { return this.arrowDirectionObjectProperty.getValue(); }
	public void setArrowDirection(ArrowDirection value) { this.arrowDirectionObjectProperty.setValue(value); }
	public SpinnerX<T> withArrowDirection(ArrowDirection value) { setArrowDirection(value); return this; }
	public enum ArrowDirection {VERTICAL, HORIZONTAL}
	
	/** AddCallback: */
	public ObjectProperty<Callback<T, Integer>> addCallbackProperty() { return this.addCallbackObjectProperty; }
	final private ObjectProperty<Callback<T, Integer>> addCallbackObjectProperty = new SimpleObjectProperty<Callback<T, Integer>>(this, "addCallback", null);
	// java bean API
	public Callback<T, Integer> getAddCallback() { return this.addCallbackObjectProperty.getValue(); }
	public void setAddCallback(Callback<T, Integer> value) { this.addCallbackObjectProperty.setValue(value); }
	public SpinnerX<T> withAddCallback(Callback<T, Integer> value) { setAddCallback(value); return this; }

	// ==================================================================================================================
	// StringConverter
	
	/**
	 * A string converter that does a simple toString, but cannot convert to an object
	 * @see org.jfxextras.util.StringConverterFactory 
	 */
	class DefaultStringConverter extends StringConverter<T>
	{
		@Override
		public T fromString(String string)
		{
			throw new IllegalStateException("not implemented");
		}

		@Override
		public String toString(T value)
		{
			return value == null ? "" : value.toString();
		}
	}
	
	// ==================================================================================================================
	// CellFactory
	
	/**
	 * Default cell factory
	 */
	class DefaultCellFactory implements Callback<SpinnerX<T>, Node>
	{
		private Label label = null;
		
		@Override
		public Node call(SpinnerX<T> spinner)
		{
			// get value
			T lValue = spinner.getValue();
			
			// label not yet created
			if (this.label == null) 
			{
				this.label = new Label();
			}
			this.label.setText( lValue == null ? "" : getStringConverter().toString(lValue) );
			return this.label;
		}
	};
	
	// ==================================================================================================================
	// EVENTS
	
	/** OnCycle: */
	public ObjectProperty<EventHandler<CycleEvent>> onCycleProperty() { return iOnCycleObjectProperty; }
	final private ObjectProperty<EventHandler<CycleEvent>> iOnCycleObjectProperty = new SimpleObjectProperty<EventHandler<CycleEvent>>(null);
	// java bean API
	public EventHandler<CycleEvent> getOnCycle() { return iOnCycleObjectProperty.getValue(); }
	public void setOnCycle(EventHandler<CycleEvent> value) { iOnCycleObjectProperty.setValue(value); }
	public SpinnerX<T> withOnCycle(EventHandler<CycleEvent> value) { setOnCycle(value); return this; }
	final static public String ONCYCLE_PROPERTY_ID = "onCycle";
	
	/**
	 * CycleEvent 
	 */
	static public class CycleEvent extends Event
	{
		/**
		 * 
		 */
		public CycleEvent()
		{
			super(new EventType<CycleEvent>());
		}

		/**
		 * 
		 * @param source
		 * @param target
		 */
		public CycleEvent(Object source, EventTarget target)
		{
			super(source, target, new EventType<CycleEvent>());
		}
		
		public Object getOldIdx() { return this.oldIdx; }
		private Object oldIdx;
		
		public Object getNewIdx() { return this.newIdx; }
		private Object newIdx;
		
		
		public boolean cycledDown() { return cycleDirection == CycleDirection.TOP_TO_BOTTOM; }
		public boolean cycledUp() { return cycleDirection == CycleDirection.BOTTOM_TO_TOP; }
		CycleDirection cycleDirection;
	}
	
	/**
	 * we're cycling, fire the event
	 */
	public void fireCycleEvent(CycleDirection cycleDirection)
	{
		EventHandler<CycleEvent> lCycleEventHandler = getOnCycle();
		if (lCycleEventHandler != null)
		{
			CycleEvent lCycleEvent = new CycleEvent();
			lCycleEvent.cycleDirection = cycleDirection;
			lCycleEventHandler.handle(lCycleEvent);
		}
	}
	static public enum CycleDirection { TOP_TO_BOTTOM, BOTTOM_TO_TOP }
	
	
	// ==================================================================================================================
	// BEHAVIOR

	/**
	 * 
	 */
	public void first()
	{
		// nothing to do
		if (getItems() == null || getItems().size() == 0) return;
		
		// set the new index (this will update the value)
		indexObjectProperty.setValue(0);
	}
	
	/**
	 * 
	 */
	public void decrement()
	{
		// nothing to do
		if (getItems() == null || getItems().size() == 0) return;
		
		// get the current index
		int lOldIdx = this.indexObjectProperty.getValue();
					
		// get the previous index (usually current - 1)
		int lIdx = lOldIdx - 1;
		
		// if end
		if (lIdx < 0)
		{
			// if we're not cyclic
			if (isCyclic() != null && isCyclic().booleanValue() == false)
			{
				// do nothing
				return;
			}
			
			// cycle to the other end: get the last value
			lIdx = getItems().size() - 1;
			
			// notify listener that we've cycled
			fireCycleEvent(CycleDirection.BOTTOM_TO_TOP);
		}

		// set the new index (this will update the value)
		indexObjectProperty.setValue(lIdx);
	}
	
	/**
	 * 
	 */
	public void increment()
	{
		// nothing to do
		if (getItems() == null || getItems().size() == 0) return;
		
		// get the current index
		int lOldIdx = this.indexObjectProperty.getValue();
		
		// get the next index (usually current + 1)
		int lIdx = lOldIdx + 1;
		
		// if null is return, there is no next index (usually current + 1)
		if (lIdx >= getItems().size())
		{
			// if we're not cyclic
			if (isCyclic() != null && isCyclic().booleanValue() == false)
			{
				// do nothing
				return;
			}
			
			// cycle to the other end: get the first value
			lIdx = 0;
			
			// notify listener that we've cycled
			fireCycleEvent(CycleDirection.TOP_TO_BOTTOM);
		}
		
		// set the new index (this will update the value)
		indexObjectProperty.setValue(lIdx);
	}

	/**
	 * Get the last index; if the data provide is endless, this method mail fail!
	 */
	public void last()
	{
		// nothing to do
		if (getItems() == null || getItems().size() == 0) return;
		
		// set the new index (this will update the value)
		indexObjectProperty.setValue(getItems().size() - 1);
	}

	/**
	 * Does a o1.equals(o2) but also checks if o1 or o2 are null.
	 * @param o1
	 * @param o2
	 * @return
	 */
	static public boolean equals(Object o1, Object o2)
	{
		if ( o1 == null && o2 == null ) return true;
		if ( o1 != null && o2 == null ) return false;
		if ( o1 == null && o2 != null ) return false;
		// TODO: compare arrays if (o1.getClass().isArray() && o2.getClass().isArray()) return Arrays.equals( (Object[])o1, (Object[])o2 );		
		return o1.equals(o2);
	}

}
