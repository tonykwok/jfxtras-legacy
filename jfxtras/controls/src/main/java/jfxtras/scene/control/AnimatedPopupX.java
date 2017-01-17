package jfxtras.scene.control;

import com.sun.javafx.Utils;
import com.sun.javafx.css.StyleManager;
import javafx.beans.property.BooleanProperty;
import javafx.beans.property.ObjectProperty;
import javafx.beans.property.SimpleBooleanProperty;
import javafx.beans.property.SimpleObjectProperty;
import javafx.geometry.HPos;
import javafx.geometry.Point2D;
import javafx.geometry.VPos;
import javafx.scene.Node;
import javafx.scene.control.PopupControl;
import javafx.util.Duration;

/**
 *
 * @author Goran Lochert
 */
public class AnimatedPopupX extends PopupControl {

    private static final String DEFAULT_STYLE_CLASS = "animated-popupx";
    private BooleanProperty visible;
    private ObjectProperty<Duration> animationDuration;
    private ObjectProperty<Node> contentNode;

    // ==================================
    // PROPERTIES
    // ==================================    
    public ObjectProperty<Node> contentNodeProperty() {
        if (contentNode == null) {
            contentNode = new SimpleObjectProperty<Node>();
        }
        return contentNode;
    }

    public final void setContentNode(Node value) {
        contentNodeProperty().set(value);
    }

    public final Node getContentNode() {
        return contentNode == null ? null : contentNode.get();
    }

    public BooleanProperty visibleProperty() {
        if (visible == null) {
            visible = new SimpleBooleanProperty(this, "showing", false);
        }
        return visible;
    }

    public final boolean isVisible() {
        return visible == null ? false : visible.get();
    }

    public final void setVisible(boolean value) {
        visibleProperty().set(value);
    }

    public ObjectProperty<Duration> animationDurationProperty() {
        if (animationDuration == null) {
            animationDuration = new SimpleObjectProperty<Duration>(this, "animationDuration", new Duration(250.0d));
        }
        return animationDuration;
    }

    public final void setAnimationDuration(Duration value) {
        animationDurationProperty().set(value);
    }

    public Duration getAnimationDuration() {
        return animationDuration == null ? new Duration(250.0d) : animationDuration.get();

    }

    // ==================================
    // CONSTRUCTORS
    // ==================================    
    public AnimatedPopupX() {
        init();
    }

    // ==================================
    // PRIVATE METHODS
    // ==================================
    private void init() {
        getStyleClass().setAll(DEFAULT_STYLE_CLASS);
    }

    // ==================================
    // PUBLIC METHODS
    // ==================================
    @Override
    public void show(Node node, double xOffset, double yOffset) {
        Point2D point2D = Utils.pointRelativeTo(node, prefWidth(-1.0D), prefHeight(-1.0D), HPos.CENTER, VPos.BOTTOM, xOffset, yOffset, true);
//        System.out.println("pw: " + computePrefWidth(-1));
//        System.out.println("ph: " + computePrefHeight(-1));
//        System.out.println("point: " + point2D);
        super.show(node, point2D.getX(), point2D.getY());
        setVisible(true);
    }

    /**
     * Method for hiding popup
     */
    public void doHide() {
        if (!isShowing()) {
            return;
        }
        setVisible(false);
    }

    /**
     * 
     * @deprecated Use doHide for hiding popup hide() is for internal use.
     * Used after animation is finished. If this is called closing animation won't be visible.
     */
    @Override
    @Deprecated
    public void hide() {
        super.hide();
    }

    static {
        StyleManager.getInstance().addUserAgentStylesheet(AnimatedPopupX.class.getResource(AnimatedPopupX.class.getSimpleName() + ".css").toString());
    }
}
