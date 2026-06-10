-- SQL Skript pro aktualizaci zboží v obchodě (BEZ OBRÁZKŮ)
-- Spusť tento skript v Supabase SQL Editoru!

-- 1. Přidání sloupce purchase_limit do tabulky merch_items, pokud ještě neexistuje
ALTER TABLE public.merch_items ADD COLUMN IF NOT EXISTS purchase_limit INTEGER DEFAULT -1;

-- 2. Vyčištění stávajících testovacích nákupů a položek (pokud chceš začít s čistým štítem)
DELETE FROM public.purchases;
DELETE FROM public.merch_items;

-- 3. Vložení nového zboží s cenami a limity nákupu na jednoho žáka (bez obrázků)
INSERT INTO public.merch_items (id, name, cost, stock, purchase_limit, image_url) VALUES
  (uuid_generate_v4(), 'Samolepky (3 ks)', 5, -1, 2, NULL),
  (uuid_generate_v4(), 'Samolepky (5 ks)', 8, -1, 2, NULL),
  (uuid_generate_v4(), 'Náramek', 8, -1, 2, NULL),
  (uuid_generate_v4(), 'Odznáček', 10, -1, 1, NULL),
  (uuid_generate_v4(), 'Tyčinka', 15, -1, 3, NULL),
  (uuid_generate_v4(), 'Láhev', 35, -1, 1, NULL),
  (uuid_generate_v4(), 'Multifunkční šátek', 80, -1, 1, NULL),
  (uuid_generate_v4(), 'Multitool', 160, -1, 1, NULL),
  (uuid_generate_v4(), 'Nářadí do řídítek', 200, -1, 1, NULL);
