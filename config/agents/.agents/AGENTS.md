## Generated documents
Save reports and other generated documents to `~/Dokumente/Agents`: in `<repo-name>/` for work on a repo, otherwise in `YYYY-MM-DD/<task>/`. Use another location only if I ask for one or the repo documents its own.

## Repo docs
Keep developer docs in `docs/dev/`, architecture decisions in `docs/adr/`, and work in progress in `tasks/`, moving finished task docs to `tasks/archive/`. Create these folders when first needed. `AGENTS.md` holds only rules and gotchas an agent can't find by looking; explanations for people go in the README or `docs/dev/`.

## App UI
**No information clutter.** Write every screen for a normal user, never like code documentation. Show only what helps the user understand or act at that moment. Leave out explanations of the obvious, implementation details, internal states and technical terms. Give each fact and control one home, and repeat it only where it changes what the user does next.

In Flutter apps that use `trainvent_general`, show loading states with `TriangleLoadingIndicator`.

## Code
- Let names and structure explain the code. Add a comment only when it's needed to explain why, such as a workaround or a constraint the code can't show.
- Put URLs, thresholds, colours, sizes and user-facing text in named constants, the theme, config or localization. Self-evident values like `0` or `1` and test fixtures can stay inline.
- Build shared styles and behaviour as reusable classes, widgets or constants, so one fix applies everywhere.
- Prefer the newest dependency versions, even when they need code changes. Pin back only when a version is blocked or broken, and record the reason and the way back in `tasks/`.
- Remove compatibility layers, aliases and old names freely. A project's `AGENTS.md` turns this off once that app has real users.
- Ask before changing stored data, public APIs or file formats. Once approved, update everything that depends on them in the same task.
- For Cloudflare, use the `cf` CLI unless the project has a Wrangler config file (`wrangler.toml`, `wrangler.json` or `wrangler.jsonc`); then use Wrangler.

## Working
- When you find an existing mistake that doesn't affect the current task, finish the task and then recommend a fix. If it does affect the task, stop and ask before applying a fix.
- Commit when a feature or a coherent set of related changes works and passes the checks, not after every small task. Commit directly to `main` in my repos. Push or release only when I ask.
- Keep plans to the essentials.
- For an open visual or UX choice, show 2-3 rough options before building one properly.
- Use the `pilot` skill when a task spans several variants that each need their own real work.

## Assist
- whenever i ask for a command which i don't now yet add it to my commands file currently located at: `/home/leonmarq/Nextcloud/Trainvent/Documents/Strainvent/Persönlich/Programmieren/Befehle.md` 
- other project indepentent advices you can also put into: `/home/leonmarq/Nextcloud/Trainvent/Documents/Strainvent/Eingang
- 





