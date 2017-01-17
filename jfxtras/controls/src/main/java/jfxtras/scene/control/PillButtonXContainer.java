package jfxtras.scene.control;

import com.sun.javafx.css.StyleManager;
import java.util.List;
import javafx.geometry.HPos;
import javafx.geometry.VPos;
import javafx.scene.Node;

/**
 *
 * @author Goran Lochert
 * Just for PIllButtons, no spacing no gaps for now
 */
public class PillButtonXContainer extends MultiLayoutContainer {

    // ===============================================
    // CONSTRUCTORS
    // ===============================================
    public PillButtonXContainer() {
        super();
        getStyleClass().setAll("pill-buttonx-container");
    }

    // ================================================
    // PROTECTED/PRIVATE METHODS
    // ================================================
    private void setButtonPositions(PillButtonX button, int column, int row, int cc, int rc) {

        button.setButtonPosition(PillButtonX.ButtonPosition.CENTER);
        if (cc == 1) { // COLUMN
            if (row == 1) {
                button.setButtonPosition(PillButtonX.ButtonPosition.TOP);
            }
            if (row == rc) {
                button.setButtonPosition(PillButtonX.ButtonPosition.BOTTOM);
            }

        } else if (rc == 1) { // ROW
            if (column == 1) {
                button.setButtonPosition(PillButtonX.ButtonPosition.LEFT);
            }
            if (column == cc) {
                button.setButtonPosition(PillButtonX.ButtonPosition.RIGHT);
            }
        } else { // GRID/TABLE
            if ((column == 1) && (row == 1)) {
                button.setButtonPosition(PillButtonX.ButtonPosition.TOP_LEFT);
            }
            if ((column == cc) && (row == 1)) {
                button.setButtonPosition(PillButtonX.ButtonPosition.TOP_RIGHT);
            }
            if ((column == 1) && (row == rc)) {
                button.setButtonPosition(PillButtonX.ButtonPosition.BOTTOM_LEFT);
            }
            if ((column == cc) && (row == rc)) {
                button.setButtonPosition(PillButtonX.ButtonPosition.BOTTOM_RIGHT);
            }
        }
    }

    // ================================================
    // OVERRIDES
    // ================================================
    @Override
    protected void layoutChildren() {
        double top = getInsets().getTop();
        double left = getInsets().getLeft();
        double xOff = left;
        double yOff = top;
        double buttonWidth = getMaxItemWidth();
        double buttonHeight = getMaxItemHeight();

        List nodeList = getManagedChildren();
        int row = 1;
        int column = 1;
        int cc = getColumnCount();
        int rc = getRowCount();

        for (int i = 0; i < nodeList.size(); i++) {
            Node node = (Node) nodeList.get(i);
            node.resize(buttonWidth, buttonHeight);

            positionInArea(node, xOff, yOff, buttonWidth, buttonHeight, 0.0, HPos.CENTER, VPos.CENTER);
            xOff += buttonWidth;

            setButtonPositions((PillButtonX) node, column, row, cc, rc);

            column++;
            if (column == (cc + 1)) {
                column = 1;
                xOff = left;
                yOff += buttonHeight;
                row++;
            }
        }
    }

    @Override
    protected void validate() {
        if (getContainerLayout() == ContainerLayout.ROW) {
            setRowCount(1);
            setColumnCount(getItems().size());
        } else if (getContainerLayout() == ContainerLayout.COLUMN) {
            setRowCount(getItems().size());
            setColumnCount(1);
        } else { // GRID
            int cc = getColumnCount();
            int rc = getRowCount();
            int size = getItems().size();

            if ((cc == 0) || (rc == 0)) {
//                System.err.println("ColumnCount or rowCount is 0");
                return;
            }
            if ((size % cc != 0)) {
                System.err.println("ColumnCount % size != 0");
                return;
            }
            if ((size % rc != 0)) {
                System.err.println("RowCount % size != 0");
                return;
            }
        }

        requestLayout();
    }

    static {
        StyleManager.getInstance().addUserAgentStylesheet(PillButtonXContainer.class.getResource(PillButtonXContainer.class.getSimpleName() + ".css").toString());
    }
}
