import javax.swing.*;
import java.awt.*;
import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;

public class MainPanel extends JPanel implements KeyListener, Subject<Ball> {
    private List<Ball> paintingBallList = new ArrayList<>();

    @Override
    public void registerObserver(Ball ball) {
        paintingBallList.add(ball);
    }

    @Override
    public void removeObserver(Ball ball) {
        paintingBallList.remove(ball);
    }

    @Override
    public void notifyObservers() {
//        for (Ball ball: paintingBallList){
//            ball.onNotified(whiteBall);
//        }
    }

    @Override
    public void notifyObservers(char KeyChar) {
        for (Ball ball: paintingBallList) {
            ball.onNotified(KeyChar);
        }
    }

    enum GameStatus {PREPARING, START, STOP}

    private GameStatus gameStatus;
    private int score;
    private Ball whiteBall;
    Random random = new Random();
    Timer t;

    public MainPanel() {
        super();
        setLayout(null);
        setSize(590, 590);
        setFocusable(true);
        this.addKeyListener(this);
        t = new Timer(50, e -> moveBalls());
        restartGame();
    }


    public void startGame() {
        this.gameStatus = GameStatus.START;
        addBallToPanel(whiteBall);
        this.paintingBallList.forEach(b -> b.setVis(false));
        this.whiteBall.setVis(true);
    }

    public void stopGame() {
        this.gameStatus = GameStatus.STOP;
        this.t.stop();
        paintingBallList.forEach(b -> {
            if (b.isVis()) {
                scoreIncrement(b.score);
            }
        });
        repaint();
    }

    public void restartGame() {
        this.gameStatus = GameStatus.PREPARING;
        if (paintingBallList.size() > 0) {
            paintingBallList.forEach(this::remove);
        }
        this.paintingBallList = new ArrayList<>();

        Ball.setCount(0);
        this.score = 100;
        if (this.whiteBall != null) {
            ((WhiteBall)whiteBall).removeObservers();
            this.whiteBall.setVis(false);
        }

        this.t.start();
        repaint();
    }

    public void setWhiteBall(Ball whiteBall) {
        this.whiteBall = whiteBall;
        this.whiteBall.setVis(false);
    }

    public void moveBalls() {
        paintingBallList.forEach(Ball::move);
        if (this.gameStatus == GameStatus.START) {
            score--;
        }
        repaint();
    }

    @Override
    protected void paintComponent(Graphics g) {
        super.paintComponent(g);
        g.setFont(new Font("Arial", Font.PLAIN, 30));
        g.setColor(Color.BLACK);
        g.drawString("Score: " + score, 20, 40);

        if (gameStatus == GameStatus.START) {
            this.setBackground(Color.WHITE);
        }

        if (gameStatus == GameStatus.STOP) {
            g.setColor(Color.BLACK);
            g.setFont(new Font("Arial", Font.BOLD, 45));
            g.drawString("Game Over!", 200, 200);
            g.setFont(new Font("", Font.BOLD, 40));
            g.drawString("Your score is " + score, 190, 280);
        }
    }

    public void scoreIncrement(int increment) {
        this.score += increment;
    }


    public void addBallToPanel(Ball ball) {
        registerObserver(ball);
        ((WhiteBall)whiteBall).registerObserver(ball);
        this.add(ball);
    }

    @Override
    public void keyTyped(KeyEvent e) {

    }

    @Override
    public void keyPressed(KeyEvent e) {
        char keyChar = e.getKeyChar();
        System.out.println("Press: " + keyChar);
        notifyObservers(keyChar);
    }

    @Override
    public void keyReleased(KeyEvent e) {

    }


}
