-- Run this in Supabase: SQL Editor → New query → Run
-- Aligns manually created tables with the DeskDose app schema (see schema.sql).

-- ---------------------------------------------------------------------------
-- routines
-- ---------------------------------------------------------------------------
alter table public.routines
  add column if not exists description text default '',
  add column if not exists duration_seconds int,
  add column if not exists thumbnail_url text,
  add column if not exists is_premium boolean not null default false,
  add column if not exists exercise_count int not null default 1,
  add column if not exists tags text[] default '{}';

-- Copy duration → duration_seconds if you used "duration"
update public.routines
set duration_seconds = coalesce(duration_seconds, duration, 60)
where duration_seconds is null;

alter table public.routines
  alter column duration_seconds set default 60,
  alter column duration_seconds set not null;

-- Optional: map video_url → thumbnail_url
update public.routines
set thumbnail_url = coalesce(thumbnail_url, video_url)
where thumbnail_url is null and video_url is not null;

-- ---------------------------------------------------------------------------
-- workout_sessions (fixes: anonymous_user_id does not exist)
-- ---------------------------------------------------------------------------
alter table public.workout_sessions
  add column if not exists anonymous_user_id text,
  add column if not exists calories_burned numeric,
  add column if not exists created_at timestamptz default now();

-- If you had user_id (uuid), you cannot auto-convert to anonymous ids; leave null
-- or drop user_id after adding anonymous_user_id.
alter table public.workout_sessions
  drop column if exists user_id,
  drop column if exists mood_after;

alter table public.workout_sessions
  alter column anonymous_user_id set not null,
  alter column duration_seconds set not null,
  alter column completed_at set default now(),
  alter column completed_at set not null;

create index if not exists idx_workout_sessions_anonymous_user_id
  on public.workout_sessions (anonymous_user_id);

-- ---------------------------------------------------------------------------
-- hydration_logs
-- ---------------------------------------------------------------------------
alter table public.hydration_logs
  add column if not exists anonymous_user_id text;

alter table public.hydration_logs
  drop column if exists user_id;

alter table public.hydration_logs
  alter column anonymous_user_id set not null,
  alter column amount_ml set not null,
  alter column logged_at set default now(),
  alter column logged_at set not null;

create index if not exists idx_hydration_logs_anonymous_user_id
  on public.hydration_logs (anonymous_user_id);

-- ---------------------------------------------------------------------------
-- reminder_settings (if you create this table later)
-- ---------------------------------------------------------------------------
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
