package original;

import java.util.List;

public class Adapter2 implements FileOperateInterfaceV3{
    private FileOperateInterfaceV2 adaptee1;
    private ManageStaffInterface adaptee2;

    Adapter2(FileOperateInterfaceV2 adaptee1, ManageStaffInterface adaptee2){
        this.adaptee1 = adaptee1;
        this.adaptee2 = adaptee2;
    }
    @Override
    public List<StaffModel> readAllStaff() {
        return adaptee1.readAllStaff();
    }

    @Override
    public void listAllStaff(List<StaffModel> list) {
        adaptee1.listAllStaff(list);
    }

    @Override
    public void writeByName(List<StaffModel> list) {
        adaptee1.writeByName(list);
    }

    @Override
    public void writeByRoom(List<StaffModel> list) {
        adaptee1.writeByRoom(list);
    }

    @Override
    public void addNewStaff(List<StaffModel> list) {
        adaptee2.addingStaff(list);
    }

    @Override
    public void removeStaffByName(List<StaffModel> list) {
        adaptee2.removeStaff(list);
    }
}
