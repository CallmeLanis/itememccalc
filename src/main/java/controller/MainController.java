package controller;

import dal.MaterialDAO;
import dal.AttachmentDAO;
import model.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;
import java.util.*;

@WebServlet("/main")
public class MainController extends HttpServlet {
    MaterialDAO dao = new MaterialDAO();
    AttachmentDAO aDao = new AttachmentDAO();

    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String actionStr = req.getParameter("action");
        if ("delSub".equals(actionStr)) {
            String idStr = req.getParameter("id");
            if (idStr != null) {
                try { aDao.delete(Integer.parseInt(idStr)); } catch (Exception e) {}
            }
            String origin = req.getParameter("origin");
            resp.sendRedirect("home".equals(origin) ? "main" : "saved");
            return;
        } else if ("editSub".equals(actionStr)) {
            String idStr = req.getParameter("id");
            if (idStr != null) {
                req.setAttribute("editId", Integer.parseInt(idStr));
            }
            String origin = req.getParameter("origin");
            if ("home".equals(origin)) {
                req.setAttribute("subItemList", aDao.getAll());
                req.setAttribute("materials", dao.getAll());
                req.getRequestDispatcher("home.jsp").forward(req, resp);
            } else {
                req.setAttribute("subItemList", aDao.getAll());
                req.getRequestDispatcher("saved.jsp").forward(req, resp);
            }
            return;
        }
        req.setAttribute("subItemList", aDao.getAll());
        req.setAttribute("materials", dao.getAll());
        req.getRequestDispatcher("home.jsp").forward(req, resp);
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");

        if ("saveSubItem".equals(action)) {
            saveSubItemLogic(req);
        } 
        else if ("updateSubItem".equals(action)) {
            try {
                int editId = Integer.parseInt(req.getParameter("editId"));
                String newName = req.getParameter("newName");
                int newCount = Integer.parseInt(req.getParameter("newCount"));
                if (editId > 0 && newCount > 0) {
                    SubItem old = aDao.getById(editId);
                    if (old != null) {
                        aDao.save(new SubItem(editId, newName, 1, old.getTotalEmc(), old.getMaterialDetails()));
                    }
                }
            } catch (Exception e) {}
            resp.sendRedirect("saved");
            return;
        }

        req.setAttribute("subItemList", aDao.getAll());
        req.setAttribute("materials", dao.getAll());
        req.getRequestDispatcher("home.jsp").forward(req, resp);
    }

    private void saveSubItemLogic(HttpServletRequest req) {
        String subName = req.getParameter("subItemName");
        int subCount = 1;
        
        int subItemTotalEmc = 0;
        List<Material> allMats = dao.getAll();
        List<Map<String, Object>> currentDetails = new ArrayList<>();

        for (Material m : allMats) {
            String qtyStr = req.getParameter("qty_" + m.getId());
            int qty = (qtyStr != null && !qtyStr.isEmpty()) ? Integer.parseInt(qtyStr) : 0;
            
            if (qty > 0) {
                int matCost = qty * m.getEmcValue();
                subItemTotalEmc += matCost;

                Map<String, Object> d = new HashMap<>();
                d.put("name", m.getName());
                d.put("qty", qty);
                d.put("totalMatCost", matCost);
                currentDetails.add(d);
            }
        }
        aDao.save(new SubItem(0, subName, subCount, subItemTotalEmc * subCount, currentDetails));
    }
}