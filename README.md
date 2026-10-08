# Virtuoso Ledger

A one-page tracker for Virtuoso's money: invoices to clients, team payouts and business expenses (contributions, taxes, software, rent and so on). It shows totals and net profit, what's still outstanding, reminders for unpaid invoices and bills, a 6-month chart, per-person and per-category balances, and exports CSV.

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

- Amounts are stored in cents, each in the currency it was paid in (EUR, USD, BAM, GBP or CHF).
- "Show totals in" converts everything to one currency. Paid entries use the European Central Bank rate on the payment date (from frankfurter.dev); pending entries use the latest rate. BAM uses its fixed legal rate to EUR (1 EUR = 1.95583 BAM). Each person picks their own display currency.
- The page checks for new entries every 20 seconds and when you switch back to its tab.
- Search engines are asked not to index the page, but the link itself is not secret. Anyone it reaches can change the data.
- **Amount due vs. amount paid.** If an entry has an amount due that differs from what was paid, the difference is tagged in the ledger (e.g. "Underpaid €200 → Nov") and listed under **Carry-overs** as a reminder for the next month. Mark it settled there, or, when adding the next entry for the same person, use "Add to amount due" to fold it in; it is marked settled when that entry is saved. Open underpayments count toward Outstanding.
- **Invoices.** Log an invoice with its number and due date and mark it *Not received yet*. It stays under **Reminders** (with an Overdue tag once the due date passes) until you click **Mark received**, which records the day the money arrived. Received invoices count toward income in the month the money arrived.
- **Expenses.** Contributions, taxes and other business costs are their own entry type, grouped by category, and are subtracted in Net profit. An unpaid expense with a due date appears under Reminders a week before it's due.
- **Fees on invoices.** When an invoice is received, enter the amount that reached your bank and the fees taken on the way (bank, PayPal, Wise…). If the bank amount is lower than the invoice, the page offers to count the difference as fees; anything not counted as fees carries over as unpaid. Fees show in the Received card (with their percentage), are included in Expenses & taxes as "Invoice transfer fees", and are subtracted from Net profit.
