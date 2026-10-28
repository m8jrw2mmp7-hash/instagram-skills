# Instagram Skills for Mistral Code (Vibe)

The 9 Instagram marketing skills from
[sergebulaev/instagram-skills](https://github.com/sergebulaev/instagram-skills),
packaged for **Mistral Code** (the Vibe CLI).

Vibe reads the open [Agent Skills](https://agentskills.io) specification —
a directory with a `SKILL.md` file holding `name` and `description` in YAML
frontmatter — which is the same format these skills already use for Claude
Code and Codex. No format conversion is needed; only the install path
differs.

## The 9 skills

| Skill | Purpose |
|---|---|
| `ig-caption-writer` | Caption with the hook in the first 125 chars |
| `ig-carousel-planner` | Slide-by-slide carousel plan |
| `ig-hook-extractor` | Reverse-engineer hooks from viral Reels/carousels |
| `ig-hashtag-strategist` | 2026 hashtag sizing (3-5, not 30) |
| `ig-humanizer` | Remove AI tells; `--mode audit`, `--mode profile` |
| `ig-content-planner` | Plan a week of Reels, carousels, stories |
| `ig-repurposer` | Turn LinkedIn/blog/YouTube/X content native to IG |
| `ig-profile-optimizer` | Audit and rewrite bio, name, highlights, grid |
| `ig-audience-insights` | Niche and profile stats from real data (Apify) |

## Install for Mistral Code

### From this repo (recommended)

```bash
git clone https://github.com/<your-fork>/instagram-skills-mistral
cd instagram-skills-mistral
./scripts/vibe-install.sh            # user install -> ~/.vibe/skills/
# or
./scripts/vibe-install.sh --project # project install -> ./.vibe/skills/
```

Then restart your Vibe session (or run `/reload-plugins`). Run `/plugins`
to confirm `instagram-skills` is listed. Each skill is user-invocable, so
`/ig-caption-writer`, `/ig-carousel-planner`, etc. autocomplete in the CLI
prompt and the VS Code extension.

### Uninstall

```bash
./scripts/vibe-install.sh --uninstall           # user install
./scripts/vibe-install.sh --project --uninstall # project install
```

### Manual install

Copy `skills/*`, `references/`, `lib/`, and the root `SKILL.md` into
`~/.vibe/skills/instagram-skills/` yourself, keeping the layout:

```
~/.vibe/skills/instagram-skills/
├── SKILL.md
├── references/
├── lib/
└── skills/
    ├── ig-caption-writer/SKILL.md
    ├── ...
    └── ig-audience-insights/SKILL.md
```

The skills reference the shared trees with `../../references/` and
`../../lib/` relative paths, which resolve from that layout unchanged.

## Python dependencies

The publish and read layers use `requests` and `python-dotenv`:

```bash
pip install -r requirements.txt
```

## Publishing (three tiers)

- **Tier 0 — draft only (default):** works with no setup. Every approved
  caption comes back as a copy-paste block.
- **Tier 1 — Publora (publish):** set `PUBLORA_API_KEY` in `.env` (copy
  `.env.example`). The draft → upload → schedule media flow posts to
  Instagram through Publora. Instagram requires media on every post; you
  supply the image or video.
- **Tier 2 — Apify (insights):** set `APIFY_TOKEN` for the
  `ig-audience-insights` read layer.

The original repo's README documents all three tiers in detail; see
`README.md` here for the full skill-by-skill reference.

## Notes

- On Vibe there is no claude.ai-style "add from GitHub" marketplace; use
  the install script above.
- The `.claude-plugin`, `.codex-plugin`, `.codex-marketplace`, and
  `.agents` packaging in this fork is kept only so the source diff against
  the upstream repo stays minimal; Vibe ignores it.
- Credits: all skill content is by [Serge Bulaev](https://github.com/sergebulaev),
  MIT licensed.
