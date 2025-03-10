package dao;

public class SqlServerFactory implements DaoFactory{

    private static SqlServerFactory instance = new SqlServerFactory();

    private SqlServerFactory(){}

    public static SqlServerFactory getInstance(){
        return instance;
    }


    @Override
    public ComputerDao createComputerDao() {
        return new SqlServerComputerDao();
    }

    @Override
    public StaffDao createStaffDao() {
        return new SqlServerStaffDao();
    }
}
