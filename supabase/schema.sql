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

-- Use RLS policies that allow anon key access scoped by anonymous_user_id if needed.
