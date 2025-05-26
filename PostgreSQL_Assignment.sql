-- Active: 1747422770417@@127.0.0.1@5432@conservation_db@public

CREATE TABLE rangers(
    ranger_id SERIAL PRIMARY KEY,
    name VARCHAR(20) NOT NULL,
    region VARCHAR(20)
);
CREATE Table species(
    species_id SERIAL PRIMARY KEY,
    common_name VARCHAR(30),
    scientific_name VARCHAR(30),
    discovery_date DATE,
    conservation_status VARCHAR(30)
);
CREATE TABLE sightings(
    sighting_id SERIAL PRIMARY KEY,
    species_id INTEGER REFERENCES species(species_id),
    ranger_id INT REFERENCES rangers(ranger_id),
    location VARCHAR(20),
    sighting_time TIMESTAMP,
    notes TEXT
); 
INSERT INTO rangers (name, region) VALUES
('Alice Green', 'Northern Hills'),
('Bob White', 'River Delta'),
('Carol King', 'Mountain Range');

INSERT INTO species (common_name, scientific_name, discovery_date, conservation_status) VALUES
('Snow Leopard', 'Panthera uncia', '1775-01-01', 'Endangered'),
('Bengal Tiger', 'Panthera tigris tigris', '1758-01-01', 'Endangered'),
('Red Panda', 'Ailurus fulgens', '1825-01-01', 'Vulnerable'),
('Asiatic Elephant', 'Elephas maximus indicus', '1758-01-01', 'Endangered');

INSERT INTO sightings (species_id, ranger_id, location, sighting_time, notes) VALUES
(1, 1, 'Peak Ridge', '2024-05-10 07:45:00', 'Camera trap image captured'),
(2, 2, 'Bankwood Area', '2024-05-12 16:20:00', 'Juvenile seen'),
(3, 3, 'Bamboo Grove East', '2024-05-15 09:10:00', 'Feeding observed'),
(1, 2, 'Snowfall Pass', '2024-05-18 18:30:00', NULL);



-- problem 1
INSERT INTO rangers(name, region) VALUES
('Derek Fox', 'Coastal Plains');

-- problem 2
SELECT count(DISTINCT species_id) AS unique_species_count
FROM sightings;

-- problem 3
SELECT *
FROM sightings
WHERE location LIKE '%Pass';

-- problem 4
SELECT rangers.name, Count(sightings.species_id) as total_sightings 
FROM rangers
LEFT JOIN sightings
    ON rangers.ranger_id = sightings.ranger_id
GROUP BY rangers.ranger_id
ORDER BY rangers.name;

-- problem 5
SELECT species.common_name
FROM species
LEFT JOIN sightings
    ON species.species_id = sightings.species_id
WHERE sightings.species_id IS NULL;

-- or 
SELECT common_name
FROM species
WHERE species_id NOT IN (
    SELECT DISTINCT species_id
    FROM sightings
);

-- problem 6
SELECT sp.common_name, si.sighting_time, r.name
FROM sightings si
INNER JOIN species sp
ON si.species_id = sp.species_id
INNER JOIN rangers r
ON si.ranger_id = r.ranger_id
ORDER BY si.sighting_time DESC
LIMIT 2;

-- problem 7
UPDATE species
SET conservation_status = 'Historic'
WHERE EXTRACT(YEAR FROM discovery_date) < 1800;

-- problem 8
SELECT sighting_id,
    CASE 
        WHEN EXTRACT(HOUR FROM sighting_time) < 12 THEN 'Morning' 
        WHEN EXTRACT(HOUR FROM sighting_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS time_of_day
FROM sightings;

-- problem 9
DELETE FROM rangers
WHERE ranger_id NOT IN (SELECT ranger_id FROM sightings);
