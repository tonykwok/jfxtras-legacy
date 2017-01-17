package jfxtras.scene.control;

import javafx.beans.InvalidationListener;
import javafx.beans.Observable;
import javafx.beans.property.ObjectProperty;
import javafx.beans.property.SimpleObjectProperty;
import javafx.beans.property.SimpleStringProperty;
import javafx.beans.property.StringProperty;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.scene.Node;
import javafx.scene.control.Control;
import javafx.scene.control.SingleSelectionModel;
import javafx.util.Duration;

/**
 *
 * @author Goran Lochert
 * insipired by http://learnjavafx.typepad.com/weblog/2008/07/getting-decked.html
 * BEWARE: ABOUT SELECTION MODEL: index is changed first then item is changed. 
 * By default selectedIndex is -1 which means nothing is selected.
 * TODO: mayne add Add sliding left - right, sliding up - down, maybe perspective TOP-BOTTOM now it has just LEFT-RIGHT  
 * TODO: maybe add onCycleEventHandler and CyclingProperty
 * TODO: maybe add onIndexChangeHandler -> for example good in wizards for changing title etc
 * TODO: maybe add onTransitionFinished/onChangeFinished event handler, called when inAnimation and outAnimation is finished
 * TODO: maybe add onTransitionStarted/onChangeStarted event handler, called before inAnimation starts
 */
public class DeckPaneX extends Control {


    // TODO: stylable -fx-animation-mode
    private ObjectProperty<AnimationModeX> animationMode;
    // TODO: styleable -fx-animation-duration
    private ObjectProperty<Duration> animationDuration;
    private ObjectProperty<ObservableList<Node>> items = new SimpleObjectProperty<ObservableList<Node>>(this, "items");
    private ObjectProperty<SingleSelectionModel<? extends Node>> selectionModel = new SimpleObjectProperty<SingleSelectionModel<? extends Node>>(this, "selectionModel");
    
    private ObjectProperty<Node> backgroundNode;
    private StringProperty selectedNodeID;

    // ==================================
    // CONSTRUCTORS
    // ==================================
    public DeckPaneX() {
        this(FXCollections.<Node>observableArrayList());
    }

    public DeckPaneX(Node... items) {
        this(FXCollections.<Node>observableArrayList(items));
    }

    public DeckPaneX(ObservableList<Node> items) {
        init();
        setItems(items);
        setSelectionModel(new DeckPaneXSelectionModel(this));
    }

    // ==================================
    // PRIVATE METHODS
    // ==================================
    private void init() {
        getStyleClass().setAll("deck-panex");
    }

    // ==================================
    // PROPERTIES
    // ==================================
    public ObjectProperty<ObservableList<Node>> itemsProperty() {
        return items;
    }

    public final void setItems(ObservableList<Node> list) {
        items.set(list);
    }

    public final ObservableList<Node> getItems() {
        return items.get();
    }

    public ObjectProperty<SingleSelectionModel<? extends Node>> selectionModelProperty() {
        return selectionModel;
    }

    public final SingleSelectionModel<? extends Node> getSelectionModel() {
        return selectionModel.get();
    }

    public final void setSelectionModel(SingleSelectionModel<? extends Node> value) {
        selectionModel.set(value);
    }

    public ObjectProperty<Node> backgroundNodeProperty() {
        if (backgroundNode == null) {
            backgroundNode = new SimpleObjectProperty<Node>(this, "backgroundNode", null);
        }
        return backgroundNode;
    }

    public final Node getBackgroundNode() {
        return backgroundNode == null ? null : backgroundNode.get();
    }

    public final void setBackgroundNode(Node value) {
        backgroundNodeProperty().set(value);
    }

    public ObjectProperty<Duration> animationDurationProperty() {
        if (animationDuration == null) {
            animationDuration = new SimpleObjectProperty<Duration>(this, "animationDuration", new Duration(250.0d));
        }
        return animationDuration;
    }

    public final Duration getAnimationDuration() {
        return animationDuration == null ? new Duration(250.0d) : animationDuration.get();
    }

    public final void setAnimationDuration(Duration value) {
        animationDurationProperty().set(value);
    }

    public final AnimationModeX getAnimationMode() {
        return animationMode == null ? AnimationModeX.FADE : animationMode.get();
    }

    public final void setAnimationMode(AnimationModeX mode) {
        animationModeProperty().set(mode);
    }

    public ObjectProperty<AnimationModeX> animationModeProperty() {
        if (animationMode == null) {
            animationMode = new SimpleObjectProperty<AnimationModeX>(AnimationModeX.FADE);
        }
        return animationMode;
    }

    public StringProperty selectedNodeIDProperty() {
        if (selectedNodeID == null) {
            selectedNodeID = new SimpleStringProperty(this, "selectedNodeID", null) {

                int index;
                boolean found = false;

                @Override
                protected void invalidated() {
                    System.out.println("invalidated - found: " + found + " current: " + get());

                    // TODO: speed up, maybe add nodes to hash<nodeID, node>
                    // when nodes are added/removed from items updateHash

                    // search through nodes                    
                    for (Node node : getItems()) {
                        if (node.getId() == null) {
                            System.err.println("Node: " + node + " does not have ID.");
                            return;
                        }
                        if (node.getId().equals(get())) {
                            found = true;
                            index = getItems().indexOf(node);
                            break;
                        }
                    }
                    System.out.println("found: " + index);
                    if (!found) {
                        System.err.println("Could not find node with ID: " + get());
                    } else {
                        getSelectionModel().select(index);
                        found = false;
                    }
                }
            };
        }
        return selectedNodeID;
    }

    public final String getSelectedNodeID() {
        return selectedNodeID == null ? null : selectedNodeID.get();
    }

    /**
     * Selects node by ID. Good when deckUsed in other classes when they don't have access to some nodes in deck ro we don't know index of some node.
     * @param nodeId node ID
     */
    public final void setSelectedNodeID(String nodeId) {
//        System.out.println("setting visible to: " + nodeId);
        selectedNodeIDProperty().set(nodeId);
    }

    // ==================================
    // OVERRIDES
    // ==================================
    @Override
    protected String getUserAgentStylesheet() {
        return DeckPaneX.class.getResource(DeckPaneX.class.getSimpleName() + ".css").toString();
    }
    // ==================================
    // STATIC CLASS
    // ==================================

    /**
     * Simple Single Selection Model used by DeckPaneX
     */
    static class DeckPaneXSelectionModel extends SingleSelectionModel<Node> {

        private final DeckPaneX deck;

        public DeckPaneXSelectionModel(DeckPaneX deck) {
            this.deck = deck;
            init();
        }

        private void init() {
            selectedItemProperty().addListener(new InvalidationListener() {

                @Override
                public void invalidated(Observable o) {
                    deck.setSelectedNodeID(getSelectedItem().getId());
                }
            });
        }

        @Override
        protected Node getModelItem(int index) {
            System.out.println("index: " + index);
            System.out.println("deck-size: " + deck.getItems().size());
            if (deck.getItems() == null) {
                return null;
            }
            if ((index < 0) || (index >= getItemCount())) {
                return null;
            }
            return deck.getItems().get(index);
        }

        @Override
        protected int getItemCount() {
            return deck.getItems() == null ? -1 : deck.getItems().size();
        }
    }
}
