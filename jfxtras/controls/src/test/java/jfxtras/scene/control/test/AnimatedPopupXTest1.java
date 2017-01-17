package jfxtras.scene.control.test;

import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.event.ActionEvent;
import javafx.event.EventHandler;
import javafx.scene.control.Button;
import javafx.scene.control.ListView;
import javafx.scene.text.Font;
import jfxtras.application.ExtendedApplicationX;
import jfxtras.scene.control.AnimatedPopupX;


/**
 *
 * @author Goran Lochert
 */
public class AnimatedPopupXTest1 extends ExtendedApplicationX {

    public static void main(String[] args) {
        launchWithPrelaunch(AnimatedPopupXTest1.class, args);
    }

    @Override
    protected void setup() {
        final AnimatedPopupX popup = new AnimatedPopupX();       
        final Button btn = new Button("click meeeeeeeeee");
        btn.setOnAction(new EventHandler<ActionEvent>() {

            @Override
            public void handle(ActionEvent t) {
                if (popup.isShowing()) {
                    popup.doHide();

                } else {
                    popup.show(btn, 0, 0);
                }
            }
        });

        ObservableList<String> fontlist = FXCollections.observableArrayList(Font.getFamilies());
        ListView<String> lv = new ListView<String>(fontlist);
        lv.setPrefHeight(180);
        lv.prefWidthProperty().bind(btn.widthProperty());
        popup.setContentNode(lv);
        root.getChildren().add(btn);
    }
}
