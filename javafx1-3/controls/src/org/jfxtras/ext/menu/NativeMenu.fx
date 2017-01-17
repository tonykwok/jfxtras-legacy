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

/**
 * JavaFX wrapper for the native AWT Menu class.
 * <p>
 * This is ideally suited for instances where native menus are required, such
 * as for use with the SystemTray.  For menus that you can associate with a
 * {@link org.jfxtras.stage.XStage} or {@link org.jfxtras.stage.XDialog}
 * please refer to Menu (not yet implemented).
 *
 * @profile desktop
 *
 * @author Stephen Chin
 */
public class NativeMenu extends NativeMenuItem {
    /**
     * A sequence of {@link NativeMenuEntry}s associated with this Menu.
     */
    public var items:NativeMenuEntry[] on replace oldItems[i..j]=newItems {
        var menu = getMenu();
        for (ind in reverse [i..j]) {
            menu.remove(ind);
        }
        for (item in newItems) {
            item.insertInto(this, i + indexof item);
        }
    }

    /**
     * Returns the java.awt.Menu instance associated with this class.
     *
     * @return The native java.awt.Menu instance
     */
    public function getMenu():Menu {
        return getMenuItem() as Menu;
    }

    override function createMenuItem():MenuItem {
        return Menu{};
    }
}
