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
package org.jfxtras.cccp;

import javafx.scene.Cursor;

import javafx.scene.paint.Paint;

import com.sun.javafx.tk.swing.SwingToolkit;

/*
   IMPORTANT: You need to specify -Djavafx.toolkit=org.jfxtras.cccp.Toolkit as
   a JVM runtime argument when you require custom cursors and/or are assigning
   a texture paint to a Scene's fill variable. Of course, jfxtras.jar must be
   included in the CLASSPATH.

   @author Jeff Friesen
*/
public class Toolkit extends SwingToolkit
{
    public override function convertCursorFromFX (cursor: Cursor)
    {
        if (cursor instanceof CustomCursor)
            return (cursor as CustomCursor).cursorAWT;

        super.convertCursorFromFX (cursor)
    }

    public override function createPaint (paint: Paint): java.lang.Object
    {
        if (paint instanceof TexturePaint)
            return paint.impl_getPlatformPaint ();

        super.createPaint (paint);
    }
}