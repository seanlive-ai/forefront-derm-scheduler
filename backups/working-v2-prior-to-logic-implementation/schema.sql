-- Forefront Dermatology scheduling app — Supabase schema
-- Single JSON-document table mirroring the app's in-memory state.
-- Already applied to the live Supabase project backing
-- https://forefront-derm-scheduler.vercel.app/ — included here for reference
-- and so the database can be reproduced in a different Supabase project.
create table if not exists app_state (
id int primary key default 1,
data jsonb not null default '{}'::jsonb,
updated_at timestamptz not null default now(),
constraint singleton check (id = 1)
);
-- Keep updated_at fresh on every write
create or replace function touch_app_state_updated_at() returns trigger as $$
begin
new.updated_at = now();
return new;
end;
$$ language plpgsql;
drop trigger if exists app_state_touch on app_state;
create trigger app_state_touch
before update on app_state
for each row execute function touch_app_state_updated_at();
-- Seed the single row
insert into app_state (id, data)
values (1, '{"providers":[],"assistants":[],"timeOff":[],"weeks":{}}'::jsonb)
on conflict (id) do nothing;
-- RLS: this is a no-auth prototype, so the public anon key can read/write
-- the one row. Anyone with the anon key can edit the schedule -- fine for a
-- prototype, NOT for real production use. See README.md for how to lock
-- this down with Supabase Auth before wider use.
alter table app_state enable row level security;
drop policy if exists "anon can read app_state" on app_state;
create policy "anon can read app_state"
on app_state for select
to anon
using (true);
drop policy if exists "anon can update app_state" on app_state;
create policy "anon can update app_state"
on app_state for update
to anon
using (true)
with check (true);
drop policy if exists "anon can insert app_state" on app_state;
create policy "anon can insert app_state"
on app_state for insert
to anon
with check (true);
