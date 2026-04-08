package controller;

import dal.CleanDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;

@WebServlet("/cleandb")
public class CleanDBController extends HttpServlet {

    private final CleanDAO dao = new CleanDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setAttribute("tableCounts", dao.getTableCounts());
        req.getRequestDispatcher("cleandb.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String table = req.getParameter("table");
        String msg;
        if (table != null && !table.trim().isEmpty()) {
            int deleted = dao.clearTable(table.trim());
            if (deleted >= 0) {
                msg = "✓ Table [" + table + "] cleared — " + deleted + " row(s) removed.";
            } else {
                msg = "✗ Failed to clear [" + table + "]. Unknown table or DB error.";
            }
        } else {
            msg = "✗ No table specified.";
        }
        req.setAttribute("actionMsg", msg);
        req.setAttribute("tableCounts", dao.getTableCounts());
        req.getRequestDispatcher("cleandb.jsp").forward(req, resp);
    }
}
