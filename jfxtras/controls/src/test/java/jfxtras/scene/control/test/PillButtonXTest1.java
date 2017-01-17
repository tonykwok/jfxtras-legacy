package jfxtras.scene.control.test;

import javafx.beans.value.ChangeListener;
import javafx.beans.value.ObservableValue;
import javafx.geometry.Pos;
import javafx.scene.control.Toggle;
import javafx.scene.control.ToggleGroup;
import javafx.scene.layout.VBox;
import jfxtras.application.ExtendedApplicationX;
import jfxtras.scene.control.PillButtonX;
import jfxtras.scene.control.PillButtonXContainer;

/**
 *
 * @author Goran Lochert
 */
public class PillButtonXTest1 extends ExtendedApplicationX {

    private PillButtonXContainer pillButtonContainerColumn;
    private PillButtonXContainer pillButtonContainerRow;
    private PillButtonXContainer pillButtonContainerGrid;
    private VBox box;

    public static void main(String[] args) {
        launchWithPrelaunch(PillButtonXTest1.class, args);
    }

    @Override
    protected void setup() {

        createContainerRow();
        createContainerColumn();
        createContainerGrid();


        box = new VBox(30);
        box.setAlignment(Pos.CENTER);
        box.getChildren().addAll(pillButtonContainerColumn, pillButtonContainerRow, pillButtonContainerGrid);
        root.getChildren().addAll(box);

    }

    private void createContainerColumn() {
        pillButtonContainerColumn = new PillButtonXContainer();
        pillButtonContainerColumn.setContainerLayout(PillButtonXContainer.ContainerLayout.COLUMN);

        ToggleGroup group = new ToggleGroup();


        PillButtonX pb1 = new PillButtonX();        
        pb1.setText("TOP");
        pb1.setId("pb1");
        pb1.setPrefSize(80, 40);
        pb1.setToggleGroup(group);


        PillButtonX pb2 = new PillButtonX();        
        pb2.setText("CENTER");
        pb2.setId("pb2");
        pb2.setToggleGroup(group);


        PillButtonX pb3 = new PillButtonX();
        pb3.setText("BOTTOM");
        pb3.setId("pb3");
        pb3.setToggleGroup(group);

        group.selectedToggleProperty().addListener(new SelectedChangeListener());

        pillButtonContainerColumn.getItems().addAll(pb1, pb2, pb3);
    }

    private void createContainerRow() {
        pillButtonContainerRow = new PillButtonXContainer();

        ToggleGroup group = new ToggleGroup();


        PillButtonX pb1 = new PillButtonX();
        pb1.setText("LEFT");
        pb1.setId("pb1");
        pb1.setToggleGroup(group);

        PillButtonX pb2 = new PillButtonX();
        pb2.setText("CENTER");
        pb2.setId("pb2");
        pb2.setToggleGroup(group);

        PillButtonX pb3 = new PillButtonX();
        pb3.setText("BOTTOM");
        pb3.setId("pb3");
        pb3.setToggleGroup(group);

        pillButtonContainerRow.getItems().addAll(pb1, pb2, pb3);
    }

    private void createContainerGrid() {
        pillButtonContainerGrid = new PillButtonXContainer();
        pillButtonContainerGrid.setContainerLayout(PillButtonXContainer.ContainerLayout.GRID);
        pillButtonContainerGrid.setColumnCount(3);
        pillButtonContainerGrid.setRowCount(3);
        ToggleGroup group = new ToggleGroup();

        PillButtonX pb1 = new PillButtonX();
        pb1.setText("TOP-LEFT");
        pb1.setId("pb1");
        pb1.setToggleGroup(group);

        PillButtonX pb2 = new PillButtonX();
        pb2.setText("CENTER");
        pb2.setId("pb2");
        pb2.setToggleGroup(group);

        PillButtonX pb3 = new PillButtonX();
        pb3.setText("TOP-RIGHT");
        pb3.setId("pb3");
        pb3.setToggleGroup(group);

        PillButtonX pb4 = new PillButtonX();
        pb4.setText("CENTER");
        pb4.setId("pb4");
        pb4.setToggleGroup(group);

        PillButtonX pb5 = new PillButtonX();
        pb5.setText("CENTER");
        pb5.setId("pb5");
        pb5.setToggleGroup(group);

        PillButtonX pb6 = new PillButtonX();
        pb6.setText("CENTER");
        pb6.setId("pb6");
        pb6.setToggleGroup(group);

        PillButtonX pb7 = new PillButtonX();
        pb7.setText("BOTTOM-LEFT");
        pb7.setId("pb7");
        pb7.setToggleGroup(group);

        PillButtonX pb8 = new PillButtonX();
        pb8.setText("CENTER");
        pb8.setId("pb8");
        pb8.setToggleGroup(group);

        final PillButtonX pb9 = new PillButtonX();
        pb9.setText("BOTTOM-RIGHT");
        pb9.setId("pb9");
        pb9.setToggleGroup(group);


        group.selectedToggleProperty().addListener(new SelectedChangeListener());

        pillButtonContainerGrid.getItems().addAll(pb1, pb2, pb3, pb4, pb5, pb6, pb7, pb8, pb9);
    }

    protected class SelectedChangeListener implements ChangeListener<Toggle> {

        @Override
        public void changed(ObservableValue<? extends Toggle> ov, Toggle oldValue, Toggle newValue) {
            PillButtonX selected = (PillButtonX) newValue;
            if (selected != null) {
                System.out.println("selected: " + selected.getText());
            }
        }
    }
}
