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

import com.sun.javafx.tk.swing.FrameStage;
import java.awt.Frame;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import java.lang.Void;
import javafx.scene.image.Image;
import java.awt.Window;
import java.util.List;
import javax.swing.JFrame;
import java.awt.image.BufferedImage;
import javax.swing.JDialog;

/**
 * Allows access to the currently visible modal XDialog.  This is necessary, because a modal
 * dialog blocks the event thread preventing normal assignment of a variable.
 * <p>
 * This will also work properly in nested modal dialog cases, returning the one in the forefront.
 */
public static var CURRENT_MODAL:XDialog;

/**
 * Extension of javafx.stage.Stage that allows the creation of first-class Java
 * Dialogs from JavaFX-only code.  Dialogs can be created via declarative
 * syntax and have any other Stage as their owner window.  Some features not
 * available on Stage include the ability to "pack" the window to the size
 * of the contents, specify modality, and force the window to be on top.
 * <p>
 * This class is named XDialog to avoid future name collisions with JavaFX
 * Dialog support when released.  At that time this class will be changed to
 * extend the official Dialog class, providing forward interoperability.
 *
 * @profile desktop
 *
 * @author Stephen Chin
 * @author Keith Combs
 */
public class XDialog extends XStage {
    /**
     * Owner window of this Dialog
     */
    public-init protected var owner:Stage;

    /**
     * Allows an ownerless dialog to be focused independently from other
     * ownerless windows.  This has no effect if owner is non-null.
     */
    public-init protected var independentFocus = false;

    /**
     * Whether this Dialog blocks user input in the owner Window until dismissed.
     */
    public-init protected var modal = false;

    /**
     * Returns the raw javax.swing.JDialog class that backs this Dialog instance.
     * <p>
     * Please submit a request for any functionality you find that you need to
     * access directly using this variable so it can be added to the XDialog
     * API.
     */
    public var dialog:JDialog;

    override function getWindow() {
        return dialog;
    }

    override var scene on replace {
        delegate.setJavaFXScene(scene);
    }

    override var icons on replace {
        setIcons(icons);
    }

    function setIcons(icons:Image[]) {
        def window = getWindow();
        if (window == null) {
            return;
        }
        def bufferedImages = for (icon in icons) icon.impl_getPlatformImage() as BufferedImage;
        def images = java.util.Arrays.asList(bufferedImages);
        def iconImagesMethod = Window.<<class>>.getMethod("setIconImages", List.<<class>>);
        if (iconImagesMethod != null) {
            iconImagesMethod.invoke(window, images);
        } else if (sizeof icons > 0 and window instanceof JFrame) {
            (window as JFrame).setIconImage(icons[0].impl_getPlatformImage() as BufferedImage);
        }
    }

    var lastModal:XDialog;

    override function close() {
        CURRENT_MODAL = lastModal;
        super.close();
    }

    var delegate:DialogStage;

    init {
        delegate = createDelegate();
        delegate.setFrameStage(WindowHelper.setStagePeer(this, delegate) as FrameStage);
        if (modal) {
            lastModal = CURRENT_MODAL;
            CURRENT_MODAL = this;
            visible = false;
            dialog.setModal(true);
            visible = true;
        }
    }

     function createDelegate(): DialogStage {
        def ownerWindow = if (independentFocus) new Frame()
            else if (owner == null) null
            else WindowHelper.extractWindow(owner);
        dialog = WindowHelper.createJDialog(style, ownerWindow);
        setIcons(icons);
        if (independentFocus) {
            def listener:WindowAdapter = WindowAdapter {
                override function windowClosed(e:WindowEvent):Void {
                    dialog.removeWindowListener(listener);
                    ownerWindow.dispose();
                }
            };
            dialog.addWindowListener(listener);
        }
        new DialogStage(dialog, style, scene);
    }
}
