---
name: samizdata-design
description: Use this skill every time you design a SAMIZDATA website, Quarto document, chart, map, or any other project. This includes the nicu.md website.
---

# SAMIZDATA design

These are the design guidelines for the SAMIZDATA brand. Always follow these principles, do not deviate from them. Use the canonical resources in this skill instead of inventing or copying visual values:

- [Design guidelines](references/DESIGN.md) for principles, semantics, accessibility, and permitted adaptation.
- [Quarto brand](references/_brand.yml) for portable identity, logo, color, and typography values.
- [Data-visualisation tokens](references/datavis-tokens.yml) for chart and map styling.
- [CSS tokens](references/css-tokens.css) for exact `--sz-*` web properties.

Read the design guidelines for every SAMIZDATA visual task. Also read the machine-readable resource relevant to the output format.

## Workflow

1. Identify whether the work is shared foundation or product-specific implementation.
2. Reuse semantic token names; do not introduce raw colors, fonts, radii, or spacing where a canonical role exists.
3. Keep framework components, page layout, and necessary format overrides in the consumer project.
4. Preserve the distinction between primary ink, filled controls, and accessible accent text, especially in dark mode.
5. Check light and dark themes, responsive behavior, keyboard focus, contrast, reduced motion, and non-color meaning as applicable.
6. For charts, choose categorical, sequential, or diverging palettes according to data semantics and verify dark mode independently.
7. Report intentional consumer overrides and their reason rather than silently forking the system.

If canonical files disagree, treat that as drift to fix; do not choose whichever value is convenient. Do not redesign SAMIZDATA or add a new design-system dependency unless explicitly requested.
