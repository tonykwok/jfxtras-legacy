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

import java.awt.Graphics2D;
import java.awt.RenderingHints;
import java.awt.image.BufferedImage;

/*
 * @author joshua@marinacci.org
 */
class ScaleUtil {

    static BufferedImage scaleImage(BufferedImage fullImage, int requestedWidth, int requestedHeight, SizingMethod sizing, boolean isThumbnail) {
        p("scaling to " + requestedWidth + " " + requestedHeight);
        p("current size = " + fullImage.getWidth() + " " + fullImage.getHeight());

        if(isThumbnail) {
            return scaleThumb(fullImage, requestedWidth, requestedHeight, sizing);
        }
        BufferedImage scaled = new BufferedImage(requestedWidth, requestedHeight, BufferedImage.TYPE_INT_ARGB);
        Graphics2D g2 = scaled.createGraphics();
        g2.setRenderingHint(RenderingHints.KEY_INTERPOLATION, RenderingHints.VALUE_INTERPOLATION_BICUBIC);

        double widthScale = ((double)requestedWidth) / ((double)fullImage.getWidth());
        double heightScale = ((double)requestedHeight) / ((double)fullImage.getHeight());

        if(sizing == SizingMethod.Stretch) {
            g2.drawImage(fullImage, 0, 0, requestedWidth, requestedHeight, null);
        }

        if(sizing == SizingMethod.Preserve) {
            g2.drawImage(fullImage, 0, 0, null);
        }

        if(sizing == SizingMethod.Crop) {
            double scale = Math.max(widthScale, heightScale);
            int xoff = requestedWidth - (int) (scale * fullImage.getWidth());
            int yoff = requestedHeight - (int) (scale * fullImage.getHeight());
            g2.translate(xoff/2, yoff/2);
            g2.scale(scale,scale);
            g2.drawImage(fullImage,0,0,null);
        }
        if(sizing == SizingMethod.Letterbox) {
            double scale = Math.min(widthScale, heightScale);
            int xoff = requestedWidth - (int) (scale * fullImage.getWidth());
            int yoff = requestedHeight - (int) (scale * fullImage.getHeight());
            g2.translate(xoff/2, yoff/2);
            g2.scale(scale,scale);
            g2.drawImage(fullImage,0,0,null);
        }

        g2.dispose();
        return scaled;
    }
    // real = 50x50 realR = 1/1 requested = 100x75 reqR = 1.333
    // final = 66.66x50
    // fw/fh = rw/rh. if realR < reqR then solve for fw. else, solve for fh
    // realR < reqR
    //   fw = (rw/rh)*fh
    // else
    //   fh = fw/(rw/rh)
    // real = 50x50 realR = 1/1 requested = 100x75 reqR = 1.333
    // final = 50x38
    // fw/fh = rw/rh if realR < reqR then solve for fh, else solve for fw
    // realR < reqR
    //   fw/(rw/rh)=fh
    // else
    //   fw = (rw/rh)*fh

    static BufferedImage scaleThumb(BufferedImage fullImage, int requestedWidth, int requestedHeight, SizingMethod sizing) {
        p("scaling a thumb. different algorithms");
        double realAspectRatio = ((double)fullImage.getWidth())/((double)fullImage.getHeight());
        double requestedAspectRatio = ((double)requestedWidth)/((double)requestedHeight);

        p("real ratio = " + realAspectRatio);
        p("requested ratio = " + requestedAspectRatio);
        int width = fullImage.getWidth();
        int height = fullImage.getHeight();

        if(sizing == SizingMethod.Letterbox) {
            if(realAspectRatio < requestedAspectRatio) {
                width = (int) (requestedAspectRatio * height);
            } else {
                height = (int) (width / requestedAspectRatio);
            }
        }
        if(sizing == SizingMethod.Crop) {
            if(realAspectRatio > requestedAspectRatio) {
                width = (int) (requestedAspectRatio * height);
            } else {
                height = (int) (width / requestedAspectRatio);
            }
        }
        if(sizing == SizingMethod.Stretch) {
            //do nothing, basically
        }

        // Preserve is broken for thumbnails. I'm not sure if it's possible to implement since you don't know the true size of the final image
        if(sizing == SizingMethod.Preserve) {
            //do nothing, basically
        }
        int xoff = (width-fullImage.getWidth())/2;
        int yoff = (height-fullImage.getHeight())/2;
        p("final calced size = " + width + " " + height);
        p("offsets = " + xoff + " " + yoff);
        BufferedImage scaled = new BufferedImage(width, height, BufferedImage.TYPE_INT_ARGB);
        Graphics2D g2 = scaled.createGraphics();
        g2.setRenderingHint(RenderingHints.KEY_INTERPOLATION, RenderingHints.VALUE_INTERPOLATION_BICUBIC);
        //g2.setColor(Color.MAGENTA);
        //g2.fillRect(0, 0, width, height);
        g2.drawImage(fullImage,xoff,yoff,null);
        g2.dispose();
        return scaled;
    }


    private static void p(String string) {
        //System.out.println(string);
    }
}
