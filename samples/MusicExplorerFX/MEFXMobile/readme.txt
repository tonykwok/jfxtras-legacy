Application Name: Music Explorer FX Mobile Edition (MEFX Mobile)

Author Contact: Sten Anderson (sanderson at citytechinc dot com)

License:

The source code for MEFX Mobile is open sourced under a BSD-style license, which should be included in the same directory as this file. All images and logos remain copyrighted under their respective creator/owners.

Description:

MEFX Mobile is a companion application to the desktop version of Music Explorer FX designed to run on JavaFX enabled mobile devices. It supports a small subset of features of the larger desktop version.

Building the Application from the Source Code:

The Netbeans project has been included with the source code, so hopefully building the app is as simple as opening the project in Netbeans.

In order to run the application from the built source, two developer API keys are required for the following web services (all require free registration):

* The Echo Nest
* Last.fm

Enter the keys as the values of their associated key in src/api_keys.properties. The application will not launch without these keys present.

Website: http://www.musicexplorerfx.com/

Web start link (to show the app running outside of the emulator or phone): http://ria.citytechinc.com/javafx/MEFXMobile/MEFXMobile.jnlp


JavaFX Version: JavaFX 1.2

Permissions Requested

If run as a web start application MEFX Mobile requires "full access" from the Security Manager since it makes several web services calls (Echo Nest, Last.fm).




