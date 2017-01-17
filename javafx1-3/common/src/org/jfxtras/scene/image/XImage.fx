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
package org.jfxtras.scene.image;

import javafx.scene.image.Image;

/**
 * Drop-in replacement for the JavaFX Image class that fixes several defects
 * with backgroundLoading enabled that cause the image load to hang and the
 * progress to remain at 0 percent.  This happens under the following conditions:
 * <ul>
 * <li>More than 4 images loaded with errors previously
 * <li>More than 4 images cancelled by calling the cancel() method previously 
 * </ul>
 * <p>
 * This issue has been filed with the JavaFX team as <a href="http://javafx-jira.kenai.com/browse/RT-3590">RT-3590</a>.
 *
 * @profile common
 *
 * @author Stephen Chin
 */
public class XImage extends Image {
    def hasError = bind error on replace {
        if (error and backgroundLoading) {
            XImageHelper.decrementRunningTasks();
        }
    }

    override function cancel() {
        super.cancel();
        if (backgroundLoading) {
            XImageHelper.removePendingTask(this);
        }
    }

}
