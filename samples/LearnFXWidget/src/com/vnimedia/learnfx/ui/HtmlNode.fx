/*
 * HtmlNode.fx
 *
 * Created on Oct 2, 2009, 9:02:51 AM
 */

package com.vnimedia.learnfx.ui;

import javafx.ext.swing.SwingComponent;
import javafx.scene.CustomNode;
import javafx.scene.Node;
import org.lobobrowser.html.gui.HtmlPanel;

/**
 * @author jlweaver
 */

public class HtmlNode extends CustomNode {

  var htmlRendererContext:CustomHtmlRendererContext;
  var browser:HtmlPanel = new HtmlPanel();
  var wrappedBrowser = SwingComponent.wrap(browser);

  /**
   *
   */
  public var url:String on replace {
    if (url != "" and url.contains(".htm")) {
      //println("url is now:{url}");
      htmlRendererContext = new CustomHtmlRendererContext(browser);
      htmlRendererContext.navigate(url);
    }
  }

  /**
   *
   */
  public var text:String on replace {
    if (url == "" and text != "") {
      //println("setting text to:{text}");
      htmlRendererContext = new CustomHtmlRendererContext(browser);
      browser.setHtml(renderTweetAsHtml(text), "http://w3c.org", htmlRendererContext);
    }
  }

  /**
   *
   */
  public var width:Number on replace {
    wrappedBrowser.width = width;
  }

  /**
   *
   */
  public var height:Number on replace {
    wrappedBrowser.height = height;
  }

  override function create():Node {

    return wrappedBrowser;

  }

  public function renderTweetAsHtml(tweet:String):String {
    var retStr = "";
    def segs = tweet.split(" ");
    for (seg in segs) {
      var str:String = seg;
      if (str.startsWith("http") and str.contains("://")) {
        str = "<a href='{str}'>{str}</a>";
      }
      retStr = "{retStr} {str}";
    }
    retStr = "<link href='{__DIR__}tweets.css' rel='stylesheet' type='text/css'/><html><body><p class='question'>{retStr}</p></font></body></html>";
    //println("renderTweetAsHtml retStr:{retStr}");
    return retStr;
  }
}
