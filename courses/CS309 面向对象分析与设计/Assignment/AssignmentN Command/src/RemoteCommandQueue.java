import java.util.ArrayDeque;
import java.util.Deque;
import java.util.Queue;

public class RemoteCommandQueue {
    Queue<Command> commands;
    Deque<Command> commandsExecuted;
    public RemoteCommandQueue(){
        commands = new ArrayDeque<>();
        commandsExecuted = new ArrayDeque<>();
    }
    public void buttonPressed(Command command){
        commands.add(command);
    }
    public void commandExecute(){
        if(commands.isEmpty()){
            System.out.println("no command");
        }
        while(!commands.isEmpty()){
            Command currentCommand = commands.poll();
            currentCommand.execute();
            commandsExecuted.addLast(currentCommand);

        }
    }
    public void undo(){
        if(commandsExecuted.isEmpty()){
            System.out.println("No command to undo.");
            return;
        }
        commandsExecuted.pollLast().undo();
    }
}
