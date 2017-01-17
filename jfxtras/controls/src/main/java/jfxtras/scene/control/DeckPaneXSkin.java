package jfxtras.scene.control;

import javafx.beans.property.SimpleDoubleProperty;
import com.sun.javafx.scene.control.skin.SkinBase;
import javafx.animation.Animation;
import javafx.animation.Animation.Status;
import javafx.animation.FadeTransition;
import javafx.animation.Interpolator;
import javafx.animation.KeyFrame;
import javafx.animation.KeyValue;
import javafx.animation.ScaleTransition;
import javafx.animation.Timeline;
import javafx.beans.binding.ObjectBinding;
import javafx.beans.property.DoubleProperty;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.event.ActionEvent;
import javafx.event.EventHandler;
import javafx.scene.Node;
import javafx.scene.control.SingleSelectionModel;
import javafx.scene.effect.Effect;
import javafx.scene.effect.PerspectiveTransform;
import javafx.scene.layout.StackPane;
import javafx.util.Duration;
import static java.lang.Math.*;

/**
 *
 * @author Goran Lochert
 */
public class DeckPaneXSkin extends SkinBase<DeckPaneX, DeckPaneXBehavior> {

    private Node visibleNodeRef = null;
    // add it with CSS
    private Duration animationDuration;
    private Timeline timeline;
    private StackPane contentStack;
    private boolean removeNode = true;
    private DoubleProperty angle;
    private AnimationModeX mode;
    private Animation animation;
    private SingleSelectionModel<Node> selectionModel;

    public DeckPaneXSkin(DeckPaneX deckPane) {
        super(deckPane, new DeckPaneXBehavior(deckPane));
        init();


    }

    private void init() {


        registerChangeListener(getSkinnable().animationModeProperty(), "ANIMATION_MODE");
        registerChangeListener(getSkinnable().animationDurationProperty(), "ANIMATION_DURATION");
        registerChangeListener(getSkinnable().backgroundNodeProperty(), "BACKGROUND_NODE");
        registerChangeListener(getSkinnable().getSelectionModel().selectedItemProperty(), "SELECTED_ITEM");


        contentStack = new StackPane();
        updateAnimationMode();
        updateAnimationDuration();
        updateSelectionModel();
        updateVisibleNode();


        if (getSkinnable().getBackgroundNode() != null) {
            getChildren().add(getSkinnable().getBackgroundNode());
        }
        if (visibleNodeRef != null) {
            contentStack.getChildren().add(visibleNodeRef);
        }

        getChildren().add(contentStack);

    }

    private DoubleProperty angleProperty() {
        if (angle == null) {
            angle = new SimpleDoubleProperty(90.0d);
        }
        return angle;
    }

    private void updateSelectionModel() {
        selectionModel = (SingleSelectionModel<Node>) getSkinnable().getSelectionModel();
    }

    private void updateAnimationMode() {
        mode = getSkinnable().getAnimationMode();
    }

    private void updateAnimationDuration() {
        animationDuration = getSkinnable().getAnimationDuration();
    }

    @Override
    protected void handleControlPropertyChanged(String string) {
        super.handleControlPropertyChanged(string);
        if (string.equals("VISIBLE_NODE")) {
            doAnimationTransition();
        } else if (string.equals("ANIMATION_MODE")) {
            updateAnimationMode();
        } else if (string.equals("ANIMATION_DURATION")) {
            updateAnimationDuration();
        } else if (string.equals("BACKGROUND_NODE")) {
            setupBackgroundNode();
        } else if (string.equals("SELECTED_ITEM")) {
            doAnimationTransition();
        }
    }

    private void doAnimationTransition() {
        if (mode == AnimationModeX.NO_ANIMATION) {
            updateVisibleNode();
            contentStack.getChildren().setAll(visibleNodeRef);
            return;
        }
        if (timeline != null) {

//            System.out.println("----> timeline status: " + timeline.getStatus());
            if (timeline.getStatus() == Status.RUNNING) {
                timeline.stop();
            }
        }

        if (animation != null) {
            if (animation.getStatus() == Status.RUNNING) {
                animation.stop();
            }
        }

        timeline = new Timeline();
        timeline.setCycleCount(1);
        timeline.getKeyFrames().setAll(generateKeyFrames());

        timeline.setOnFinished(new EventHandler<ActionEvent>() {

            @Override
            public void handle(ActionEvent event) {
                System.out.println("-- TIME LINE FINISHED -- ");
            }
        });
        timeline.playFromStart();
    }

    private ObservableList<KeyFrame> generateKeyFrames() {
        ObservableList<KeyFrame> frames = FXCollections.<KeyFrame>observableArrayList();


        if (removeNode) {
            KeyFrame keyFrame1 = new KeyFrame(Duration.ONE, new EventHandler<ActionEvent>() {

                @Override
                public void handle(ActionEvent event) {
                    if (mode == AnimationModeX.PERSPECTIVE) {
                        contentStack.effectProperty().bind(new ObjectBinding<Effect>() {

                            {
                                super.bind(angleProperty());
                            }

                            @Override
                            protected Effect computeValue() {
                                return getTransform(contentStack.getLayoutBounds().getWidth(), contentStack.getLayoutBounds().getHeight());
                            }
                        });
                        angle.setValue(90.0d);
                    }
                    animation = createOutAnimation();

                    animation.playFromStart();
                }
            });

            frames.setAll(keyFrame1);
        } else {
            KeyFrame keyFrame1 = new KeyFrame(Duration.ONE, new EventHandler<ActionEvent>() {

                @Override
                public void handle(ActionEvent event) {
                    removeNode = true;
                    updateVisibleNode();
//                    visibleNodeRef = getSkinnable().getSelectionModel().getSelectedItem();

                    if (mode == AnimationModeX.PERSPECTIVE) {
                        contentStack.effectProperty().bind(new ObjectBinding<Effect>() {

                            {
                                super.bind(angleProperty());
                            }

                            @Override
                            protected Effect computeValue() {
                                return getTransform(contentStack.getLayoutBounds().getWidth(), contentStack.getLayoutBounds().getHeight());
                            }
                        });
                        angle.set(0.0d);
                    }
                    contentStack.setCache(true);
                    contentStack.getChildren().setAll(visibleNodeRef);
                    animation = createInAnimation();
                    animation.playFromStart();
//                    contentStack.getParent().impl_transformsChanged();
                }
            });
            frames.setAll(keyFrame1);

        }
        return frames;
    }

    private void updateVisibleNode() {
        if (selectionModel != null) {
            visibleNodeRef = selectionModel.getSelectedItem();
            return;
        }

    }

    private Animation createOutAnimation() {
        // finish handler
        EventHandler<ActionEvent> onFinishedHandler = new EventHandler<ActionEvent>() {

            @Override
            public void handle(ActionEvent event) {
                contentStack.effectProperty().unbind();
                contentStack.setCache(false);
                removeNode = false;
                doAnimationTransition();
            }
        };

        if (mode == AnimationModeX.SCALE) {
            ScaleTransition st = new ScaleTransition(animationDuration, contentStack);
            st.setFromX(1.0);
            st.setFromY(1.0);
            st.setToX(0.0);
            st.setToY(0.0);
            st.setInterpolator(Interpolator.EASE_OUT);
            st.setCycleCount(1);
            st.setOnFinished(onFinishedHandler);
            return st;
        } else if (mode == AnimationModeX.PERSPECTIVE) {
            Timeline perspectiveTimeline = new Timeline();
            perspectiveTimeline.setCycleCount(1);
            perspectiveTimeline.getKeyFrames().addAll(
                    new KeyFrame(animationDuration,
                    onFinishedHandler,
                    new KeyValue(angleProperty(), 180.0d, Interpolator.EASE_OUT)));
            return perspectiveTimeline;
        } else {
            FadeTransition ft = new FadeTransition(animationDuration, contentStack);
            ft.setFromValue(1.0);
            ft.setToValue(0.0);
            ft.setInterpolator(Interpolator.EASE_OUT);
            ft.setCycleCount(1);
            ft.setOnFinished(onFinishedHandler);
            return ft;
        }
    }

    private Animation createInAnimation() {
        if (mode == AnimationModeX.SCALE) {
            ScaleTransition st = new ScaleTransition(animationDuration, contentStack);
            st.setFromX(0.0);
            st.setFromY(0.0);
            st.setToX(1.0);
            st.setToY(1.0);
            st.setInterpolator(Interpolator.EASE_IN);
            st.setCycleCount(1);
            return st;
        } else if (mode == AnimationModeX.PERSPECTIVE) {
            Timeline perspectiveTimeline = new Timeline();
            perspectiveTimeline.setCycleCount(1);
            perspectiveTimeline.getKeyFrames().addAll(
                    new KeyFrame(animationDuration,
                    new EventHandler<ActionEvent>() {

                        @Override
                        public void handle(ActionEvent event) {
                            contentStack.effectProperty().unbind();
                        }
                    },
                    new KeyValue(angleProperty(), 90.0d, Interpolator.EASE_IN)));
            return perspectiveTimeline;
        } else {
            FadeTransition ft = new FadeTransition(animationDuration, contentStack);
            ft.setFromValue(0.0);
            ft.setToValue(1.0);
            ft.setInterpolator(Interpolator.EASE_IN);
            ft.setCycleCount(1);
            return ft;
        }
    }

    private PerspectiveTransform getTransform(double width, double height) {
        PerspectiveTransform transform = new PerspectiveTransform();
        double ox = 0;
        double oy = 0;
        double pw = width;
        double ph = height;
        double radius = pw / 2;
        double back = ph / 10;
        double t = toRadians(angle.get());

        transform.setUlx(ox + radius - sin(t) * radius);
        transform.setUly(oy + 0 - cos(t) * back);
        transform.setUrx(ox + radius + sin(t) * radius);
        transform.setUry(oy + 0 + cos(t) * back);
        transform.setLrx(ox + radius + sin(t) * radius);
        transform.setLry(oy + ph - cos(t) * back);
        transform.setLlx(ox + radius - sin(t) * radius);
        transform.setLly(oy + ph + cos(t) * back);
        return transform;
    }

    private void setupBackgroundNode() {
        int size = getChildren().size();
        if (size == 0) {
            return;
        }
        if (size == 1) {
            getChildren().clear();
            getChildren().add(getSkinnable().getBackgroundNode());
            getChildren().add(contentStack);
        } else if (size == 2) {
            getChildren().set(0, getSkinnable().getBackgroundNode());
        }
    }
}