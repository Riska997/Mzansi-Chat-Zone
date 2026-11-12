package com.mycompany.chatapplication.websocket;

import jakarta.websocket.server.HandshakeRequest;
import jakarta.websocket.HandshakeResponse;
import jakarta.websocket.server.ServerEndpointConfig;

/** Provides the HTTP login session to the WebSocket endpoint. */
public class SessionConfigurator extends ServerEndpointConfig.Configurator {
    @Override
    public void modifyHandshake(ServerEndpointConfig config, HandshakeRequest request, HandshakeResponse response) {
        config.getUserProperties().put("httpSession", request.getHttpSession());
        super.modifyHandshake(config, request, response);
    }
}
