package controller;

import dal.MaterialDAO;
import dal.AttachmentDAO;
import dal.GunDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;

@WebServlet("/overview")
public class OverviewController extends HttpServlet {
    MaterialDAO matDao = new MaterialDAO();
    AttachmentDAO attDao = new AttachmentDAO();
    GunDAO originDao = new GunDAO("gun_origins");
    GunDAO customDao = new GunDAO("custom_guns");

    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setAttribute("materials", matDao.getAll());
        req.setAttribute("attachments", attDao.getAll());
        req.setAttribute("basicGunList", originDao.getAll());
        req.setAttribute("gunList", customDao.getAll());
        
        req.getRequestDispatcher("overview.jsp").forward(req, resp);
    }
}
