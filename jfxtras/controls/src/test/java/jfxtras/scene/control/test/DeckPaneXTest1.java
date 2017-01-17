package jfxtras.scene.control.test;

import javafx.beans.Observable;

import javafx.beans.InvalidationListener;
import javafx.event.EventHandler;
import javafx.scene.control.Button;
import javafx.beans.value.ChangeListener;
import javafx.beans.value.ObservableValue;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.event.ActionEvent;
import javafx.geometry.Insets;
import javafx.geometry.Pos;
import javafx.scene.Group;
import javafx.scene.Node;
import javafx.scene.control.Label;
import javafx.scene.control.ListView;
import javafx.scene.control.RadioButton;
import javafx.scene.control.SingleSelectionModel;
import javafx.scene.control.Toggle;
import javafx.scene.control.ToggleGroup;
import javafx.scene.layout.BorderPane;
import javafx.scene.layout.HBox;
import javafx.scene.layout.StackPane;
import javafx.scene.layout.VBox;
import javafx.util.Duration;
import jfxtras.application.ExtendedApplicationX;
import jfxtras.scene.control.AnimationModeX;
import jfxtras.scene.control.DeckPaneX;

public class DeckPaneXTest1 extends ExtendedApplicationX {

    private DeckPaneX deck;
    private ButtonEventHandler beh;
    private ObservableList<String> colors;
    private ListView<String> lv;

    @Override
    public void setup() {

        HBox top = new HBox(20);
        top.setAlignment(Pos.CENTER);

        colors = FXCollections.<String>observableArrayList(
                "red", "blue", "yellow", "green", "skyblue",
                "deepskyblue", "indigo", "orange", "magenta", "gold",
                "pink", "gray", "aqua", "brown", "olive");

        lv = new ListView<String>(colors);
        lv.setPrefHeight(400);
        lv.setMaxHeight(400);


        deck = new DeckPaneX();
        deck.setId("mainDeck");
        deck.setAnimationDuration(new Duration(800.0d));


        ObservableList<Node> items = createDeckItems();
        beh = new ButtonEventHandler();

        final Button first = new Button("First");
        first.setId("first");
        first.setOnAction(beh);

        final Button previous = new Button("Previous");
        previous.setId("previous");
        previous.setOnAction(beh);


        final Button next = new Button("Next");
        next.setId("next");
        next.setOnAction(beh);

        final Button last = new Button("Last");
        last.setId("last");
        last.setOnAction(beh);

        final Label label = new Label();

        StackPane localStack = new StackPane();
        localStack.setStyle("-fx-padding: 20; -fx-background-color: yellowgreen; -fx-background-radius: 10;");
        localStack.setPrefSize(300, 300);
        deck.setBackgroundNode(new Group(localStack));
        deck.setItems(items);
        deck.selectedNodeIDProperty().addListener(new ChangeListener<String>() {

            @Override
            public void changed(ObservableValue<? extends String> observable, String oldValue, String newValue) {
                System.out.println("-> newVisible: " + newValue + " oldVisible: " + oldValue);
            }
        });

        Button bgChange = new Button("Change bg Node");
        bgChange.setOnAction(new EventHandler<ActionEvent>() {

            @Override
            public void handle(ActionEvent t) {
                StackPane localStack = new StackPane();
           
                localStack.setStyle("-fx-padding: 20; -fx-background-color: deepskyblue; -fx-background-radius: 60;");
                localStack.setPrefSize(300, 300);
                deck.setBackgroundNode(new Group(localStack));
                deck.getItems().add(new Label("Test"));
            }
        });

        deck.getSelectionModel().selectedIndexProperty().addListener(new InvalidationListener() {

            @Override
            public void invalidated(Observable o) {
                System.out.println("dsi changed.");
                int listSelectedIndex = lv.getSelectionModel().getSelectedIndex();
                int deckSelectedIndex = deck.getSelectionModel().getSelectedIndex();
                System.out.println("lsi: " + listSelectedIndex);
                System.out.println("dsi: " + deckSelectedIndex);
                if (deckSelectedIndex != listSelectedIndex) {
                    lv.getSelectionModel().select(deckSelectedIndex);
                }
                label.setText(String.valueOf(deck.getSelectionModel().getSelectedIndex()));
            }
        });

        lv.getSelectionModel().selectedIndexProperty().addListener(new InvalidationListener() {

            @Override
            public void invalidated(Observable o) {
                System.out.println("lsi changed.");
                int listSelectedIndex = lv.getSelectionModel().getSelectedIndex();
                int deckSelectedIndex = deck.getSelectionModel().getSelectedIndex();
                System.out.println("lsi: " + listSelectedIndex);
                System.out.println("dsi: " + deckSelectedIndex);
                if (listSelectedIndex != deckSelectedIndex) {
                    System.out.println("in IF");
                    deck.getSelectionModel().select(listSelectedIndex);
                }
            }
        });

        deck.getSelectionModel().selectedItemProperty().addListener(new InvalidationListener() {

            @Override
            public void invalidated(Observable o) {
                System.out.println("selected: " + deck.getSelectionModel().getSelectedIndex());
                System.out.println("selected: " + deck.getSelectionModel().getSelectedItem());
//                System.out.println("deck items: " + deck.getItems());
            }
        });

        top.getChildren().addAll(first, previous, label, next, last, bgChange);

        root = new BorderPane();
        root.setPadding(new Insets(20));
        ((BorderPane) root).setTop(top);

        ((BorderPane) root).setCenter(deck);


        final ToggleGroup group = new ToggleGroup();
        group.selectedToggleProperty().addListener(new ChangeListener<Toggle>() {

            @Override
            public void changed(ObservableValue<? extends Toggle> observable, Toggle oldValue, Toggle newValue) {
                if (group.getSelectedToggle() != null) {
//                    System.out.println("toggle changed: " + newValue.getUserData());
//                    System.out.println("toggle changed: " + group.getSelectedToggle().getUserData());
                    AnimationModeX mode = (AnimationModeX) group.getSelectedToggle().getUserData();
                    deck.setAnimationMode(mode);
                }
            }
        });
        RadioButton rb1 = new RadioButton("FADE");
        rb1.setUserData(AnimationModeX.FADE);
        rb1.setToggleGroup(group);
        rb1.setSelected(true);

        RadioButton rb2 = new RadioButton("SCALE");
        rb2.setUserData(AnimationModeX.SCALE);
        rb2.setToggleGroup(group);

        RadioButton rb3 = new RadioButton("PERSPECTIVE");
        rb3.setUserData(AnimationModeX.PERSPECTIVE);
        rb3.setToggleGroup(group);

        RadioButton rb4 = new RadioButton("NO ANIMATION");
        rb4.setUserData(AnimationModeX.NO_ANIMATION);
        rb4.setToggleGroup(group);

        VBox vb = new VBox(10);
        vb.getChildren().addAll(rb1, rb2, rb3, rb4);



        VBox left = new VBox(20);
        left.getChildren().addAll(vb, lv);
        ((BorderPane) root).setLeft(left);


        scene.setRoot(root);

        // SELECT BY ID, OR BY INDEX
//        deck.setSelectedNodeID("yellow");
        deck.getSelectionModel().select(4);
    }

    @Override
    protected double getAppHeight() {
        return 600.0d;
    }

    @Override
    protected double getAppWidth() {
        return 600.0d;
    }

    private Button createDeckButton(String color) {
        Button btn = new Button(color);
        btn.setId(color);
        btn.setPrefSize(200, 200);
        btn.setStyle("-fx-base: " + color + ";");
        return btn;
    }

    public static void main(String[] args) {
        launchWithPrelaunch(DeckPaneXTest1.class, args);
    }

    private ObservableList<Node> createDeckItems() {
        ObservableList<Node> temp = FXCollections.<Node>observableArrayList();

        for (String color : colors) {
            temp.add(createDeckButton(color));
        }
        return temp;
    }

    protected class ButtonEventHandler implements EventHandler<ActionEvent> {

        @Override
        public void handle(ActionEvent t) {
            SingleSelectionModel<Node> selectionModel = (SingleSelectionModel<Node>) deck.getSelectionModel();
            Button button = (Button) t.getSource();
            String id = button.getId();
            if (id.equals("first")) {
                selectionModel.selectFirst();
            } else if (id.equals("previous")) {
                selectionModel.selectPrevious();
            } else if (id.equals("next")) {
                selectionModel.selectNext();
            } else if (id.equals("last")) {
                selectionModel.selectLast();
            }
        }
    }
}
