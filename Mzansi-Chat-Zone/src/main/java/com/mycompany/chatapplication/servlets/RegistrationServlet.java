package com.mycompany.chatapplication.servlets;

import com.mycompany.chatapplication.utils.DBManager;
import com.mycompany.chatapplication.utils.PasswordUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/register")
public class RegistrationServlet extends HttpServlet {
    @Override protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }

    @Override protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        username = username == null ? "" : username.trim();
        if (!username.matches("[A-Za-z][A-Za-z0-9_.-]{2,23}")) {
            request.setAttribute("errorMessage", "Choose a username of 3–24 letters, numbers, dots, hyphens or underscores.");
        } else if (password == null || password.length() < 8 || password.length() > 128) {
            request.setAttribute("errorMessage", "Use a password of 8–128 characters.");
        } else {
            try {
                if (DBManager.createUser(username, PasswordUtil.hash(password))) {
                    response.sendRedirect(request.getContextPath() + "/login?registered=1");
                    return;
                }
                request.setAttribute("errorMessage", "That username is already taken. Please choose another.");
            } catch (SQLException ex) {
                getServletContext().log("Registration database error", ex);
                request.setAttribute("errorMessage", "Registration is temporarily unavailable. Please try again.");
            }
        }
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }
}
