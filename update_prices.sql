-- SQL příkaz pro rychlou úpravu cen dvou produktů v Supabase SQL Editoru
-- (Tímto se upraví pouze ceny a nemusíš mazat celý obchod)

UPDATE public.merch_items 
SET cost = 140 
WHERE name = 'Multitool';

UPDATE public.merch_items 
SET cost = 175 
WHERE name = 'Nářadí do řídítek';
