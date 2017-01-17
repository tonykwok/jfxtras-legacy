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

package jfxtras.scene.control.fxform.view.factory;

import javafx.beans.binding.StringBinding;
import javafx.scene.Node;
import javafx.scene.control.Label;
import jfxtras.scene.control.fxform.model.ElementController;
import jfxtras.scene.control.fxform.view.NodeCreationException;

/**
 * Factory creating a label bound to a string representation of the {@code Element}<br>
 * <br>
 * Created at 20/09/11 10:45.<br>
 *
 * @author Antoine Mischler <antoine@dooapp.com>
 */
public class ReadOnlyFactory implements NodeFactory {

    private final FormatProvider formatProvider;

    public ReadOnlyFactory() {
        this(new FormatProviderImpl());
    }

    public ReadOnlyFactory(FormatProvider formatProvider) {
        this.formatProvider = formatProvider;
    }

    public Node createNode(final ElementController controller) throws NodeCreationException {
        Label label = new Label();
        label.textProperty().bind(new StringBinding() {

            {
                bind(controller);
            }

            @Override
            protected String computeValue() {
                if (controller.getValue() != null) {
                    return formatProvider.getFormat(controller.getElement()).format(controller.getElement().getValue());
                } else {
                    return "";
                }
            }
        });
        return label;
    }
}