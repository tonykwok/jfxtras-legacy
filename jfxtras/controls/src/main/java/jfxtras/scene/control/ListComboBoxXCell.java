/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package jfxtras.scene.control;

import javafx.scene.control.ListCell;

/**
 *
 * @author Goran Lochert
 * just making updateItem method public
 */
public class ListComboBoxXCell<T> extends ListCell<T> {

    @Override
    public void updateItem(T t, boolean bln) {
        super.updateItem(t, bln);
    }    
}
