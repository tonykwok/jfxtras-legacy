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

import javafx.scene.control.Behavior;
import javafx.scene.input.KeyCode;
import javafx.scene.input.KeyEventID;

/**
 * @author Stephen Chin
 */
public class XTableBehavior extends Behavior {
    override function callActionForEvent(e) {
        if (e.impl_EventID == KeyEventID.PRESSED) {
            var table = skin.control as XTableView;
            var tableSkin = skin as XTableSkin;
            if (e.code == KeyCode.VK_LEFT) {
            } else if (e.code == KeyCode.VK_RIGHT) {
            } else if (e.code == KeyCode.VK_UP) {
                table.selectedRow--;
                if (table.selectedRow < 0) {
                    table.selectedRow = 0;
                }
                table.scrollToSelected();
            } else if (e.code == KeyCode.VK_DOWN) {
                table.selectedRow++;
                if (table.selectedRow >= table.dataProvider.rowCount) {
                    table.selectedRow = table.dataProvider.rowCount - 1;
                }
                table.scrollToSelected();
            } else if (e.code == KeyCode.VK_HOME) {
            } else if (e.code == KeyCode.VK_END) {
            } else if (e.code == KeyCode.VK_PAGE_UP) {
                tableSkin.pageUp();
            } else if (e.code == KeyCode.VK_PAGE_DOWN) {
                tableSkin.pageDown();
            } else if (e.code == KeyCode.VK_ENTER) {
                // add action handler
            }
        }
    }
}
