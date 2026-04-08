package dal;

import model.SubItem;
import java.sql.*;
import java.util.*;

public class GunDAO extends DBContext {
    private final String tableName;

    public GunDAO(String tableName) {
        this.tableName = tableName;
    }

    public List<SubItem> getAll() {
        List<SubItem> list = new ArrayList<>();
        try (Connection c = getConnection(); PreparedStatement ps = c.prepareStatement("SELECT * FROM " + tableName + " ORDER BY id ASC")) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                int id = rs.getInt("id");
                String name = rs.getString("name");
                int totalEmc = rs.getInt("total_emc");
                String detailsStr = rs.getString("details");
                
                List<Map<String, Object>> details = new ArrayList<>();
                if (detailsStr != null && !detailsStr.isEmpty()) {
                    String[] mats = detailsStr.split("\\|");
                    for (String m : mats) {
                        String[] mq = m.split(":");
                        if (mq.length == 2) {
                            Map<String, Object> d = new HashMap<>();
                            d.put("name", mq[0].trim());
                            d.put("qty", Integer.parseInt(mq[1].trim()));
                            details.add(d);
                        }
                    }
                }
                list.add(new SubItem(id, name, 1, totalEmc, details));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public void save(SubItem s) {
        String detailsStr = "";
        if (s.getMaterialDetails() != null) {
            boolean first = true;
            for (Map<String, Object> d : s.getMaterialDetails()) {
                if (!first) detailsStr += "|";
                detailsStr += d.get("name") + ":" + d.get("qty");
                first = false;
            }
        }
        
        String sql = (s.getId() > 0) ? "UPDATE " + tableName + " SET name=?, total_emc=?, details=? WHERE id=?" 
                                     : "INSERT INTO " + tableName + "(name, total_emc, details) VALUES(?, ?, ?)";
        try (Connection c = getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, s.getName());
            ps.setInt(2, s.getTotalEmc());
            ps.setString(3, detailsStr);
            if (s.getId() > 0) ps.setInt(4, s.getId());
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }

    public void delete(int id) {
        try (Connection c = getConnection(); PreparedStatement ps = c.prepareStatement("DELETE FROM " + tableName + " WHERE id=?")) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }
}
