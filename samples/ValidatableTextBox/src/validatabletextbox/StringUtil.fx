/*
 * StringUtil.fx
 *
 * Created on 4-sep-2009, 9:12:44
 */

package validatabletextbox;

/**
 * @author Yannick
 */

public class StringUtil {}

public function isBlank(input:String) {
    if(input == null or input.equals("")) {
        return true
    }
    return false;
}

