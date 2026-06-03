-- ============================================================
-- PACE VACATION — Tabela de cartões
-- Execute no SQL Editor do Supabase
-- ============================================================

create table if not exists cartoes (
  id uuid primary key default uuid_generate_v4(),
  nome text not null,
  banco text,
  ultimos4 text,
  bandeira text,        -- Visa, Mastercard, Elo, Amex...
  dia_fechamento integer not null,   -- Ex: 15 (fecha todo dia 15)
  dia_vencimento integer not null,   -- Ex: 10 (vence dia 10 do mês seguinte)
  limite numeric default 0,
  obs text,
  ativo boolean default true,
  created_at timestamptz default now()
);

-- Adicionar campos de pagamento ao fornecedor na tabela vendas
alter table vendas
  add column if not exists forn_cartao_id uuid references cartoes(id) on delete set null,
  add column if not exists forn_parcelas integer default 1,
  add column if not exists forn_valor_parcela numeric default 0,
  add column if not exists forn_venc_fatura date;

-- RLS
alter table cartoes enable row level security;
create policy "auth_cartoes" on cartoes
  for all using (auth.role() = 'authenticated')
  with check (auth.role() = 'authenticated');

-- ============================================================
-- FIM — após rodar, cadastre seus cartões na aba Cartões
-- ============================================================
