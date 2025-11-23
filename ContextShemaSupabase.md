-- ============================================================
-- 1. CONFIGURACIÓN DE ENUMS (Tipos de datos personalizados)
-- ============================================================

-- Estado del procesamiento de la IA Médica
CREATE TYPE analysis_status AS ENUM ('pending', 'processing', 'completed', 'failed');

-- Rol en la conversación
CREATE TYPE message_role AS ENUM ('user', 'agent');

-- Estado del reto/desafío generado para el paciente
CREATE TYPE challenge_status AS ENUM ('assigned', 'completed', 'skipped', 'expired');

-- Categoría del reto (Vital para diabetes)
CREATE TYPE challenge_category AS ENUM ('glucose_check', 'diet', 'exercise', 'medication', 'mental_wellbeing');

-- ============================================================
-- 2. TABLAS PRINCIPALES
-- ============================================================

-- 2.1. PERFILES (Datos del Paciente)
-- Extendemos auth.users con datos médicos básicos para contexto
create table public.profiles (
  id uuid not null references auth.users on delete cascade primary key,
  full_name text,
  avatar_url text,
  
  -- Contexto Médico (Vital para que la Lambda sepa qué recomendar)
  diabetes_type text, -- 'Type 1', 'Type 2', 'Gestational', etc.
  diagnosis_date date,
  
  -- Resumen clínico generado por la IA (para tener memoria a largo plazo)
  clinical_summary text, 
  
  -- Gamificación básica
  points_balance integer default 0,
  
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

-- 2.2. CONVERSACIONES (ElevenLabs Sessions)
create table public.conversations (
  -- ID que viene de ElevenLabs (ej: "conv_xyz123")
  id text primary key, 
  
  user_id uuid references public.profiles(id) on delete cascade not null,
  
  -- Metadatos de la llamada
  start_time timestamptz default now(),
  duration_seconds integer,
  recording_url text, -- URL al audio completo si ElevenLabs lo provee
  call_status text, -- 'success', 'error', etc.
  
  -- ESTADO DE ANÁLISIS (Para tu AWS Lambda)
  ai_analysis_status analysis_status default 'pending',
  
  -- Resultado crudo del análisis (JSON) por si quieres guardar el reporte médico técnico
  medical_analysis_report jsonb, 
  
  created_at timestamptz default now()
);

-- 2.3. MENSAJES (Transcripción detallada)
-- El webhook de ElevenLabs te dará una lista de mensajes, los insertas aquí.
create table public.messages (
  id uuid default gen_random_uuid() primary key,
  conversation_id text references public.conversations(id) on delete cascade not null,
  role message_role not null,
  content text not null, -- Lo que se dijo
  
  -- Timestamp relativo dentro de la llamada (opcional)
  timestamp_in_call float, 
  
  created_at timestamptz default now()
);

-- 2.4. RETOS DE SALUD (Generated Health Challenges)
-- Esta tabla la llena tu AWS Lambda basándose en la conversación
create table public.health_challenges (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references public.profiles(id) on delete cascade not null,
  
  -- Trazabilidad: ¿De qué conversación salió este reto?
  source_conversation_id text references public.conversations(id) on delete set null,
  
  title text not null, -- Ej: "Mide tu glucosa post-prandial"
  description text, -- Ej: "Mencionaste que comiste pasta, revisa tus niveles en 2 horas."
  category challenge_category not null,
  difficulty_level integer default 1, -- 1 a 5, para dar puntos
  points_reward integer default 50,
  
  status challenge_status default 'assigned',
  
  due_date timestamptz, -- Fecha límite para cumplirlo
  completed_at timestamptz,
  
  created_at timestamptz default now()
);

-- 2.5. LOGS DE GLUCOSA (Opcional pero recomendado)
-- Si el reto es "Mídete la glucosa", el usuario necesita donde guardarlo.
create table public.glucose_logs (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references public.profiles(id) on delete cascade not null,
  value_mg_dl integer not null,
  measured_at timestamptz default now(),
  notes text,
  
  -- Si este registro completa un reto, lo vinculamos
  linked_challenge_id uuid references public.health_challenges(id),
  
  created_at timestamptz default now()
);

-- ============================================================
-- 3. TRIGGERS Y AUTOMATIZACIÓN
-- ============================================================

-- Crear perfil al registrarse
create or replace function public.handle_new_user()
returns trigger as $$
begin
  insert into public.profiles (id, full_name)
  values (new.id, new.raw_user_meta_data->>'full_name');
  return new;
end;
$$ language plpgsql security definer;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();

-- ============================================================
-- 4. SEGURIDAD (RLS)
-- ============================================================

-- Habilitar RLS
alter table public.profiles enable row level security;
alter table public.conversations enable row level security;
alter table public.messages enable row level security;
alter table public.health_challenges enable row level security;
alter table public.glucose_logs enable row level security;

-- POLÍTICAS (Policies)
-- Nota: Tu AWS Lambda usará la "Service Role Key" (bypass RLS), 
-- por lo que estas políticas son solo para proteger al usuario en la App Flutter.

-- PROFILES
create policy "Users can view own profile" on public.profiles for select using (auth.uid() = id);
create policy "Users can update own profile" on public.profiles for update using (auth.uid() = id);

-- CONVERSATIONS
create policy "Users can view own conversations" on public.conversations for select using (auth.uid() = user_id);
-- Permitimos insert si la App inserta, pero idealmente el Webhook inserta con Service Role
create policy "Users can insert own conversations" on public.conversations for insert with check (auth.uid() = user_id);

-- MESSAGES
create policy "Users can view own messages" on public.messages for select 
using (exists (select 1 from public.conversations c where c.id = conversation_id and c.user_id = auth.uid()));

-- HEALTH CHALLENGES
create policy "Users can view own challenges" on public.health_challenges for select using (auth.uid() = user_id);
create policy "Users can update challenge status" on public.health_challenges for update using (auth.uid() = user_id);

-- GLUCOSE LOGS
create policy "Users manage own glucose logs" on public.glucose_logs for all using (auth.uid() = user_id);