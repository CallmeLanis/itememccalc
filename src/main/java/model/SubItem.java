package model;

import java.util.List;
import java.util.Map;

public class SubItem {
    private int id;
    private String name;
    private int count;
    private int totalEmc;
    private List<Map<String, Object>> materialDetails; // Lưu chi tiết mats dùng cho item này

    // Existing for session logic
    public SubItem(String name, int count, int totalEmc, List<Map<String, Object>> details) {
        this.name = name;
        this.count = count;
        this.totalEmc = totalEmc;
        this.materialDetails = details;
    }

    // New for DB mapping
    public SubItem(int id, String name, int count, int totalEmc, List<Map<String, Object>> details) {
        this.id = id;
        this.name = name;
        this.count = count;
        this.totalEmc = totalEmc;
        this.materialDetails = details;
    }

    // Getters / Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getName() { return name; }
    public int getCount() { return count; }
    public int getTotalEmc() { return totalEmc; }
    public List<Map<String, Object>> getMaterialDetails() { return materialDetails; }
}