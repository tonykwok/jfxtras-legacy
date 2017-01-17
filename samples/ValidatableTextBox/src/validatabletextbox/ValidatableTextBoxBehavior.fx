/*
 * ValidatableTextBoxBehavior.fx
 *
 * Created on 4-sep-2009, 8:55:42
 */

package validatabletextbox;

import javafx.scene.control.Behavior;

/**
 * @author Yannick Van Godtsenhoven
 * <yannick@jfxperience.com>
 */
 
public class ValidatableTextBoxBehavior extends Behavior {

    var textSkin = bind skin as ValidatableTextBoxSkin;
    var textControl = bind skin.control as ValidatableTextBox;

    public function onMouseEntered() {
        recalculateToolTipPosition();
        textSkin.tooltip.visible = true;
        delete textSkin.tooltip from textControl.scene.content;
        insert textSkin.tooltip into textControl.scene.content;

    }

    public function onMouseExited() {
        delete textSkin.tooltip from textControl.scene.content;
        textSkin.tooltip.visible = false;
    }

    function recalculateToolTipPosition(){
        textSkin.tooltip.translateY = calculateYCoordinate();
        textSkin.tooltip.translateX = calculateXCoordinate();
    }

    function calculateXCoordinate():Number {
        if(ToolTip.TOOLTIP_LEFT.equals(textSkin.tooltip.position)) {
            return textControl.localToScene(textControl.boundsInLocal).minX - textSkin.tooltipSpacing - textSkin.tooltip.layoutBounds.width;
        } else if(ToolTip.TOOLTIP_UP.equals(textSkin.tooltip.position)) {
            return textControl.localToScene(textControl.boundsInLocal).minX;
        } else if(ToolTip.TOOLTIP_DOWN.equals(textSkin.tooltip.position)) {
            return textControl.localToScene(textControl.boundsInLocal).minX;
        } else if(ToolTip.TOOLTIP_OVER.equals(textSkin.tooltip.position)) {
            return textControl.localToScene(textControl.boundsInLocal).minX + 5;
        } else {
            return textControl.localToScene(textControl.boundsInLocal).maxX + textSkin.tooltipSpacing;
        }
    }

    function calculateYCoordinate():Number {
        if(ToolTip.TOOLTIP_LEFT.equals(textSkin.tooltip.position)) {
            return textControl.localToScene(textControl.boundsInLocal).minY;
        } else if(ToolTip.TOOLTIP_UP.equals(textSkin.tooltip.position)) {
            return textControl.localToScene(textControl.boundsInLocal).minY - textSkin.tooltipSpacing - textSkin.tooltip.layoutBounds.height;
        } else if(ToolTip.TOOLTIP_DOWN.equals(textSkin.tooltip.position)) {
            return textControl.localToScene(textControl.boundsInLocal).maxY + textSkin.tooltipSpacing;
        } else if(ToolTip.TOOLTIP_OVER.equals(textSkin.tooltip.position)) {
            return textControl.localToScene(textControl.boundsInLocal).minY + 5;
        } else {
            return textControl.localToScene(textControl.boundsInLocal).minY;
        }
    }
}
