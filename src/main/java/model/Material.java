package model;

public class Material {
    private int id;
    private String name;
    private int emcValue;

    // 1. Constructor không tham số (Vibecoder luôn cần cái này để tránh lỗi vặt)
    public Material() {
    }

    // 2. Constructor có 2 tham số (Dùng khi Thêm mới - chưa có ID)
    public Material(String name, int emcValue) {
        this.name = name;
        this.emcValue = emcValue;
    }

    // 3. Constructor có 3 tham số (Cái này là cái đang bị thiếu khiến bạn bị lỗi đỏ!)
    public Material(int id, String name, int emcValue) {
        this.id = id;
        this.name = name;
        this.emcValue = emcValue;
    }

    // Đừng quên các Getter và Setter bên dưới nhé...

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getEmcValue() {
        return emcValue;
    }

    public void setEmcValue(int emcValue) {
        this.emcValue = emcValue;
    }
}