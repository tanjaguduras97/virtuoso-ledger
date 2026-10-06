-- Run this once in Supabase: SQL Editor → New query → paste → Run.

create table if not exists public.entries (
  id          uuid primary key default gen_random_uuid(),
  type        text   not null check (type in ('in','out')),
  party       text   not null check (char_length(party) between 1 and 80),
  amount      bigint not null check (amount > 0),          -- in cents
  date        date   not null,
  category    text   check (char_length(category) <= 60),
  status      text   not null check (status in ('paid','pending')),
  note        text   check (char_length(note) <= 200),
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
