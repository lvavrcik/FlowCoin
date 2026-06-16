-- SQL příkaz pro rychlou úpravu cen tří produktů v Supabase SQL Editoru
-- (Tímto se upraví pouze ceny a nemusíš mazat celý obchod)

UPDATE public.merch_items 
SET cost = 70 
WHERE name = 'Multifunkční šátek';

UPDATE public.merch_items 
SET cost = 120 
WHERE name = 'Multitool';

UPDATE public.merch_items 
SET cost = 150 
WHERE name = 'Nářadí do řídítek';
