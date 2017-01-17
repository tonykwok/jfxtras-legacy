package sidehatch.util;

import javafx.scene.layout.Panel;

public class StretchyHBox extends StretchyBox {
    override var onLayout = function():Void {
        resizeContent(); // will set all content to preferred sizes
        var min = 0.0;
        var extraCount = 0;
        for (node in getManaged(content)) {
            min += getNodePrefWidth(node);
            min += spacing;
            if(node instanceof Spacer) {
                extraCount++;
            }
            if(node.layoutInfo == GROW) {
                extraCount++;
            }
        }
        min -= spacing; //subtract off that last spacing
        var extra = width - min;
        var y = 0.0;
        for (node in getManaged(content)) {
            positionNode(node,y,0);
            var w = getNodePrefWidth(node);
            if(extra > 0 and (node instanceof Spacer or node.layoutInfo == GROW)) {
                var grow = extra/extraCount;
                resizeNode(node,w+grow,height);
                y += (w+grow);
            } else {
                resizeNode(node,w,height);
                y += w;
            }
            y += spacing;
        }
    }

}

