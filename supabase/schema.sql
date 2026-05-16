-- DeskDose Supabase schema (reference)

create table if not exists public.users (
  id uuid primary key references auth.users (id) on delete cascade,
  email text not null,
  display_name text,
  avatar_url text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

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
  user_id uuid not null references public.users (id) on delete cascade,
  routine_id uuid not null references public.routines (id) on delete cascade,
  completed_at timestamptz not null default now(),
  duration_seconds int not null,
  calories_burned numeric,
  created_at timestamptz not null default now()
);

create table if not exists public.hydration_logs (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.users (id) on delete cascade,
  amount_ml int not null,
  logged_at timestamptz not null default now()
);

create table if not exists public.reminder_settings (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.users (id) on delete cascade,
  type text not null,
  is_enabled boolean not null default true,
  interval_minutes int not null default 60,
  start_time text,
  end_time text,
  unique (user_id, type)
);

-- Enable RLS and add policies per your auth requirements.
