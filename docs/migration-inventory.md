# Migration inventory

This records the Phase 1 comparison used to establish the current identity. It is historical migration context, not an alternative set of guidelines.

| Source | Already aligned | Drift to remove or classify |
|---|---|---|
| `../../blog-astro/src/styles/global.css` | Warm light/dark ramps; Space Grotesk/Work Sans; sharp shapes; current spacing and layout. | Phase 1 separated primary, filled-primary, text accent, focus, and destructive roles. Phase 5 will consume shared CSS tokens. |
| `../../blog-astro/.agents/skills/samizdata-design/references/DESIGN.md` | Current principles, components, typography, spacing, and most colors. | Phase 1 corrected focus and destructive semantics. The canonical skill will move here in Phase 7. |
| `../../graphics/src/lib/theme/theme.css` | Current fonts, core surfaces, accent, spacing, chart palettes, and reduced motion. | Chart dark surfaces are a smaller purposeful subset; essential and decorative structural roles need to remain distinct. |
| `../../graphics/src/lib/theme/colors.ts` | Canvas fallbacks match the current light chart theme. | Necessary duplicated fallbacks need a consistency check. |
| `../_brand.yml` and `../css/app.css` before Phase 2 | Historical raspberry and warm-background lineage. | Roboto/Roboto Slab/Roboto Mono, `#faf9f6`, IBM cool grays, 0.5rem structural radius, and the Konstruktor wordmark were retired. |
| `../../samizplot/R/theme_samizdata.R` | Historical warm background and raspberry lineage. | Roboto typography, `#404040` text, `#d8d8d8` grid, oversized axis text, and inherited “pilot” documentation remain to migrate. |
| `../../../jobs/_brand.yml` | Historical accent and semantic status colors. | Old fonts/colors and a complete local brand copy remain to migrate. |
| `../../../jobs/cover-letters/_brand.yml` | Same historical identity with useful local font embedding. | Font delivery is a consumer requirement, not a separate identity. |
| `../../youth-jobs-gap/_quarto.yml` | Historical warm/ruby direction. | Noto Sans/Roboto Slab and hard-coded PDF colors remain to migrate or document. |
| `../../website/src/app.css` | Much of the current ramp, type, and sharp shape language. | Older duplicate implementation; confirm whether it remains active before changing it. |

Intentional consumer differences include offline font delivery, native monospace, chart-only palettes, decorative gridlines, output-format limitations, and explicit client branding overrides.
