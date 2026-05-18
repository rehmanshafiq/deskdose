-- DeskDose Supabase schema (no-login / anonymous identity)

create table if not exists public.routines (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  description text default '',
  duration_seconds int not null default 60,
  category text not null default 'stretch',
  difficulty text not null default 'beginner',
  thumbnail_url text,
  is_premium boolean not null default false,
  exercise_count int not null default 1,
  tags text[] default '{}',
  created_at timestamptz not null default now()
);

create table if not exists public.workout_sessions (
  id uuid primary key default gen_random_uuid(),
  anonymous_user_id text not null,
  routine_id uuid not null references public.routines (id) on delete cascade,
  completed_at timestamptz not null default now(),
  duration_seconds int not null,
  calories_burned numeric,
  created_at timestamptz not null default now()
);

create index if not exists idx_workout_sessions_anonymous_user_id
  on public.workout_sessions (anonymous_user_id);

create table if not exists public.hydration_logs (
  id uuid primary key default gen_random_uuid(),
  anonymous_user_id text not null,
  amount_ml int not null,
  logged_at timestamptz not null default now()
);

create index if not exists idx_hydration_logs_anonymous_user_id
  on public.hydration_logs (anonymous_user_id);

create table if not exists public.reminder_settings (
  id uuid primary key default gen_random_uuid(),
  anonymous_user_id text not null,
  type text not null,
  is_enabled boolean not null default true,
  interval_minutes int not null default 60,
  start_time text,
  end_time text,
  unique (anonymous_user_id, type)
);

-- Row-level security (required for anon key access from the app).
-- Run supabase/rls_policies.sql in the SQL Editor after creating tables.

alter table public.routines enable row level security;
alter table public.workout_sessions enable row level security;
alter table public.hydration_logs enable row level security;
alter table public.reminder_settings enable row level security;

create policy "routines_select_anon"
  on public.routines for select to anon, authenticated using (true);

create policy "workout_sessions_all_anon"
  on public.workout_sessions for all to anon, authenticated
  using (true) with check (true);

create policy "hydration_logs_all_anon"
  on public.hydration_logs for all to anon, authenticated
  using (true) with check (true);

create policy "reminder_settings_all_anon"
  on public.reminder_settings for all to anon, authenticated
  using (true) with check (true);
