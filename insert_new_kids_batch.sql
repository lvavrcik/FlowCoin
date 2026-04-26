-- Ensure courses exist. We will just attempt to INSERT them with season_id = active. Assuming there is an active season.
DO $$
DECLARE
  active_season_id UUID;
BEGIN
  SELECT id INTO active_season_id FROM public.seasons WHERE is_active = true LIMIT 1;
  IF active_season_id IS NULL THEN
    INSERT INTO public.seasons (name, is_active) VALUES ('Jaro 2026', true) RETURNING id INTO active_season_id;
  END IF;

  IF NOT EXISTS (SELECT 1 FROM public.courses WHERE name = 'Netro PreFlow (Úterý)') THEN
    INSERT INTO public.courses (name, season_id)
    VALUES ('Netro PreFlow (Úterý)', active_season_id);
  END IF;
  IF NOT EXISTS (SELECT 1 FROM public.courses WHERE name = 'Brno Freestyle Academy (Úterý)') THEN
    INSERT INTO public.courses (name, season_id)
    VALUES ('Brno Freestyle Academy (Úterý)', active_season_id);
  END IF;
  IF NOT EXISTS (SELECT 1 FROM public.courses WHERE name = 'Netro Shred (Středa)') THEN
    INSERT INTO public.courses (name, season_id)
    VALUES ('Netro Shred (Středa)', active_season_id);
  END IF;
  IF NOT EXISTS (SELECT 1 FROM public.courses WHERE name = 'Mariánské PreFlow/Flow (Čtvrtek)') THEN
    INSERT INTO public.courses (name, season_id)
    VALUES ('Mariánské PreFlow/Flow (Čtvrtek)', active_season_id);
  END IF;
  IF NOT EXISTS (SELECT 1 FROM public.courses WHERE name = 'Brno Freestyle Academy (Čtvrtek)') THEN
    INSERT INTO public.courses (name, season_id)
    VALUES ('Brno Freestyle Academy (Čtvrtek)', active_season_id);
  END IF;
  IF NOT EXISTS (SELECT 1 FROM public.courses WHERE name = 'Jedovnice PreFlow/Flow (Pondělí)') THEN
    INSERT INTO public.courses (name, season_id)
    VALUES ('Jedovnice PreFlow/Flow (Pondělí)', active_season_id);
  END IF;
  IF NOT EXISTS (SELECT 1 FROM public.courses WHERE name = 'Netro Shred (Pondělí)') THEN
    INSERT INTO public.courses (name, season_id)
    VALUES ('Netro Shred (Pondělí)', active_season_id);
  END IF;
END $$;

-- Script to add kids and enroll them in their courses with generated PINs

-- 1. Samuel Rider (Netro PreFlow (Úterý)) -> PIN: 18618
INSERT INTO public.profiles (id, role, first_name, last_name, flowcoins_balance, pin_code)
VALUES ('e518816b-2257-49fd-9975-59c68bfcc063', 'kid', 'Samuel', 'Rider', 0, '18618')
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.enrollments (course_id, kid_id)
SELECT id, 'e518816b-2257-49fd-9975-59c68bfcc063' FROM public.courses WHERE name = 'Netro PreFlow (Úterý)' LIMIT 1
ON CONFLICT (course_id, kid_id) DO NOTHING;


-- 2. Jirka Rider (Netro PreFlow (Úterý)) -> PIN: 23058
INSERT INTO public.profiles (id, role, first_name, last_name, flowcoins_balance, pin_code)
VALUES ('b34971f1-282c-405a-bd2a-2c65edfd9215', 'kid', 'Jirka', 'Rider', 0, '23058')
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.enrollments (course_id, kid_id)
SELECT id, 'b34971f1-282c-405a-bd2a-2c65edfd9215' FROM public.courses WHERE name = 'Netro PreFlow (Úterý)' LIMIT 1
ON CONFLICT (course_id, kid_id) DO NOTHING;


-- 3. Eduard Rider (Netro PreFlow (Úterý)) -> PIN: 83921
INSERT INTO public.profiles (id, role, first_name, last_name, flowcoins_balance, pin_code)
VALUES ('71fd02bd-ecb9-4d99-8323-990394a74c51', 'kid', 'Eduard', 'Rider', 0, '83921')
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.enrollments (course_id, kid_id)
SELECT id, '71fd02bd-ecb9-4d99-8323-990394a74c51' FROM public.courses WHERE name = 'Netro PreFlow (Úterý)' LIMIT 1
ON CONFLICT (course_id, kid_id) DO NOTHING;


-- 4. Tigran Rider (Netro PreFlow (Úterý)) -> PIN: 79436
INSERT INTO public.profiles (id, role, first_name, last_name, flowcoins_balance, pin_code)
VALUES ('ebb0b64e-767e-4325-854f-f07f0a32041f', 'kid', 'Tigran', 'Rider', 0, '79436')
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.enrollments (course_id, kid_id)
SELECT id, 'ebb0b64e-767e-4325-854f-f07f0a32041f' FROM public.courses WHERE name = 'Netro PreFlow (Úterý)' LIMIT 1
ON CONFLICT (course_id, kid_id) DO NOTHING;


-- 5. Theodor Rider (Netro PreFlow (Úterý)) -> PIN: 31057
INSERT INTO public.profiles (id, role, first_name, last_name, flowcoins_balance, pin_code)
VALUES ('81e4f50e-bdba-445d-9d18-d3c7c7401066', 'kid', 'Theodor', 'Rider', 0, '31057')
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.enrollments (course_id, kid_id)
SELECT id, '81e4f50e-bdba-445d-9d18-d3c7c7401066' FROM public.courses WHERE name = 'Netro PreFlow (Úterý)' LIMIT 1
ON CONFLICT (course_id, kid_id) DO NOTHING;


-- 6. Richard M. (Netro PreFlow (Úterý)) -> PIN: 61401
INSERT INTO public.profiles (id, role, first_name, last_name, flowcoins_balance, pin_code)
VALUES ('c12552a8-31b0-4e58-8270-f00d7f12ce19', 'kid', 'Richard', 'M.', 0, '61401')
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.enrollments (course_id, kid_id)
SELECT id, 'c12552a8-31b0-4e58-8270-f00d7f12ce19' FROM public.courses WHERE name = 'Netro PreFlow (Úterý)' LIMIT 1
ON CONFLICT (course_id, kid_id) DO NOTHING;


-- 7. Eda Rider (Netro PreFlow (Úterý)) -> PIN: 42844
INSERT INTO public.profiles (id, role, first_name, last_name, flowcoins_balance, pin_code)
VALUES ('cb3671c7-59b8-475f-978f-b62eec12d371', 'kid', 'Eda', 'Rider', 0, '42844')
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.enrollments (course_id, kid_id)
SELECT id, 'cb3671c7-59b8-475f-978f-b62eec12d371' FROM public.courses WHERE name = 'Netro PreFlow (Úterý)' LIMIT 1
ON CONFLICT (course_id, kid_id) DO NOTHING;


-- 8. Vilém Rider (Netro PreFlow (Úterý)) -> PIN: 21464
INSERT INTO public.profiles (id, role, first_name, last_name, flowcoins_balance, pin_code)
VALUES ('ffcab751-4866-4a47-a5cf-ab637554459f', 'kid', 'Vilém', 'Rider', 0, '21464')
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.enrollments (course_id, kid_id)
SELECT id, 'ffcab751-4866-4a47-a5cf-ab637554459f' FROM public.courses WHERE name = 'Netro PreFlow (Úterý)' LIMIT 1
ON CONFLICT (course_id, kid_id) DO NOTHING;


-- 9. Vašek Rider (Netro PreFlow (Úterý)) -> PIN: 23065
INSERT INTO public.profiles (id, role, first_name, last_name, flowcoins_balance, pin_code)
VALUES ('97117761-c58f-4871-9b5f-99f41979638e', 'kid', 'Vašek', 'Rider', 0, '23065')
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.enrollments (course_id, kid_id)
SELECT id, '97117761-c58f-4871-9b5f-99f41979638e' FROM public.courses WHERE name = 'Netro PreFlow (Úterý)' LIMIT 1
ON CONFLICT (course_id, kid_id) DO NOTHING;


-- 10. Teo Rider (Netro PreFlow (Úterý)) -> PIN: 59409
INSERT INTO public.profiles (id, role, first_name, last_name, flowcoins_balance, pin_code)
VALUES ('6844154d-be9f-4b9b-ae5a-fad4f301c94b', 'kid', 'Teo', 'Rider', 0, '59409')
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.enrollments (course_id, kid_id)
SELECT id, '6844154d-be9f-4b9b-ae5a-fad4f301c94b' FROM public.courses WHERE name = 'Netro PreFlow (Úterý)' LIMIT 1
ON CONFLICT (course_id, kid_id) DO NOTHING;


-- 11. Ragnar Rider (Netro PreFlow (Úterý)) -> PIN: 13143
INSERT INTO public.profiles (id, role, first_name, last_name, flowcoins_balance, pin_code)
VALUES ('8f065ac3-e8d4-4304-874c-e4c1d46156a7', 'kid', 'Ragnar', 'Rider', 0, '13143')
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.enrollments (course_id, kid_id)
SELECT id, '8f065ac3-e8d4-4304-874c-e4c1d46156a7' FROM public.courses WHERE name = 'Netro PreFlow (Úterý)' LIMIT 1
ON CONFLICT (course_id, kid_id) DO NOTHING;


-- 12. Richard T. (Netro PreFlow (Úterý)) -> PIN: 78755
INSERT INTO public.profiles (id, role, first_name, last_name, flowcoins_balance, pin_code)
VALUES ('9a60309b-7593-44b2-991e-96d8907ef4a8', 'kid', 'Richard', 'T.', 0, '78755')
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.enrollments (course_id, kid_id)
SELECT id, '9a60309b-7593-44b2-991e-96d8907ef4a8' FROM public.courses WHERE name = 'Netro PreFlow (Úterý)' LIMIT 1
ON CONFLICT (course_id, kid_id) DO NOTHING;


-- 13. Eda Rider (Netro PreFlow (Úterý)) -> PIN: 78956
INSERT INTO public.profiles (id, role, first_name, last_name, flowcoins_balance, pin_code)
VALUES ('e7261a18-ddfc-4c8d-82b6-7af438398c68', 'kid', 'Eda', 'Rider', 0, '78956')
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.enrollments (course_id, kid_id)
SELECT id, 'e7261a18-ddfc-4c8d-82b6-7af438398c68' FROM public.courses WHERE name = 'Netro PreFlow (Úterý)' LIMIT 1
ON CONFLICT (course_id, kid_id) DO NOTHING;


-- 14. Jirka Rider (Brno Freestyle Academy (Úterý)) -> PIN: 37586
INSERT INTO public.profiles (id, role, first_name, last_name, flowcoins_balance, pin_code)
VALUES ('1b87fdd8-2d70-4c71-b063-8e95d24a88d3', 'kid', 'Jirka', 'Rider', 0, '37586')
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.enrollments (course_id, kid_id)
SELECT id, '1b87fdd8-2d70-4c71-b063-8e95d24a88d3' FROM public.courses WHERE name = 'Brno Freestyle Academy (Úterý)' LIMIT 1
ON CONFLICT (course_id, kid_id) DO NOTHING;


-- 15. Masťa Rider (Brno Freestyle Academy (Úterý)) -> PIN: 92597
INSERT INTO public.profiles (id, role, first_name, last_name, flowcoins_balance, pin_code)
VALUES ('c32d7875-8513-44ec-926e-c66dc3fa9073', 'kid', 'Masťa', 'Rider', 0, '92597')
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.enrollments (course_id, kid_id)
SELECT id, 'c32d7875-8513-44ec-926e-c66dc3fa9073' FROM public.courses WHERE name = 'Brno Freestyle Academy (Úterý)' LIMIT 1
ON CONFLICT (course_id, kid_id) DO NOTHING;


-- 16. Kiki Rider (Brno Freestyle Academy (Úterý)) -> PIN: 87636
INSERT INTO public.profiles (id, role, first_name, last_name, flowcoins_balance, pin_code)
VALUES ('3a6b04ec-1b9a-4612-a7b3-15f29cf66266', 'kid', 'Kiki', 'Rider', 0, '87636')
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.enrollments (course_id, kid_id)
SELECT id, '3a6b04ec-1b9a-4612-a7b3-15f29cf66266' FROM public.courses WHERE name = 'Brno Freestyle Academy (Úterý)' LIMIT 1
ON CONFLICT (course_id, kid_id) DO NOTHING;


-- 17. Jonáš Rider (Brno Freestyle Academy (Úterý)) -> PIN: 50118
INSERT INTO public.profiles (id, role, first_name, last_name, flowcoins_balance, pin_code)
VALUES ('40ff84dc-96be-489b-aa26-7a588ebd85cc', 'kid', 'Jonáš', 'Rider', 0, '50118')
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.enrollments (course_id, kid_id)
SELECT id, '40ff84dc-96be-489b-aa26-7a588ebd85cc' FROM public.courses WHERE name = 'Brno Freestyle Academy (Úterý)' LIMIT 1
ON CONFLICT (course_id, kid_id) DO NOTHING;


-- 18. František Rider (Brno Freestyle Academy (Úterý)) -> PIN: 25807
INSERT INTO public.profiles (id, role, first_name, last_name, flowcoins_balance, pin_code)
VALUES ('533c0639-25cf-4f87-96d4-66c318a8055a', 'kid', 'František', 'Rider', 0, '25807')
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.enrollments (course_id, kid_id)
SELECT id, '533c0639-25cf-4f87-96d4-66c318a8055a' FROM public.courses WHERE name = 'Brno Freestyle Academy (Úterý)' LIMIT 1
ON CONFLICT (course_id, kid_id) DO NOTHING;


-- 19. Dominik Rider (Brno Freestyle Academy (Úterý)) -> PIN: 22309
INSERT INTO public.profiles (id, role, first_name, last_name, flowcoins_balance, pin_code)
VALUES ('202a83f9-4075-446b-a487-2033b3da7c47', 'kid', 'Dominik', 'Rider', 0, '22309')
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.enrollments (course_id, kid_id)
SELECT id, '202a83f9-4075-446b-a487-2033b3da7c47' FROM public.courses WHERE name = 'Brno Freestyle Academy (Úterý)' LIMIT 1
ON CONFLICT (course_id, kid_id) DO NOTHING;


-- 20. Tomáš K. (Brno Freestyle Academy (Úterý)) -> PIN: 39710
INSERT INTO public.profiles (id, role, first_name, last_name, flowcoins_balance, pin_code)
VALUES ('8443510f-208b-476c-bd81-8b770b22ae35', 'kid', 'Tomáš', 'K.', 0, '39710')
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.enrollments (course_id, kid_id)
SELECT id, '8443510f-208b-476c-bd81-8b770b22ae35' FROM public.courses WHERE name = 'Brno Freestyle Academy (Úterý)' LIMIT 1
ON CONFLICT (course_id, kid_id) DO NOTHING;


-- 21. David Rider (Brno Freestyle Academy (Úterý)) -> PIN: 97215
INSERT INTO public.profiles (id, role, first_name, last_name, flowcoins_balance, pin_code)
VALUES ('59fc4e87-dfee-475a-b550-5369afda6e09', 'kid', 'David', 'Rider', 0, '97215')
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.enrollments (course_id, kid_id)
SELECT id, '59fc4e87-dfee-475a-b550-5369afda6e09' FROM public.courses WHERE name = 'Brno Freestyle Academy (Úterý)' LIMIT 1
ON CONFLICT (course_id, kid_id) DO NOTHING;


-- 22. Tomáš H. (Brno Freestyle Academy (Úterý)) -> PIN: 31778
INSERT INTO public.profiles (id, role, first_name, last_name, flowcoins_balance, pin_code)
VALUES ('147d9924-8b38-469c-9b94-70ed96e1dac3', 'kid', 'Tomáš', 'H.', 0, '31778')
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.enrollments (course_id, kid_id)
SELECT id, '147d9924-8b38-469c-9b94-70ed96e1dac3' FROM public.courses WHERE name = 'Brno Freestyle Academy (Úterý)' LIMIT 1
ON CONFLICT (course_id, kid_id) DO NOTHING;


-- 23. Tomáš M. (Brno Freestyle Academy (Úterý)) -> PIN: 76395
INSERT INTO public.profiles (id, role, first_name, last_name, flowcoins_balance, pin_code)
VALUES ('baffe3e9-e4d5-4bc7-b3e2-9399a45bb3a3', 'kid', 'Tomáš', 'M.', 0, '76395')
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.enrollments (course_id, kid_id)
SELECT id, 'baffe3e9-e4d5-4bc7-b3e2-9399a45bb3a3' FROM public.courses WHERE name = 'Brno Freestyle Academy (Úterý)' LIMIT 1
ON CONFLICT (course_id, kid_id) DO NOTHING;


-- 24. Kuba S. (Brno Freestyle Academy (Úterý)) -> PIN: 88402
INSERT INTO public.profiles (id, role, first_name, last_name, flowcoins_balance, pin_code)
VALUES ('99e56768-e8f0-40ea-8849-b50394ab5045', 'kid', 'Kuba', 'S.', 0, '88402')
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.enrollments (course_id, kid_id)
SELECT id, '99e56768-e8f0-40ea-8849-b50394ab5045' FROM public.courses WHERE name = 'Brno Freestyle Academy (Úterý)' LIMIT 1
ON CONFLICT (course_id, kid_id) DO NOTHING;


-- 25. Tomáš P. (Brno Freestyle Academy (Úterý)) -> PIN: 78462
INSERT INTO public.profiles (id, role, first_name, last_name, flowcoins_balance, pin_code)
VALUES ('3089691c-eb47-4b5e-b80d-371a27331f7e', 'kid', 'Tomáš', 'P.', 0, '78462')
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.enrollments (course_id, kid_id)
SELECT id, '3089691c-eb47-4b5e-b80d-371a27331f7e' FROM public.courses WHERE name = 'Brno Freestyle Academy (Úterý)' LIMIT 1
ON CONFLICT (course_id, kid_id) DO NOTHING;


-- 26. Vojta Rider (Netro Shred (Středa)) -> PIN: 18753
INSERT INTO public.profiles (id, role, first_name, last_name, flowcoins_balance, pin_code)
VALUES ('9bd48556-5537-4880-ac7a-4420a4f135d9', 'kid', 'Vojta', 'Rider', 0, '18753')
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.enrollments (course_id, kid_id)
SELECT id, '9bd48556-5537-4880-ac7a-4420a4f135d9' FROM public.courses WHERE name = 'Netro Shred (Středa)' LIMIT 1
ON CONFLICT (course_id, kid_id) DO NOTHING;


-- 27. Dan Rider (Netro Shred (Středa)) -> PIN: 50412
INSERT INTO public.profiles (id, role, first_name, last_name, flowcoins_balance, pin_code)
VALUES ('fd19802a-942e-4991-b659-dcdc45b3b0ca', 'kid', 'Dan', 'Rider', 0, '50412')
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.enrollments (course_id, kid_id)
SELECT id, 'fd19802a-942e-4991-b659-dcdc45b3b0ca' FROM public.courses WHERE name = 'Netro Shred (Středa)' LIMIT 1
ON CONFLICT (course_id, kid_id) DO NOTHING;


-- 28. Matěj B. (Netro Shred (Středa)) -> PIN: 21760
INSERT INTO public.profiles (id, role, first_name, last_name, flowcoins_balance, pin_code)
VALUES ('fffcf6d5-a337-46ef-8fce-74d80ea792be', 'kid', 'Matěj', 'B.', 0, '21760')
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.enrollments (course_id, kid_id)
SELECT id, 'fffcf6d5-a337-46ef-8fce-74d80ea792be' FROM public.courses WHERE name = 'Netro Shred (Středa)' LIMIT 1
ON CONFLICT (course_id, kid_id) DO NOTHING;


-- 29. Kryštof Rider (Netro Shred (Středa)) -> PIN: 16669
INSERT INTO public.profiles (id, role, first_name, last_name, flowcoins_balance, pin_code)
VALUES ('92a32c48-58dd-4726-a803-8e1de242d18b', 'kid', 'Kryštof', 'Rider', 0, '16669')
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.enrollments (course_id, kid_id)
SELECT id, '92a32c48-58dd-4726-a803-8e1de242d18b' FROM public.courses WHERE name = 'Netro Shred (Středa)' LIMIT 1
ON CONFLICT (course_id, kid_id) DO NOTHING;


-- 30. Jakub K. (Netro Shred (Středa)) -> PIN: 66043
INSERT INTO public.profiles (id, role, first_name, last_name, flowcoins_balance, pin_code)
VALUES ('962d274b-3931-43cd-bc9b-a3e7285a1c75', 'kid', 'Jakub', 'K.', 0, '66043')
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.enrollments (course_id, kid_id)
SELECT id, '962d274b-3931-43cd-bc9b-a3e7285a1c75' FROM public.courses WHERE name = 'Netro Shred (Středa)' LIMIT 1
ON CONFLICT (course_id, kid_id) DO NOTHING;


-- 31. Matěj K. (Netro Shred (Středa)) -> PIN: 32998
INSERT INTO public.profiles (id, role, first_name, last_name, flowcoins_balance, pin_code)
VALUES ('7e2d1d96-bc35-4f7b-ae36-59ea87be1054', 'kid', 'Matěj', 'K.', 0, '32998')
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.enrollments (course_id, kid_id)
SELECT id, '7e2d1d96-bc35-4f7b-ae36-59ea87be1054' FROM public.courses WHERE name = 'Netro Shred (Středa)' LIMIT 1
ON CONFLICT (course_id, kid_id) DO NOTHING;


-- 32. Samuel Rider (Netro Shred (Středa)) -> PIN: 49228
INSERT INTO public.profiles (id, role, first_name, last_name, flowcoins_balance, pin_code)
VALUES ('e962caea-be46-46b6-9837-aaae8abd1dec', 'kid', 'Samuel', 'Rider', 0, '49228')
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.enrollments (course_id, kid_id)
SELECT id, 'e962caea-be46-46b6-9837-aaae8abd1dec' FROM public.courses WHERE name = 'Netro Shred (Středa)' LIMIT 1
ON CONFLICT (course_id, kid_id) DO NOTHING;


-- 33. Patrik Rider (Netro Shred (Středa)) -> PIN: 54129
INSERT INTO public.profiles (id, role, first_name, last_name, flowcoins_balance, pin_code)
VALUES ('e0f4b44e-4a45-41de-828a-3bbb16675b06', 'kid', 'Patrik', 'Rider', 0, '54129')
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.enrollments (course_id, kid_id)
SELECT id, 'e0f4b44e-4a45-41de-828a-3bbb16675b06' FROM public.courses WHERE name = 'Netro Shred (Středa)' LIMIT 1
ON CONFLICT (course_id, kid_id) DO NOTHING;


-- 34. Dan Rider (Netro Shred (Středa)) -> PIN: 13287
INSERT INTO public.profiles (id, role, first_name, last_name, flowcoins_balance, pin_code)
VALUES ('e44b3bb2-7bc7-41e8-b1bf-c09dd9bf9e95', 'kid', 'Dan', 'Rider', 0, '13287')
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.enrollments (course_id, kid_id)
SELECT id, 'e44b3bb2-7bc7-41e8-b1bf-c09dd9bf9e95' FROM public.courses WHERE name = 'Netro Shred (Středa)' LIMIT 1
ON CONFLICT (course_id, kid_id) DO NOTHING;


-- 35. Filip Rider (Netro Shred (Středa)) -> PIN: 12656
INSERT INTO public.profiles (id, role, first_name, last_name, flowcoins_balance, pin_code)
VALUES ('56945ad8-cb21-4d82-a175-aef41256ca53', 'kid', 'Filip', 'Rider', 0, '12656')
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.enrollments (course_id, kid_id)
SELECT id, '56945ad8-cb21-4d82-a175-aef41256ca53' FROM public.courses WHERE name = 'Netro Shred (Středa)' LIMIT 1
ON CONFLICT (course_id, kid_id) DO NOTHING;


-- 36. Štefan Rider (Netro Shred (Středa)) -> PIN: 87480
INSERT INTO public.profiles (id, role, first_name, last_name, flowcoins_balance, pin_code)
VALUES ('be387e72-3791-4e3b-a493-3a1a918505d5', 'kid', 'Štefan', 'Rider', 0, '87480')
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.enrollments (course_id, kid_id)
SELECT id, 'be387e72-3791-4e3b-a493-3a1a918505d5' FROM public.courses WHERE name = 'Netro Shred (Středa)' LIMIT 1
ON CONFLICT (course_id, kid_id) DO NOTHING;


-- 37. David Rider (Netro Shred (Středa)) -> PIN: 77513
INSERT INTO public.profiles (id, role, first_name, last_name, flowcoins_balance, pin_code)
VALUES ('52045962-a25f-4d56-aff4-dd770d85bc56', 'kid', 'David', 'Rider', 0, '77513')
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.enrollments (course_id, kid_id)
SELECT id, '52045962-a25f-4d56-aff4-dd770d85bc56' FROM public.courses WHERE name = 'Netro Shred (Středa)' LIMIT 1
ON CONFLICT (course_id, kid_id) DO NOTHING;


-- 38. Tadeáš Rider (Netro Shred (Středa)) -> PIN: 96708
INSERT INTO public.profiles (id, role, first_name, last_name, flowcoins_balance, pin_code)
VALUES ('22e86c8b-829c-4fa8-91fe-450022b65211', 'kid', 'Tadeáš', 'Rider', 0, '96708')
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.enrollments (course_id, kid_id)
SELECT id, '22e86c8b-829c-4fa8-91fe-450022b65211' FROM public.courses WHERE name = 'Netro Shred (Středa)' LIMIT 1
ON CONFLICT (course_id, kid_id) DO NOTHING;


-- 39. Prokop Rider (Netro Shred (Středa)) -> PIN: 12252
INSERT INTO public.profiles (id, role, first_name, last_name, flowcoins_balance, pin_code)
VALUES ('746a25a4-bde2-4978-8483-a134dc079cf7', 'kid', 'Prokop', 'Rider', 0, '12252')
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.enrollments (course_id, kid_id)
SELECT id, '746a25a4-bde2-4978-8483-a134dc079cf7' FROM public.courses WHERE name = 'Netro Shred (Středa)' LIMIT 1
ON CONFLICT (course_id, kid_id) DO NOTHING;


-- 40. Edward Rider (Netro Shred (Středa)) -> PIN: 81619
INSERT INTO public.profiles (id, role, first_name, last_name, flowcoins_balance, pin_code)
VALUES ('f964c9cd-c7ec-4394-9f28-1587d440a0e5', 'kid', 'Edward', 'Rider', 0, '81619')
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.enrollments (course_id, kid_id)
SELECT id, 'f964c9cd-c7ec-4394-9f28-1587d440a0e5' FROM public.courses WHERE name = 'Netro Shred (Středa)' LIMIT 1
ON CONFLICT (course_id, kid_id) DO NOTHING;


-- 41. Marek Rider (Mariánské PreFlow/Flow (Čtvrtek)) -> PIN: 77921
INSERT INTO public.profiles (id, role, first_name, last_name, flowcoins_balance, pin_code)
VALUES ('60e2bbd9-89de-4a9a-88b4-c95d6062e0bf', 'kid', 'Marek', 'Rider', 0, '77921')
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.enrollments (course_id, kid_id)
SELECT id, '60e2bbd9-89de-4a9a-88b4-c95d6062e0bf' FROM public.courses WHERE name = 'Mariánské PreFlow/Flow (Čtvrtek)' LIMIT 1
ON CONFLICT (course_id, kid_id) DO NOTHING;


-- 42. Miroslav Rider (Mariánské PreFlow/Flow (Čtvrtek)) -> PIN: 32445
INSERT INTO public.profiles (id, role, first_name, last_name, flowcoins_balance, pin_code)
VALUES ('5105f28b-be71-4c57-91eb-e02cf269f31a', 'kid', 'Miroslav', 'Rider', 0, '32445')
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.enrollments (course_id, kid_id)
SELECT id, '5105f28b-be71-4c57-91eb-e02cf269f31a' FROM public.courses WHERE name = 'Mariánské PreFlow/Flow (Čtvrtek)' LIMIT 1
ON CONFLICT (course_id, kid_id) DO NOTHING;


-- 43. Mikuláš Rider (Mariánské PreFlow/Flow (Čtvrtek)) -> PIN: 91620
INSERT INTO public.profiles (id, role, first_name, last_name, flowcoins_balance, pin_code)
VALUES ('973ca019-4a0c-45c0-bf63-dd9ac085eae5', 'kid', 'Mikuláš', 'Rider', 0, '91620')
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.enrollments (course_id, kid_id)
SELECT id, '973ca019-4a0c-45c0-bf63-dd9ac085eae5' FROM public.courses WHERE name = 'Mariánské PreFlow/Flow (Čtvrtek)' LIMIT 1
ON CONFLICT (course_id, kid_id) DO NOTHING;


-- 44. Lukáš D. (Mariánské PreFlow/Flow (Čtvrtek)) -> PIN: 53070
INSERT INTO public.profiles (id, role, first_name, last_name, flowcoins_balance, pin_code)
VALUES ('84046e4a-0965-44a0-89e7-280130c37939', 'kid', 'Lukáš', 'D.', 0, '53070')
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.enrollments (course_id, kid_id)
SELECT id, '84046e4a-0965-44a0-89e7-280130c37939' FROM public.courses WHERE name = 'Mariánské PreFlow/Flow (Čtvrtek)' LIMIT 1
ON CONFLICT (course_id, kid_id) DO NOTHING;


-- 45. Lukáš L. (Mariánské PreFlow/Flow (Čtvrtek)) -> PIN: 72449
INSERT INTO public.profiles (id, role, first_name, last_name, flowcoins_balance, pin_code)
VALUES ('4eda00ec-cb6b-45a1-b28f-84d524ab9231', 'kid', 'Lukáš', 'L.', 0, '72449')
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.enrollments (course_id, kid_id)
SELECT id, '4eda00ec-cb6b-45a1-b28f-84d524ab9231' FROM public.courses WHERE name = 'Mariánské PreFlow/Flow (Čtvrtek)' LIMIT 1
ON CONFLICT (course_id, kid_id) DO NOTHING;


-- 46. Anna Rider (Mariánské PreFlow/Flow (Čtvrtek)) -> PIN: 27858
INSERT INTO public.profiles (id, role, first_name, last_name, flowcoins_balance, pin_code)
VALUES ('6a997d24-fe75-4ae2-bd53-4fae8711e279', 'kid', 'Anna', 'Rider', 0, '27858')
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.enrollments (course_id, kid_id)
SELECT id, '6a997d24-fe75-4ae2-bd53-4fae8711e279' FROM public.courses WHERE name = 'Mariánské PreFlow/Flow (Čtvrtek)' LIMIT 1
ON CONFLICT (course_id, kid_id) DO NOTHING;


-- 47. Vít Rider (Mariánské PreFlow/Flow (Čtvrtek)) -> PIN: 78981
INSERT INTO public.profiles (id, role, first_name, last_name, flowcoins_balance, pin_code)
VALUES ('bcbf209a-01ea-4552-bd60-0eab6de8f307', 'kid', 'Vít', 'Rider', 0, '78981')
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.enrollments (course_id, kid_id)
SELECT id, 'bcbf209a-01ea-4552-bd60-0eab6de8f307' FROM public.courses WHERE name = 'Mariánské PreFlow/Flow (Čtvrtek)' LIMIT 1
ON CONFLICT (course_id, kid_id) DO NOTHING;


-- 48. Libor Rider (Mariánské PreFlow/Flow (Čtvrtek)) -> PIN: 15028
INSERT INTO public.profiles (id, role, first_name, last_name, flowcoins_balance, pin_code)
VALUES ('d4ed4f4b-048e-448a-91ac-419e7601bfb5', 'kid', 'Libor', 'Rider', 0, '15028')
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.enrollments (course_id, kid_id)
SELECT id, 'd4ed4f4b-048e-448a-91ac-419e7601bfb5' FROM public.courses WHERE name = 'Mariánské PreFlow/Flow (Čtvrtek)' LIMIT 1
ON CONFLICT (course_id, kid_id) DO NOTHING;


-- 49. Charis Rider (Mariánské PreFlow/Flow (Čtvrtek)) -> PIN: 58465
INSERT INTO public.profiles (id, role, first_name, last_name, flowcoins_balance, pin_code)
VALUES ('e0e1d39a-2975-4a34-ae9a-071b38c4c155', 'kid', 'Charis', 'Rider', 0, '58465')
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.enrollments (course_id, kid_id)
SELECT id, 'e0e1d39a-2975-4a34-ae9a-071b38c4c155' FROM public.courses WHERE name = 'Mariánské PreFlow/Flow (Čtvrtek)' LIMIT 1
ON CONFLICT (course_id, kid_id) DO NOTHING;


-- 50. Samuel Rider (Mariánské PreFlow/Flow (Čtvrtek)) -> PIN: 35024
INSERT INTO public.profiles (id, role, first_name, last_name, flowcoins_balance, pin_code)
VALUES ('3208c40e-5a69-4e03-9a78-8041e4d8e31b', 'kid', 'Samuel', 'Rider', 0, '35024')
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.enrollments (course_id, kid_id)
SELECT id, '3208c40e-5a69-4e03-9a78-8041e4d8e31b' FROM public.courses WHERE name = 'Mariánské PreFlow/Flow (Čtvrtek)' LIMIT 1
ON CONFLICT (course_id, kid_id) DO NOTHING;


-- 51. Lucas Rider (Mariánské PreFlow/Flow (Čtvrtek)) -> PIN: 35321
INSERT INTO public.profiles (id, role, first_name, last_name, flowcoins_balance, pin_code)
VALUES ('52e5a6cf-aa10-4f86-af24-b2a2f75837e5', 'kid', 'Lucas', 'Rider', 0, '35321')
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.enrollments (course_id, kid_id)
SELECT id, '52e5a6cf-aa10-4f86-af24-b2a2f75837e5' FROM public.courses WHERE name = 'Mariánské PreFlow/Flow (Čtvrtek)' LIMIT 1
ON CONFLICT (course_id, kid_id) DO NOTHING;


-- 52. Zuzka Rider (Mariánské PreFlow/Flow (Čtvrtek)) -> PIN: 64806
INSERT INTO public.profiles (id, role, first_name, last_name, flowcoins_balance, pin_code)
VALUES ('cf358eb4-5820-4862-a612-800f176f14f7', 'kid', 'Zuzka', 'Rider', 0, '64806')
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.enrollments (course_id, kid_id)
SELECT id, 'cf358eb4-5820-4862-a612-800f176f14f7' FROM public.courses WHERE name = 'Mariánské PreFlow/Flow (Čtvrtek)' LIMIT 1
ON CONFLICT (course_id, kid_id) DO NOTHING;


-- 53. Niki Rider (Mariánské PreFlow/Flow (Čtvrtek)) -> PIN: 46543
INSERT INTO public.profiles (id, role, first_name, last_name, flowcoins_balance, pin_code)
VALUES ('94f76898-447c-4279-8c58-e6dc57d3bfa9', 'kid', 'Niki', 'Rider', 0, '46543')
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.enrollments (course_id, kid_id)
SELECT id, '94f76898-447c-4279-8c58-e6dc57d3bfa9' FROM public.courses WHERE name = 'Mariánské PreFlow/Flow (Čtvrtek)' LIMIT 1
ON CONFLICT (course_id, kid_id) DO NOTHING;


-- 54. Otakar Rider (Mariánské PreFlow/Flow (Čtvrtek)) -> PIN: 77425
INSERT INTO public.profiles (id, role, first_name, last_name, flowcoins_balance, pin_code)
VALUES ('a1d50f92-506a-4a51-980c-f40b6d12bf26', 'kid', 'Otakar', 'Rider', 0, '77425')
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.enrollments (course_id, kid_id)
SELECT id, 'a1d50f92-506a-4a51-980c-f40b6d12bf26' FROM public.courses WHERE name = 'Mariánské PreFlow/Flow (Čtvrtek)' LIMIT 1
ON CONFLICT (course_id, kid_id) DO NOTHING;


-- 55. Kája Rider (Mariánské PreFlow/Flow (Čtvrtek)) -> PIN: 93430
INSERT INTO public.profiles (id, role, first_name, last_name, flowcoins_balance, pin_code)
VALUES ('12bc7f78-73cb-4ae6-8794-3f298b207868', 'kid', 'Kája', 'Rider', 0, '93430')
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.enrollments (course_id, kid_id)
SELECT id, '12bc7f78-73cb-4ae6-8794-3f298b207868' FROM public.courses WHERE name = 'Mariánské PreFlow/Flow (Čtvrtek)' LIMIT 1
ON CONFLICT (course_id, kid_id) DO NOTHING;


-- 56. Tonda Rider (Mariánské PreFlow/Flow (Čtvrtek)) -> PIN: 17639
INSERT INTO public.profiles (id, role, first_name, last_name, flowcoins_balance, pin_code)
VALUES ('95681a69-6dbd-4bdc-a320-55bbc9d2c475', 'kid', 'Tonda', 'Rider', 0, '17639')
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.enrollments (course_id, kid_id)
SELECT id, '95681a69-6dbd-4bdc-a320-55bbc9d2c475' FROM public.courses WHERE name = 'Mariánské PreFlow/Flow (Čtvrtek)' LIMIT 1
ON CONFLICT (course_id, kid_id) DO NOTHING;


-- 57. Matěj Rider (Mariánské PreFlow/Flow (Čtvrtek)) -> PIN: 91033
INSERT INTO public.profiles (id, role, first_name, last_name, flowcoins_balance, pin_code)
VALUES ('97a24d5f-e4f5-4c2a-aeb2-9c3e08c1bae9', 'kid', 'Matěj', 'Rider', 0, '91033')
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.enrollments (course_id, kid_id)
SELECT id, '97a24d5f-e4f5-4c2a-aeb2-9c3e08c1bae9' FROM public.courses WHERE name = 'Mariánské PreFlow/Flow (Čtvrtek)' LIMIT 1
ON CONFLICT (course_id, kid_id) DO NOTHING;


-- 58. Filip Rider (Mariánské PreFlow/Flow (Čtvrtek)) -> PIN: 41647
INSERT INTO public.profiles (id, role, first_name, last_name, flowcoins_balance, pin_code)
VALUES ('7941c05f-2774-49ee-813c-925f50105b02', 'kid', 'Filip', 'Rider', 0, '41647')
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.enrollments (course_id, kid_id)
SELECT id, '7941c05f-2774-49ee-813c-925f50105b02' FROM public.courses WHERE name = 'Mariánské PreFlow/Flow (Čtvrtek)' LIMIT 1
ON CONFLICT (course_id, kid_id) DO NOTHING;


-- 59. Ondřej Rider (Mariánské PreFlow/Flow (Čtvrtek)) -> PIN: 32898
INSERT INTO public.profiles (id, role, first_name, last_name, flowcoins_balance, pin_code)
VALUES ('aa47afb2-0640-44f1-a996-b0f49012fe60', 'kid', 'Ondřej', 'Rider', 0, '32898')
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.enrollments (course_id, kid_id)
SELECT id, 'aa47afb2-0640-44f1-a996-b0f49012fe60' FROM public.courses WHERE name = 'Mariánské PreFlow/Flow (Čtvrtek)' LIMIT 1
ON CONFLICT (course_id, kid_id) DO NOTHING;


-- 60. Matěj Rider (Mariánské PreFlow/Flow (Čtvrtek)) -> PIN: 96753
INSERT INTO public.profiles (id, role, first_name, last_name, flowcoins_balance, pin_code)
VALUES ('0470a7b7-a178-40be-9525-17c802528a1c', 'kid', 'Matěj', 'Rider', 0, '96753')
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.enrollments (course_id, kid_id)
SELECT id, '0470a7b7-a178-40be-9525-17c802528a1c' FROM public.courses WHERE name = 'Mariánské PreFlow/Flow (Čtvrtek)' LIMIT 1
ON CONFLICT (course_id, kid_id) DO NOTHING;


-- 61. Petr Rider (Brno Freestyle Academy (Čtvrtek)) -> PIN: 57378
INSERT INTO public.profiles (id, role, first_name, last_name, flowcoins_balance, pin_code)
VALUES ('eb90b8b3-5c52-4546-9ce0-e605efea3617', 'kid', 'Petr', 'Rider', 0, '57378')
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.enrollments (course_id, kid_id)
SELECT id, 'eb90b8b3-5c52-4546-9ce0-e605efea3617' FROM public.courses WHERE name = 'Brno Freestyle Academy (Čtvrtek)' LIMIT 1
ON CONFLICT (course_id, kid_id) DO NOTHING;


-- 62. Filip V. (Brno Freestyle Academy (Čtvrtek)) -> PIN: 98306
INSERT INTO public.profiles (id, role, first_name, last_name, flowcoins_balance, pin_code)
VALUES ('09373895-b4f8-4dfc-9295-8ed3e80f7ef5', 'kid', 'Filip', 'V.', 0, '98306')
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.enrollments (course_id, kid_id)
SELECT id, '09373895-b4f8-4dfc-9295-8ed3e80f7ef5' FROM public.courses WHERE name = 'Brno Freestyle Academy (Čtvrtek)' LIMIT 1
ON CONFLICT (course_id, kid_id) DO NOTHING;


-- 63. Daniel Rider (Brno Freestyle Academy (Čtvrtek)) -> PIN: 86619
INSERT INTO public.profiles (id, role, first_name, last_name, flowcoins_balance, pin_code)
VALUES ('cf69ac70-012e-4f52-8620-6fa5270ae6ec', 'kid', 'Daniel', 'Rider', 0, '86619')
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.enrollments (course_id, kid_id)
SELECT id, 'cf69ac70-012e-4f52-8620-6fa5270ae6ec' FROM public.courses WHERE name = 'Brno Freestyle Academy (Čtvrtek)' LIMIT 1
ON CONFLICT (course_id, kid_id) DO NOTHING;


-- 64. Kuba Rider (Brno Freestyle Academy (Čtvrtek)) -> PIN: 71577
INSERT INTO public.profiles (id, role, first_name, last_name, flowcoins_balance, pin_code)
VALUES ('52ee34f7-c6f1-4965-aec0-35fd363677a1', 'kid', 'Kuba', 'Rider', 0, '71577')
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.enrollments (course_id, kid_id)
SELECT id, '52ee34f7-c6f1-4965-aec0-35fd363677a1' FROM public.courses WHERE name = 'Brno Freestyle Academy (Čtvrtek)' LIMIT 1
ON CONFLICT (course_id, kid_id) DO NOTHING;


-- 65. Pavel Rider (Brno Freestyle Academy (Čtvrtek)) -> PIN: 35035
INSERT INTO public.profiles (id, role, first_name, last_name, flowcoins_balance, pin_code)
VALUES ('87322e65-ccee-44fe-87fb-fbfb1ed6ecab', 'kid', 'Pavel', 'Rider', 0, '35035')
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.enrollments (course_id, kid_id)
SELECT id, '87322e65-ccee-44fe-87fb-fbfb1ed6ecab' FROM public.courses WHERE name = 'Brno Freestyle Academy (Čtvrtek)' LIMIT 1
ON CONFLICT (course_id, kid_id) DO NOTHING;


-- 66. Olda Rider (Brno Freestyle Academy (Čtvrtek)) -> PIN: 50264
INSERT INTO public.profiles (id, role, first_name, last_name, flowcoins_balance, pin_code)
VALUES ('020b80c3-f87b-484a-967c-29881a987c58', 'kid', 'Olda', 'Rider', 0, '50264')
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.enrollments (course_id, kid_id)
SELECT id, '020b80c3-f87b-484a-967c-29881a987c58' FROM public.courses WHERE name = 'Brno Freestyle Academy (Čtvrtek)' LIMIT 1
ON CONFLICT (course_id, kid_id) DO NOTHING;


-- 67. Martin Rider (Brno Freestyle Academy (Čtvrtek)) -> PIN: 14242
INSERT INTO public.profiles (id, role, first_name, last_name, flowcoins_balance, pin_code)
VALUES ('75c3fc12-e9e2-4630-b4c8-fbe6d087d730', 'kid', 'Martin', 'Rider', 0, '14242')
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.enrollments (course_id, kid_id)
SELECT id, '75c3fc12-e9e2-4630-b4c8-fbe6d087d730' FROM public.courses WHERE name = 'Brno Freestyle Academy (Čtvrtek)' LIMIT 1
ON CONFLICT (course_id, kid_id) DO NOTHING;


-- 68. Filip Š. (Brno Freestyle Academy (Čtvrtek)) -> PIN: 87344
INSERT INTO public.profiles (id, role, first_name, last_name, flowcoins_balance, pin_code)
VALUES ('c523e1cd-57af-458f-8ebd-af65a8c84ef4', 'kid', 'Filip', 'Š.', 0, '87344')
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.enrollments (course_id, kid_id)
SELECT id, 'c523e1cd-57af-458f-8ebd-af65a8c84ef4' FROM public.courses WHERE name = 'Brno Freestyle Academy (Čtvrtek)' LIMIT 1
ON CONFLICT (course_id, kid_id) DO NOTHING;


-- 69. Emma Rider (Jedovnice PreFlow/Flow (Pondělí)) -> PIN: 14638
INSERT INTO public.profiles (id, role, first_name, last_name, flowcoins_balance, pin_code)
VALUES ('1aba71ae-f20c-4855-a5be-fba417b3c2c2', 'kid', 'Emma', 'Rider', 0, '14638')
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.enrollments (course_id, kid_id)
SELECT id, '1aba71ae-f20c-4855-a5be-fba417b3c2c2' FROM public.courses WHERE name = 'Jedovnice PreFlow/Flow (Pondělí)' LIMIT 1
ON CONFLICT (course_id, kid_id) DO NOTHING;


-- 70. Maty Rider (Jedovnice PreFlow/Flow (Pondělí)) -> PIN: 92974
INSERT INTO public.profiles (id, role, first_name, last_name, flowcoins_balance, pin_code)
VALUES ('5506b62c-7d93-47dc-abde-cfe651a8ff9a', 'kid', 'Maty', 'Rider', 0, '92974')
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.enrollments (course_id, kid_id)
SELECT id, '5506b62c-7d93-47dc-abde-cfe651a8ff9a' FROM public.courses WHERE name = 'Jedovnice PreFlow/Flow (Pondělí)' LIMIT 1
ON CONFLICT (course_id, kid_id) DO NOTHING;


-- 71. Dominik Rider (Jedovnice PreFlow/Flow (Pondělí)) -> PIN: 76353
INSERT INTO public.profiles (id, role, first_name, last_name, flowcoins_balance, pin_code)
VALUES ('5889c887-aa23-4405-b7a7-52a347b8b9d5', 'kid', 'Dominik', 'Rider', 0, '76353')
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.enrollments (course_id, kid_id)
SELECT id, '5889c887-aa23-4405-b7a7-52a347b8b9d5' FROM public.courses WHERE name = 'Jedovnice PreFlow/Flow (Pondělí)' LIMIT 1
ON CONFLICT (course_id, kid_id) DO NOTHING;


-- 72. Damián Rider (Jedovnice PreFlow/Flow (Pondělí)) -> PIN: 87190
INSERT INTO public.profiles (id, role, first_name, last_name, flowcoins_balance, pin_code)
VALUES ('aa13e740-96f1-4f29-8941-dc30de12b3f4', 'kid', 'Damián', 'Rider', 0, '87190')
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.enrollments (course_id, kid_id)
SELECT id, 'aa13e740-96f1-4f29-8941-dc30de12b3f4' FROM public.courses WHERE name = 'Jedovnice PreFlow/Flow (Pondělí)' LIMIT 1
ON CONFLICT (course_id, kid_id) DO NOTHING;


-- 73. Albert Rider (Jedovnice PreFlow/Flow (Pondělí)) -> PIN: 34583
INSERT INTO public.profiles (id, role, first_name, last_name, flowcoins_balance, pin_code)
VALUES ('83595eb3-a558-4eca-ab3c-9911a0b9dec8', 'kid', 'Albert', 'Rider', 0, '34583')
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.enrollments (course_id, kid_id)
SELECT id, '83595eb3-a558-4eca-ab3c-9911a0b9dec8' FROM public.courses WHERE name = 'Jedovnice PreFlow/Flow (Pondělí)' LIMIT 1
ON CONFLICT (course_id, kid_id) DO NOTHING;


-- 74. Tomáš Rider (Jedovnice PreFlow/Flow (Pondělí)) -> PIN: 91018
INSERT INTO public.profiles (id, role, first_name, last_name, flowcoins_balance, pin_code)
VALUES ('da72a47d-05bf-460d-93b1-b64aeb1ce2b1', 'kid', 'Tomáš', 'Rider', 0, '91018')
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.enrollments (course_id, kid_id)
SELECT id, 'da72a47d-05bf-460d-93b1-b64aeb1ce2b1' FROM public.courses WHERE name = 'Jedovnice PreFlow/Flow (Pondělí)' LIMIT 1
ON CONFLICT (course_id, kid_id) DO NOTHING;


-- 75. Matěj Rider (Jedovnice PreFlow/Flow (Pondělí)) -> PIN: 43457
INSERT INTO public.profiles (id, role, first_name, last_name, flowcoins_balance, pin_code)
VALUES ('f360c476-3af8-4723-bd2e-738043da157c', 'kid', 'Matěj', 'Rider', 0, '43457')
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.enrollments (course_id, kid_id)
SELECT id, 'f360c476-3af8-4723-bd2e-738043da157c' FROM public.courses WHERE name = 'Jedovnice PreFlow/Flow (Pondělí)' LIMIT 1
ON CONFLICT (course_id, kid_id) DO NOTHING;


-- 76. Matěj Rider (Jedovnice PreFlow/Flow (Pondělí)) -> PIN: 87797
INSERT INTO public.profiles (id, role, first_name, last_name, flowcoins_balance, pin_code)
VALUES ('e176c283-6b6f-49eb-850c-4507a7e5319f', 'kid', 'Matěj', 'Rider', 0, '87797')
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.enrollments (course_id, kid_id)
SELECT id, 'e176c283-6b6f-49eb-850c-4507a7e5319f' FROM public.courses WHERE name = 'Jedovnice PreFlow/Flow (Pondělí)' LIMIT 1
ON CONFLICT (course_id, kid_id) DO NOTHING;


-- 77. Natálie Rider (Jedovnice PreFlow/Flow (Pondělí)) -> PIN: 70012
INSERT INTO public.profiles (id, role, first_name, last_name, flowcoins_balance, pin_code)
VALUES ('f2768c94-cbdd-4510-adf7-321c44924198', 'kid', 'Natálie', 'Rider', 0, '70012')
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.enrollments (course_id, kid_id)
SELECT id, 'f2768c94-cbdd-4510-adf7-321c44924198' FROM public.courses WHERE name = 'Jedovnice PreFlow/Flow (Pondělí)' LIMIT 1
ON CONFLICT (course_id, kid_id) DO NOTHING;


-- 78. Anna Rider (Jedovnice PreFlow/Flow (Pondělí)) -> PIN: 47267
INSERT INTO public.profiles (id, role, first_name, last_name, flowcoins_balance, pin_code)
VALUES ('092e47c9-66e1-4871-b7b5-1692b8accfb3', 'kid', 'Anna', 'Rider', 0, '47267')
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.enrollments (course_id, kid_id)
SELECT id, '092e47c9-66e1-4871-b7b5-1692b8accfb3' FROM public.courses WHERE name = 'Jedovnice PreFlow/Flow (Pondělí)' LIMIT 1
ON CONFLICT (course_id, kid_id) DO NOTHING;


-- 79. Vítek Rider (Jedovnice PreFlow/Flow (Pondělí)) -> PIN: 58830
INSERT INTO public.profiles (id, role, first_name, last_name, flowcoins_balance, pin_code)
VALUES ('4f88df51-2093-4dc4-a810-8e773d5e8a75', 'kid', 'Vítek', 'Rider', 0, '58830')
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.enrollments (course_id, kid_id)
SELECT id, '4f88df51-2093-4dc4-a810-8e773d5e8a75' FROM public.courses WHERE name = 'Jedovnice PreFlow/Flow (Pondělí)' LIMIT 1
ON CONFLICT (course_id, kid_id) DO NOTHING;


-- 80. Petr Rider (Jedovnice PreFlow/Flow (Pondělí)) -> PIN: 34633
INSERT INTO public.profiles (id, role, first_name, last_name, flowcoins_balance, pin_code)
VALUES ('a95365b1-f46a-4fcb-9690-99a45d6a4706', 'kid', 'Petr', 'Rider', 0, '34633')
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.enrollments (course_id, kid_id)
SELECT id, 'a95365b1-f46a-4fcb-9690-99a45d6a4706' FROM public.courses WHERE name = 'Jedovnice PreFlow/Flow (Pondělí)' LIMIT 1
ON CONFLICT (course_id, kid_id) DO NOTHING;


-- 81. Honza Rider (Jedovnice PreFlow/Flow (Pondělí)) -> PIN: 51475
INSERT INTO public.profiles (id, role, first_name, last_name, flowcoins_balance, pin_code)
VALUES ('41be339c-ef6e-49ef-89d1-2fbd1bea481e', 'kid', 'Honza', 'Rider', 0, '51475')
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.enrollments (course_id, kid_id)
SELECT id, '41be339c-ef6e-49ef-89d1-2fbd1bea481e' FROM public.courses WHERE name = 'Jedovnice PreFlow/Flow (Pondělí)' LIMIT 1
ON CONFLICT (course_id, kid_id) DO NOTHING;


-- 82. Šimon Jiří (Netro Shred (Pondělí)) -> PIN: 70142
INSERT INTO public.profiles (id, role, first_name, last_name, flowcoins_balance, pin_code)
VALUES ('671a1e7e-3811-4d3b-a1e8-db59bca64f5d', 'kid', 'Šimon', 'Jiří', 0, '70142')
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.enrollments (course_id, kid_id)
SELECT id, '671a1e7e-3811-4d3b-a1e8-db59bca64f5d' FROM public.courses WHERE name = 'Netro Shred (Pondělí)' LIMIT 1
ON CONFLICT (course_id, kid_id) DO NOTHING;


-- 83. Jonáš Rider (Netro Shred (Pondělí)) -> PIN: 24472
INSERT INTO public.profiles (id, role, first_name, last_name, flowcoins_balance, pin_code)
VALUES ('5ebf6dcd-7c4a-4b28-9daa-e8d35a9e096f', 'kid', 'Jonáš', 'Rider', 0, '24472')
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.enrollments (course_id, kid_id)
SELECT id, '5ebf6dcd-7c4a-4b28-9daa-e8d35a9e096f' FROM public.courses WHERE name = 'Netro Shred (Pondělí)' LIMIT 1
ON CONFLICT (course_id, kid_id) DO NOTHING;


-- 84. Teo Rider (Netro Shred (Pondělí)) -> PIN: 65697
INSERT INTO public.profiles (id, role, first_name, last_name, flowcoins_balance, pin_code)
VALUES ('49171783-87c3-46f3-b193-d2bfe51d55df', 'kid', 'Teo', 'Rider', 0, '65697')
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.enrollments (course_id, kid_id)
SELECT id, '49171783-87c3-46f3-b193-d2bfe51d55df' FROM public.courses WHERE name = 'Netro Shred (Pondělí)' LIMIT 1
ON CONFLICT (course_id, kid_id) DO NOTHING;


-- 85. Jan Rider (Netro Shred (Pondělí)) -> PIN: 85967
INSERT INTO public.profiles (id, role, first_name, last_name, flowcoins_balance, pin_code)
VALUES ('95bf266e-a27e-4dac-a961-ea4c3509c063', 'kid', 'Jan', 'Rider', 0, '85967')
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.enrollments (course_id, kid_id)
SELECT id, '95bf266e-a27e-4dac-a961-ea4c3509c063' FROM public.courses WHERE name = 'Netro Shred (Pondělí)' LIMIT 1
ON CONFLICT (course_id, kid_id) DO NOTHING;


-- 86. Adam Rider (Netro Shred (Pondělí)) -> PIN: 22059
INSERT INTO public.profiles (id, role, first_name, last_name, flowcoins_balance, pin_code)
VALUES ('e99332a9-18b5-44e5-a87f-e40794d51f92', 'kid', 'Adam', 'Rider', 0, '22059')
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.enrollments (course_id, kid_id)
SELECT id, 'e99332a9-18b5-44e5-a87f-e40794d51f92' FROM public.courses WHERE name = 'Netro Shred (Pondělí)' LIMIT 1
ON CONFLICT (course_id, kid_id) DO NOTHING;


-- 87. Mikuláš Rider (Netro Shred (Pondělí)) -> PIN: 62264
INSERT INTO public.profiles (id, role, first_name, last_name, flowcoins_balance, pin_code)
VALUES ('3b2d3a90-7a7e-49dd-8c5e-5a26239a5fbc', 'kid', 'Mikuláš', 'Rider', 0, '62264')
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.enrollments (course_id, kid_id)
SELECT id, '3b2d3a90-7a7e-49dd-8c5e-5a26239a5fbc' FROM public.courses WHERE name = 'Netro Shred (Pondělí)' LIMIT 1
ON CONFLICT (course_id, kid_id) DO NOTHING;


-- 88. Šimon Rider (Netro Shred (Pondělí)) -> PIN: 74584
INSERT INTO public.profiles (id, role, first_name, last_name, flowcoins_balance, pin_code)
VALUES ('79421d85-a20f-4dcc-87b3-9177f5cb59eb', 'kid', 'Šimon', 'Rider', 0, '74584')
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.enrollments (course_id, kid_id)
SELECT id, '79421d85-a20f-4dcc-87b3-9177f5cb59eb' FROM public.courses WHERE name = 'Netro Shred (Pondělí)' LIMIT 1
ON CONFLICT (course_id, kid_id) DO NOTHING;


-- 89. Honza Rider (Netro Shred (Pondělí)) -> PIN: 72023
INSERT INTO public.profiles (id, role, first_name, last_name, flowcoins_balance, pin_code)
VALUES ('a76db2b9-b56c-43a2-9775-596af907cef1', 'kid', 'Honza', 'Rider', 0, '72023')
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.enrollments (course_id, kid_id)
SELECT id, 'a76db2b9-b56c-43a2-9775-596af907cef1' FROM public.courses WHERE name = 'Netro Shred (Pondělí)' LIMIT 1
ON CONFLICT (course_id, kid_id) DO NOTHING;


