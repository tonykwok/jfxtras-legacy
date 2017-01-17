package jfxtras.scene.control;

import javafx.animation.Animation;
import javafx.animation.Interpolator;
import javafx.animation.KeyFrame;
import javafx.animation.KeyValue;
import javafx.animation.Timeline;
import javafx.beans.InvalidationListener;
import javafx.beans.Observable;
import javafx.beans.property.DoubleProperty;
import javafx.beans.property.SimpleDoubleProperty;
import javafx.event.ActionEvent;
import javafx.event.EventHandler;
import javafx.geometry.HPos;
import javafx.geometry.VPos;
import javafx.scene.Node;
import javafx.scene.control.Skin;
import javafx.scene.layout.StackPane;
import javafx.scene.shape.Rectangle;
import javafx.util.Duration;

/**
 *
 * @author Goran Lochert
 */
public class AnimatedPopupXSkin extends StackPane implements Skin<AnimatedPopupX> {

    private AnimatedPopupX popup;
    private Timeline timeline;
    private Node contentNode;
    private ContentStack contentStack;
    private DoubleProperty transition = new SimpleDoubleProperty(0.0) {

        @Override
        protected void invalidated() {
            requestLayout();
        }
    };

    // ===========================
    // CONSTRUCTOR/S
    // ===========================
    public AnimatedPopupXSkin(AnimatedPopupX animatedPopup) {
        this.popup = animatedPopup;
        init();
    }

    // ===========================
    // PRIVATE METHODS
    // ===========================
    private void init() {

        contentNode = popup.getContentNode();
        contentStack = new ContentStack(contentNode);
        contentStack.getStyleClass().add("content");

        popup.visibleProperty().addListener(new InvalidationListener() {

            @Override
            public void invalidated(Observable o) {
                doAnimation();
            }
        });

        getChildren().add(contentStack);
        idProperty().bind(popup.idProperty());
        styleProperty().bind(popup.styleProperty());
        getStyleClass().setAll(popup.getStyleClass());

    }

    private double getTransition() {
        return transition.get();
    }

    private void doAnimation() {

        Duration duration;
        if ((this.timeline != null) && (this.timeline.getStatus() != Animation.Status.STOPPED)) {
            duration = this.timeline.getCurrentTime();
            this.timeline.stop();
        } else {
            duration = popup.getAnimationDuration();
        }

        timeline = new Timeline();
        timeline.setCycleCount(1);
        KeyFrame keyFrame1;
        KeyFrame keyFrame2;
        //
        if (getSkinnable().isVisible()) {
            // kf1
            keyFrame1 = new KeyFrame(
                    Duration.ZERO,
                    new EventHandler<ActionEvent>() {

                        @Override
                        public void handle(ActionEvent event) {
                            contentStack.getContentNode().setCache(true);
                        }
                    },
                    new KeyValue(transition, 0.0d, Interpolator.EASE_IN));
            // kf2
            keyFrame2 = new KeyFrame(
                    duration,
                    new EventHandler<ActionEvent>() {

                        @Override
                        public void handle(ActionEvent event) {
                            contentStack.getContentNode().setCache(false);
                            contentStack.getContentNode().requestFocus();
                        }
                    },
                    new KeyValue(transition, 1.0d, Interpolator.EASE_OUT));
        } else {
            keyFrame1 = new KeyFrame(
                    Duration.ZERO,
                    new EventHandler<ActionEvent>() {

                        @Override
                        public void handle(ActionEvent event) {
                            contentStack.getContentNode().setCache(true);
                        }
                    },
                    new KeyValue(transition, 1.0d, Interpolator.EASE_IN));
            //
            keyFrame2 = new KeyFrame(
                    duration,
                    new EventHandler<ActionEvent>() {

                        @Override
                        public void handle(ActionEvent event) {
                            contentStack.getContentNode().setCache(false);
                            popup.hide();
                        }
                    },
                    new KeyValue(transition, 0.0d, Interpolator.EASE_OUT));
        } // end if-else

        timeline.getKeyFrames().setAll(keyFrame1, keyFrame2);
        timeline.play();
    }

    // ===========================
    // OVERRIDES
    // ===========================
    @Override
    protected double computePrefWidth(double d) {
        return getInsets().getLeft() + contentStack.prefWidth(-1) + getInsets().getRight();
    }

    @Override
    protected void layoutChildren() {
        double top = getInsets().getTop();
        double right = getInsets().getRight();
//        double bottom = getInsets().getBottom();
        double left = getInsets().getLeft();
        double width = this.getWidth();
//        double height = this.getHeight();
        double areaHeight = contentStack.prefHeight(-1) * getTransition();
        contentStack.resize(width, areaHeight);
        positionInArea(contentStack, left, top, width - left - right, areaHeight, 0.0, HPos.CENTER, VPos.TOP);
    }

    @Override
    public AnimatedPopupX getSkinnable() {
        return popup;
    }

    @Override
    public Node getNode() {
        return this;
    }

    @Override
    public void dispose() {
        popup = null;
    }

    // ===========================
    // PRIVATE CLASS
    // ===========================
    class ContentStack extends StackPane {

        private Node contentNode;
        private Rectangle clipRectangle; // clip for better sliding effect without clip it looks ugly

        public ContentStack(Node contentNode) {
            this.contentNode = contentNode;
            init();
        }

        public Node getContentNode() {
            return contentNode;
        }

        public void setContentNode(Node contentNode) {
            this.contentNode = contentNode;
        }

        private void init() {
            clipRectangle = new Rectangle();
            setClip(clipRectangle); // comment this to see animation without clip
            getChildren().add(contentNode);
        }

        @Override
        protected void setWidth(double width) {
            // resize stack and clip at same time to get nicer slide effect
            super.setWidth(width);
            clipRectangle.setWidth(width);
        }

        @Override
        protected void setHeight(double height) {
            // resize stack and clip at same time to get nicer slide effect
            super.setHeight(height);
            clipRectangle.setHeight(height);
        }

        @Override
        protected void layoutChildren() {
            double top = getInsets().getTop();
            double right = getInsets().getRight();
            double bottom = getInsets().getBottom();
            double left = getInsets().getLeft();
            double width = this.getWidth();
            double height = this.getHeight();
            double widthWithoutInsets = width - left - right;
            double heightWithoutInsets = height - top - bottom;

            // calculate width and height depending on node is managed
            double pw = contentNode.isManaged() ? widthWithoutInsets : Math.min(widthWithoutInsets, contentNode.prefWidth(-1.0D));
            double ph = contentNode.isManaged() ? contentNode.prefHeight(-1.0D) : Math.min(heightWithoutInsets, contentNode.prefHeight(-1.0D));

            // resize and position content node
            contentNode.resize(pw, ph);
            positionInArea(contentNode, left, top, pw, ph, 0.0D, HPos.CENTER, VPos.CENTER);
        }
    }
}
