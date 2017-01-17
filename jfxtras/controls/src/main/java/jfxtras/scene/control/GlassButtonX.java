package jfxtras.scene.control;

import javafx.event.*;
import javafx.scene.*;
import javafx.scene.paint.*;
import javafx.scene.shape.*;
import javafx.beans.property.*;
import javafx.scene.input.*;
import javafx.geometry.*;
import javafx.scene.transform.*;
import javafx.scene.effect.*;
import javafx.beans.value.*;

import javafx.beans.binding.*;

public class GlassButtonX {
    private SimpleDoubleProperty width;
    private SimpleDoubleProperty height;
    private SimpleDoubleProperty x;
    private SimpleDoubleProperty y;
    private Node node;
    private SimpleObjectProperty<Node> content;
    private Rectangle flare;
    private Group contentGroup;
    private Group shadowGroup;
    private Group backGroup;
    public GlassButtonX() {
	width = new SimpleDoubleProperty(90);
	height = new SimpleDoubleProperty(60);
	x = new SimpleDoubleProperty(0);
	y = new SimpleDoubleProperty(0);
	content = new SimpleObjectProperty<Node>();
	Rectangle t = new Rectangle();
	t.setFill(Color.web("#ff0000"));
	content.set(t);
	backGroup = new Group();
	Rectangle r1 = new Rectangle();
	r1.setArcHeight(8);
	r1.setArcWidth(8);
	r1.setStroke(Color.web("#ffffff99"));
	r1.setStrokeWidth(1.0);
	r1.widthProperty().bind(width);
	r1.heightProperty().bind(height);
	r1.setFill(Color.web("#ffffff00"));
	backGroup.getChildren().add(r1);
	Rectangle r2 = new Rectangle();
	r2.setArcHeight(8);
	r2.setArcWidth(8);
	r2.setStroke(Color.web("#ffffff22"));
	r2.setStrokeWidth(3.0);
	r2.widthProperty().bind(width);
	r2.heightProperty().bind(height);
	r2.setFill(Color.web("#ffffff00"));
	backGroup.getChildren().add(r2);
	Rectangle r3 = new Rectangle();
	r3.setArcHeight(8);
	r3.setArcWidth(8);
	r3.setStroke(Color.web("#ffffff22"));
	r3.setStrokeWidth(5.0);
	r3.widthProperty().bind(width);
	r3.heightProperty().bind(height);
	r3.setFill(Color.web("#ffffff00"));
	backGroup.getChildren().add(r3);
	Rectangle r4 = new Rectangle();
	r4.setArcHeight(8);
	r4.setArcWidth(8);
	r4.widthProperty().bind(width);
	r4.heightProperty().bind(height);
	r4.setFill(Color.web("#ffffff00"));
	Stop[] s4 = new Stop[]{new Stop(0, Color.web("#ffffff99")), new Stop(1, Color.web("#ffffff00"))};
	LinearGradient g4 = new LinearGradient(0, 1, 0, 0.5, true, CycleMethod.NO_CYCLE, s4);
	r4.setFill(g4);
	backGroup.getChildren().add(r4);
	flare = new Rectangle();
	flare.setArcHeight(8);
	flare.setArcWidth(8);
	flare.widthProperty().bind(width);
	flare.heightProperty().bind(height);
	flare.setFill(Color.web("#ffffff00"));
	Stop[] s5 = new Stop[]{new Stop(0, Color.web("#ffffffcc")), new Stop(0.99, Color.web("#ffffff33")), new Stop(1, Color.web("#ffffff00"))};
	LinearGradient g5 = new LinearGradient(0, 0, 0.0, 0.45, true, CycleMethod.NO_CYCLE, s5);
	flare.setFill(g5);
	flare.setCursor(Cursor.HAND);
	flare.setOnMousePressed(new EventHandler<MouseEvent>() {
	    @Override
	    public void handle(MouseEvent event) {
		onClick();
	    }
	});
	flare.hoverProperty().addListener(new ChangeListener<Boolean>() {
	    @Override
	    public void changed(ObservableValue<? extends Boolean> observable, Boolean oldValue, Boolean newValue) {
		adjustOpacity();
	    }
	});
	width.addListener(new ChangeListener<Number>() {
	    public void changed(ObservableValue<? extends Number> observable, Number oldValue, Number newValue) {
		adjustSize();
	    }
	});
	height.addListener(new ChangeListener<Number>() {
	    public void changed(ObservableValue<? extends Number> observable, Number oldValue, Number newValue) {
		adjustSize();
	    }
	});
	Group root = new Group();
	root.getChildren().add(backGroup);
	contentGroup = new Group();
	shadowGroup = new Group();
	contentGroup.boundsInLocalProperty().addListener(new ChangeListener<Bounds>() {
	    public void changed(ObservableValue<? extends Bounds> observable, Bounds oldValue, Bounds newValue) {
		adjustSize();
	    }
	});
	DropShadow ds = new DropShadow();
	shadowGroup.setEffect(ds);
	contentGroup.boundsInLocalProperty().getValue();//bug with stupid lazy binding
	contentGroup.getChildren().add(content.get());
	backGroup.getChildren().add(shadowGroup);
	shadowGroup.getChildren().add(contentGroup);
	root.getChildren().add(flare);
	root.translateXProperty().bindBidirectional(x);
	root.translateYProperty().bindBidirectional(y);
	node = root;
    }
    void adjustSize() {
	double contentWidth = content.get().getBoundsInLocal().getWidth();
	double contentHeight = content.get().getBoundsInLocal().getHeight();
	double contentX = content.get().getBoundsInLocal().getMinX();
	double contentY = content.get().getBoundsInLocal().getMinY();
	if (contentWidth > 0 && contentHeight > 0 && width.get() > 0 && height.get() > 0) {
	    double widthScale = (width.get() - 16) / contentWidth;
	    double heightScale = (height.get() - 16) / contentHeight;
	    double scaleSize = widthScale < heightScale ? widthScale : heightScale;
	    Scale scaleTransform = new Scale(scaleSize, scaleSize, 0, 0);
	    contentGroup.getTransforms().clear();
	    contentGroup.getTransforms().add(scaleTransform);
	    double xShift = (width.get() - contentWidth * scaleSize - 16) / 2 + 8;
	    double yShift = (height.get() - contentHeight * scaleSize - 16) / 2 + 8;
	    contentGroup.setTranslateX(xShift - contentX * scaleSize);
	    contentGroup.setTranslateY(yShift - contentY * scaleSize);
	}
    }
    void adjustOpacity() {
	if (flare.isHover()) {
	    flare.setOpacity(1.0);
	    contentGroup.setOpacity(1.0);
	} else {
	    flare.setOpacity(0.5);
	    contentGroup.setOpacity(0.5);
	}
    }
    public Node node() {
	adjustOpacity();
	adjustSize();
	return node;
    }
    public GlassButtonX content(Node n) {
	this.content.set(n);
	contentGroup.getChildren().clear();
	contentGroup.getChildren().add(content.get());
	return this;
    }
    public SimpleObjectProperty<Node> content() {
	return content;
    }
    public GlassButtonX width(DoubleProperty nn) {
	this.width.bindBidirectional(nn);
	return this;
    }
    public GlassButtonX width(double nn) {
	this.width.set(nn);
	return this;
    }
    public GlassButtonX width(int nn) {
	this.width.set(nn);
	return this;
    }
    public SimpleDoubleProperty width() {
	return width;
    }
    public GlassButtonX width(DoubleBinding nn) {
	nn.addListener(new ChangeListener<Number>() {
	    public void changed(ObservableValue<? extends Number> observable, Number oldValue, Number newValue) {
		width(newValue.doubleValue());
	    }
	});
	width(nn.get());
	return this;
    }
    public GlassButtonX x(DoubleProperty nn) {
	this.x.bindBidirectional(nn);
	return this;
    }
    public GlassButtonX x(double nn) {
	this.x.set(nn);
	return this;
    }
    public GlassButtonX x(int nn) {
	this.x.set(nn);
	return this;
    }
    public SimpleDoubleProperty x() {
	return x;
    }
    public GlassButtonX x(DoubleBinding nn) {
	nn.addListener(new ChangeListener<Number>() {
	    public void changed(ObservableValue<? extends Number> observable, Number oldValue, Number newValue) {
		x(newValue.doubleValue());
	    }
	});
	x(nn.get());
	return this;
    }
    public GlassButtonX y(DoubleProperty nn) {
	this.y.bindBidirectional(nn);
	return this;
    }
    public GlassButtonX y(double nn) {
	this.y.set(nn);
	return this;
    }
    public GlassButtonX y(int nn) {
	this.y.set(nn);
	return this;
    }
    public SimpleDoubleProperty y() {
	return y;
    }
    public GlassButtonX y(DoubleBinding nn) {
		nn.addListener(new ChangeListener<Number>() {
			public void changed(ObservableValue<? extends Number> observable, Number oldValue, Number newValue) {
				y(newValue.doubleValue());
				}
			}
		);
	y(nn.get());
	return this;
    }
    public GlassButtonX height(DoubleProperty nn) {
	this.height.bindBidirectional(nn);
	return this;
    }
    public GlassButtonX height(double nn) {
	this.height.set(nn);
	return this;
    }
    public GlassButtonX height(int nn) {
	this.height.set(nn);
	return this;
    }
    public GlassButtonX height(DoubleBinding nn) {
	nn.addListener(new ChangeListener<Number>() {
	    public void changed(ObservableValue<? extends Number> observable, Number oldValue, Number newValue) {
		height(newValue.doubleValue());
	    }
	});
	height(nn.get());
	return this;
    }
    public SimpleDoubleProperty height() {
	return height;
    }
    public void onClick() {
    }
}
