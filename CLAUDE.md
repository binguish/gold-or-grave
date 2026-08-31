# Framed House Rules — project context

This project is about scoring the daily [framed.wtf](https://framed.wtf) games played by Nick, David Rizzo ("Dave"), and Nate King. Anything that computes, displays, or explains scores must follow the rubric below exactly. When in doubt, the rubric wins over "what seems fair."

## The game

framed.wtf posts four puzzles a day. Each gives you up to 6 guesses:

| Mode      | What you see                                  |
|-----------|-----------------------------------------------|
| Framed    | Up to 6 stills from the movie, one per guess   |
| One Frame | A single frame, progressively revealed         |
| Title     | The title, progressively revealed              |
| Poster    | The poster, progressively revealed             |

A player's daily result is one value per mode: the guess number they solved on (1–6) or a fail.

Everyone plays the same puzzles, so the "poster is readable by guess 6" advantage is shared. It doesn't make a 6 worth more; it makes failing poster worse.

## Scoring rubric (v2 — weighted points, highest total wins)

| Result   | Tier   | Points |
|----------|--------|-------:|
| 1        | Gold   | 10     |
| 2        | Silver | 7      |
| 3        | Bronze | 5      |
| 4        | Trash  | 3      |
| 5        | Dumpster Fire | 2 |
| 6        | Grave  | 1      |
| Fail     | —      | -2     |

- A skipped mode counts as a fail.
- Daily score = sum of the four mode scores. Best possible day: 40. Worst: -8.
- A fail is the only way to score negative. That is deliberate: a 6 is ugly but it is still a solve; a fail costs you.
- "A solve is a solve." A lucky guess counts. Knowing the movie but not its name does NOT count — the name is the game.
- Tiebreakers, in order: (1) more modes solved, (2) best single mode, (3) it's a tie.
- The real competition is the weekly running total (Mon–Fri, the business week — amended from Mon–Sun on 2026-08-31). Weekend days can still be played and count toward all-time, but not toward the weekly title. A title is awarded once that week's Friday has passed.

```
def points(result):            # result: 1..6, or None for a fail
    table = {1: 10, 2: 7, 3: 5, 4: 3, 5: 2, 6: 1}
    return table.get(result, -2)
```

## Why the scale looks like this (context for future changes)

The rubric came out of a group argument. Keep these positions in mind before "fixing" the numbers:

- **Nick's position:** a fail is categorically worse than any solve. His original proposal was deduction-based (lowest wins, guess N costs N, fail costs 7), but that put a 6 and a fail one point apart, which undercut his own point. The negative fail score is what preserves it now.
- **David's position:** the scale isn't linear. 1–3 are real wins of different sizes, 4–5 are garbage, 6 is a gravestone. His emoji ladder (🥇🥈🥉🗑️🗑️🔥🪦) is the direct source of the tier names and the top-heavy weights.
- **Nate's position:** "the goal is to know it" — solving three modes slowly should count for something against one fast solve. That lives in the tiebreaker (modes solved first) and in the fail penalty.

Consequence everyone accepted: one gold is worth ten gravestones, so a player with one great solve and three fails (4 pts) beats a player with two 6s, a 5, and a fail (2 pts). Over a week, consistent 2s and 3s beat gold-or-nothing.

### Reference day (Aug 26, 2026)

| Player | Framed | One Frame | Title | Poster | v1 (deduction, low wins) | v2 (points, high wins) |
|--------|--------|-----------|-------|--------|-------------------------:|-----------------------:|
| Nick   | 6      | fail      | 6     | 5      | 24                       | 2                      |
| David  | fail   | fail      | fail  | 1      | 22 (won)                 | 4 (won)                |
| Nate   | fail   | fail      | fail  | 3      | 24                       | -3                     |

Use this row set as the fixture for any scoring tests.

## Rejected / alternative rubrics (don't reintroduce without a group vote)

- **v1 deduction:** guess N = N points, fail = 7, lowest wins. Rejected because 6 ≈ fail.
- **v1.5 golf:** same as v1 but fail = 10. Fixes the fail gap but keeps a linear 1–6, which David rejected.
- **Solves-first:** most modes solved wins, total guesses as tiebreaker. Rejected because a 1 and a 6 count the same.
- **Multipliers:** "get it in 1 and your day is multiplied." Dropped in favor of the weighted table, which is the same idea with less arguing.

## Conventions for this repo

- Use the tier names (Gold/Silver/Bronze/Trash/Dumpster Fire/Grave/Fail) in UI copy; use the numbers in data. ("Fire" was renamed Dumpster Fire 2026-08-26 — plain "fire" sounded like a good thing.)
- Store raw results (guess number or null), never stored points — recompute so the rubric can change without migrating data.
- Any rubric change bumps the version (v3, v4…) and gets appended to the "Rejected / alternative" list above with the reason, so the same argument doesn't happen twice.
- Players: `nick`, `david`, `nate`. David also answers to Dave.
- Publishing: `data.json` in the repo is the shared scoreboard everyone sees. The page's **Publish** button commits it via the GitHub API using a fine-grained token stored only in the scorekeeper's browser; once a token is saved, edits auto-publish ~2 min after the last tap. Devices without a token are read-only viewers.
- The scoreboard app is called **The Box Office** (renamed from "Gold or Grave" 2026-08-26). Scores DISPLAY as box-office millions ($4M, −$3M "in the red") purely as flavor — the points and stored raw guesses are unchanged. Weekly total is "the weekly gross."
