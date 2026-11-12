package com.mycompany.chatapplication.servlets;

import com.mycompany.chatapplication.utils.DBManager;
import jakarta.json.Json;
import jakarta.json.JsonArrayBuilder;
import jakarta.json.JsonObjectBuilder;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

/** Returns the 100 most recent messages to signed-in users. */
@WebServlet("/messages")
public class MessagesServlet extends HttpServlet {
    @Override protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            response.sendError(401, "Sign in required");
            return;
        }
        response.setCharacterEncoding("UTF-8");
        response.setContentType("application/json");
        response.setHeader("Cache-Control", "no-store");
        try {
            JsonArrayBuilder array = Json.createArrayBuilder();
            for (DBManager.ChatMessage m : DBManager.recentMessages()) {
                JsonObjectBuilder obj = Json.createObjectBuilder()
                    .add("id", m.id).add("sender", m.sender).add("message", m.content).add("time", m.timestamp);
                array.add(obj);
            }
            response.getWriter().write(array.build().toString());
        } catch (SQLException ex) {
            getServletContext().log("Could not load messages", ex);
            if (!response.isCommitted()) response.sendError(503, "Chat history unavailable");
        }
    }
}
