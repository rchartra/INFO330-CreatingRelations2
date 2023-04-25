-- Add Huskichu data to each table
INSERT INTO pokemon 
    VALUES (802, 'Huskichu', 130, 60, 100, 170, 210, 130, 8, 1, 40.0, 0.5, 50.0, 30720, 100, 700, 5, 'Best Boi Pokemon', 1250000);

INSERT INTO abilities VALUES (802, 'Queenly Majesty'), (802, 'Fluffy');

INSERT INTO pokemon_types VALUES (802, 'mascot');

-- Add Cougarite data to each table

INSERT INTO pokemon
    VALUES (803, 'Cougarite', 0, 30, 90, 60, 0, 50, 8, 0, 60.0, 0.7, 50.0, 8960, 0, 500, 68, 'Sad Pokemon', 800000);

INSERT INTO abilities VALUES (803, 'Slow Attack');

INSERT INTO pokemon_types VALUES (803, 'mascot');

-- Effectiveness value for new pokemon type 'mascot'
INSERT INTO type_effectiveness VALUES 
    ('mascot', '', 'bug', 2.0),
    ('mascot', '', 'dark', 1.0),
    ('mascot', '', 'dragon', 0.5),
    ('mascot', '', 'electric', 1.0),
    ('mascot', '', 'fairy', 1.0),
    ('mascot', '', 'fighting', 0.5),
    ('mascot', '', 'fire', 1.0),
    ('mascot', '', 'flying', 0.5),
    ('mascot', '', 'ghost', 1.0),
    ('mascot', '', 'grass', 1.5),
    ('mascot', '', 'ground', 2.0),
    ('mascot', '', 'ice', 1.0),
    ('mascot', '', 'normal', 1.0),
    ('mascot', '', 'poison', 0.5),
    ('mascot', '', 'psychic', 2.0),
    ('mascot', '', 'rock', 1.0),
    ('mascot', '', 'steel', 1.0),
    ('mascot', '', 'water', 0.5);

-- Effectiveness values against 'mascot'


-- Create table to allow a cross join with both pokemon types to get all possible combinations
CREATE TABLE temp (
    type VARCHAR(40)
);
INSERT INTO temp VALUES ('mascot');

-- Cross join
INSERT INTO type_effectiveness(type1, type2, against_type) 
    SELECT DISTINCT type_effectiveness.type1 AS a, type_effectiveness.type2 AS b, temp.type AS c
    FROM type_effectiveness
    CROSS JOIN temp 
    ORDER BY c, a, b;

DROP TABLE temp;

-- Add effectiveness values

-- Mascots are resistant to damage from all pokemon types!
UPDATE type_effectiveness
    SET effectiveness = 0.5
    WHERE against_type = 'mascot';

-- Create trainer table

CREATE TABLE 
    trainers (
        trainer_id INTEGER PRIMARY KEY, 
        first_name VARCHAR(80), 
        last_name VARCHAR(80)
    );

-- Add trainers

INSERT INTO trainers VALUES 
    (1, 'Robin', 'Chartrand'), 
    (2, 'Ted', 'Neward'), 
    (3, 'Justin', 'Dong'),
    (4, 'Leah', 'Thompson');

-- Create favorite pokemon types

CREATE TABLE
    favorite_pokemon_types (
        trainer_id INTEGER,
        type VARCHAR(40),
        FOREIGN KEY (trainer_id) REFERENCES trainers(trainer_id),
        FOREIGN KEY (type) REFERENCES pokemon_types(type)
    );

-- Add favorite pokemon types

INSERT INTO favorite_pokemon_types VALUES 
    (1, 'ice'), 
    (1, 'dragon'),
    (2, 'water'),
    (2, 'dark'),
    (2, 'fire'),
    (3, 'fairy'),
    (3, 'dragon'),
    (4, 'grass')
    ;

-- Create pokemon teams

CREATE TABLE
    teams (
        trainer_id INTEGER,
        pokedex_number INTEGER,
        FOREIGN KEY (trainer_id) REFERENCES trainers(trainer_id),
        FOREIGN KEY (pokedex_number) REFERENCES pokemon(pokedex_number)
    );

-- Add teams

INSERT INTO teams VALUES
    (1, 150),
    (1, 320),
    (1, 450),
    (1, 802),
    (1, 801),
    (1, 3),
    (2, 12),
    (2, 78),
    (2, 90),
    (2, 540),
    (2, 782),
    (2, 802),
    (2, 621),
    (2, 554),
    (2, 45),
    (2, 429),
    (3, 6),
    (3, 15),
    (3, 450),
    (3, 801),
    (3, 67),
    (3, 765),
    (3, 89),
    (4, 2)
;

