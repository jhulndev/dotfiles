#!/usr/bin/env bash
set -euo pipefail

PLANNOTATOR_VERSION="0.26.8"

log() { printf "\n==> %s\n" "$*"; }

require_cmd() {
  command -v "$1" >/dev/null 2>&1
}

if ! require_cmd mise && [[ -x "$HOME/.local/bin/mise" ]]; then
  export PATH="$HOME/.local/bin:$PATH"
fi
if ! require_cmd mise; then
  echo "mise must be installed by setup-scripts/02-common-mise.sh first." >&2
  exit 1
fi
eval "$(mise activate bash)"

for command in curl gh git node npx pi python3; do
  if ! require_cmd "$command"; then
    echo "Required command not found: $command" >&2
    exit 1
  fi
done

log "Install Plannotator ${PLANNOTATOR_VERSION} and its managed integrations"
curl -fsSL https://plannotator.ai/install.sh | bash -s -- \
  --version "v${PLANNOTATOR_VERSION}" \
  --verify-attestation \
  --extras \
  --model-invocable none \
  --non-interactive

export PATH="$HOME/.local/bin:$PATH"

log "Install the extra Plannotator skills as user-invoked tools"
npx --yes skills add backnotprop/plannotator/apps/skills/extra \
  --global \
  --agent opencode \
  --agent claude-code \
  --agent codex \
  --yes

log "Disable Plannotator sharing by default"
python3 - <<'PY'
import json
import os
import tempfile

configured_dir = os.environ.get("PLANNOTATOR_DATA_DIR")
legacy_dir = os.path.expanduser("~/.plannotator")
xdg_dir = os.environ.get("XDG_DATA_HOME", "")
if configured_dir:
    data_dir = os.path.abspath(os.path.expanduser(configured_dir))
elif os.path.isdir(legacy_dir):
    data_dir = legacy_dir
elif os.path.isabs(xdg_dir):
    data_dir = os.path.join(xdg_dir, "plannotator")
else:
    data_dir = legacy_dir

path = os.path.join(data_dir, "config.json")
os.makedirs(os.path.dirname(path), exist_ok=True)

if os.path.exists(path):
    with open(path, encoding="utf-8") as handle:
        config = json.load(handle)
else:
    config = {}

config["share"] = "disabled"
fd, temporary_path = tempfile.mkstemp(dir=os.path.dirname(path))
try:
    with os.fdopen(fd, "w", encoding="utf-8") as handle:
        json.dump(config, handle, indent=2)
        handle.write("\n")
    os.replace(temporary_path, path)
finally:
    if os.path.exists(temporary_path):
        os.unlink(temporary_path)
PY

log "Configure the pinned Plannotator OpenCode plugin"
OPENCODE_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/opencode/opencode.json"
python3 - "$OPENCODE_CONFIG" "$PLANNOTATOR_VERSION" <<'PY'
import json
import os
import sys
import tempfile

path = os.path.abspath(os.path.expanduser(sys.argv[1]))
version = sys.argv[2]
package = f"@plannotator/opencode@{version}"
os.makedirs(os.path.dirname(path), exist_ok=True)

if os.path.exists(path):
    with open(path, encoding="utf-8") as handle:
        config = json.load(handle)
else:
    config = {"$schema": "https://opencode.ai/config.json"}

plugins = config.setdefault("plugin", [])
if not isinstance(plugins, list):
    raise SystemExit(f"Expected 'plugin' to be an array in {path}")

merged_plugins = []
found = False
for entry in plugins:
    spec = entry if isinstance(entry, str) else entry[0] if isinstance(entry, list) and entry else ""
    if spec == "@plannotator/opencode" or spec.startswith("@plannotator/opencode@"):
        if found:
            continue
        if isinstance(entry, str):
            entry = package
        else:
            entry[0] = package
        found = True
    merged_plugins.append(entry)
if not found:
    merged_plugins.append(package)
config["plugin"] = merged_plugins

fd, temporary_path = tempfile.mkstemp(dir=os.path.dirname(path))
try:
    with os.fdopen(fd, "w", encoding="utf-8") as handle:
        json.dump(config, handle, indent=2)
        handle.write("\n")
    os.replace(temporary_path, path)
finally:
    if os.path.exists(temporary_path):
        os.unlink(temporary_path)
PY

log "Configure the Plannotator Claude Code plugin"
if require_cmd claude; then
  if ! claude plugin marketplace list --json | python3 -c '
import json, sys
raise SystemExit(0 if any(item.get("repo") == "backnotprop/plannotator" for item in json.load(sys.stdin)) else 1)
'; then
    claude plugin marketplace add --scope user backnotprop/plannotator
  fi

  if ! claude plugin list --json | python3 -c '
import json, sys
items = json.load(sys.stdin)
raise SystemExit(0 if any("plannotator" in str(item.get("id", item.get("name", ""))) for item in items) else 1)
'; then
    claude plugin install --scope user plannotator@plannotator
  fi
else
  log "Claude Code not found; skipping its Plannotator plugin"
fi

log "Install/update the pinned Plannotator Pi extension"
pi install "npm:@plannotator/pi-extension@${PLANNOTATOR_VERSION}"

log "Verify Plannotator setup"
plannotator --version
plannotator --help >/dev/null
pi list
for skill in plannotator-compound plannotator-setup-goal plannotator-visual-explainer; do
  if [[ ! -d "$HOME/.agents/skills/$skill" ]]; then
    echo "Expected Plannotator skill not found: $HOME/.agents/skills/$skill" >&2
    exit 1
  fi
done
if require_cmd opencode; then
  opencode debug config >/dev/null
fi
