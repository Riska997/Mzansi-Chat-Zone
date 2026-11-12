/* Real-time group chat; the authenticated Java server owns the sender identity. */
(() => {
  "use strict";
  const root = document.body;
  if (!root || !root.classList.contains("chat-page")) return;
  const contextPath = root.dataset.contextPath || "";
  const username = root.dataset.username || "";
  const $ = id => document.getElementById(id);
  const messageList = $("message-list");
  const messageScroller = $("message-scroller");
  const input = $("message-input");
  const form = $("message-form");
  const sendButton = $("send-button");
  const error = $("chat-error");
  const seen = new Set();
  let socket = null;
  let reconnectTimer = null;
  let retryCount = 0;
  let active = true;
  $("my-username").textContent = username;
  $("my-avatar").textContent = username.charAt(0).toUpperCase() || "M";

  function setConnection(state, label) {
    const indicator = $("connection-status");
    indicator.className = "connection-status " + state;
    $("connection-label").textContent = label;
    updateSendButton();
  }
  function updateSendButton() {
    sendButton.disabled = !socket || socket.readyState !== WebSocket.OPEN || !input.value.trim();
  }
  function showError(message) { error.textContent = message; error.hidden = false; }
  function clearError() { error.hidden = true; error.textContent = ""; }
  function formatTime(value) {
    const date = new Date(value);
    return Number.isFinite(date.getTime())
      ? date.toLocaleTimeString(undefined, {hour:"2-digit", minute:"2-digit"}) : "";
  }
  function makeText(tag, text, css) {
    const el = document.createElement(tag);
    el.textContent = text;
    if (css) el.className = css;
    return el;
  }
  function addMessage(data) {
    if (!data || typeof data.id !== "number" || typeof data.message !== "string" || typeof data.sender !== "string") return;
    if (seen.has(data.id)) return;
    seen.add(data.id);
    const mine = data.sender === username;
    const row = makeText("article", "", "message-row" + (mine ? " mine" : ""));
    row.append(makeText("div", data.sender.charAt(0).toUpperCase(), "avatar msg-avatar"));
    const bubble = makeText("div", "", "message-bubble");
    const meta = makeText("div", "", "message-meta");
    meta.append(makeText("strong", mine ? "You" : data.sender));
    const time = document.createElement("time");
    time.textContent = formatTime(data.time);
    if (data.time) time.dateTime = data.time;
    meta.append(time);
    bubble.append(meta, makeText("p", data.message, "message-text"));
    row.append(bubble);
    row.dataset.messageId = String(data.id);
    const next = [...messageList.children].find(el => Number(el.dataset.messageId) > data.id);
    if (next) messageList.insertBefore(row, next);
    else messageList.append(row);
    while (messageList.children.length > 100) {
      const old = messageList.firstElementChild;
      if (old) { messageList.removeChild(old); }
    }
    messageScroller.scrollTop = messageScroller.scrollHeight;
  }
  async function loadHistory() {
    try {
      const response = await fetch(contextPath + "/messages", {credentials:"same-origin",cache:"no-store"});
      if (response.status === 401) { window.location.assign(contextPath + "/login"); return; }
      if (!response.ok) throw new Error("Could not load chat history");
      const messages = await response.json();
      if (!Array.isArray(messages)) throw new Error("Invalid chat history response");
      // History and live messages are deduplicated by ID and inserted in order.
      for (const data of messages) addMessage(data);
    } catch (ex) { showError("Could not load earlier messages. New messages may still arrive."); }
  }
  function connect() {
    if (!active) return;
    setConnection("connecting", "Connecting");
    const protocol = location.protocol === "https:" ? "wss:" : "ws:";
    socket = new WebSocket(protocol + "//" + location.host + contextPath + "/chat-socket");
    socket.addEventListener("open", () => {
      retryCount = 0;
      setConnection("connected", "Connected");
      clearError();
      loadHistory();
    });
    socket.addEventListener("message", event => {
      try {
        const data = JSON.parse(event.data);
        if (data.type === "message") addMessage(data);
        else if (data.type === "error") showError(data.message || "Your message could not be sent.");
      } catch { showError("A message could not be displayed."); }
    });
    socket.addEventListener("close", event => {
      setConnection("disconnected", "Disconnected");
      if (event.code === 1008) {
        showError("Your chat session has ended. Please sign in again.");
        setTimeout(() => window.location.assign(contextPath + "/login"), 1100);
        return;
      }
      if (active) {
        showError("Connection lost. Trying to reconnect…");
        retryCount++;
        reconnectTimer = setTimeout(connect, Math.min(1000 * Math.pow(2, Math.min(retryCount, 4)), 15000));
      }
    });
    socket.addEventListener("error", () => { showError("Cannot connect to the chat server at the moment."); });
  }
  form.addEventListener("submit", event => {
    event.preventDefault();
    const message = input.value.trim();
    if (!message || message.length > 1000) { showError("Message must be 1–1000 characters."); return; }
    if (!socket || socket.readyState !== WebSocket.OPEN) { showError("Please reconnect before sending."); return; }
    try {
      socket.send(message);
      input.value = "";
      input.style.height = "auto";
      $("character-count").textContent = "0 / 1000";
      clearError();
      updateSendButton();
      input.focus();
    } catch { showError("Your message was not sent. Try again."); }
  });
  input.addEventListener("input", () => {
    input.style.height = "auto";
    input.style.height = Math.min(input.scrollHeight, 120) + "px";
    $("character-count").textContent = input.value.length + " / 1000";
    updateSendButton();
  });
  input.addEventListener("keydown", event => {
    if (event.key === "Enter" && !event.shiftKey && !event.isComposing) {
      event.preventDefault();
      form.requestSubmit();
    }
  });
  window.addEventListener("beforeunload", () => {
    active = false;
    if (reconnectTimer) clearTimeout(reconnectTimer);
    if (socket) socket.close(1000);
  });
  loadHistory();
  connect();
})();
