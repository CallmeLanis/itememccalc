package controller;

import dal.AttachmentDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;

@WebServlet("/saved")
public class SavedController extends HttpServlet {
    AttachmentDAO aDao = new AttachmentDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setAttribute("subItemList", aDao.getAll());
        req.getRequestDispatcher("saved.jsp").forward(req, resp);
    }
}
