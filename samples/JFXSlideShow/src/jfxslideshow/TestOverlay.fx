/*
 * TestOverlay.fx
 *
 * Created on Oct 21, 2009, 4:34:39 PM
 */

package jfxslideshow;

import javafx.scene.CustomNode;
import javafx.scene.Group;
import javafx.scene.Node;

import javafx.scene.text.Text;
import javafx.scene.text.Font;

import javafx.scene.paint.Color;

/**
 * @author jimclarke
 */

public class TestOverlay extends CustomNode {

    public override function create(): Node {
        return Group {
            content:  Text {
                font : Font {
                    size: 42
                }
                fill: Color.RED
                opacity: 0.5
                content: "DRAFT"
                rotate: 45
            }
        };
    }

}
