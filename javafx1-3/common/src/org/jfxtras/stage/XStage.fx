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
package org.jfxtras.stage;

import javafx.stage.*;
import java.awt.Window;
import java.util.List;
import javafx.scene.image.*;
import javax.swing.JFrame;

/**
 * An extension of javafx.stage.Stage that provides additional functionality,
 * such as the ability to set the window to be always on top, or direct access
 * to the underlying java.awt.Window object.
 * <p>
 * Please submit a request for any functionality you find that you need to
 * access directly using {@link #getWindow()} so it can be added to the XStage
 * API.
 *
 * @profile desktop
 *
 * @author Stephen Chin
 */
public class XStage extends Stage {
    
    var windowInitialized = false;

    /**
     * Returns the java.awt.Window associated with this Stage.  This will return
     * null until the Stage is fully initialized (after postinit).
     * <p>
     * Please submit a request for any functionality you find that you need to
     * access directly using this variable so it can be added to the XStage
     * API.
     *
     * @return The java.awt.Window associated with this Stage
     */
    public function getWindow():Window {
        return if (windowInitialized) WindowHelper.extractWindow(this) else null;
    }

    /**
     * If set to true, this Dialog will float on top of all other windows.
     */
    public var alwaysOnTop = false on replace {
        getWindow().setAlwaysOnTop(alwaysOnTop);
    }

    postinit {
        windowInitialized = true;
        if (alwaysOnTop) { // set alwaysOnTop after window initialization
            getWindow().setAlwaysOnTop(true);
        }
    }
}
