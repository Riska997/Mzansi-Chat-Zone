package com.mycompany.chatapplication.servlets;

import com.mycompany.chatapplication.utils.DBManager;
import com.mycompany.chatapplication.utils.PasswordUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    @Override protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    @Override protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        username = username == null ? "" : username.trim();
        if (password == null || username.length() > 24 || !username.matches("[A-Za-z][A-Za-z0-9_.-]{2,23}")) {
            request.setAttribute("errorMessage", "Incorrect username or password.");
        } else {
            try {
                String hash = DBManager.passwordHashFor(username);
                if (hash != null && PasswordUtil.verify(password, hash)) {
                    HttpSession previous = request.getSession(false);
                    if (previous != null) previous.invalidate();
                    HttpSession session = request.getSession(true);
                    session.setAttribute("username", username);
                    session.setMaxInactiveInterval(30 * 60);
                    response.sendRedirect(request.getContextPath() + "/conversations");
                    return;
                }
                request.setAttribute("errorMessage", "Incorrect username or password.");
            } catch (SQLException ex) {
                getServletContext().log("Login database error", ex);
                request.setAttribute("errorMessage", "Sign-in is temporarily unavailable. Please try again.");
            }
        }
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }
}
