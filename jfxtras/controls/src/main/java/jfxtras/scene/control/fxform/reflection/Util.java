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

package jfxtras.scene.control.fxform.reflection;

import java.lang.reflect.Field;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * User: Antoine Mischler <antoine@dooapp.com>
 * Date: 09/09/11
 * Time: 14:37
 */
public class Util {

    private final static String PATTERN_STRING = "<L(.*);>;";

    private final static Pattern PATTTERN = Pattern.compile(PATTERN_STRING);

    private final static String SIGNATURE = "signature";

    /**
     * Tries to retrieve the generic parameter of an ObjectProperty at runtime. Some kind of magic need to be done there.
     *
     * @param field a Field of ObjectProperty<T> type
     * @return the Class of the generic parameter of the given field
     * @throws NoSuchFieldException
     * @throws IllegalAccessException
     * @throws InstantiationException
     * @throws ClassNotFoundException
     */
    public static Class getObjectPropertyGeneric(Field field) throws NoSuchFieldException, IllegalAccessException, InstantiationException, ClassNotFoundException {
        Field signatureField = field.getClass().getDeclaredField(SIGNATURE);
        signatureField.setAccessible(true);
        String signature = (String) signatureField.get(field);
        Matcher matcher = PATTTERN.matcher(signature);
        if (matcher.find()) {
            return Class.forName(matcher.group(1).replaceAll("/", "."));
        }
        throw new ClassNotFoundException("Generic class could not be retrieved");
    }

}
