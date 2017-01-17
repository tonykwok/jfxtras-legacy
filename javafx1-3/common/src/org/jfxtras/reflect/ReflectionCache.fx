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
package org.jfxtras.reflect;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import javafx.reflect.FXClassType;
import javafx.reflect.FXLocal;
import javafx.reflect.FXVarMember;
import org.jfxtras.util.XMap;

/**
 * This class contains static methods that return reflection information about a class.  All results are
 * cached on the first invocation to improve performance.
 *
 * @author Stephen Chin
 */
public class ReflectionCache {}

var context = FXLocal.getContext();

var variableSequences:XMap = XMap {}
var variableMaps:XMap = XMap {}

// workaround for Object->sequence casting issue
class FXVMSequence {
    var fxvms:FXVarMember[]
}

/**
 * Returns an ordered set of variables for the given class.  Results are cached between invocations
 * to improve performance.
 */
public function getVariableSequence(classType:FXClassType):FXVarMember[] {
    if (not variableSequences.containsKey(classType)) {
        populateVariables(classType);
    }
    return (variableSequences.get(classType) as FXVMSequence).fxvms;
}

/**
 * Returns a map that can be used to quickly lookup a variable by name.  Results are cached
 * between invocations to improve performance.
 */
public function getVariableMap(classType:FXClassType):XMap {
    if (not variableMaps.containsKey(classType)) {
        populateVariables(classType);
    }
    return variableMaps.get(classType) as XMap;
}

function populateVariables(classType:FXClassType) {
    var variables = new ArrayList(classType.getVariables(false));
    Collections.sort(variables, Comparator {
        override function compare(a:Object, b:Object):Integer {
            var varA = a as FXVarMember;
            var varB = b as FXVarMember;
            return varA.getOffset().compareTo(varB.getOffset());
        }
    });
    var varSequence = for (variable in variables where not (variable as FXVarMember).isStatic()) {variable as FXVarMember};
    variableSequences.put(classType, FXVMSequence{fxvms: varSequence});
    var varMap = XMap {
        entries: for (variable in varSequence) XMap.Entry {
            key: variable.getName()
            value: variable
        }
    }
    variableMaps.put(classType, varMap);
}
