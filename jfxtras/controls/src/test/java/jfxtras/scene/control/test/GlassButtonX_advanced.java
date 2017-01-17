package jfxtras.scene.control.test;

import jfxtras.scene.control.*;
import javafx.scene.shape.*;
import javax.swing.JOptionPane;
import javafx.application.*;
import javafx.scene.*;
import javafx.scene.paint.*;
import javafx.stage.*;

public class GlassButtonX_advanced extends Application {
    public static void main(String[] args) {
	Application.launch(GlassButtonX_advanced.class, args);
    }
    @Override
    public void start(Stage primaryStage) {
	Group root = new Group();
	Stop[] stop = new Stop[]{new Stop(0, Color.web("#999999")), new Stop(1, Color.web("#000000"))};
	LinearGradient linearGradient = new LinearGradient(0, 0, 1,1, true, CycleMethod.NO_CYCLE, stop);
	Scene scene = new Scene(root, 600, 500, linearGradient);
	primaryStage.setScene(scene);
	primaryStage.show();
	Circle circleRed = new Circle();
	circleRed.setRadius(1000);
	circleRed.setFill(Color.web("#aa0000"));
	GlassButtonX glassButton1 = new GlassButtonX() {
		@Override public void onClick() {JOptionPane.showMessageDialog(null, "red click");}
		}
	    .width(scene.widthProperty().subtract(40))
	    .height(scene.heightProperty().subtract(170))
	    .content(circleRed)
	    .x(20)
	    .y(20);
	root.getChildren().add(glassButton1.node());
	Circle circleGreen = new Circle();
	circleGreen.setRadius(1000);
	circleGreen.setFill(Color.web("#009900"));
	GlassButtonX glassButton2 = new GlassButtonX() {
		@Override public void onClick() {JOptionPane.showMessageDialog(null, "green click");}
		}
	    .width(100)
	    .height(100)
	    .content(circleGreen)
	    .x(20)
	    .y(scene.heightProperty().subtract(120));
	root.getChildren().add(glassButton2.node());
	Circle circleBlue = new Circle();
	circleBlue.setRadius(1000);
	circleBlue.setFill(Color.web("#0000ff"));
	GlassButtonX glassButton3 = new GlassButtonX() {
		@Override public void onClick() {JOptionPane.showMessageDialog(null, "blue click");}
		}
	    .width(100)
	    .height(100)
	    .content(circleBlue)
	    .x(scene.widthProperty().subtract(120))
	    .y(scene.heightProperty().subtract(120));
	root.getChildren().add(glassButton3.node());
	Circle circleMagenta = new Circle();
	circleMagenta.setRadius(1000);
	circleMagenta.setFill(Color.web("#ff00ff"));
	GlassButtonX glassButton4 = new GlassButtonX() {
		@Override public void onClick() {JOptionPane.showMessageDialog(null, "magenta click");}
		}
	    .width(100)
	    .height(100)
	    .content(circleMagenta)
	    .x(scene.widthProperty().divide(2).subtract(50))
	    .y(scene.heightProperty().subtract(120));
	root.getChildren().add(glassButton4.node());
    }
}

