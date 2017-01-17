package jfxtras.scene.control.fxform;

import javafx.beans.property.*;
import javafx.beans.value.ChangeListener;
import javafx.beans.value.ObservableValue;
import javafx.scene.Node;
import javafx.scene.control.CheckBox;
import javafx.scene.control.ChoiceBox;
import javafx.scene.control.TextArea;
import javafx.scene.layout.VBox;
import jfxtras.application.ExtendedApplicationX;
import jfxtras.scene.control.fxform.annotation.FormFactory;
import jfxtras.scene.control.fxform.filter.ReorderFilter;
import jfxtras.scene.control.fxform.model.PropertyElementController;
import jfxtras.scene.control.fxform.view.FXFormSkinFactory;
import jfxtras.scene.control.fxform.view.NodeCreationException;
import jfxtras.scene.control.fxform.view.factory.NodeFactory;
import org.hibernate.validator.constraints.Email;
import org.junit.Ignore;

/**
 * A demo for the FXFormX component<br>
 * <br>
 * Created at 30/09/11 16:32.<br>
 *
 * @author Antoine Mischler <antoine@dooapp.com>
 * @since 2.2
 */
@Ignore
public class FXFormXDemo extends ExtendedApplicationX {

    /**
     * The bean to be edited.
     */
    private static class MyBean {

        private static enum Subject {
            CONTACT, QUESTION, BUG, FEEDBACK
        }

        private final StringProperty name = new SimpleStringProperty();

        private final StringProperty email = new SimpleStringProperty();

        @FormFactory(TextAreaFactory.class)
        private final StringProperty message = new SimpleStringProperty();

        private final StringProperty website = new SimpleStringProperty();

        private final BooleanProperty subscribe = new SimpleBooleanProperty();

        private final ObjectProperty<Subject> subject = new SimpleObjectProperty<Subject>();

        private MyBean(String name, String email, String message, String website, boolean subscribe, Subject subject) {
            this.name.set(name);
            this.email.set(email);
            this.message.set(message);
            this.website.set(website);
            this.subscribe.set(subscribe);
            this.subject.set(subject);
        }

        @Email
        public String getEmail() {
            return email.get();
        }
    }

    /**
     * Example of custom factory
     */
    public static class TextAreaFactory implements NodeFactory<PropertyElementController<String>> {

        @Override
        public Node createNode(PropertyElementController<String> controller) throws NodeCreationException {
            TextArea textArea = new TextArea();
            return textArea;
        }
    }

    private FXFormX<MyBean> fxFormX = new FXFormX<MyBean>();

    private final String css = FXFormXDemo.class.getResource("style.css").toExternalForm();

    @Override
    protected String getAppTitle() {
        return "FXFormX demo";
    }

    @Override
    protected void setup() {
        fxFormX.setSource(new MyBean("Joe", "contact@", "How does this crazy form works?", "www.dooapp.com", true, MyBean.Subject.QUESTION));
        fxFormX.addFilters(new ReorderFilter("name", "email", "website", "subject", "message"));
        fxFormX.setTitle("Dude, where is my form?");
        root.getChildren().add(createNode());
    }

    private Node createNode() {
        VBox vBox = new VBox();
        vBox.getChildren().addAll(createSkinSelector(), createCSSNode(), fxFormX);
        return vBox;
    }

    private Node createCSSNode() {
        CheckBox checkBox = new CheckBox("Use css");
        checkBox.selectedProperty().addListener(new ChangeListener<Boolean>() {
            @Override
            public void changed(ObservableValue<? extends Boolean> observableValue, Boolean aBoolean, Boolean aBoolean1) {
                if (aBoolean1) {
                    root.getScene().getStylesheets().add(css);
                } else {
                    root.getScene().getStylesheets().remove(css);
                }
            }
        });
        checkBox.setSelected(true);
        return checkBox;
    }

    /**
     * Create a selector that changes the skin of the form.
     *
     * @return
     */
    private Node createSkinSelector() {
        ChoiceBox<FXFormSkinFactory> choiceBox = new ChoiceBox<FXFormSkinFactory>();
        choiceBox.getItems().addAll(FXFormSkinFactory.DEFAULT_FACTORY, FXFormSkinFactory.INLINE_FACTORY);
        choiceBox.getSelectionModel().selectedItemProperty().addListener(new ChangeListener<FXFormSkinFactory>() {
            @Override
            public void changed(ObservableValue<? extends FXFormSkinFactory> observableValue, FXFormSkinFactory fxFormSkinFactory, FXFormSkinFactory fxFormSkinFactory1) {
                fxFormX.setSkin(fxFormSkinFactory1.createSkin(fxFormX));
            }
        });
        choiceBox.getSelectionModel().selectFirst();
        return choiceBox;
    }

    public static void main(String[] args) {
        launchWithPrelaunch(FXFormXDemo.class, args);
    }
}