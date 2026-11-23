---
name: taimzz9-ui-law
description: v2.1 · Taim Al-Bakri's (Taimzz9) UX and interface rulebook for a consistent, professional UI. Measurable baseline (WCAG 2.2 AA contrast, targets, focus, labels, states), a visual system (one accent, borders over shadows, a radius and spacing scale, tabular numbers), button, action and flow rules, dashboard and report rules, 30 usability laws with their real evidence strength, and patterns from Biwize client work. Apply whenever designing, building, reviewing or revising any UI, page, dashboard, report, form or flow, even if UX or design is not named. Review mode returns a findings table naming the rule broken and the fix.
license: MIT
---

# Taimzz9 UI Law

**Author:** Taim Al-Bakri (Taimzz9) · biwize.ca · Version 2.1, 2026-11-21

Goal: every screen looks like it came from one careful designer, and the user finishes their task fast, without confusion and without mistakes.

## How to use

- **Build mode:** run the Process at the bottom. Parts A to D are rules; Part E explains why; Part F holds patterns for recurring situations.
- **Review mode:** check Part A first, then B to D, then E. Report in the Review output format. Always name the rule (`B2`, `D4`, `Fitts`); no generic advice.
- **Priority when rules conflict:** A (access) beats everything. Then clarity, user control, finishing the task. Laws in Part E are lenses, never reasons to break A to D.

## Part A · Baseline: every screen passes

| # | Rule | Measure | Source |
|---|---|---|---|
| A1 | Text contrast | 4.5:1; large text (18 pt, or 14 pt bold) 3:1 | WCAG 2.2 1.4.3 AA |
| A2 | Contrast of controls, borders that define a control, chart marks, focus rings | 3:1 against adjacent colors | WCAG 1.4.11 AA |
| A3 | Color is never the only signal | Status also carries an icon, text or shape | WCAG 1.4.1 A |
| A4 | Target size | 24 by 24 CSS px is the legal floor. **House rule: 44 px hit area for anything touched** (Apple 44 pt); 48 px for field and gloved use (Material 48 dp). At least 8 px between adjacent targets | WCAG 2.5.8 AA, 2.5.5 AAA; Apple HIG; Material 3 |
| A5 | Keyboard and focus | Every action reachable by keyboard; focus always visible and never hidden under sticky bars or dialogs. House rule: 2 px focus ring at 3:1 | WCAG 2.4.7 AA, 2.4.11 AA, 2.4.13 AAA |
| A6 | Narrow screens | Works at 320 CSS px wide with no sideways scroll | WCAG 1.4.10 AA |
| A7 | Labels | Visible label or instruction on every input; a placeholder is never the label | WCAG 3.3.2 A |
| A8 | Icons | Every icon has a text label, except universal ones (close, search, print, play, share); icon only buttons get an accessible name | Laws of UX (cognitive load) |
| A9 | States | Loading, empty, error and success designed for every view, plus a designed 404 and outage page | NN/g; Laws of UX (peak end) |
| A10 | Errors | Keep the input; say what went wrong, where, and the exact fix, in plain words | |
| A11 | Plain language | The user's words, not the database's | |

## Part B · Visual system: one look everywhere

Consistency comes from tokens. Define color, type, spacing, radius and elevation once; never hard code a value in a component.

### B1 · Color

1. **One accent color.** It marks the primary action, the selected item, the link. Nothing else uses it, so it always means "act here" or "you are here".
2. **Neutrals carry the rest:** a grey scale for text, borders, surfaces. Soft, neutral colors by default let a bright color draw attention when it is needed (Few).
3. **Status colors only for status** (error, warning, success, info), always with an icon or word (A3). At most two alert levels on a dashboard, shown as one hue at two intensities (Few).
4. **No decorative gradients** on headers, buttons or chart fills. A gradient is allowed only when it encodes data (a sequential or diverging scale, a heatmap).
5. **Category colors only when they mean a category,** and the same category keeps the same color on every screen.
6. **Nothing looks like an ad.** Boxed, bright, image heavy blocks beside content get ignored (banner blindness); never put key content in that style (Selective attention).

### B2 · Surfaces, borders, elevation

1. **Borders define, shadows lift.** Cards, inputs, tables and panels sit flat and are separated by a 1 px border or spacing. A border that marks an interactive boundary meets 3:1 (A2); dividers between content can be lighter.
2. **Shadow only for layers above the page:** menus, popovers, dialogs, toasts, drag previews. Material 3 likewise keeps shadows for when protection from the background or a cue to interact is needed, and expresses other elevation as tonal surface color. When every card floats, nothing does.
3. **Radius scale** (aligned to Material 3's corner scale): 4 px for badges, checkboxes, chips; 8 px for inputs and buttons; 12 px for cards; 16 px for dialogs and sheets; full round only for pills and avatars. Avoid large corners on dense information cards.
4. **Nested corners:** inner radius = outer radius minus the padding between them, so curves stay parallel (Material 3 "optical roundness"). Never the same radius on a box and the box inside it.

### B3 · Type, links and numbers

1. One typeface family; one size scale (example: 12, 14, 16, 20, 24, 32). Weight and size make hierarchy, not color. Body text at least 16 px on the web (Apple default 17 pt).
2. **Sentence case** for buttons, headings and labels (Material, Carbon, GOV.UK). Exception: native Apple platform apps follow Apple's title case.
3. **Links look unlike body text** (accent color plus underline in running text); visited links styled where users revisit lists (Similarity, Working memory).
4. **Tabular figures for numbers that line up or change:** CSS `font-variant-numeric: tabular-nums` (needs a font with `tnum`).
5. **Numeric columns right aligned,** header included; identifiers (job numbers, codes) stay left aligned.
6. Every figure has its unit, a consistent number of decimals, and thousands separators for the locale.

### B4 · Space and alignment

1. One spacing scale on a 4 px base (4, 8, 12, 16, 24, 32, 48).
2. Related items closer than unrelated ones (Proximity). Align edges to a grid; no item off by a few pixels.
3. Long content is chunked into visibly separate groups with headings (Chunking).

### B5 · Copy

1. No filler: no "Welcome back" greetings, emoji or mascots in work tools. The first thing on screen is the answer.
2. Every number with a comparison names the period and the base: "Revenue Nov 1 to 21: $48,200, up 6.1% vs Oct 1 to 21", not "+12.5% from last month".

## Part C · Buttons, actions and flows

### Buttons

| # | Rule | Source |
|---|---|---|
| C1 | **One primary (filled) button per view.** Never more than two prominent buttons. Others are secondary (outlined). Text or ghost style only for low stakes actions such as Cancel; never for something the user must find (weak signifiers cost effort). A dialog or side panel opened on top gets its own primary | Material 3, Apple HIG, Carbon, GOV.UK, NN/g |
| C2 | **Label says what happens:** a verb, 1 to 3 words, sentence case (B3). "Create account", "Send invoice", "Save and continue". "Done" and "Cancel" are fine. Never "Submit", "OK", "Click here". Labels never truncate or wrap | Material 3, GOV.UK, Carbon, Apple HIG |
| C3 | **Size and spacing per A4.** The visible button can be smaller if its padding is part of the hit area | Apple, Material, WCAG |
| C4 | **Design every state in one pass:** default, hover, focus, pressed, loading, disabled; selected for toggles | NN/g, Material 3 |
| C5 | **Loading shows in the button:** spinner plus a progress label ("Saving…"), width unchanged; it blocks the second click, and the server ignores duplicates too | Apple HIG, GOV.UK, Carbon |
| C6 | **Disabled sparingly.** Prefer an enabled button that explains what is missing on click. If disabled, say why next to it, and keep it focusable (`aria-disabled`) | GOV.UK, NN/g |
| C7 | **Destructive actions** use the danger style, are never the primary, never icon only, and offer undo or a confirm that names the object ("Delete invoice 1042") | Apple HIG, Carbon |
| C8 | **Placement:** the primary sits where the task ends (under the last field, bottom right of a dialog in LTR). Same order on every screen | Fitts, Similarity |

### Flows

| # | Rule | Source |
|---|---|---|
| C9 | **One goal per entry screen;** autofocus its main input. Filters and extras appear after the first step | Laws of UX (Google Search, Hick) |
| C10 | **Prefill what is known** (user, company, last used job, billing as shipping) and keep it editable; suggest from history | Tesler, Default effect |
| C11 | **Progressive disclosure:** essentials first, advanced options behind one clear control. Do not simplify until the meaning is lost | Tesler, Occam |
| C12 | **Keep context visible on the next screen:** the search term, the selected record, the active filters, a breadcrumb. Recognition over recall | Working memory |
| C13 | **No blocking product tours.** Help sits at the point of use (inline hint, tooltip, empty state text); a getting started checklist can be reopened | Paradox of the active user |
| C14 | **High stakes steps (send, pay, post, delete) are calm:** a clear summary before, a clear confirmation after saying what happened and what is next | Peak end |

## Part D · Dashboards and reports

| # | Rule | Source |
|---|---|---|
| D1 | **Most important at upper left** (upper right in RTL) | Power BI guidance |
| D2 | **Hierarchy, not a grid of equals.** When one metric matters most, it is large and the rest are small (house default: 1 primary, up to 3 secondary). Peers of equal weight may share one size. Design first for the few views used most (Pareto) | Power BI guidance |
| D3 | **The number is the hero.** No icon tiles in pastel colors per card; four colors for four numbers is decoration. Color appears only when it encodes status or category (B1) | Few |
| D4 | **Context on every figure:** period, comparison base, sign and unit (B5). Prefer a sparkline over the same stated period to a bare percent badge | Tufte |
| D5 | Numbers per B3: tabular, right aligned, consistent decimals | MDN, Carbon |
| D6 | **Charts:** quantities by length and position, not color intensity or area; highlight one series, grey the rest; label directly instead of a legend where possible; gradients only for sequential data | Few, NN/g |
| D7 | **Bullet graphs instead of gauges:** label, linear scale from zero, the measure as a bar about a third of the height, 1 or 2 target marks, 2 to 5 qualitative ranges in one hue from dark (poor) to light (good) | Few, Bullet Graph Design Spec |
| D8 | **One semantic model** behind every visual, so the same number is the same everywhere | House rule |
| D9 | Active filters and the data refresh time are visible on the page | Working memory |

## Part E · The laws, and how much to trust them

Use these to explain a decision. Evidence column: **strong** (replicated research), **mixed** (real but conditional), **heuristic** (expert rule, little direct evidence).

### Deciding

| Law | What it says | Use it to | Do not | Evidence |
|---|---|---|---|---|
| Hick's Law (Hick 1952, Hyman 1953) | Choice time grows with the number and complexity of options | Cut options in fast, repeated choices; split complex tasks into steps; recommend one | Bury items in extra levels to shorten a menu | mixed |
| Choice overload (Toffler 1970; Iyengar and Lepper 2000) | Many options can stall choosing and lower satisfaction | Curate, filter, compare side by side, feature one | Remove filters experts rely on | mixed |
| Default effect (Johnson and Goldstein 2003) | People keep the preselected option | Preselect the safest common choice; prefill (C10) | Defaults that serve the business against the user; pre ticked consent | strong |
| Jakob's Law (Nielsen) | Users expect your screen to work like the ones they know | Follow conventions; break one only for a stated goal, proven in testing | Copy a competitor's flaw; novelty that costs usability | heuristic |
| Mental model (Craik 1943) | People reuse what they believe about similar systems | Match the user's model, found by research, not assumed | Design from the database's structure | strong |
| Pareto principle | About 80% of use comes from 20% of features | Polish and test the most used paths first | Drop the rare path that is critical | heuristic |

### Seeing and grouping

| Law | What it says | Use it to | Do not | Evidence |
|---|---|---|---|---|
| Proximity (Gestalt) | Near means related | Group with space | Rely on spacing that breaks when content wraps | strong |
| Common region (Gestalt; Palmer 1992) | A shared boundary means related | Cards, panels, fieldsets | Box every item | strong |
| Uniform connectedness (Gestalt; Palmer and Rock 1994) | Connected elements read as related | Steppers, trees, flows | Draw lines implying a sequence that is not real | strong |
| Similarity (Gestalt) | Same look means same kind | One style per kind of action; links unlike text | Style unrelated things alike | strong |
| Prägnanz (Wertheimer 1910) and Occam's razor | People read the simplest form; keep the simplest design that works | Remove elements until function would break, then stop | Cut what users need | heuristic |
| Serial position (Ebbinghaus) | First and last items are recalled best | Key items at the ends of short lists and nav; least important in the middle | Assume middle items in visible nav are ignored | strong for recall |
| Von Restorff (1933) | The odd one out is remembered | One primary action stands out (C1), with restraint | Highlight many things; rely on color alone; motion without a reduced motion option | strong for memory |
| Selective attention (Broadbent 1958) | Users filter out what looks irrelevant | Put key content where the eye already goes; flag real changes clearly | Style content like ads (B1.6); expect users to notice silent changes | strong |
| Aesthetic usability (Kurosu and Kashimura 1995) | Attractive designs are perceived as easier, and users forgive small flaws | Invest in polish (Part B) | Treat polish as proof of usability; it hides problems in tests | mixed |

### Acting

| Law | What it says | Use it to | Do not | Evidence |
|---|---|---|---|---|
| Fitts's Law (Fitts 1954) | Time to hit a target depends on its distance and size | Big, near, well spaced targets for frequent actions (A4) | Put large destructive buttons next to frequent ones | strong |
| Doherty threshold (Doherty and Thadhani, IBM 1982) | Productivity rose sharply as response time fell below about one second; "400 ms" is a later popular figure, not in the report | Respond at once: pressed state, skeleton, optimistic update, progress for longer waits | Quote 400 ms as research | mixed |
| Postel's Law (RFC 761, 1980) | Accept liberally, output strictly | Accept "416 555 0100" and "(416) 555-0100"; store one format; state the boundary and confirm the result | Guess ambiguous input such as 03/04 | heuristic |
| Tesler's Law (Tesler, Xerox PARC) | Complexity does not vanish; someone carries it | Carry it in the system (C10, C11) | Design for an idealised, rational user; hide settings users must control | heuristic |
| Paradox of the active user (Rosson and Carroll 1987) | Users start using a product without reading help | Help in context (C13) | Rely on manuals or upfront tours | mixed |
| Flow (Csikszentmihalyi 1975) | Full focus comes when challenge matches skill and feedback is instant | Keep repeated work fast and free of interruptions | Add steps or pop ups to frequent tasks | mixed |

### Remembering and finishing

| Law | What it says | Use it to | Do not | Evidence |
|---|---|---|---|---|
| Cognitive load (Sweller 1988) | Effort has a limit; intrinsic load comes from the task, extraneous load from the design | Cut extraneous load: noise, decoration, unclear labels | Remove information the task needs | strong |
| Miller's Law and chunking (Miller 1956; Cowan 2001 says about 4) | Short term memory holds few chunks | Chunk phone numbers, codes, long forms | Cap visible menus at 7; they need no recall | mixed |
| Working memory (Atkinson and Shiffrin 1968) | A few chunks for about 20 to 30 s | Recognition over recall; carry information across screens (C12) | Ask users to remember a value from a previous screen | strong |
| Task resumption (Ovsiankina; replaces Zeigarnik) | People tend to return to interrupted tasks; Zeigarnik's memory claim did not hold up (Ghibellini and Meier 2025 meta analysis) | Save drafts, show progress, resume in one click | Nag with "incomplete profile" claims | mixed |
| Goal gradient (Hull 1932; Kivetz 2006) | Effort rises as the goal gets near | Show steps left; an honest head start | Fake progress | mixed |
| Peak end rule (Kahneman et al. 1993) | Experiences are judged by their peak and end; bad moments weigh more | Fix the worst moment first; design errors, 404, outages and the success screen (A9, C14) | Polish the end and ignore the middle | mixed |
| Cognitive bias (Tversky and Kahneman) | Judgment errs in systematic ways, designers' too | In reviews, name the bias (confirmation bias) before trusting a finding | Treat one user's opinion as research | strong |

Not used: Parkinson's Law (a satire about bureaucracy and time, not a UI finding).

## Part F · Patterns from Biwize work

| Situation | Do this | Rules |
|---|---|---|
| **Field tools for non technical users on site** replacing a paper form | The paper form is the familiar pattern. Keep its field order. Pickers for codes instead of free text. Default to the last used value. 48 px targets for outdoor, one handed, gloved use | Jakob, Hick, Default effect, A4 |
| **Tools over a client's ERP or accounting system** | Use the system's own field names, codes and structure; renaming adds a translation step | Jakob, Mental model |
| **A family of internal apps for one client** (shared sign in, one tenant) | One token set and one interaction language across all of them | Part B, Similarity |
| **Redesigning a tool people already use** | Announce it, let users switch to the new version and back for a set period, then retire the old one | Jakob, Mental model |
| **Anything in a client's brand** | Use the client's brand kit (palette, fonts, logo files) as the tokens in Part B; never invent a palette. The brand's main color becomes the single accent | B1 |
| **Sites nobody maintains day to day** | Plain, standard patterns; nothing custom that needs upkeep | Tesler |
| **Power BI and other reports** | Part D. Semantic model first, then visuals | D1 to D9 |
| **Bilingual sites, including RTL** (EN and AR, EN and FR) | `lang` and `dir` set per page; layout mirrored for RTL; the language switch is in the same place on every page and keeps the user on the same page | Jakob, Similarity |
| **Sensitive services** (counselling, health) | A help or crisis route visible on every page; no third party requests (trackers, external fonts, embeds) | A3, Peak end |
| **Owner run business sites** | One primary action per page (call, book, request a quote); contact details visible without scrolling on a phone | C1, Hick |

## Process

1. Name the primary goal and the actual user (office staff, a worker on site, a site visitor, an owner reading a report).
2. Load the tokens (Part B), or the client's brand kit as tokens.
3. Design the shortest clear path to the goal; one primary action (C1).
4. Pass Part A; apply C and D; check against Part E; use any Part F pattern.
5. Design every state (A9, C4) and the success state (C14).
6. Review against the format below before handing over.

## Review output format

| # | Screen or element | Rule | Problem | Fix | Severity |
|---|---|---|---|---|---|
| 1 | Revenue card | D4, B5 | "+12.5%" with no period or base | "Nov 1 to 21 vs Oct 1 to 21, up 6.1%" plus sparkline | Medium |
| 2 | Save button | A4, C3 | Hit area 32 px on a tablet app | 44 px hit area | High |

Severity: **High** blocks the task or excludes a user (any Part A failure). **Medium** slows, confuses or breaks consistency. **Low** polish. Sort High first; end with the count per severity.

## Sources

WCAG 2.2 (w3.org/TR/WCAG22) · Apple Human Interface Guidelines, buttons and accessibility (developer.apple.com/design/human-interface-guidelines) · Material Design 3: buttons, structure, elevation, corner radius scale (m3.material.io) · IBM Carbon button usage (carbondesignsystem.com) · GOV.UK Design System, button (design-system.service.gov.uk) · Nielsen Norman Group: button states, flat UI and weak signifiers, flat design best practices (nngroup.com) · Stephen Few: Bullet Graph Design Spec and Dashboard Design for Real Time Situation Awareness (perceptualedge.com) · Microsoft Learn, Power BI report design · Edward Tufte on sparklines · MDN font-variant-numeric · Doherty and Thadhani, The Economic Value of Rapid Response Time, IBM 1982 · Ghibellini and Meier 2025, Humanities and Social Sciences Communications 12:962 · **Laws of UX by Jon Yablonski** (lawsofux.com, CC BY-NC-ND 4.0): laws and articles paraphrased here, not reproduced.

House rules (no single external source, chosen for consistency): shadow only on layers above the page; 1 primary plus up to 3 secondary metrics; 44 px touch minimum and 8 px target spacing; 2 px focus ring; the radius and spacing tokens.
