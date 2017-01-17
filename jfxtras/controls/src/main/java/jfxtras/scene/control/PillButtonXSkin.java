package jfxtras.scene.control;

import com.sun.javafx.scene.control.behavior.ButtonBehavior;
import com.sun.javafx.scene.control.skin.LabeledSkinBase;

/**
 *
 * @author Goran Lochert
 */
public class PillButtonXSkin extends LabeledSkinBase<PillButtonX, ButtonBehavior<PillButtonX>> {

    public PillButtonXSkin(PillButtonX pillButton) {
        super(pillButton, new ButtonBehavior<PillButtonX>(pillButton));
    } 
}
