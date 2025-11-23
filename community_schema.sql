-- ============================================================
-- 5. COMUNIDAD (Community Features)
-- ============================================================

-- 5.1. GRUPOS DE COMUNIDAD
create table public.community_groups (
  id uuid default gen_random_uuid() primary key,
  name text not null,
  description text,
  icon text, -- Nombre del icono (ej: 'water_drop')
  accent_color text, -- Hex color (ej: '0xFF123456')
  tone text, -- Ej: 'Noches calmadas...'
  created_at timestamptz default now()
);

-- 5.2. MIEMBROS DE GRUPO
create table public.community_members (
  id uuid default gen_random_uuid() primary key,
  group_id uuid references public.community_groups(id) on delete cascade not null,
  user_id uuid references public.profiles(id) on delete cascade not null,
  role text default 'member', -- 'admin', 'member', 'moderator'
  joined_at timestamptz default now(),
  unique(group_id, user_id)
);

-- 5.3. MENSAJES DE COMUNIDAD
create table public.community_messages (
  id uuid default gen_random_uuid() primary key,
  group_id uuid references public.community_groups(id) on delete cascade not null,
  user_id uuid references public.profiles(id) on delete cascade not null,
  content text not null,
  created_at timestamptz default now()
);

-- ============================================================
-- 6. SEGURIDAD (RLS) PARA COMUNIDAD
-- ============================================================

alter table public.community_groups enable row level security;
alter table public.community_members enable row level security;
alter table public.community_messages enable row level security;

-- POLÍTICAS (Policies)

-- GRUPOS: Todos pueden ver los grupos
create policy "Anyone can view groups" on public.community_groups for select using (true);

-- MIEMBROS: Ver quién está en el grupo
create policy "Anyone can view members" on public.community_members for select using (true);
-- Unirse a un grupo (insertar su propio ID)
create policy "Users can join groups" on public.community_members for insert with check (auth.uid() = user_id);

-- MENSAJES:
-- Ver mensajes: Si eres miembro del grupo (o simplificado: todos pueden ver por ahora para demo)
create policy "Anyone can view messages" on public.community_messages for select using (true);

-- Enviar mensajes: Si estás autenticado (y eres miembro, idealmente)
create policy "Authenticated users can insert messages" on public.community_messages for insert with check (auth.uid() = user_id);

-- ============================================================
-- 7. DATOS INICIALES (Seed Data)
-- ============================================================

INSERT INTO public.community_groups (name, description, icon, accent_color, tone)
VALUES 
('Glucosa Serena', 'Chequeos diarios, recetas sencillas y alertas de hipoglucemia.', 'water_drop', '0xFF0EA5E9', 'Noches calmadas, hábitos sostenibles'),
('Ritmo Cardiaco', 'Personas con hipertensión comparten rutinas y recordatorios.', 'favorite', '0xFFEF4444', 'Respira, registra y reconoce tus logros'),
('Nube Clara', 'Espacio mixto para salud mental y acompañamiento emocional.', 'self_improvement', '0xFF10B981', 'Moderado por psicólogos invitados cada semana');
