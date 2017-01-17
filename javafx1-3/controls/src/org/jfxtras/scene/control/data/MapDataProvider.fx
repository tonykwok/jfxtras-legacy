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

import org.jfxtras.lang.XBind;
import org.jfxtras.util.XMap;
import javafx.reflect.FXLocal;
import javafx.reflect.FXType;

/**
 * @author Stephen Chin
 */
public class MapDataProvider extends DataProvider {
    def context = FXLocal.getContext();
    public var data:XMap[] on replace oldData[a..b]=newData {
        calculateColumns();
    }
    override var rowCount = bind sizeof data;

    /**
     * A map that defines the set of columns that can be returned by this data provider.
     * The order of the columns will be determined by the order in the entry set.
     * For each entry the key must be the column name.  The value can either be an instance
     * of FXType to explicitly specify types, or a class object to use reflection.
     * <p>
     * If this variable is null, the first row of the data set will be used as a model
     * object to determine the columns and types.
     */
    public var prototype:XMap on replace {
        calculateColumns();
    }

    var lastPrototype:XMap;

    function calculateColumns():Void {
        def map = if (prototype != null) prototype else data[0];
        if (map != lastPrototype) {
            columns = for (e in map.entries) {e.key as String}
            types = for (e in map.entries) {if (e.value instanceof FXType) e.value as FXType else if (e.value == null) context.getAnyType() else context.makeClassRef(e.value.getClass())}
            lastPrototype = map;
        }
    }

    override bound function getRange(rowStart:Integer, rowCount:Integer, columns:String[]):DataRow[] {
        for (map in data[rowStart..rowStart+rowCount-1]) {
            MapDataRow{map: map, columns: columns}
        }
    }

    override bound function getRow(rowIndex:Integer, columns:String[]):XBind[] {
        for (column in columns) {
            data[rowIndex].getXBind(column);
        }
    }

    override bound function getColumn(rowStart:Integer, rowCount:Integer, column:String):XBind[] {
        for (map in data[rowStart..rowStart+rowCount-1]) {
            map.getXBind(column);
        }
    }

    override bound function getCell(rowIndex:Integer, column:String):XBind {
        data[rowIndex].getXBind(column);
    }
}
