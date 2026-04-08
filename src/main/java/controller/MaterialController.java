package controller;

import dal.MaterialDAO;
import model.Material;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;

@WebServlet("/material")
public class MaterialController extends HttpServlet {
    MaterialDAO dao = new MaterialDAO();

    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if ("edit".equals(action)) {
            req.setAttribute("itemEdit", dao.getById(Integer.parseInt(req.getParameter("id"))));
        } else if ("delete".equals(action)) {
            dao.delete(Integer.parseInt(req.getParameter("id")));
            resp.sendRedirect("material"); return;
        }
        req.setAttribute("materials", dao.getAll());
        req.getRequestDispatcher("material.jsp").forward(req, resp);
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idStr = req.getParameter("id");
        int id = (idStr == null || idStr.isEmpty()) ? 0 : Integer.parseInt(idStr);
        dao.save(new Material(id, req.getParameter("name"), Integer.parseInt(req.getParameter("emc"))));
        resp.sendRedirect("material");
    }
}