---
name: google-setup
description: "One-time setup: install gcloud CLI, install gws CLI, authenticate, and verify connection."
---

# Google - Setup Guide

> **One-time setup.** Once complete, the agent uses SKILL.md for all workflows. This file is not needed again.

## Setup Paths

There are two ways to complete setup:

| Path | Steps | When to Use |
|---|---|---|
| **Fast path** (recommended) | 4 steps | First-time setup, user has admin access |
| **Manual fallback** | 7 steps | `gws auth setup` fails, or user wants explicit control |

The agent should always attempt the fast path first. If `gws auth setup` fails at any point, switch to the manual fallback starting at the step that corresponds to where things broke.

---

## Agent Guidance Rules

> [!IMPORTANT]
> **If something goes wrong during setup,** the agent must try to resolve it automatically first. Retry commands, try alternative approaches, check error messages, and attempt fixes independently. Only after exhausting automatic solutions should the agent fall back to guiding the user manually. When that happens, switch to step-by-step guide mode: one action at a time, tell the user exactly what to do and what they should see, and ask them to confirm with **'done'** before moving on.

**Browser confirmation protocol:** Every time the agent opens a browser URL (using `open` or `start`), immediately ask:

> "Did a browser window open? If not, let me know and I'll open it again. Once it's open, here's what to do: [instructions]"

Never assume a browser opened successfully. Always confirm before giving the next set of instructions.

---

## Fast Path (Recommended)

### Checklist

- [ ] Step 1: Install Google Cloud CLI (`gcloud`)
- [ ] Step 2: Install Google Workspace CLI (`gws`)
- [ ] Step 3: Run `gws auth setup` (handles project, APIs, OAuth, and login)
- [ ] Step 4: Verify connection

---

### Step 1: Install Google Cloud CLI

**macOS:**
```bash
brew install google-cloud-sdk
```

**Windows (PowerShell):**
```powershell
(New-Object Net.WebClient).DownloadFile("https://dl.google.com/dl/cloudsdk/channels/rapid/GoogleCloudSDKInstaller.exe", "$env:TEMP\GoogleCloudSDKInstaller.exe")
& "$env:TEMP\GoogleCloudSDKInstaller.exe"
```

> [!NOTE]
> For Linux or alternative install methods, see the [official gcloud installation guide](https://cloud.google.com/sdk/docs/install-sdk).

Verify:

```bash
gcloud --version
```

Tell the user:

> "Installing the Google Cloud CLI - this takes a couple of minutes.
>
> I'll handle the download automatically."

---

### Step 2: Install Google Workspace CLI

**macOS:**
```bash
brew install googleworkspace-cli
```

**Windows (PowerShell):**
```powershell
npm install -g @googleworkspace/cli
```

> [!NOTE]
> **Alternative install methods:**
> - **GitHub Releases** (any OS): Download the pre-built binary from [github.com/googleworkspace/cli/releases](https://github.com/googleworkspace/cli/releases)
> - **npm** (any OS): `npm install -g @googleworkspace/cli`
> - **Cargo** (build from source): `cargo install gws`

Verify:

```bash
gws --version
```

This step is fully automated - no user action needed.

---

### Step 3: Run `gws auth setup`

This single command handles GCP project creation, API enabling, OAuth consent screen, client credentials, and authentication in one interactive flow.

```bash
gws auth setup
```

**Agent flow:**
1. First, authenticate gcloud if not already authenticated:
   ```bash
   gcloud auth login
   ```
   This opens a browser. Tell the user:
   > "A browser window is opening for Google sign-in. Log in with your Google account and approve access. Tell me **'done'** when you see the confirmation screen."

2. Instruct the user to run `gws auth setup` **IN THEIR OWN TERMINAL**.
   The agent environment cannot handle the interactive scope selection TUI that appears during this process.
   
   Tell the user:
   > "Please open your terminal and run: `gws auth setup`
   > This handles everything automatically, but it will open a few browser windows.
   > 
   > Important: When configuring the OAuth consent screen in the browser:
   > 1. Select **Internal** for the User Type (this skips annoying app verification)
   > 2. Accept the default scopes when the CLI prompts you
   > 
   > Tell me **'done'** when the setup finishes."

Tell the user:

> "I'm running the Google Workspace setup. This handles everything automatically, but it will open a few browser windows for your approval.
>
> Check all the scope boxes and click **Continue**.
>
> Tell me **'done'** when the browser shows a success page."

Wait for user confirmation.

> [!WARNING]
> **Scope limit for unverified apps:** The OAuth app is in "testing mode," which limits consent to ~25 scopes. The 6 default services (Drive, Gmail, Calendar, Sheets, Docs, Meet) with the "Recommended" preset use ~28 scopes, which is within the limit. Do NOT use `-s all` during auth without service filtering, as it includes 85+ scopes and will fail.

> [!CAUTION]
> **If `gws auth setup` fails at any point,** switch to the Manual Fallback below. Start at the step corresponding to where the failure occurred.

---

### Step 4: Verify Connection

**Smoke test:**

```bash
gws drive files list --params '{"pageSize": 1}'
gws gmail users messages list --params '{"userId":"me","maxResults":1}'
```

If both return JSON data (even empty results), the connection works.

Tell the user:

> "Google Workspace is connected! I can now:
>
> - Read and send emails via Gmail
> - View and create calendar events
> - Browse, create, and organize Drive files
> - Read and edit Sheets and Docs
> - Access Google Meet
>
> I access these through the `gws` command-line tool. Your credentials are encrypted at rest with AES-256-GCM using your OS keychain (macOS Keychain / Windows Credential Manager) and never leave your machine."

> [!TIP]
> **Want additional services later?** No reinstall needed. Re-authenticate with more services:
> ```bash
> gws auth login -s drive,gmail,calendar,sheets,docs,meet,chat,keep
> ```
> Then approve the new scopes in the browser.

> ✅ **Setup complete.** Read `workflows/workspace.md` to run verification tests.

---
---

## Manual Fallback

> Use these steps if `gws auth setup` fails. Each step maps to what the fast path does automatically.

### Checklist

- [ ] Step 2a: Authenticate gcloud and create GCP project
- [ ] Step 2b: Install gws CLI (if not already done in Step 2)
- [ ] Step 2c: Enable APIs
- [ ] Step 2d: Create OAuth credentials (requires browser)
- [ ] Step 2e: Authenticate gws
- [ ] Step 2f: Verify connection

---

### Step 2a: Authenticate gcloud and Create GCP Project

```bash
gcloud auth login
```

This opens a browser window automatically for Google sign-in. Tell the user:

> "A browser window is opening for Google sign-in. Log in with your Google account and approve access.
>
> Tell me **'done'** when you see the confirmation screen."

Wait for user confirmation. After authentication, create a project:

```bash
gcloud projects create antigravity-workspace --name="Antigravity Workspace"
gcloud config set project antigravity-workspace
```

> [!NOTE]
> If the project name is taken, append a unique suffix (e.g., `antigravity-ws-2026`). The agent should retry automatically with a different name.

---

### Step 2b: Install gws CLI

If not already installed from the fast path Step 2:

**macOS:**
```bash
brew install googleworkspace-cli
```

**Windows (PowerShell):**
```powershell
npm install -g @googleworkspace/cli
```

Verify:

```bash
gws --version
```

---

### Step 2c: Enable APIs

Enable the default services on the GCP project:

```bash
gcloud services enable \
  drive.googleapis.com \
  sheets.googleapis.com \
  gmail.googleapis.com \
  calendar-json.googleapis.com \
  docs.googleapis.com \
  meet.googleapis.com \
  --project=PROJECT_ID
```

Replace `PROJECT_ID` with the actual project ID from Step 2a.

This step is fully automated - no user action needed.

---

### Step 2d: Create OAuth Credentials (Requires Browser)

> [!IMPORTANT]
> This is the one step that **cannot** be fully automated. The agent must open the browser and guide the user through exactly what to click. Keep the instructions dead simple.

There are three sub-steps. The agent opens each URL automatically.

#### 2d-i: Configure OAuth Consent Screen

Open automatically:
```bash
# macOS
open "https://console.cloud.google.com/apis/credentials/consent?project=PROJECT_ID"
# Windows
start "https://console.cloud.google.com/apis/credentials/consent?project=PROJECT_ID"
```

Tell the user:

> "I just opened the Google Cloud Console in your browser. Here's what to do:
>
> 1. If it asks for User Type, select **Internal** (if you have a Workspace account) or **External** (if using a standard @gmail.com account) and click **Create**
> 2. App name: type `Antigravity Workspace`
> 3. User support email: select your email from the dropdown
> 4. Scroll to the bottom, enter your email again under 'Developer contact information'
> 5. Click **Save and Continue**
> 6. On the Scopes page, just click **Save and Continue** (skip it)
> 7. On the Test Users page (if External), click **+ ADD USERS**, enter your email, click **Add**
> 8. Click **Save and Continue**, then **Back to Dashboard**
>
> Tell me **'done'** when you're back at the dashboard."

Wait for user confirmation.

> [!CAUTION]
> The user **must** add themselves as a test user (sub-step 7). Without this, login will fail with a generic "Access blocked" error and no helpful message.

#### 2d-ii: Create Desktop OAuth Client

Open automatically:
```bash
# macOS
open "https://console.cloud.google.com/apis/credentials/oauthclient?project=PROJECT_ID"
# Windows
start "https://console.cloud.google.com/apis/credentials/oauthclient?project=PROJECT_ID"
```

Tell the user:

> "I opened the credential creation page. Here's what to do:
>
> 1. **Application type**: select **Desktop app**
> 2. **Name**: type `Antigravity`
> 3. Click **Create**
> 4. A popup appears - click **Download JSON** (the download icon)
> 5. Close the popup
>
> Tell me **'done'** when you've downloaded the JSON file."

Wait for user confirmation.

#### 2d-iii: Move the Client Secret File

The downloaded file lands in the Downloads folder as `client_secret_*.json`. The agent may not have access to Downloads on macOS due to sandboxing.

**Strategy:** Ask the user to run a single copy command:

**macOS / Linux:**

Tell the user:

> "Almost there! Run this command in your terminal to move the file into place:
>
> ```
> mkdir -p ~/.config/gws && cp ~/Downloads/client_secret_*.json ~/.config/gws/client_secret.json
> ```
>
> Tell me **'done'** when it's run."

**Windows (PowerShell):**

Tell the user:

> "Almost there! Run this command in PowerShell to move the file into place:
>
> ```
> New-Item -ItemType Directory -Force -Path "$env:APPDATA\gws" | Out-Null; Copy-Item "$env:USERPROFILE\Downloads\client_secret_*.json" "$env:APPDATA\gws\client_secret.json"
> ```
>
> Tell me **'done'** when it's run."

**Alternative:** Ask the user to move the file to the project directory (which the agent can access), then the agent copies it:

```bash
# macOS / Linux
mkdir -p ~/.config/gws && cp /path/to/client_secret_*.json ~/.config/gws/client_secret.json

# Windows (PowerShell)
New-Item -ItemType Directory -Force -Path "$env:APPDATA\gws" | Out-Null
Copy-Item "C:\path\to\client_secret_*.json" "$env:APPDATA\gws\client_secret.json"
```

---

### Step 2e: Authenticate gws

```bash
gws auth login -s drive,gmail,calendar,sheets,docs,meet
```

This launches an interactive scope selection TUI, then prints an auth URL.

**Agent flow:**
1. Instruct the user to run `gws auth login` **IN THEIR OWN TERMINAL**.
   The interactive scope selection TUI prevents the agent's internal terminal from completing the flow successfully.
   
Tell the user:
> "Please run this command in your own terminal to authenticate:
> ```bash
> gws auth login -s drive,gmail,calendar,sheets,docs,meet
> ```
> 1. When the menu appears, press Enter to confirm the Recommended scopes.
> 2. It will open your browser for you to log in.
> 3. Tell me **'done'** when the terminal shows 'Login successful'."

Tell the user:

> "I'm opening a browser window for you to approve access to your Google apps.
>
> Did a browser window open? If not, let me know and I'll open it again.
>
> You'll see **'Google hasn't verified this app'** - this is normal. Click **Advanced**, then **Go to Antigravity Workspace (unsafe)**.
>
> Check all the scope boxes and click **Continue**.
>
> Tell me **'done'** when the browser shows a success page."

Wait for user confirmation.

> [!WARNING]
> **Scope limit for unverified apps:** The OAuth app is in "testing mode," which limits consent to ~25 scopes. The 6 default services (Drive, Gmail, Calendar, Sheets, Docs, Meet) with the "Recommended" preset use ~28 scopes, which is within the limit. Do NOT use `-s all` during auth without service filtering, as it includes 85+ scopes and will fail.

---

### Step 2f: Verify Connection

Same as Fast Path Step 4. Run the smoke tests and tell the user the connection is active.

> ✅ **Setup complete.** Read `workflows/workspace.md` to run verification tests.

---

## Troubleshooting

### "Access blocked" or 403 during login
You forgot to add yourself as a test user. Go back to Step 2d-i, sub-step 7.

### "Google hasn't verified this app"
This is expected and safe. Click **Advanced** then **Go to Antigravity Workspace (unsafe)**.

### Too many scopes error
You selected too many services. Re-run `gws auth login -s drive,gmail,calendar,sheets,docs,meet` with only the services you need.

### "API not enabled - accessNotConfigured"
The agent forgot to enable an API. Run:
```bash
gcloud services enable <SERVICE>.googleapis.com --project=PROJECT_ID
```

### Can't access Downloads folder
macOS sandboxing may block the agent from reading `~/Downloads/`. The user must run the copy command themselves (Step 2d-iii).

### `gws auth setup` hangs or fails
Switch to the manual fallback path. Identify which sub-step failed and start from the corresponding manual step.

### Adding more services later
No reinstall needed. Just re-authenticate with additional services:
```bash
gws auth login -s drive,gmail,calendar,sheets,docs,meet,chat,keep
```
Then approve the new scopes in the browser.

### Credential location
Credentials are stored encrypted (AES-256-GCM) with the encryption key in your OS keychain:
- **macOS:** `~/.config/gws/` (key in Keychain Access)
- **Windows:** `%APPDATA%\gws\` (key in Windows Credential Manager)

### General: Something went wrong
If the setup breaks at any point, the agent should:
1. Tell the user exactly what failed and why
2. Offer a clear fix as a single numbered step
3. Ask for **'done'** confirmation before proceeding
4. Never skip a broken step or assume it resolved itself
