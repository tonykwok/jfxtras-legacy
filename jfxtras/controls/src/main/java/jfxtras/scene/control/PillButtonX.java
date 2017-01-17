package jfxtras.scene.control;

import com.sun.javafx.css.StyleManager;
import javafx.beans.property.BooleanProperty;
import javafx.beans.property.ObjectProperty;
import javafx.beans.property.SimpleBooleanProperty;
import javafx.beans.property.SimpleObjectProperty;
import javafx.event.ActionEvent;
import javafx.scene.Node;
import javafx.scene.control.ToggleButton;

/**
 *
 * @author Goran Lochert
 * TODO: make builder PillButtonBuilder
 */
public class PillButtonX extends ToggleButton {

    public enum ButtonPosition {

        TOP,
        RIGHT,
        BOTTOM,
        LEFT,
        TOP_LEFT,
        TOP_RIGHT,
        BOTTOM_LEFT,
        BOTTOM_RIGHT,
        CENTER
    }
    // ===============================================
    // CSS 
    // ===============================================
    private static final String DEFAULT_STYLE_CLASS = "pill-buttonx";
    private static final String PSEUDO_CLASS_LEFT = "left";
    private static final long LEFT_PSEUDO_CLASS_STATE = StyleManager.getInstance().getPseudoclassMask(PSEUDO_CLASS_LEFT);
    private static final String PSEUDO_CLASS_RIGHT = "right";
    private static final long RIGHT_PSEUDO_CLASS_STATE = StyleManager.getInstance().getPseudoclassMask(PSEUDO_CLASS_RIGHT);
    private static final String PSEUDO_CLASS_TOP = "top";
    private static final long TOP_PSEUDO_CLASS_STATE = StyleManager.getInstance().getPseudoclassMask(PSEUDO_CLASS_TOP);
    private static final String PSEUDO_CLASS_BOTTOM = "bottom";
    private static final long BOTTOM_PSEUDO_CLASS_STATE = StyleManager.getInstance().getPseudoclassMask(PSEUDO_CLASS_BOTTOM);
    private static final String PSEUDO_CLASS_TOP_LEFT = "top-left";
    private static final long TOP_LEFT_PSEUDO_CLASS_STATE = StyleManager.getInstance().getPseudoclassMask(PSEUDO_CLASS_TOP_LEFT);
    private static final String PSEUDO_CLASS_TOP_RIGHT = "top-right";
    private static final long TOP_RIGHT_PSEUDO_CLASS_STATE = StyleManager.getInstance().getPseudoclassMask(PSEUDO_CLASS_TOP_RIGHT);
    private static final String PSEUDO_CLASS_BOTTOM_LEFT = "bottom-left";
    private static final long BOTTOM_LEFT_PSEUDO_CLASS_STATE = StyleManager.getInstance().getPseudoclassMask(PSEUDO_CLASS_BOTTOM_LEFT);
    private static final String PSEUDO_CLASS_BOTTOM_RIGHT = "bottom-right";
    private static final long BOTTOM_RIGHT_PSEUDO_CLASS_STATE = StyleManager.getInstance().getPseudoclassMask(PSEUDO_CLASS_BOTTOM_RIGHT);
    private static final String PSEUDO_CLASS_CENTER = "center";
    private static final long CENTER_PSEUDO_CLASS_STATE = StyleManager.getInstance().getPseudoclassMask(PSEUDO_CLASS_CENTER);

    // ===============================================
    // CONSTRUCTORS
    // ===============================================
    public PillButtonX() {
        init();
    }

    public PillButtonX(String string) {
        super(string);
        init();
    }

    public PillButtonX(String string, Node node) {
        super(string, node);
        init();
    }

    private void init() {
        getStyleClass().setAll(DEFAULT_STYLE_CLASS);
    }
    // ================================================
    // PROPERTIES    
    // ================================================    
    private ObjectProperty<ButtonPosition> buttonPosition;
    // TODO: ButtonType enum (NORMAL, TOGGLE, RADIO)
    // make styleable (-fx-deselect-allowed)
    // property that makes PillButton to act as RadioButton
    private BooleanProperty deselectAllowed;
    // property that makes PillButton to act as normal Button
    private BooleanProperty selectAllowed;

    private BooleanProperty selectAllowedProperty() {
        if (selectAllowed == null) {
            selectAllowed = new SimpleBooleanProperty(this, "select-allowed", false);
        }
        return selectAllowed;
    }

    public final boolean isSelectAllowed() {
        return selectAllowed == null ? true : selectAllowed.get();
    }

    public final void setSelectAllowed(boolean value) {
        selectAllowedProperty().set(value);
    }

    public BooleanProperty deselectAllowedProperty() {
        if (deselectAllowed == null) {
            deselectAllowed = new SimpleBooleanProperty(this, "deselect-allowed", false);
        }
        return deselectAllowed;
    }

    public final boolean isDeselectAllowed() {
        return deselectAllowed == null ? true : deselectAllowed.get();
    }

    public final void setDeselectAllowed(boolean value) {
        deselectAllowedProperty().set(value);
    }

    public ObjectProperty<ButtonPosition> buttonPositionProperty() {
        if (buttonPosition == null) {
            buttonPosition = new SimpleObjectProperty<ButtonPosition>(this, "button-position", ButtonPosition.CENTER) {

                @Override
                protected void invalidated() {
                    PillButtonX.this.impl_pseudoClassStateChanged(PSEUDO_CLASS_TOP);
                    PillButtonX.this.impl_pseudoClassStateChanged(PSEUDO_CLASS_RIGHT);
                    PillButtonX.this.impl_pseudoClassStateChanged(PSEUDO_CLASS_BOTTOM);
                    PillButtonX.this.impl_pseudoClassStateChanged(PSEUDO_CLASS_LEFT);
                    PillButtonX.this.impl_pseudoClassStateChanged(PSEUDO_CLASS_TOP_LEFT);
                    PillButtonX.this.impl_pseudoClassStateChanged(PSEUDO_CLASS_TOP_RIGHT);
                    PillButtonX.this.impl_pseudoClassStateChanged(PSEUDO_CLASS_BOTTOM_LEFT);
                    PillButtonX.this.impl_pseudoClassStateChanged(PSEUDO_CLASS_BOTTOM_RIGHT);
                }
            };
        }
        return buttonPosition;
    }

    public final ButtonPosition getButtonPosition() {
        return buttonPosition == null ? ButtonPosition.CENTER : buttonPosition.get();
    }

    public final void setButtonPosition(ButtonPosition value) {
        buttonPositionProperty().set(value);
    }
    // ================================================
    // PUBLIC METHODS
    // ================================================


    // ================================================
    // OVERRIDES
    // ================================================
    @Override
    protected String getUserAgentStylesheet() {
        return this.getClass().getResource(this.getClass().getSimpleName() + ".css").toString();
    }

    @Override
    public void fire() {
        if (!isSelectAllowed()) { // if select is not allowed just fire event
            fireEvent(new ActionEvent());
        } else {
            if (isDeselectAllowed()) {
                super.fire();
            } else { // do not allow deselection
                if ((getToggleGroup() == null) || (!isSelected())) {
                    super.fire();
                }
            }
        }
    }

    @Override
    public long impl_getPseudoClassState() {
        long bits = super.impl_getPseudoClassState();

        switch (getButtonPosition()) {
            case TOP:
                bits |= TOP_PSEUDO_CLASS_STATE;
                break;
            case RIGHT:
                bits |= RIGHT_PSEUDO_CLASS_STATE;
                break;
            case BOTTOM:
                bits |= BOTTOM_PSEUDO_CLASS_STATE;
                break;
            case LEFT:
                bits |= LEFT_PSEUDO_CLASS_STATE;
                break;
            case TOP_LEFT:
                bits |= TOP_LEFT_PSEUDO_CLASS_STATE;
                break;
            case TOP_RIGHT:
                bits |= TOP_RIGHT_PSEUDO_CLASS_STATE;
                break;
            case BOTTOM_LEFT:
                bits |= BOTTOM_LEFT_PSEUDO_CLASS_STATE;
                break;
            case BOTTOM_RIGHT:
                bits |= BOTTOM_RIGHT_PSEUDO_CLASS_STATE;
                break;
        }
        return bits;
    }
}
