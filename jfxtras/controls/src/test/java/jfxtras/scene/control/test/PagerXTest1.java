package jfxtras.scene.control.test;


import javafx.event.EventHandler;
import javafx.scene.control.Button;
import javafx.beans.value.ChangeListener;
import javafx.beans.value.ObservableValue;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.event.ActionEvent;
import javafx.geometry.Insets;
import javafx.geometry.Pos;
import javafx.scene.control.CheckBox;
import javafx.scene.control.ListView;
import javafx.scene.control.RadioButton;
import javafx.scene.control.SingleSelectionModel;
import javafx.scene.control.Toggle;
import javafx.scene.control.ToggleGroup;
import javafx.scene.layout.BorderPane;
import javafx.scene.layout.HBox;
import javafx.scene.layout.StackPane;
import javafx.scene.layout.VBox;
import jfxtras.application.ExtendedApplicationX;
import jfxtras.scene.control.AnimationModeX;
import jfxtras.scene.control.PageItemX;
import jfxtras.scene.control.PageX;
import jfxtras.scene.control.PagerX;

public class PagerXTest1 extends ExtendedApplicationX {

    private PagerX pager;
 
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

        pager = new PagerX();

        ObservableList<PageItemX> items = createDeckItems();
       



        StackPane localStack = new StackPane();
        localStack.setStyle("-fx-padding: 20; -fx-background-color: yellowgreen; -fx-background-radius: 10;");
        localStack.setPrefSize(300, 300);

        pager.setItems(items);

        pager.setItemsPerPage(3);


        CheckBox templateLabelShownCheckBox = new CheckBox("Show Template Node");
        templateLabelShownCheckBox.setSelected(true);
        pager.templateNodeShownProperty().bind(templateLabelShownCheckBox.selectedProperty());
        
        top.getChildren().addAll(templateLabelShownCheckBox);
        top.setPadding(new Insets(20));

        root = new BorderPane();
        root.setPadding(new Insets(20));
        ((BorderPane) root).setTop(top);

        ((BorderPane) root).setCenter(pager);


        final ToggleGroup group = new ToggleGroup();
        group.selectedToggleProperty().addListener(new ChangeListener<Toggle>() {

            @Override
            public void changed(ObservableValue<? extends Toggle> observable, Toggle oldValue, Toggle newValue) {
                if (group.getSelectedToggle() != null) {
//                    System.out.println("toggle changed: " + newValue.getUserData());
//                    System.out.println("toggle changed: " + group.getSelectedToggle().getUserData());
                    AnimationModeX mode = (AnimationModeX) group.getSelectedToggle().getUserData();
                    pager.setAnimationMode(mode);
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
//        ((BorderPane) root).setLeft(left);


//        pager.getSelectionModel().selectFirst(); //

        scene.setRoot(root);



    }

    @Override
    protected double getAppHeight() {
        return 600.0d;
    }

    @Override
    protected double getAppWidth() {
        return 800.0d;
    }

    private Button createDeckButton(String color) {
        Button btn = new Button(color);
        btn.setId(color);
        btn.setPrefSize(200, 200);
        btn.setStyle("-fx-base: " + color + ";");
        return btn;
    }

    public static void main(String[] args) {
        launchWithPrelaunch(PagerXTest1.class, args);
    }

    private ObservableList<PageItemX> createDeckItems() {
        ObservableList<PageItemX> temp = FXCollections.<PageItemX>observableArrayList();

        for (String color : colors) {
            temp.add(new PageItemX(createDeckButton(color)));
        }
        return temp;
    }

    protected class ButtonEventHandler implements EventHandler<ActionEvent> {

        @Override
        public void handle(ActionEvent t) {
            SingleSelectionModel<PageX> selectionModel = (SingleSelectionModel<PageX>) pager.getSelectionModel();
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
