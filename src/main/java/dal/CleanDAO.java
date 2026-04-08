package dal;

import java.sql.*;
import java.util.*;

public class CleanDAO extends DBContext {

    /** Returns (tableName → rowCount) for all user-defined base tables in the current DB. */
    public Map<String, Integer> getTableCounts() {
        Map<String, Integer> result = new LinkedHashMap<>();
        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement(
                 "SELECT table_name FROM information_schema.tables WHERE table_type='BASE TABLE' AND table_name != 'sysdiagrams'")) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                String tbl = rs.getString(1);
                try (PreparedStatement cntPs = c.prepareStatement("SELECT COUNT(*) FROM [" + tbl + "]")) {
                    ResultSet cntRs = cntPs.executeQuery();
                    result.put(tbl, cntRs.next() ? cntRs.getInt(1) : 0);
                } catch (Exception e) { result.put(tbl, -1); }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return result;
    }

    /** Deletes all rows from the specified table. Validates that the table exists in user schema first. */
    public int clearTable(String tableName) {
        // Dynamic whitelist check: see if tableName exists in DB first
        boolean exists = false;
        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement(
                 "SELECT 1 FROM information_schema.tables WHERE table_type='BASE TABLE' AND table_name=?")) {
            ps.setString(1, tableName);
            exists = ps.executeQuery().next();
        } catch (Exception e) { return -2; }

        if (!exists) return -1;

        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement("DELETE FROM [" + tableName + "]")) {
            return ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
            return -3;
        }
    }
}
