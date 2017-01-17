package sidehatch.util;

import javafx.scene.layout.Panel;
import javafx.scene.layout.LayoutInfo;

public class StretchyBox extends Panel {
    public-init var spacing = 0.0;
}
public class Spacer extends Panel {
    var initHeight = 50.0;
    var initWidth = 50.0;
    init {
        initHeight = height;
        initWidth = width;
        prefHeight = function(v:Float) { initHeight; }
        prefWidth = function(v:Float) { initWidth; }
    }
}

public def GROW:LayoutInfo = LayoutInfo { }


