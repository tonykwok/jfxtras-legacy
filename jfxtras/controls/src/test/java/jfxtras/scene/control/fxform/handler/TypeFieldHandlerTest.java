package jfxtras.scene.control.fxform.handler;

import javafx.beans.property.StringProperty;
import jfxtras.scene.control.fxform.TestUtils;
import jfxtras.scene.control.fxform.view.handler.FieldHandler;
import jfxtras.scene.control.fxform.view.handler.TypeFieldHandler;
import org.junit.Assert;
import org.junit.Test;

import java.lang.reflect.Field;
import java.util.List;

/**
 * User: Antoine Mischler <antoine@dooapp.com>
 * Date: 12/09/11
 * Time: 17:14
 */
public class TypeFieldHandlerTest {
    @Test
    public void testHandle() throws Exception {
        List<Field> fields = TestUtils.getTestFields();
        FieldHandler handler = new TypeFieldHandler(StringProperty.class);
        Assert.assertTrue(handler.handle(fields.get(0)));
        Assert.assertFalse(handler.handle(fields.get(1)));
        Assert.assertFalse(handler.handle(fields.get(2)));
        Assert.assertFalse(handler.handle(fields.get(3)));
        Assert.assertFalse(handler.handle(fields.get(4)));
    }
}
