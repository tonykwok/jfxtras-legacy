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
package org.jfxtras.scene.control;

import javafx.scene.control.Control;
import org.jfxtras.scene.layout.XLayoutInfo;
import org.jfxtras.scene.layout.XLayoutInfo.*;

import javafx.util.Math;

import javafx.scene.media.MediaPlayer;

import javafx.scene.media.Media;

/**
 * This is a magical number to get the wheel clicks to playback with minimal
 * clipping while not running out of system resources.
 */
def PLAYER_COUNT = 16;

/**
 * This is a game-show-like XSpinnerWheel wheel in full 3d.  It is a vertical wheel
 * drawn from a forward-facing position, similar to the Price-is-Right.
 *
 * Todo:
 * - expose colors and fonts
 * - allow nodes on the wheel faces
 * -
 *
 * @author Stephen Chin
 */
public class XSpinnerWheel extends Control {
    var spinnerSkin = skin as XSpinnerWheelSkin;
    /**
     * The entries that will be written on the faces of the wheel.
     */
    public var entries:String[];
    public var wheelSound = "http://jfxtras.org/sounds/beep.wav";
    public var soundEnabled = true;
    public var maxVisible = 0;
    var players = for (i in [1..PLAYER_COUNT]) MediaPlayer {
        media: Media {
//TODO 1.3            source: bind wheelSound
            source: wheelSound
        }
    }
    var lastPlayer = 0;
    public var centered:Number = 0 on replace oldCentered=newCentered {
        if (soundEnabled and Math.floor(oldCentered) != Math.floor(newCentered)) {
            lastPlayer = if (lastPlayer + 1 == sizeof players) 0 else lastPlayer + 1;
            players[lastPlayer].stop();
            players[lastPlayer].currentTime = 0s;
            players[lastPlayer].play();
        }
    }
    override var skin = XSpinnerWheelSkin {}
    override function getPrefWidth(height) {300}
    override function getPrefHeight(width) {300}
    override function getMaxWidth() {10000}
    override function getMaxHeight() {10000}
    override function getHFill() {true}
    override function getVFill() {true}
    override function getHGrow() {ALWAYS}
    override function getVGrow() {ALWAYS}
    override function getHShrink() {SOMETIMES}
    override function getVShrink() {SOMETIMES}
}
