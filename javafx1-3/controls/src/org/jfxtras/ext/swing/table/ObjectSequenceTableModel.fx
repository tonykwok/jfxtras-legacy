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

/**
 * {@code TableMode} driven by the properties of sequence entries.
 *
 * @example
 * import org.jfxtras.ext.swing.table.IntegerCell;
 * import org.jfxtras.ext.swing.table.ObjectSequenceTableModel;
 * import org.jfxtras.ext.swing.table.Row;
 * import org.jfxtras.ext.swing.table.StringCell;
 *
 * class Person {
 *     var forename:String;
 *     var surname:String;
 *     var age:Integer;
 * }
 *
 * var employees = [
 *     Person {
 *         forename: "Joe"
 *         surname: "Bloggs"
 *         age: 45
 *     }
 *     Person {
 *         forename: "Fred"
 *         surname: "Bloggs"
 *         age: 60
 *     }
 * ];
 *
 * ObjectSequenceTableModel {
 *     override function transformEntry(entry) {
 *         def person:Person = entry as Person;
 *         return Row {
 *             cells: [
 *                 StringCell { value: bind person.forename }
 *                 StringCell {
 *                     value: bind person.surname with inverse
 *                     editable: true
 *                 }
 *                 IntegerCell { value: bind person.age }
 *             ]
 *         }
 *     }
 *     columnLabels: ["Forename", "Surname", "Age"]
 *     sequence: bind employees
 * }
 * @endexample
 *
 * @see org.jfxtras.ext.swing.XSwingTable
 * @profile desktop
 * @author John Freeman
 */
public abstract class ObjectSequenceTableModel extends AbstractMultiColumnTableModel {

    /**
     * The data for the table. Bind with inverse and set {@code editable = true} if you want the cell to be editable.
     */
    public var sequence:Object[] on replace oldValue[start..end] = newElements {
        // need to assign to typed varable for sequence to be created correctly
        def newRows:Row[] = for(entry in newElements) {
            transformEntry(entry);
        };
        rows[start..end] = newRows;
    }

    /**
     * Function required to convert the sequence entry to a row for use in the table. Each row must contain the same
     * number of cells. While different columns may have different cell types every row must use the same cell types
     * as the last.
     */
    public abstract function transformEntry(entry:Object):Row;

}
