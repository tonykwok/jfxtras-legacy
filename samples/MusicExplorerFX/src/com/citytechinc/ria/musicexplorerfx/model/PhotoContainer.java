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

import com.aetrion.flickr.FlickrException;
import com.aetrion.flickr.photos.Photo;
import com.aetrion.flickr.photos.PhotosInterface;
import com.aetrion.flickr.tags.Tag;
import java.awt.Image;
import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.Collection;
import javax.swing.ImageIcon;
import org.xml.sax.SAXException;

public class PhotoContainer {
    private String id;
    private Photo photo = null;
    private String query;
    private PhotosInterface photosInterface;
    private ImageIcon imageIcon;

    PhotoContainer(PhotosInterface pi, String id, String query) {
        this.photosInterface = pi;
        this.id = id;
        this.query = query;

    }

    public String getID() {
        return id;
    }

    public Photo getPhoto() {
        if (photo == null) {
            try {
                synchronized (photosInterface) {
                    photo = photosInterface.getPhoto(id);
                // System.out.printf("User: [%s] [%s] [%s]\n", photo.getOwner().getUsername(), photo.getOwner().getRealName(), photo.getLicense());
                }
            } catch (IOException ex) {
                System.err.println("Trouble talking to flickr");
                ex.printStackTrace();
            } catch (SAXException ex) {
                System.err.println("Trouble parsing flickr results");
                ex.printStackTrace();
            } catch (FlickrException ex) {
                System.err.println("Flickr is complaining " + ex);
                ex.printStackTrace();
            } catch (Exception e) {
                System.err.println("flickrj trouble " + e);
                e.printStackTrace();
            }
        }
        return photo;
    }

    public String getImageUrl() {
        // String url = getPhoto().getLargeUrl();
        String url = getPhoto().getMediumUrl();
        if (url == null) {
            url = getPhoto().getMediumUrl();
        }
        return url;
    }

    public String toString() {
        return "pc " +  id;
    }

    public Image getImage() {
        return getImageIcon().getImage();
    }

    public ImageIcon getImageIcon() {
        try {
            if (imageIcon == null) {
                String surl = getImageUrl();
                URL url = new URL(surl);
                imageIcon = new ImageIcon(url);
            }
            return imageIcon;
        } catch (MalformedURLException ex) {
            // bad URL so skip it.
            return new ImageIcon();
        }
    }

    public int getWidth() {
        return getImageIcon().getIconWidth();
    }

    public int getHeight() {
        return getImageIcon().getIconHeight();
    }

    public String getURL() {
        Photo p = getPhoto();
        String url = p.getUrl();
        return url;
    }

    public String getQuery() {
        return query;
    }

    public String resolveQuery() {
        String q = query.replaceAll("[-+]", " ");
        String[] words = q.split(" ");
        Collection tags = getPhoto().getTags();
        StringBuffer sb = new StringBuffer();
        for (int i = 0; i < words.length; i++) {
            if (contains(words[i], tags)) {
                sb.append(words[i]);
                sb.append(" ");
            }
        }
        return sb.toString();
    }

    private boolean contains(String word, Collection set) {
        for (Object o : set) {
            Tag t = (Tag) o;
            String s = t.getValue();
            if (s.equalsIgnoreCase(word)) {
                return true;
            }
        }
        return false;
    }

}
