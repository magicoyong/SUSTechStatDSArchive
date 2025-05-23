package original;

import java.util.List;

public interface FileOperateInterfaceV3 {
    List<StaffModel> readAllStaff();

    void listAllStaff(List<StaffModel> list);

    void writeByName(List<StaffModel> list);

    void writeByRoom(List<StaffModel> list);

    void addNewStaff(List<StaffModel> list);

    void removeStaffByName(List<StaffModel> list);
}
