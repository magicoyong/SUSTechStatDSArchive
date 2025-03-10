package dao;

public class MysqlDaoFactory implements DaoFactory {
    private static MysqlDaoFactory instance = new MysqlDaoFactory();

    private MysqlDaoFactory(){}

    public static MysqlDaoFactory getInstance(){
        return instance;
    }

    @Override
    public ComputerDao createComputerDao() {
        return new MysqlComputerDao();
    }

    @Override
    public StaffDao createStaffDao() {
        return new MysqlStaffDao();
    }
}
