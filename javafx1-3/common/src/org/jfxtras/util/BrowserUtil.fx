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
package org.jfxtras.util;

import java.lang.Class;
import java.net.URI;
import java.net.URL;
import javax.jnlp.BasicService;
import javax.jnlp.ServiceManager;
import javafx.stage.AppletStageExtension;

/**
 * Utility library for interacting with a web browser.
 *
 * @author Stephen Chin
 */
public class BrowserUtil {}

public def applet = FX.getArgument("javafx.applet") as java.applet.Applet;
public def inBrowser = applet != null;

/**
 * Url navigation convenience function.  This will allows you to use a single call to launch a link in
 * a browser regardless of whether you are running as an applet, a web start application, or a desktop
 * application.
 * <p>
 * The one configuration in which this method will not work is if you are running in a pre-Java 6 JVM as
 * a desktop application.
 * <p>
 * Web start and desktop applications will always open a new window.  However, if you are running as an
 * applet in a browser, it will replace the current frame.  To have more control over the applet behavior,
 * use the other variant of this method with a target parameter.
 */
public function browse(url:String) {
    browse(url, "_self");
}

/**
 * Url navigation convenience function.  This will allows you to use a single call to launch a link in
 * a browser regardless of whether you are running as an applet, a web start application, or a desktop
 * application.
 * <p>
 * The one configuration in which this method will not work is if you are running in a pre-Java 6 JVM as
 * a desktop application.
 * <p>
 * Web start and desktop applications will always open a new window.  However, if you are running as an
 * applet in a browser, you can choose the behavior by passing in one of the following targets:
 * <ul>
 * <li>"_self" - Show in the window and frame that contain the applet.
 * <li>"_parent" - Show in the applet's parent frame. If the applet's frame has no parent frame, acts the same as "_self".
 * <li>"_top" - Show in the top-level frame of the applet's window. If the applet's frame is the top-level frame, acts the same as "_self".
 * <li>"_blank" - Show in a new, unnamed top-level window.
 * <li>name - Show in the frame or window named name. If a target named name does not already exist, a new top-level window with the specified name is created, and the document is shown there.
 * </ul>
 */
public function browse(url:String, target:String) {
    if (inBrowser) { // If in a browser, try the applet API first
        def appletExtension = AppletStageExtension {}
        appletExtension.showDocument(url, target); // default dehavior is to open the link in the same window
    } else { // Try the JDK 6 Desktop API (default applet behavior is open in the same window)
        // Invoke "Desktop.getDesktop().browse(uri)" using Reflection
        try {
            def desktopClazz = Class.forName("java.awt.Desktop");
            def desktop = desktopClazz.getMethod("getDesktop").invoke(null);
            def browseMethod = desktopClazz.getMethod("browse", [URI.class] as java.lang.Class[]);
            browseMethod.invoke(desktop, new URI(url));
        } catch (e) { // Try web start (default applet behavior is open in a new window)
            try {
                def basicService = ServiceManager.lookup("javax.jnlp.BasicService") as BasicService;
                basicService.showDocument(new URL(url));
            } catch (e2) {
                println("Upgrade to Java 6 or later to launch hyperlinks: {url}");
            }
        }
    }
}
