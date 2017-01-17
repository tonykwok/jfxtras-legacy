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

import java.io.File;
import javax.imageio.ImageIO;

/**
 * Utilities that are useful for manipulating URLs and image types when
 * using the built-in JavaFX Image class.
 *
 * @profile desktop
 *
 * @author Stephen Chin
 */
public abstract class ImageUtil {} // placeholder to generate javadoc

/**
 * Function that converts a file to a String url for use with the JavaFX Image class.
 * <p>
 * This function compensates for corner cases with special characters that would normally
 * trip up certain files when accessed on disk.
 */
public function getURL(file:File) {
    def url = file.toURI().toURL();
    def uri = new java.net.URI(url.getProtocol(), url.getUserInfo(),
        url.getHost(), url.getPort(), url.getPath(), url.getQuery(), url.getRef());
    return uri.toString().replaceAll("#", "%23");
}

/**
 * The function returns true if the extension of the given url is supported.  It uses
 * the ImageIO getImageReadersBySuffix method to determine if the file has a valid
 * extension.
 */
public function imageTypeSupported(url:String) {
    def index = url.lastIndexOf('.');
    def extension = if (index == - 1) null else url.substring(index + 1);
    return extension != null and ImageIO.getImageReadersBySuffix(extension).hasNext();
}
