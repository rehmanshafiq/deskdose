-- Run in Supabase SQL Editor after schema.sql / migrate_manual_tables.sql
-- Allows the Flutter app (anon key) to read/write anonymous-user rows.

alter table public.routines enable row level security;
alter table public.workout_sessions enable row level security;
alter table public.hydration_logs enable row level security;
alter table public.reminder_settings enable row level security;

-- Routines: public catalog read
drop policy if exists "routines_select_anon" on public.routines;
create policy "routines_select_anon"
  on public.routines
  for select
  to anon, authenticated
  using (true);

-- Workout sessions
drop policy if exists "workout_sessions_all_anon" on public.workout_sessions;
create policy "workout_sessions_all_anon"
  on public.workout_sessions
  for all
  to anon, authenticated
  using (true)
  with check (true);

-- Hydration logs
drop policy if exists "hydration_logs_all_anon" on public.hydration_logs;
create policy "hydration_logs_all_anon"
  on public.hydration_logs
  for all
  to anon, authenticated
  using (true)
  with check (true);

-- Reminder settings
drop policy if exists "reminder_settings_all_anon" on public.reminder_settings;
create policy "reminder_settings_all_anon"
  on public.reminder_settings
  for all
  to anon, authenticated
  using (true)
  with check (true);
