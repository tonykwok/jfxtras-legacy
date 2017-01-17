/*
Copyright (c) 2009, Mark Macumber
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the author (Mark Macumber) nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY Mark Macumber "AS IS" AND ANY
EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL MARK MACUMBER BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

package hudsonremoteaccess;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.URL;
import java.net.URLConnection;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamSource;
import org.dom4j.Document;
import org.dom4j.DocumentHelper;
import org.dom4j.io.DocumentResult;
import org.dom4j.io.DocumentSource;

/**
 * @author Mark Macumber
 */
public class Hudson {

    public Document getXMLHudsonQuery() {
        try {
            String webUrl = "http://deadlock.netbeans.org/hudson/job/FindBugs/api/xml?depth=1&wrapper=builds&xpath=//build&exclude=//build/artifact&exclude=//build/culprit&exclude=//build/changeSet";
            Document xmlDocument = DocumentHelper.parseText(getDataFromUrl(webUrl));
            return applyXsltStylesheet(xmlDocument);
        } catch (Exception ex) {
            System.err.println(ex.getMessage());
        }
        return null;
    }

    private Document applyXsltStylesheet(Document document){
        try {
            // load the transformer using JAXP
            TransformerFactory factory = TransformerFactory.newInstance();

            InputStream is = this.getClass().getResourceAsStream("/hudsonremoteaccess/resources/styleSheet.xsl");
            Transformer transformer = factory.newTransformer(new StreamSource(is));

            // now lets style the given document
            DocumentSource source = new DocumentSource( document );
            DocumentResult result = new DocumentResult();
            transformer.transform( source, result );

            return result.getDocument();
        } catch (TransformerException ex) {
            Logger.getLogger(Hudson.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    private String getDataFromUrl(String webUrl) {
        try {
            URL url = new URL(webUrl);
            URLConnection connection = url.openConnection();
            StringBuilder builder = extractDataFromStream(connection);
            String response = builder.toString();
            return response;
        } catch (Exception e) {
            System.err.println("Something went wrong...");
            e.printStackTrace();
        }
        return null;
    }

    private StringBuilder extractDataFromStream(URLConnection connection) throws IOException {
        String line;
        StringBuilder builder = new StringBuilder();
        InputStream is = connection.getInputStream();
        BufferedReader reader = new BufferedReader(new InputStreamReader(is));
        while ((line = reader.readLine()) != null) {
            builder.append(line);
        }
        return builder;
    }
}
