# Claude Code setup

## Use skills from `~/.agents/skills`

Claude Code reads personal skills from `~/.claude/skills`, not `~/.agents/skills`. A `SessionStart` hook links any new skills across automatically.

### 1. Create the script

Run `mkdir -p ~/.claude/hooks`, then save this as `~/.claude/hooks/link-agent-skills.sh`:

```bash
#!/usr/bin/env bash
# Links any new skills from ~/.agents/skills into ~/.claude/skills.
for d in ~/.agents/skills/*/; do
  name=$(basename "$d")
  [ "$name" = "code-review" ] && continue
  [ -e ~/.claude/skills/"$name" ] || ln -s "${d%/}" ~/.claude/skills/"$name"
done
exit 0
```

`code-review` is skipped because it has the same name as the built-in `/code-review`.

### 2. Add the hook

Add this to `~/.claude/settings.json`. If a `hooks` key already exists, add `SessionStart` inside it.

```json
"hooks": {
  "SessionStart": [
    {
      "hooks": [
        {
          "type": "command",
          "command": "bash ~/.claude/hooks/link-agent-skills.sh"
        }
      ]
    }
  ]
}
```

### 3. Check it

1. Start a new Claude Code session.
2. Run `ls -la ~/.claude/skills`. Your skills should be listed as symlinks.
3. Type `/<installed-skill>`. If it isn't there yet, start one more session.

## Use your own skills

Your own skills live in the `ai-skills` repo. Clone it to `~/Code/ai-skills`, then link each skill into `~/.agents/skills`, and the hook above picks it up:

```bash
ln -s ~/Code/ai-skills/skills/pilot ~/.agents/skills/pilot
```

## Good to know

- New skills may not appear until the session after you install them.
- Don't replace `~/.claude/skills` with a symlink to `~/.agents/skills`. Claude Code keeps its `synced` skills in that folder.
