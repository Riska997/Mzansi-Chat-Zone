<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!doctype html>
<html lang="en">
<head>
  <link rel="icon" type="image/x-icon" href="${pageContext.request.contextPath}/favicon.ico?v=mz-original-2026"><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1"><title>Home | Mzansi Chat Zone</title><link rel="stylesheet" href="${pageContext.request.contextPath}/style.css"></head>
<body class="home-page">
  <header class="site-header"><a class="brand" href="${pageContext.request.contextPath}/home"><img class="brand-logo" src="${pageContext.request.contextPath}/logo.png" alt="" width="38" height="38"><span>mzansi<span class="brand-soft">chat.</span></span></a><a class="subtle-link" href="${pageContext.request.contextPath}/home?action=logout">Sign out</a></header>
  <main class="home-content"><span class="eyebrow">Welcome back</span><h1>Hello, ${username}.</h1><p>Your community conversation is ready. Come in and say hello.</p><a class="primary-button" href="${pageContext.request.contextPath}/conversations">Open the chat room <span aria-hidden="true">→</span></a><div class="home-note"><strong>A shared conversation</strong><p>Everyone who signs in can see messages posted in this room. Please avoid sharing private information.</p></div></main>
</body>
</html>
