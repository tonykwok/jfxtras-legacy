package jfxtras.scene.control.test;

import java.text.DecimalFormat;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.event.ActionEvent;
import javafx.event.EventHandler;
import javafx.geometry.Insets;
import javafx.geometry.Pos;
import javafx.scene.Node;
import javafx.scene.control.Button;
import javafx.scene.control.Label;
import javafx.scene.control.RadioButton;
import javafx.scene.control.Toggle;
import javafx.scene.control.ToggleGroup;
import javafx.scene.layout.VBox;
import javafx.scene.paint.Color;
import javafx.scene.shape.Rectangle;
import javafx.scene.text.Font;
import javafx.scene.text.Text;
import jfxtras.application.ExtendedApplicationX;
import jfxtras.scene.control.DeckPaneX;

/**
 *
 * @author Goran Lochert
 * DeckPaneTest2 aka Simple Java Quiz :P
 * TODO: add some images etc etc.... improve demo
 */
public class DeckPaneXTest2 extends ExtendedApplicationX {

    private VBox mainContent;
    private ObservableList<Node> quizPages;
    private ObservableList<Node> deckItems;
    private DeckPaneX deck;
    private ResultsPage resultsNode;
    private DecimalFormat df = new DecimalFormat("#0.00");

    public static void main(String[] args) {
        launchWithPrelaunch(DeckPaneXTest2.class, args);
    }

    @Override
    protected void setup() {
        mainContent = new VBox(10);
        mainContent.setPadding(new Insets(10));
        mainContent.setAlignment(Pos.CENTER);

        deck = new DeckPaneX();
        Rectangle rect = new Rectangle(450, 450, Color.DEEPSKYBLUE);
        deck.setBackgroundNode(rect);
        quizPages = createQuizPages();

        deckItems = FXCollections.<Node>observableArrayList();
        deckItems.add(createQuizIntroPage());
        deckItems.addAll(quizPages);
        resultsNode = createQuizResultsNode();
        deckItems.add(resultsNode);

        deck.setItems(deckItems);

        mainContent.getChildren().add(deck);

        Button nextButton = new Button("Next");
        nextButton.setOnAction(new EventHandler<ActionEvent>() {

            @Override
            public void handle(ActionEvent t) {
                
                deck.getSelectionModel().selectNext();
                resultsNode.updateResults(); // do not update everytime
            }
        });

        mainContent.getChildren().add(nextButton);
        root.getChildren().add(mainContent);

        deck.getSelectionModel().selectFirst();
    }

    
    
    private Node createQuizIntroPage() {
        VBox box = new VBox();
        box.setAlignment(Pos.CENTER);
        Text welcomeMessage = new Text("Welcome to Java Quiz");
        welcomeMessage.setFont(new Font(20));
        box.getChildren().add(welcomeMessage);
        Text text = new Text("Click Next to begin Test");
        text.setFont(new Font(20));
        box.getChildren().add(text);

        return box;
    }

    private ObservableList<Node> createQuizPages() {
        ObservableList<Node> items = FXCollections.<Node>observableArrayList();
        //
        QuizPage page1 = new QuizPage(
                "1. What is Java (in regard to Computer Science)?",
                "A type of coffee",
                "An object-oriented programming language",
                "An interactive website",
                "None of the above",
                "2");
        //
        QuizPage page2 = new QuizPage(
                "2. What is an Applet?",
                "Type of computer",
                "A Java program that is run through a web browser",
                "An interactive website",
                "A type of fruit",
                "2");
        //
        QuizPage page3 = new QuizPage(
                "3. Java runs on _______.",
                "Windows",
                "Unix/Linux",
                "Mac",
                "All of the Above",
                "4");
        //
        QuizPage page4 = new QuizPage(
                "4. What is the main function of any variable?",
                "To add numbers together",
                "To keep track of data in the memory of the computer",
                "To print words on the screen",
                "To write Java",
                "2");
        //
        QuizPage page5 = new QuizPage(
                "5. What is an assignment statement?",
                "Adding a number to an int",
                "Assigning a multiplication",
                "Assigning a name to a variable",
                "Assigning a value to a variable",
                "4");
        //
        items.addAll(page1, page2, page3, page4, page5);
        return items;
    }

    private ResultsPage createQuizResultsNode() {
        ResultsPage rp = new ResultsPage();
        return rp;
    }
    class ResultsPage extends VBox {

        private Text messageText;
        private Text percetageText;
        
        public ResultsPage() {
            super(10);
            setAlignment(Pos.CENTER);
            init();
        }
        
        private void init() {
            messageText = new Text();
            messageText.setFont(new Font(20));
            percetageText = new Text();
            percetageText.setFont(new Font(20));
            getChildren().addAll(messageText, percetageText);
        }
        
        public void updateResults() {
            int correctAnswerCount = 0;
            for(int i = 0; i < quizPages.size(); i++) {
                QuizPage page = (QuizPage)quizPages.get(i);
                if(page.isQuestionAnsweredCorrectly()) {
                    correctAnswerCount++;
                }
            }
            messageText.setText("You answered " + correctAnswerCount + " / " + quizPages.size() + " questions correctly.");
            double percentage = (double)correctAnswerCount/quizPages.size() * 100;
            percetageText.setText("Percentage " + df.format(percentage) + "%");
        }
    
    }
    class QuizPage extends VBox {

        private Label questionLabel;
        private RadioButton answerOneRadioButton;
        private RadioButton answerTwoRadioButton;
        private RadioButton answerThreeRadioButton;
        private RadioButton answerFourRadioButton;
        private String correctAnswer;
        private ToggleGroup answerGroup;

        public QuizPage(String... args) {
            super(10);
//            setAlignment(Pos.CENTER);
            setPadding(new Insets(25));
            createGUI(FXCollections.<String>observableArrayList(args));
        }

        private void createGUI(ObservableList<String> questionList) {
            answerGroup = new ToggleGroup();
            questionLabel = new Label(questionList.get(0));
            questionLabel.setFont(new Font(20));
            answerOneRadioButton = new RadioButton(questionList.get(1));
            answerOneRadioButton.setUserData("1");
            answerOneRadioButton.setToggleGroup(answerGroup);
            answerTwoRadioButton = new RadioButton(questionList.get(2));
            answerTwoRadioButton.setUserData("2");
            answerTwoRadioButton.setToggleGroup(answerGroup);
            answerThreeRadioButton = new RadioButton(questionList.get(3));
            answerThreeRadioButton.setUserData("3");
            answerThreeRadioButton.setToggleGroup(answerGroup);
            answerFourRadioButton = new RadioButton(questionList.get(4));
            answerFourRadioButton.setUserData("4");
            answerFourRadioButton.setToggleGroup(answerGroup);
            correctAnswer = questionList.get(5);
            getChildren().addAll(questionLabel, answerOneRadioButton, answerTwoRadioButton, answerThreeRadioButton, answerFourRadioButton);
        }

        public boolean isQuestionAnsweredCorrectly() {
            Toggle toggle = answerGroup.getSelectedToggle();
            if (toggle == null) {
                return false;
            }
            return toggle.getUserData().equals(correctAnswer);
        }
    }
}
