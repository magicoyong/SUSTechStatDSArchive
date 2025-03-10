import java.awt.*;
import java.util.ArrayList;
import java.util.List;

public class WhiteBall extends Ball implements Subject<Ball>{
    private List<Ball> ballList = new ArrayList<>();
    public WhiteBall(Color color, int xSpeed, int ySpeed, int ballSize) {
        super(color, xSpeed, ySpeed, ballSize);
        score = 0;
    }
    public void onNotified(char keyChar) {
        switch (keyChar) {
            case 'a': setXSpeed(-8); break;
            case 'd': setXSpeed(8); break;
            case 'w': setYSpeed(-8); break;
            case 's': setYSpeed(8); break;
        }
    }

    @Override
    public void registerObserver(Ball ball) {
        if(ball.equals(this))
            return;
        ballList.add(ball);
    }

    public void removeObservers(){
        ballList = new ArrayList<>();
    }

    @Override
    public void removeObserver(Ball ball) {
        ballList.remove(ball);
    }

    @Override
    public void notifyObservers() {
        for (Ball ball: ballList) {
            ball.onNotified(this);
        }
    }

    @Override
    public void notifyObservers(char KeyChar) {

    }

    public void move(){
        super.move();
        notifyObservers();
    }
}
