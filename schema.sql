-- Run this once in Supabase: SQL Editor → New query → paste → Run.

create table if not exists public.entries (
  id          uuid primary key default gen_random_uuid(),
  type        text   not null check (type in ('in','out','expense')),   -- invoice / team payout / business expense
  party       text   not null check (char_length(party) between 1 and 80),
  amount      bigint not null check (amount > 0),          -- in cents
  date        date   not null,
  category    text   check (char_length(category) <= 60),
  status      text   not null check (status in ('paid','pending')),
  note        text   check (char_length(note) <= 200),
  currency    text   not null default 'EUR' check (currency in ('EUR','USD','BAM','GBP','CHF')),
  expected    bigint check (expected > 0),                  -- amount due, in cents; null = paid in full
  carry_settled boolean not null default false,             -- difference between due and paid has been dealt with
  invoice_no  text   check (char_length(invoice_no) <= 40),
  due_date    date,
  paid_date   date,                                         -- when an invoice was actually paid, if not the invoice date
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now()
);

create table if not exists public.settings (
  id       int primary key check (id = 1),
  currency text not null default 'EUR' check (char_length(currency) between 3 and 3)
);
insert into public.settings (id, currency) values (1, 'EUR') on conflict (id) do nothing;

-- No login: anyone with the page link can read, add, edit and delete.
alter table public.entries  enable row level security;
alter table public.settings enable row level security;

drop policy if exists "open access" on public.entries;
create policy "open access" on public.entries
  for all to anon using (true) with check (true);

drop policy if exists "open access" on public.settings;
create policy "open access" on public.settings
  for all to anon using (true) with check (true);

grant select, insert, update, delete on public.entries  to anon;
grant select, insert, update        on public.settings to anon;

-- Added later: the currency each entry was paid in. Safe to re-run.
alter table public.entries add column if not exists currency text not null default 'EUR';
alter table public.entries drop constraint if exists entries_currency_check;
alter table public.entries add constraint entries_currency_check check (currency in ('EUR','USD','BAM','GBP','CHF'));

-- Added later: amount due vs. amount paid, and carry-over tracking. Safe to re-run.
alter table public.entries add column if not exists expected bigint check (expected > 0);
alter table public.entries add column if not exists carry_settled boolean not null default false;

-- Added later: business expenses and invoice tracking. Safe to re-run.
alter table public.entries drop constraint if exists entries_type_check;
alter table public.entries add constraint entries_type_check check (type in ('in','out','expense'));
alter table public.entries add column if not exists invoice_no text check (char_length(invoice_no) <= 40);
alter table public.entries add column if not exists due_date date;
alter table public.entries add column if not exists paid_date date;
