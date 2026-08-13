# SAMIZDATA design system migration plan

## Goal

Make this repository the versioned source of truth for SAMIZDATA's shared design foundations, then migrate existing projects to consume controlled copies of those foundations.

The design system must serve humans, agents, Quarto, frontend projects, and data-visualisation tooling without requiring those consumers to interpret one another's implementation files.

## Guiding decisions

- This repository—not an individual website or agent skill—is the canonical distribution point.
- `_brand.yml` is the canonical machine-readable source for portable brand concepts supported by the `brand.yml` schema: identity, logos, colors, typography, and format defaults.
- `DESIGN.md` is the canonical human-readable explanation of visual principles and usage rules.
- Data-visualisation tokens live in a separate structured file because categorical, sequential, and diverging scales do not fit cleanly in `_brand.yml`.
- The agent skill explains how to use these canonical resources; it does not independently redefine their values.
- Consumer projects pin or commit a known brand version. Builds must not fetch the latest `main` branch automatically.
- Product-specific layout and component implementations remain in their projects. This repository shares foundations and rules, not a cross-framework component library.

## Scope of the first migration

Included:

- the current SAMIZDATA identity used by `../blog-astro` and `../graphics`;
- this repository's `_brand.yml`, documentation, logos, and installable Quarto brand;
- the SAMIZDATA agent skill;
- Quarto projects in `../../jobs` and `../youth-jobs-gap`;
- frontend token alignment in `../blog-astro`;
- chart token alignment in `../graphics` and `../samizplot`;
- a small versioning and consistency-check mechanism.

Deferred:

- publishing an npm package;
- sharing framework-specific components;
- migrating a personal website;
- automatic update bots;
- a full design-token build framework such as Style Dictionary;
- redesigning project-specific pages or charts.

## Target repository structure

The migration should finish with approximately this structure:

```text
.
├── _brand.yml
├── _extension.yml
├── DESIGN.md
├── PLAN.md
├── README.md
├── VERSION
├── assets/
│   ├── fonts/                 # only if fonts are self-hosted
│   └── logos/
├── css/
│   └── tokens.css             # shared or generated CSS custom properties
├── datavis/
│   └── tokens.yml
└── skills/
    └── samizdata-design/
        └── SKILL.md
```

Use fewer files if Quarto's extension layout or the final font-delivery decision allows it. Do not retain parallel `images/` and `assets/logos/` directories.

---

## Phase 1 — Establish and verify the canonical identity

**Status: complete (2026-08-13).** The approved baseline, accessibility results, resolved semantics, migration inventory, and intentional consumer differences are recorded in `DESIGN.md`. The current identity in `../blog-astro` is the baseline; this phase made only semantic/accessibility corrections rather than redesigning it.

### 1.1 Inventory current values

Compare the following files and record every conflicting color, font, radius, spacing, and semantic token:

- `../blog-astro/.agents/skills/samizdata-design/references/DESIGN.md`
- `../blog-astro/src/styles/global.css`
- `../graphics/src/lib/theme/theme.css`
- `../graphics/src/lib/theme/colors.ts`
- `_brand.yml`
- `css/app.css`
- `../samizplot/R/theme_samizdata.R`
- `../../jobs/_brand.yml`
- `../../jobs/cover-letters/_brand.yml`

The known major split is:

- old identity: Roboto, Roboto Slab, Roboto Mono, rounded components, `#faf9f6`;
- current identity: Space Grotesk, Work Sans, sharp structural components, `#fbf9f4`, warm surface and border ramps.

### 1.2 Confirm the baseline

Adopt the newer identity represented by the design skill and the Astro/graphics projects, subject to resolving their internal differences.

At minimum, explicitly decide and document:

- `primary` versus `primary-container` semantics;
- separate text-accent and filled-control colors in both themes;
- light and dark surface ramps;
- Space Grotesk and Work Sans font sources and supported weights;
- whether code uses a system monospace stack or a named font;
- 0px default structural radius and exceptions for transient/icon controls;
- the canonical logo files and dark-mode behavior;
- accessibility contrast requirements.

Do not proceed while `DESIGN.md` and `blog-astro/src/styles/global.css` disagree over the meaning of `primary`.

### 1.3 Validate the baseline visually and accessibly

Check representative light and dark combinations for WCAG AA body-text contrast. At minimum test:

- ink on every commonly used surface;
- muted text on surface and surface-lowest;
- accent text on light and dark surfaces;
- white text on primary-container;
- focus indicators against adjacent surfaces;
- chart labels, axes, and annotations.

Capture the approved combinations in `DESIGN.md`; do not create a separate audit document unless needed.

**Phase 1 exit criteria**

- [x] Every canonical color and font has one agreed meaning.
- [x] Light and dark text colors meet the documented contrast target.
- [x] Remaining differences are explicitly identified as consumer-specific rather than accidental drift.

---

## Phase 2 — Rebuild this repository around the approved system

**Status: complete (2026-08-13).** The repository now contains a schema-valid `_brand.yml`, cross-project guidance, shared CSS tokens, visualization tokens, canonical mark assets, an operational README, and a dependency-free consistency/contrast check. The obsolete Roboto/Konstruktor assets and component-heavy `css/app.css` were removed; the original website brief was preserved under `docs/`.

### 2.1 Replace the old `_brand.yml`

Update `_brand.yml` to describe the approved identity using valid `brand.yml` fields:

- metadata and links;
- canonical logos and alt text;
- named palette values;
- light/dark semantic colors where supported;
- Space Grotesk and Work Sans typography;
- monospace choice;
- portable Bootstrap/format defaults only where they remain useful.

Keep paths relative to `_brand.yml`, as required by Quarto and `brand.yml` tooling.

Do not put chart palettes or arbitrary component specifications into unsupported schema keys.

### 2.2 Promote and edit `DESIGN.md`

Move the useful content from the existing agent skill reference into root-level `DESIGN.md` and revise it so it describes SAMIZDATA rather than one specific portfolio implementation.

It should cover:

- identity and design principles;
- semantic color use and dark mode;
- typography;
- spacing and layout principles;
- shape, elevation, and motion;
- interaction and focus behavior;
- component guidance without framework-specific APIs;
- data-visualisation guidance;
- accessibility;
- do/don't rules;
- permitted project-level adaptation.

Values duplicated in prose should point back to the named `_brand.yml` or data-visualisation token whenever practical.

### 2.3 Add visualization tokens

Create `datavis/tokens.yml`, initially based on `../graphics/src/lib/theme/theme.css`.

Include only stable visualization concepts:

- foreground, muted, background, and surface colors;
- axis, gridline, and baseline colors;
- accent, area fill, selection, and focus colors;
- categorical palette;
- sequential scale;
- diverging scale;
- chart font roles and sizes;
- line widths, spacing, and transition duration.

Document usage rules in `DESIGN.md`, including:

- categorical colors must not communicate order;
- sequential scales must preserve ordered luminance;
- diverging scales require a meaningful midpoint;
- color must not be the only carrier of meaning;
- dark-mode chart colors must be tested independently.

### 2.4 Create the shared CSS token artifact

Create `css/tokens.css` containing CSS custom properties for the canonical web and chart foundations.

For the first release, prefer the smallest maintainable approach:

1. Generate it with tooling already present in the repository/environment, if reliable; otherwise
2. maintain it as a reviewed distribution artifact and add a consistency check for the critical values.

Do not introduce Style Dictionary or another dependency solely for this migration.

The file must contain a source/version header and no component or page-layout rules. Remove or archive the obsolete `css/app.css` after consumers no longer need it.

### 2.5 Consolidate assets

- Choose one canonical wordmark, mark, favicon source, and any dark variants.
- Move them under one asset directory.
- Remove superseded duplicates only after all paths are updated.
- Decide whether fonts are loaded remotely or self-hosted.
- If self-hosting, include only required font files/weights and document their licenses.

### 2.6 Rewrite the README

Make `README.md` operational rather than aspirational. Include:

- what the repository contains;
- which files are canonical;
- how to install/update the Quarto brand;
- how frontend and chart projects consume tokens;
- how to install the agent skill;
- how versioning works;
- how to validate a change;
- a link to `DESIGN.md` and this plan.

Move historical redesign notes to an archive only if they still provide useful context; otherwise delete them.

**Phase 2 exit criteria**

- [x] `_brand.yml`, `DESIGN.md`, `datavis/tokens.yml`, and `css/tokens.css` describe the same approved identity.
- [x] Assets resolve from `_brand.yml`.
- [x] Obsolete identity values are no longer presented as current guidance in this repository.

---

## Phase 3 — Package the Quarto brand

**Status: awaiting publication verification (2026-08-13).** Implementation and local verification are complete: the extension installs from a directory and archive, survives an update without deleting consumer files, and renders the HTML fixture with light/dark fonts, colors, and logo assets. Quarto distribution requires `_extensions/samizdata/`, so the canonical root files are synchronized into that directory and checked for drift. PDF requires locally available brand fonts and is documented as a consumer delivery override. The remaining exit criterion is installing from a published GitHub tag; creating commits/tags is deferred until explicitly requested.

### 3.1 Add the smallest valid brand extension

Add `_extension.yml` that contributes this repository's `_brand.yml` as the project brand. Declare:

- extension title;
- author/organization;
- initial version;
- minimum supported Quarto version;
- project metadata pointing to `_brand.yml`.

Quarto distribution only installs content under `_extensions/`. Keep `_brand.yml` canonical at the repository root, synchronize it and required assets into `_extensions/samizdata/` with `scripts/sync-extension.rb`, and fail validation when the distribution copy drifts.

### 3.2 Test installation in a disposable project

Use a temporary Quarto project to verify that:

- [x] the extension installs from a local path;
- [ ] it installs from the GitHub repository/tag (requires a published commit/tag);
- [x] `_brand.yml` and its assets resolve correctly;
- [x] HTML renders with the intended fonts and semantic colors;
- [x] PDF limitations and the local-font requirement are documented;
- [x] updating the extension does not delete unrelated project files.

### 3.3 Render a minimal fixture

Use one small `.qmd` fixture containing:

- headings and body text;
- links and focusable controls;
- a table;
- inline and block code;
- success/info/warning/danger elements;
- a logo;
- light and dark HTML output where supported.

Keep the fixture only if it provides ongoing value as a smoke test.

**Phase 3 exit criteria**

- [ ] A tagged copy of this repository can be installed as a Quarto brand extension.
- [x] A minimal document renders without missing assets or schema warnings.

---

## Phase 4 — Migrate Quarto consumers

Migrate one project at a time. Do not bulk-replace files before the extension has passed Phase 3.

### 4.1 Migrate `../../jobs`

- Install a pinned release of the brand extension.
- Point `_quarto.yml` at the installed brand as required by the extension.
- Remove the duplicated root `_brand.yml` after a successful render.
- Keep job-specific PDF configuration local.
- Replace hard-coded old colors/fonts in PDF includes where the brand cannot supply them directly.
- Render representative HTML and PDF outputs.

### 4.2 Migrate `../../jobs/cover-letters`

- Install the same pinned release.
- Remove the duplicated `_brand.yml` after verification.
- Preserve the local embedded-font requirement as a narrowly scoped override if needed.
- Render at least one cover letter to HTML and PDF.

### 4.3 Migrate `../youth-jobs-gap`

- Add the brand extension; this project currently has no `_brand.yml` declaration.
- Reconcile hard-coded Noto Sans/Roboto Slab and PDF colors with the canonical typography.
- Keep publication-specific needs as documented overrides.
- Render representative HTML and PDF outputs.

### 4.4 Record overrides

For every consumer override, record a short reason beside the configuration. Acceptable examples include:

- offline PDF font embedding;
- publication/client branding;
- a chart-specific accessibility requirement;
- output-format limitations.

Avoid copying the full canonical palette to change one value.

**Phase 4 exit criteria**

- Each Quarto project uses a known brand release.
- No project contains an unexplained full copy of the old `_brand.yml`.
- Representative HTML and PDF outputs render successfully.

---

## Phase 5 — Align the active frontend

### 5.1 Reconcile `../blog-astro`

Treat the Astro project as the first CSS consumer:

- replace canonical color/font/layout token declarations in `src/styles/global.css` with an import or synchronized copy of `css/tokens.css`;
- retain Astro-specific aliases, Pagefind variables, resets, prose rules, and layout/component styles locally;
- remove duplicate canonical values from local styles where practical;
- resolve the existing `primary` mismatch rather than preserving compatibility aliases indefinitely.

Do not migrate `../website` separately unless it is still deployed or maintained. It shares a remote with `../blog-astro` and appears to be an older implementation; confirm its status first.

### 5.2 Verify the frontend

Run the project's existing checks and inspect at least:

- home/studio page;
- article/prose page;
- training page;
- navigation and footer;
- light and dark modes;
- mobile width;
- keyboard focus;
- reduced motion.

**Phase 5 exit criteria**

- Canonical CSS values originate in or are checked against this repository.
- Project-specific CSS remains local.
- The existing frontend build and checks pass.

---

## Phase 6 — Align visualization implementations

### 6.1 Update `../graphics`

Use `datavis/tokens.yml` as the reference for:

- `src/lib/theme/theme.css`;
- `src/lib/theme/colors.ts` canvas/WebGL fallbacks;
- examples and documentation;
- unit-test expectations.

Retain CSS variables in the package so consumers can override themes. Ensure canvas fallbacks match the light canonical defaults, since canvas cannot always resolve CSS at initialization time.

### 6.2 Update `../samizplot`

Modernize only the theme defaults required for alignment:

- Space Grotesk for display/title roles;
- Work Sans for body/legend/annotation roles;
- canonical background, foreground, muted, axis, and grid colors;
- canonical visualization palettes where the package exposes scales.

Prefer reading a project's `_brand.yml` through the existing `brand.yml` R package if that can be done without making normal plot creation fragile. Always retain packaged fallback defaults for standalone use.

Do not redesign the package API as part of this migration.

### 6.3 Add one cross-implementation check

Add the smallest runnable check that compares a critical subset across outputs, such as:

- accent;
- background;
- foreground;
- muted;
- display and body font families;
- categorical palette;
- sequential endpoints;
- diverging endpoints and midpoint.

The check should fail with a useful message when a consumer's packaged defaults drift.

**Phase 6 exit criteria**

- Web graphics and R graphics use the same named visual foundations.
- Existing graphics tests pass.
- One automated check catches future token drift.

---

## Phase 7 — Move and improve the agent skill

### 7.1 Add the canonical skill

Create `skills/samizdata-design/SKILL.md` with a precise trigger description covering:

- SAMIZDATA UI and UX;
- websites and components;
- Quarto documents;
- charts and data visualisations;
- logos, colors, typography, layout, and accessibility.

The skill should instruct agents to read, as appropriate:

- `DESIGN.md` for principles and rules;
- `_brand.yml` for portable values;
- `datavis/tokens.yml` for chart styling;
- `css/tokens.css` for exact web variable names.

Do not duplicate the full design specification in `SKILL.md`.

### 7.2 Install rather than fork the skill

Install or link this canonical skill in the agent environments used for SAMIZDATA work. For agents that require repository-local skills, provide a documented update/copy command.

After installation is verified:

- remove the independently maintained skill from `../blog-astro`, or replace it with a generated copy;
- add a short project instruction requiring the skill for SAMIZDATA visual work;
- verify that relative references resolve in the installed/copied form.

### 7.3 Test activation

Run a small agent task such as “review this component for SAMIZDATA design consistency” and confirm that the agent:

- loads the skill;
- consults the canonical references;
- uses semantic token names;
- does not invent colors or fonts;
- checks accessibility and responsive behavior.

**Phase 7 exit criteria**

- There is one independently editable skill source.
- The skill points to canonical resources rather than restating them.
- At least one real project can invoke it successfully.

---

## Phase 8 — Version, release, and document updates

### 8.1 Add simple versioning

Add a `VERSION` file and start with `1.0.0` once the canonical identity and first consumers are stable.

Use semantic intent:

- patch: documentation corrections or output fixes with no visual change;
- minor: additive tokens/assets or backward-compatible guidance;
- major: changed token meaning, removed tokens, typography changes, or intentional visual redesign.

Keep the same version in `_extension.yml` and generated artifact headers. Add a check rather than relying on manual review.

### 8.2 Tag a release

For each release:

1. run schema/consistency checks;
2. render the Quarto fixture;
3. run frontend and graphics checks affected by the change;
4. update `VERSION` and `_extension.yml`;
5. summarize visual or breaking changes;
6. tag the release;
7. update consumers deliberately.

Do not update consumer projects from an untagged branch when reproducible output matters.

### 8.3 Document the update procedure

Add concise commands to `README.md` for:

- updating the Quarto extension;
- refreshing frontend CSS tokens;
- refreshing a repository-local skill copy;
- running consistency checks;
- identifying the installed brand version.

**Phase 8 exit criteria**

- The design system has a tagged `1.0.0` release.
- Every migrated consumer records which release it uses.
- Updating a consumer is documented and repeatable.

---

## Final acceptance checklist

- [ ] This repository is the documented source of truth.
- [ ] The current Space Grotesk/Work Sans identity is approved and internally consistent.
- [ ] `_brand.yml` validates and resolves all assets.
- [ ] `DESIGN.md` describes cross-project rules rather than one website implementation.
- [ ] `datavis/tokens.yml` contains the approved chart system.
- [ ] `css/tokens.css` contains no component/page-specific rules.
- [ ] The Quarto brand extension installs from a tagged release.
- [ ] `jobs`, `cover-letters`, and `youth-jobs-gap` render with the shared brand or documented overrides.
- [ ] `blog-astro` consumes or is checked against shared CSS tokens.
- [ ] `graphics` and `samizplot` agree on core chart defaults.
- [ ] The agent skill is maintained here and works from at least one consumer project.
- [ ] A small automated check detects critical drift.
- [ ] No build fetches an unpinned remote brand automatically.
- [ ] The first stable design-system release is tagged.

## Later work

Only after the first migration is stable, consider:

- publishing `@samizdata/design` for frontend consumers;
- generating `_brand.yml`, CSS, TypeScript, and R artifacts from a more general token source;
- automatic dependency update pull requests;
- visual regression snapshots;
- a personal-site theme that inherits SAMIZDATA foundations while keeping its own identity;
- additional client or publication themes;
- shared components where repeated implementations have demonstrated a real need.
