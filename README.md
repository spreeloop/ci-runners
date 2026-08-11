# ci-runners
Configurations for self hosted runners on gcp/aws/azure

## Mac Mini M4 Access Guide

We have setup the headless Mac mini with **Tailscale SSH**. Authentication is handled automatically via your Spreeloop Google/Identity account.

**Security Note:** All terminal sessions are automatically recorded for audit.

---

### 1. Quick Installation (CLI)

If you do not use the Tailscale GUI app, run the command for your local machine's operating system:

* **Ubuntu / Debian:**
  ```bash
  curl -fsSL https://tailscale.com | sh
  ```
* **macOS (Homebrew):**
  ```bash
  brew install tailscale && sudo brew services start tailscale
  ```

---

### 2. Authenticating to the Network

Connect your local machine to the Spreeloop Tailscale network:

```bash
sudo tailscale up
```

1. Copy the unique login URL printed in your terminal.
2. Paste it into your browser.
3. Sign in using your `@spreeloop.com` email address.

---

### 3. Connecting to the Mac Mini

Once authenticated, connect directly to the shared admin profile:

```bash
ssh sharedadmin@spreeloop-macmini-m4
```

* **No Password Required:** Tailscale validates your identity and securely logs you in.
* **Session Warning:** You will see a notice stating that the session is being recorded.
* **Passwordless Sudo:** The `sharedadmin` account is pre-configured to run root commands without a password prompt (e.g., `sudo ls /root`).
