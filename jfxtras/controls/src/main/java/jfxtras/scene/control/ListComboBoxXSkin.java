package jfxtras.scene.control;

import com.sun.javafx.scene.control.skin.SkinBase;
import javafx.beans.InvalidationListener;
import javafx.beans.Observable;
import javafx.event.EventHandler;
import javafx.geometry.HPos;
import javafx.geometry.VPos;
import javafx.scene.control.Label;
import javafx.scene.control.ListView;
import javafx.scene.control.MultipleSelectionModel;
import javafx.scene.input.MouseEvent;
import javafx.scene.layout.StackPane;
import javafx.stage.WindowEvent;

/**
 *
 * @author Goran Lochert
 * 
 */
public class ListComboBoxXSkin<T> extends SkinBase<ListComboBoxX<T>, ListComboBoxXBehavior<T>> {

    private ListView<T> listView;
    private Label label;
    private StackPane arrowContainer; // container for arrow shape
    private MultipleSelectionModel<T> selectionModel;
    private AnimatedPopupX popup;

    public ListComboBoxXSkin(ListComboBoxX<T> listComboBox) {
        super(listComboBox, new ListComboBoxXBehavior<T>(listComboBox));
        init();
        initListenersAndBinds();
    }

    private void init() {
        listView = getSkinnable().listView;
        popup = new AnimatedPopupX();
        popup.setContentNode(listView);

        selectionModel = listView.getSelectionModel();

        label = new Label();

        StackPane arrow = new StackPane();
        arrow.getStyleClass().add("arrow");

        arrowContainer = new StackPane();
        arrowContainer.getStyleClass().add("arrow-container");
        arrowContainer.getChildren().add(arrow);

        getChildren().addAll(label, arrowContainer);
        updateValue();
        requestFocus();
    }

    private void updateValue() {
        
        // if nothing is selected select first value in list unless list is empty (when empty index is auto -1)        
        if(selectionModel.getSelectedIndex() == -1) {
            selectionModel.selectFirst();
        }
        ListComboBoxXCell<T> cell = (ListComboBoxXCell<T>) getSkinnable().getCellFactory().call(listView);
        cell.updateIndex(selectionModel.getSelectedIndex());
        cell.updateItem(selectionModel.getSelectedItem(), false);
        label.setText(cell.getText());
        label.setGraphic(cell.getGraphic());
        label.setAlignment(cell.getAlignment());
        label.setContentDisplay(cell.getContentDisplay());
        label.setFont(cell.getFont());
    }

    private void initListenersAndBinds() {

        getSkinnable().showingProperty().addListener(new InvalidationListener() {

            @Override
            public void invalidated(Observable o) {
                System.out.println("showing: " + getSkinnable().isShowing());
            }
        });

        getSkinnable().focusedProperty().addListener(new InvalidationListener() {

            @Override
            public void invalidated(Observable o) {
                System.out.println("focused: " + getSkinnable().isFocused());
            }
        });

        registerChangeListener(getSkinnable().animationDurationProperty(), "ANIMATION_DURATION");
        registerChangeListener(getSkinnable().itemsProperty(), "ITEMS");

        listView.prefWidthProperty().bind(getSkinnable().widthProperty());

        selectionModel.selectedIndexProperty().addListener(new InvalidationListener() {

            @Override
            public void invalidated(Observable o) {
                updateValue();
            }
        });

        popup.setOnHiding(new EventHandler<WindowEvent>() {

            @Override
            public void handle(WindowEvent t) {
                getSkinnable().requestFocus(); // fix for : popup hidden control losses focus
            }
        });

        arrowContainer.setOnMouseReleased(new EventHandler<MouseEvent>() {

            @Override
            public void handle(MouseEvent event) {

                if (popup.isVisible()) {
                    getSkinnable().showingProperty().set(false);
                    popup.doHide();
                } else {
                    getSkinnable().showingProperty().set(true);
                    popup.show(ListComboBoxXSkin.this, 0, 0);
                }
            }
        });

        listView.setOnMouseReleased(new EventHandler<MouseEvent>() {

            @Override
            public void handle(MouseEvent event) {
                getSkinnable().showingProperty().set(false);
                popup.doHide();
            }
        });
    }

    // ***********************************
    //             overrides
    // ***********************************
    @Override
    protected void handleControlPropertyChanged(String string) {
        super.handleControlPropertyChanged(string);
        if (string.equals("ANIMATION_DURATION")) {
            popup.setAnimationDuration(getSkinnable().getAnimationDuration());
        } else if (string.equals("ITEMS")) {            
            updateValue();
//            System.out.println("items changed in lcb");
//            if (!getSkinnable().getItems().isEmpty()) {
//                selectionModel.selectFirst();
//            }
        }
    }

    @Override
    protected void layoutChildren() {

        double top = getInsets().getTop();
        double right = getInsets().getRight();
        double bottom = getInsets().getBottom();
        double left = getInsets().getLeft();
        double width = this.getWidth();
        double height = this.getHeight();

        double arrowpw = arrowContainer.prefWidth(-1);

        if (getSkinnable().isArrowOnLeft()) {
            // position arrow to left side
            arrowContainer.resize(arrowpw, height);
            positionInArea(arrowContainer, 0.0, 0.0d, arrowpw, height, 0.0d, HPos.CENTER, VPos.CENTER);
            label.resize(width - left - right - arrowpw, height - top - bottom);
            positionInArea(label, arrowpw + left, 0.0d, width, height, 0.0d, HPos.LEFT, VPos.CENTER);
        } else {
            // position label to left side
            label.resize(width - left - right - arrowpw, height - top - bottom);
            positionInArea(label, left, 0.0, width, height, 0.0d, HPos.LEFT, VPos.CENTER);
            arrowContainer.resize(arrowpw, height);
            positionInArea(arrowContainer, width - arrowpw, 0.0, arrowpw, height, 0.0d, HPos.CENTER, VPos.CENTER);
        }
    }

    @Override
    protected double computeMaxHeight(double width) {
        return getPadding().getTop() + Math.max(22.0d, getSkinnable().prefHeight(width)) + getPadding().getBottom();
    }

    @Override
    protected double computePrefHeight(double width) {
        return getPadding().getTop() + Math.max(22.0d, label.prefHeight(-1)) + getPadding().getBottom();
    }

    @Override
    protected double computeMinHeight(double width) {
        return getPadding().getTop() + Math.max(22.0d, label.minHeight(-1)) + getPadding().getBottom();
    }

    @Override
    protected double computePrefWidth(double height) {
        double labelwp = label.prefWidth(-1);
        double arrowwp = arrowContainer.prefWidth(-1);
        return getPadding().getLeft() + Math.max(50.0d, labelwp + arrowwp) + getPadding().getRight();
    }

    @Override
    protected double computeMaxWidth(double height) {
        return getPadding().getLeft() + Math.max(50.0d, getSkinnable().prefWidth(height)) + getPadding().getRight();
    }

    @Override
    protected double computeMinWidth(double height) {
        return getPadding().getLeft() + Math.max(50.0d, label.minWidth(-1)) + getPadding().getRight();
    }
}
