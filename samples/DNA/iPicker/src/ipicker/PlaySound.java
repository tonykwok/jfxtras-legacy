/*
 * Copyright (c) 2008-2009, David Armitage
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 * 1. Redistributions of source code must retain the above copyright notice,
 *    this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 * 3. The names of its contributors may not be used
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

package ipicker;

import java.io.*;
import java.net.URL;
import javax.sound.sampled.*;

/**
 * This enum encapsulates all the sound effects of a game, so as to separate the sound playing
 * codes from the game codes.
 * 1. Define all your sound effect names and the associated wave file.
 * 2. To play a specific sound, simply invoke SoundEffect.SOUND_NAME.play().
 * 3. You might optionally invoke the static method SoundEffect.init() to pre-load all the
 *    sound files, so that the play is not paused while loading the file for the first time.
 * 4. You can use the static variable SoundEffect.volume to mute the sound.
 */
public enum PlaySound {
   PIP("ipicker/pip2.wav");

// Nested class for specifying volume
   public static enum Volume {
     MUTE, LOW, MEDIUM, HIGH
     }

   public static Volume volume = Volume.MEDIUM;

// Each sound effect has its own clip, loaded with its own sound file.
   private Clip clip;

// Constructor to construct each element of the enum with its own sound file.
   PlaySound(String soundFileName) {
     try {
       // Use URL (instead of File) to read from disk and JAR.
       URL url = this.getClass().getClassLoader().getResource(soundFileName);
       // Set up an audio input stream piped from the sound file.
       AudioInputStream audioInputStream = AudioSystem.getAudioInputStream(url);
       // Get a clip resource.
       clip = AudioSystem.getClip();
       // Open audio clip and load samples from the audio input stream.
       clip.open(audioInputStream);
       }
     catch (UnsupportedAudioFileException e) {
       e.printStackTrace();
       }
     catch (IOException e) {
       e.printStackTrace();
       }
     catch (LineUnavailableException e) {
       e.printStackTrace();
       }
     }

   // Play or Re-play the sound effect from the beginning, by rewinding.
   public void play() {
     if (volume != Volume.MUTE) {
       if (clip.isRunning()) clip.stop();   // Stop the player if it is still running
       clip.setFramePosition(0); // rewind to the beginning
       clip.start();     // Start playing
       }
     }

   // Optional static method to pre-load all the sound files.
   public static void init() {
     values(); // calls the constructor for all the elements
     }
  }
