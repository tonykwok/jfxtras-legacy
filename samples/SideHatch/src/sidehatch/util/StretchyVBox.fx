package sidehatch.util;

import javafx.scene.layout.Panel;

public class StretchyVBox extends StretchyBox {
    override var onLayout = function():Void {
        resizeContent(); // will set all content to preferred sizes
        var min = 0.0;
        var extraCount = 0;
        for (node in getManaged(content)) {
            min += getNodePrefHeight(node);
            if(node instanceof Spacer) {
                extraCount++;
            }
            if(node.layoutInfo == GROW) {
                extraCount++;
            }
        }
        var extra = height - min;
        var y = 0.0;
        for (node in getManaged(content)) {
            positionNode(node,0,y);
            var h = getNodePrefHeight(node);
            if(extra > 0 and (node instanceof Spacer or node.layoutInfo == GROW)) {
                var grow = extra/extraCount;
                //var w = getNodePrefWidth(node);
                resizeNode(node,width,h+grow);
                y += (h+grow);
            } else {
                resizeNode(node,width,h);
                y += h;
            }

        }
    }
}

