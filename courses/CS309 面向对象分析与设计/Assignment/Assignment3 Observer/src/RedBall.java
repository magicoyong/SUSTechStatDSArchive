import java.awt.*;
import java.util.Random;

public class RedBall extends Ball{
    Random random = new Random();
    public RedBall(Color color, int xSpeed, int ySpeed, int ballSize) {
        super(color, xSpeed, ySpeed, ballSize);
        score = 80;
    }

    @Override
    public void onNotified(char keyChar) {
        switch (keyChar) {
            case 'a': setXSpeed(-random.nextInt(3) - 1); break;
            case 'd': setXSpeed(random.nextInt(3) + 1); break;
            case 'w': setYSpeed(-random.nextInt(3) - 1); break;
            case 's': setYSpeed(random.nextInt(3) + 1); break;
        }
    }
    @Override
    public void onNotified(Ball whiteBall){
        setVis(isIntersect(whiteBall));
        if(isVis()){
            setXSpeed(whiteBall.getXSpeed());
            setYSpeed(whiteBall.getYSpeed());
        }
    }
}
