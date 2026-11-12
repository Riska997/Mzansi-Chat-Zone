package com.mycompany.chatapplication.websocket;

import com.mycompany.chatapplication.utils.DBManager;
import jakarta.json.Json;
import jakarta.websocket.CloseReason;
import jakarta.websocket.OnClose;
import jakarta.websocket.OnError;
import jakarta.websocket.OnMessage;
import jakarta.websocket.OnOpen;
import jakarta.websocket.Session;
import jakarta.websocket.server.ServerEndpoint;
import jakarta.servlet.http.HttpSession;
import java.sql.SQLException;
import java.util.Set;
import java.util.concurrent.CopyOnWriteArraySet;

/** One shared group conversation; messages are validated and saved on the server. */
@ServerEndpoint(value = "/chat-socket", configurator = SessionConfigurator.class)
public class ChatEndpoint {
    private static final Set<Session> clients = new CopyOnWriteArraySet<>();

    @OnOpen
    public void onOpen(Session ws) {
        HttpSession http = (HttpSession) ws.getUserProperties().get("httpSession");
        String username = null;
        try { if (http != null) username = (String) http.getAttribute("username"); }
        catch (IllegalStateException ignored) { /* Expired session */ }
        if (username == null) {
            try { ws.close(new CloseReason(CloseReason.CloseCodes.VIOLATED_POLICY, "Sign in required")); }
            catch (Exception ignored) { }
            return;
        }
        ws.getUserProperties().put("username", username);
        ws.setMaxIdleTimeout(20 * 60 * 1000L);
        ws.setMaxTextMessageBufferSize(4096);
        clients.add(ws);
    }

    @OnMessage
    public void onMessage(String raw, Session ws) {
        String username = (String) ws.getUserProperties().get("username");
        HttpSession http = (HttpSession) ws.getUserProperties().get("httpSession");
        try {
            if (http == null || username == null || !username.equals(http.getAttribute("username"))) {
                ws.close(new CloseReason(CloseReason.CloseCodes.VIOLATED_POLICY, "Please sign in again"));
                return;
            }
        } catch (Exception e) {
            try { ws.close(new CloseReason(CloseReason.CloseCodes.VIOLATED_POLICY, "Session expired")); }
            catch (Exception ignored) { }
            return;
        }
        String content = raw == null ? "" : raw.strip();
        if (content.isEmpty() || content.length() > 1000) {
            ws.getAsyncRemote().sendText(Json.createObjectBuilder()
                .add("type", "error").add("message", "Message must contain 1–1000 characters.").build().toString());
            return;
        }
        try {
            DBManager.ChatMessage saved = DBManager.insertMessage(username, content);
            String payload = Json.createObjectBuilder().add("type", "message").add("id", saved.id)
                .add("sender", saved.sender).add("message", saved.content).add("time", saved.timestamp)
                .build().toString();
            for (Session client : clients) {
                if (client.isOpen()) client.getAsyncRemote().sendText(payload);
                else clients.remove(client);
            }
        } catch (SQLException ex) {
            ws.getAsyncRemote().sendText(Json.createObjectBuilder()
                .add("type", "error").add("message", "Message could not be saved. Please try again.")
                .build().toString());
            System.err.println("Chat message storage error: " + ex.getMessage());
        }
    }

    @OnClose
    public void onClose(Session ws) { clients.remove(ws); }

    @OnError
    public void onError(Session ws, Throwable ex) { clients.remove(ws); }
}
