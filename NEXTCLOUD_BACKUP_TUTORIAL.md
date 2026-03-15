# Nextcloud Weekly Backup Tutorial (Local Folder → Nextcloud via rclone)

A practical setup that is:
- automated weekly
- resilient if the laptop is off/no Wi‑Fi at backup time
- easy to troubleshoot

---

## 1) Install rclone

```bash
sudo apt update
sudo apt install -y rclone
```

(Alternative on some systems: `brew install rclone`)

---

## 2) Configure Nextcloud remote in rclone

Run:

```bash
rclone config
```

Create a new remote, for example named `nextcloud`:
- **Storage type**: `webdav`
- **URL**: `https://cloud.aiomvp.com/remote.php/dav/files/<YOUR_USERNAME>/`
- **Vendor**: `nextcloud`
- **User**: your Nextcloud username
- **Password**: use an **app password** (recommended)

Test:

```bash
rclone lsd nextcloud:
```

If this lists directories, remote setup is good.

---

## 3) Create backup script

Create `/opt/scripts/backup-to-nextcloud.sh`:

```bash
#!/usr/bin/env bash
set -Eeuo pipefail

# ===== Fill these =====
SRC="/path/to/local/folder"
DST="nextcloud:Backups/YourFolder"
LOG_FILE="/home/<YOUR_USER>/.local/share/backup-nextcloud.log"
EXCLUDES="/opt/scripts/rclone-excludes.txt"
# ======================

ts() { date +"%Y-%m-%d %H:%M:%S"; }
log() { echo "[$(ts)] $*"; }
trap 'log "ERROR on line $LINENO (exit=$?)"' ERR

log "Backup started"
log "SRC=$SRC"
log "DST=$DST"

if [[ "$SRC" == "/path/to/local/folder" ]]; then
  log "Please set SRC first"; exit 1
fi
if [[ ! -d "$SRC" ]]; then
  log "Source does not exist: $SRC"; exit 1
fi
mkdir -p "$(dirname "$LOG_FILE")"

rclone sync "$SRC" "$DST" \
  --exclude-from "$EXCLUDES" \
  --create-empty-src-dirs \
  --transfers 2 \
  --checkers 4 \
  --retries 6 \
  --low-level-retries 20 \
  --retries-sleep 15s \
  --timeout 2m \
  --contimeout 30s \
  --disable-http2 \
  --stats 15s \
  --progress \
  --verbose \
  --log-file "$LOG_FILE" \
  --log-level INFO

log "Backup completed"
```

Make executable:

```bash
sudo chmod +x /opt/scripts/backup-to-nextcloud.sh
```

---

## 4) Add excludes (important for code/projects)

Create `/opt/scripts/rclone-excludes.txt`:

```txt
**/.git/**
**/.dart_tool/**
**/build/**
**/node_modules/**
**/.next/**
**/.cache/**
**/.idea/**
**/.vscode/**
**/.DS_Store
**/Thumbs.db
**/~$*
**/.~lock.*#
```

Why: avoids volatile/generated/temp files that often cause retries and errors.

---

## 5) Test manually first

```bash
/opt/scripts/backup-to-nextcloud.sh
```

If you want a safe test first:

```bash
rclone sync "$SRC" "$DST" --dry-run --exclude-from /opt/scripts/rclone-excludes.txt
```

---

## 6) Schedule weekly with systemd timer (better than cron)

### `/etc/systemd/system/nextcloud-backup.service`

```ini
[Unit]
Description=Nextcloud Backup (rclone)
Wants=network-online.target
After=network-online.target

[Service]
Type=oneshot
User=<YOUR_USER>
ExecStart=/opt/scripts/backup-to-nextcloud.sh
```

### `/etc/systemd/system/nextcloud-backup.timer`

```ini
[Unit]
Description=Weekly Nextcloud Backup Timer

[Timer]
OnCalendar=Sun *-*-* 03:00:00
Persistent=true
RandomizedDelaySec=2h

[Install]
WantedBy=timers.target
```

Enable it:

```bash
sudo systemctl daemon-reload
sudo systemctl enable --now nextcloud-backup.timer
```

Check status:

```bash
systemctl list-timers | grep nextcloud-backup
systemctl status nextcloud-backup.timer
journalctl -u nextcloud-backup.service --since "7 days ago"
```

### Why systemd timer instead of cron?
- `Persistent=true` runs missed jobs later (e.g., laptop off/no Wi‑Fi at 03:00).

---

## 7) Common problems + fixes

### Problem: `didn't find section in config file`
Cause: service ran as root and used `/root/.config/rclone/rclone.conf`.

Fix:
- set `User=<YOUR_USER>` in the service (recommended), or
- pass explicit `--config /home/<user>/.config/rclone/rclone.conf`.

### Problem: `source file is being updated`
Cause: files changed during backup.

Fix:
- exclude build/cache/temp folders
- avoid running active builds during backup

### Problem: `502 Bad Gateway`
Cause: Nextcloud/proxy stress, often with large binaries/many tiny files.

Fix:
- lower concurrency (`--transfers 2 --checkers 4`)
- retries + timeouts as above
- exclude unnecessary heavy/generated artifacts

### Problem: `http2: request body larger than specified content length`
Fix:
- add `--disable-http2`

---

## 8) Optional hardening

- Add a lock to prevent overlapping runs.
- Add notification on success/failure (mail/Telegram/etc.).
- Use `restic` if you need versioned, encrypted, point-in-time backups.

---

## 9) Quick command cheatsheet

```bash
# Manual run
/opt/scripts/backup-to-nextcloud.sh

# Show rclone errors from log
grep -n "ERROR" /home/<YOUR_USER>/.local/share/backup-nextcloud.log | head -n 30

# Timer status
systemctl status nextcloud-backup.timer

# Service logs
journalctl -u nextcloud-backup.service -f
```

---

If you reuse this for another machine, only update:
- `SRC`
- `DST`
- user in systemd service
- Nextcloud remote config (`rclone config`)
