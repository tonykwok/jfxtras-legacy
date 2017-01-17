/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.vnimedia.learnfx.ui;

import org.lobobrowser.html.test.SimpleHtmlRendererContext;
import org.lobobrowser.html.gui.HtmlPanel;
import edu.stanford.ejalbert.BrowserLauncher;
/**
 *
 * @author jlweaver
 */
public class CustomHtmlRendererContext extends SimpleHtmlRendererContext {
  public CustomHtmlRendererContext(HtmlPanel htmlPanel) {
    super(htmlPanel);
  }

//  public void linkClicked(org.w3c.dom.html2.HTMLElement linkNode, java.net.URL url) {
//    System.out.//println("Link clicked!!!!!!!!!!!!!!!");
//  }

  @Override public boolean onMouseClick(org.w3c.dom.html2.HTMLElement linkNode, java.awt.event.MouseEvent event) {
    //System.out.println("Mouse clicked&&&&&&&&&&&&&&&&&" + linkNode);
    try {
      BrowserLauncher launcher = new BrowserLauncher(); //TODO: Move out
      //launcher.openURLinBrowser(linkNode.toString(), "_blank");
      launcher.openURLinBrowser(linkNode.toString());
    }
    catch (java.lang.Exception e) {
      //System.out.println("Exception:" + e);
    }
    return false;
  }
}
