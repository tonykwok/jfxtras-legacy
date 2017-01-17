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

package org.jfxtras.ext.swing.table;

import java.math.BigDecimal;

/**
 * Cell representing big decimal type.
 * 
 * @example
 * // e.g. dynamic value editable cell
 * import java.math.BigDecimal;
 * import org.jfxtras.ext.swing.table.BigDecimalCell;
 *
 * var modelValue = new BigDecimal("12.345");
 *
 * BigDecimalCell {
 *    value: bind modelValue with inverse
 *    editable: true
 * }
 * @endexample
 *
 * @example
 * // e.g. dynamic value non-editable cell
 * import java.math.BigDecimal;
 * import org.jfxtras.ext.swing.table.BigDecimalCell;
 *
 * var modelValue = new BigDecimal("12.345");
 *
 * BigDecimalCell {
 *    value: bind modelValue
 * }
 * @endexample
 *
 * @example
 * // e.g. static value non-editable cell
 * import java.math.BigDecimal;
 * import org.jfxtras.ext.swing.table.BigDecimalCell;
 *
 * var modelValue = new BigDecimal("12.345");
 *
 * BigDecimalCell {
 *    value: modelValue
 * }
 * @endexample
 *
 * @see ObjectSequenceTableModel
 * @profile desktop
 * @author John Freeman
 */
public class BigDecimalCell extends Cell {

    /**
     * Binding for big decimal value. Bind with inverse and set {@code editable = true} if you want the cell to be
     * editable.
     */
    public var value:BigDecimal on replace {
        valueChanged();
    }

    override function getColumnClass() {
        return BasicTypes.BIG_DECIMAL;
    }

    override function getValue() {
        return value;
    }

    override function setValue(newValue):Void {
        value = newValue as BigDecimal;
    }

}
