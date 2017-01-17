/*
 * Copyright (c) 2009, Amy Fowler
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 * 1. Redistributions of source code must retain the above copyright notice,
 *    this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 * 3. Neither the name of JFXtras nor the names of its contributors may be used
 *    to endorse or promote products derived from this software without
 *    specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */
package boundisizer;

import javafx.geometry.BoundingBox;
import javafx.scene.CustomNode;
import javafx.scene.Group;
import javafx.scene.Node;
import javafx.scene.layout.Resizable;
import javafx.scene.paint.Color;
import javafx.scene.paint.Paint;
import javafx.scene.shape.Line;
import javafx.scene.shape.Rectangle;

/**
 * Class which displays a grid of major and minor lines within its width/height.
 *
 * @author aim
 */

public class LineGrid extends CustomNode, Resizable {
    
    public var minorSpacing:Integer = 10 on replace {
        createVerticalLines(width, false);
        createHorizontalLines(height, false);
    }
    
    public var majorSpacing:Integer = 100 on replace {
        createVerticalLines(width, true);
        createHorizontalLines(height, true);
    }

    public var fill:Paint = Color.WHITE;
    
    public var lineStroke:Paint = Color.GRAY;
        
    override var width on replace {
        createVerticalLines(width, false);
        createVerticalLines(width, true);
    }
    
    override var height on replace {
        createHorizontalLines(height, false);
        createHorizontalLines(height, true);
    }

    override function getMinWidth():Number { minorSpacing }
    override function getMinHeight():Number { minorSpacing }
    override function getPrefWidth(height:Number):Number { majorSpacing }
    override function getPrefHeight(width:Number):Number { majorSpacing }
    override var layoutBounds = bind lazy BoundingBox { minX: 0 minY: 0 width: width height: height }

    protected function createVerticalLines(width:Number, major:Boolean) {
        var lineID = "vertical.{if (major) "major" else "minor"}";
        for (line in lines.content) {
            if (line.id == lineID) {
                delete line from lines.content
            }
        }
        var spacing = if (major) majorSpacing else minorSpacing;
        var x = 0;
        //var lw = if (major) 2 else 1;
        var lw = 1;
        while(x <= width) {
            insert Line {id:lineID startX:x startY:0 endX:x endY: bind height strokeWidth: lw
                         stroke: bind lineStroke strokeDashArray:[3,2]} into lines.content;
            x += spacing;
        }
        
    }
    
    protected function createHorizontalLines(height:Number, major:Boolean) {
        var lineID = "horizontal.{if (major) "major" else "minor"}";
        for (line in lines.content) {
            if (line.id == lineID) {
                delete line from lines.content
            }
        }        
        var spacing = if (major) majorSpacing else minorSpacing;
        var y = 0;
        //var lw = if (major) 2 else 1;
        var lw = 1;
        while(y <= height) {
            insert Line {id:lineID startX:0 startY:y endX: bind width endY:y strokeWidth:lw
                         stroke: bind lineStroke strokeDashArray:[3,2]} into lines.content;
            y += spacing;
        }
    }
    
    protected var lines:Group = Group{}
    
    override function create():Node {
        Group {
            content: [
                Rectangle {
                    translateX: bind lines.layoutBounds.minX
                    translateY: bind lines.layoutBounds.minY
                    width: bind lines.layoutBounds.width
                    height: bind lines.layoutBounds.height
                    fill: bind this.fill
                },
                lines
            ]
        }
    }    
}
