

-- Import data from csv
.mode csv
.import pokemon.csv pokedata

-- Create the a temporary table
CREATE TABLE temp (
    ability VARCHAR(40) NOT NULL, 
    pokedex_number INTEGER DEFAULT NULL,
    FOREIGN KEY (pokedex_number) REFERENCES pokedata(pokedex_number)
);

-- Use recursion to split all lists of abilities into their own row
WITH split(pokedex_number, abilities, nextability) AS (
    SELECT pokedex_number, '' AS abilities, abilities||',' AS nextability
    FROM pokedata
    UNION ALL
        SELECT pokedex_number,
            substr(nextability, 0, instr(nextability, ',')) AS abilities,
            substr(nextability, instr(nextability, ',') + 1) AS nextability
        FROM split
        WHERE nextability !=''
)
-- Put trimmed, unique abilities into temporary table that relates them to pokedex number
INSERT INTO temp(pokedex_number, ability) 
    SELECT DISTINCT pokedex_number, TRIM(TRIM(abilities, ' []'), '''')
    FROM split
    WHERE abilities != ''
    ORDER BY pokedex_number, abilities;

-- Create abilities table
CREATE TABLE abilities (
    ability VARCHAR(40) NOT NULL, 
    pokedex_number INTEGER DEFAULT NULL,
    FOREIGN KEY (pokedex_number) REFERENCES pokedata(pokedex_number)
);

-- Move from temporary to abilities table (fixes weird ordering issue)
INSERT INTO abilities SELECT * FROM temp ORDER BY pokedex_number;

DROP TABLE temp;

-- Create new pokemon table
CREATE TABLE pokemon (
    pokedex_number INTEGER,
    name VARCHAR(40),
    attack INTEGER,
    defense INTEGER,
    hp INTEGER,
    speed INTEGER,
    sp_attack INTEGER,
    sp_defense INTEGER,
    generation INTEGER,
    is_legendary INTEGER,
    weight_kg REAL,
    height_m REAL,
    percentage_male REAL,
    base_egg_steps INTEGER,
    base_happiness INTEGER,
    base_total INTEGER,
    capture_rate INTEGER,
    classification VARCHAR(40),
    experience_growth INTEGER,
    type1 VARCHAR(40),
    type2 VARCHAR(40),
    against_bug REAL,
    against_dark REAL, 
    against_dragon REAL,
    against_electric REAL,
    against_fairy REAL,
    against_fight REAL,
    against_fire REAL,
    against_flying REAL,
    against_ghost REAL,
    against_grass REAL,
    against_ground REAL,
    against_ice REAL,
    against_normal REAL,
    against_poison REAL,
    against_psychic REAL,
    against_rock REAL,
    against_steel REAL,
    against_water REAL,
    ability VARCHAR(40)
    
);
-- Move data over
INSERT INTO pokemon 
    SELECT p.pokedex_number, p.name, p.attack, p.defense, p.hp, 
    p.speed, p.sp_attack, p.sp_defense, p.generation, p.is_legendary,
    p.weight_kg, p.height_m, p.percentage_male, p.base_egg_steps, p.base_happiness,
    p.base_total, p.capture_rate, p.classfication, p.experience_growth, p.type1, p.type2,
    p.against_bug,
    p.against_dark,
    p.against_dragon,
    p.against_electric,
    p.against_fairy,  
    p.against_fight,  
    p.against_fire,  
    p.against_flying,   
    p.against_ghost,    
    p.against_grass,   
    p.against_ground,   
    p.against_ice,  
    p.against_normal,
    p.against_poison,
    p.against_psychic,  
    p.against_rock,    
    p.against_steel,   
    p.against_water,
    abilities.ability

    FROM pokedata AS p
    INNER JOIN abilities ON p.pokedex_number = abilities.pokedex_number;

DROP TABLE abilities;
DROP TABLE pokedata;

