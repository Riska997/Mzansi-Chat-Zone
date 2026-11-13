# Mzansi Chat Zone 

A working, responsive group-chat web application based on the original **ChatApplication** Java/Jakarta EE project. The original app name, page flow and Java WebSocket/Servlet architecture are preserved. The redesigned screens use **espresso, terracotta, olive and warm cream**—no blue/purple dashboard theme.

## What it does

- User registration and sign-in, with salted PBKDF2 password hashes and session cookies
- **One shared community chat room** (not private messages)
- Real-time delivery to connected users using Java WebSockets
- Last 100 saved messages displayed on entry/reconnect
- Responsive login, registration, welcome, and chat screens
- User-friendly connection indicator, message times, Enter to send, Shift+Enter for a new line, validation
- Local embedded H2 database for development; PostgreSQL for hosted deployment

**Important:** This is a portfolio/demo version of a chat app. It has no private conversations, file/camera upload, admin moderation, password recovery, anti-spam throttling or account verification. Do not ask people to share sensitive information. Host with HTTPS. Before inviting untrusted users to a public service, add rate limiting, moderation and an abuse/privacy policy.

## Stack

- **Frontend:** Existing Java JSP pages, HTML, CSS, vanilla JavaScript
- **Backend:** Java 17, Jakarta EE 10, Servlets, WebSockets, Payara Micro 6
- **Local database:** H2 (automatically created in `chat-data/`)
- **Cloud database:** Supabase PostgreSQL using the PostgreSQL JDBC driver
- **Build:** Maven, WAR; **deployment:** Docker on Render or Railway

### Local development (without an external database)

**Option A — IntelliJ + Payara/GlassFish server**
1. Extract the ZIP and open the folder containing `pom.xml` as a Maven project in IntelliJ.
2. Use **JDK 17** for the project. If IntelliJ is using JDK 27, you can still compile for Java 17, but running Payara 6 is safest on JDK 17 or its official Docker image.
3. Run `mvn clean package` (IntelliJ Maven tool window or terminal). This should generate `target/chat.war`.
4. Run/deploy the WAR on **Payara 6** or a compatible Jakarta EE 10 application server, using a context path such as `/chat`.
5. Open `http://localhost:8080/chat/` (replace the path/port with your local server's settings).
6. Register two different usernames, then sign into two browsers or an incognito window. Test live messages between them and refresh to see saved history.

**Option B — Docker (recommended for reproducing production)**
```bash
docker build -t mzansi-chat .
docker run --rm -p 8080:8080 mzansi-chat
```
Visit `http://localhost:8080/`. Data stored in local H2 inside a disposable container is **not durable** if you remove the container. For persistent online messages use PostgreSQL as below.

### Prepare a PostgreSQL database (Supabase)

1. Create a Supabase project. In **Connect**, select the **Session pooler** (IPv4 compatible) connection method, usually on port 5432.
2. Copy the **actual pooler host, username, database name and password** from Supabase. Do not guess host names.
3. Set these environment variables on your Java hosting platform:

   | Variable | Example / description |
   |---|---|
   | `DB_URL` | `jdbc:postgresql://YOUR_POOLER_HOST:5432/postgres?sslmode=require` |
   | `DB_USER` | `postgres.YOUR_PROJECT_REF` (use the exact username supplied by Supabase) |
   | `DB_PASSWORD` | Your Supabase database password (secret) |
   | `PORT` | `8080` if your host requests an explicit listening port |

4. The Java app creates `users` and `messages` database tables on first use. The account password is hashed; the database password stays in backend environment settings.
5. Do **not** put database credentials in `chat.js`, JSPs, or GitHub.

**Database migration note:** The original project included broken JPA configuration and plaintext-password storage. This repaired demo uses its own JDBC `users` / `messages` schema. Existing user data from the original schema is **not automatically imported**.

### Deploy the complete application (recommended: Render Docker)

1. Upload this folder (including the `Dockerfile` and `pom.xml`) to a **separate GitHub repository**.
2. On Render, choose **New → Web Service → Connect repository**.
3. Select **Docker** as the runtime, Dockerfile path `./Dockerfile`, and the desired service plan.
4. Add `DB_URL`, `DB_USER`, `DB_PASSWORD` as **secret environment variables**; set `PORT=8080` where appropriate.
5. Deploy. Once live, open its Render HTTPS URL, register an account and test messages with a second account/device.
6. Copy the live URL into your portfolio. It will be a **separate HTTPS address**, linked from `https://riska997.github.io/`. You cannot host this complete Java backend using GitHub Pages.

**Alternative: Railway** can build this same Dockerfile. Configure the three database environment variables, expose port 8080, and generate a public service domain. Monitor resource usage and credit limits.

**Important hosting limitations:** Render's Free web services can sleep when idle, temporarily breaking WebSocket connections. Railway's free service has credit and memory limits and may not be sufficient for Payara Micro. The app will try to reconnect, but either host may need a paid tier for continuous use. This is not guaranteed to remain free indefinitely.

### Deployment choices

| Your platform | Use for this exact project? | Explanation |
|---|---|---|
| **Render** | **Yes — recommended backend+frontend together** | Deploy WAR inside Payara Docker; serves JSP, CSS, JS and WebSocket endpoint. |
| **Railway** | **Yes — alternative** | Same Dockerfile, watch memory and pricing. |
| **Supabase** | **Yes — database** | Hosted PostgreSQL, separate from the Java server. |
| Vercel | Not required | The site is already rendered by JSP inside the Java app. Splitting frontend would be unnecessary. |
| Firebase Hosting | Not required | Static hosting alone cannot execute Java Servlets/WebSockets. |
| Cloudflare | Optional | CDN/DNS/custom domain later, not needed for a working chat app. |
| GitHub Pages | Portfolio link only | You can link to the chat's Render/Railway URL from your portfolio. |

### Notable fixes from the original uploaded project

- Repaired invalid login query and nonfunctional persistence-unit configuration
- Unified sessions (`username`) across login, home, and conversations
- Fixed wrong URL mappings, missing welcome page, broken `chat.js` path and element IDs
- Replaced broken JSON decoder with authenticated text WebSocket messages
- Ensured chat messages are saved and broadcast to **sender and other connected clients**
- Removed the unused Camera link (the original camera page was not implemented)
- Removed redundant Spring filter configuration (Spring is not a dependency)
- Removed old JPA persistence config in favour of minimal JDBC access

### How to confirm it works

- Register first account, then log in successfully.
- Register a second account in another browser/incognito session.
- Both users open **Community room** and see the `Connected` indicator.
- Send one message from each account: both users should see both messages.
- Refresh both browsers: saved messages should still appear.
- Sign out and revisit `/conversations`: you should be redirected to `/login`.
- Try sending an empty or overly long message: it should be rejected.

**Troubleshooting:** If registration or messages fail, check the Java server logs and DB environment variables. If the page opens but chat says Disconnected, check that your host supports inbound WebSocket connections and that traffic is reaching the same Java service. If deployed on a sleeping free instance, the first request after inactivity can take longer.
