package controller;

import dal.MaterialDAO;
import dal.AttachmentDAO;
import model.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;
import java.util.*;

@WebServlet("/gunorigin")
public class GunOriginController extends HttpServlet {
    dal.GunDAO gDao = new dal.GunDAO("gun_origins");
    MaterialDAO dao = new MaterialDAO();
    AttachmentDAO aDao = new AttachmentDAO();

    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String actionStr = req.getParameter("action");
        if ("delOrigin".equals(actionStr)) {
            String idStr = req.getParameter("id");
            if (idStr != null) {
                try { gDao.delete(Integer.parseInt(idStr)); } catch (Exception e) {}
            }
            resp.sendRedirect("gunorigin");
            return;
        }
        req.setAttribute("originList", gDao.getAll());
        req.setAttribute("subItemList", aDao.getAll());
        req.setAttribute("materials", dao.getAll());
        req.getRequestDispatcher("gunorigin.jsp").forward(req, resp);
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        
        if ("calcOrigin".equals(action)) {
            String originName = req.getParameter("originName");
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
            
            gDao.save(new SubItem(0, originName, 1, totalEmc, details));
        }

        resp.sendRedirect("gunorigin");
    }
}
