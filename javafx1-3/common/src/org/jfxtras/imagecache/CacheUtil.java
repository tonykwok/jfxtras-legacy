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
package org.jfxtras.imagecache;

import java.io.File;
import java.net.URI;
import java.net.URISyntaxException;

/*
 * @author joshua@marinacci.org
 */
class CacheUtil {

    static File getCachePath(File cacheDir, String url, int requestedWidth, int requestedHeight, SizingMethod sizing) throws URISyntaxException {
        //System.out.println("dealing with url: " + url);
        URI uri = new URI(url);
        String host = uri.getHost().replace('.', '_');
        //p("host = " + host);
        String path = uri.getPath().replace('/', '_');
        //p("path = " + path);
        //p("query = " + uri.getQuery());
        String extension = path.substring(path.lastIndexOf('.')+1);
        //p("extension = " + extension);

        File imagesDir = new File(cacheDir, "images");
        File hostDir = new File(imagesDir,host);
        File pathDir = new File(hostDir, path);
        if(requestedWidth > 0 || requestedHeight > 0) {
            extension = "png";
        }
        File image = new File(pathDir,"image_"+sizing.toString()+"_"+requestedWidth+"_"+requestedHeight+"."+extension);
        //p("image path = " + image.getPath());
        return image;

    }

    
    static void recursiveDelete(File cacheDir) {
        if(cacheDir.isDirectory() && cacheDir.exists()) {
            for(File f : cacheDir.listFiles()) {
                recursiveDelete(f);
            }
        }
        if(cacheDir.exists()) {
            cacheDir.delete();
        }
    }


}
