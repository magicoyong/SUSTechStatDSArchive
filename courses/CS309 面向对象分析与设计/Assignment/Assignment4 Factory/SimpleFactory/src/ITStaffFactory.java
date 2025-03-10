package SimpleFactory;

public class ITStaffFactory {
    public ITStaff createITStaff(int op){
        switch (op){
            case 1: return new ITManager();
            case 2: return new Developer();
            case 3: return new Tester();
        }
        return null;
    }
}
