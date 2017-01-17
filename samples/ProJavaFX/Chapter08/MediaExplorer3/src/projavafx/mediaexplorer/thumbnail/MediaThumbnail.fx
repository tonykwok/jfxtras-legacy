/*
 * Copyright (c) 2009, Pro JavaFX Authors
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
 *
 * MediaThumbnail.fx - A JavaFX Script example program that
 * demonstrates how to build a rich Media Explorer application
 * that leverages layouts and utilities from the JFXtras project.
 *
 * Developed 2009 by Stephen Chin steve [at] widgetfx.org
 * as a JavaFX Script SDK 1.2 example for the Pro JavaFX book.
 */
package projavafx.mediaexplorer.thumbnail;

import javafx.scene.media.Media;
import javafx.scene.media.MediaPlayer;
import org.jfxtras.scene.image.ImageUtil;
import org.jfxtras.scene.layout.GridLayoutInfo;
import org.jfxtras.scene.media.ResizableMediaView;
import projavafx.mediaexplorer.view.MediaFileView;

/**
 * @author Stephen Chin
 */
public class MediaThumbnail extends Thumbnail {

    var mediaPlayer: MediaPlayer;

    override function stop() {
        mediaPlayer.stop();
    }

    var viewerOpen = false;

    init {
        mediaPlayer = MediaPlayer {
            mute: bind not (hover or viewerOpen)
            media: Media {
                source: ImageUtil.getURL(mediaFile)
            }
        }
        FX.deferAction(function():Void {
            mediaPlayer.play();
        });
        progress = 100;
    }

    override function create() {
        ResizableMediaView {
            mediaPlayer: bind mediaPlayer
        }
    }

    override var onMouseClicked = function(e) {
        viewerOpen = true;
        mediaViewer.showView(
            MediaFileView {
                file: mediaFile
                fromNode: this
                player: mediaPlayer
                onClose: function() {viewerOpen = false}
            }
        );
    }

    override var defaultLayoutInfo = bind GridLayoutInfo {
        width: 250
        height: if (mediaPlayer.media.width == 0) 0
                else 250 * mediaPlayer.media.height / mediaPlayer.media.width
    }
}