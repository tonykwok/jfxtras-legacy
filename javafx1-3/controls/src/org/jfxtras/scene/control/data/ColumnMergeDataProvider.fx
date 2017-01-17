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

import org.jfxtras.scene.control.data.DataProvider;
import javafx.reflect.FXType;
import javafx.util.Sequences;
import org.jfxtras.scene.control.data.DataRow;

/**
 * Data Provider that can be used to merge in two different sources.  Useful
 * if you have multiple model objects, or simply want to add in a few extra
 * columns via a MapDataProvider.
 *
 * @author jlweaver
 * @author Stephen Chin
 */
public class ColumnMergeDataProvider extends DataProvider {
    public-init var dataProviderA:DataProvider;
    public-init var dataProviderB:DataProvider;

    override var rowCount:Integer = bind dataProviderA.rowCount;
    override public-read protected var columns:String[] = bind [dataProviderA.columns, dataProviderB.columns];
    override public-read protected var types:FXType[] = bind [dataProviderA.types, dataProviderB.types];

    override public bound function getRange(rowStart:Integer, rowCount:Integer, columns:String[]):DataRow[] {
        def aColumns = columns[c|Sequences.indexOf(dataProviderA.columns, c) != -1];
        def bColumns = columns[c|Sequences.indexOf(dataProviderB.columns, c) != -1];
        def rowASeq = dataProviderA.getRange(rowStart, rowCount, aColumns);
        def rowBSeq = dataProviderB.getRange(rowStart, rowCount, bColumns);
        for (a in rowASeq) ColumnMergeDataRow {
            aColumns: bind aColumns
            bColumns: bind bColumns
            columns: bind columns
            dataA: a
            dataB: rowBSeq[indexof a]
        }
    }
}
