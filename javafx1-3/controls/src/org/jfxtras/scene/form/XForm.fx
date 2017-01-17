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
package org.jfxtras.scene.form;

import javafx.reflect.FXLocal;
import javafx.reflect.FXType;
import javafx.scene.control.Label;
import javafx.scene.control.TextInputControl;
import javafx.scene.paint.Color;
import javafx.scene.text.Font;
import org.jfxtras.scene.XCustomNode;
import org.jfxtras.scene.layout.XGrid;
import org.jfxtras.scene.layout.XGridRow;
import org.jfxtras.scene.control.data.DataProvider;
import org.jfxtras.scene.control.data.SequenceObjectDataProvider;
import org.jfxtras.scene.control.renderer.PasswordRenderer;
import org.jfxtras.scene.control.renderer.NodeRenderer;
import org.jfxtras.scene.control.renderer.StringAutoRenderer;
import org.jfxtras.scene.control.renderer.TextRenderer;
import org.jfxtras.util.StringUtil;
import org.jfxtras.util.XMap;

/**
 * @author Stephen Chin
 * @author Keith Combs
 */
def context = FXLocal.getContext();

public class XForm extends XCustomNode {
    public var font:Font = Font.DEFAULT;
    public var textColor:Color = Color.BLACK;

    public-init var model:Object;

    public var editable = true;

    // todo - use localization for mapping from ids to real names

    // todo - create a single object data provider
    // todo - move the data and renderer packages out of the control package
    public-init var dataProvider:DataProvider = if (model == null) null else SequenceObjectDataProvider {
        data: model
    }

    public-init var entries:XFormEntry[];

    public var action:function():Void;

    var passwordRenderer = PasswordRenderer {
        font: bind font
        fill: bind textColor
    }

    package var defaultRenderers:XMap = XMap {
        entries: [
            XMap.Entry {
                key: context.getStringType()
                value: StringAutoRenderer {
                    textRenderer: TextRenderer {
                        font: bind font
                        fill: bind textColor
                    }
                }
            }
            XMap.Entry {
                key: context.getIntegerType()
                value: TextRenderer {
                    font: bind font
                    fill: Color.DARKBLUE
                }
            }
        ]
    }

    public-init var chooseRenderer:function(name:String, type:FXType):NodeRenderer = function(name, type) {
        return if (name.toLowerCase().contains("password")) {
            passwordRenderer;
        } else {
            defaultRenderers.get(type) as NodeRenderer;
        }
    }

    init {
        initializeColumns();
    }

    function initializeColumns() {
        if (entries != null) return;
        entries = for (column in dataProvider.columns) XFormEntry {
            id: column
            displayName: StringUtil.camelToTitleCase(column)
            renderer: chooseRenderer(column, dataProvider.types[indexof column])
        }
    }

    override function create() {
        XGrid {
            rows: bind createRows(entries, editable);
        }
    }

    function createRows(entries:XFormEntry[], editable:Boolean) {
        for (entry in entries) {
            def node = entry.renderer.createNode(dataProvider.getCell(0, entry.id), 0, editable, 100, 100);
            if (node instanceof TextInputControl) {(node as TextInputControl).action = action}
            if (entry.displayName == "") {
                XGridRow {
                    column: 1
                    cells: node
                }
            } else {
                XGridRow {
                    cells: [Label {text: entry.displayName}, node]
                }
            }
        }
    }

}
