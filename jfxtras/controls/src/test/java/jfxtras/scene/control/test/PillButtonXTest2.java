package jfxtras.scene.control.test;

import javafx.beans.value.ChangeListener;
import javafx.beans.value.ObservableValue;
import javafx.scene.control.Toggle;
import javafx.scene.control.ToggleGroup;
import jfxtras.application.ExtendedApplicationX;
import jfxtras.scene.control.PillButtonX;
import jfxtras.scene.control.PillButtonXContainer;

/**
 *
 * @author Goran Lochert
 */
public class PillButtonXTest2 extends ExtendedApplicationX {

    private PillButtonXContainer pbc;
    private ToggleGroup group;

    public static void main(String[] args) {
        launchWithPrelaunch(PillButtonXTest2.class, args);
    }

    @Override
    protected void setup() {
        createContainerColumn();
        root.getChildren().addAll(pbc);
    }

    private void createContainerColumn() {
        pbc = new PillButtonXContainer();
        pbc.setContainerLayout(PillButtonXContainer.ContainerLayout.COLUMN);

        group = new ToggleGroup();


        PillButtonX pb1 = new PillButtonX();
        pb1.setText("I WANT ROW");
        pb1.setId("pb1");
        pb1.setPrefSize(80, 40);
        pb1.setToggleGroup(group);


        PillButtonX pb2 = new PillButtonX();
        pb2.setText("I WANT COLUMN");
        pb2.setId("pb2");
        pb2.setToggleGroup(group);


        PillButtonX pb3 = new PillButtonX();
        pb3.setText("ADD NEW BUTTON");
        pb3.setId("pb3");
        pb3.setToggleGroup(group);

        PillButtonX pb4 = new PillButtonX();
        pb4.setText("I WANT GRID");
        pb4.setId("pb4");
        pb4.setToggleGroup(group);

        group.selectedToggleProperty().addListener(new SelectedChangeListener());

        pbc.getItems().addAll(pb1, pb2, pb3, pb4);
    }

    @Override
    protected double getAppWidth() {
        return 800;
    }

    
    protected class SelectedChangeListener implements ChangeListener<Toggle> {

        @Override
        public void changed(ObservableValue<? extends Toggle> ov, Toggle oldValue, Toggle newValue) {
            PillButtonX selected = (PillButtonX) newValue;
            if (selected != null) {

                System.out.println("selected: " + selected.getId());
                String id = selected.getId();
                if(id == null) {
                    return;
                }
                if (id.equals("pb1")) {
                    pbc.setContainerLayout(PillButtonXContainer.ContainerLayout.ROW);
                } else if (id.equals("pb2")) {
                    pbc.setContainerLayout(PillButtonXContainer.ContainerLayout.COLUMN);
                } else if (id.equals("pb3")) {
                    PillButtonX pbx = new PillButtonX("Added");
                    pbx.setToggleGroup(group);
                    pbc.getItems().add(pbx);
                } else if (id.equals("pb4")) {
                    int size = pbc.getItems().size();
                    if (size % 3 == 0) {
                        pbc.setColumnCount(3);
                        pbc.setRowCount(size / 3);
                        pbc.setContainerLayout(PillButtonXContainer.ContainerLayout.GRID);
                    }
                }
            }
        }
    }
}
