-- FlowTask: chạy toàn bộ SQL này trong Supabase Dashboard > SQL Editor > New query.
-- Supabase Auth tự lưu tài khoản trong auth.users; không tạo bảng mật khẩu riêng.
create extension if not exists pgcrypto;

create table if not exists public.tasks (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  title text not null check (char_length(title) between 1 and 160),
  due_date date,
  priority text not null default 'Vừa' check (priority in ('Thấp','Vừa','Cao')),
  completed boolean not null default false,
  created_at timestamptz not null default now()
);
create table if not exists public.notes (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  title text not null check (char_length(title) between 1 and 160),
  content text not null default '',
  created_at timestamptz not null default now()
);
create table if not exists public.goals (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  title text not null check (char_length(title) between 1 and 160),
  description text not null default '',
  target_date date,
  progress integer not null default 0 check (progress between 0 and 100),
  created_at timestamptz not null default now()
);
create table if not exists public.habits (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  title text not null check (char_length(title) between 1 and 160),
  description text not null default '',
  emoji text not null default '✳',
  last_done date,
  created_at timestamptz not null default now()
);

alter table public.tasks enable row level security;
alter table public.notes enable row level security;
alter table public.goals enable row level security;
alter table public.habits enable row level security;

-- Người dùng chỉ có thể đọc/ghi/xóa dữ liệu thuộc chính tài khoản của mình.
drop policy if exists "Users manage own tasks" on public.tasks;
create policy "Users manage own tasks" on public.tasks for all to authenticated
using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);
drop policy if exists "Users manage own notes" on public.notes;
create policy "Users manage own notes" on public.notes for all to authenticated
using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);
drop policy if exists "Users manage own goals" on public.goals;
create policy "Users manage own goals" on public.goals for all to authenticated
using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);
drop policy if exists "Users manage own habits" on public.habits;
create policy "Users manage own habits" on public.habits for all to authenticated
using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);

grant usage on schema public to authenticated;
grant select, insert, update, delete on public.tasks, public.notes, public.goals, public.habits to authenticated;
