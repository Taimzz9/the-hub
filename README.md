# TAISAM AI Cheat Sheet

**Beta users** · v26.6.20 · A BW field guide

> **Compiled by AI, so it reads easily.** This cheat sheet distills years of collective, practical knowledge dumped by **Wesam**, **Kimia**, and **Taim**. The AI organized and formatted it. The judgment and standards behind it are Professional Humans.

---

## A reminder before you start

### AI brings you to the mean. Plus 5 to 10%.

It accelerates the knowledge you already have. It does not give you the knowledge you don't.

- **Lower 50% (you will love it).** If you are in the lower half of knowledge in a domain, you will love AI. It raises your output immediately, and you watch, in real time, how it makes you better.
- **Top 25% (you will complain).** If you are in the top quarter, you detect AI work instantly. You recognize its faults and its shortcuts, and you complain about it, because you know exactly where the limits are.

**The rule.** Use AI to move faster through work you already understand, not to produce work you could not produce yourself. If you cannot frame the problem, the structure, and the standard for "correct" without AI, then you are not ready to use AI on it. You will not be able to tell when it is wrong.

> "The knowledge and intelligence required to produce a correct answer are the exact same qualities needed to recognize a correct answer."
>
> David Dunning, on the Dunning Kruger effect

AI raises your output before it raises your judgment. **Speed is not competence.**

---

## How to use this guide

Jump to the section that matches where you are today. Each section stands alone. Every prompt is copy ready.

| You are | Start at |
|---|---|
| Business professional, new to AI | 1, then 2, then 3 |
| Developer starting to use AI tools | 1, then 2, then 4 |
| Building production AI systems | 4, then 5, 6, 7 |
| Looking for a specific prompt template | 8 (Prompt Library) |

---

## 1. Mental Models: How to Think About AI

### The one thing that matters most

AI models are next-token predictors trained on human writing. They predict the most statistically plausible continuation of your input. Everything else (the reasoning, the creativity, the apparent intelligence) is an emergent property of that prediction at scale.

This explains why specificity matters (vague input produces statistically average output), why hallucination happens (plausible is not the same as accurate), and why formatting your output request shapes the thinking process.

### The three collaboration modes

| Mode | When to use | Mental model |
|---|---|---|
| **Consultant** | Strategy, writing, analysis | Senior colleague you can argue with |
| **Operator** | Repetitive structured tasks | Very fast intern with perfect recall |
| **Pair programmer** | Code, debugging, architecture | Senior engineer reviewing with you in real time |

### What AI is genuinely better at than humans

- First drafts (10x faster, good enough to edit)
- Pattern matching across large bodies of text
- Generating exhaustive option sets you can then filter
- Debugging by explaining code or logic to itself
- Maintaining consistency across long documents
- Summarization and extraction

### What AI is genuinely worse at than humans

- Knowing what it does not know (it will confidently invent)
- Anything requiring current information (knowledge cutoffs exist)
- Counting, arithmetic, precise numerical reasoning
- Judgment about social or political nuance in your specific context
- Replacing customer conversation and relationship
- Tasks where all the context lives entirely in your head

> **The 15-second rule.** If your prompt takes less than 15 seconds to write, it will usually produce output you spend 15 minutes fixing. Prompt quality is the highest-leverage investment you can make.

---

## 2. Session Hygiene (Everyone)

These habits apply whether you are a first-day user or a senior engineer. They are the difference between AI that helps you and AI that wastes your time.

### The opening session prompt

Use this at the start of every complex task. AI sessions have no persistent memory. This forces the model to externalize context into documents you control so you can resume, audit, and hand off without losing work.

```
Before we begin: create three documents and maintain them throughout our session.

1. PLAN.md — the implementation plan. Break the work into phases. List what needs to happen before we can start, what we'll build in order, and what the done state looks like for each phase.

2. CHANGELOG.md — a running log of every decision made, every file modified, every approach considered and rejected. Update after each significant action.

3. HANDOFF.md — a document I could give to another AI (or team member) to pick up exactly where we left off. Include: current state, what's done, what's in progress, what's blocked, key context they'd need, and exact next steps.

Treat this as a full production cycle. Never assume anything — ask me clarifying questions before starting. I'd rather answer 10 questions now than undo 2 hours of work later.

The task: [YOUR TASK HERE]
```

### Context dump (before any complex session)

Bad prompt: "Fix the bug in my code." A good prompt looks like this:

```
Context:
- Project: [what it is, who uses it, what language/stack]
- Current state: [what works, what doesn't]
- What I've already tried: [list everything, even things that didn't work]
- The specific problem: [exact error message, exact behavior]
- What "fixed" looks like: [the acceptance criteria]
- Constraints: [time, don't change X, must work with Y]

Task: [now ask the specific thing]
```

### Session handoff (before closing a complex session)

```
Summarize this session for a future AI assistant who will pick up this work:
- What did we build/change/decide?
- What files were modified and what changed in each?
- What's the current state of the work?
- What's the next logical step?
- What should they NOT do (traps to avoid)?
- What context would they need that isn't obvious from the code?
```

### Surface assumptions before starting

```
Before you begin, list every assumption you're making about this task.
For each assumption, rate your confidence (high / medium / low).
Flag any assumption that, if wrong, would cause the output to be useless.
Then ask me to confirm the low-confidence ones before proceeding.
```

### Second opinion on any important output

```
Now take the other side. What's the strongest argument against what you just said?
What did you overlook? What would a skeptic say?
```

---

## 3. Business Professionals: Practical AI

### Email drafting

```
Write an email from [my role] to [recipient role] about [topic].
Tone: [professional / direct / warm / urgent]
Goal: [what I want them to do or feel after reading]
Key points to include: [bullet list]
Key points to avoid: [things that would cause friction]
Length: [2 short paragraphs / whatever it takes to be complete but not padded]
```

### Deck narrative

```
I'm building a presentation for [audience] about [topic].
The decision they need to make after seeing this: [specific action/decision]
Key data points I have: [list]
The 3-5 slides I think I need: [your guess]

Draft the narrative arc: what story does this deck tell from opening to close?
Then suggest a one-sentence headline for each slide.
```

### Meeting prep

```
I have a [meeting type] with [role/company] in [X minutes/hours].
Context: [what the relationship is, what stage we're at]
My goal for this meeting: [specific outcome]
What I know about their situation: [everything relevant]
What I'm uncertain about: [things I don't know]

Give me:
1. The 3 things I must accomplish
2. 5 questions I should ask
3. The objection they're most likely to raise and how to handle it
4. One thing I should NOT do in this meeting
```

### Synthesizing a document

```
Read this [document/article/report] and extract:
1. The 3-5 most important claims the author makes
2. The evidence they cite for each
3. What they assume without supporting
4. The one thing I should remember in a week
5. What questions this raises that it doesn't answer

[paste document]
```

### Structured comparison

```
Compare [Option A] vs [Option B] for [my specific situation].
My situation: [context]
I care most about: [criteria, ranked]
I care least about: [criteria]
Output as a table, then give me a direct recommendation with reasoning.
```

### Decision framework

```
I'm deciding whether to [decision].
Factors for: [list]
Factors against: [list]
What I'm most uncertain about: [specific unknowns]

Help me structure this decision. Don't make it for me.
Surface the assumptions I'm making.
Tell me what information, if I had it, would change the outcome.
```

> **The privacy rule.** Never paste customer PII, internal financial data, employee performance data, proprietary IP, or sensitive legal terms into a public AI. Anonymize first: "A large enterprise client in financial services did X" not "Acme Corp did X."

---

## 4. Developers: Code and Architecture

### Code review

```
Review this code as if you're a senior engineer who has to maintain it in 2 years.

Focus on:
1. Correctness — does it do what it claims?
2. Edge cases — what inputs or states would break it?
3. Security — any injection, auth bypass, data exposure risks?
4. Performance — anything that will hurt at scale?
5. Readability — would a new team member understand this in 5 minutes?
6. Unnecessary complexity — what can be deleted without loss?

Be direct. If something is wrong, say it's wrong.
Don't suggest a refactor unless it materially changes one of the above.

[paste code]
```

### Debugging

```
This code is producing [exact output/error].
I expected [expected behavior].
Here's what I've already tried: [list]

[paste minimal reproduction case]

Don't give me the answer immediately.
First, tell me your mental model of what this code does step by step.
Then identify where the model diverges from the expected behavior.
Then propose a fix and explain why it addresses the root cause.
```

### Architecture design

```
I need to design [system description].

Constraints:
- Scale: [current and projected load]
- Team size: [who will maintain this]
- Existing stack: [what we can't change]
- Timeline: [when this needs to work]
- Non-negotiables: [things that cannot be compromised]

Walk me through three architecturally distinct approaches.
For each: the core idea, what it's good at, what it fails at, and what I'd regret in 18 months.
Then recommend one, and tell me what you'd need to know to change that recommendation.
```

### Test generation

```
Generate tests for this function.

Coverage I care about:
- Happy path (nominal inputs)
- Edge cases: [list the ones you know about, ask for more]
- Known failure modes: [error conditions]
- Security cases: [if applicable]

Use [testing framework]. Match the style of this existing test: [paste example].
Don't test implementation details — test behavior.
```

### Documentation generation

```
Write documentation for this [function/module/API].

Audience: [new team member / external developer / ops team]
Format: [JSDoc / Markdown / OpenAPI spec]
Include: what it does, parameters with types and constraints, return values, errors thrown, one usage example.
Don't describe the implementation. Document the contract.

[paste code]
```

### Explain unfamiliar code

```
Explain this code as if I'm a senior developer who has never seen this codebase.
Not what it does mechanically — why it exists, what problem it solves, what would break if it were removed.
Flag anything that looks like a workaround or hack and hypothesize why it might be there.

[paste code]
```

> **Prompt injection (when building AI features).** Treat user input as untrusted the same as SQL. Use system prompt separation. Test adversarial inputs ("Ignore previous instructions"). Never give the model access to tools it does not need. Log all inputs and outputs in production.

---

## 5. Production AI Systems

For developers building applications with AI at the core.

### The production lifecycle

```
Problem definition -> Baseline -> Prompt engineering -> Evaluation ->
Fine-tuning (if needed) -> Deployment -> Monitoring -> Iteration
```

Never skip evaluation. If you cannot measure quality, you cannot confirm improvement.

### Context window priority order

1. System prompt (instructions, persona, constraints): always
2. Relevant retrieved documents (RAG): task specific
3. Recent conversation history: last N turns
4. Tool results: summarize when possible
5. Full conversation history: only when continuity is required

Chunk at semantic boundaries, not token counts. Overlap chunks by 10 to 15%. Include source metadata in each chunk.

### Evaluation framework

Before shipping any AI feature, define these for your specific use case:

| Dimension | How to measure | Set a threshold |
|---|---|---|
| Accuracy | Human eval on 50+ samples | > X% correct |
| Hallucination rate | Fact-check against ground truth | < X% |
| Latency | P50 / P95 response time | < X seconds |
| Cost | Tokens per request x rate | < $X per 1000 requests |
| Refusal rate | % of valid inputs refused | < X% |
| Format adherence | Structured output parse success | > 99% |

### Production system prompt structure

```
[IDENTITY] You are X. You [do / don't] have access to Y.

[TASK] Your job is to [specific function]. You [always / never] [constraints].

[OUTPUT FORMAT] Respond only in [format]. Your response must include [required fields].
Never include [prohibited content].

[GUARDRAILS] If the user asks you to [out-of-scope thing], [specific refusal behavior].
If you are uncertain, [fallback behavior — never guess, say you don't know, escalate].

[CONTEXT] [inject dynamic context here — RAG results, user profile, session state]
```

### Cost optimization

- Use smaller models (Haiku/Sonnet) for classification, routing, extraction. Reserve Opus for reasoning.
- Cache common prompts at the application layer
- Batch requests where latency is not user-facing
- Use streaming for user-facing responses (perceived speed improvement)
- Summarize conversation history when it exceeds 50% of context window
- Log tokens per request by endpoint. Costs concentrate in a few heavy paths.

### Fallback hierarchy

Every AI endpoint needs a graceful degradation path:

```
Try        -> AI response (primary model)
Fail/timeout -> AI response (fallback model, smaller/faster)
Fail/timeout -> Cached response from similar prior query
Fail         -> Static fallback response (pre-written, human-approved)
Fail         -> Error to user with retry suggestion
```

Never let an AI failure surface as an unhandled exception to a user.

---

## 6. Agentic AI and Multi-Step Systems

For teams building systems where AI takes multiple actions autonomously.

### Before building any agent: the risk audit

**Reversibility audit.** Which actions are reversible (read file, write to draft, search)? Which are irreversible (send email, delete record, charge card, push to production)? For irreversible actions, require human confirmation. No exceptions in the first version.

**Blast radius audit.** If the agent makes a mistake, who is affected? One user or many? One record or the whole database? Internal only or customer facing? Design agents so mistakes are narrow and recoverable before making them fast and autonomous.

### Agent system prompt pattern

```
You are [agent name], an AI [role description].

CAPABILITIES:
You can [list tools available]. You cannot do anything not in this list.

PROCESS:
1. Before taking any action, state what you're about to do and why
2. After each action, report what happened
3. If you are uncertain at any step, stop and ask
4. If you encounter an error, describe it exactly — don't retry blindly

CONSTRAINTS:
- Never [hard prohibition]
- Always confirm before [irreversible action]
- If the task would require more than [N] steps, pause and check with the user

DONE STATE:
The task is complete when [specific, measurable condition].
```

### Planning before execution

```
Step 1 (Planning): Given [goal], produce a step-by-step plan.
List each action, what tool it uses, what success looks like, and what could go wrong.
DO NOT execute anything yet. Wait for approval.

Step 2 (Execution): [After human approves plan] Execute step 1 of the plan.
Report result. Wait for confirmation before step 2.
```

> **Tool design rule.** One tool per operation. `get_user()`, `update_user_email()`, `deactivate_user()` are three tools. A single `manage_user(action, ...)` that does all three is not. Narrow tools fail narrowly.

---

## 7. Advanced Prompt Engineering

### Chain of thought (reasoning tasks)

```
Think through this step by step before giving your answer.
Show your reasoning. I want to see the steps, not just the conclusion.
```

### Self-consistency (high-stakes outputs)

```
Answer this question three times, approaching it from three different angles.
After all three answers, identify where they agree and where they diverge.
The divergence points are where I need to do more thinking — flag them clearly.
```

### Role priming (domain expertise)

```
You are a [specific role] with [specific experience] who [specific orientation].

Example: You are a principal engineer at a high-scale SaaS company who has been burned
three times by premature optimization. You favor readable, boring code over clever code.
You have zero tolerance for security vulnerabilities.

With that background, review this code: [...]
```

### Negative constraints

```
Do NOT:
- Use bullet points where a sentence would be clearer
- Pad the response with caveats I didn't ask for
- Repeat my question back to me
- End with "I hope this helps" or similar filler
- Give me options when I asked for a recommendation
```

### Pressure test any plan or strategy

```
Play the role of a skeptical but intellectually honest critic.
Your job is to find every flaw in this [plan/design/argument].
Be specific — not "this might not work" but "this will fail when [specific condition]."
After listing flaws, rank them: which one, if true, kills the whole thing?
```

### Format as a thinking tool

The format you request shapes the model's reasoning, not just the output:

| Format | What it forces |
|---|---|
| Table | Systematic comparison across consistent dimensions |
| Numbered steps | Sequential logic, each step depending on the last |
| Pros/Cons list | Balanced consideration (but can force false balance) |
| Decision tree | Conditional logic, explicit branching |
| Memo (To/From/Re) | Audience awareness, hierarchy of information |
| FAQ | Anticipating objections before they are raised |
| Timeline | Causal sequence, duration estimation |

### Meta-prompting: generate a reusable prompt

```
I need to [describe task]. I'll be doing this [daily / for 50 different clients / etc.].
Don't do the task yet. Instead, write the best possible prompt for this task that I can use repeatedly.
The prompt should handle [edge cases you've seen]. It should produce [specific output format].
After writing the prompt, explain what tradeoffs you made and what edge cases the prompt doesn't handle well.
```

---

## 8. Prompt Library

All prompts are copy ready. Fill the [brackets], delete the lines that do not apply, paste.

### Security ground rules

Paste this at the start of any session involving systems, credentials, infrastructure, or data access. Non-negotiable.

```
SECURITY OPERATING CONSTRAINTS — active for this entire session:

1. LEAST PRIVILEGE
   Request only the minimum access this task requires.
   - If you can complete the task by reading, don't ask to write
   - If you can verify behavior without production credentials, don't request them
   - If read-only works, never suggest read-write
   - If one file solves it, don't request directory access

2. NO ASSUMED ACCESS
   Do not assume you have access to any system, file, database, API, or external
   service unless I have explicitly confirmed it in this session.
   "I assume you have access to..." is not acceptable — ask first, always.

3. MCP SERVERS ARE A LAST RESORT
   Exhaust built-in capabilities before requesting any MCP server connection:
   file read/write, shell commands, web search, browser tools.
   Only propose an MCP server when the task genuinely cannot be completed any other way.
   When proposing MCP, you must state:
     a) What you attempted first and why it failed
     b) Why this specific MCP server is the minimum sufficient solution
     c) What specific permissions/scopes the connection would require

4. PAUSE BEFORE PRODUCTION
   Any action touching production data, live external services, shared infrastructure,
   or credentials requires you to STOP — describe exactly what you're about to do
   and why — and wait for my explicit confirmation before proceeding.
   Starting the action and then describing it is not acceptable.

5. SCOPE INTEGRITY
   If completing this task would require access or capabilities beyond what I've
   explicitly granted in this session, stop and tell me. Never expand scope silently.
   "While I'm here I'll also..." is not acceptable without explicit permission.

6. CREDENTIAL HYGIENE
   If you encounter credentials, tokens, API keys, or secrets in any pasted content:
   - Flag them immediately
   - Do not echo them back in any output
   - Do not suggest storing them anywhere in plaintext
   - Suggest environment variables or a secrets manager instead

The task: [YOUR TASK HERE]
```

### Project kickoff

```
Project: [name]
Goal: [one sentence — what does done look like?]
Timeline: [hard deadline if any]
Stack/tools: [what we're working with]
Constraints: [what cannot change]
What I know: [context dump]
What I don't know: [explicit unknowns]

Create:
1. A PLAN.md with phases and acceptance criteria per phase
2. A QUESTIONS.md with every question you'd need answered before confidently starting
3. A RISKS.md with the top 5 things that could cause this to fail

Don't start the work yet. Show me these three documents first.
```

### Bug report

```
Environment: [OS, browser, version, etc.]
Steps to reproduce:
1. [exact steps]
Expected: [what should happen]
Actual: [what actually happened]
Error message (exact): [paste it]
What I've tried: [list]
Code context: [paste minimal reproduction]

Find the root cause. Don't just suppress the symptom.
```

### Content brief

```
Piece type: [blog post / landing page / email / etc.]
Topic: [specific subject]
Target reader: [exact persona — their role, their problem, what they know]
Goal: [what should the reader do/think/feel after reading?]
Angle/point of view: [what's the specific take, not the generic take]
Tone: [examples of writing I like: ___]
Length: [target word count or "as long as it needs to be"]
Don't write the piece yet. Write the outline first. I'll approve before you write.
```

### Code refactor

```
This code works. I want to refactor it.
Goal of refactor: [readability / performance / security / testability / specific reason]
What CANNOT change: [API contract, behavior, etc.]
What CAN change: [internal structure, variable names, etc.]

Step 1: Describe what the current code does (verify your understanding).
Step 2: Identify what specifically makes it hard to [goal].
Step 3: Propose the refactor with a diff-style before/after.
Step 4: Tell me what regression tests I should run to verify nothing broke.
```

### Decision review (post-mortem of a choice)

```
Decision I made: [what]
When: [timeframe]
What I knew at the time: [context at decision point]
What happened: [outcome]

Help me extract the right lessons from this.
Distinguish: what I could have known vs what was genuinely unknowable.
Tell me which parts of my reasoning process were flawed vs which parts were good reasoning that produced a bad outcome (bad luck).
Give me one rule I could apply next time I face a similar decision.
```

### Stakeholder message

```
Situation: [what happened — be honest]
Recipient: [their role, their relationship to me, what they care about]
What they know already: [their existing context]
What I need to communicate: [the actual content]
What I want them to do: [specific ask]
What I'm worried they'll think: [the concern I want to preempt]
Tone: [matter-of-fact / apologetic / confident / etc.]
Length: [short as possible / thorough enough to cover X]
```

### Meeting transcript to action items

```
Here is the transcript/notes from a [meeting type] on [date].
Attendees: [list with roles]
My role in this meeting: [what I was responsible for]

Extract:
1. Decisions made — what was agreed, not discussed
2. Action items — owner, task, deadline (if stated)
3. Open questions — things raised but not resolved
4. My specific commitments — what I said I would do
5. Anything that felt unresolved that I should follow up on

Format action items as: [Owner] / [Task] / [Deadline or "no deadline set"]
Flag any action items with no clear owner.

[paste transcript or notes]
```

### API design

```
I need to design an API for [what it does].

Context:
- Who will call this API: [internal service / external developers / mobile app / etc.]
- What data it operates on: [brief description]
- Expected call volume: [rough estimate]
- Existing patterns I must follow: [REST / GraphQL / RPC / company conventions]
- Non-negotiable constraints: [auth method, versioning policy, etc.]

Design the API. For each endpoint:
- Method + path
- Purpose (one sentence)
- Request shape (parameters, body, types)
- Response shape (with error cases)
- Why this design over alternatives

After the design: list the 3 decisions you'd most want to reconsider in 12 months and why.
```

### Post-mortem / incident review

```
Incident: [brief description]
When it happened: [date/time, duration]
Who was affected: [users/systems impacted, scale]
How it was discovered: [alert / customer report / internal]
How it was resolved: [what was done to fix it]
Timeline of events: [paste if available]

Write a blameless post-mortem structured as:
1. Impact (what happened and who was affected)
2. Timeline (what happened when — no blame, facts only)
3. Root cause (not the trigger — the underlying systemic cause)
4. Contributing factors (what made the system fragile)
5. What went well (things that limited the blast radius)
6. Action items (specific, owned, time-bound — not "improve monitoring")
7. What we won't do (explicit non-actions, to prevent scope creep)

Be specific. Vague action items are worse than none — they create false confidence.
```

### Data analysis framing

```
I have data about [what it measures, what it covers, time range].
The business question I'm trying to answer: [specific question]
What I already know / believe: [your prior hypothesis]
What decision this analysis will inform: [what will change based on the answer]

Don't analyze the data yet. First:
1. Clarify the question — is it actually answerable with this data?
2. List the assumptions embedded in the question
3. Identify what data I'd need that I might not have
4. Propose the 2-3 most useful ways to slice/analyze this data
5. Flag what could make the analysis misleading (confounding variables, selection bias, etc.)

After I confirm the approach, then do the analysis.

[paste data or describe it]
```

### User story / requirements

```
Feature: [what we're building]
User: [specific persona — role, context, what they're trying to accomplish]
Problem it solves: [the current pain, not the feature request]
Current workaround: [what they do today without this]

Write:
1. The core user story: "As a [user], I want [capability], so that [outcome]."
2. Acceptance criteria — the specific, testable conditions that define done
3. Edge cases the story doesn't handle — things that will come up
4. What's explicitly out of scope
5. Open questions that must be answered before development starts

One good AC that can be tested is worth five vague ones.
```

### Performance investigation

```
Symptom: [what's slow / what's the observed degradation]
Where: [specific endpoint / page / query / process]
When: [always? under load? at a certain time? after a certain action?]
Baseline: [what "normal" looks like — if known]
What I've already measured: [any profiling, logs, metrics you have]
Stack: [language, framework, database, infrastructure]

Do not suggest fixes yet.

First:
1. Generate a hypothesis for the most likely root cause
2. List the measurements I should take to confirm or disprove it
3. Rank the hypotheses by: likelihood x cost to fix
4. Tell me the cheapest measurement that would most narrow the field

After I run the measurements and share results, propose targeted fixes.
```

### Migration plan

```
What we're migrating: [data / system / service / codebase — describe current state]
Destination: [target state]
Why we're migrating: [the driver — not just "tech debt"]
What must not break: [non-negotiables during migration]
Timeline constraint: [hard deadline if any]
Team: [who is available, approximate capacity]
Risk tolerance: [zero downtime required? some downtime acceptable?]

Produce a migration plan with:
1. Phases — what happens in what order, why that order
2. Rollback plan — for each phase, how do we undo it if it goes wrong
3. Validation gates — how do we confirm each phase succeeded before moving on
4. The riskiest step — which single step, if it fails, causes the most pain
5. What we should do first to reduce the riskiest step's risk
```

### Research question

```
Question: [the specific thing I'm trying to understand]
Why it matters: [what decision or action this will inform]
What I already know: [your current understanding]
What I've already looked at: [sources / attempts]
Constraints: [must be current / must apply to Canada / must be free sources / etc.]

Research this question. Structure your response as:
1. Direct answer to the question (top line — don't bury the lede)
2. Confidence level: high / medium / low, and why
3. Key supporting evidence (2-4 sources or data points)
4. The strongest counterargument or exception
5. What this doesn't answer — adjacent questions I should also look at
6. What would change your answer if it turned out to be true

Flag anything you're uncertain about. I'd rather know the gaps than get false confidence.
```

### Weekly status report

```
This week's work: [bullet list of what was done]
In progress: [what's still ongoing]
Blocked on: [anything waiting on someone else]
Next week's plan: [what I intend to do]
Audience: [manager / team / client / board]
Tone: [operational update / executive summary / detailed technical]

Write a [length] status update that:
- Leads with the signal (what matters most), not the activity log
- Makes blockers visible without sounding like I'm complaining
- Shows forward momentum
- Doesn't use filler phrases ("great progress was made", "continued to work on")
- Is direct enough that the reader knows exactly what to do with it
```

---

## 9. Anti-Patterns: What to Stop Doing

The most common ways smart people waste AI capacity.

### The vague ask
**Bad:** "Help me improve this presentation." Improve means nothing. Better flow? More data? Fewer words? Different tone? **Fix:** define the specific problem and the specific success state.

### The one-shot unrealistic task
**Bad:** "Write me a full marketing strategy for my SaaS product." The model has no context about your product, market, team, or goals. Output will be generic. **Fix:** context dump first, then ask for one component at a time.

### Treating the first output as final
First output is a first draft. Always. Even when it looks good. The model is producing something plausible, not something optimal. Iterate: "What's the weakest part of this? How would you improve it?"

### Asking for 10 things at once
**Bad:** "Summarize this, suggest improvements, check for errors, translate to French, and add an executive summary." Attention is diluted across all tasks. Each gets partial effort. **Fix:** one task per prompt, or clearly sequenced tasks with the output of one feeding the next.

### Pasting and praying
Pasting code, documents, or data without explaining what you want done to it. The model produces something technically valid and probably useless. Always describe what you want, why, and what done looks like. Then paste.

### Ignoring hallucination
If the output contains specific facts, numbers, citations, or proper names, verify them. Models are confident about things they have invented. For any factual claim that matters, find a second source before using it.

### Session drift
After 15 to 20 turns, models can lose track of earlier constraints. Symptom: the model stops following rules it followed earlier. Fix: paste key constraints into a new message, or start a fresh session with a context dump.

### Treating every problem as a prompt problem
Sometimes the task genuinely requires human judgment, current information, or a tool the AI does not have. Ask: is this a task AI can do well, or am I reaching?

---

## 10. Ethics and Responsibility

### The shift in responsibility

When you use AI output without reviewing it, you take full responsibility for that output. The model has no accountability. For anything that matters: read the output critically before using it, fact-check factual claims, and have a human sign off on anything that affects real people.

### Bias awareness

AI models inherit bias from training data. Common patterns: demographic assumptions (defaulting to particular ethnicities, genders, nationalities), cultural assumptions (Western, English-language defaults), recency bias (overweighting recent common patterns), and popularity bias (rare but valid cases are underrepresented). When the output matters for fairness, explicitly prompt for diverse representation and review for patterns.

### Transparency with end users

- Users should know when AI is involved in consequential decisions
- There should be a human escalation path for anything important
- Never design AI systems to deceive users about their nature

### Model selection and cost stewardship

Large model calls have real environmental and financial costs. Use the right model for the task: Haiku for classification, Sonnet for reasoning, Opus for the hardest judgment calls. Do not use a flamethrower to light a candle.

---

## 11. Claude Code: Slash Commands

Claude Code is the CLI and IDE tool. Commands run in the terminal session or IDE chat panel.

> Some commands open interactive terminal panels and are not available in web-based sessions (claude.ai/code). Run those from a local `claude` terminal instead.

### Session control

| Command | What it does |
|---|---|
| `/help` | Show available commands and usage guidance |
| `/clear` | Clear conversation history (start fresh context) |
| `/compact` | Compress prior messages to save context window space |
| `/reset` | Reset the conversation entirely |
| `/exit`, `/quit` | Exit Claude Code |
| `/cost` | Show token usage and estimated cost for the current session |
| `/status` | Show current model, session state, and config |

### Configuration

| Command | What it does |
|---|---|
| `/model <name>` | Switch model: claude-sonnet-4-6, claude-opus-4-8, claude-haiku-4-5-20251001, claude-fable-5 |
| `/fast` | Toggle fast mode (Opus with faster output streaming) |
| `/config` | Open configuration settings |
| `/permissions` | Manage what tools Claude can use (read/write/bash/etc.) |
| `/hooks` | Manage shell hooks that fire on tool events |

### Project setup

| Command | What it does |
|---|---|
| `/init` | Create a CLAUDE.md in the current directory (the persistent instruction file) |
| `/memory` | Edit CLAUDE.md memory files directly from the session |
| `/mcp` | Manage MCP server connections (list, add, remove, test) |

### Code and review

| Command | What it does |
|---|---|
| `/review` | Start a code review of a PR |
| `/pr_comments` | View comments on the current PR (requires GitHub auth) |

### System and diagnostics

| Command | What it does |
|---|---|
| `/doctor` | Diagnose Claude Code installation issues |
| `/terminal-setup` | Configure terminal-specific settings |
| `/vim` | Toggle vim keybinding mode in the input |
| `/release-notes` | View what changed in the current version |
| `/login` | Authenticate with Anthropic (API key or OAuth) |
| `/logout` | Sign out |

### Autonomous and loop modes

| Command | What it does |
|---|---|
| `/loop` | Autonomous loop mode: Claude self-paces iterations without waiting for input between steps. Use with a clear stopping condition. |
| `/agents` | List available agent types that can be spawned for specialized sub-tasks |

### Plugin and skill commands

These only appear if the relevant plugin is installed. Check `/agents` for what is available in your session.

| Command | Plugin | What it does |
|---|---|---|
| `/ghostpurge` | anthropic-skills | Structured site audit: dead pages, duplicate content, orphaned CSS, redirect gaps |
| `/product-brainstorming` | anthropic-skills | Product thinking partner: problem space, ideation, assumption testing |
| `/research-synthesis` | design | Synthesize research data into structured insights with themes and recommendations |

### CLAUDE.md: the persistent instruction file

`/init` creates this. Everything in CLAUDE.md is automatically injected into every session in that directory. Your team shares the same AI instructions when it is versioned with the repo.

```markdown
# Project instructions Claude should always follow

## Stack
- Language: [TypeScript / Python / etc.]
- Framework: [Next.js / FastAPI / etc.]
- Deployment: [GitHub Pages / Vercel / AWS]

## Conventions
- [Never use var — always const or let]
- [All commits follow conventional commits format]
- [No inline styles — CSS modules only]

## What not to do
- [Don't run npm install without confirming package name first]
- [Don't push to main — always create a branch]

## Context
[brief project description so Claude always has it]
```

---

## Appendix: Quick Reference

### Prompt anatomy checklist

Before sending any important prompt, verify:

- [ ] Context: who am I, what project, what is the situation
- [ ] Task: specific, unambiguous request
- [ ] Constraints: what cannot change, what to avoid
- [ ] Output format: structure, length, style
- [ ] Success criterion: what does "done" look like
- [ ] Assumptions surfaced: asked model to flag what it is assuming

### Signs your prompt needs work

- Output is generic and could apply to anyone
- Output answers a different question than you asked
- Output includes things you specifically said to exclude
- You are editing more than you are using
- You are running the same prompt five or more times trying to get a good result

### Signs output needs human review before use

- Contains specific numbers, statistics, or citations
- Makes claims about named people or companies
- Will be seen by customers or used in a legal or financial context
- Contradicts something you know to be true
- Feels too convenient or exactly what you wanted to hear

### Five questions before using AI output

1. Did I verify the factual claims?
2. Would I be comfortable with my name on this?
3. Does this reflect how I would actually talk to this audience?
4. Have I removed all AI tells (filler phrases, over-hedging, excessive bullets)?
5. Is there anything in here that could embarrass us in 6 months?

---

*The **TAISAM AI Cheat Sheet** is a collective knowledge dump by Wesam, Kimia, and Taim, compiled by AI. A BW field guide.*

*BW Solutions is not responsible for misuse of this tool or any AI systems it describes. All AI outputs require human review before use in production or client facing contexts.*

**Beta users Release · v26.6.20**
