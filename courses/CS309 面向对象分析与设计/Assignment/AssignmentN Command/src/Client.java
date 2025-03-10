import java.util.InputMismatchException;
import java.util.Scanner;

public class Client {
    public static void main(String[] args) {
        AirConditioner roomAirConditioner = new AirConditioner("bedRoom");
        AirConditioner livingAirConditioner = new AirConditioner("livingRoom");
        Light roomLight = new Light("bedRoom");
        Light livingLight = new Light("livingRoom");

        Command[] commands = new Command[]{
                new AirConditionerOnCommand(roomAirConditioner),
                new AirConditionerOffCommand(roomAirConditioner),
                new AirConditionerOnCommand(livingAirConditioner),
                new AirConditionerOffCommand(livingAirConditioner),
                new LightOnCommand(roomLight),
                new LightOffCommand(roomLight),
                new LightOnCommand(livingLight),
                new LightOffCommand(livingLight)
        };
        RemoteCommandQueue remoteCommandQueue = new RemoteCommandQueue();

        Scanner input = new Scanner(System.in);
        System.out.println("Please input operation number: 1-9,[1,3,5,7] is on command,[2,4,6,8] is off command, 9 is to show state terminate by 0:");
        int op = 0;
        do {
            try {
                op = input.nextInt();
                switch (op) {
                    case 9:
                        showState(
                                new AirConditioner[]{roomAirConditioner, livingAirConditioner},
                                new Light[]{roomLight, livingLight
                        });
                        break;
                    case 10:
                        remoteCommandQueue.commandExecute();
                        break;
                    case 11:
                        remoteCommandQueue.undo();
                        break;
                    default:
                        if(1 <= op && op <= 8){
                            remoteCommandQueue.buttonPressed(commands[op - 1]);
                        }
                }
            } catch (InputMismatchException e) {
                System.out.println("Exception:" + e);
                input.nextLine();
            }
        } while (op != 0);

        input.close();
    }

    public static void showState(AirConditioner[] airConditioners, Light[] lights) {
        for (AirConditioner a : airConditioners) {
            System.out.println(a);
        }
        for (Light l : lights) {
            System.out.println(l);
        }

    }
}
