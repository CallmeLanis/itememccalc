package dal;

import model.SubItem;
import java.sql.*;
import java.util.*;

public class AttachmentDAO extends DBContext {
    
    public List<SubItem> getAll() {
        List<SubItem> list = new ArrayList<>();
        try (Connection c = getConnection(); PreparedStatement ps = c.prepareStatement("SELECT * FROM attachments ORDER BY id ASC")) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                int id = rs.getInt("id");
                String name = rs.getString("name");
                int count = rs.getInt("count");
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
                            d.put("value", 0);
                            details.add(d);
                        }
                    }
                }
                list.add(new SubItem(id, name, count, totalEmc, details));
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
        
        String sql = (s.getId() > 0) ? "UPDATE attachments SET name=?, count=?, total_emc=?, details=? WHERE id=?" 
                                     : "INSERT INTO attachments(name, count, total_emc, details) VALUES(?, ?, ?, ?)";
        try (Connection c = getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, s.getName());
            ps.setInt(2, s.getCount());
            ps.setInt(3, s.getTotalEmc());
            ps.setString(4, detailsStr);
            if (s.getId() > 0) ps.setInt(5, s.getId());
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }

    public void delete(int id) {
        try (Connection c = getConnection(); PreparedStatement ps = c.prepareStatement("DELETE FROM attachments WHERE id=?")) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }

    public SubItem getById(int id) {
        try (Connection c = getConnection(); PreparedStatement ps = c.prepareStatement("SELECT * FROM attachments WHERE id=?")) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                String name = rs.getString("name");
                int count = rs.getInt("count");
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
                            d.put("value", 0);
                            details.add(d);
                        }
                    }
                }
                return new SubItem(id, name, count, totalEmc, details);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    /** Returns true if an attachment with this exact name (case-insensitive) already exists. */
    public boolean existsByName(String name) {
        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement(
                     "SELECT 1 FROM attachments WHERE LOWER(name) = LOWER(?) LIMIT 1")) {
            ps.setString(1, name.trim());
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }
}
