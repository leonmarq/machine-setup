# Codex setup

## Use `AGENTS.md` from this repo

Codex only reads global instructions from `~/.codex/AGENTS.md` (or `$CODEX_HOME/AGENTS.md`), and has no setting for a custom path. A symlink keeps this repo's file as the only real copy.

### 1. Clone this repo

Clone it to `~/Code/machine-setup`.

### 2. Link the file

Check for an existing `~/.codex/AGENTS.md` first, because `-f` overwrites it.

```bash
mkdir -p ~/.codex
ln -sfn ~/Code/machine-setup/AGENTS.md ~/.codex/AGENTS.md
```

### 3. Check it

1. Run `ls -l ~/.codex/AGENTS.md`. It should point to this repo.
2. Run this from a folder without its own `AGENTS.md`:

```bash
codex exec --skip-git-repo-check "Without running commands or reading files, list the headings in your global instructions."
```

## Claude Code

Claude Code can import the file directly, so it doesn't need a symlink. Put this in `~/.claude/CLAUDE.md`:

```markdown
@~/Code/machine-setup/AGENTS.md
```

## Good to know

- If the repo moves, the symlink breaks. Run step 2 again with the new path.
- `~/.codex/AGENTS.override.md` takes priority over `AGENTS.md`, so don't leave one lying around.
- Don't use these settings to point at the file:
  - `model_instructions_file` replaces Codex's built-in instructions.
  - `CODEX_HOME` moves all of Codex's home directory, including auth, sessions and config.
- A `global_agents_file` setting has been proposed in [openai/codex#42601](https://github.com/openai/codex/issues/42601). If it ships, it could replace the symlink.
