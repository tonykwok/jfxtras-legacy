package sidehatch;

import javafx.scene.CustomNode;
import javafx.scene.Node;
import javafx.scene.layout.Resizable;
import javafx.scene.paint.Paint;
import javafx.scene.shape.Rectangle;

public class ResizeRect extends CustomNode, Resizable {
    override function getPrefHeight(width: Number) : Number {
        return 20;
    }

    override function getPrefWidth(height: Number) : Number {
        return 20;
    }

    public-init var fill:Paint;

    var rect = Rectangle {
        height: bind height
        width: bind width
        fill: bind fill
    }


    override function create():Node {
        return rect;
    }
}

