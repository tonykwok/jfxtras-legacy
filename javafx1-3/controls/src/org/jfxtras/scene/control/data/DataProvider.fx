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
package org.jfxtras.scene.control.data;

import javafx.reflect.FXType;
import org.jfxtras.lang.XBind;

/**
 * @author Stephen Chin
 *
 * Todo:
 * - Pick data provider automatically based on a cachedrowset
 * - Support Java objects in addition to JavaFX
 */
public abstract class DataProvider {
    public-read protected var rowCount:Integer;
    public-read protected var columns:String[];
    public-read protected var types:FXType[];

    public abstract bound function getRange(rowStart:Integer, rowCount:Integer, columns:String[]):DataRow[];

    public bound function getRange(rowStart:Integer, rowCount:Integer):DataRow[] {
        return getRange(rowStart, rowCount, columns);
    }

    public bound function getRow(rowIndex:Integer, columns:String[]):XBind[] {
        return getRange(rowIndex, 1, columns)[0].getData();
    }

    public bound function getRow(rowIndex:Integer):XBind[] {
        return getRow(rowIndex, columns);
    }

    public bound function getColumn(rowStart:Integer, rowCount:Integer, column:String):XBind[] {
        return for (row in getRange(rowStart, rowCount, column)) row.getData()[0];
    }

    public bound function getCell(rowIndex:Integer, column:String):XBind {
        return getRow(rowIndex, column)[0];
    }
}
