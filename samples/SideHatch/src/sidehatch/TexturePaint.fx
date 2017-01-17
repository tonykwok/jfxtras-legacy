package sidehatch;

import java.awt.image.BufferedImage;

import javafx.scene.paint.Paint;
import javax.imageio.ImageIO;

import java.net.URL;


public class TexturePaint extends Paint {
    var tex:BufferedImage;
    public-init var gridSpacing = 20.0;
    public-init var gridLineWidth = 1.0;
    init {
        tex = ImageIO.read(new URL("{__DIR__}stripe.png"));
    }

    public override function impl_getPlatformPaint () {
        var anchor = new java.awt.geom.Rectangle2D.Double(0,0,gridSpacing,gridSpacing);
        return new java.awt.TexturePaint(tex,anchor);
    }
}
