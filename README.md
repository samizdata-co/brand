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

The repository is private. Download a pinned tag with authenticated GitHub CLI access, then install the archive:

```sh
gh api repos/samizdata-co/brand/tarball/v0.1.0 > /tmp/samizdata-brand-v0.1.0.tar.gz
cd your-quarto-project
quarto add /tmp/samizdata-brand-v0.1.0.tar.gz
```

If the repository becomes public, the shorter `quarto add samizdata-co/brand@v0.1.0` command will work. Quarto's GitHub installer cannot currently access this private repository directly.

For local development of this repository:

```sh
cd your-quarto-project
quarto add /absolute/path/to/samizdata/brand
```

Quarto copies the extension into `_extensions/samizdata/`. Commit that installed directory so the project remains reproducible. To update, download the desired pinned tag and run:

```sh
quarto update extension /tmp/samizdata-brand-v0.1.0.tar.gz
```

Do not reference the raw `main` branch during a build. The extension activates the brand through project metadata, so the consuming directory must contain `_quarto.yml`.

The canonical files at the repository root are synchronized into the distributable extension with:

```sh
ruby scripts/sync-extension.rb
```

The default web font source is Bunny Fonts. HTML supports light/dark mode and the branded fonts directly. PDF engines do not obtain fonts from Bunny Fonts: install Space Grotesk and Work Sans on the rendering system or provide local font files/configuration in the consuming project. PDF dark-mode switching and web-only interaction treatments are not applicable.

## Use with agents

The current agent-facing implementation remains in `../blog-astro/.agents/skills/samizdata-design/` while consumers are migrated. Phase 7 will move the canonical skill into this repository and document installation for each agent environment. Until then, agents should read this repository's `DESIGN.md`, `_brand.yml`, and relevant token file directly; do not create another independently maintained skill copy.

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

## Distribution and versioning status

The extension is published as the private GitHub tag **v0.1.0**. Local-directory, local-archive, and authenticated GitHub-tag archive installation are tested. Phase 8 will add a `VERSION` file and stronger synchronization across extension/artifact versions. Visual or semantic token changes will require a major version; additive tokens will be minor; non-visual fixes will be patch releases.

## Validate changes

Requirements: Ruby (standard library only) and Quarto.

```sh
ruby scripts/check-tokens.rb
scripts/test-quarto-extension.sh
quarto render
```

The token check compares critical `_brand.yml`, CSS, visualization, contrast, and extension-copy values. The extension test installs from both a local directory and an archive, renders the fixture, and verifies light/dark CSS, fonts, and logo assets. To verify the private published tag, download its authenticated archive and pass that path as the optional third source:

```sh
gh api repos/samizdata-co/brand/tarball/v0.1.0 > /tmp/samizdata-brand-v0.1.0.tar.gz
scripts/test-quarto-extension.sh /tmp/samizdata-brand-v0.1.0.tar.gz
```

Quarto validates `_brand.yml` and renders the local design guide and fixture.

When changing the identity:

1. update `_brand.yml`;
2. update the matching CSS and visualization artifacts;
3. update `DESIGN.md` if meaning or guidance changed;
4. run the checks above;
5. review light and dark output, keyboard focus, contrast, and reduced motion;
6. release and update consumers deliberately once versioning is introduced in Phase 8.

## Repository history

The previous website redesign brief is preserved in [`docs/initial-website-brief.md`](docs/initial-website-brief.md). The Phase 1 comparison is in [`docs/migration-inventory.md`](docs/migration-inventory.md). These files provide context but are not current guidance.
