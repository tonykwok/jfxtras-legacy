/*
 * ValidatableTextBoxSkin.fx
 *
 * Created on 4-sep-2009, 8:45:41
 */

package validatabletextbox;

import javafx.scene.Group;
import javafx.scene.control.Skin;
import javafx.scene.control.TextBox;
import javafx.scene.input.KeyEvent;
import javafx.scene.input.MouseEvent;
import javafx.scene.layout.LayoutInfo;

/**
 * @author Yannick Van Godtsenhoven
 * <yannick@jfxperience.com>
 */

public class ValidatableTextBoxSkin extends Skin {

    /*
     * Reference to the control.
     */
    var validatableTextBoxControl:ValidatableTextBox = bind control as ValidatableTextBox;

    /*
     * Reference to the behavior.
     */
    override var behavior = ValidatableTextBoxBehavior{};

    /*
     * Reference to the tooltip.
     */
    public var tooltip:ToolTip = ToolTip{
        visible : false;
    };

    /*
     * space between the tooltip and the textbox.
     */
    public var tooltipSpacing = 3;

    /*
     * Reference to the textBox.
     */
    public var textBox:TextBox = TextBox {
        onMouseEntered: function(me:MouseEvent) {
            if(ValidatableTextBox.STATE_INVALID.equals(validatableTextBoxControl.validationState)){
                (behavior as ValidatableTextBoxBehavior).onMouseEntered();
            }
        }
        onMouseExited: function(me:MouseEvent) {
            if(tooltip.visible){
                (behavior as ValidatableTextBoxBehavior).onMouseExited();
            }
        }
        onKeyTyped: function (ke:KeyEvent) {
            validatableTextBoxControl.valueToValidate = textBox.rawText;
        }
    };

    var validationState:String = bind validatableTextBoxControl.validationState on replace {
        if(ValidatableTextBox.STATE_INVALID.equals(validatableTextBoxControl.validationState)) {
            textBox.style = "border-fill: red; border-width: 2";
            updateTooltipMessage();
        } else {
            textBox.style = "";
        }
    };

    var validationMessage:String = bind validatableTextBoxControl.validationMessage on replace {
        updateTooltipMessage()
    }

    override public function intersects(localX:Number, localY:Number, localWidth:Number, localHeigth:Number):Boolean {
        return node.intersects(localX, localY, localWidth, localHeigth);
    }

    override public function contains(localX:Number, localY:Number):Boolean {
        return node.contains(localX, localY);
    }

    function updateTooltipMessage() {
        tooltip.text = validatableTextBoxControl.validationMessage;
    }

    init {
        node = Group {
            content: bind [
                textBox
            ]
        };
    }
}
