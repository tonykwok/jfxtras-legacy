/*
 * Copyright (c) 2011, dooApp <contact@dooapp.com>
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *
 * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * Neither the name of dooApp nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

package jfxtras.scene.control.fxform.view.factory.delegate;

import javafx.beans.property.ObjectProperty;
import javafx.beans.property.SimpleObjectProperty;
import javafx.beans.value.ChangeListener;
import javafx.beans.value.ObservableValue;
import javafx.scene.Node;
import javafx.scene.control.TextField;
import jfxtras.scene.control.fxform.model.PropertyElementController;
import jfxtras.scene.control.fxform.view.factory.FormatProvider;
import jfxtras.scene.control.fxform.view.factory.NodeFactory;

import java.text.Format;
import java.text.ParseException;

/**
 * User: Antoine Mischler <antoine@dooapp.com> Date: 17/04/11 Time: 17:31
 */
public abstract class AbstractNumberPropertyDelegate<T extends Number> implements
        NodeFactory<PropertyElementController<T>> {

    protected ObjectProperty<T> numberProperty = new SimpleObjectProperty<T>();

    protected final FormatProvider formatProvider;

    public AbstractNumberPropertyDelegate(FormatProvider formatProvider) {
        this.formatProvider = formatProvider;
    }

    public Node createNode(final PropertyElementController<T> controller) {
        final TextField textBox = new TextField();
        textBox.textProperty().addListener(new ChangeListener<String>() {

            public void changed(ObservableValue<? extends String> observableValue, String s, String s1) {
                if (textBox.getText().trim().length() > 0) {
                    try {
                        Number parsed = parse(formatProvider.getFormat(controller.getElement()), textBox.getText());
                        numberProperty.setValue((T) parsed);
                    } catch (ParseException e) {
                        e.printStackTrace();
                    }
                }
            }
        });
        if (controller.getValue() != null) {
            textBox.textProperty().setValue(formatProvider.getFormat(controller.getElement()).format(controller.getValue()));
        }
        controller.addListener(new ChangeListener() {
            public void changed(ObservableValue observableValue, Object o, Object o1) {
                textBox.textProperty().setValue(formatProvider.getFormat(controller.getElement()).format(controller.getValue()));
            }
        });
        numberProperty.addListener(new ChangeListener<T>() {
            public void changed(ObservableValue<? extends T> observableValue, T t, T t1) {
                controller.setValue(t1);
            }
        });
        return textBox;
    }

    protected abstract Number parse(Format format, String text) throws ParseException;

}
