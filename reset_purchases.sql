-- SQL příkaz pro smazání všech nákupů (historie nákupů) v Supabase
-- Tímto se vynulují limity nákupu pro všechny děti.

DELETE FROM public.purchases;
