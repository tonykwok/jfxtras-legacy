package jfxtras.scene.control;

import com.sun.javafx.css.StyleManager;
import javafx.beans.property.BooleanProperty;
import javafx.beans.property.IntegerProperty;
import javafx.beans.property.ObjectProperty;
import javafx.beans.property.SimpleBooleanProperty;
import javafx.beans.property.SimpleIntegerProperty;
import javafx.beans.property.SimpleObjectProperty;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.scene.Node;
import javafx.scene.control.Control;
import javafx.scene.control.Label;
import javafx.scene.control.SingleSelectionModel;
import javafx.util.Callback;
import javafx.util.Duration;

/**
 *
 * @author Goran Lochert
 * Control that adds "aligns" items into pages. It is practically DeckPane with Controls
 * ----------------------------------------------------------
 * TODO: make any selectedIndex as startIndex
 * TODO: add backgroundNodeProperty
 * TODO: add showGotoControlProperty
 * TODO: add showItemsPerPageControlProperty
 * TODO: add showTemplateNodeProperty
 * TODO: internationalization
 * TODO: maybe add onPageChangeHandler @see DeckPane class
 * TODO: maybe add onCycleChange @see DeckPane class
 * -----------------------------------------------------------
 * DONE! TODO: try to make selected index 1 as default
 * DONE! TODO: add templateFactory CallBack<PagerX, Node>
 * REJECTED! TODO: add showToolbarControlsProperty hides all controls good for custom Controling of pager if needed -> CAN BE DONE WITH DECK
 * REJECTED! TODO: add showOnlyNextButtonProperty good for wizards -> deck + button can do same thing
 * REJECTED! TODO: add showOnlyBasicButtons shows first prev, next last -> CAN BE DONE WITHOUT PROPERTY 
 * DONE! TODO: add same properties from deck animationMode, animationDuration and bind to deck or make Stylables on Deck and add them through CSS
 * REJECTED! BUG: pillButtons get bottom right corner rounded when hovered ??? -> fixed with b45
 */
public class PagerX extends Control {

    protected DeckPaneX deck;
    private ObjectProperty<ObservableList<PageItemX>> items = new SimpleObjectProperty<ObservableList<PageItemX>>(this, "items");
    private ObjectProperty<Callback<PagerX, Node>> templateFactory = new SimpleObjectProperty<Callback<PagerX, Node>>(this, "templateFactory");
    private IntegerProperty itemsPerPage; // ObservableList - default 1 2 3 4 5, so users can add as many as they want, be careful if > items size
    private IntegerProperty pageButtonsCount;
    private BooleanProperty showGotoControl;
    private BooleanProperty templateNodeShown;
    

    public PagerX() {
        this(FXCollections.<PageItemX>observableArrayList());
    }

    public PagerX(ObservableList<PageItemX> items) {

        getStyleClass().add("pagerx");

        deck = new DeckPaneX();
        deck.setId("pager-deck");
        setTemplateFactory(new DefaultTemplateFactory());
        setItems(items);

    }


    public BooleanProperty templateNodeShownProperty() {
        if(templateNodeShown == null) {
            templateNodeShown = new SimpleBooleanProperty(this, "templateLabelShown", true);
        }
        return templateNodeShown;
    }
    
    public final boolean isTemplateNodeShown() {
        return templateNodeShown == null ? true : templateNodeShown.get();
    }
    
    public final void setTemplateNodeShown(boolean value) {
        templateNodeShownProperty().set(value);
    }
    
    public BooleanProperty showGotoControlProperty() {
        if(showGotoControl == null) {
            showGotoControl = new SimpleBooleanProperty(this, "showGotoControl", true);
        }
        return showGotoControl;
    }
    
    public final boolean isShowGotoControl() {
        return showGotoControl == null ? true : showGotoControl.get();
    }
    
    public final void setShowGotoControl(boolean value) {
        showGotoControlProperty().set(value);
    }
    
    public final SingleSelectionModel<? extends Node> getSelectionModel() {
        return deck.getSelectionModel();
    }


    
    public ObjectProperty<Callback<PagerX, Node>> templateFactoryProperty() {
        return templateFactory;
    }

    /**
     * Sets template factory for templateNode/templateLabel
     * @param tf template factory
     */
    public final void setTemplateFactory(Callback<PagerX, Node> tf) {
        templateFactory.set(tf);
    }

    public final Callback<PagerX, Node> getTemplateFactory() {
        return templateFactory.get();
    }

    public ObjectProperty<Duration> animationDurationProperty() {
        return deck.animationDurationProperty();
    }

    public final Duration getAnimationDuration() {
        return deck.getAnimationDuration();
    }

    public final void setAnimationDuration(Duration value) {
        animationDurationProperty().set(value);
    }

    public final AnimationModeX getAnimationMode() {
        return deck.getAnimationMode();
    }

    public final void setAnimationMode(AnimationModeX mode) {
        animationModeProperty().set(mode);
    }

    public ObjectProperty<AnimationModeX> animationModeProperty() {
        return deck.animationModeProperty();
    }

    public IntegerProperty pageButtonsCountProperty() {
        if (pageButtonsCount == null) {
            pageButtonsCount = new SimpleIntegerProperty(this, "pageButtonsCount", 5) {

                @Override
                public void set(int i) {
                    if (i < 0) {
                        throw new UnsupportedOperationException("buttonCount cannot be < 0");
                    }
                    super.set(i);
                }
            };
        }
        return pageButtonsCount;
    }

    public final Integer getPageButtonsCount() {
        return pageButtonsCount == null ? 5 : pageButtonsCount.get();
    }

    /**
     * Setting to 0 will hide page buttons
     * @param value 
     */
    public final void setPageButtonsCount(int value) {
        pageButtonsCountProperty().set(value);
    }

    public IntegerProperty itemsPerPageProperty() {
        if (itemsPerPage == null) {
            itemsPerPage = new SimpleIntegerProperty(this, "itemsPerPage", 1) {

                @Override
                public void set(int i) {
                    System.out.println("items per page changed.");
                    if (i < 1) {
                        throw new UnsupportedOperationException("itemsPerPage cannot be < 1");
                    }
                    super.set(i);
                }
            };
        }
        return itemsPerPage;
    }

    public final Integer getItemsPerPage() {
        return itemsPerPage == null ? 1 : itemsPerPage.get();
    }

    /**
     * if items per page > item count then pager will show all items in one page
     * @param value items per page
     */
    public final void setItemsPerPage(int value) {
        itemsPerPageProperty().set(value);
    }

    public ObjectProperty itemsProperty() {
        return items;
    }

    public final void setItems(ObservableList<PageItemX> list) {
        System.out.println("set-items-size: " + list.size());
        items.set(list);
    }

    public final ObservableList<PageItemX> getItems() {
        return items.get();
    }

    protected class DefaultTemplateFactory implements Callback<PagerX, Node> {

        @Override
        public Node call(PagerX pager) {
            int selectedIndex = pager.getSelectionModel().getSelectedIndex();            
            int ipp = pager.getItemsPerPage();
            int size = pager.getItems().size();
            System.out.println("** call : " + selectedIndex);
            int to = (selectedIndex + 1) * ipp;
            if (to > size) {
                to = size;
            }
            String text = "Items " + (selectedIndex * ipp + 1) + " to " + to + " of " + size;
            final Label label = new Label(text);
            return label;
        }
    }

    static {
        StyleManager.getInstance().addUserAgentStylesheet(PagerX.class.getResource(PagerX.class.getSimpleName() + ".css").toString());
    }
}
