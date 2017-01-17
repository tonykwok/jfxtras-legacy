package jfxtras.scene.control;

import javafx.beans.property.ObjectProperty;
import javafx.beans.property.SimpleObjectProperty;
import javafx.collections.ObservableList;
import javafx.geometry.Pos;
import javafx.scene.layout.StackPane;

/**
 *
 * @author Goran Lochert
 * Class that represents one page in pagerX.
 * TODO: extend Control or MultiLayoutContainer
 * TODO: maybe add pageTitleProperty
 */
public class PageX extends StackPane {

    private PageContent pageContent;
    private ObjectProperty<ObservableList<PageItemX>> items = new SimpleObjectProperty<ObservableList<PageItemX>>(this, "items");


    public PageX(ObservableList<PageItemX> items) {
        System.out.println("page items: " + items);
        setItems(items);
        init();
    }

    private void init() {
        pageContent = new PageContent();
       
        setAlignment(Pos.CENTER);
        for (PageItemX item : getItems()) {
            pageContent.getItems().add(item.getContent());
        }
        getChildren().add(pageContent);
    }

    public ObjectProperty itemsProperty() {
        return items;
    }

    public final void setItems(ObservableList<PageItemX> list) {
        items.set(list);
    }

    public final ObservableList<PageItemX> getItems() {
        return items.get();
    }

    protected class PageContent extends MultiLayoutContainer {

        public PageContent() {
            super();
            setVgap(10);
            setHgap(10);
            getStyleClass().add("page-content");
        }
    }
}
