package FactoryMethod;

import java.util.Random;

public class ArtDesignerFactory implements ITStaffFactoryInterface{

    Random random = new Random();
    @Override
    public ITStaff createITStaff() {
        return new ArtDesigner(random.nextInt());
    }
}
