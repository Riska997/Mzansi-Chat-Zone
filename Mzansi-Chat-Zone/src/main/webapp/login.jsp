<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!doctype html>
<html lang="en">
<head>
  <link rel="icon" type="image/x-icon" href="${pageContext.request.contextPath}/favicon.ico?v=mz-original-2026">
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Sign in | Mzansi Chat Zone</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/style.css">
</head>
<body class="auth-page">
  <main class="auth-layout">
    <section class="auth-intro" aria-label="About Mzansi Chat Zone">
      <a class="brand brand-inverse" href="${pageContext.request.contextPath}/login" aria-label="Mzansi Chat Zone home"><img class="brand-logo" src="${pageContext.request.contextPath}/logo.png" alt="" width="38" height="38"> <span>mzansi<span class="brand-soft">chat.</span></span></a>
      <div class="auth-intro-body">
        <span class="eyebrow light">A place to connect</span>
        <h1>Good conversation<br>starts here<span class="hero-period">.</span></h1>
        <p>Join a simple community chat where you can share a message and see replies as they arrive.</p>
        <div class="illustration" aria-hidden="true"><div class="illustration-bubble one">Hello there! 👋</div><div class="illustration-bubble two">Hi, welcome in ☀</div><div class="illustration-bubble three">Let’s chat ✦</div></div>
      </div>
      </section>
    <section class="auth-panel">
      <div class="auth-card">
        <p class="eyebrow">Welcome back</p>
        <h2>Sign in to chat</h2>
        <p class="auth-description">Enter your details to join the conversation.</p>
        <% if (request.getAttribute("errorMessage") != null) { %>
          <div class="notice error" role="alert"><%= request.getAttribute("errorMessage") %></div>
        <% } %>
        <% if ("1".equals(request.getParameter("registered"))) { %>
          <div class="notice success" role="status">Account created. You can sign in now.</div>
        <% } %>
        <form method="post" action="${pageContext.request.contextPath}/login" class="auth-form">
          <label for="username">Username</label>
          <input id="username" name="username" type="text" placeholder="Enter your username" minlength="3" maxlength="24" pattern="[A-Za-z][A-Za-z0-9_.-]{2,23}" autocomplete="username" required autofocus>
          <label for="password">Password</label>
          <input id="password" name="password" type="password" placeholder="Enter your password" autocomplete="current-password" required>
          <button class="primary-button full" type="submit">Sign in <span aria-hidden="true">→</span></button>
        </form>
        <p class="auth-switch">New to Mzansi Chat Zone? <a href="${pageContext.request.contextPath}/register">Create an account</a></p>
      </div>
    </section>
  </main>
</body>
</html>
