package jfxtras.scene.control.test;

import jfxtras.scene.control.*;
import javafx.application.*;
import javafx.scene.*;
import javafx.scene.paint.*;
import javafx.stage.*;
import javafx.scene.image.*;

public class ImageFillX_simple extends Application {
    public static void main(String[] args) {
        Application.launch(ImageFillX_simple.class, args);
    }
    @Override
    public void start(Stage primaryStage) {
        Group root = new Group();
        Stop[] stop = new Stop[]{new Stop(0, Color.web("#999999")), new Stop(1, Color.web("#000000"))};
        LinearGradient linearGradient = new LinearGradient(0, 0, 1, 1, true, CycleMethod.NO_CYCLE, stop);
        Scene scene = new Scene(root, 600, 400, linearGradient);
        primaryStage.setScene(scene);
        primaryStage.show();
        root.getChildren().add(new ImageFillX()//
                .width(scene.widthProperty().subtract(100))//
                .height(scene.heightProperty().subtract(100))//
                .x(50)//
                .y(50)//
                .image(new Image(this.getClass().getResourceAsStream("ImageFillX_simple.jpg")))//
                .node());
    }
}
