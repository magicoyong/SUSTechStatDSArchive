import java.awt.*;

public class BlueBall extends Ball{
    public BlueBall(Color color, int xSpeed, int ySpeed, int ballSize) {
        super(color, xSpeed, ySpeed, ballSize);
        score = -80;
    }

    @Override
    public void onNotified(char c) {
        setXSpeed(-1 * getXSpeed());
        setYSpeed(-1 * getYSpeed());
    }

    @Override
    public void onNotified(Ball whiteBall){
        setVis(isIntersect(whiteBall));
        if(isVis()){
            setXSpeed(-1 * getXSpeed());
            setYSpeed(-1 * getYSpeed());
        }
    }
}
