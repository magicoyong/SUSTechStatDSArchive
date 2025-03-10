package dao;

import java.io.BufferedInputStream;
import java.io.FileInputStream;
import java.io.InputStream;
import java.util.Properties;

public class DaoFactoryImpl implements DaoFactory {
    private static final DaoFactoryImpl instance = new DaoFactoryImpl();
    private static final Properties prop = new Properties();
    private DaoFactoryImpl(){}

    private static void loadProperty(){
        InputStream in = null;
        try{
            in = new BufferedInputStream(new FileInputStream("resource/resource.properties"));
            prop.load(in);
        }catch(Exception e){
            e.printStackTrace();
        }
    }

    public static Object createObject(String className){
        try{
            Class<?> clz = Class.forName(className);
            return clz.getDeclaredConstructor().newInstance();
        }catch (Exception e){
            e.printStackTrace();
        }
        return null;
    }

    static {
        loadProperty();
    }

    public static DaoFactoryImpl getInstance(){
        return instance;
    }

    @Override
    public ComputerDao createComputerDao() {
        return (ComputerDao)createObject(prop.getProperty("packageName") + "." + prop.getProperty("dbType") + "ComputerDao");
    }

    @Override
    public StaffDao createStaffDao() {
        return (StaffDao)createObject(prop.getProperty("packageName") + "." + prop.getProperty("dbType") + "StaffDao");
    }
}
