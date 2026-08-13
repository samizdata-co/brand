# Brand guidelines


# Website revamp

I currently have a very simple SvelteKit one-page website for my small data journalism consultancy (https://samizdata.co/).

I haven't been promoting it much, but some business is coming through it, and I want to make sure it reflects the work I do and the services I offer.

The goal is to revamp it with multiple pages, two languages (English and Romanian), a more opinionated and bold design, dark and light mode, and general improvements to the user experience.

There is also an opportunity to redesign the website from scratch, including new branding, logo, colours, typography, and overall visual identity. The goal is to make it modern, bold, professional.

I also have a training website (https://training.nicu.md/) buiolt in Quarto. As my agency also offers training, I want to move it into the main SAMIZDATA website. This would be either done as a transition from Quarto to SvelteKit, or by ensuring the Quarto website is visually and functionally integrated into the main website.

### Must-haves

- [ ] This is a dual-language website in English and Romanian.
- [ ] Light and dark mode.
- [ ] GDPR-compliant analytics.


- What we do
    - Journalism & research
    - Data analysis
    - Data visualisation
    - Training (move training website here)
- Our work
<!-- - Testimonials (when we have them) -->
- Meet the team (Nicu bio)
- Carousel of publisher logos
- Contact / call to action


# AI instructions

SAMIZDATA is a small data journalism, research, visualisation and training consultancy. We work with media organisations, NGOs and other organisations.

Build a brand identity for SAMIZDATA, including a logo, colour palette, typography, and overall visual style. The brand should be modern, bold, professional, and reflect the work we do in data journalism and research. The logo should be simple and memorable, and the colour palette should be versatile for use across different media. There will be a dark mode we will work on later, so keep that in mind.

We will design the homepage of the website first, don't worry about the other pages for now.

We want a navbar at the top with the following sections:

Logo on the left
- Who we are
- Contact
- Language switcher (EN by default)
- Dark mode toggle

Then, on the homepage, we want a big full-width section with some sort of data-y animation. On top of it, the following text: "SAMIZDATA is a consultancy for data-driven storytelling."

And underneath, a short bio: "We research, write and build data tools for media organisations, NGOs and other public benefit organisations.". Then two buttons: "Let's talk!" and "What we do".

---

The next section is a grid of both the services we offer and examples of our work.

Essentially, we want these kinds of components to begin with:

- A "service" component with a title and short description. This could be "Dashboards", "Journalism", "Training", etc.
- A "article" component with a title, short description, date, and publisher. The card/component should have a darkened thumbnail.
- A "tool" component with a thumbnail (perhaps a gif) with no darkening. The title should only be revealed on hover.

Under the grid, we want a "See more" button.

---

Get in touch section with an email address: mail@samizdata.co.

---

Footer with a small logo, mail@samizdata.co, address (London, UK), copyright notice.


#  Things I like

The best site oveall is [Parabole](https://www.parabole.studio/). It uses nice, simple colours (off-white, off-black, muted greens and browns). Feels very earthy and natural. The Safiro font is nice, opinionated but not too much.

[Beyond Words](https://beyondwordsstudio.com/) is a nice example of a simple, clean, modern website. Many bold colours on a white background makes them stand out. Perhaps a bit too childish for my taste, but it works really well together.

I really like the grid of services and examples of work from [Thibi](https://site.thibi.co/). I could do something similar (perhaps with animations) to show the different services I offer and examples of work. One issue is much of the work is not visual.

[Mongabay Studio](https://studio.mongabay.com/) does this nicely on the homepage. They start with a section of "Data Tools" with a title, short description, call to action and thumbnail. Then underneath they have a "Data Journalism" section with a more traditional news layout.

[Sheldon.studio](https://sheldon.studio/) has a similar grid layout of various components they can arrange in different ways. I really like their "Find out what we can do for" section which links to different pages for different types of clients (journalists, NGOs, etc).

We probably want to build a series of components that we can reuse across the website. One would be a

