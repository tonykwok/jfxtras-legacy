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
import javafx.reflect.FXLocal;
import javafx.reflect.FXVarMember;
import org.jfxtras.lang.XBind;
import org.jfxtras.reflect.ReflectionCache;

/**
 * @author Stephen Chin
 */
var context = FXLocal.getContext();
public class ObjectDataRow extends DataRow {
    public-init var editable:Boolean;
    public-init var object:Object;
    public-init var type:FXClassType;
    public-init var columns:String[];
    var data:XBind[];
    init {
        if (object != null and type != null) {
            def variables = if (columns == null) {
                ReflectionCache.getVariableSequence(type);
            } else {
                def varMap = ReflectionCache.getVariableMap(type);
                for (column in columns) varMap.get(column as Object) as FXVarMember;
            }
            def objectMirror = context.mirrorOf(object);
            data = for (variable in variables) {
                XBind.bindWithInverse(objectMirror, variable);
            }
        }
    }
    override function getData():XBind[] {
        return data;
    }
}
