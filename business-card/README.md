This document outlines Nicu Calcea's business card concept.

Technical specification:

- Single side
- 85mm × 55mm
- Vertical
- Exported from PDF (but can be made in raw SVG initially)

It follows the SAMIZDATA design guidelines, colours, fonts and logo/mark. It uses flat design (no shadows or gradients), is bold, unique, professional and creative.

It needs to include the following information:

- Name: Nicu Calcea
- Job: Investigative Data Journalist @ SAMIZDATA (samizdata.co)
- Email: mail@nicu.md
- Website: nicu.md
- Work website: samizdata.co
- Phone nrs: +44 7784 751562 (UK, Whatsapp, Signal) and +373 699 93 781 (MD)
- QR code linking to https://nicu.md/

The landing page should be a simple, mobile-friendly page with a links to download a vCard, email, social media, portfolio, CV, and samizdata.co. This will be created at a later stage.

## Render files

From this directory, run:

```sh
rsvg-convert -f pdf -o business-card.pdf business-card.svg
rsvg-convert -o business-card.png -w 1100 business-card.svg
```

This requires `rsvg-convert` (from librsvg).
