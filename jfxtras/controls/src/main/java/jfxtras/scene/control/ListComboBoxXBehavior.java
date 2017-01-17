package jfxtras.scene.control;

import com.sun.javafx.scene.control.behavior.BehaviorBase;
import com.sun.javafx.scene.control.behavior.KeyBinding;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Goran Lochert
 * TODO: add key bindings
 */
public class ListComboBoxXBehavior<T> extends BehaviorBase<ListComboBoxX<T>> {

    protected static final List<KeyBinding> LIST_COMBO_BOX_BINDINGS = new ArrayList();

    public ListComboBoxXBehavior(ListComboBoxX<T> listComboBox) {
        super(listComboBox);
    }


    @Override
    protected List<KeyBinding> createKeyBindings() {
        return LIST_COMBO_BOX_BINDINGS;
    }

    static {
        LIST_COMBO_BOX_BINDINGS.addAll(TRAVERSAL_BINDINGS);        
    }
}
