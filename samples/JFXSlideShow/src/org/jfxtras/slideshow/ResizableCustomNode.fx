/*
 * ResizableCustomNode.fx
 *
 * Created on Sep 21, 2009, 4:14:15 PM
 */

package org.jfxtras.slideshow;

import javafx.scene.CustomNode;
import javafx.scene.layout.Resizable;

import javafx.geometry.BoundingBox;

/**
 * @author jimclarke
 */

public abstract class ResizableCustomNode extends CustomNode, Resizable {

    override var layoutBounds = bind lazy BoundingBox { width: width height: height }

    postinit {
        if(not isInitialized(width)) width = getPrefWidth(-1);
        if(not isInitialized(height)) width = getPrefHeight(-1);
    }


}
