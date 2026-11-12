<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!doctype html>
<html lang="en">
<head>
  <link rel="icon" type="image/x-icon" href="${pageContext.request.contextPath}/favicon.ico?v=mz-original-2026">
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Create account | Mzansi Chat Zone</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/style.css">
</head>
<body class="auth-page">
  <main class="auth-layout">
    <section class="auth-intro" aria-label="About Mzansi Chat Zone">
      <a class="brand brand-inverse" href="${pageContext.request.contextPath}/login"><img class="brand-logo" src="${pageContext.request.contextPath}/logo.png" alt="" width="38" height="38"> <span>mzansi<span class="brand-soft">chat.</span></span></a>
      <div class="auth-intro-body">
        <span class="eyebrow light">Join the conversation</span>
        <h1>Make some space<br>for conversation<span class="hero-period">.</span></h1>
        <p>Create your account, share a message, and connect with others in the community room.</p>
        <div class="illustration" aria-hidden="true"><div class="illustration-bubble one">Have a question?</div><div class="illustration-bubble two">We’re here 👋</div><div class="illustration-bubble three">Welcome ✦</div></div>
      </div>
    </section>
    <section class="auth-panel">
      <div class="auth-card">
        <p class="eyebrow">Let’s get started</p>
        <h2>Create an account</h2>
        <p class="auth-description">Choose a username and password to join the shared chat room.</p>
        <% if (request.getAttribute("errorMessage") != null) { %>
          <div class="notice error" role="alert"><%= request.getAttribute("errorMessage") %></div>
        <% } %>
        <form method="post" action="${pageContext.request.contextPath}/register" class="auth-form">
          <label for="username">Username</label>
          <input id="username" name="username" type="text" placeholder="e.g. risca_97" minlength="3" maxlength="24" pattern="[A-Za-z][A-Za-z0-9_.-]{2,23}" autocomplete="username" required autofocus>
          <span class="field-hint">3–24 characters. Start with a letter; numbers, dots, hyphens and underscores are allowed.</span>
          <label for="password">Password</label>
          <input id="password" name="password" type="password" placeholder="At least 8 characters" minlength="8" maxlength="128" autocomplete="new-password" required>
          <span class="field-hint">Use a unique password of at least 8 characters.</span>
          <button class="primary-button full" type="submit">Create account <span aria-hidden="true">→</span></button>
        </form>
        <p class="auth-switch">Already registered? <a href="${pageContext.request.contextPath}/login">Sign in</a></p>
      </div>
    </section>
  </main>
</body>
</html>
