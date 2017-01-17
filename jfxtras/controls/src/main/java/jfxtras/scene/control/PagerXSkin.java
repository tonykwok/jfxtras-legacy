package jfxtras.scene.control;

import com.sun.javafx.scene.control.skin.SkinBase;
import javafx.beans.InvalidationListener;
import javafx.beans.Observable;
import javafx.beans.value.ChangeListener;
import javafx.beans.value.ObservableValue;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.event.ActionEvent;
import javafx.event.EventHandler;
import javafx.geometry.Pos;
import javafx.scene.Node;
import javafx.scene.control.Label;
import javafx.scene.control.Separator;
import javafx.scene.control.SingleSelectionModel;
import javafx.scene.control.Toggle;
import javafx.scene.control.ToggleGroup;
import javafx.scene.control.ToolBar;
import javafx.scene.layout.HBox;
import javafx.scene.layout.StackPane;
import javafx.scene.layout.VBox;

/**
 *
 * @author Goran Lochert
 */
public class PagerXSkin extends SkinBase<PagerX, PagerXBehavior> {

    private DeckPaneX deck;
    private PagerXControlBox controls;
    private ToggleGroup pageToggleGroup = new ToggleGroup();
    private ListComboBoxX<Integer> gotoListComboBoxX;
    private ListComboBoxX<Integer> itemsPerPageList;
    private Node templateNode;
    private int templateNodeIndex;
    private int gotoIndex;
    private HBox gotoControl;
    // private ListComboBox gotoListComboBox
//    private ObservableList<Node> pageButtons;
//    private PagerControlEventHandler ceh;
//    private SingleSelectionModel<? extends Node> selectionModel;

    public PagerXSkin(PagerX pager) {
        super(pager, new PagerXBehavior(pager));
        init();
//        initListeners();
        System.out.println("PAGERX SKIN Contructor");
    }

    private void init() {
        deck = getSkinnable().deck;
        VBox localVBox = new VBox(10);


        // register listeners


        getChildren().add(deck);
        gotoListComboBoxX = new ListComboBoxX<Integer>();
        gotoListComboBoxX.setDropDownHeight(150.0d);
        itemsPerPageList = new ListComboBoxX<Integer>(FXCollections.<Integer>observableArrayList(1, 2, 3, 4, 5));
        itemsPerPageList.setDropDownHeight(150.0d);

        controls = new PagerXControlBox();
        templateNodeIndex = controls.getItems().indexOf(templateNode);
        gotoIndex = controls.getItems().indexOf(gotoControl);
        updateGotoControl();

        Integer ipp = getSkinnable().itemsPerPageProperty().getValue();
        System.out.println("ipp: " + ipp.intValue() + " index: " + itemsPerPageList.getSelectionModel().getSelectedIndex());
        int index = itemsPerPageList.getItems().indexOf(ipp);
        System.out.println("index: " + index);
        itemsPerPageList.getSelectionModel().select(index);
        itemsPerPageList.getSelectionModel().selectedIndexProperty().addListener(new ChangeListener<Number>() {

            @Override
            public void changed(ObservableValue<? extends Number> observable, Number oldIndexValue, Number newIndexValue) {
                int itemsPerPage = itemsPerPageList.getSelectionModel().getSelectedItem();
                System.out.println("IPP - selected old: " + oldIndexValue);
//                if(!getSkinnable().itemsPerPageProperty().isBound()) { // if it is bound to something else (some other list or something) ignore
                getSkinnable().setItemsPerPage(itemsPerPage);
//                } 
            }
        });

        localVBox.getChildren().add(deck);
        localVBox.getChildren().add(controls);

        updatePages();
        controls.updateTemplateNode();
        controls.updateNumericButtonsBar(false);
//        updateNumericButtons(false);


        getChildren().add(localVBox);

        deck.getSelectionModel().selectedIndexProperty().addListener(new ChangeListener<Number>() {

            @Override
            public void changed(ObservableValue<? extends Number> observable, Number oldIndexValue, Number newIndexValue) {

                System.out.println("deck: w: " + deck.getWidth() + " h: " + getHeight());

//                if (pageToggleGroup.getToggles().isEmpty()) {
//                    return;
//                }

                int pageIndex = deck.getSelectionModel().getSelectedIndex();
                System.out.println("PAGE_INDEX: " + pageIndex);

                refreshPageButtons(oldIndexValue.intValue(), newIndexValue.intValue());

                Toggle selectedToggle = pageToggleGroup.getSelectedToggle();
                if (selectedToggle != null) { // if nothing selected return, when going down autoselected in updateMethod
                    String togglePageID = (String) selectedToggle.getProperties().get("PAGE_ID"); // do it without casting integer can be value
                    System.out.println("togglePageID=" + togglePageID);
                    int pbID = Integer.parseInt(togglePageID);
                    if (pageIndex != pbID) {
                        pageToggleGroup.selectToggle(findToggle(String.valueOf(pageIndex)));
                    }
                }

                int gotoIndex = gotoListComboBoxX.getSelectionModel().getSelectedIndex();
                System.out.println("GOTO INDEX: " + pageIndex);
                if (pageIndex != gotoIndex) {
                    gotoListComboBoxX.getSelectionModel().select(pageIndex);
                }
                controls.updateTemplateNode();
            }

            private void refreshPageButtons(int oldIndex, int newIndex) {
                int shift = newIndex - oldIndex;
                int bc = getSkinnable().getPageButtonsCount();
                if (bc == 0) {
                    return;
                }
                if (shift > 0) { // if index is going up
                    if (shift > (newIndex % bc)) {
                        controls.updateNumericButtonsBar(false);
                    }
                } else { // index is going down
                    if (Math.abs(shift) > (oldIndex % bc)) {
                        controls.updateNumericButtonsBar(true);
                    }
                }
            }

            private Toggle findToggle(String pageID) {
                Toggle temp = null;
                System.out.println("togglePageID: " + pageID);
                for (Toggle toggle : pageToggleGroup.getToggles()) {

                    String tempID = (String) toggle.getProperties().get("PAGE_ID");
                    System.out.println("tempID: " + tempID);
                    if (tempID.equals(pageID)) {
                        temp = toggle;
                        break;
                    }
                }
                System.out.println("temp: " + temp);
                return temp;
            }
        });

        // selectedIndexProperty is Read Only Integer Property
        gotoListComboBoxX.getSelectionModel().selectedIndexProperty().addListener(new ChangeListener<Number>() {

            @Override
            public void changed(ObservableValue<? extends Number> observable, Number oldIndexValue, Number newIndexValue) {
                deck.getSelectionModel().select(newIndexValue.intValue());
            }
        });

        // register other listeners
        registerChangeListener(getSkinnable().itemsProperty(), "ITEMS");
        registerChangeListener(getSkinnable().pageButtonsCountProperty(), "PAGE_BUTTONS_COUNT");
        registerChangeListener(getSkinnable().itemsPerPageProperty(), "ITEMS_PER_PAGE");
        registerChangeListener(getSkinnable().showGotoControlProperty(), "SHOW_GOTO_CONTROL");
        registerChangeListener(getSkinnable().templateNodeShownProperty(), "TEMPLATE_NODE_SHOWN");

        System.out.println("children: " + localVBox.getChildren() + " deckSize: " + deck.getItems().size());
    }

    @Override
    protected void handleControlPropertyChanged(String string) {
        super.handleControlPropertyChanged(string);
        if (string.equals("ITEMS")) {
            System.out.println("items changed.");
            updatePages();
        } else if (string.equals("PAGE_BUTTONS_COUNT")) {
            controls.updateNumericButtonsBar(false);
        } else if (string.equals("ITEMS_PER_PAGE")) {
            System.out.println("items per page changed.");
            updatePages();
//            itemsPerPageList.getSelectionModel().select(getSkinnable().getItemsPerPage());
//            gotoListComboBoxX.getSelectionModel().selectFirst();
            controls.updateNumericButtonsBar(false);
            controls.updateTemplateNode();
        } else if (string.equals("SHOW_GOTO_CONTROL")) {
//            updateGotoControl(); toolbar gets bigger height with gotoControl then w/o it -> make custom layout
        } else if (string.equals("TEMPLATE_NODE_SHOWN")) {
            updateTemplateNode();
        }
    }

    private void updateTemplateNode() {
        boolean isShown = getSkinnable().isTemplateNodeShown();
        if (isShown && (!controls.getItems().contains(templateNode))) {
            controls.getItems().add(templateNodeIndex, templateNode);
        } else {
            controls.getItems().remove(templateNode);
        }
    }

    private void updateGotoControl() {
        if (!getSkinnable().isShowGotoControl()) {
            controls.getItems().remove(gotoControl);
        } else { // insert at same index
            if (!controls.getItems().contains(gotoControl)) {
                controls.getItems().add(gotoIndex, gotoControl);
            }
        }
    }

    private void updatePages() {
        ObservableList<Integer> gotoList = FXCollections.<Integer>observableArrayList();
        int pageNumber = 1;
        System.out.println("contruct pages - items per page: " + getSkinnable().getItemsPerPage() + " itemCount: " + getSkinnable().getItems().size());
        deck.getItems().clear(); // clear all pages
        for (int i = 0; i < getSkinnable().getItems().size(); i += getSkinnable().getItemsPerPage()) {
            ObservableList<PageItemX> itemsInPage = FXCollections.<PageItemX>observableArrayList();
            for (int j = 0; j < getSkinnable().getItemsPerPage(); j++) {
                int index = i + j; // calcualate
                if (index < getSkinnable().getItems().size()) {
                    itemsInPage.add(getSkinnable().getItems().get(index)); // add item to page
                } else {
                    break;
                }
            }
            if (!itemsInPage.isEmpty()) {
                deck.getItems().add(new PageX(itemsInPage));
                gotoList.add(pageNumber++);
            }
        }

        gotoListComboBoxX.setItems(gotoList);
//        System.out.println("GOTO: " + gotoListComboBoxX.getSelectionModel().getSelectedIndex());
//        gotoListComboBoxX.getSelectionModel().selectFirst();
//        System.out.println("GOTO: " + gotoListComboBoxX.getSelectionModel().getSelectedIndex());
//        getSkinnable().setPageButtonsCount(deck.getItems().size());
        deck.getSelectionModel().selectFirst();// always select first one when items are changed/added etc..
    }

    /**
     * ControlBox for Controlling pagerX
     */
    // 
    // TODO: extend Region or StackPane or maybe Toolbar
    // TODO: DONE! add numeric buttons 5 + ...
    // TODO: DONE! add itemsPerPage controls -listComboBoxX - showItemsPerPageControls
    // TODO: DONE! add gotoPage controls - listComboBoxX - showGotoControls
    // TODO: DONE! add templateLabel - property templateLabelText
    protected class PagerXControlBox extends ToolBar {

        private PagerControlEventHandler ceh;
//        PagerXControlHandler pceh;
        private HBox firstPrevBox;
        private HBox nextLastBox;
        private HBox numericControlsBox;
        private NumericControlsInvalidationListener ncil;

        public PagerXControlBox() {
            super();

            getStyleClass().add("control-box");
            templateNode = new StackPane();

            ceh = new PagerControlEventHandler();
            ncil = new NumericControlsInvalidationListener();
            pageToggleGroup.selectedToggleProperty().addListener(ncil);
            setAlignment(Pos.BASELINE_CENTER);

            init();
        }

        private void init() {
            createFirstPrevControls();
            createNumericButtonsBar();

            updateNumericButtonsBar(false);

            createNextLastControls();
            gotoListComboBoxX.setPrefHeight(20);

            itemsPerPageList.setPrefHeight(20);

            getItems().add(new Label("Items per page"));
            getItems().add(itemsPerPageList);

            gotoControl = new HBox(10);
            gotoControl.setAlignment(Pos.CENTER);
            gotoControl.getChildren().add(new Label("Go to:"));
            gotoControl.getChildren().add(gotoListComboBoxX);
//            getItems().add(new Label("Go to"));
//            getItems().add(gotoListComboBoxX);
            getItems().add(gotoControl);
            getItems().add(templateNode);
            updateTemplateNode();
        }

        private void updateTemplateNode() {

            int index = getItems().indexOf(templateNode);
            Node newTemplate = getSkinnable().getTemplateFactory().call(getSkinnable());
            templateNode = newTemplate;
            if (index != -1) {
                getItems().set(index, templateNode);
            }

        }

        private void createFirstPrevControls() {
            firstPrevBox = new HBox();
            firstPrevBox.getStyleClass().add("first-prev-box");

            PillButtonX firstButton = createPillButtonX("First", "first", ceh, "first-button");
            PillButtonX previousButton = createPillButtonX("Previous", "prev", ceh, "previous-button");

            firstPrevBox.getChildren().addAll(firstButton, previousButton);

            getItems().add(firstPrevBox);
        }

        private void createNextLastControls() {
            nextLastBox = new HBox();
            nextLastBox.getStyleClass().add("next-last-box");

            PillButtonX nextButton = createPillButtonX("Next", "next", ceh, "next-button-old");
            PillButtonX lastButton = createPillButtonX("Last", "last", ceh, "last-button");

            nextLastBox.getChildren().addAll(nextButton, lastButton);

            getItems().addAll(nextLastBox);
        }

        private void createNumericButtonsBar() {
            numericControlsBox = new HBox();
            numericControlsBox.getStyleClass().add("numberic-controls-box");


            getItems().add(numericControlsBox);
        }

        /**
         * If buttonCount is zero does not update
         * @param isDown 
         */
        private void updateNumericButtonsBar(boolean isDown) {


            System.out.println("---> refreshing - isDown: " + isDown);
            System.out.println("selected: " + getSkinnable().getSelectionModel().getSelectedIndex());
            pageToggleGroup.getToggles().clear(); // clear toggles
            // remove listener
            int bc = getSkinnable().getPageButtonsCount();
            if (bc == 0) {
                return;
            }
            System.out.println("buttonCount: " + bc);
            numericControlsBox.getChildren().clear();
            numericControlsBox.getChildren().add(new Separator());
            if (deck.getSelectionModel().getSelectedIndex() > bc - 1) {
                PillButtonX btn = new PillButtonX("...");
                btn.setSelectAllowed(false);
//                btn.setButtonPosition(PillButtonX.ButtonPosition.LEFT);
                btn.setUserData("dots-left");
                btn.setOnAction(ceh);
                btn.getStyleClass().add("left-dots-button");

                numericControlsBox.getChildren().add(btn);
            }
//            int buttonCount = 
            int selectedIndex = deck.getSelectionModel().getSelectedIndex();
            int size = deck.getItems().size();

            int startIndex = selectedIndex % bc == 0 ? selectedIndex : selectedIndex - (selectedIndex % bc);
            int endIndex = selectedIndex % bc == 0 ? selectedIndex + bc : selectedIndex + bc - ((selectedIndex % bc));

            System.out.println("start: " + startIndex + " end: " + endIndex);
            for (int i = startIndex; i < endIndex; i++) {
                if (i == size) { // if there are no more pages return
                    break;
                }

                PillButtonX btn = new PillButtonX(String.valueOf(i + 1));
                btn.setButtonPosition(PillButtonX.ButtonPosition.CENTER);
                btn.setDeselectAllowed(false);
                btn.getProperties().put("PAGE_ID", String.valueOf(i));

                btn.setToggleGroup(pageToggleGroup);

                numericControlsBox.getChildren().add(btn);

                if (i == selectedIndex) {
                    pageToggleGroup.selectToggle(btn);
                }
                if ((i == endIndex - 1) && (i != size - 1)) { // if there are more pages add dots button
                    PillButtonX dotsButton = new PillButtonX("...");
                    dotsButton.setSelectAllowed(false);
                    dotsButton.setUserData("dots-right");
                    dotsButton.setOnAction(ceh);
                    dotsButton.getStyleClass().add("right-dots-button");

                    numericControlsBox.getChildren().add(dotsButton);
                }
            }

            numericControlsBox.getChildren().add(new Separator());
        }

        private PillButtonX createPillButtonX(String text, String userData, EventHandler<ActionEvent> eh, String styleClass) {
            PillButtonX temp = new PillButtonX(text);
            temp.setUserData(userData);
//            temp.setPrefHeight(30);
            temp.setSelectAllowed(false);
            temp.setOnAction(eh);
            temp.getStyleClass().add(styleClass);
            return temp;
        }
    }

    /**
     * Invalidation listener for numeric buttons
     */
    protected class NumericControlsInvalidationListener implements InvalidationListener {

        @Override
        public void invalidated(Observable o) {
            Toggle toggle = pageToggleGroup.getSelectedToggle();
            if (toggle == null) {
                return;
            }
            int togglePageID = Integer.parseInt(toggle.getProperties().get("PAGE_ID").toString());
            int pageIndex = deck.getSelectionModel().getSelectedIndex();
            if (togglePageID != pageIndex) {
                System.out.println("changing page toggleID: " + togglePageID + " pi: " + pageIndex);
                System.out.println("selectAllowed: " + ((PillButtonX) toggle).isSelectAllowed());
                deck.getSelectionModel().select(togglePageID);
            }
        }
    }

    /**
     * EventHandler for first-prev, last-next and dot Buttons
     * TODO: make outer class so users can do something before or after it is called by overriding class
     */
    protected class PagerControlEventHandler implements EventHandler<ActionEvent> {

        @Override
        public void handle(ActionEvent t) {
            SingleSelectionModel<PageX> selectionModel = (SingleSelectionModel<PageX>) getSkinnable().getSelectionModel();
            Node node = (Node) t.getSource();
            String data = node.getUserData().toString();
            if (data.equals("first")) {
                selectionModel.selectFirst();
            } else if (data.equals("prev")) {
                selectionModel.selectPrevious();
            } else if (data.equals("next")) {
                selectionModel.selectNext();
            } else if (data.equals("last")) {
                selectionModel.selectLast();
            } else if (data.equals("dots-left")) {
                int buttonCount = getSkinnable().getPageButtonsCount();
                int selectedIndex = selectionModel.getSelectedIndex();
                int shiftIndex = selectedIndex - 1 - (selectedIndex % buttonCount);
                System.out.println("shiftIndex: " + shiftIndex);
                selectionModel.select(shiftIndex);
            } else if (data.equals("dots-right")) {
                int buttonCount = getSkinnable().getPageButtonsCount();
                int selectedIndex = selectionModel.getSelectedIndex();
                int shiftIndex = selectedIndex + (buttonCount - (selectedIndex % buttonCount));
                selectionModel.select(shiftIndex);
            }
        }
    }
}
