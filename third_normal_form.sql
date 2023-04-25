

-- Create the Type effectiveness table
CREATE TABLE type_effectiveness (
    type1 VARCHAR(40),
    type2 VARCHAR(40) DEFAULT NULL,
    against_type VARCHAR(40),
    effectiveness REAL,
    PRIMARY KEY (type1, type2, against_type)
);

-- Create table to allow a cross join with both pokemon types to get all possible combinations
CREATE TABLE temp (
    type VARCHAR(40)
);
INSERT INTO temp(type) SELECT DISTINCT type1 FROM pokemon;

-- Cross join
INSERT INTO type_effectiveness(type1, type2, against_type) 
    SELECT DISTINCT pokemon.type1 AS a, pokemon.type2 AS b, temp.type AS c
    FROM pokemon
    CROSS JOIN temp 
    ORDER BY c, a, b;

-- Add effectiveness values

UPDATE type_effectiveness
    SET effectiveness = pokemon.against_bug
    FROM pokemon
    WHERE against_type = 'bug' AND
    type_effectiveness.type1 = pokemon.type1 
    AND type_effectiveness.type2 = pokemon.type2;

UPDATE type_effectiveness
    SET effectiveness = pokemon.against_dark
    FROM pokemon
    WHERE against_type = 'dark' AND
    type_effectiveness.type1 = pokemon.type1 
    AND type_effectiveness.type2 = pokemon.type2;

UPDATE type_effectiveness
    SET effectiveness = pokemon.against_dragon
    FROM pokemon
    WHERE against_type = 'dragon' AND
    type_effectiveness.type1 = pokemon.type1 
    AND type_effectiveness.type2 = pokemon.type2;

UPDATE type_effectiveness
    SET effectiveness = pokemon.against_electric
    FROM pokemon
    WHERE against_type = 'electric' AND
    type_effectiveness.type1 = pokemon.type1 
    AND type_effectiveness.type2 = pokemon.type2;

UPDATE type_effectiveness
    SET effectiveness = pokemon.against_fairy
    FROM pokemon
    WHERE against_type = 'fairy' AND
    type_effectiveness.type1 = pokemon.type1 
    AND type_effectiveness.type2 = pokemon.type2;

UPDATE type_effectiveness
    SET effectiveness = pokemon.against_fight
    FROM pokemon
    WHERE against_type = 'fighting' AND
    type_effectiveness.type1 = pokemon.type1 
    AND type_effectiveness.type2 = pokemon.type2;

UPDATE type_effectiveness
    SET effectiveness = pokemon.against_fire
    FROM pokemon
    WHERE against_type = 'fire' AND
    type_effectiveness.type1 = pokemon.type1 
    AND type_effectiveness.type2 = pokemon.type2;

UPDATE type_effectiveness
    SET effectiveness = pokemon.against_flying
    FROM pokemon
    WHERE against_type = 'flying' AND
    type_effectiveness.type1 = pokemon.type1 
    AND type_effectiveness.type2 = pokemon.type2;

UPDATE type_effectiveness
    SET effectiveness = pokemon.against_ghost
    FROM pokemon
    WHERE against_type = 'ghost' AND
    type_effectiveness.type1 = pokemon.type1 
    AND type_effectiveness.type2 = pokemon.type2;

UPDATE type_effectiveness
    SET effectiveness = pokemon.against_grass
    FROM pokemon
    WHERE against_type = 'grass' AND
    type_effectiveness.type1 = pokemon.type1 
    AND type_effectiveness.type2 = pokemon.type2;

UPDATE type_effectiveness
    SET effectiveness = pokemon.against_ground
    FROM pokemon
    WHERE against_type = 'ground' AND
    type_effectiveness.type1 = pokemon.type1 
    AND type_effectiveness.type2 = pokemon.type2;

UPDATE type_effectiveness
    SET effectiveness = pokemon.against_ice
    FROM pokemon
    WHERE against_type = 'ice' AND
    type_effectiveness.type1 = pokemon.type1 
    AND type_effectiveness.type2 = pokemon.type2;

UPDATE type_effectiveness
    SET effectiveness = pokemon.against_normal
    FROM pokemon
    WHERE against_type = 'normal' AND
    type_effectiveness.type1 = pokemon.type1 
    AND type_effectiveness.type2 = pokemon.type2;

UPDATE type_effectiveness
    SET effectiveness = pokemon.against_poison
    FROM pokemon
    WHERE against_type = 'poison' AND
    type_effectiveness.type1 = pokemon.type1 
    AND type_effectiveness.type2 = pokemon.type2;

UPDATE type_effectiveness
    SET effectiveness = pokemon.against_psychic
    FROM pokemon
    WHERE against_type = 'psychic' AND
    type_effectiveness.type1 = pokemon.type1 
    AND type_effectiveness.type2 = pokemon.type2;

UPDATE type_effectiveness
    SET effectiveness = pokemon.against_rock
    FROM pokemon
    WHERE against_type = 'rock' AND
    type_effectiveness.type1 = pokemon.type1 
    AND type_effectiveness.type2 = pokemon.type2;

UPDATE type_effectiveness
    SET effectiveness = pokemon.against_steel
    FROM pokemon
    WHERE against_type = 'steel' AND
    type_effectiveness.type1 = pokemon.type1 
    AND type_effectiveness.type2 = pokemon.type2;

UPDATE type_effectiveness
    SET effectiveness = pokemon.against_water
    FROM pokemon
    WHERE against_type = 'water' AND
    type_effectiveness.type1 = pokemon.type1 
    AND type_effectiveness.type2 = pokemon.type2;

-- Drop temporary tables
DROP TABLE temp;


-- Connect to pokemon through a typing table
CREATE TABLE temp (
    pokedex_number INTEGER,
    type VARCHAR(40),
    FOREIGN KEY (pokedex_number) REFERENCES pokemon(pokedex_number),
    FOREIGN KEY (type) REFERENCES type_effectiveness(type1)
);
-- Grab pokemon and their type 1s
INSERT INTO temp 
    SELECT DISTINCT
        pokemon.pokedex_number AS poke, 
        type_effectiveness.type1 AS ty 
    FROM pokemon
    INNER JOIN type_effectiveness ON pokemon.type1 = ty;

-- Grab pokemon and their type 2s that aren't blank
INSERT INTO temp 
    SELECT DISTINCT
        pokemon.pokedex_number AS poke, 
        type_effectiveness.type2 AS ty 
    FROM pokemon
    INNER JOIN type_effectiveness ON pokemon.type2 = ty WHERE ty IS NOT '';

-- Create final table
CREATE TABLE pokemon_types (
    pokedex_number INTEGER,
    type VARCHAR(40),
    FOREIGN KEY (pokedex_number) REFERENCES pokemon(pokedex_number),
    FOREIGN KEY (type) REFERENCES type_effectiveness(type1)
);

-- Reorder data and insert
INSERT INTO pokemon_types 
    SELECT * FROM temp ORDER BY pokedex_number, type;
DROP TABLE temp;


-- Create new temporary pokemon table
CREATE TABLE pokemon2 (
    pokedex_number INTEGER PRIMARY KEY,
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
    experience_growth INTEGER
);
-- Move data over
INSERT INTO pokemon2 
    SELECT pokedex_number, name, attack, defense, hp, 
    speed, sp_attack, sp_defense, generation, is_legendary,
    weight_kg, height_m, percentage_male, base_egg_steps, base_happiness,
    base_total, capture_rate, classification, experience_growth
    FROM pokemon;

-- Drop old table
DROP TABLE pokemon;

-- The final table!

CREATE TABLE pokemon (
    pokedex_number INTEGER PRIMARY KEY,
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
    experience_growth INTEGER
);

-- Move data over
INSERT INTO pokemon SELECT * FROM pokemon2;

-- Drop temporary table
DROP TABLE pokemon2;
