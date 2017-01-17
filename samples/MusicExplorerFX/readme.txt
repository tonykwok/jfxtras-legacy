Application Name: Music Explorer FX

Author Contact: Sten Anderson (sanderson at citytechinc dot com)

License:

The source code for Music ExplorerFX is open sourced under a BSD-style license, which should be included in the same directory as this file. All images and logos remain copyrighted under their respective creator/owners.

Description:

Music Explorer FX is a visual tool for discovering new music. Start with your favorite artist and take a musical journey based on recommendations provided by the Echo Nest. Up to six recommendations will be given for each artist so no two journeys will be the same. As you take your journey you can listen to music from the artist, view images of the artist, and follow links to view videos, reviews, news, and blogs. At any point you can automatically tweet your journey if you discover a path that you particularly enjoy. 

Building the Application from the Source Code:

The Netbeans project has been included with the source code, so hopefully building the app is as simple as opening the project in Netbeans.

In order to run the application from the built source, three developer API keys are required for the following web services (all require free registration):

* The Echo Nest
* Flickr
* Last.fm

Enter the keys as the values of their associated key in src/api_keys.properties. The application will not launch without these keys present.

Website: http://www.musicexplorerfx.com/

Web start link: http://ria.citytechinc.com/javafx/MusicExplorerFX/v1_0/MusicExplorerFX.jnlp

The application can also be run as a draggable applet.

Version Number: 1.0

Java Version: Java 5.0+

The application requires 128MB to run: <j2se version="1.5+" max-heap-size="128m"/>

JavaFX Version: JavaFX 1.2

Permissions Requested

Music Explorer FX is a signed application since it requires "full access" from the Security Manager for the following reasons:
* It makes several web services calls (Echo Nest, Last.fm, Flickr, Twitter).
* It launches the user's default browser to view URLs
* It creates a directory in the user's home directory to write a cache file ("user.home"/.MusicExplorerFX/cache.dat) for the Echo Nest data (this code is part of the Echo Nest Java API).


Supported Platforms/Minimum Requirements

The application was developed on a Thinkpad T61p running Windows XP SP3 with the NetBeans 6.5 IDE and JavaFX 1.1 SDK, JDK 1.6.0_13-b03 and later updated to JavaFX 1.2.

The primary supported platform is Windows XP SP3, JRE 1.5+. It has also been tested on Macbook Pros (both 15" and 17") and newer iMacs running OS 10.5 and informally tested on various Ubuntu systems.

There are known issues running on Macbooks or older iMacs, and so these platforms are not supported at this time (but give it a shot...you never know...).

The application requires 128MB of RAM to run. It's minimum supported resolution is 1300x900 (which barely accommodates 15" Macbook Pros). Recommended resolution is 1300x1000 or greater.

Full Screen mode is not supported across multiple monitors.


3rd Party APIs

Music Explorer FX uses the following 3rd parties libraries, all of which are under Open Source licenses:

* The Echo Nest API Java bindings which provide the bulk of the web service calls: http://code.google.com/p/echo-nest-java-api/
* The Last.fm API Java bindings which is used to retrieve the artist profile images: http://www.last.fm/api
* The Flickr API Java bindings which is used to retrieve images for the "image gallery" portion of the application: http://www.flickr.com/services/api/
* The a portion of the Flickr code from Project Aura to translate social tags into a compatible image search. http://kenai.com/projects/aura
* Twitter4j (a set of Java bindings for the Twitter API) is used to tweet the user's music journey.
* The "Bare Bones Browser Launch for Java" (one source file) is used to open URLs in a browser in various parts of the application: http://www.centerkey.com/java/browser/



Getting Started/How to Use the Application

After the application finishes starting up, you'll be presented with a search box. Enter the name of a musical artist in the search box and press the search button (or press the "Enter" key). Entering the name of an artist that you are already familiar with is a good start. You'll be presented with a list of artists matching your search. Click on the artist that most closely matches your intention and you'll be brought to the explorer screen.

In the explorer screen, the currently selected artist (the artist in the middle of the screen) is surrounded by up to six artists that sound similar to the current artist. You can click on any of these recommendations to promote that artist to the middle and in turn, generate recommendations for the newly selected artist. The old artist travels to the top of the screen and becomes part of the history. This process of selecting new artists while remembering the path it took to get there is your musical journey. At any point you can click on an artist in the history to make them the current artist again.

A row of buttons will appear below the current artist. 

The search button will return you to the initial search screen. 

The "info" button will display aggregated information about the current artist from around the internet, including reviews, videos, artist links (such as iTunes, Amazon, etc.), news, and blogs. Clicking on any item in any of these sections will open the link in a browser window.

The "image gallery" button will attempt to find photos of the artist from Flickr and display them two at a time.

The question mark icon ("?") will display a help section summarizing the information in this document.

If the application is in either "info" or "image gallery" mode, it will display the "find similar" button, which will return the application to "similar" mode with the six artist recommendations.

The green gauge on the artist boxes is a "familiarity" rating, which is a measure of how well-known an artist is in the wider world. The yellow gauge is a measure of "hotness", which is a sort of popularity metric.

If any music is found for the current artist, audio controls will appear below the artist image. Use the buttons to control playback or scroll through available tracks. The "auto play" button (the "robot" icon) is a toggle which will, if enabled, automatically play music as it is found. If you are experiencing performance issues, it is a good idea to disable auto play. Auto play is disabled by default.

The icon in the lower right will put the application in full screen mode. Once in full screen mode you can click the button again to re-enter windowed mode. 

If you have a Twitter account, you can press the "Twitter" button (the "singing bird" icon) and tweet your musical journey. 
