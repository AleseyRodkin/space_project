-- ==========================================
-- 1. DDL: СОЗДАНИЕ СТРУКТУРЫ (Каркас)
-- ==========================================

-- Таблица-справочник кораблей
CREATE TABLE IF NOT EXISTS ships (
    ship_id SERIAL PRIMARY KEY, 
    ship_name VARCHAR(100) NOT NULL UNIQUE,
    ship_type VARCHAR(50)
);

-- Таблица миссий со связью Foreign Key
CREATE TABLE IF NOT EXISTS missions (
    mission_id SERIAL PRIMARY KEY,
    ship_id INTEGER REFERENCES ships(ship_id), 
    destination TEXT NOT NULL,
    status VARCHAR(20) DEFAULT 'Запланирована',
    launch_date DATE
);

-- ==========================================
-- 2. DML: НАПОЛНЕНИЕ ДАННЫМИ
-- ==========================================

INSERT INTO ships (ship_name, ship_type) 
VALUES ('Восток-1', 'Клипер'), 
       ('Falcon 9', 'Тяжелый'), 
       ('Discovery', 'Шаттл')
ON CONFLICT DO NOTHING; -- Чтобы не было ошибки, если уже есть такие имена

INSERT INTO missions (ship_id, destination, launch_date) 
VALUES (1, 'Орбита Земли', '1961-04-12'),
       (2, 'МКС', '2020-05-30'),
       (3, 'Телескоп Хаббл', '1990-04-24');

-- ==========================================
-- 3. DQL: ПРОВЕРКА (Сложный запрос с JOIN)
-- ==========================================

SELECT m.mission_id, s.ship_name, m.destination, m.launch_date
FROM missions m
JOIN ships s ON m.ship_id = s.ship_id;

-- ==========================================
-- 4. DCL: ПРАВА ДОСТУПА
-- ==========================================

-- Создание пользователя (если еще нет)
-- CREATE USER space_analyst WITH PASSWORD 'orbital123';

-- Выдача прав
GRANT CONNECT ON DATABASE postgres TO space_analyst;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO space_analyst;