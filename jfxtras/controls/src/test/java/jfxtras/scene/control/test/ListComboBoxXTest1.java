package jfxtras.scene.control.test;


import javafx.application.Application;
import javafx.beans.InvalidationListener;
import javafx.beans.Observable;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;

import javafx.geometry.Pos;
import javafx.scene.control.ContentDisplay;
import javafx.scene.control.ListCell;
import javafx.scene.control.ListView;
import javafx.scene.layout.StackPane;
import javafx.scene.layout.VBox;
import javafx.scene.paint.Color;
import javafx.scene.shape.Rectangle;
import javafx.scene.text.Font;
import javafx.util.Callback;
import javafx.util.Duration;
import jfxtras.application.ExtendedApplicationX;
import jfxtras.scene.control.ListComboBoxX;
import jfxtras.scene.control.ListComboBoxXCell;


/**
 * 
 * @author Goran Lochert
 */
public class ListComboBoxXTest1 extends ExtendedApplicationX {

    public static void main(String[] args) {
        launchWithPrelaunch(ListComboBoxXTest1.class, args);
    }

    @Override
    protected void setup() {
        ObservableList<String> data = FXCollections.observableArrayList(
                "chocolate", "salmon", "gold", "coral",
                "darkorchid", "darkgoldenrod", "lightsalmon",
                "black", "rosybrown", "blue", "blueviolet",
                "brown");

        ListComboBoxX<String> listComboBox = new ListComboBoxX<String>();
        listComboBox.setDropDownHeight(150.0);
        listComboBox.setItems(data);
        listComboBox.setCellFactory(new Callback<ListView<String>, ListCell<String>>() {

            @Override
            public ListComboBoxXCell<String> call(ListView<String> p) {
                final Rectangle rect = new Rectangle(190, 20);
                final StackPane stack = new StackPane();
                final ListComboBoxXCell<String> cell = new ListComboBoxXCell<String>() {

                    @Override
                    public void updateItem(String item, boolean empty) {
                        super.updateItem(item, empty);
                        if (item != null) {
                            rect.setFill(Color.web(item));
                            stack.setStyle("-fx-background-color: " + item + ";"
                                    + "-fx-background-insets: 2;"
                                    + "-fx-padding: 4;"
                                    + "");
                            setGraphic(stack);
                            setContentDisplay(ContentDisplay.CENTER);
                        }
                    }
                };
                return cell;
            }
        });

        ListComboBoxX<String> fontComboBox = new ListComboBoxX<String>();
        ObservableList<String> fontlist = FXCollections.observableArrayList(Font.getFamilies());
        fontComboBox.setItems(fontlist);
        fontComboBox.setArrowOnLeft(true);
        fontComboBox.setCellFactory(new Callback<ListView<String>, ListCell<String>>() {

            @Override
            public ListCell<String> call(ListView<String> param) {
                final ListComboBoxXCell<String> cell = new ListComboBoxXCell<String>() {

                    @Override
                    public void updateItem(String item, boolean empty) {
                        super.updateItem(item, empty);
                        if (item != null) {
                            setText(item);
                            setFont(new Font(item, 14));
                            setContentDisplay(ContentDisplay.CENTER);
                        }
                    }
                };
                return cell;
            }
        });


        fontComboBox.setPrefWidth(150);
        fontComboBox.setDropDownHeight(320);

        final ListComboBoxX<Integer> animationDurationLCB = new ListComboBoxX<Integer>();
        animationDurationLCB.setItems(FXCollections.observableArrayList(10, 50, 75, 100, 150, 200, 250, 300, 350, 400, 450, 500, 600, 800, 1000));

        animationDurationLCB.getSelectionModel().selectedItemProperty().addListener(new InvalidationListener() {

            @Override
            public void invalidated(Observable o) {
                animationDurationLCB.setAnimationDuration(new Duration(animationDurationLCB.getSelectionModel().getSelectedItem().doubleValue()));
            }
        });

        animationDurationLCB.getSelectionModel().select(5);
        VBox pane = new VBox(10);
        pane.setAlignment(Pos.CENTER);

        pane.getChildren().addAll(listComboBox, fontComboBox, animationDurationLCB);
        root.getChildren().add(pane);
    }
}
