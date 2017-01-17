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

import javafx.reflect.FXClassType;
import org.jfxtras.lang.XBind;
import org.jfxtras.reflect.ReflectionCache;

/**
 * @author Stephen Chin
 * @author Keith Combs
 */
public abstract class ObjectDataProvider extends DataProvider {
    public var type:FXClassType on replace oldValue=newValue {
        if (oldValue != newValue) {
            def variables = ReflectionCache.getVariableSequence(type);
            columns = for (variable in variables) {
                variable.getName();
            }
            types = for (variable in variables) {
                variable.getType();
            }
        }
    }

    public abstract bound function getItems(startIndex:Integer, count:Integer):Object[];
    
    public bound function getItem(index:Integer):Object {
        return getItems(index, 1)[0];
    }

    override bound function getRange(rowStart:Integer, rowCount:Integer, columns:String[]):DataRow[] {
        var objects = getItems(rowStart, rowCount);
        for (object in objects) {
            ObjectDataRow {
                object: object
                type: type
                columns: columns
            }
        }
    }

    override bound function getRange(rowStart:Integer, rowCount:Integer):DataRow[] {
        var objects = getItems(rowStart, rowCount);
        for (object in objects) {
            ObjectDataRow {
                object: object
                type: type
            }
        }
    }

    override bound function getRow(rowIndex:Integer, columns:String[]):XBind[] {
        ObjectDataRow {
            object: getItem(rowIndex);
            type: type
            columns: columns
        }.getData();
    }

    override bound function getRow(rowIndex:Integer):XBind[] {
        ObjectDataRow {
            object: getItem(rowIndex);
            type: type
        }.getData();
    }
}
