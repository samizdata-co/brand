# SAMIZDATA design guidelines

## Purpose and authority

SAMIZDATA's identity should feel **precise, credible, editorial, and quietly confident**: rigorous enough for investigations and data work, but warm and readable rather than institutional or corporate.

Use these files together:

- [`_brand.yml`](_brand.yml) is authoritative for portable identity, logo, color, and typography values.
- [`css/tokens.css`](css/tokens.css) exposes the shared web vocabulary.
- [`datavis/tokens.yml`](datavis/tokens.yml) extends the system for charts and maps.
- This document explains how and why to use those values.

When prose and a machine-readable token disagree, treat it as a defect rather than choosing whichever value is convenient. Product-specific layout and components may remain local, but they should be built from these foundations.

## Identity

The system balances editorial gravitas with contemporary data practice:

- one restrained dried-raspberry accent;
- warm, paper-like neutral surfaces;
- geometric display typography paired with readable humanist body typography;
- sharp structural forms;
- tonal layering instead of decorative effects;
- clear information hierarchy and accessible interaction.

The system applies to the studio website, publications, reports, training material, charts, tools, and presentations. A format does not need to reproduce every web treatment to remain recognisably SAMIZDATA.

## Logo

The canonical mark is three horizontal data bars. The first and third are quiet, the middle is emphasized, and the third is shorter. It suggests both structured text and a compact chart without committing the identity to a specific visualization type.

- Use [`assets/logos/mark.svg`](assets/logos/mark.svg) on light backgrounds.
- Use [`assets/logos/mark-dark.svg`](assets/logos/mark-dark.svg) on dark backgrounds.
- Use [`assets/logos/mark-512.png`](assets/logos/mark-512.png) only where raster artwork is required.
- Pair the mark with `SAMIZDATA` in uppercase Space Grotesk 900 when a wordmark is needed.
- Keep the mark's proportions and bar geometry intact. Do not recolor individual bars.
- Provide useful surrounding text or the accessible name “SAMIZDATA” when the mark conveys identity.

Web interfaces may animate the bars into a scatter plot. This is optional decoration, not part of the mark required by other formats. A static version must be used when reduced motion is requested.

## Color

The named values and light/dark variants live in `_brand.yml`. Use semantic roles rather than copying hex values.

### Raspberry roles

The raspberry family has deliberately separate jobs:

- **Primary** is the deep brand ink used for logo marks, strong emphasis, and hover states.
- **Primary container** is the brighter fill used for primary controls, selected regions, and occasional accent panels.
- **Accent text** is the contrast-safe color for links, small labels, annotations, and focus indicators.

These roles coincide in places in light mode but diverge in dark mode. Never collapse them into one alias. In particular, dark primary and primary-container colors are not safe for small text.

Use raspberry sparingly. One emphasized phrase, active state, or leading data series is usually enough. It should communicate hierarchy or interaction, not decorate empty space.

### Surfaces and text

The neutral ramp is warm and paper-like:

- **Surface** is the page foundation.
- **Surface low/container/high/highest** create section rhythm, insets, hover states, and elevation.
- **Surface lowest** is reserved for raised cards and popovers.
- **Surface dim** is the deepest canvas value.
- **Ink** is primary text.
- **Muted** is normal body and secondary text—the system's quieter voice.

Prefer tonal separation over shadows. Low-alpha borders and outlines add quiet structure, but they are decorative and must not be the sole signal for an essential boundary or state.

### Destructive states

Destructive fill and destructive text are separate tokens. Use the fill only for destructive controls or regions, and the text token for error copy. In dark mode, destructive fills use dark ink rather than white text to maintain contrast.

Do not introduce raw saturated status colors merely because a framework provides them. Add a tested semantic token only when the product genuinely needs that state.

## Typography

### Display, headings, and labels

Use **Space Grotesk**:

- weight 900 for display and headings;
- weight 700 for introductions, labels, navigation, and controls;
- tight negative tracking (`-0.04em` to `-0.06em`) and compressed line height (`0.85`–`0.95`) for large display text;
- uppercase with generous tracking (`0.18em`–`0.22em`) for labels and eyebrows.

Large typography should scale fluidly rather than forcing desktop sizes onto narrow screens. Avoid using more than the 700 and 900 display weights in one output.

### Body

Use **Work Sans**:

- weight 400 for normal copy;
- weight 500 for modest emphasis and links;
- line height 1.6–1.75 for reading;
- muted rather than pure ink for long body passages when contrast remains sufficient.

The canonical web font subsets include Latin and Latin Extended so Romanian diacritics render correctly.

### Code and data

Use the native monospace stack in `css/tokens.css`. A platform-native monospace face is an intentional exception to the two branded families. Code should not use ligatures when they can obscure literal characters.

The brand declares Space Grotesk and Work Sans through Bunny Fonts for portable Quarto/web use. Consumers that must work offline or embed all resources may provide local copies of the same families and weights as a delivery override.

## Spacing and layout

Use a 4px-derived spacing rhythm: **4 / 8 / 16 / 24 / 32 / 64px**. Prefer combinations of these steps over arbitrary gaps.

Shared layout limits are tokens rather than mandatory page templates:

- maximum wide shell: 1440px;
- standard grid gap: 24px;
- spacious section block: up to 128px;
- tight section block: up to 64px;
- fixed-navigation offset where applicable: 88px.

Editorial documents may use narrower reading measures. Charts may use denser spacing. Preserve the underlying rhythm instead of forcing website dimensions into every format.

## Shape and depth

The shape language is architectural and sharp:

- cards, buttons, tags, inputs, document panels, and chart containers default to 0 radius;
- icon-only controls may be circular;
- detached transient layers such as popovers may use up to 16px radius;
- the logo bars retain their 1px corners;
- inline code may use a subtle 2px radius.

Communicate depth primarily with the surface ramp. The ambient shadow is reserved for genuinely raised or interactive elements. Avoid stacks of heavy shadows, gradients used only as ornament, and mixed radius styles without semantic reason.

## Interaction and motion

- Every interactive element must have a visible keyboard focus indicator using the accent-text token, 2px width, and approximately 3px offset.
- Default interaction transitions should be restrained, around 180–220ms.
- Cards may lift by 0.2rem on hover when this helps show interactivity.
- Longer image or logo animations must be decorative and interruptible.
- Honor `prefers-reduced-motion: reduce`; shared transition duration becomes 0ms.
- Do not rely on hover alone to reveal essential information or actions.
- Interactive targets should be at least 44×44px where practical.

## Components

These are behavioral and visual rules, not a shared framework implementation.

### Buttons

- **Primary:** primary-container fill, contrasting foreground, sharp corners; hover deepens to primary.
- **Outline:** transparent or surface fill, visible border, ink text; hover introduces raspberry emphasis.
- **Ghost:** borderless and quiet; rounding is acceptable only when it reads as a detached control.
- **Destructive:** destructive intent only, using the tested fill/foreground pairing.
- **Link:** textual action with a visible underline or equally clear affordance.

Labels use Space Grotesk 700, uppercase, and tracked lettering. Focus uses accent-text—not the filled-control color.

### Cards and panels

Use surface-lowest on a tonal parent, a soft 1px border, and 0 radius. Hover may add a small lift, ambient shadow, and accent border. Accent cards invert to primary-container sparingly; they should not dominate every grid.

### Labels and tags

Use the compact “data label” voice: Space Grotesk 700, uppercase, and generous tracking. A selected tag needs more than a low-contrast border—use fill, text weight, or another redundant state cue.

### Long-form content

Prioritize reading over display treatments. Use restrained heading sizes, generous body line height, underlined links, horizontal overflow for code, and clear table structure. Avoid carrying oversized studio display type into reports or training prose.

## Data visualisation

Chart-specific values are in `datavis/tokens.yml`.

### Typography and structure

- Work Sans is the default for axes, labels, annotations, legends, and tooltips.
- Space Grotesk is reserved for chart titles, display values, and strong labels.
- Essential axes, ticks, baselines, and reference lines must reach 3:1 against adjacent colors.
- Low-alpha gridlines are decorative and may remain quiet when labels and position carry meaning.
- Prefer direct labels and annotations over legends when space permits.

### Color scales

- **Categorical:** distinguishes unordered groups. Do not imply ranking through palette order.
- **Sequential:** runs light to dark for ordered magnitude. Preserve its luminance order.
- **Diverging:** use only when the midpoint is meaningful, such as zero or a benchmark.
- Use the raspberry accent for the leading series or positive pole, not automatically for every mark.
- Never rely on color alone; pair it with position, shape, label, pattern, or direct annotation.
- Test dark-mode charts independently rather than mechanically swapping the background.

Allow project-specific palettes when data semantics or accessibility require them, but document the reason and retain the shared structural styling.

## Accessibility baseline

Normal-size text targets **WCAG AA 4.5:1**. Essential non-text controls, focus indicators, and chart geometry target **3:1** against adjacent colors.

| Role | Light | Dark | Minimum observed contrast on the relevant surface ramp |
|---|---|---|---:|
| Ink | `#1b1c19` | `#f4efe9` | 10.52:1 |
| Muted | `#574146` | `#c2b7b3` | 6.14:1 |
| Accent text/focus | `#7b003c` | `#f078a6` | 4.55:1 |
| Primary fill + white | `#9f1853` | `#c62168` | 5.50:1 |
| Destructive text | `#a52f56` | `#e98bab` | 4.78:1 |
| Destructive fill | white on `#c0476b` | `#111311` on `#d06b8c` | 4.82:1 |

Never reduce the opacity of text or focus tokens without recalculating contrast. Decorative border tokens do not meet 3:1 and cannot independently convey input boundaries, selected states, or chart axes.

## Adaptation across projects

The following are valid consumer-specific adaptations when documented:

- local font files for offline or embedded output;
- a narrower document measure or denser chart layout;
- chart palettes required by data semantics;
- client or publication branding that explicitly supersedes SAMIZDATA defaults;
- substitutions required by PDF, Canvas, WebGL, or another output limitation.

An adaptation should override the smallest possible semantic layer. Do not copy and fork the complete palette to change one value.

## Do and don't

- **Do** use semantic token names and preserve separate text/fill roles.
- **Do** use raspberry as emphasis, not decoration.
- **Do** use tonal surfaces for hierarchy.
- **Do** test light, dark, keyboard, narrow-screen, and reduced-motion behavior.
- **Don't** revive the retired Roboto/Roboto Slab, IBM cool-gray, `#faf9f6`, rounded-card identity.
- **Don't** set long body copy in pure black or oversized display typography.
- **Don't** add arbitrary radii, shadows, saturated colors, or spacing values.
- **Don't** guess when `_brand.yml`, CSS tokens, or visualization tokens provide a named value.
