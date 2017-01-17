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
import java.lang.reflect.Method;

/*
 * @author joshua@marinacci.org
 */
class OSUtil {

    public static boolean isMac() {
        String osName = System.getProperty("os.name");
        if (osName.startsWith("Mac OS")) {
            return true;
        }
        return false;
    }

    private static boolean isJava6() {
//            return true;
        return (System.getProperty("java.version").startsWith("1.6"));
    }

    public static File getJavaWSExecutable() {
        println("java.home = " + System.getProperty("java.home"));
        if(isMac()) {
            File javaws6 = new File("/System/Library/Frameworks/JavaVM.framework/Versions/1.6/Home/bin/javaws");
            if(javaws6.exists()) {
                return javaws6;
            }
            return new File("/System/Library/Frameworks/JavaVM.framework/Versions/1.5/Home/bin/javaws");
        }
        return new File(System.getProperty("java.home"),"bin/javaws");
    }
    public static void launchWebstart(String url) {
        openBrowser(url);
    }

    public static void log(Throwable ex) {
        System.out.println(ex.getMessage());
        ex.printStackTrace(System.out);
    }


    // launching code from http://www.centerkey.com/java/browser/
    public static void openBrowser(String url) {
        String os = System.getProperty("os.name");
        println("os = " + os);
        String osName = System.getProperty("os.name");
        try {
            if (osName.startsWith("Mac OS")) {
                Class<?> fileMgr = Class.forName("com.apple.eio.FileManager");
                Method openURL = fileMgr.getDeclaredMethod("openURL",
                        new Class[]{String.class});
                openURL.invoke(null, new Object[]{url});
            } else if (osName.startsWith("Windows")) {
                Runtime.getRuntime().exec("rundll32 url.dll,FileProtocolHandler " + url);
            } else { //assume Unix or Linux
                String[] browsers = {
                    "firefox", "opera", "konqueror", "epiphany", "mozilla", "netscape"};
                String browser = null;
                for (int count = 0; count < browsers.length && browser == null; count++) {
                    if (Runtime.getRuntime().exec(
                            new String[]{"which", browsers[count]}).waitFor() == 0) {
                        browser = browsers[count];
                    }
                }
                if (browser == null) {
                    throw new Exception("Could not find web browser");
                } else {
                    Runtime.getRuntime().exec(new String[]{browser, url});
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static void println(String string) {
        System.out.println(string);
    }

    public static String getUserSettingsDir() {
        String os = System.getProperty("os.name").toLowerCase();
        StringBuffer filepath = new StringBuffer(System.getProperty("user.home"));
        if (os.indexOf("vista") != -1) {
            filepath.append(File.separator);
            filepath.append("appdata");
            filepath.append(File.separator);
            filepath.append("locallow");
        } else if (os.startsWith("mac")) {
            filepath.append(File.separator);
            filepath.append("Library");
            filepath.append(File.separator);
            filepath.append("Preferences");
        }
        filepath.append(File.separator);
        return filepath.toString();
    }
    
}
