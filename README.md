# Virtuoso Ledger

A one-page tracker for Virtuoso's money: client payments coming in and team payouts going out. It shows totals, outstanding amounts, a 6-month chart and per-person balances, and exports CSV.

Entries are stored in a [Supabase](https://supabase.com) database, so everyone who opens the page sees and edits the same ledger from any device. There is **no login**: anyone with the link can read, add, edit and delete entries. Use **Back up** now and then to download a copy.

## Setup

1. **Create the database**
   - Sign up at supabase.com (free plan is fine) and create a new project.
   - Open **SQL Editor → New query**, paste the contents of `schema.sql`, and click **Run**.
2. **Connect the page**
   - In Supabase, go to **Project Settings → API**. Copy the **Project URL** and the **anon public** key.
   - Paste them into `config.js` and commit.
3. **Publish with GitHub Pages**
   - In this repo, go to **Settings → Pages**.
   - Under *Build and deployment*, choose **Deploy from a branch**, branch **main**, folder **/ (root)**, then **Save**.
   - After a minute the ledger is live at `https://<your-username>.github.io/virtuoso-ledger/`.

## Files

| File | What it is |
|------|------------|
| `index.html` | The whole app: layout, styles and script |
| `config.js` | Your Supabase URL and anon key |
| `schema.sql` | Tables and access rules to run once in Supabase |

## Notes

- Amounts are stored in cents. The currency setting is a label shared by everyone; it doesn't convert amounts.
- The page checks for new entries every 20 seconds and when you switch back to its tab.
- Search engines are asked not to index the page, but the link itself is not secret. Anyone it reaches can change the data.
