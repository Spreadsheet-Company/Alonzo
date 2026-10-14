<!-- SPDX-License-Identifier: 0BSD -->
<!-- SPDX-FileCopyrightText: 2026 Spreadsheet Company -->

# BUFFET: all you can sheet

*The design reference for `CART.11`: an idle game in which you run an asset-management firm, and a spreadsheet you are allowed to open. A reference point for later brainstormings, written 2026-10-13 from the owner's brief and the sittings that answered it. Not a specification: where this file disagrees with `CHARTER.md`, `SPEC.md` or `ROADMAP.md`, those win. Living and unadjudicated, rewritten in place; nothing here is built.*

*Tags used below: **(owner)** the owner's word; **(rec)** the session's recommendation; **(pred)** a prediction, written before any measurement; **(derived)** arithmetic over stated inputs; **(check)** verify before relying on it.*

*Why a document sits in a cartridge folder: `cartridges/buffet/` will hold `buffet.vla`, its source, its replay and its golden. Until then the folder is a design folder, and `tools/build_web.ps1` and the describe test skip a folder that holds no `.vla` at all.*

---

## Contents

0. The pitch
1. The name
2. Jokes all the way down
3. The Series 777 exam
4. The firm
5. The market
6. The menu: asset classes and vehicles
7. The bunker: stores of value outside the market
8. Mechanics against click-and-wait
9. The options strategy pane
10. From game to tutorial
11. The spreadsheet wink, and the funnel
12. Where I would push back
13. Slices and the order of work
14. Engine facts and constraints
15. What will bite
16. Open decisions
- Appendix A. Joke seeds

---

## 0. The pitch

You are an asset manager. You begin with a pencil, a Series 777 exam and a small pile of other people's money. You end with an island, a compliance department the size of a small country, and a personal net worth that needs scientific notation. In between, the market breathes in cycles you can learn but not solve, and you decide when to be greedy, when to be afraid, and when to hide in the bunker with the canned goods (a commodity) and the Beanie Babies (a collectible).

Four claims, each a thing to protect:

1. **It is funny.** The game is fun insofar as it is funny (owner). Every string is a chance.
2. **It is a spreadsheet.** Every number on every screen is a cell in a workbook the player may open. By the late game the player has written a trading bot in formulas and nobody told them that was programming.
3. **It teaches.** The market is a model the player can inspect and change; the options pane builds iron condors; the exam teaches economics by being ridiculous.
4. **It is checkers first and chess later.** AdVenture Capitalist is checkers; Buffet is chess (owner). The first five minutes must be checkers. The chess arrives one licence at a time.

---

## 1. The name

*Buffet*, as in the food line (owner). It is a pun with at least three layers, and the cartridge should use all of them:

- **The food line.** The whole interface metaphor. Asset classes are *stations*. A *plate* is a portfolio, and a bigger plate is more position slots. *Heat lamps* are yield. The *sneeze guard* is compliance. The *carving station* is private equity (a chef slices off a piece, for a fee). The *salad bar* is bonds (healthy, dull). The *dessert bar* is crypto. *Going back for seconds* is reinvesting. *All you can sheet* is the tagline (owner, 2026-10-13, changing it from "all you can invest": a sheet is the interface, the medium and the pun).
- **The investor.** The name is a pun on a person, which is safe as a pun on a common noun and not safe as a likeness. Keep his name, face and quotations out of the game (rec). The oldest advice in the building can be attributed to "the oldest advice in the building".
- **To be buffeted.** The verb: to be struck repeatedly, as by wind or waves. The market is weather, and the forecast panel is the *Buffet Weather Service*: "partly bullish, 30% chance of correction by Q3, winds from the bond market at 25 basis points".
- **A fourth, quietly.** The sideboard, the train car. Background jokes only.

Palette: Lovelace Lavender and nothing else (owner's standing rule for arcade games). Consequences are in section 15.

---

## 2. Jokes all the way down

> "The game will be fun insofar as it is funny. The name is almost a triple-entendre already, so the cartridge should be jokes all the way down." (owner, 2026-10-13)

### The principle

A joke is not decoration; it is the **mnemonic**. The funnier the wrong answer, the more memorable the right one. The funny carries the first five minutes (checkers); the depth carries the fiftieth (chess). If a screen has a string, it has a chance.

### Where jokes live

Every player-visible string, which is to say:

- the exam, its proctor and its certificate (section 3);
- vehicle names, tickers, and what the index funds are called;
- the news ticker and event headlines;
- licence names, compliance memos and the audit's findings;
- staff, rivals, clients, the league table;
- achievements, titles (Intern, Associate, VP "a title given instead of a raise", Director, Managing Director, Partner, Legend);
- error values (`#NUM!` reads "net worth exceeds the known universe");
- fine print, tooltips, the crash screen, the prestige screen, the ending;
- **the source itself**: sheet names, cell notes, comments and the header of every replay. The repository is public; the jokes are part of it.

### The voice

Deadpan corporate-compliance. Understatement. Regulatory euphemism. A footnote that grows. A memo from someone who has seen things. Never a wink to the camera; the tone is that this is all very serious and everyone involved is slightly doomed.

### Rules (rec)

- **Punch up.** Institutions, archetypes, jargon and ourselves. Never at a named individual, never at people who lost their savings. The 2008 jokes aim at the *instrument*, not the evicted.
- **Fictional names.** Firms, people and tickers are invented. A parody pun on a living company is a lawyer's glance before shipping (appendix A flags the ones that are).
- **Clarity first.** The tutorial must teach. A joke may be the vehicle; it must never be the fog.
- **Strings are data.** A joke is a row in a sheet. No text functions exist in the cartridge dialect, so a picker is `CHOOSE(k, ...)` over references, generated by a kit macro (section 14).
- **PG-13.** The audience includes classrooms.

### Running gags (rec)

- **Mildred in Compliance**, whose memos are the voice of the regulator's conscience.
- **Steve.** Nobody knows what Steve does. The firm's performance dips, mysteriously, when Steve is out. Firing Steve has a hidden, wrong, funny effect.
- **The footnote** that begins as an asterisk and by the late game runs for a page.
- **The proctor, Gary**, who administers every exam and is never promoted.
- **"Past performance is not indicative of future results"** in a different font every time.
- **The weather**, always the weather.

### The joke pipeline is the contribution funnel

A joke is the cheapest pull request there is: one row in one sheet. That matters for the repository's hypothesis (`CHARTER.md` section 6): forks and pull requests are what gets counted, and jokes, exam questions and scenarios are the contributions a stranger can make in five minutes. Keep `Jokes`, `Exam` and `Scenarios` as plain data sheets with a one-page "how to add a row" (rec).

---

## 3. The Series 777 exam

The starting screen. A proctor, a No. 2 pencil, a Scantron, ten questions drawn by seed from a bank. **You cannot fail** ("you have failed in a way the regulator has decided to call passing"); the score sets the starting capital, and the last, ungraded question sets the firm's archetype.

It is also the controls tutorial: every answer is a click, so the player has learned the pointer before they know they were taught.

### Scoring and consequence (rec)

- Starting capital: a base plus a small amount per correct answer. (The first purchase is penny stocks; the first dollar should feel like a dollar.)
- The final question picks the archetype, which sets the firm's *flavour*, not its power: **Prudent & Sons** (reads the prospectus), **Headline Capital** (reads the headlines), **Read-the-Room Partners** (reads the room), **Vibes LLC** (feels).
- The certificate prints the firm's name, the date, and a signature that is, on inspection, a doodle of a bull.

### The bank (draft; correct answer marked ✔)

1. **Opportunity cost.** *You can read the prospectus or nap. The opportunity cost of the nap is:* (A) nothing, naps are free; (B) the prospectus, and probably a lawsuit; **(C) the value of the best thing you gave up ✔**; (D) $4.99 a month, billed annually. *Proctor: "Correct. Also B."*
2. **Supply and demand.** *It rains and umbrella prices rise. This is:* (A) a conspiracy by Big Umbrella; **(B) demand rising against a fixed supply ✔**; (C) a weather-adjusted vibe; (D) illegal in at least one state.
3. **Inflation.** *Your cash earns 0% while prices rise 3% a year. After a year it buys:* (A) the same, a dollar is a dollar; **(B) about 3% less ✔**; (C) nothing, it has gone to a better place; (D) more, if you believe in it.
4. **The rule of 72.** *At 8% a year, money roughly doubles in:* **(A) 9 years ✔**; (B) 8 years, because the number is 8; (C) never, money only multiplies in films; (D) until the next quarterly report.
5. **Risk and return.** *On average, the higher the expected return, the:* (A) lower the risk, obviously; **(B) higher the risk, which is what you are being paid for ✔**; (C) better the logo; (D) closer your brother-in-law is to being right.
6. **Diversification.** *"Don't put all your eggs in one basket" is advice about:* (A) poultry; **(B) spreading risk without necessarily lowering expected return ✔**; (C) baskets, mostly; (D) eggs, specifically.
7. **Bonds.** *A bond is:* (A) a lasting emotional connection; **(B) a loan you make, which pays interest and returns the principal ✔**; (C) a spy; (D) a stock with a sad backstory.
8. **Bonds and rates.** *When interest rates rise, existing bonds:* (A) rise, out of solidarity; **(B) fall in price, because new bonds pay more ✔**; (C) stay put, bonds are loyal; (D) are not discussed at parties.
9. **Liquidity.** *Which is the most liquid?* (A) a private island; **(B) cash ✔**; (C) a 1952 baseball card; (D) your cousin's startup.
10. **Bear market.** *A bear market is a fall of at least:* (A) 2%, and a deep sigh; **(B) 20% from the peak ✔**; (C) 100%, a figure usually reserved for your cousin's startup; (D) a bear's weight in honey.
11. **Price to earnings.** *A stock with a P/E of 20 costs, per dollar of yearly earnings:* **(A) $20 ✔**; (B) $0.05; (C) 20 hugs; (D) a type of coffee.
12. **Moral hazard.** *"Too big to fail" encourages banks to:* (A) shrink; **(B) take more risk, because someone else pays for the downside ✔**; (C) take up jogging; (D) fail bigger, for the exposure.
13. **Leverage.** *You put in $1, borrow $9 and buy a $10 asset that falls 10%. Your equity is now:* **(A) $0 ✔**; (B) $9; (C) $10; (D) a learning experience.
14. **Sunk cost.** *You paid $50 for a terrible film and stay "because you paid". This is:* (A) loyalty; **(B) the sunk-cost fallacy ✔**; (C) cinema; (D) a deductible.
15. **Deposit insurance.** *A US bank deposit is insured, per depositor per bank, up to:* **(A) $250,000 ✔**; (B) $2.50; (C) $250 million; (D) a pinky promise.
16. **Central banks.** *A central bank raises rates to:* (A) make borrowing cheaper; **(B) cool inflation by making borrowing dearer ✔**; (C) impress other central banks; (D) fund the pens.
17. **Efficient markets.** *Two economists see a $20 bill on the pavement. One says, "If it were real, someone would have picked it up." This is a joke about:* **(A) the efficient-market hypothesis ✔**; (B) littering; (C) pavement; (D) twenties.
18. **Time value.** *$100 today or $100 in a year?* (A) in a year, I like surprises; **(B) today, it can earn something meanwhile ✔**; (C) both, with a lawyer; (D) neither, cash is dead.
19. **Short selling.** *You short a stock at $10 and it goes to $20. Your loss is:* **(A) $10 a share, and it can grow ✔**; (B) $0, you never owned it; (C) capped at $10; (D) spiritual.
20. **Ungraded.** *Which best describes you?* (A) I read the prospectus; (B) I read the headlines; (C) I read the room; (D) I feel. *(Sets the archetype.)*

The bank should reach 40 to 60 over time. Every question carries a one-line "why" the game can show later in a concept card (section 10).

### The licence ladder as progressive disclosure (rec)

Each licence is an exam *and a layer of the interface*. A player cannot see the options pane until they have earned the option approval, which is how chess is kept from frightening checkers players.

| Licence | The real thing | What it unlocks here |
|---|---|---|
| Series 777 | fictional entry exam | cash, stocks (the first rungs), net worth |
| SIE and Series 7 | Securities Industry Essentials; general securities representative | stocks and bonds |
| Series 63 | state securities law | more states: a higher client cap |
| Series 65 / 66 | investment adviser | client accounts: the firm layer, fees |
| Series 3 and NFA registration | futures | commodities and futures |
| Series 4 | registered options principal | the options pane |
| Series 24 | general securities principal | staff and the firm's structure |
| Series 79 | investment banking | the IPO prestige |
| Series 82 | private securities offerings | private equity and venture |
| State broker licence | real estate | real estate |
| State insurance producer licence | insurance | the insurance class |
| BitLicense, in spirit | crypto | crypto vehicles |
| Accredited investor, qualified purchaser | net-worth gates, not exams | private deals; the hedge-fund structure |

Joke licences, for the gag cabinet: Series 404 (licence not found), Series 1040 (mostly forms), Series 11 (goes to eleven), Series 42 (the answer), Series 99 (the dollar-store licence), Series 0 (the trivial one). (check) The real licence names above are the sitting's reading; verify before they appear on screen.

---

## 4. The firm

You are an asset manager with your own firm, which means two pockets: the firm's, and yours.

### The two pockets

- **Firm capital:** what the firm owns (proprietary positions, working cash). It is reinvested or distributed.
- **Personal wealth:** what the partner draws. This is the **score**: net worth at the end, the "retire to the island" ending.

The tension (rec): every dollar drawn is a dollar not compounding in the firm. An idle game's reinvestment loop becomes a real decision.

### Staff (rec)

| Role | What it does | The joke |
|---|---|---|
| Intern | clicks for you at the start (an autoclicker) | unpaid; counted as "human capital" |
| Analyst | cleans the signal in the indicators | has opinions; most are footnotes |
| Trader | cuts execution costs; runs the strategy sheet at lower slippage | shouts at screens; they do not shout back |
| Quant | unlocks the model inspector and factor views | has Greek letters; does not share |
| Compliance officer | lowers audit and fine risk; required per licence | has a binder; the binder has a binder |
| Lobbyist | shifts regulatory events; unlocks grey-area ventures | has a golf bag; the golf bag has a lobbyist |
| Steve | nobody knows | things go wrong when he is out |

Staff are paid every tick. The *burn rate* is a number on the dashboard, and a bust makes fixed costs hurt (operating leverage, taught by being fired).

### Clients and AUM (rec)

Client money is how the firm scales and what the firm can lose.

| Client | Wants | Redeems when |
|---|---|---|
| Grandma's Trust | steady, no surprises | any drawdown over 5% |
| The Retired Dentist | a bit of everything | the headlines are scary |
| A Pension Fund | benchmark plus a little | tracking error, slowly, with a committee |
| An Endowment | long horizon, illiquids | almost never, which is the point |
| A Sovereign Wealth Fund | scale | never; it just moves the market |
| A Guy Named Chad | 10x, immediately | the first red day, loudly |

### Fees (the maths)

```text
management fee   = 2% a year of AUM, accrued each tick
performance fee  = 20% of the gain above the high-water mark, crystallized at each period end
high-water mark  : HWM = MAX(HWM.last, NAV)            ; MAX is in the dialect
net flow         = marketing + k1*(trailing return - benchmark) - k2*drawdown   ; clamped with MIN and MAX
redemptions      : requested now, paid after the notice period; a gate caps them at a reputation cost
```

**The insight to teach:** a performance fee is a *call option on the clients' money*. You keep the upside and, below the high-water mark, you do not pay the downside, you only stop earning. That is moral hazard in one formula, and the options pane (section 9) can draw the manager's own payoff diagram next to the player's. "Heads I win, tails you lose" is a section of the textbook and a button in the game.

### The firm's ledger

Revenue (management fees, performance fees, proprietary gains) minus costs (payroll, rent, data, compliance, marketing) is the firm's profit; the player decides how much to draw. Death spirals (redemptions force sales which cause redemptions) must be visible, survivable and *funny*: the one mechanic a player will remember is the gate.

---

## 5. The market

> "I'll have to noodle on how we decide to model the price fluctuations of various asset classes under the hood ... maybe we swap in different functions of varying complexity based upon a difficulty picker?" (owner)

Yes. The difficulty picker *is* the model's complexity, and each tier is a lesson.

### The principles (rec)

1. **Deterministic.** The market's path is a pure function of the seed, the difficulty and the scenario. No `RAND`; the dice are a Park and Miller cell seeded from `Clock!B3` (`SPEC.md` 3.5). A replay replays the market.
2. **Exogenous.** The player does not move the market (execution slippage is a cost, not a path change). That keeps scores comparable and replays verifiable. (An endgame twist, "you are now the weather", may let a sovereign-scale player move prices; it belongs to a career mode, not the leaderboards.)
3. **Quasi-periodic, never periodic.** A pure sine is solvable: two peaks reveal period and phase, and timing becomes arithmetic. Cycles must be incommensurate, modulated, noisy and punctured by shocks.
4. **Partly informative.** Leading indicators are noisy views of hidden state. Analysts buy a cleaner view. Nothing is certain; a lot is knowable.
5. **A toy, labelled as one.** Parameters are loosely calibrated and honestly flagged. The game shows its work and keeps a "Things this game gets wrong" sheet (section 10).

### The shape

```text
; shape, not syntax; every operator is in the dialect (^ and SIN included)
trend(t)    = g ^ t                                          ; the slight uptrend, g just above 1 a tick
cycle(t)    = 1 + A1*SIN(w1*t+p1) + A2*SIN(w2*t+p2) + A3*SIN(w3*t+p3) + A4*SIN(w4*t+p4)
index(t)    = trend(t) * cycle(t) * (1 + noise(t)) * (1 + shock(t))
class(c, t) = 1 + beta(c)*(index(t) - 1) + Ac*SIN(w1*t + phase(c))      ; phase(c) from the Investment Clock
vehicle(v)  = price0(v) * class(c(v), t) * (1 + idio(v, t))
```

- **The four waves** carry the classic cycle names: Kitchin (about 4 years, inventories), Juglar (about 9, investment), Kuznets (about 18, building and infrastructure), Kondratiev (about 50, the long wave). Their ratios are not whole numbers, and a fifth, slow wave modulates the amplitudes, so the pattern does not visibly repeat. Phases and amplitudes are seeded.
- **Cosine is a sine**: `COS(x) = SIN(x + 3.14159265358979/2)`. (There is no `PI` function either; it is a literal.)
- **Noise** is an AR(1) walk from the seeded stream: `n(t) = phi*n(t-1) + sigma*z(t)`. A near-normal `z` is a sum of uniforms (Irwin and Hall: twelve uniforms minus six); there is no `LN` for Box and Muller.
- **Volatility clusters:** `sigma(t) = sigma0 * (1 + k*stress(t))`, stress rising in drawdowns.
- **Shocks** are rare and asymmetric: down fast, up slowly ("the stairs up and the elevator down"). A heavy tail is `u^(-1/alpha)`, a Pareto draw by inverse transform; `^` makes it one cell.
- **Class phases** follow the Investment Clock: recovery favours stocks, overheating commodities, stagflation cash, reflation bonds. *Rotation* is therefore a skill and not a slogan.
- **Crisis correlation:** `rho(t) = rho + stress(t) * (1 - rho)`. In a crisis every correlation goes to one, which is when diversification fails and tail hedges earn their keep. Teach this by letting it hurt.
- **Seasonality** per class: harvests for grain, driving season for oil, December tax-loss selling, the January effect, "sell in May".
- **Per-class cycles:** crypto's four-year halving beat, real estate's long slow wave, the commodity supercycle.

### The difficulty ladder

| Tier | Picker name | Adds | What it teaches |
|---|---|---|---|
| 0 | **Kiddie Pool** | one sine and a drift, fixed class phases | markets have cycles |
| 1 | **Day Trader** | four incommensurate waves, seeded phases | cycles that do not repeat |
| 2 | **Swing Trader** | AR(1) noise and rare shocks | noise is not signal |
| 3 | **Quant** | regimes (bull, bear, sideways; a Markov chain) and volatility clustering | regimes and fat times |
| 4 | **Risk Manager** | a factor model (market, rates, inflation, credit, commodity, crypto sentiment) and crisis correlation | diversification and where it fails |
| 5 | **Black Swan** | heavy-tailed jumps and liquidity spirals (spreads widen with stress) | tail risk is not a normal distribution |
| 6 | **Central Banker** | an endogenous rate path (a Taylor rule), inflation, a term structure | why rates move bonds, houses and currencies |
| 7 | **Documentary** | historical scenario packs, parameters fit loosely to 1929, 1973, 1987, 2000, 2008, 2020, 2022, and 1637 as the tutorial | history rhymes, loudly |

All tiers' formulas live in one `Market` sheet and a `Difficulty` value cell picks (`CHOOSE`); changing the tier mid-run is a person's edit of a value (`AD-6`), recorded in the replay, and a leaderboard run fixes it at the start (rec). Computing every tier each frame is trivially cheap.

### Per-class stochastic functions: the factor model

Each class gets its own stochastic wave by *loadings on shared factors* plus its own noise:

```text
return(c, t) = SUM over factors k of  B(c, k) * f(k, t)  +  eps(c, t)
```

A classes-by-factors block (12 by 6 is 72 cells) is the whole model, and it is **a sheet the player can open and edit**: change the equity beta, raise the inflation loading on gold, watch the portfolio re-price. That is a finance course's best lab.

### Time (open decision)

One tick is one day (rec). With the teacher's rate (the Clock's `rate`) at 1 frame a second, one game year is about six minutes (365 ticks, *derived*), so a Kitchin wave is about 24 minutes, a Juglar about an hour, a Kuznets nearly two hours and a Kondratiev about five (*derived*): the player lives through the short waves in a session, the medium ones in a day, and the long one is the generation. The owner's question 5 in section 16 fixes it.

### The open-book problem (a design fact, not a bug)

The cartridge is open (`AD-6`) and deterministic. The market is a function of a seed that sits in a cell. **Anyone can read the model, run it forward in a scratch sheet, and know the future.** That is not a flaw to hide; it is the strongest play there is, and the spreadsheet community will find it in an afternoon. The options:

- **Score by alpha on your own seed** (rec): the score is excess return over a benchmark *on the same market* (buy and hold, 60/40), so runs on different seeds are comparable, and the seed travels in the replay header. Foresight is then a skill you may exercise but cannot make comparable by *choosing* a seed.
- **Daily market, as a puzzle** (rec): everyone gets the same seed, spoilers are expected (like any daily puzzle), and the best replay is shared; the leaderboard is "who found the cleverest path", which is a perfectly respectable game.
- **Open-book category:** the model is public by design and the competition is *out-modelling the model*. This is the Excel-modelling-competition culture exactly, and it may be the sharpest marketing hook in the file.
- **The Strategy sheet's sandbox** (see section 8.6): whether rules may reference hidden state is a decision for the owner.

---

## 6. The menu: asset classes and vehicles

Ladders run cheapest to dearest. **Price and risk are separate axes** (rec): cheap vehicles are risky and dear ones steadier and lower-yielding (a barbell), so a growing firm *reaches for yield* by climbing classes, which is "ever-riskier asset classes to boost net worth" (owner) as a story the player lives. The *unlock order* of classes follows licensing complexity (section 3), not risk.

Each row below is: **vehicle**, then **what it does to the player**. Real names are used as the sitting's working labels; the in-game names are jokes (section 2, appendix A).

### Stocks

| # | Vehicle | What it does |
|---|---|---|
| 1 | Penny stocks | pay dividends in pennies; pump-and-dump events; most go to nothing |
| 2 | Microcaps | wide spreads, thin liquidity |
| 3 | Russell 5000 | the broad market including the small fry |
| 4 | Russell 3000 | the 1000 and the 2000 together |
| 5 | Russell 2000 | small caps; high beta; the recovery's darling |
| 6 | Russell 1000 | large and mid caps |
| 7 | Dividend aristocrats | dividends that grow every year: the snowball |
| 8 | S&P 500 | the benchmark your clients grade you on |
| 9 | S&P 100 | the megacaps; lower volatility, concentration risk |
| 10 | NASDAQ-100 | growth and technology; earnings multiples; bubble risk |
| 11 | International and emerging ADRs | a currency overlay on every return |
| 12 | Pre-IPO shares | a lottery on the first-day pop |

*Page mechanics:* an **alpha slider** (analysts may beat the index, at a fee, or you index for free); dividend growth that compounds; earnings-season volatility; the **nesting** of the Russell indexes as a set bundle (own the 1000 and the 2000 and the 3000 unlocks at a discount); an IPO-allocation lottery.
*Note:* private equity moved to Companies as the leveraged-buyout capstone; its payoff (capital calls, lock-ups, 2 and 20, a J-curve) is a different machine from a stock index.

### Bonds

| # | Vehicle | What it does |
|---|---|---|
| 1 | Savings and I-bonds | tiny, safe, capped purchases |
| 2 | Junk bonds | high yield, real defaults |
| 3 | Municipal bonds | tax-free, funds the potholes |
| 4 | Agency bonds | almost government |
| 5 | Treasuries (2y to 30y) | the risk-free reference; duration |
| 6 | TIPS | inflation-linked |
| 7 | Investment-grade corporates | a spread over Treasuries |
| 8 | Convertibles | a bond with an equity kicker |
| 9 | Emerging-market sovereigns | carry, and a default calendar |
| 10 | Leveraged loans | floating-rate, covenant-lite |
| 11 | Agency MBS pass-throughs | prepayment risk |
| 12 | CLO and MBS tranches | senior, mezzanine, equity: the waterfall |

*Page mechanics:* price against the rate cycle (**duration**); **credit spreads** and defaults; **maturity timers** (principal returns at par, then reinvest: a decision); a **yield-curve sheet** whose inversion is the recession signal; a **tranche waterfall** where losses eat the equity first and the AAA "is safe until it isn't" (a scripted boss: the correlation spike).

### Commodities

| # | Vehicle | What it does |
|---|---|---|
| 1 | Live cattle | "moo-ney"; disease events |
| 2 | Lean hogs | seasonal |
| 3 | Corn | harvest cycle |
| 4 | Wheat | weather shocks |
| 5 | Soybeans | export demand |
| 6 | Sugar | ethanol linkage |
| 7 | Coffee | frost events |
| 8 | Natural gas | storage and weather |
| 9 | Crude oil | supply shocks; the cartel |
| 10 | Copper | the economy's pulse |
| 11 | Silver | industrial plus fear |
| 12 | Gold | the stagflation hedge |

*Page mechanics:* **harvest seasonality** (an annual sine: buy at harvest lows, sell in spring); **storage cost against appreciation** (cash-and-carry); supply shocks (weather, cartels, strikes); **contango and backwardation** and the roll yield for futures-based vehicles; the inflation hedge that pays in stagflation. Bonus rungs: platinum, uranium, lithium.

### Derivatives

| # | Vehicle | What it does |
|---|---|---|
| 1 | Long calls | defined risk, theta bleed |
| 2 | Long puts | the umbrella |
| 3 | Covered calls | the landlord: income, capped upside |
| 4 | Cash-secured puts | the patient shopper |
| 5 | Bull call spreads | the budget optimist |
| 6 | Bear put spreads | the budget pessimist |
| 7 | Straddles and strangles | a bet on size, not direction |
| 8 | Iron condors | income if nothing happens |
| 9 | Naked calls | unlimited risk, in plain sight |
| 10 | Index futures | linear leverage; daily settlement |
| 11 | Interest-rate swaps | trade the rate path |
| 12 | Volatility products and credit default swaps | the steamroller and its insurance |

*Page mechanics:* **expiry timers and time decay**; **margin and margin calls**; the **payoff-diagram builder** (section 9); brokerage **option-approval levels** as internal unlocks; and "Volmageddon" as a scripted event for the short-volatility rung.

### Currencies and crypto

| # | Vehicle | What it does |
|---|---|---|
| 1 | Foreign-currency savings | a bank account with a time zone |
| 2 | EUR/USD | the benchmark pair |
| 3 | USD/JPY carry | the carry trade's home |
| 4 | GBP/USD | central-bank drama |
| 5 | AUD/NZD | commodity currencies |
| 6 | EM carry basket (MXN, BRL, TRY) | high carry, cliff risk |
| 7 | A currency-peg bet | until it breaks |
| 8 | Bitcoin | the four-year halving beat |
| 9 | Ethereum | the other one |
| 10 | Stablecoin yield | a promise that is stable until it is not |
| 11 | Altcoins and memecoins | a pump with a logo |
| 12 | DeFi liquidity pools | impermanent loss, permanent headache |

*Page mechanics:* **the carry trade** (steady income until a funding-currency snap-back), **peg breaks** (the Swiss franc, 2015, as a historical event), the **halving beat**, 24/7 markets (no closing bell), rug-pulls and exchange failures.

### Real estate

| # | Vehicle | What it does |
|---|---|---|
| 1 | Storage units and parking | small, steady |
| 2 | Tax liens | a lien is an interest rate with a deed behind it |
| 3 | Foreclosures | appear **only in busts** |
| 4 | Single-family rentals | a mortgage and a tenant |
| 5 | Duplexes and fourplexes | house-hacking |
| 6 | Apartment buildings | cap rate, vacancy |
| 7 | Strip malls | anchor-tenant risk |
| 8 | Farmland | slow, inflation-linked |
| 9 | Warehouses and logistics | the e-commerce wave |
| 10 | Office towers | the work-from-home wave, the other way |
| 11 | Resorts | seasonal, cyclical |
| 12 | A private island | the ending |

*Page mechanics:* **mortgage leverage and the cash-out refinance**; **cap rate against interest rates**; vacancy and maintenance; **illiquid sale timers**; a **1031 exchange** to roll gains; renovation timers.

### Companies

| # | Vehicle | What it does |
|---|---|---|
| 1 | Lemonade stand | the tutorial |
| 2 | Laundromat | "we clean up" |
| 3 | Car wash | the same, with water |
| 4 | Vending routes | route density |
| 5 | Restaurant | thin margins, high churn |
| 6 | Gas station | volume, convenience-store margin |
| 7 | Hotel | an operating business inside a real-estate wrapper |
| 8 | Franchise group | royalties |
| 9 | Medical practice | regulated, sticky |
| 10 | Factory | capex and a cycle |
| 11 | SaaS company | recurring revenue, a multiple |
| 12 | Private-equity buyout | the leveraged buyout capstone |

*Page mechanics:* **managers as automation** (the AdVenture Capitalist staple, here with salaries); **multiple expansion** in booms; **leveraged buyouts** (borrow against the target's cash flows); dividend recaps; exits. Bonus rungs: sports team, conglomerate.

### Classes to add (the owner liked the first three)

- **Cash and banking, insurance, alternatives and collectibles:** the bunker; section 7.
- **Venture and IP:** angel checks, seed, Series A to C, growth equity, unicorns, patents, royalty streams, the SPAC (a joke vehicle). *Page mechanic:* power-law payoffs (most go to zero, one pays a hundredfold), dilution, follow-on decisions.
- **Infrastructure and energy** (later): toll roads, pipelines, solar farms, data centres, a nuclear plant. *Page mechanic:* build timers before income.

---

## 7. The bunker: stores of value outside the market

> "I like your idea about cash/banking, insurance, alternatives/collectibles as stores of value for players to keep cash/equivalents outside of the market during inclement market weather conditions." (owner)

These three classes are not an afterthought; they are the **other half of the game**. The player's real decision in a storm is not which stock to sell, it is *where to stand*. Every shelter has a cost, a cap and a way to fail, so hiding is a decision and not a pause button.

### The shelter model (rec)

| Shelter | What it pays | What it costs | How it fails |
|---|---|---|---|
| **Cash and banking** | a rate that rises when rates rise | inflation erodes it; "cash drag" in clients' benchmarks | bank failures, deposit-insurance caps, lock-ups |
| **Insurance** | protection, cash value, guaranteed payouts | premiums, fees, surrender charges | insurer insolvency, claims disputes, the fine print |
| **Alternatives and collectibles** | an asset that is not in the market's mood | storage, insurance, spreads, patience | appraisal lag, fakes, fads, illiquidity |

### Cash and banking (The Mattress District)

| # | Vehicle | What it does |
|---|---|---|
| 1 | The mattress | 0%; theft and moth events |
| 2 | Checking account | 0.01%; fees; overdraft jokes |
| 3 | Savings account | insured up to a cap per bank: **spread your cash across banks** |
| 4 | CD, six months | a lock-up with an early-withdrawal penalty |
| 5 | CD ladder, five years | rolling maturities; a bet on the rate path |
| 6 | Money market fund | "breaks the buck" is an event |
| 7 | Treasury bills | the safest; auction timers |
| 8 | I-bonds | inflation-linked; purchase-capped |
| 9 | Brokered sweep account | yield with counterparty risk |
| 10 | Overnight repo lending | tiny and steady until it is not |
| 11 | Swiss vault | privacy; a fee; negative rates once happened |
| 12 | The bunker in New Zealand | pays nothing until the apocalypse; costs upkeep |

*Mechanics:* **inflation erodes idle cash** (the idle-game cure for hoarding); the deposit-insurance **cap** per bank makes a spreading puzzle; **bank runs** are an event, and a bank is a vehicle with a failure probability tied to stress; **lock-ups mean you cannot hide in a CD at the last minute**; cash yields rise with the rate cycle, so "cash is trash" until the day it is not.

### Insurance (The Umbrella Department)

| # | Vehicle | What it does |
|---|---|---|
| 1 | Renter's policy | cheap; theft events |
| 2 | Auto policy | fender benders |
| 3 | Homeowner's policy | weather events |
| 4 | Term life | pure protection |
| 5 | Whole life | slow cash value, heavy fees |
| 6 | Fixed annuity | guaranteed income; insurer credit risk |
| 7 | Variable annuity | market-linked, with riders and fees |
| 8 | Indexed annuity | a floor and a cap: a structured product in a suit |
| 9 | Business-interruption policy | pays when the world stops |
| 10 | Key-person policy | for Steve |
| 11 | Catastrophe bonds | high yield until a hurricane |
| 12 | Reinsurance treaty | underwrite the underwriters |

*Mechanics:* **float** (premiums now, claims later) is leverage that feels free until the hurricane: steady pennies, a rare steamroller, a negative-skew payoff the player must provision for; premiums against payouts; claim events with seeded schedules; **counterparty risk** (the insurer can fail, which is a lesson from 2008 and funny only afterwards); the indexed annuity's capped upside as a teaching moment about structured products.

### Alternatives and collectibles (The Attic)

| # | Vehicle | What it does |
|---|---|---|
| 1 | Trading cards | grading: send them off, wait, hope |
| 2 | Sneakers | limited drops; a lottery to buy, a spread to sell |
| 3 | Comic books | a grading company's opinion is the price |
| 4 | Rare coins and stamps | slow, dignified |
| 5 | Wine | ages up, then down; "corked" risk |
| 6 | Whisky casks | the angels' share evaporates yearly |
| 7 | Watches | brand cycles; fakes |
| 8 | Classic cars | storage, insurance, auctions |
| 9 | Fine art | appraisal lag, provenance, forgery events |
| 10 | Beanie Babies | the 1990s, as a historical bubble |
| 11 | NFTs | "right-click save" is a mechanic |
| 12 | A sports franchise | illiquid, enormous, vanity |

*Mechanics:* **appraisal marks lag the market** (smoothed prices make collectibles *look* uncorrelated, which is partly a lie and a good one to teach); **authenticity risk** (a forgery event); **auction events** with reserve prices and buyer's premiums; storage and insurance carrying costs; **fad cycles** with their own phase; illiquidity (a sale takes ticks). Historical Easter eggs: tulips in 1637.

### The weather metaphor

The market weather, forecast and shelter fit one picture: *sun* (bullish), *scattered clouds* (a correction), *rain* (a bear market), *thunderstorm* (a crash), *hurricane* (a systemic event). The bunker is where you stand when the forecast turns. The forecast panel is the *Buffet Weather Service* (section 1).

---

## 8. Mechanics against click-and-wait

The brief (owner): avoid "the inevitable monotony of clicking and waiting for time to pass". The answer is **decisions with stakes**: things a player can do *badly*. Each mechanic below states the loop, the rules, the finance, the jokes, the engine fit, the failure modes and what it teaches.

### 8.1 The firm layer: AUM, fees, redemptions

- **The loop.** Attract clients (marketing and a track record), allocate to funds with mandates (Conservative, Balanced, Aggressive: each with allowed classes and a leverage cap), earn fees, pay payroll, and meet quarterly redemption windows.
- **The rules.** Section 4's formulas. Add **side pockets** for illiquid holdings ("the side pocket is where we put the things we don't talk about"), a **hurdle rate** option, and a **clawback** late game.
- **The finance.** High-water marks, fee drag, operating leverage, the manager's option payoff.
- **The jokes.** "2 and 20 (the ancient Roman numeral for greed)." Client personas who send emails.
- **The engine.** `MAX`, `MIN`, `IF` and arithmetic; all deterministic. Positions as formula state (`=IF(buy, n.last + k, n.last)`); the Write sheet for cross-sheet effects, kept short (`SPEC.md` 3.9).
- **Failure modes.** A death spiral that cannot be escaped (soft-lock); a first AUM so punishing that the early game is not checkers. Always leave a recoverable path, and make the first client forgiving.
- **Teaches.** Why performance fees reward risk; why the high-water mark exists; why funds gate.

### 8.2 Licences, exams and audits

- **The loop.** Study (time and analysts), book the exam (a timer), sit it (a short mini-game), earn the licence, pay continuing education and compliance, and survive audits.
- **The audit is a spreadsheet mini-game.** The examiner arrives (probability rises with size and falls with compliance), and the player must **find the planted error in their own books**: a typed-over constant, an inconsistent formula in a fill, a range that omits a cell. Defects are laid at build time (the step never writes formulas, `AD-7`), and a seeded one is "active". Click the cell. Correct: "a clean exam" (Mildred wept). Wrong: a fine and a reputational hit.
- **The finance and compliance.** Real licence structure (section 3); fiduciary duty; recordkeeping; the idea that regulation is a cost centre and a moat.
- **The jokes.** The proctor; "Series 404"; the study montage.
- **The engine.** Questions are rows (a `Exam` sheet); draws are seeded; the audit's defect index is a seeded value and the cell clicked is the pointer's Screen cell (`Input!B11` and `B12`).
- **Failure modes.** Exam tedium: keep exams under about 90 seconds, make them skippable by delegating to staff (at a cost, "Steve sits the Series 7").
- **Teaches.** The regulatory shape of finance and, quietly, the error classes of real spreadsheets (the same classes Frazaro's audit command finds).

### 8.3 Cycle rotation and the forecast

- **The loop.** Read the forecast and the leading indicators; rotate between classes ahead of regime shifts; hold a *policy* allocation and decide how far to *tilt*.
- **The indicators** (each a noisy view of hidden state, with its own lead time): the yield-curve slope (inversion leads downturns by quarters to a couple of years), credit spreads, valuation against history, momentum, sentiment, a purchasing-activity index, inflation, jobless claims.
- **The forecast** is a weighted blend, rendered as weather with probabilities. Analysts reduce the noise. A **Brier score** on the player's own forecasts is a cute, optional readout.
- **The UI.** The Investment Clock as a wheel, with a hand that moves; the forecast beside it.
- **The jokes.** Forecaster personas: Chip the Bull, Barbara the Bear, the Permabear who predicted twelve of the last two recessions.
- **The engine.** Indicators are formulas over hidden-state cells plus seeded noise. No lookahead: a forecast uses the *current* hidden state. (See the open-book problem, section 5.)
- **Failure modes.** A forecast so accurate the game is solved, or so noisy it is a slot machine. The signal-to-noise ratio is the difficulty knob.
- **Teaches.** Business cycles, leading and lagging indicators, sector rotation, and honest humility about timing.

### 8.4 Leverage, margin and shorts

- **The loop.** Slide leverage from 1x to 10x per position or fund; borrow at a rate (base plus a spread); short with a borrow fee; meet maintenance margin or be liquidated.
- **The rules.** Initial margin 50% and maintenance 25% for stock, as the classic US rules; futures margin as a smaller fraction of notional; a margin call fires when equity over exposure falls below maintenance; forced liquidation sells the largest positions first, ties by a fixed order (deterministic, so a replay replays the carnage); a liquidation penalty. **Short squeezes** are an event (recalls, a borrow-fee spike, a meme rally).
- **The finance.** Leverage amplifies both ways; risk of ruin; the Kelly fraction; liquidation cascades.
- **The jokes.** "Margin call: your call is important to us." A strongly worded text from your broker.
- **The engine.** Margin ratio per position; the Write sheet issues forced sells next frame in a fixed order.
- **Failure modes.** Total liquidation as a soft-lock: offer the *bailout* (below).
- **Teaches.** Why leverage is dangerous and how fast; why cash is a position.

### 8.5 Distress buys and dry powder

- **The loop.** Hold cash. When stress spikes, **fire-sale offers** appear for a limited time: foreclosures, defaulted debt at 30 cents on the dollar, distressed companies, blue chips at a discount. Take what you can afford before the window closes.
- **The rules.** Availability gated by `stress > threshold`; discounts of 10% to 70% scaled by stress; a countdown in frames; the recovery is the model's mean reversion.
- **The finance.** The liquidity premium; dry powder; vulture investing; "be greedy when others are fearful", the oldest advice in the building.
- **The jokes.** "Everything must go. Including, soon, you."
- **The engine.** Offers are locked rows with `IF(stress>threshold, available, 0)`; purchases through the Write sheet.
- **Failure modes.** Hoarding cash forever: inflation, cash drag and AUM benchmarks must make cash cost something.
- **Teaches.** Cash has option value; liquidity is an asset.

### 8.6 The Strategy sheet: automation by authored rules

*The Frazaro wink.* This is the endgame and the product.

- **The loop.** A rules table: a row is a rule with a *condition* (a formula), an *action* (buy, sell, rebalance to target weights), a *size* and *guards* (a maximum position, a cooldown). The player types the formulas; the sheet evaluates each tick; the Write sheet executes orders with costs and slippage. The rules run while the player is away.
- **Starter recipes** (copyable, named, with jokes): Buy and Hold; **60/40 Rebalance**; Dollar-Cost Averaging ("slow and steady loses the race to nobody"); Trend Follower (price above its 200-day average); Mean Reversion; Golden Cross ("The Chad"); Stop-Loss ("The Coward's Stop-Loss"); Trailing Stop; Take-Profit; Volatility Targeting; Risk-Parity-Lite.
- **Target-weight rebalancing** quietly harvests volatility (Shannon's demon): a bonus the game need not announce and the sharp will notice.
- **Backtesting.** A "run ten game-years" button that seeks forward (a replay played at engine speed, `ENGINE.13`'s seek), then an *out-of-sample* run on another seed. The overfitting event: "your strategy worked perfectly on the past; congratulations, you have invented hindsight".
- **English sentences.** "Buy gold when its price is below its 20-day average." Frazaro's compiler is exactly this product; a typed-formula version works now (grid mode), the sentence version waits on a page hosting both modules (`SPEC.md` 7.4).
- **Guard rails.** A circuit breaker and a big red kill switch (deterministic), an order-rate cap per tick, a cost model.
- **The engine.** A person may write formulas (`AD-7`); what they *do* is write values through the Write sheet. Rules ≤ about 50 so the Write sheet stays short. The rules are authored edits, so the replay carries them.
- **Failure modes.** Peeking at the future: whether a rule may reference hidden state is a decision (a reference whitelist is a page check, not an engine one).
- **Teaches.** Algorithmic trading, backtesting and its sins, and, without saying so, programming.

### 8.7 Rival funds and the league table

- **The loop.** Six to ten rival firms play the same market by deterministic heuristics whose weights are readable rows (the textbook-opponent shape of `CART.6` to `CART.8`). A **league table** ranks by Sharpe or return. Rivals poach clients when ahead; hostile takeovers are an event. Open a rival's sheet and read its mind (`AD-6`).
- **Archetypes** (fictional): The Index Hugger, The Momentum Chad, The Value Boomer, The Quant Who Will Not Explain, The Permabear, The Crypto Bro, The Pension Fund (slow), The Sovereign Wealth Fund, The Guy With A Newsletter.
- **The engine.** A rival is about 20 cells over the same market; they do not move it.
- **Teaches.** Styles (value, growth, momentum, quant), benchmarking, and the humility of never beating the index.

### 8.8 Prestige: IPO the firm, or raise Fund II

- **IPO.** Reset operations and capital; take the firm public for *Float* (permanent multipliers: lower overhead, higher client trust). Then *lock-up* (shares cannot be sold for a period), *earnings pressure* (a quarterly-guidance mini-game), later a secondary offering, buybacks, an activist.
- **Fund II.** Return Fund I's capital, raise a successor fund; the **carry** from Fund I's realized gains is a permanent personal multiplier. **Vintage-year risk**: Fund II starts in whatever conditions the market is in, which is the real reason vintage matters.
- **The rules.** A threshold of AUM *and* at least one completed bust (so the player has felt a drawdown before being rewarded for surviving one).
- **The finance.** Underwriting spreads, lock-ups, carried interest, fund life.
- **The jokes.** "Ring the bell" (a slideshow with snacks).
- **The engine.** A prestige is a *scenario switch*: one edit dirtying most of the graph, which is `CART.11`'s model-benchmark property and the incremental frame's whole-frame fallback.

### 8.9 The also-rans (each a candidate, none committed)

- **Taxes and holding periods.** Long-term against short-term gains, the wash-sale rule, year-end tax-loss harvesting, and an "April 15" ritual. **Tax lots** (FIFO, LIFO, highest-in-first-out) are a small optimization the spreadsheet community will enjoy.
- **Position sizing and the Kelly gauge** on gambles (the IPO lottery, venture): overbetting ruins.
- **Rumour against news.** Buy the rumour, sell the news: a drift then a reversal, as an event shape.
- **The opening bell.** A 30-second optional skill burst, for the people who like to click.
- **Earnings season.** Quarterly volatility spikes.
- **Splits, reverse splits, delistings, bankruptcies.** Cosmetic and funny: "your one share is now ten shares of the same thing; nothing changed; everyone cheers".
- **Currency hedging.**
- **The bailout.** A one-time "too big to fail" reset-saver, with a reputational price: satire that is also a floor.

---

## 9. The options strategy pane

> "Devising an option strategy construction pane would allow players to construct all sort of compound option strategies to 'speculate' against the market by constructing iron condors and other multi-leg strategies." (owner)

This is the tutorial's centrepiece and the cartridge's most spreadsheet-native screen.

### The interface (rec)

- Pick an **underlying** (a vehicle), an **expiry** (ticks away) and add **legs**: long or short, call or put, a strike (a step offset from spot), a quantity.
- The pane draws the **payoff at expiry** (a row of 21 to 41 price points), the **current theoretical value**, **maximum profit and loss**, **breakevens**, the **Greeks**, the **margin requirement** and the **probability of profit**.
- **Recipes** drop a pre-built strategy into the pane. Dragging a strike moves the curve live.
- Option approval levels unlock progressively (covered calls and cash-secured puts, then long options, then spreads, then undefined risk), as brokers do.

### The pricing engine: a binomial lattice

No `EXP`, `LN`, `SQRT` or `NORM.DIST` is in the dialect, so Black and Scholes is out and the **binomial lattice**, the textbook spreadsheet model, is in:

```text
dt = T / N                       ; N = 20 steps: 231 nodes a lattice
u  = 1 + sigma * dt ^ 0.5        ; first-order approximation of exp(sigma*sqrt(dt)); ^0.5 is the root
d  = 1 / u                       ; recombining by construction: u*d = 1
p  = ((1 + r*dt) - d) / (u - d)  ; risk-neutral up-probability
S(i,j)  = S0 * u ^ (2*j - i)     ; node j of step i
V(N,j)  = MAX(S(N,j) - K, 0)     ; a call at expiry (a put: MAX(K - S, 0))
V(i,j)  = (p*V(i+1,j+1) + (1-p)*V(i+1,j)) / (1 + r*dt)    ; European
V(i,j)  = MAX(exercise, that)                              ; American
q(i+1,j) = q(i,j-1)*p + q(i,j)*(1-p)                       ; Pascal's triangle of probabilities, no factorials
```

- **A multi-leg value** is the sum of its legs' lattices (linear), so four legs are four lattices of 231 cells.
- **The terminal row of the lattice is the terminal distribution.** Probability of profit is `SUM` over terminal nodes of `q(N,j) * IF(payoff(S(N,j)) > 0, 1, 0)`. The lattice gives it for free.
- **Two probabilities, one lesson.** Compute it with the risk-neutral `p` and again with a real-world `p` that uses the model's drift: *the gap is the risk premium*. That is a month of a derivatives course in one number.
- **Greeks from the lattice.** Delta from the first step: `(V(1,1) - V(1,0)) / (S(1,1) - S(1,0))`. Gamma from the second differences. Theta from the central node two steps forward over `2*dt`. Vega by re-pricing with `sigma + dsigma` (a second lattice). The Greeks panel is nearly free.
- **A cheap oracle.** The engine's native tests may use `exp` and `ln`: the lattice at 20 steps held to a closed-form Black and Scholes within a stated tolerance over a suite is a ready-made oracle (rec).

### The recipe book (named, with jokes)

| Recipe | Legs | The lesson |
|---|---|---|
| **Long call**, "The Lottery Ticket" | buy a call | limited loss, unlimited gain; theta bleeds you |
| **Long put**, "The Umbrella" | buy a put | insurance; its price is a premium, so it hurts when it works |
| **Covered call**, "The Landlord" | own stock, sell a call | income, capped upside |
| **Cash-secured put**, "The Patient Shopper" | sell a put, hold the cash | paid to wait; assigned shares like homework |
| **Protective put**, "The Seatbelt" | own stock, buy a put | a floor |
| **Collar**, "Belt and Suspenders" | stock, buy a put, sell a call | the call funds the put |
| **Bull call spread**, "The Budget Optimist" | buy a call, sell a higher call | cheaper, capped |
| **Bear put spread**, "The Budget Pessimist" | buy a put, sell a lower put | the mirror |
| **Bull put spread**, "The Toll Booth" | sell a put, buy a lower put (credit) | defined risk income |
| **Long straddle**, "The Fence-Sitter" | buy a call and a put, same strike | a bet on size, not direction |
| **Short strangle**, "Pennies Before the Steamroller" | sell an OTM call and put | steady income, ruin tail |
| **Iron condor**, "The Condor" | sell an OTM put spread and an OTM call spread | profit if nothing happens; max loss = wing width - credit |
| **Iron butterfly**, "The Pin" | short straddle, long wings | a narrow profit tent |
| **Long butterfly**, "The Sniper" | buy, sell two, buy | cheap bet on a price |
| **Broken-wing butterfly**, "The Limp" | an asymmetric butterfly | a free-ish trade with a tail |
| **Calendar spread**, "The Time Traveller" | sell near, buy far | time decay as a weapon; needs two expiries |
| **Diagonal**, "The Time Traveller's Cousin" | calendar with strikes | |
| **Ratio spread**, "The Ratio Rat" | 1 long, 2 short | undefined risk with a smile |
| **Jade lizard**, "The Lizard" | short put, short call spread | no upside risk if the credit exceeds the spread width |
| **The Wheel**, "The Hamster" | cash-secured put, assignment, covered call, repeat | a loop that feels like an income and is a position |
| **Box spread**, "The Loan Shark" | a synthetic loan | arbitrage and financing in one |
| **Synthetic long**, "The Impersonator" | buy a call, sell a put | stock without the stock |

### The pitfalls, as events

- **Early exercise** and dividends (American options): "you have been assigned shares; they have been assigned to you like homework".
- **Pin risk** at expiry.
- **IV crush** after earnings: "you were right about direction and still lost" (vega).
- **Assignment** on short options.
- **The pattern-day-trader rule** and its dollar floor as a gate.

### The scale knob

Slice the pane into units: each concurrent strategy is about four lattices of 231 cells plus a payoff row and a Greeks block: a few thousand cells for a few strategies. A lattice is a triangular dependency graph 20 deep, a small Sand, which makes the pane a free depth test.

---

## 10. From game to tutorial

> "This cartridge could easily evolve into a full-blown financial market tutorial application." (owner)

It can, because the properties that make it a game (determinism, inspectability, the model as cells) are the properties a classroom wants.

### The layers

1. **Play.** The idle loop; the funny.
2. **Explain.** Every figure has a *Why?*: the cone of the cell (`ALGEBRA.md` 2.1): precedents of net worth, laid out as a **post-mortem** after a drawdown. Concept cards unlock on first encounter and quote the exam's one-line "why". A glossary is a sheet.
3. **Experiment.** A sandbox where the model is open (`AD-6`): edit betas, rates, correlations, the difficulty tier; fork a run ("what if rates were 15%?"); a **scenario library** (1637, 1929, 1973, 1987, 2000, 2008, 2020, 2022) as seeds plus parameter sets.
4. **Teach.** Instructors set seeds and scenarios; students submit replays; grading is **re-execution** (`ENGINE.10`), with rubrics as sheets. A cohort league table.

### Accuracy policy (rec)

- **Toy models, labelled.** Every simplification is on a sheet called *Things this game gets wrong* (funny and honest): "volatility does not cluster this neatly; the Kondratiev wave is a crime against statistics; the yield curve has six points; real banks are worse".
- **Not advice.** A plain statement, and the joke version beside it.
- **Reviewed.** A finance educator reads the concept cards. (The owner's degree is tingling for a reason.)
- **No real data.** No tickers with real prices, no feeds (`SD-13`).
- **Not a brokerage.** No real money, ever.

---

## 11. The spreadsheet wink, and the funnel

> "This game is starting to feel like the perfect marketing tool for the spreadsheet cartridge." (owner)

### The reveals (rec)

The player should be allowed to find out, in stages, that they have been using a spreadsheet:

1. **The tabs.** The UI is a workbook: tabs are asset classes, the dashboard is a sheet.
2. **The first rule.** The first Strategy-sheet formula: *"That's a formula."*
3. **The audit.** The examiner's planted error: *"That's how real spreadsheet errors look."*
4. **The export.** The player's firm as a workbook (plausible: the door's writer takes the sheet model; the other direction, `.xlsx` into a cartridge, is `SPEC.md` 7.4's shipped road; the reverse is unchecked).

### What the audience gets

- **Idle-game players:** checkers, then chess.
- **Finance students:** a lab where the model is open.
- **Spreadsheet people:** a game that is their medium, with covariance matrices, lattices, waterfalls, amortization schedules and yield curves as *screens*.
- **Quants and hackers:** an open model and a daily market to out-model.
- **Educators:** seeds, replays, auto-grading.

### A leaderboard that is a pull request (rec)

`SD-13` forbids a leaderboard server and telemetry. So: a `strategies/` folder (0BSD) in the repository; a player adds their strategy sheet and replay in a pull request; **CI re-executes it** on the standard scenarios and posts its score. The repository is the leaderboard, verification is re-execution, and a submission is exactly the contribution the charter's hypothesis counts.

### The hypothesis, stated so it can fail (proposed)

*People who would never open a spreadsheet will play a funny idle game about money, and a game that is visibly a spreadsheet turns some of them into people who open one.*

Why it might be false: the sheet may be ignored and the game played as a game; the funny may carry five minutes and not fifty; and with no telemetry the funnel cannot be counted except where strangers act in public.

*The test (proposed; the owner may amend by a dated line before release):* one quarter after release, counting only what strangers do in public: (a) at least 10 pull requests from at least 5 people who are not the owner, at least half of them jokes, exam questions or scenarios; (b) at least 3 strategy sheets or scenario packs shared publicly; (c) at least one pull request to the model or the engine made because of the game. The hypothesis fails if a quarter passes with fewer than 3 outside pull requests. A result between leaves the hypothesis standing and the prediction unmet, and the number is then revised in a dated line.

---

## 12. Where I would push back

> "Feel free to slap my hand." (owner)

Gently, and in order of importance:

1. **"Killer app" is a hypothesis, not a fact.** The enthusiasm is warranted; the claim should be written down as a prediction and given a way to fail (section 11). Chess is also a lot to ship.
2. **Chess is the risk and the point.** Ship the checkers. The first playable must be fun in five minutes with ten rows, one cycle and the exam; the chess lives in data and unlocks one licence at a time. Progressive disclosure is not a nicety here, it is the product.
3. **The cart before the horse.** The marketing tool needs a product to market. The spreadsheet cartridge (Frazaro the spreadsheet) needs `ENGINE.8`'s second slice and more; Buffet must not delay it, and Buffet's own first slice should run on what exists.
4. **Education is a promise.** "Tutorial" implies correctness. The accuracy policy (section 10) is not optional, and a simplification labelled is a lesson while a simplification hidden is a liability.
5. **The funnel cannot be measured the usual way.** There is no analytics (`SD-13`). The only counters are what strangers do in public: forks, pull requests, stars, strategies and posts. That is a fine discipline, but it is a different one from every other game's.
6. **Keep the seams.** "Everything finally comes together" is a feeling; chat, radio, collaboration, tutorial and the options pane are separate items that should each stay shippable alone (the house's ratchet: the instrument before the operation). Buffet needs none of the network items to be a great single-player game.
7. **The open-book problem will be found in a week.** Plan for it (section 5); it is a feature if you frame it.

---

## 13. Slices and the order of work

Each slice is a game that is complete in itself, with an oracle, and each proves something to the engine.

| Slice | Name | Contents | What it proves to the engine |
|---|---|---|---|
| 0 | **Open for business** | the Series 777 exam, the firm's name, cash, stocks (four rungs), the market at tier 1, a simple forecast, net worth, a ticker of ten headlines | a model-shaped sheet, text values, error values at overflow, a rate and an edit mixed |
| 1 | **Bonds and rates** | the bond ladder, a rate cycle, Series 7 and 63, the yield-curve sheet, maturity timers | timers, amortization with `^`, a long-ish chain |
| 2 | **The firm** | AUM, fees, the high-water mark, redemptions, staff and payroll | roll-ups, `MAX`, flows, whole-graph events |
| 3 | **Leverage and weather** | margin, shorts, forced liquidation in a fixed order, the forecast panel, distress buys | deterministic cascades, locked rows |
| 4 | **Derivatives and the pane** | lattices, legs, payoff rows, Greeks, margin, the recipe book | depth (a triangular graph), a legs-by-grid block |
| 5 | **The Strategy sheet** | the rules table, backtest (seek), the sandbox, English sentences (waits on Frazaro's page) | formula writes on a person's act, replays of edits, offline progress |
| 6 | **The rest of the menu** | commodities, currencies, real estate, companies, the bunker, venture | data, scale |
| 7 | **Rivals, prestige, scenarios, classroom** | the league table, IPO and Fund II, the scenario library, assignment mode | scenario switches, `ENGINE.10` verification |

### Dependencies on engine items (as the roadmap has them)

`ENGINE.8`'s second slice (the values drawn: Frazaro's `KERNEL.37`), `ENGINE.5` (a save), `ENGINE.13` (seek: offline progress and backtests), `ENGINE.10` (proof of play: leaderboards and grading), `ENGINE.9` (the scale ladder: the procedural-vehicle dial), `ENGINE.7` (edit and continue), `KERNEL.8` (`INDEX` and text), the sentence layer (Frazaro's) for English rules. The ratchet stands: a pattern two cartridges write alike moves to the kit, and a mechanic enters the core only on a measurement and a second client. The market generator and the lattice macros are Buffet's own until another cartridge writes one.

### The oracles

The game written by hand in the engine's tests, every frame held; closed forms (compound interest, bond prices, amortization schedules, the tier series); the lattice against Black and Scholes; replay goldens; `describe`'s census; floor rows for the prestige switch and the scale dial.

---

## 14. Engine facts and constraints

*Checked 2026-10-13.*

- **The dialect.** `IF AND OR NOT SUM MIN MAX ABS INT MOD ROW COLUMN CHOOSE SIN`, with Excel's operators; `^` is among them (power, by `powf` computed inside the module). No `EXP`, `LN`, `SQRT`, `RAND`, `AVERAGE`, `INDEX` or text functions (`KERNEL.8`). A square root is `^0.5`; a mean is `SUM` over a count; a standard deviation is `SUM` of squares and `^0.5`.
- **Dice.** Park and Miller in a cartridge cell seeded from `Clock!B3` (`SPEC.md` 3.5), exact in doubles. One state cell per stream; a near-normal draw is a sum of uniforms.
- **No formulas at run time.** The step computes values only (`AD-7`). Every vehicle exists at load, locked; adding a class is data, not engine work. A person may type formulas (the Strategy sheet is within the rules).
- **The Write sheet is short.** One formula row per write, evaluated every frame (`SPEC.md` 3.9). Positions as formula state where possible.
- **Text is data.** Strings are cell values. A picker is `CHOOSE(k, ref1, ref2, ...)`, limited by the 8,192-character formula limit: about a thousand references. A kit macro generates it.
- **Grid mode.** The UI is a grid-mode cartridge (`ENGINE.8`): a window of at most 80 by 50 cells; a cell shows its value's text; a `look` fills by value; **a format has no font color** (found at `CART.4`). Whether custom number formats with literal glyphs (`▲0.0%;▼0.0%`) are honoured by the viewport is (check).
- **Palette.** Lovelace Lavender: `#A080E0`, `#E2D8F6`, `#F7F4FC`, `#6B4FC8`, and the dark lavender greys; nothing else.
- **Numbers.** Doubles end near 1.8e308 and then an error value; "no NaN reaches a cell". The end of the game is a designed thing.
- **Time.** The frame number is the only clock; the host writes no time into any cell. Offline progress is a seek (`ENGINE.13`), not a wall-clock read in a formula.
- **Determinism.** The same module gives the same bits on every browser; the native runner may differ in a transcendental's last bit, so goldens are held on the module. `SIN` and `^` are computed inside it.
- **The cap.** 1,048,576 cells in a grid (`SPEC.md` 10). Buffet at 150 vehicles and a handful of lattices is a few thousand cells; the cap is for the procedural dial.

---

## 15. What will bite

- **The palette.** Lovelace Lavender "and nothing else" has no red or green, and finance is red and green. Gains and losses need glyphs (up and down triangles) and shade steps, or an exception the owner grants for the *meaning* (rec: ask).
- **The names.** S&P, Russell and NASDAQ are others' marks. Use them nominatively with a disclaimer, or rename them (appendix A). The jokes are on-brand and the trademark risk is lower.
- **Loss aversion.** Idle games rarely let numbers fall. Give floors: insured cash, a one-time "too big to fail" bailout, crash insurance, and a difficulty dial (bull market, real world, lost decade).
- **Scope.** Seven classes by twelve vehicles by eight mechanics is a year of content. Slice vertically (section 13).
- **The ceiling.** An error value at the end of the numbers. Plan the ending ("retire to the island").
- **Text-heavy UI in a grid.** Fixed-width cells, no font color, an 80 by 50 window. The UI is a *sheet*: embrace it as the aesthetic (the spreadsheet is the joke).
- **The open-book problem** (section 5).
- **Education liability** (section 10).
- **Contribution hygiene.** Jokes as pull requests need a content policy and a reviewer.

---

## 16. Open decisions (the owner's)

| # | Decision | Recommendation |
|---|---|---|
| 1 | Class unlock order | by licensing complexity, not risk |
| 2 | One shared daily market plus a sandbox, or per-save markets only | both: per-save is the career; the daily is the puzzle |
| 3 | Strategy sheet in v1 | typed formulas in v1; English sentences when the page hosts both modules |
| 4 | Real index names or renamed | renamed, with the real name in a tooltip as the joke's explanation |
| 5 | One game year in real minutes | about six at 1 Hz (one tick a day); the teacher's dial scales it |
| 6 | Prestige | IPO first, Fund II as the second layer |
| 7 | Difficulty fixed at the start for leaderboards | yes; sandbox may change it live |
| 8 | Does the exam gate anything | no: it cannot be failed; it scales the start and picks the archetype |
| 9 | Gains and losses within the palette | glyphs and shade steps; ask for a semantic exception |
| 10 | The Strategy sheet's sandbox (hidden state) | whitelist the market's *history*, not its state |
| 11 | Scoring | alpha over a same-seed benchmark, with Sharpe and max drawdown beside |
| 12 | Where the jokes are reviewed | a `CONTRIBUTING` note and one human |

---

## Appendix A. Joke seeds

*Seeds, not copy: each is a candidate for a row in the `Jokes` sheet. (check) marks a parody of a living company or a real mark: a lawyer's glance before shipping.*

### Fine print (a rotating footer)

- "Past performance is not indicative of future results, but it is all we have."
- "Buffet is not a financial advisor. Buffet is barely a game."
- "All investments carry risk. Some carry a lunch tray."
- "Securities are not FDIC insured. Neither are your feelings."
- "Diversification does not ensure a profit; it ensures you will be wrong in several places at once."
- "Forward-looking statements are statements of hope wearing a tie."
- "This is not a recommendation to buy or sell. It is barely a recommendation to breathe."
- "Your capital is at risk. So is the office microwave."

### Headlines

- "Fed holds rates steady; markets read it as 'a sort of hug'."
- "Economists predict nine of the last three recessions."
- "Analyst upgrades stock to 'buy' after discovering he owns it."
- "Soybean futures bean-up after surprise harvest."
- "Crypto exchange loses all customer funds, describes it as 'a learning process'."
- "Board assures investors the losses are merely unrealized, 'like everything else'."
- "Yield curve inverts; bonds observed walking backwards."
- "SEC announces new rule against funny business; definitions to follow."
- "Company announces 'strategic pivot to AI'; stock up 40%; company still sells ice cream."
- "Local man buys everything at the top; market tops."
- "Hurricane season: insurers 'cautiously terrified'."
- "Tulip prices surge; historians sigh."
- "Intern discovers rounding error worth $4 million; asks about a bonus; there isn't one."
- "Private-island index hits record; sea levels also."
- "Gold remains calm as the world panics; the world finds this annoying."

### Memos from Mildred in Compliance

- "Please stop describing quarterly losses as 'a surprise party for the balance sheet'."
- "Reminder: the break-room refrigerator is not an asset class."
- "RE: RE: RE: the Series 777. It is not a slot machine."
- "Steve: please do not 'just hop on a quick call' with the regulator."
- "'Trust me' is not a due-diligence process."
- "Per Legal: the phrase 'guaranteed returns' may not appear in a sentence, a haiku or a dream."

### Index and vehicle renames

| Real | In-game |
|---|---|
| S&P 500 (check) | Standard & Poorish 500 |
| S&P 100 (check) | The Fortunate 100 |
| Russell 1000 (check) | Russell 1000 (the Tall Ones) |
| Russell 2000 (check) | Russell 2000 (the Plucky Ones) |
| Russell 3000 (check) | Russell 3000 (everyone who showed up) |
| Russell 5000 (check) | Russell 5000 (everyone, and their cousins) |
| NASDAQ-100 (check) | NASDAQ-100 (now with more vowels) |
| Penny stocks | Penny Dreadfuls |
| Microcaps | Microcaps (cap sold separately) |
| Dividend aristocrats | Old Money, Older Cash |
| Pre-IPO | Trust-Me-Bro Shares |
| Junk bonds | Junk Bonds (one man's trash) |
| Municipals | Municipals (funds the potholes) |
| TIPS | Tips on Inflation |
| Mortgage-backed securities | What Could Go Wrong™ |
| CLO equity tranche | Please Don't Look |

### Achievements

Paper Hands (sold the bottom). Diamond Hands (held through a 40% drawdown). Bagholder. Bought the Top (Twice). Margin Call: Your Call Is Important To Us. Regulatory Capture. Too Big To Fail (Briefly). Soft Landing (a recession without redemptions). Greedy When Others Were Fearful. Series 777 (a perfect score; the examiner was suspicious). The Hamster (completed the Wheel). Clean Audit (Mildred wept). Steve Fired (mysteriously profitable).

### Error values

- `#NUM!`: "Net worth exceeds the known universe. Please buy another universe."
- `#DIV/0!`: "Return on zero capital: infinite, and unavailable."
- `#REF!`: "You no longer hold this position. It holds you."
- `#VALUE!`: "The analyst entered text where a number goes. The analyst is on a call."
- `#N/A`: "Data not available. The data is at lunch."

### Rivals (fictional; the puns are the risk: (check))

Sterling, Cooper & Lowball. Bearish Stearns & Sons (check). Lemon Brothers, est. 1850, est. again 2010 (check). Goldfish Sachs (check). J.P. Morgue (check). Wells Cargo-Cult (check). The Vanguardians (check). BlackRocket (check). State Streetlight (check).

### Endings

*Retire to the island.* *Indicted, then acquitted on a technicality; the technicality is a fine.* *Bankrupt: the island is a hotel now.* *Still working: the market is, as ever, in session.*
