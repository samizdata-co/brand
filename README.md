# SAMIZDATA design system

Shared design foundations for SAMIZDATA websites, reports, training material, tools, and data visualisations.

## Sources of truth

| File | Purpose |
|---|---|
| [`_brand.yml`](_brand.yml) | Portable brand identity for Quarto and other `brand.yml` consumers |
| [`DESIGN.md`](DESIGN.md) | Human-readable principles and usage rules |
| [`css/tokens.css`](css/tokens.css) | Shared light/dark CSS custom properties |
| [`datavis/tokens.yml`](datavis/tokens.yml) | Chart and map colors, palettes, typography, lines, and interaction tokens |
| [`assets/logos/`](assets/logos/) | Canonical light, dark, and raster marks |
| [`skills/samizdata-design/`](skills/samizdata-design/) | Canonical agent skill |
| [`VERSION`](VERSION) | Current design-system release |
| [`PLAN.md`](PLAN.md) | Migration and rollout plan |

`_brand.yml` is authoritative for portable identity values. Visualization-only concepts belong in `datavis/tokens.yml`. CSS is a distribution artifact and must remain synchronized with both.

## Current identity

- **Display:** Space Grotesk 700/900
- **Body:** Work Sans 400/500
- **Accent:** dried raspberry on warm paper/charcoal surfaces
- **Structure:** sharp cards, controls, and panels; selective rounding for circular or detached controls
- **Depth:** tonal surfaces first, restrained ambient shadow second
- **Accessibility:** WCAG AA text, visible focus, and reduced-motion support

See [`DESIGN.md`](DESIGN.md) before implementing or reviewing visual work.

## Use in Quarto

The supported cross-repository mechanism is the `samizdata` Quarto Brand Extension. Quarto 1.8.20 or newer is required.

Install the pinned public release from GitHub:

```sh
cd your-quarto-project
quarto add samizdata-co/brand@v1.0.0
```

For local development of this repository:

```sh
cd your-quarto-project
quarto add /absolute/path/to/samizdata/brand
```

Quarto copies the extension into `_extensions/samizdata-co/samizdata/`. Commit that installed directory so the project remains reproducible. To update deliberately to a released tag, run:

```sh
quarto update extension samizdata-co/brand@v1.0.0
```

Do not reference the raw `main` branch during a build. The extension activates the brand through project metadata, so the consuming directory must contain `_quarto.yml`.

The canonical files at the repository root are synchronized into the distributable extension with:

```sh
ruby scripts/sync-extension.rb
```

The default web font source is Bunny Fonts. HTML supports light/dark mode and the branded fonts directly. PDF engines do not obtain fonts from Bunny Fonts: install Space Grotesk and Work Sans on the rendering system or provide local font files/configuration in the consuming project. PDF dark-mode switching and web-only interaction treatments are not applicable.

## Use with agents

[`skills/samizdata-design/SKILL.md`](skills/samizdata-design/SKILL.md) is the only independently editable skill source. Its reference links resolve directly to the canonical files in this repository.

For Pi, add the checkout's skill directory to `~/.pi/agent/settings.json`:

```json
{
  "skills": ["/absolute/path/to/brand/skills"]
}
```

Alternatively, add a path relative to a consuming project's `.pi/settings.json`. In the sibling layout used by this workspace, `website/.pi/settings.json` contains:

```json
{
  "skills": ["../../brand/skills"]
}
```

Restart Pi, trust project settings when prompted, and invoke `/skill:samizdata-design` to force loading. Pi otherwise activates it from its description when a task matches.

If an agent requires a self-contained repository-local skill, generate a copy from the brand checkout:

```sh
scripts/copy-skill.sh /path/to/consumer/.agents/skills/samizdata-design
```

The command dereferences canonical reference links so the copy works without a sibling checkout. Do not edit generated copies; rerun the command from a known brand revision to update them.

## Use in frontend projects

Until a package is justified, copy or link [`css/tokens.css`](css/tokens.css), then map project/framework aliases to its `--sz-*` properties. Keep resets, prose styles, components, and page layout in the consumer project.

Example:

```css
@import "./vendor/samizdata/tokens.css";

:root {
  --background: var(--sz-color-surface);
  --foreground: var(--sz-color-ink);
  --primary: var(--sz-color-primary-container);
  --ring: var(--sz-color-accent-text);
}
```

Do not edit a vendored token file locally. Update it from a known brand revision and review the visual change.

## Use in data visualisation

Read [`datavis/tokens.yml`](datavis/tokens.yml) when implementing package defaults or generating platform-specific chart tokens. Preserve consumer overrides: data semantics and accessibility can require a project-specific palette.

The categorical palette is unordered. The sequential palette runs light to dark. Use the diverging palette only around a meaningful midpoint. Low-alpha gridlines are decorative; essential axes and reference lines need at least 3:1 contrast.

## Logos

- `assets/logos/mark.svg`: light-background mark
- `assets/logos/mark-dark.svg`: dark-background mark
- `assets/logos/mark-512.png`: raster fallback

A wordmark is the mark paired with uppercase `SAMIZDATA` in Space Grotesk 900. It remains typographic rather than being frozen into an inaccessible or font-dependent SVG.

## Distribution and versioning

The stable design-system release is **v1.0.0**. `VERSION`, the Quarto extension metadata, and distribution-artifact headers must carry the same version; `scripts/check-tokens.rb` enforces this.

Use semantic intent:

- **patch:** documentation corrections or output fixes without a visual change;
- **minor:** additive tokens, assets, or backward-compatible guidance;
- **major:** changed token meaning, removed tokens, typography changes, or an intentional redesign.

Consumer projects remain independently versioned. They record the brand release they consume rather than adopting the brand repository's package version.

## Validate changes

Requirements: Ruby (standard library only) and Quarto.

```sh
ruby scripts/check-tokens.rb
ruby scripts/check-consumers.rb # with graphics/ and samizplot/ sibling checkouts
scripts/test-quarto-extension.sh
quarto render
```

The token check compares versions, critical `_brand.yml`, CSS, visualization, contrast, and extension-copy values. The consumer check compares the recorded brand version, canonical chart colors, palettes, and font roles with the packaged defaults in `graphics` and `samizplot`. The extension test installs from both a local directory and an archive, renders the fixture, and verifies light/dark CSS, fonts, and logo assets. After publishing a tag, pass it as the optional third source:

```sh
scripts/test-quarto-extension.sh samizdata-co/brand@v1.0.0
```

Quarto validates `_brand.yml` and renders the local design guide and fixture.

When changing the identity:

1. update `_brand.yml`;
2. update the matching CSS and visualization artifacts;
3. update `DESIGN.md` if meaning or guidance changed;
4. choose the next version and update `VERSION`, extension metadata, and artifact headers;
5. run the checks above;
6. review light and dark output, keyboard focus, contrast, and reduced motion;
7. commit and tag the release;
8. update each consumer deliberately.

Frontend consumers refresh with their documented copy command (for `website`, `npm run brand:sync`). Repository-local skills refresh with `scripts/copy-skill.sh`. Quarto consumers run `quarto update extension samizdata-co/brand@vX.Y.Z`. Identify the installed Quarto version in `_extensions/samizdata-co/samizdata/_extension.yml`; identify frontend and graphics baselines from their artifact headers.

## Repository history

The previous website redesign brief is preserved in [`docs/initial-website-brief.md`](docs/initial-website-brief.md). The Phase 1 comparison is in [`docs/migration-inventory.md`](docs/migration-inventory.md). These files provide context but are not current guidance.
