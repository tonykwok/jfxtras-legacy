/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package jfxtras.scene.control;

import javafx.beans.property.ObjectProperty;
import javafx.beans.property.SimpleObjectProperty;
import javafx.scene.Node;

/**
 *
 * @author Goran Lochert
 */
public class PageItemX {

    private ObjectProperty<Node> content;

    public PageItemX(Node content) {
//        getStyleClass().add("page-itemx");
        setContent(content);
        init();
    }
    
    private void init() {
//        getChildren().add(getContent());
    }

    public ObjectProperty<Node> contentProperty() {
        if (content == null) {
            content = new SimpleObjectProperty<Node>(this, "content");
        }
        return content;
    }
    
    public final void setContent(Node value) {
        contentProperty().set(value);
    }
    
    public final Node getContent() {
        return content == null ? null : content.get();
    }
}
