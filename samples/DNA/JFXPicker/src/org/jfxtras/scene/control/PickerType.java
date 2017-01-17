
package org.jfxtras.scene.control;

/**
 * Defines the Picker types available i.e. dropDownPicker, sideScrollPicker and thumbWheelPicker
 * 
 * @author David
 */
public enum PickerType {
   /**
   * Default. A basic Combobox type picker with one down arrow control on left or right
   */
  DROP_DOWN, 
   /**
   * A left and right arrow scroll picker with optional dropdown selector
   * Typified by Month selectors found in Calendars etc.
   */
  SIDE_SCROLL,
   /**
   * An up/down arrow control with optional dropdown selector and left/right control
   * Typically used for rapid wheel scrolling through a range of numbers
   */
  THUMB_WHEEL
  }
