<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!doctype html>
<html lang="en">
<head>
  <link rel="icon" type="image/x-icon" href="${pageContext.request.contextPath}/favicon.ico?v=mz-original-2026">
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Community chat | Mzansi Chat Zone</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/style.css">
</head>
<body class="chat-page" data-context-path="${pageContext.request.contextPath}" data-username="${username}">
  <main class="chat-app" aria-label="Mzansi Chat Zone application">
    <aside class="chat-sidebar" aria-label="Chat navigation">
      <a class="brand" href="${pageContext.request.contextPath}/home"><img class="brand-logo" src="${pageContext.request.contextPath}/logo.png" alt="" width="38" height="38"> <span>mzansi<span class="brand-soft">chat.</span></span></a>
      <div class="sidebar-title"><span class="eyebrow">Your space</span><h2>Conversations</h2></div>
      <div class="room-tile selected" aria-current="page"><div class="room-icon" aria-hidden="true">✦</div><div><strong>Community room</strong><span>General conversation</span></div></div>
      <div class="sidebar-spacer"></div>
      <div class="sidebar-guide"><span class="guide-icon" aria-hidden="true">♡</span><strong>A friendly reminder</strong><p>Messages in this room are visible to everyone who signs in. Please keep conversations respectful.</p></div>
      <div class="profile-bottom"><div class="avatar small" id="my-avatar" aria-hidden="true">M</div><div class="profile-detail"><strong id="my-username">My account</strong><span>Signed in</span></div><a href="${pageContext.request.contextPath}/home?action=logout" class="logout" title="Sign out">Sign out</a></div>
    </aside>
    <section class="conversation" aria-label="Community room conversation">
      <header class="conversation-header">
        <div class="room-avatar" aria-hidden="true">✦</div>
        <div class="conversation-heading"><h1>Community room</h1><p>Share ideas, messages and greetings.</p></div>
        <div id="connection-status" class="connection-status connecting" role="status"><span class="status-dot"></span><span id="connection-label">Connecting</span></div>
      </header>
      <div class="message-scroller" id="message-scroller" tabindex="0" aria-label="Messages">
        <div class="conversation-intro"><span class="intro-icon" aria-hidden="true">✳</span><h2>Welcome to the conversation</h2><p>This is a shared room. Say hello to start chatting.</p></div>
        <div class="message-list" id="message-list" role="log" aria-live="polite" aria-relevant="additions"></div>
      </div>
      <div class="composer-area">
        <p class="composer-error" id="chat-error" role="alert" hidden></p>
        <form id="message-form" class="composer" autocomplete="off">
          <label class="visually-hidden" for="message-input">Write a message</label>
          <textarea id="message-input" rows="1" maxlength="1000" placeholder="Write a message…" aria-label="Write a message" required></textarea>
          <button type="submit" id="send-button" class="send-button" aria-label="Send message" disabled><span class="send-text">Send</span><span aria-hidden="true">↗</span></button>
        </form>
        <div class="composer-note"><span>Enter to send · Shift + Enter for a new line</span><span id="character-count">0 / 1000</span></div>
      </div>
    </section>
  </main>
  <script src="${pageContext.request.contextPath}/chat.js" defer></script>
</body>
</html>
