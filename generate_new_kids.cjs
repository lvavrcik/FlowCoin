const fs = require('fs');
const crypto = require('crypto');

const data = `Samuel	Netro PreFlow (Úterý)
Jirka	Netro PreFlow (Úterý)
Eduard	Netro PreFlow (Úterý)
Tigran	Netro PreFlow (Úterý)
Theodor	Netro PreFlow (Úterý)
Richard M.	Netro PreFlow (Úterý)
Eda	Netro PreFlow (Úterý)
Vilém	Netro PreFlow (Úterý)
Vašek	Netro PreFlow (Úterý)
Teo	Netro PreFlow (Úterý)
Ragnar	Netro PreFlow (Úterý)
Richard T.	Netro PreFlow (Úterý)
Eda	Netro PreFlow (Úterý)

Jirka	Brno Freestyle Academy (Úterý)
Masťa	Brno Freestyle Academy (Úterý)
Kiki	Brno Freestyle Academy (Úterý)
Jonáš	Brno Freestyle Academy (Úterý)
František	Brno Freestyle Academy (Úterý)
Dominik	Brno Freestyle Academy (Úterý)
Tomáš K.	Brno Freestyle Academy (Úterý)
David	Brno Freestyle Academy (Úterý)
Tomáš H.	Brno Freestyle Academy (Úterý)
Tomáš M.	Brno Freestyle Academy (Úterý)
Kuba S.	Brno Freestyle Academy (Úterý)
Tomáš P.	Brno Freestyle Academy (Úterý)

Vojta	Netro Shred (Středa)
Dan	Netro Shred (Středa)
Matěj B.	Netro Shred (Středa)
Kryštof 	Netro Shred (Středa)
Jakub K.	Netro Shred (Středa)
Matěj K.	Netro Shred (Středa)
Samuel	Netro Shred (Středa)
Patrik	Netro Shred (Středa)
Dan	Netro Shred (Středa)
Filip	Netro Shred (Středa)
Štefan	Netro Shred (Středa)
David	Netro Shred (Středa)
Tadeáš	Netro Shred (Středa)
Prokop	Netro Shred (Středa)
Edward	Netro Shred (Středa)

Marek	Mariánské PreFlow/Flow (Čtvrtek)
Miroslav	Mariánské PreFlow/Flow (Čtvrtek)
Mikuláš	Mariánské PreFlow/Flow (Čtvrtek)
Lukáš D.	Mariánské PreFlow/Flow (Čtvrtek)
Lukáš L.	Mariánské PreFlow/Flow (Čtvrtek)
Anna	Mariánské PreFlow/Flow (Čtvrtek)
Vít	Mariánské PreFlow/Flow (Čtvrtek)
Libor	Mariánské PreFlow/Flow (Čtvrtek)
Charis	Mariánské PreFlow/Flow (Čtvrtek)
Samuel	Mariánské PreFlow/Flow (Čtvrtek)
Lucas	Mariánské PreFlow/Flow (Čtvrtek)
Zuzka	Mariánské PreFlow/Flow (Čtvrtek)
Niki	Mariánské PreFlow/Flow (Čtvrtek)
Otakar	Mariánské PreFlow/Flow (Čtvrtek)
Kája	Mariánské PreFlow/Flow (Čtvrtek)
Tonda	Mariánské PreFlow/Flow (Čtvrtek)
Matěj	Mariánské PreFlow/Flow (Čtvrtek)
Filip	Mariánské PreFlow/Flow (Čtvrtek)
Ondřej	Mariánské PreFlow/Flow (Čtvrtek)
Matěj	Mariánské PreFlow/Flow (Čtvrtek)

Petr	Brno Freestyle Academy (Čtvrtek)
Filip V.	Brno Freestyle Academy (Čtvrtek)
Daniel	Brno Freestyle Academy (Čtvrtek)
Kuba	Brno Freestyle Academy (Čtvrtek)
Pavel	Brno Freestyle Academy (Čtvrtek)
Olda	Brno Freestyle Academy (Čtvrtek)
Martin	Brno Freestyle Academy (Čtvrtek)
Filip Š.	Brno Freestyle Academy (Čtvrtek)

Emma	Jedovnice PreFlow/Flow (Pondělí)
Maty	Jedovnice PreFlow/Flow (Pondělí)
Dominik	Jedovnice PreFlow/Flow (Pondělí)
Damián	Jedovnice PreFlow/Flow (Pondělí)
Albert	Jedovnice PreFlow/Flow (Pondělí)
Tomáš	Jedovnice PreFlow/Flow (Pondělí)
Matěj	Jedovnice PreFlow/Flow (Pondělí)
Matěj	Jedovnice PreFlow/Flow (Pondělí)
Natálie	Jedovnice PreFlow/Flow (Pondělí)
Anna	Jedovnice PreFlow/Flow (Pondělí)
Vítek	Jedovnice PreFlow/Flow (Pondělí)
Petr	Jedovnice PreFlow/Flow (Pondělí)
Honza	Jedovnice PreFlow/Flow (Pondělí)

Šimon Jiří	Netro Shred (Pondělí)
Jonáš 	Netro Shred (Pondělí)
Teo	Netro Shred (Pondělí)
Jan	Netro Shred (Pondělí)
Adam	Netro Shred (Pondělí)
Mikuláš 	Netro Shred (Pondělí)
Šimon	Netro Shred (Pondělí)
Honza	Netro Shred (Pondělí)`;

const lines = data.split('\n').map(l => l.trim()).filter(l => l);

const weakPins = ['00000','11111','22222','33333','44444','55555','66666','77777','88888','99999','12345','54321','12312','67890','09876'];
let usedPins = new Set();
function generatePin() {
    let pin;
    do {
        pin = Math.floor(10000 + Math.random() * 90000).toString();
    } while (weakPins.includes(pin) || usedPins.has(pin));
    usedPins.add(pin);
    return pin;
}

let sql = `-- Script to add kids and enroll them in their courses with generated PINs\n\n`;
let i = 1;

for (const line of lines) {
    const parts = line.split('\t');
    if (parts.length < 2) continue;
    let nameRaw = parts[0].trim();
    let course = parts[1].trim();
    
    // some names are "Richard M.", separate them carefully
    let nameParts = nameRaw.split(' ');
    let firstName = nameParts[0];
    let lastName = nameParts.length > 1 ? nameParts.slice(1).join(' ') : 'Rider'; // default last name if missing
    
    let kidId = crypto.randomUUID();
    let pin = generatePin();
    
    sql += `-- ${i}. ${firstName} ${lastName} (${course}) -> PIN: ${pin}\n`;
    sql += `INSERT INTO public.profiles (id, role, first_name, last_name, flowcoins_balance, pin_code)\n`;
    sql += `VALUES ('${kidId}', 'kid', '${firstName}', '${lastName}', 0, '${pin}')\n`; // Initial balance 0
    sql += `ON CONFLICT (id) DO NOTHING;\n\n`;
    
    sql += `INSERT INTO public.enrollments (course_id, kid_id)\n`;
    sql += `SELECT id, '${kidId}' FROM public.courses WHERE name = '${course}' LIMIT 1\n`;
    sql += `ON CONFLICT (course_id, kid_id) DO NOTHING;\n\n\n`;
    i++;
}

// Check if we need to insert new courses. Since user mentioned "for courses that were empty (Monday ones)"
// Let's also output course insertion if they don't exist.
const uniqueCourses = [...new Set(lines.map(l => l.split('\t')[1].trim()))];
let courseSql = `-- Ensure courses exist. We will just attempt to INSERT them with season_id = active. Assuming there is an active season.\n`;
courseSql += `DO $$\nDECLARE\n  active_season_id UUID;\nBEGIN\n  SELECT id INTO active_season_id FROM public.seasons WHERE is_active = true LIMIT 1;\n`;
courseSql += `  IF active_season_id IS NULL THEN\n    INSERT INTO public.seasons (name, is_active) VALUES ('Jaro 2026', true) RETURNING id INTO active_season_id;\n  END IF;\n\n`;

for (const crs of uniqueCourses) {
    courseSql += `  IF NOT EXISTS (SELECT 1 FROM public.courses WHERE name = '${crs}') THEN\n`;
    courseSql += `    INSERT INTO public.courses (name, season_id)\n`;
    courseSql += `    VALUES ('${crs}', active_season_id);\n`;
    courseSql += `  END IF;\n`;
}
courseSql += `END $$;\n\n`;

sql = courseSql + sql;

fs.writeFileSync('insert_new_kids_batch.sql', sql);
console.log('Done generating insert_new_kids_batch.sql');
