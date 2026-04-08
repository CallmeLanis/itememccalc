package controller;

import dal.MaterialDAO;
import model.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;
import java.util.*;

@WebServlet("/fullgun")
public class FullGunController extends HttpServlet {
    MaterialDAO dao = new MaterialDAO();
    dal.GunDAO gDao = new dal.GunDAO("custom_guns");
    dal.AttachmentDAO aDao = new dal.AttachmentDAO();
    dal.GunDAO originDao = new dal.GunDAO("gun_origins");

    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String actionStr = req.getParameter("action");
        if ("delGun".equals(actionStr)) {
            String idStr = req.getParameter("id");
            if (idStr != null) {
                try { gDao.delete(Integer.parseInt(idStr)); } catch (Exception e) {}
            }
            resp.sendRedirect("fullgun");
            return;
        }
        req.setAttribute("gunList", gDao.getAll());
        req.setAttribute("basicGunList", originDao.getAll());
        req.setAttribute("subItemList", aDao.getAll());
        req.setAttribute("materials", dao.getAll());
        req.getRequestDispatcher("fullgun.jsp").forward(req, resp);
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        
        if ("calcGun".equals(action)) {
            String gunName = req.getParameter("gunName");
            int totalEmc = 0;
            List<Map<String, Object>> details = new ArrayList<>();
            
            // Calc Vanilla Mats
            List<Material> allMats = dao.getAll();
            for (Material m : allMats) {
                String qtyStr = req.getParameter("mat_" + m.getId());
                int qty = (qtyStr != null && !qtyStr.isEmpty()) ? Integer.parseInt(qtyStr) : 0;
                if (qty > 0) {
                    int cost = qty * m.getEmcValue();
                    totalEmc += cost;
                    Map<String, Object> d = new HashMap<>();
                    d.put("name", m.getName());
                    d.put("qty", qty);
                    d.put("value", cost);
                    details.add(d);
                }
            }
            
            // Calc Attachments
            List<SubItem> subItemList = aDao.getAll();
            if (subItemList != null) {
                for (SubItem s : subItemList) {
                    String qtyStr = req.getParameter("att_" + s.getId());
                    int qty = (qtyStr != null && !qtyStr.isEmpty()) ? Integer.parseInt(qtyStr) : 0;
                    if (qty > 0) {
                        int cost = qty * s.getTotalEmc();
                        totalEmc += cost;
                        Map<String, Object> d = new HashMap<>();
                        d.put("name", s.getName());
                        d.put("qty", qty);
                        d.put("value", cost);
                        details.add(d);
                    }
                }
            }
            
            // Calc Gun Origins
            List<SubItem> basicGuns = originDao.getAll();
            if (basicGuns != null) {
                for (SubItem g : basicGuns) {
                    String qtyStr = req.getParameter("origin_" + g.getId());
                    int qty = (qtyStr != null && !qtyStr.isEmpty()) ? Integer.parseInt(qtyStr) : 0;
                    if (qty > 0) {
                        int cost = qty * g.getTotalEmc();
                        totalEmc += cost;
                        Map<String, Object> d = new HashMap<>();
                        d.put("name", g.getName());
                        d.put("qty", qty);
                        d.put("value", cost);
                        details.add(d);
                    }
                }
            }
            
            gDao.save(new SubItem(0, gunName, 1, totalEmc, details));
        }

        resp.sendRedirect("fullgun");
    }
}
