package model;

import java.util.List;
import java.util.Map;

public class BasicGun {
    private String name;
    private int totalEmc;
    private List<Map<String, Object>> details;

    public BasicGun(String name, int totalEmc, List<Map<String, Object>> details) {
        this.name = name;
        this.totalEmc = totalEmc;
        this.details = details;
    }

    public String getName() { return name; }
    public int getTotalEmc() { return totalEmc; }
    public List<Map<String, Object>> getDetails() { return details; }
}
