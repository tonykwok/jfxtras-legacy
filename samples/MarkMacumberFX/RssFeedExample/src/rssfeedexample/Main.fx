package rssfeedexample;

import javafx.scene.Scene;
import javafx.data.feed.rss.RssTask;
import javafx.data.feed.rss.Item;
import javafx.stage.Stage;
import java.lang.Exception;
import javafx.scene.Group;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;
import javafx.scene.shape.Rectangle;
import javafx.scene.paint.Color;
import javafx.scene.CustomNode;
import javafx.scene.Node;
import javafx.scene.text.Font;
import javafx.scene.text.Text;
import javafx.scene.control.ScrollBar;
import javafx.scene.control.Hyperlink;
import javafx.stage.Alert;

/**
 * @author Mark Macumber
 */

var theRssItems:RssRectangleItem[] = [];

var rssTask = RssTask {
    interval: 30s
    location: "http://feeds.feedburner.com/javaposse"
    onStart: function() {
        println("loading RSS feed...");
    }
    onItem: function(rssItem:Item) {
        insert RssRectangleItem{title: rssItem.title; linkAddress: rssItem.link} into theRssItems;
    }
    onException:function(e:Exception){
        println("There was an error: {e.getMessage()}");
    }
    onDone: function(){ println("done reading RSS"); scrollBar.disable = false; }
};
rssTask.start();

var scrollBar : ScrollBar = ScrollBar {
    translateX: bind (435 - scrollBar.width)
    translateY: 0
    vertical: true
    height: 415
    blockIncrement: 415
    unitIncrement: 30
    min: 0
    max: 415
    focusTraversable: false
    blocksMouse: true
    disable: true
};

class RssRectangleItem extends CustomNode{
    public var title:String;
    public var linkAddress:String;
    var cont:Rectangle;
    var i = sizeof theRssItems;
    override function create():Node {
        cont = Rectangle {
            width: 250
            height: 60
            stroke: Color.BLACK
            fill: Color.WHITE
            arcHeight: 12
            arcWidth: 12
            x: 55
            y: bind (i * 65) - (scrollBar.value);
        };

        var img = ImageView {
            x: bind cont.x + 5
            y: bind cont.y + 15
            image:
                Image {
                    url:"{__DIR__}feedIcon.png"
                }
        };

        var titleText = Text {
            font : Font { size: 10 }
            x: bind img.x + 45,
            y: bind img.y
            content: bind title
            wrappingWidth: 200
        };

        var link = Hyperlink{
            text: "[link...]";
            layoutX: bind titleText.x;
            layoutY: bind titleText.y + 20;
            action: function():Void{
                Alert.inform("Link Alert", "take me to the link...{linkAddress}");
            }
        };

        Group {
            content: [cont, img, titleText, link]
        }
    }
}

Stage {
    title: "JavaFX RSS Example"
    width: 450
    height: 450
    scene: Scene {
        content: bind [ theRssItems,scrollBar ]
    }
}