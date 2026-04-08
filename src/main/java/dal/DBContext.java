package dal;

import java.sql.*;

public class DBContext {
    public Connection getConnection() throws Exception {
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        return DriverManager.getConnection(
            "jdbc:sqlserver://localhost:1433;databaseName=emcdb;encrypt=true;trustServerCertificate=true", 
            "sa", "sa"
        );
    }
}