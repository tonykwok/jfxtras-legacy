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
package org.jfxtras.lang;

import com.sun.javafx.functions.Function2;
import com.sun.javafx.runtime.AssignToBoundException;
import com.sun.javafx.runtime.Checks;
import com.sun.javafx.runtime.FXBase;
import com.sun.javafx.runtime.FXObject;
import com.sun.javafx.runtime.Pointer;
import com.sun.javafx.runtime.annotation.Def;
import com.sun.javafx.runtime.annotation.JavafxSignature;
import com.sun.javafx.runtime.annotation.Public;
import com.sun.javafx.runtime.annotation.PublicInitable;
import com.sun.javafx.runtime.annotation.ScriptPrivate;
import com.sun.javafx.runtime.annotation.SourceName;
import com.sun.javafx.runtime.annotation.Static;
import com.sun.javafx.runtime.sequence.Sequence;
import com.sun.javafx.runtime.sequence.Sequences;
import javafx.reflect.FXClassType;
import javafx.reflect.FXLocal;
import javafx.reflect.FXObjectValue;
import javafx.reflect.FXVarMember;

/**
 * Stub function to allow compilation of XDynamicBind before XBind.fx is compiled
 * (this class will get overwritten by the compiler, and can be safely ignored)
 * <p>
 * Note: To regenerate this class, use a decompiler on XBind.fx
 *
 * @author Steve
 */
@Public
public class XBind extends FXBase implements FXObject {

    private static int VCNT$ = 2;
    public static int VOFF$ref = 0;
    public static int VOFF$listeners = 1;
    public short VFLG$ref;
    public short VFLG$listeners;
    @Public
    @SourceName("ref")
    public Object $ref;
    @PublicInitable
    @ScriptPrivate
    @SourceName("listeners")
    public Sequence<? extends Function2<Void, ? super Object, ? super Object>> $listeners;
    @Static
    @Def
    @ScriptPrivate
    @SourceName("context")
    public static FXLocal.Context $context;

    public static int VCNT$() {
        return 2;
    }

    public int count$() {
        return 2;
    }

    public Object get$ref() {
        return null;
    }

    public Object set$ref(Object varNewValue$) {
        return null;
    }

    public void invalidate$ref(int phase$) {
    }

    public void onReplace$ref(Object oldValue, Object newValue) {
    }

    public Sequence<? extends Function2<Void, ? super Object, ? super Object>> get$listeners() {
        return null;
    }

    public Function2<Void, ? super Object, ? super Object> elem$listeners(int pos$) {
        return null;
    }

    public int size$listeners() {
        return 0;
    }

    public void invalidate$listeners(int startPos$, int endPos$, int newLength$, int phase$) {
    }

    public void onReplace$listeners(int startPos$, int endPos$, int newLength$) {
    }

    public void applyDefaults$(int varNum$) {
    }

    public Object get$(int varNum$) {
        return null;
    }

    public Object elem$(int varNum$, int pos$) {
        return null;
    }

    public int size$(int varNum$) {
        return 0;
    }

    public void set$(int varNum$, Object object$) {
    }

    public void seq$(int varNum$, Object object$) {
    }

    public void invalidate$(int varNum$, int startPos$, int endPos$, int newLength$, int phase$) {
    }

    public int varChangeBits$(int varNum$, int clearBits$, int setBits$) {
        return 0;
    }

    public XBind() {
        this(false);
        initialize$(true);
    }

    public XBind(boolean dummy) {
        super(dummy);
    }

    @Public
    public void addListener(Function2<Void, ? super Object, ? super Object> listener) {
    }

    @Public
    public void removeListener(Function2<Void, ? super Object, ? super Object> listener) {
    }

    public static FXLocal.Context get$context() {
        return $context;
    }
}
