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
package org.jfxtras.ext.menu;

import java.awt.*;
import java.awt.event.*;

/**
 * Wrapper for a native MenuItem for use in a {@link NativeMenu}.
 *
 * @profile desktop
 *
 * @author Stephen Chin
 */
public class NativeMenuItem extends NativeMenuEntry {
    /**
     * The name of this menu item.  Corresponds to the label property on the
     * native peer.
     */
    public var text:String on replace {
        getMenuItem().setLabel(text);
    }

    /**
     * Action that will get executed when this menu item is clicked.
     */
    public var action:function():Void;
    
    var menuItem:MenuItem;
    
    /**
     * Returns the java.awt.MenuItem instance associated with this class.
     *
     * @return The native java.awt.MenuItem instance
     */
    public function getMenuItem():MenuItem {
        if (menuItem == null) {
            menuItem = createMenuItem();
            menuItem.addActionListener(ActionListener {
                override function actionPerformed(e:ActionEvent):Void {
                    if (action != null) {
                        action();
                    }
                }
            });
        }
        return menuItem;
    }
    
    package function createMenuItem():MenuItem {
        return MenuItem{};
    }
    
    override function insertInto(menu:NativeMenu, ind:Integer):Void {
        menu.getMenu().<<insert>>(getMenuItem(), ind);
    }
}
