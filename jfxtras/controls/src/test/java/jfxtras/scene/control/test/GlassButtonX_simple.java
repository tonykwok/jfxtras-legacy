package jfxtras.scene.control.test;

import jfxtras.scene.control.*;
import javafx.scene.shape.*;
import javax.swing.JOptionPane;
import javafx.application.*;
import javafx.scene.*;
import javafx.scene.paint.*;
import javafx.stage.*;

public class GlassButtonX_simple extends Application {
    public static void main(String[] args) {
	Application.launch(GlassButtonX_simple.class, args);
    }
    @Override
    public void start(Stage primaryStage) {
	Group root = new Group();
	Stop[] stop = new Stop[]{new Stop(0, Color.web("#999999")), new Stop(1, Color.web("#000000"))};
	LinearGradient linearGradient = new LinearGradient(0, 0, 1,1, true, CycleMethod.NO_CYCLE, stop);
	Scene scene = new Scene(root, 600, 400, linearGradient);
	primaryStage.setScene(scene);
	primaryStage.show();
	Circle circle = new Circle();
	circle.setRadius(1000);
	circle.setFill(Color.web("#aa0000"));
	root.getChildren().add(new GlassButtonX() {
		@Override public void onClick() {
		    JOptionPane.showMessageDialog(null, "click");
		    }
		}
	    .width(150)
	    .height(100)
	    .content(circle)
	    .x(100)
	    .y(20).node());
    }
}

