/*
 * ValidatableTextBox.fx
 *
 * Created on 4-sep-2009, 8:41:55
 */

package validatabletextbox;

import javafx.scene.control.Control;
import javafx.scene.Node;

import java.util.regex.Pattern;
import java.util.regex.PatternSyntaxException;

/**
 * @author Yannick Van Godtsenhoven
 * <yannick@jfxperience.com>
 */

public def STATE_UNVALIDATED:String = "unvalidated";
public def STATE_INVALID:String = "invalid";
public def STATE_VALID:String = "valid";
public def STATE_REGEX_ERROR:String = "regexerror";


public class ValidatableTextBox extends Control {

    /*
     * The state of the validation.
     */
    public var validationState:String = STATE_UNVALIDATED;

    /*
     * The message linked to the validationstate.
     */
    public var validationMessage:String;

    /*
     * Determines whether the value is required or not.
     */
    public var required:Boolean = false;

    /*
     * The validation message if the value is required.
     */
    public var requiredMessage:String = "required";

    /*
     * The regex pattern for a valid value.
     */
    public var regexPattern:String;

    /*
     * The validation message if the value doesn't match the specified regex.
     */
    public var regexPattenMessage:String = "invalid";

    /*
     * The value that needs to be validated.
     */
    public var valueToValidate:String;

    /*
     * Validates the value and returns
     * true if the validation succeeds.
     */
    public function validate() {
        println("value {valueToValidate} - pattern {regexPattern}");
        println("boolean {StringUtil.isBlank(regexPattern)} : value ");
        if(required and StringUtil.isBlank(valueToValidate)) {
            validationMessage = requiredMessage;
            validationState = STATE_INVALID;
        } else if(not StringUtil.isBlank(regexPattern)) {
            try{
                var b:Boolean = Pattern.matches(regexPattern, valueToValidate);
                println("{valueToValidate} matches {regexPattern}: {b}");
                if(b)  {
                    validationMessage = null;
                    validationState = STATE_VALID;
                } else {
                    validationMessage = regexPattenMessage;
                    validationState = STATE_INVALID;
                }
            }catch(e:PatternSyntaxException){
                validationMessage = e.getMessage();
                validationState = STATE_REGEX_ERROR;
            }
        } else {
            validationMessage = null;
            validationState = STATE_VALID;
        }
    }

    /*
     * Create instance with default skin
     */
   override public function create():Node {
       if(skin == null) {
           skin = ValidatableTextBoxSkin{}
       }
       super.create();
   }



}
