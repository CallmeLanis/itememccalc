package controller;

import dal.MaterialDAO;
import dal.AttachmentDAO;
import model.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;
import java.util.*;

@WebServlet("/quickload")
public class QuickLoadController extends HttpServlet {
    MaterialDAO dao = new MaterialDAO();
    AttachmentDAO aDao = new AttachmentDAO();
    dal.GunDAO gDaoOrigin = new dal.GunDAO("gun_origins");
    dal.GunDAO gDaoCustom = new dal.GunDAO("custom_guns");

    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("quickload.jsp").forward(req, resp);
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        
        if ("loadVanilla".equals(action)) {
            loadVanilla(req, dao);
        } 
        else if ("loadAttachment".equals(action)) {
            loadGunGeneric(req, aDao, "attachmentData", "msg2");
        }
        else if ("loadGunOrigin".equals(action)) {
            loadGunGeneric(req, gDaoOrigin, "originData", "msg3");
        }
        else if ("loadCustomGun".equals(action)) {
            loadGunGeneric(req, gDaoCustom, "customData", "msg4");
        }
        else if ("exportVanilla".equals(action)) {
            StringBuilder sb = new StringBuilder();
            for(Material m : dao.getAll()) sb.append(m.getName()).append(",").append(m.getEmcValue()).append("\n");
            req.setAttribute("vanillaExport", sb.toString());
            req.setAttribute("msg1", "Vanilla Mats Exported!");
        }
        else if ("exportAttachment".equals(action)) {
            req.setAttribute("attachmentExport", exportGunGeneric(aDao));
            req.setAttribute("msg2", "Attachments Exported!");
        }
        else if ("exportGunOrigin".equals(action)) {
            req.setAttribute("originExport", exportGunGeneric(gDaoOrigin));
            req.setAttribute("msg3", "Gun Origins Exported!");
        }
        else if ("exportCustomGun".equals(action)) {
            req.setAttribute("customExport", exportGunGeneric(gDaoCustom));
            req.setAttribute("msg4", "Custom Guns Exported!");
        }
        
        req.getRequestDispatcher("quickload.jsp").forward(req, resp);
    }

    private void loadVanilla(HttpServletRequest req, MaterialDAO dao) {
        String data = req.getParameter("vanillaData");
        int inserted = 0, skipped = 0;
        if (data != null) {
            List<Material> existing = dao.getAll();
            for (String line : data.split("\\r?\\n")) {
                String[] parts = line.split(",", 2);
                if (parts.length == 2) {
                    try {
                        String name = parts[0].trim();
                        int emc = Integer.parseInt(parts[1].trim());
                        boolean skip = existing.stream().anyMatch(e -> e.getName().equalsIgnoreCase(name) && e.getEmcValue() == emc);
                        if (skip) skipped++;
                        else {
                            dao.save(new Material(0, name, emc));
                            inserted++;
                        }
                    } catch (Exception e) { skipped++; }
                }
            }
        }
        req.setAttribute("msg1", "Loaded: " + inserted + " inserted, " + skipped + " skipped.");
    }

    private void loadGunGeneric(HttpServletRequest req, Object dao, String paramName, String msgAttr) {
        String data = req.getParameter(paramName);
        int inserted = 0, skipped = 0;
        if (data != null) {
            boolean isAttachment = dao instanceof AttachmentDAO;
            List<SubItem> existing = isAttachment ? ((AttachmentDAO)dao).getAll() : ((dal.GunDAO)dao).getAll();
            for (String line : data.split("\\r?\\n")) {
                String[] p = line.split(",");
                if (p.length >= 2) {
                    try {
                        String name = p[0].trim();
                        int count = 1;
                        int totalEmc = Integer.parseInt(p[1].trim());
                        String detailsStr = (p.length > 2) ? p[2].trim() : "";
                        
                        final int checkEmc = totalEmc;
                        boolean skip = existing.stream().anyMatch(e -> e.getName().equalsIgnoreCase(name) && e.getTotalEmc() == checkEmc);
                        if (skip) {
                            skipped++;
                            continue;
                        }

                        List<Map<String, Object>> details = new ArrayList<>();
                        if (!detailsStr.isEmpty()) {
                            for (String m : detailsStr.split("\\|")) {
                                String[] mq = m.split(":");
                                if (mq.length == 2) {
                                    Map<String, Object> d = new HashMap<>();
                                    d.put("name", mq[0].trim());
                                    d.put("qty", Integer.parseInt(mq[1].trim()));
                                    details.add(d);
                                }
                            }
                        }
                        if (isAttachment) ((AttachmentDAO)dao).save(new SubItem(0, name, count, totalEmc, details));
                        else ((dal.GunDAO)dao).save(new SubItem(0, name, count, totalEmc, details));
                        inserted++;
                    } catch (Exception e) { skipped++; }
                }
            }
        }
        req.setAttribute(msgAttr, "Loaded: " + inserted + " inserted, " + skipped + " skipped.");
    }

    private String exportGunGeneric(Object dao) {
        StringBuilder sb = new StringBuilder();
        boolean isAttachment = dao instanceof AttachmentDAO;
        List<SubItem> list = isAttachment ? ((AttachmentDAO)dao).getAll() : ((dal.GunDAO)dao).getAll();
        for (SubItem s : list) {
            sb.append(s.getName()).append(",").append(s.getTotalEmc());
            
            if (s.getMaterialDetails() != null && !s.getMaterialDetails().isEmpty()) {
                sb.append(",");
                boolean first = true;
                for (Map<String, Object> d : s.getMaterialDetails()) {
                    if (!first) sb.append("|");
                    sb.append(d.get("name")).append(":").append(d.get("qty"));
                    first = false;
                }
            }
            sb.append("\n");
        }
        return sb.toString();
    }
}
