<h1 align="center">🚀 SheepIt Render Farm on Railway</h1>

<p align="center">
  <img src="https://github.com/user-attachments/assets/e0e44a2b-ed0c-4ce3-bc78-b7541986f0c3" alt="SheepIt Render Farm Banner" width="600"/>
</p>

<p align="center">
  <a href="https://github.com/PreLar1/sheepit-renderfarm-to-railway-deployer/blob/main/lint.yml">
    <img src="https://github.com/PreLar1/sheepit-renderfarm-to-railway-deployer/blob/main/lint.yml/badge.svg" alt="GitHub Actions"/>
  </a>
  <a href="https://coff.ee/prelar1">
    <img src="https://github.com/user-attachments/assets/d36c21cd-81f7-4819-8604-6782c064adcd" alt="Buy Me A Coffee"/>
  </a>
</p>

<p align="center">
  <b>Render Blender projects at scale with SheepIt Render Farm, deployed effortlessly on Railway! 🎨</b>
</p>

---

## 🌟 What is This?

This project runs a **SheepIt Render Farm** client in a Docker container on **Railway**, allowing you to contribute CPU power to render Blender animations and earn points. It’s optimized for stability, easy to set up, and perfect for cloud-based rendering.

### Key Features
- 🛠️ **Simple Setup**: Deploy in minutes with Railway and GitHub.
- ⚡ **Robust Performance**: Uses 24 CPU cores and 24GB RAM.
- 📦 **Persistent Storage**: Stores Blender projects in a `/cache` volume.
- ✅ **Automated Checks**: GitHub Actions lints all configuration files.
- 🔄 **Auto-Restart**: Restarts on failure with up to 5 retries.

---

## 🚀 Get Started

### Prerequisites
- A **SheepIt Render Farm** account ([sign up here](https://www.sheepit-renderfarm.com/)).
- A **Railway** account ([create one here](https://railway.com/)).
- A **GitHub** repository to host this project.
- **Git** installed locally ([download here](https://git-scm.com/download/win)).

### Setup Steps
1. **Clone the Repository**:
   ```bash
   git clone https://github.com/PreLar1/sheepit-renderfarm-to-railway-deployer.git
   cd sheepit-railway

2. **Set GitHub repo secrets** (Settings → Secrets and variables → Actions → New repository secret):
     <table>
       <tr>
         <th>Secret</th>
         <th>Description</th>
         <th>Required</th>
       </tr>
       <tr>
         <td><code>RAILWAY_TOKEN</code></td>
         <td>A Railway account API token (Railway dashboard → Account Settings → Tokens)</td>
         <td>Yes</td>
       </tr>
     </table>
   - Then set your SheepIt credentials as Railway service variables (one-time, in the Railway dashboard, or via `railway variables set` from the CLI): `SHEEPIT_USERNAME`, `SHEEPIT_PASSWORD`. Optional: `SHEEPIT_CORES`, `SHEEPIT_MEMORY` (default 24 / 24G).

3. **Push to GitHub**:
   ```bash
   git add .
   git commit -m "Initial SheepIt client setup"
   git push origin main

4. **Deploy automatically via GitHub Actions**:
   - Every push to `main` triggers `.github/workflows/deploy.yml`, which installs the Railway CLI and runs `railway up`.
   - On the very first run, since no Railway project exists yet, the workflow creates one and saves its ID as a repo variable (`RAILWAY_PROJECT_ID`) so future runs reuse it — no manual project linking needed.
   - Watch the run under the repo's **Actions** tab to confirm deployment.

5. **Check SheepIt Dashboard**:
   - Log in to [SheepIt](https://www.sheepit-renderfarm.com/).
   - Verify your client is **Online** in "My Computers".
   - Watch for incrementing **Rendered Frames** and **Points earned**.

---

## 📂 Project Files

- **`Dockerfile`**: Builds the Docker image with Java 17 and Blender dependencies.
- **`start.sh`**: Launches the client with retries and error logging.
- **`client.properties`**: Configures core count, memory, and server settings.
- **`railway.yml`**: Defines the Railway service with volume and health check.
- **`lint.yml`**: GitHub Actions workflow for linting files.

---

## 🛠️ Troubleshooting

<details>
<summary><b>Renderer Fails (Missing Libraries)</b></summary>
<ul>
  <li>Check Railway logs for errors like <code>libxkbcommon.so.0: cannot open shared object</code>.</li>
  <li>Add missing libraries to <code>Dockerfile</code>, e.g.:
    <pre><code>RUN apt-get install -y libfontconfig1</code></pre>
  </li>
  <li>Redeploy after updating.</li>
</ul>
</details>

<details>
<summary><b>Client Blocked on SheepIt</b></summary>
<ul>
  <li>Verify <code>SHEEPIT_USERNAME</code> and <code>SHEEPIT_PASSWORD</code> in Railway.</li>
  <li>Check client limits (max 10) in SheepIt’s "My Computers".</li>
  <li>Try HTTP server in <code>client.properties</code>:
    <pre><code>client.server=http://client.sheepit-renderfarm.com</code></pre>
  </li>
  <li>Contact SheepIt support with <code>error.log</code>.</li>
</ul>
</details>

<details>
<summary><b>GitHub Actions Fails</b></summary>
<ul>
  <li>Ensure <code>railway.yml</code> is in the repository root.</li>
  <li>Check Actions logs for <code>ls -laR</code> and <code>find . -type f</code>.</li>
  <li>Update <code>lint.yml</code> if file is in a subdirectory:
    <pre><code>if [ -f ./config/railway.yml ]; then
      yamllint ./config/railway.yml
    fi</code></pre>
  </li>
</ul>
</details>

---

## 🤝 Contribute

Want to improve this project? Here’s how:
1. Fork the repository.
2. Create a branch: `git checkout -b my-feature`.
3. Commit changes: `git commit -m "Add feature"`.
4. Push: `git push origin my-feature`.
5. Open a pull request with a clear description.

---

<p align="center">
  <b>Happy Rendering! 🎥</b>
</p>
