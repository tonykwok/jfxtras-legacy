package jfxtras.scene.control;

import java.util.List;
import javafx.beans.InvalidationListener;
import javafx.beans.Observable;
import javafx.beans.property.DoubleProperty;
import javafx.beans.property.IntegerProperty;
import javafx.beans.property.ObjectProperty;
import javafx.beans.property.SimpleDoubleProperty;
import javafx.beans.property.SimpleIntegerProperty;
import javafx.beans.property.SimpleObjectProperty;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.geometry.HPos;
import javafx.geometry.VPos;
import javafx.scene.Node;
import javafx.scene.layout.Region;

/**
 *
 * @author Goran Lochert
 * Container that lays out nodes in 3 modes, by default resizes all nodes to weight/height of largest node
 * to avoid that behavior override layoutChildren method and compute methods to get real weight/height.
 * TODO: add vgap and hgap to layout calculations
 * TODO: add allItemsSameSizeProperty and add to layouChildren and compute methods calculations
 * TODO: pay attention to non resizeable nodes
 */
public class MultiLayoutContainer extends Region {

    // TODO: make styleable
    public enum ContainerLayout {

        ROW,
        COLUMN,
        GRID // for now does not support cell span 
    }
    private ObjectProperty<ObservableList<Node>> items = new SimpleObjectProperty<ObservableList<Node>>(this, "items");
    
    // TODO: make styleable
    private IntegerProperty columnCount;
    // TODO: make styleable property
    private IntegerProperty rowCount;
    // TODO make styleable
    private ObjectProperty<ContainerLayout> containerLayout;
    // TODO: make styleable
    private DoubleProperty hgap;
    // TODO: make styleable
    private DoubleProperty vgap;
    // ================================================
    // PROPERTIES    
    // ================================================

    public final ObjectProperty containerLayoutProperty() {
        if (containerLayout == null) {
            containerLayout = new SimpleObjectProperty<ContainerLayout>(this, "containerLayout", ContainerLayout.ROW) {

                @Override
                protected void invalidated() {
                    validate();
                }
            };
        }
        return containerLayout;
    }

    public final ContainerLayout getContainerLayout() {
        return containerLayout == null ? ContainerLayout.ROW : containerLayout.get();
    }

    public final void setContainerLayout(ContainerLayout cl) {
        containerLayoutProperty().set(cl);
    }

    public final IntegerProperty columnCountProperty() {
        if (columnCount == null) {
            columnCount = new SimpleIntegerProperty(this, "columnCount", 1) {
            };
        }
        return columnCount;
    }

    public final int getColumnCount() {
        return columnCount == null ? 0 : columnCount.get();
    }

    public final void setColumnCount(int columnCount) {
        columnCountProperty().set(columnCount);
    }

    public final IntegerProperty rowCountProperty() {
        if (rowCount == null) {
            rowCount = new SimpleIntegerProperty(this, "rowCount", 1) {
            };
        }
        return rowCount;
    }

    public final int getRowCount() {
        return rowCount == null ? 0 : rowCount.get();
    }

    public final void setRowCount(int value) {
        rowCountProperty().set(value);
    }

    public final ObservableList<Node> getItems() {
        return items.get();
    }

    public final void setItems(ObservableList<Node> list) {
        items.set(list);
    }

    public final DoubleProperty hgapProperty() {
        if (this.hgap == null) {
            this.hgap = new SimpleDoubleProperty(this, "hgap", 0.0) {

                @Override
                public void invalidated() {
                    MultiLayoutContainer.this.requestLayout();

                }
            };
        }
        return this.hgap;
    }

    public final void setHgap(double value) {
        hgapProperty().set(value);
    }

    public final double getHgap() {
        return this.hgap == null ? 0.0d : this.hgap.get();
    }

    public final DoubleProperty vgapProperty() {
        if (this.vgap == null) {
            this.vgap = new SimpleDoubleProperty(this, "vgap", 0.0d) {

                @Override
                public void invalidated() {
                    MultiLayoutContainer.this.requestLayout();
                }
            };
        }
        return this.vgap;
    }

    public final void setVgap(double value) {
        vgapProperty().set(value);
    }

    public final double getVgap() {
        return this.vgap == null ? 0.0d : this.vgap.get();
    }

    // ===============================================
    // CONSTRUCTORS
    // ===============================================
    public MultiLayoutContainer() {

        this(FXCollections.<Node>observableArrayList());

    }

    public MultiLayoutContainer(ObservableList<Node> items) {
        setItems(items);
        init();
    }

    // ================================================
    // PROTECTED/PRIVATE METHODS
    // ================================================
    private void init() {
        getItems().addListener(new InvalidationListener() {

            @Override
            public void invalidated(Observable o) {
                getChildren().setAll(getItems());
                validate();

            }
        });
    }

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

            if ((cc == 0) || (rc == 0)) {
                System.err.println("ColumnCount or rowCount is 0");
                return;
            }
        }

        requestLayout();
    }

    protected double getMaxItemWidth() {
        double maxW = 0.0;
        for (Node item : getItems()) {
            maxW = Math.max(maxW, item.prefWidth(-1));
        }
        return maxW;
    }

    protected double getMaxItemHeight() {
        double maxH = 0.0;
        for (Node item : getItems()) {
            maxH = Math.max(maxH, item.prefHeight(-1));
        }
        return maxH;
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
        double itemWidth = getMaxItemWidth();
        double itemHeight = getMaxItemHeight();

        List nodeList = getManagedChildren();
        int row = 1;
        int column = 1;
        int cc = getColumnCount();
//        int rc = getRowCount();

        for (int i = 0; i < nodeList.size(); i++) {
            Node node = (Node) nodeList.get(i);
            node.resize(itemWidth, itemHeight);

            positionInArea(node, xOff, yOff, itemWidth, itemHeight, 0.0, HPos.CENTER, VPos.CENTER);
            xOff += itemWidth + getHgap();


            column++;
            if (column == (cc + 1)) {
                column = 1;
                xOff = left;
                yOff += itemHeight + getVgap();
                row++;
            }
        }
    }

    @Override
    protected double computePrefWidth(double d) { // TODO: add gaps
        return getInsets().getLeft() + getMaxItemWidth() * getColumnCount() + getInsets().getRight();
    }

    @Override
    protected double computeMaxWidth(double d) { 
        return computePrefWidth(d);
    }

    @Override
    protected double computeMaxHeight(double d) {
        return computePrefHeight(d);
    }

    @Override
    protected double computePrefHeight(double d) { // TODO: add gaps
        return getInsets().getTop() + getRowCount() * getMaxItemHeight() + getInsets().getBottom();
    }
//    static {
//        StyleManager.getInstance().addUserAgentStylesheet(MultiLayoutContainer.class.getResource(MultiLayoutContainer.class.getSimpleName() + ".css").toString());
//    }
}
