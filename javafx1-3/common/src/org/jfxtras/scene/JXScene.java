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
package org.jfxtras.scene;


import com.sun.javafx.runtime.Entry;
import com.sun.javafx.runtime.sequence.Sequence;
import com.sun.javafx.tk.swing.FrameStage;

import java.awt.BorderLayout;
import java.awt.Container;
import java.awt.event.ComponentListener;
import java.awt.event.ComponentEvent;
import java.awt.event.ComponentAdapter;
import java.util.Map;
import javafx.reflect.FXLocal.ClassType;
import javax.swing.JComponent;
import javax.swing.JFrame;
import javafx.reflect.FXClassType;
import javafx.reflect.FXFunctionMember;
import javafx.reflect.FXLocal;
import javafx.reflect.FXLocal.ObjectValue;
import javafx.reflect.FXObjectValue;
import javafx.scene.Scene;
import javafx.stage.Stage;


/**
 * A Java class that allows embedding a javafx scene in java/swing.
 * It allows communication between the swing and javafx side.
 *
 * This class was originally created by Richard Bair and Jasper Potts and re-implemented for version javafx1.2
 * For more examples and documentation check out this blog post: http://blogs.sun.com/javafx/entry/how_to_use_javafx_in
 *
 * The JavaFX class to be embedded can extend Stage or Scene, or be a script file that returns an instance of Stage or Scene.
 *
 * @example
 * <code>
 *  import org.jfxtras.scene.JXScene;
 *
 *  public class TheFrame extends javax.swing.JFrame {
 *
 *      public TheFrame() {
 *          JXScene jxScene = new JXScene();
 *          jxScene.setScript("com.sun.test.MyScene"); // the name of your main JavaFX class
 *          add(jxScene); // add the scene your swing scene
 *          IPrintable printable = (IPrintable) jxScene.getScriptObject();
 *          printable.print("calling javafx from the swing side");
 *      }
 *      public static void main(String args[]) {
 *         java.awt.EventQueue.invokeLater(new Runnable() {
 *             public void run() {
 *                 new TheFrame().setVisible(true);
 *             }
 *         });
 *      }
 *  }
 *  </code>
 *  @endexample
 *  <p>To run this, the jar files in the JavaFX SDK lib/shared and lib/desktop
 *  must be included in the java CLASSPATH.
 * @example
 * <code>
 * JAVAFX_HOME=/opt/javafx-1.2
 * SHARED=$JAVAFX_HOME/lib/shared
 * DESKTOP=$JAVAFX_HOME/lib/desktop

 * CP=dist/jfxtras.jar
 * CP=$CP:$SHARED/javafxrt.jar
 * CP=$CP:$SHARED/javafxc.jar
 * CP=$CP:$DESKTOP/decora-j2d-rsl.jar
 * CP=$CP:$DESKTOP/decora-ogl.jar
 * CP=$CP:$DESKTOP/decora-runtime.jar
 * CP=$CP:$DESKTOP/eula.jar
 * ...
 * java -cp $CP TheFrame
 * </code>
 * @endexample
 *
 * @profile Desktop
 * @author Pedro Duque Vieira
 */
public class JXScene<T> extends JComponent {

    private T scene;

    private final FXLocal.Context context = FXLocal.getContext();

    public JXScene() {
        setLayout(new BorderLayout());
        addComponentListener(new ComponentAdapter() {
            @Override
            public void componentResized(ComponentEvent e) {
                repaint();
            }

            @Override
            public void componentMoved(ComponentEvent e) {
                repaint();
            }
        });
    }

    /**
     * Create a JXScene with the given JavaFX class.
     *
     * @param sceneClassName Name of the JavaFX class to be loaded.  Can extend
     * Stage or Scene, or be a script file that returns an instance of Stage or Scene.
     */
    public JXScene(String sceneClassName) {
        this();
        setScript(sceneClassName);
    }

    /**
     * Create a JXScene with the given JavaFX class initialized with the passed in initVars.
     *
     * @param sceneClassName Name of the JavaFX class to be loaded.  Can extend
     * Stage or Scene, or be a script file that returns an instance of Stage or Scene.
     * @param initVars a keyed map of init's var's you want to set when creating
     * the script object.
     */
    public JXScene(String sceneClassName, Map<String, Object> initVars) {
        setLayout(new BorderLayout());
        setScript(sceneClassName, initVars);
    }

    /**
     * Initializes the JXScene to use the given JavaFX class
     *
     * @param sceneClassName Name of the JavaFX class to be loaded.  Can extend
     * Stage or Scene, or be a script file that returns an instance of Stage or Scene.
     */
    public final void setScript(String sceneClassName) {
        setScript(sceneClassName, null);
    }

    /**
     * Initializes the JXScene with the given JavaFX class initialized with the passed in initVars.
     *
     * @param scriptClassName the JavaFX object that extends javafx.stage.Stage,
     * javafx.scene.Scene, or returns one of the former.
     * @param initVars a keyed map of init's var's you want to set when creating
     * the script object.
     */
    public final void setScript(String scriptClassName, Map<String, Object> initVars) {
        FXLocal.ClassType sceneClass = FXLocal.getContext().findClass(scriptClassName);
        final FXObjectValue fxObjectValue = sceneClass.allocate();
        if (initVars != null) {
            for (String key : initVars.keySet()) {
                fxObjectValue.initVar(key, FXLocal.getContext().mirrorOf(initVars.get(key)));
            }
        }
        ObjectValue objectInstance = (ObjectValue) fxObjectValue.initialize();
        Object scriptObject = (T) objectInstance.asObject();
        if (!(scriptObject instanceof Scene || scriptObject instanceof Stage)) {
            scriptObject = runScript(sceneClass);
        }
        if (scriptObject instanceof Scene) {
            scene = (T) scriptObject;
            add(sceneToJComponent((Scene) scriptObject), BorderLayout.CENTER);
        } else if (scriptObject instanceof Stage) {
            scene = (T) ((Stage) scriptObject).get$scene();
            add(stageToJComponent((Stage) scriptObject), BorderLayout.CENTER);
        } else {
            throw new IllegalStateException("Script file is not an instance of Scene or Stage");
        }
    }

    /**
     * Executes the given script class, returning the object that is the result of running it.
     *
     * @param scriptClass Class to be run as a script
     * @return The result of executing this script
     * @throws IllegalArgumentException
     */
    private Object runScript(ClassType scriptClass) throws IllegalArgumentException {
        try {
            String name = Entry.entryMethodName();
            Entry.deferAction(new Runnable() {
                public void run() {
                }
            }); // force the runtime provider to get loaded
            return scriptClass.getJavaImplementationClass().getMethod(name, Sequence.class).invoke(null, (Object) null);
        } catch (NoSuchMethodException ex) {
            throw new IllegalArgumentException("Script " + scriptClass + " is missing a JavaFX run function.", ex);
        } catch (Exception ex) {
            throw new IllegalStateException("Exception while executing script", ex);
        }
    }


    /**
     * This method wraps the Scene with a JComponent.
     *
     * @param scene the JavaFX object that extends javafx.scene.Scene.
     * @return the javafx.scene.Scene wrapped by a JComponent.
     */
    private Container sceneToJComponent(Scene scene) {
        FXClassType stageType = context.findClass("javafx.stage.Stage");
        FXLocal.ObjectValue stageObj = (ObjectValue) stageType.allocate();
        //stageObj.initVar("visible", FXLocal.getContext().mirrorOf(Boolean.FALSE));
        stageObj.initVar("opacity", FXLocal.getContext().mirrorOf(new Float(0.0)));
        ObjectValue sceneObj = context.mirrorOf(scene);

        stageObj.initVar("scene", sceneObj);
        stageObj.initialize();
        return stageToJComponent((Stage) stageObj.asObject());
    }

    /**
     * Extracts the Container from the Stage and destroys the Stage frame.
     *
     * @param stage Stage that the Scene Container will be extracted from
     * @return A Container that holds the Scene
     */
    private Container stageToJComponent(Stage stage) {
        FXClassType stageType = context.findClass("javafx.stage.Stage");
        FXFunctionMember getPeer = stageType.getFunction("impl_getPeer");
        FXLocal.ObjectValue peer = (ObjectValue) getPeer.invoke(context.mirrorOf(stage));

        FrameStage frameStage = (FrameStage) peer.asObject();

        JFrame jframe = (JFrame)frameStage.window;
        Container container =  jframe.getContentPane();
        jframe.remove(container);
        jframe.dispose();

        return container;
    }

    /**
     * This method allows you to get the JavaFX Java Object. The JavaFX Java
     * Object typically implements a java interface T. This allows the JavaFX
     * Object to expose itself to the caller. Note, that JavaFX can extend
     * multiple Java interfaces, so there could be more than on type T on offer.
     * If this is the case you will need to cast the object yourself.
     *
     * @return the javafx.scene.Scene java Object
     */
    public T getScriptObject() {
        return scene;
    }
}