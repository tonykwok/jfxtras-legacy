package jfxtras.scene.control;

import com.sun.javafx.css.StyleManager;
import javafx.beans.InvalidationListener;
import javafx.beans.Observable;
import javafx.beans.property.BooleanProperty;
import javafx.beans.property.DoubleProperty;
import javafx.beans.property.ObjectProperty;
import javafx.beans.property.SimpleBooleanProperty;
import javafx.beans.property.SimpleDoubleProperty;
import javafx.beans.property.SimpleObjectProperty;
import javafx.collections.ObservableList;
import javafx.scene.Node;
import javafx.scene.control.Control;
import javafx.scene.control.Label;
import javafx.scene.control.ListCell;
import javafx.scene.control.ListView;
import javafx.scene.control.MultipleSelectionModel;
import javafx.util.Callback;
import javafx.util.Duration;

/**
 *
 * @author Goran Lochert
 * BUG shadow on popup is blinking sometimes
 * BUG mouse scroll on listView does not work when listView is inside popup
 */
public class ListComboBoxX<T> extends Control {

    private static final String LIST_COMBO_BOX_STYLE_CLASS = "list-combo-boxx";
    private static final String PSEUDO_CLASS_SHOWING = "showing";
    private static final long SHOWING_PSEUDOCLASS_STATE = StyleManager.getInstance().getPseudoclassMask("showing");
    private static final String PSEUDO_CLASS_ARROW_ON_LEFT = "arrow-on-left";
    private static final long ARROW_ON_LEFT_PSEUDOCLASS_STATE = StyleManager.getInstance().getPseudoclassMask("arrow-on-left");
    protected ListView<T> listView;
    // ==================================
    // PROPERTIES
    // ==================================
    // maybe styleable -fx-dropdown-height
    private DoubleProperty dropDownHeight;
    // maybe stylable -fx-animation-duration
    private ObjectProperty<Duration> animationDuration;
    private BooleanProperty arrowOnLeft;
    private BooleanProperty showing;

    public DoubleProperty dropDownHeightProperty() {
        if(dropDownHeight == null) {
            dropDownHeight = new SimpleDoubleProperty(this, "dropDownHeight", 200.0d);
        }
        return dropDownHeight;
    }
    
    public final double getDropDownHeight() {
        return dropDownHeight == null ? 200.0d : dropDownHeight.get();
    }
    public final void setDropDownHeight(double value) {
        dropDownHeightProperty().set(value);
    }
    
    public final void setShowing(boolean value) {
        showingProperty().set(value);
    }

    public final boolean isShowing() {
        return showing == null ? false : showing.get();
    }

    public BooleanProperty showingProperty() {
        if (showing == null) {
            showing = new SimpleBooleanProperty(this, "showing", false) {

                @Override
                protected void invalidated() {
                    ListComboBoxX.this.impl_pseudoClassStateChanged(PSEUDO_CLASS_SHOWING);
                }
            };
        }
        return showing;
    }

    public final Duration getAnimationDuration() {
        return animationDuration == null ? new Duration(350.0d) : animationDuration.get();
    }

    public final void setAnimationDuration(Duration value) {
        animationDurationProperty().set(value);
    }

    public ObjectProperty<Duration> animationDurationProperty() {
        if (animationDuration == null) {
            animationDuration = new SimpleObjectProperty<Duration>(this, "animationDuration", new Duration(350.0d));
        }
        return animationDuration;
    }

    public BooleanProperty arrowOnLeftProperty() {
        if (arrowOnLeft == null) {
            arrowOnLeft = new SimpleBooleanProperty(this, "arrow-on-left", false) {

                @Override
                protected void invalidated() {
                    ListComboBoxX.this.impl_pseudoClassStateChanged(PSEUDO_CLASS_ARROW_ON_LEFT);
                }
            };
        }
        return arrowOnLeft;
    }

    public final boolean isArrowOnLeft() {
        return arrowOnLeft == null ? false : arrowOnLeft.get();
    }

    public final void setArrowOnLeft(boolean value) {
        arrowOnLeftProperty().set(value);
    }

    public final void setItems(ObservableList<T> items) {
        listView.setItems(items);
    }

    public final ObservableList<T> getItems() {
        return listView.getItems();
    }

    public ObjectProperty<ObservableList<T>> itemsProperty() {
        return listView.itemsProperty();
    }

    public void setCellFactory(Callback<ListView<T>, ListCell<T>> value) {
        listView.setCellFactory(value);
    }

    public Callback<ListView<T>, ListCell<T>> getCellFactory() {
        return listView.getCellFactory();
    }

    public ObjectProperty<Callback<ListView<T>, ListCell<T>>> cellFactoryProperty() {
        return listView.cellFactoryProperty();
    }

    // ==================================
    // CONSTRUCTORS
    // ==================================
    public ListComboBoxX() {
        init();
        initListeners();
    }

    public ListComboBoxX(ObservableList<T> items) {
        init();
        setItems(items);
        initListeners();

    }
    // ==================================
    // PRIVATE METHODS
    // ==================================

    private void init() {
        getStyleClass().add(LIST_COMBO_BOX_STYLE_CLASS);
        listView = new ListView<T>();        
        setCellFactory(new DefaultCellFactory());
    }

    private void initListeners() {
        dropDownHeightProperty().addListener(new InvalidationListener() {

            @Override
            public void invalidated(Observable o) {
                listView.setPrefHeight(dropDownHeight.get());
                listView.setMinHeight(dropDownHeight.get());
                listView.setMaxHeight(dropDownHeight.get());
            }
        });
    }

    // ==================================
    // PUBLIC METHODS
    // ==================================
    /**
     * Get listComboBox/ListView selection Model
     * @return selection model
     */
    public MultipleSelectionModel<T> getSelectionModel() {
        return listView.getSelectionModel();
    }

    // ==================================
    // OVERRIDES
    // ==================================
    @Override
    public long impl_getPseudoClassState() {
        long l = super.impl_getPseudoClassState();
        if (isShowing()) {
            l |= SHOWING_PSEUDOCLASS_STATE;
        }
        if (isArrowOnLeft()) {
            l |= ARROW_ON_LEFT_PSEUDOCLASS_STATE;

        }
        return l;
    }

    @Override
    protected String getUserAgentStylesheet() {
        return this.getClass().getResource(this.getClass().getSimpleName() + ".css").toString();
    }


    // ==================================
    // PROTECTED CLASSES
    // ==================================
    protected class DefaultCellFactory implements Callback<ListView<T>, ListCell<T>> {

        @Override
        public ListCell<T> call(ListView<T> listView) {

            ListComboBoxXCell<T> cell = new ListComboBoxXCell<T>() {

                Label label;

                @Override
                public void updateItem(T item, boolean empty) {
                    super.updateItem(item, empty);

                    if (item == null) {
                        setGraphic(null);
                    } else {
                        Node node;
                        if (item instanceof Node) {
                            node = (Node) item;
                            setGraphic(node);
                        } else {
                            if (label == null) {
                                label = new Label();
                            }
                            label.setText(item.toString());
                            setGraphic(label);
                        }
                    }
                }
            };
            return cell;
        }
    }
}
