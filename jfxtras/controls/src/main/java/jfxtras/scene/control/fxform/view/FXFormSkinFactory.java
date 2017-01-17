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

package jfxtras.scene.control.fxform.view;

import jfxtras.scene.control.fxform.FXFormX;
import jfxtras.scene.control.fxform.view.skin.DefaultSkin;
import jfxtras.scene.control.fxform.view.skin.InlineSkin;

/**
 * User: Antoine Mischler <antoine@dooapp.com>
 * Date: 28/08/11
 * Time: 14:19
 */
public interface FXFormSkinFactory {

    public FXFormSkin createSkin(FXFormX form);

    public final static FXFormSkinFactory DEFAULT_FACTORY = new FXFormSkinFactory() {
        public FXFormSkin createSkin(FXFormX form) {
            return new DefaultSkin(form);
        }

        public String toString() {
            return "Default skin";
        }
    };

    public final static FXFormSkinFactory INLINE_FACTORY = new FXFormSkinFactory() {
        public FXFormSkin createSkin(FXFormX form) {
            return new InlineSkin(form);
        }

        public String toString() {
            return "Inline skin";
        }
    };


}
