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

import javafx.beans.value.ChangeListener;
import javafx.beans.value.ObservableValue;
import javafx.scene.Node;
import javafx.scene.control.TextField;
import jfxtras.scene.control.fxform.model.PropertyElementController;
import jfxtras.scene.control.fxform.view.NodeCreationException;
import jfxtras.scene.control.fxform.view.factory.NodeFactory;

/**
 * User: Antoine Mischler <antoine@dooapp.com>
 * Date: 16/04/11
 * Time: 23:28
 */
public class StringPropertyDelegate implements NodeFactory<PropertyElementController<String>> {

    public Node createNode(final PropertyElementController<String> controller) throws NodeCreationException {
        final TextField text = new TextField();
        String value = controller.getValue();
        if (value != null) {
            text.setText(value);
        }
        text.textProperty().addListener(new ChangeListener<String>() {
            public void changed(ObservableValue<? extends String> observableValue, String s, String s1) {
                controller.setValue(s1);
            }
        });
        controller.addListener(new ChangeListener<String>() {
            public void changed(ObservableValue<? extends String> observableValue, String s, String s1) {
                if (s1 != null) {
                    text.setText(s1);
                } else {
                    text.setText("");
                }
            }
        });
        return text;
    }
}
