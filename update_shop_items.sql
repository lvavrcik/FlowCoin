-- SQL Skript pro aktualizaci zboží v obchodě a přidání sloupečku pro limit nákupu
-- Spusť tento skript v Supabase SQL Editoru!

-- 1. Přidání sloupce purchase_limit do tabulky merch_items, pokud ještě neexistuje
ALTER TABLE public.merch_items ADD COLUMN IF NOT EXISTS purchase_limit INTEGER DEFAULT -1;

-- 2. Vyčištění stávajících testovacích nákupů a položek (pokud chceš začít s čistým štítem)
-- POZNÁMKA: Pokud chceš zachovat historii nákupů, zakomentuj řádek DELETE FROM public.purchases;
DELETE FROM public.purchases;
DELETE FROM public.merch_items;

-- 3. Vložení nového zboží s cenami a limity nákupu na jednoho žáka
INSERT INTO public.merch_items (id, name, cost, stock, purchase_limit, image_url) VALUES
  (
    uuid_generate_v4(), 
    'Samolepky (3 ks)', 
    5, 
    -1, -- neomezený sklad
    2,  -- limit 2ks na osobu
    'https://images.unsplash.com/photo-1572945281861-68b122e3e84e?w=400&h=400&fit=crop'
  ),
  (
    uuid_generate_v4(), 
    'Samolepky (5 ks)', 
    8, 
    -1, 
    2, 
    'https://images.unsplash.com/photo-1572945281861-68b122e3e84e?w=400&h=400&fit=crop'
  ),
  (
    uuid_generate_v4(), 
    'Náramek', 
    8, 
    -1, 
    2, 
    'https://images.unsplash.com/photo-1611591437281-460bfbe1220a?w=400&h=400&fit=crop'
  ),
  (
    uuid_generate_v4(), 
    'Odznáček', 
    10, 
    -1, 
    1, 
    'https://images.unsplash.com/photo-1622560480605-d83c853bc5c3?w=400&h=400&fit=crop'
  ),
  (
    uuid_generate_v4(), 
    'Tyčinka', 
    15, 
    -1, 
    3, 
    'https://images.unsplash.com/photo-1622483767028-3f66f32aef97?w=400&h=400&fit=crop'
  ),
  (
    uuid_generate_v4(), 
    'Láhev', 
    35, 
    -1, 
    1, 
    'https://images.unsplash.com/photo-1602143407151-7111542de6e8?w=400&h=400&fit=crop'
  ),
  (
    uuid_generate_v4(), 
    'Multifunkční šátek', 
    80, 
    -1, 
    1, 
    'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=400&h=400&fit=crop'
  ),
  (
    uuid_generate_v4(), 
    'Multitool', 
    160, 
    -1, 
    1, 
    'https://images.unsplash.com/photo-1582639590011-f5a8416d1101?w=400&h=400&fit=crop'
  ),
  (
    uuid_generate_v4(), 
    'Nářadí do řídítek', 
    200, 
    -1, 
    1, 
    'https://images.unsplash.com/photo-1485965120184-e220f721d03e?w=400&h=400&fit=crop'
  );
