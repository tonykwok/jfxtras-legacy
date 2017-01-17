package jfxtras.scene.control;

import javafx.scene.*;
import javafx.scene.shape.*;
import javafx.beans.property.*;
import javafx.beans.value.*;
import javafx.scene.image.*;
import javafx.beans.binding.*;

public class ImageFillX {
    private SimpleDoubleProperty height;
    private SimpleDoubleProperty width;
    private SimpleDoubleProperty x;
    private SimpleDoubleProperty y;
    private ImageView imageView;
    private Group root;
    public ImageFillX() {
        width = new SimpleDoubleProperty(300);
        height = new SimpleDoubleProperty(200);
        x = new SimpleDoubleProperty(0);
        y = new SimpleDoubleProperty(0);
        imageView = new ImageView();
        imageView.setPreserveRatio(true);
        root = new Group();
        root.getChildren().add(imageView);
        Rectangle clip = new Rectangle();
        clip.widthProperty().bind(width);
        clip.heightProperty().bind(height);
        root.setClip(clip);
        root.translateXProperty().bindBidirectional(x);
        root.translateYProperty().bindBidirectional(y);
        addWatchers();
    }
    private void addWatchers() {
        width.addListener(new ChangeListener<Number>() {
            public void changed(ObservableValue<? extends Number> observable, Number oldValue, Number newValue) {
                adjust();
            }
        });
        height.addListener(new ChangeListener<Number>() {
            public void changed(ObservableValue<? extends Number> observable, Number oldValue, Number newValue) {
                adjust();
            }
        });
    }
    private void adjust() {
        if (width.get() / imageView.getBoundsInLocal().getWidth() > height.get() / imageView.getBoundsInLocal().getHeight()) {
            imageView.setFitHeight(0);
            imageView.setFitWidth(width.get());
        } else {
            imageView.setFitWidth(0);
            imageView.setFitHeight(height.get());
        }
    }
    public ImageFillX width(DoubleProperty nn) {
        width.bind(nn);
        return this;
    }
    public ImageFillX width(double nn) {
        width.set(nn);
        return this;
    }
    public ImageFillX width(int nn) {
        width.set(nn);
        return this;
    }
    public ImageFillX width(DoubleBinding nn) {
        nn.addListener(new ChangeListener<Number>() {
            public void changed(ObservableValue<? extends Number> observable, Number oldValue, Number newValue) {
                width(newValue.doubleValue());
            }
        });
        width(nn.get());
        return this;
    }
    public ImageFillX height(DoubleProperty nn) {
        height.bind(nn);
        return this;
    }
    public ImageFillX height(double nn) {
        height.set(nn);
        return this;
    }
    public ImageFillX height(int nn) {
        height.set(nn);
        return this;
    }
    public ImageFillX height(DoubleBinding nn) {
        nn.addListener(new ChangeListener<Number>() {
            public void changed(ObservableValue<? extends Number> observable, Number oldValue, Number newValue) {
                height(newValue.doubleValue());
            }
        });
        height(nn.get());
        return this;
    }
    public ImageFillX x(DoubleProperty nn) {
        x.bind(nn);
        return this;
    }
    public ImageFillX x(double nn) {
        x.set(nn);
        return this;
    }
    public ImageFillX x(int nn) {
        x.set(nn);
        return this;
    }
    public ImageFillX x(DoubleBinding nn) {
        nn.addListener(new ChangeListener<Number>() {
            public void changed(ObservableValue<? extends Number> observable, Number oldValue, Number newValue) {
                x(newValue.doubleValue());
            }
        });
        x(nn.get());
        return this;
    }
    public ImageFillX y(DoubleProperty nn) {
        y.bind(nn);
        return this;
    }
    public ImageFillX y(double nn) {
        y.set(nn);
        return this;
    }
    public ImageFillX y(int nn) {
        y.set(nn);
        return this;
    }
    public ImageFillX y(DoubleBinding nn) {
        nn.addListener(new ChangeListener<Number>() {
            public void changed(ObservableValue<? extends Number> observable, Number oldValue, Number newValue) {
                y(newValue.doubleValue());
            }
        });
        y(nn.get());
        return this;
    }
    public ImageFillX image(Image it) {
        imageView.setImage(it);
        adjust();
        return this;
    }
    public Node node() {
        return root;
    }
}
