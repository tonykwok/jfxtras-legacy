/*
 * Copyright (c) 2009, Sten Anderson, CITYTECH, INC.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 * 1. Redistributions of source code must retain the above copyright notice,
 *    this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 * 3. Neither the name of CITYTECH, INC. nor the names of its contributors may be used
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

package com.citytechinc.ria.musicexplorerfx.model;

import java.util.Map;
import net.roarsoftware.lastfm.Image;
import net.roarsoftware.lastfm.PaginatedResult;

/**
 *
 * @author Sten Anderson
 */
public class LastfmHelper {

    private Map<String,String> cache = new java.util.HashMap<String, String>();

    public String loadArtistImage(String name, String apiKey) {
        if (cache.containsKey(name)) {
            return cache.get(name);
        }
        String url = null;
        try {
            PaginatedResult<Image> imagePage = net.roarsoftware.lastfm.Artist.getImages(name, 1, 1, apiKey);

            for (Image image : imagePage.getPageResults()) {
                url = image.getImageURL(net.roarsoftware.lastfm.ImageSize.ORIGINAL);
            }
            cache.put(name, url);
        }
        catch (Exception e) {
            //System.err.println ("LastfmHelper exception");
            //e.printStackTrace();
        }
        return url;
    }

}
