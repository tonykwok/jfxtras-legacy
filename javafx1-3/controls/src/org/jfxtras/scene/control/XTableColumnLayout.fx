/*
 * Copyright (c) 2008-2010, JFXtras Group
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
package org.jfxtras.scene.control;

import javafx.animation.Interpolator;
import javafx.animation.KeyFrame;
import javafx.animation.Timeline;
import org.jfxtras.util.SequenceUtil;

/**
 * @author Stephen Chin
 */
package class XTableColumnLayout {
    public var skin:XTableSkin;
    public var columnInfo = bind for (column in visibleColumns) XTableColumnInfo {} on replace {
        doLayout();
    }
    public var layoutWidth:Number on replace {
        requestLayout();
    }
    public-read var needsLayout = false;
    public-read var draggingIndex:Integer = -1;
    public-read var draggingCI = bind lazy columnInfo[draggingIndex];
    var table = bind skin.table;
    var visibleColumns = bind table.columns[c|c.visible];
    var gapIndex:Integer = -1;
    var gapWidth:Number;
    var originalX:Number;

    public function startDrag(column:Integer):Void {
        if (draggingIndex == -1) {
            draggingIndex = column;
            draggingCI.opacity = 0.6;
            originalX = draggingCI.position;
            gapWidth = draggingCI.width;
            gapIndex = draggingIndex;
        }
    }

    public function drag(dragX:Number, tableX:Number):Void {
        var x;
        var oldGap = gapIndex;
        gapIndex = if (tableX < 0) -1 else sizeof columnInfo - 1;
        for (column in columnInfo[c|indexof c != draggingIndex]) {
           if (tableX < x + (gapWidth + column.width) / 2) {
               gapIndex = indexof column;
               break;
           }
           if (indexof column == gapIndex) {
               x += gapWidth;
           }
           x += column.width;
        }
        if (oldGap != gapIndex) {
            animatePosition();
        }
        draggingCI.position = originalX + dragX;
        skin.requestLayoutOnRows();
    }

    public function endDrag():Void {
        var finalPosition = SequenceUtil.sum(for (ci in columnInfo[c|indexof c != draggingIndex][0..gapIndex-1]) ci.width);
        Timeline {
            keyFrames: KeyFrame {
                def dci = draggingCI;
                time: 300ms
                values: [
                    dci.position => finalPosition tween Interpolator.EASEOUT,
                    update => update + 1 tween Interpolator.EASEOUT
                ]
                action: function() {
                    draggingCI.opacity = 1;
                    if (draggingIndex != gapIndex) {
                        var dragged = table.columns[draggingIndex];
                        delete table.columns[draggingIndex];
                        insert dragged before table.columns[gapIndex];
                    }
                    draggingIndex = -1;
                    gapIndex = -1;
                }
            }
        }.play();
    }

    public function requestLayout() {
        needsLayout = true;
        skin.requestLayout();
    }

    var prefWidths = bind for (column in visibleColumns) {
        column.prefWidth + table.getLeftPad() + table.getRightPad();
    } on replace {
        requestLayout();
    }

    public function doLayout():Void {
        var x:Number = 0;
        def extraSpace = layoutWidth - SequenceUtil.sum(prefWidths);
        for (ci in columnInfo) {
            ci.width = prefWidths[indexof ci] + extraSpace / sizeof visibleColumns;
        }
        for (ci in columnInfo[c|indexof c != draggingIndex]) {
            if (indexof ci == gapIndex) {
                x += gapWidth;
            }
            ci.position = x;
            x += ci.width;
        }
        needsLayout = false;
        skin.requestLayoutOnRows();
    }

    var timeline:Timeline;

    var update on replace {
        skin.requestLayoutOnRows();
    }

    public function animatePosition():Void {
        timeline.pause();
        timeline = Timeline {
            keyFrames: KeyFrame {
                time: 200ms
                var x:Number = 0;
                values: [
                    for (ci in columnInfo[c|indexof c != draggingIndex]) {
                        if (indexof ci == gapIndex) {
                            x += gapWidth;
                        }
                        def target = x;
                        x += ci.width;
                        def dci = ci;
                        dci.position => target tween Interpolator.EASEOUT;
                    }
                    update => update + 1 tween Interpolator.EASEOUT
                ]
            }
        }
        timeline.play();
    }
}
