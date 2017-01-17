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
package org.jfxtras.data.pull;

import javafx.reflect.*;

protected def context:FXLocal.Context = FXLocal.getContext();

/**
 * @author Stephen Chin
 */
package abstract class ObjectRef {
    public var name:String;
    public var parent:ObjectRef;
    public var fxName:String;
    // root duplication:
    public var rootClass:String;
    public var rootPackage:String;
    public var classRef:FXClassType;
    // this one is only used in XML:
    public var baseClassRef:FXClassType;
    public var type:FXType;
    public var baseType:FXType;
    public var member:FXVarMember;
    public var fxObject:FXValue;
    // seq duplication:
    public var sequenceBuilder:FXSequenceBuilder;
    public var isSequence:Boolean;
    // from XMLHandler:
    public var seqFxObject:FXSequenceValue;

    public abstract function initialize(parent:ObjectRef):Void;

    public function setValue(value:FXValue) {
         if (member == null) {
             fxObject = value;
         } else if (isSequence) { // handle primitive sequences from XML
             def existingSequence = member.getValue(parent.fxObject as FXObjectValue);
             def sequenceBuilder = context.makeSequenceBuilder(baseType);
             for(i in [0..<existingSequence.getItemCount()]) {
                 sequenceBuilder.append(existingSequence.getItem(i));
             }
             sequenceBuilder.append(value);
             member.setValue(parent.fxObject as FXObjectValue, sequenceBuilder.getSequence());
             fxObject = null;
         } else {
             member.setValue(fxObject as FXObjectValue, value);
         }
    }

    //from XMLHandler:
    public function addElement(parent:ObjectRef):Void {
        if (isSequence and fxObject != null) {
            def sequenceBuilder = context.makeSequenceBuilder(baseType);
            for(i in [0..<seqFxObject.getItemCount()]) {
                sequenceBuilder.append(seqFxObject.getItem(i));
            }
            sequenceBuilder.append(fxObject);
            member.setValue(parent.fxObject as FXObjectValue, sequenceBuilder.getSequence());
        }
    }

    // from JSONHandler:
    public function startSequence():Void {
        if (baseType == null) return;
        sequenceBuilder = context.makeSequenceBuilder(baseType);
    }

    public function addElement(val:FXValue) {
        if (BaseHandler.DEBUG) println("{name},{fxName} addElement() : {sequenceBuilder} = {val.getValueString()}");
        if (sequenceBuilder == null) return;
        sequenceBuilder.append(val);
    }

    public function closeSequence():Void {
        if (BaseHandler.DEBUG) println("{name},{fxName} closeSequence() : {sequenceBuilder} = {sequenceBuilder.getSequence().getValueString()}");
        if (sequenceBuilder == null) return;
        setValue(sequenceBuilder.getSequence());
    }
}
