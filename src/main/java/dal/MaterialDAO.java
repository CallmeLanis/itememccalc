package dal;

import model.Material;
import java.sql.*;
import java.util.*;

public class MaterialDAO extends DBContext {
    
    public List<Material> getAll() {
        List<Material> list = new ArrayList<>();
        try (Connection c = getConnection(); PreparedStatement ps = c.prepareStatement("SELECT * FROM materials ORDER BY name ASC")) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(new Material(rs.getInt(1), rs.getString(2), rs.getInt(3)));
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public void save(Material m) {
        String sql = (m.getId() > 0) ? "UPDATE materials SET name=?, emc_value=? WHERE id=?" 
                                     : "INSERT INTO materials(name, emc_value) VALUES(?, ?)";
        try (Connection c = getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, m.getName());
            ps.setInt(2, m.getEmcValue());
            if (m.getId() > 0) ps.setInt(3, m.getId());
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }

    public void delete(int id) {
        try (Connection c = getConnection(); PreparedStatement ps = c.prepareStatement("DELETE FROM materials WHERE id=?")) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }

    public Material getById(int id) {
        try (Connection c = getConnection(); PreparedStatement ps = c.prepareStatement("SELECT * FROM materials WHERE id=?")) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return new Material(rs.getInt(1), rs.getString(2), rs.getInt(3));
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    /** Returns true if a material with this exact name (case-insensitive) already exists. */
    public boolean existsByName(String name) {
        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement(
                     "SELECT 1 FROM materials WHERE LOWER(name) = LOWER(?) LIMIT 1")) {
            ps.setString(1, name.trim());
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }
}