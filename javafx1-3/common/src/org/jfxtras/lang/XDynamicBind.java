/**
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

import com.sun.javafx.runtime.ErrorHandler;
import com.sun.javafx.runtime.FXBase;
import com.sun.javafx.runtime.FXObject;
import com.sun.javafx.runtime.annotation.Package;
import com.sun.javafx.runtime.annotation.PublicInitable;
import com.sun.javafx.runtime.annotation.SourceName;
import javafx.reflect.FXLocal;
import javafx.reflect.FXObjectValue;
import javafx.reflect.FXPrimitiveType;
import javafx.reflect.FXPrimitiveValue;
import javafx.reflect.FXVarMember;

@Package
final class XDynamicBind extends XBind implements FXObject {
    private static int VCNT$ = 5;
    public static int VOFF$obj = 2;
    public static int VOFF$variable = 3;
    public static int VOFF$withInverse = 4;

    @PublicInitable
    @SourceName("obj")
    public FXObjectValue obj;

    @PublicInitable
    @SourceName("variable")
    public FXVarMember variable;

    @PublicInitable
    @SourceName("withInverse")
    public boolean withInverse = false;
    
    public static int VCNT$() { return VCNT$; }
    @Override
    public int count$() { return VCNT$; }

    public void set$obj(FXObjectValue fxObject) {
        obj = fxObject;
    }

    public void set$variable(FXVarMember variable) {
        this.variable = variable;
        if (obj != null && variable != null) {
            DCNT$();
            FXBase.addDependent$(((FXObject)((FXLocal.ObjectValue)obj).asObject()), variable.getOffset(), this, DEP$$_$$ref$ol$2);
        }
    }

    public void set$withInverse(boolean withInverse) {
        this.withInverse = withInverse;
    }

    private static int DCNT$ = -1;
    public static int DEP$$_$$ref$ol$2;

    public Object get$ref() {
        if ((VFLG$ref & 0x18) == 0) {
            VFLG$ref = (short) (VFLG$ref | 0x400);
        } else if ((VFLG$ref & 0x104) == 0x104) {
            Object varNewValue$;
            int varFlags$ = VFLG$ref;
            try {
                if (variable == null || obj == null) return null;
                if (variable.getType() instanceof FXPrimitiveType) {
                    varNewValue$ = ((FXPrimitiveValue)variable.getValue(obj)).asObject();
                } else {
                    varNewValue$ = ((FXLocal.Value)variable.getValue(obj)).asObject();
                }
            } catch (RuntimeException ifx$30tmp) {
                ErrorHandler.bindException(ifx$30tmp);
                varNewValue$ = null;
            }
            VFLG$ref = (short) (VFLG$ref & 0xFFFFFFE7 | 0x0);
            if (!withInverse) {
                VFLG$ref = (short) (VFLG$ref | 0x200);
            }
            if ((VFLG$ref & 0x5) == 4) {
                VFLG$ref = (short) varFlags$;
                return varNewValue$;
            }
            Object varOldValue$ = $ref;
            VFLG$ref = (short) (VFLG$ref & 0xFFFFFFF8 | 0x19);
            if ((varOldValue$ != varNewValue$) || ((varFlags$ & 0x10) == 0)) {
                $ref = varNewValue$;
                onReplace$ref(varOldValue$, varNewValue$);
            }
        }
        return $ref;
    }

    private FXLocal.Context context = FXLocal.Context.getInstance();

    public Object set$ref(Object varNewValue$) {
        if (withInverse) {
            if ((VFLG$ref & 0x100) == 256) {
                if (obj != null && variable != null) {
                    variable.setValue(obj, context.mirrorOf(varNewValue$));
                }
            }
        } else {
            restrictSet$(VFLG$ref);
            VFLG$ref = (short) (VFLG$ref | 0x200);
        }
        Object varOldValue$ = $ref;
        int varFlags$ = VFLG$ref;
        VFLG$ref = (short) (VFLG$ref | 0x18);
        if ((varOldValue$ != varNewValue$) || ((varFlags$ & 0x10) == 0)) {
            invalidate$ref(97);
            $ref = varNewValue$;
            invalidate$ref(94);
            onReplace$ref(varOldValue$, varNewValue$);
        }
        VFLG$ref = (short) (VFLG$ref & 0xFFFFFFF8 | 0x1);
        return $ref;
    }

    public void applyDefaults$(int varNum$) {
        if (!(varTestBits$(varNum$, 56, 8))) {
            return;
        }
        if (XBind.VOFF$ref == varNum$) {
            invalidate$ref(65);
            invalidate$ref(92);
            if ((VFLG$ref & 0x440) != 0) {
                get$ref();
            }
            return;
        }
        super.applyDefaults$(varNum$);
    }

    public void initVars$() {
        super.initVars$();
    }

    public static int DCNT$() {
        if (DCNT$ == -1) {
            int $count = ++DCNT$;
            DEP$$_$$ref$ol$2 = $count + -1;
        }
        return DCNT$;
    }

    public boolean update$(FXObject instance$, int depNum$, int startPos$, int endPos$, int newLength$, int phase$) {
        switch (depNum$ - DCNT$) {
            case -1:
                if (instance$ == ((FXLocal.ObjectValue)obj).asObject()) {
                    invalidate$ref(phase$);
                    return true;
                }
        }
        return super.update$(instance$, depNum$, startPos$, endPos$, newLength$, phase$);
    }

    public XDynamicBind(boolean dummy) {
        super(true);
        VFLG$ref |= 0x100;
    }
}
