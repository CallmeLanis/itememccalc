import java.sql.Connection; 
import java.sql.DriverManager; 
import java.sql.Statement; 

public class CreateDB { 
    public static void main(String[] args) throws Exception { 
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver"); 
        try (Connection c = DriverManager.getConnection("jdbc:sqlserver://localhost:1433;databaseName=emcdb;encrypt=true;trustServerCertificate=true", "sa", "sa"); 
             Statement stmt = c.createStatement()) { 
            stmt.executeUpdate("CREATE TABLE attachments (id INT IDENTITY(1,1) PRIMARY KEY, name NVARCHAR(255), count INT, total_emc INT, details NVARCHAR(MAX))"); 
            System.out.println("Table created"); 
        } 
    } 
}
