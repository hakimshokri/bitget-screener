# Bitget Spot Momentum Screener

A free, single-file crypto screener for Bitget spot markets. No API key, no backend,
no account — it reads Bitget's public market data directly from the browser.

**Live:** enable GitHub Pages on this repo, then open the Pages URL.

## What it does

Ranks Bitget spot pairs by whether a move is *still alive*, rather than by the 24h
change alone — a coin can be +40% on the day while actively dumping.

- **Rank by** 24h / 4h / 1h momentum, or pure volume surge
- **Vol surge** — last hour of volume vs the prior five, so you can tell money
  entering now from a move that already happened
- **Market breadth** — share of the top 22 liquid majors green on the hour, which
  turns hours before the 24h numbers do
- **Alerts** — sound + feed, armed against a baseline so only new crossings fire
- **Forward-test log** — records each signal, then scores it against BTC 1h and 4h
  later, so you can check whether the scoring actually has an edge

Filters out Bitget's ~680 tokenized equity pairs (rNVDA, rSPY, …), which report huge
volume but don't trade on weekends.

## Notes

All state (settings, alert history, forward-test log) is stored in the browser's
localStorage and never leaves the device. Each device keeps its own log.

Not financial advice. A screener finds candidates, not trades.
