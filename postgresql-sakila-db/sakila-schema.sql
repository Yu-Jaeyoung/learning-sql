-- 스키마 삭제 (CASCADE로 내부 객체도 함께 삭제)
DROP SCHEMA IF EXISTS sakila CASCADE;

-- 스키마 생성
CREATE SCHEMA sakila;

-- 현재 세션의 검색 경로 설정 (MySQL의 USE와 동일한 역할)
SET search_path TO sakila, public;

-------------------------------
-------------------------------

-- actor 테이블 생성
CREATE TABLE actor
(
  actor_id    SMALLINT    NOT NULL GENERATED ALWAYS AS IDENTITY,
  first_name  VARCHAR(45) NOT NULL,
  last_name   VARCHAR(45) NOT NULL,
  last_update TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (actor_id),
  CONSTRAINT actor_id_positive CHECK (actor_id > 0)
);

-- 인덱스 생성
CREATE INDEX idx_actor_last_name ON actor (last_name);

-- ON UPDATE CURRENT_TIMESTAMP 동작을 위한 트리거 함수 생성
CREATE OR REPLACE FUNCTION update_last_update_column() RETURNS TRIGGER AS
$$
BEGIN
  new.last_update = CURRENT_TIMESTAMP;
  RETURN new;
END;
$$ LANGUAGE plpgsql;

-- 트리거 적용
CREATE TRIGGER update_actor_last_update
  BEFORE UPDATE
  ON actor
  FOR EACH ROW
EXECUTE FUNCTION update_last_update_column();

-------------------------------
-------------------------------

-- country 테이블 생성
CREATE TABLE country
(
  country_id  SMALLINT    NOT NULL GENERATED ALWAYS AS IDENTITY,
  country     VARCHAR(50) NOT NULL,
  last_update TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (country_id),
  CONSTRAINT country_id_positive CHECK (country_id > 0)
);

-- ON UPDATE CURRENT_TIMESTAMP 트리거
CREATE TRIGGER update_country_last_update
  BEFORE UPDATE
  ON country
  FOR EACH ROW
EXECUTE FUNCTION update_last_update_column();

-------------------------------
------------------------------

-- city 테이블 생성
CREATE TABLE city
(
  city_id     SMALLINT    NOT NULL GENERATED ALWAYS AS IDENTITY,
  city        VARCHAR(50) NOT NULL,
  country_id  SMALLINT    NOT NULL,
  last_update TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (city_id),
  CONSTRAINT city_id_positive CHECK (city_id > 0),
  CONSTRAINT country_id_positive CHECK (country_id > 0),
  CONSTRAINT fk_city_country FOREIGN KEY (country_id) REFERENCES country (country_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- 인덱스 생성
CREATE INDEX idx_fk_country_id ON city (country_id);

-- ON UPDATE CURRENT_TIMESTAMP 트리거
CREATE TRIGGER update_city_last_update
  BEFORE UPDATE
  ON city
  FOR EACH ROW
EXECUTE FUNCTION update_last_update_column();

-- PostGIS 확장 설치
-- 추가) docker-container에 접속한 뒤 PostGIS 설치 진행해야험
-- 유저에 SuperUser 권한이 있어야 확장 설치 가능
CREATE EXTENSION IF NOT EXISTS postgis;

CREATE EXTENSION postgis;

SELECT postgis_version();

-------------------------------
-------------------------------

-- address 테이블 생성
CREATE TABLE address
(
  address_id  SMALLINT           NOT NULL GENERATED ALWAYS AS IDENTITY,
  address     VARCHAR(50)        NOT NULL,
  address2    VARCHAR(50)                 DEFAULT NULL,
  district    VARCHAR(20)        NOT NULL,
  city_id     SMALLINT           NOT NULL,
  postal_code VARCHAR(10)                 DEFAULT NULL,
  phone       VARCHAR(20)        NOT NULL,
  -- PostGIS의 GEOMETRY 타입 (PostGIS 확장 필요)
  location    geometry(POINT, 0) NOT NULL,
  last_update TIMESTAMP          NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (address_id),
  CONSTRAINT address_id_positive CHECK (address_id > 0),
  CONSTRAINT city_id_positive CHECK (city_id > 0),
  CONSTRAINT fk_address_city FOREIGN KEY (city_id) REFERENCES city (city_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- 인덱스 생성
CREATE INDEX idx_fk_city_id ON address (city_id);

-- SPATIAL INDEX (PostGIS 필요)
CREATE INDEX idx_location ON address USING gist (location);

-- ON UPDATE CURRENT_TIMESTAMP 트리거
CREATE TRIGGER update_address_last_update
  BEFORE UPDATE
  ON address
  FOR EACH ROW
EXECUTE FUNCTION update_last_update_column();

-------------------------------
-------------------------------

-- category 테이블 생성
CREATE TABLE category
(
  category_id SMALLINT    NOT NULL GENERATED ALWAYS AS IDENTITY,
  name        VARCHAR(25) NOT NULL,
  last_update TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (category_id),
  CONSTRAINT category_id_positive CHECK (category_id > 0)
);

-- ON UPDATE CURRENT_TIMESTAMP 트리거
CREATE TRIGGER update_category_last_update
  BEFORE UPDATE
  ON category
  FOR EACH ROW
EXECUTE FUNCTION update_last_update_column();

-------------------------------
-------------------------------

-- staff 테이블 생성 (외래키는 나중에 추가)
CREATE TABLE staff
(
  staff_id    SMALLINT    NOT NULL GENERATED ALWAYS AS IDENTITY,
  first_name  VARCHAR(45) NOT NULL,
  last_name   VARCHAR(45) NOT NULL,
  address_id  SMALLINT    NOT NULL,
  picture     bytea                   DEFAULT NULL,
  email       VARCHAR(50)             DEFAULT NULL,
  store_id    SMALLINT    NOT NULL,
  active      BOOLEAN     NOT NULL    DEFAULT TRUE,
  username    VARCHAR(16) NOT NULL,
  password    VARCHAR(40) COLLATE "C" DEFAULT NULL,
  last_update TIMESTAMP   NOT NULL    DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (staff_id),
  CONSTRAINT staff_id_positive CHECK (staff_id > 0),
  CONSTRAINT address_id_positive CHECK (address_id > 0),
  CONSTRAINT store_id_positive CHECK (store_id > 0)
  -- 외래키는 나중에 추가
);

-- 인덱스 생성
CREATE INDEX idx_fk_store_id ON staff (store_id);
CREATE INDEX idx_fk_address_id ON staff (address_id);

-- ON UPDATE CURRENT_TIMESTAMP 트리거
CREATE TRIGGER update_staff_last_update
  BEFORE UPDATE
  ON staff
  FOR EACH ROW
EXECUTE FUNCTION update_last_update_column();

-------------------------------
-------------------------------

-- store 테이블 생성 (외래키는 나중에 추가)
CREATE TABLE store
(
  store_id         SMALLINT  NOT NULL GENERATED ALWAYS AS IDENTITY,
  manager_staff_id SMALLINT  NOT NULL,
  address_id       SMALLINT  NOT NULL,
  last_update      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (store_id),
  CONSTRAINT store_id_positive CHECK (store_id > 0),
  CONSTRAINT manager_staff_id_positive CHECK (manager_staff_id > 0),
  CONSTRAINT address_id_positive CHECK (address_id > 0),
  CONSTRAINT idx_unique_manager UNIQUE (manager_staff_id)
  -- 외래키는 나중에 추가
);

-- 인덱스 생성 (중복)
-- CREATE INDEX idx_fk_address_id ON store(address_id);

-- ON UPDATE CURRENT_TIMESTAMP 트리거
CREATE TRIGGER update_store_last_update
  BEFORE UPDATE
  ON store
  FOR EACH ROW
EXECUTE FUNCTION update_last_update_column();


-- 외래키 제약조건 추가
-- staff 테이블 외래키
ALTER TABLE staff
  ADD CONSTRAINT fk_staff_store FOREIGN KEY (store_id) REFERENCES store (store_id) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE staff
  ADD CONSTRAINT fk_staff_address FOREIGN KEY (address_id) REFERENCES address (address_id) ON DELETE RESTRICT ON UPDATE CASCADE;

-- store 테이블 외래키
ALTER TABLE store
  ADD CONSTRAINT fk_store_staff FOREIGN KEY (manager_staff_id) REFERENCES staff (staff_id) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE store
  ADD CONSTRAINT fk_store_address FOREIGN KEY (address_id) REFERENCES address (address_id) ON DELETE RESTRICT ON UPDATE CASCADE;

-------------------------------
-------------------------------

-- customer 테이블 생성
CREATE TABLE customer
(
  customer_id SMALLINT    NOT NULL GENERATED ALWAYS AS IDENTITY,
  store_id    SMALLINT    NOT NULL,
  first_name  VARCHAR(45) NOT NULL,
  last_name   VARCHAR(45) NOT NULL,
  email       VARCHAR(50)          DEFAULT NULL,
  address_id  SMALLINT    NOT NULL,
  active      BOOLEAN     NOT NULL DEFAULT TRUE,
  create_date TIMESTAMP   NOT NULL,
  last_update TIMESTAMP            DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (customer_id),
  CONSTRAINT customer_id_positive CHECK (customer_id > 0),
  CONSTRAINT store_id_positive CHECK (store_id > 0),
  CONSTRAINT address_id_positive CHECK (address_id > 0),
  CONSTRAINT fk_customer_address FOREIGN KEY (address_id) REFERENCES address (address_id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_customer_store FOREIGN KEY (store_id) REFERENCES store (store_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- 인덱스 생성 (중복되는 요소 제외)
-- CREATE INDEX idx_fk_store_id ON customer(store_id);
-- CREATE INDEX idx_fk_address_id ON customer(address_id);
CREATE INDEX idx_last_name ON customer (last_name);

-- ON UPDATE CURRENT_TIMESTAMP 트리거
CREATE TRIGGER update_customer_last_update
  BEFORE UPDATE
  ON customer
  FOR EACH ROW
EXECUTE FUNCTION update_last_update_column();

-------------------------------
-------------------------------

-- language 테이블 생성

CREATE TABLE language
(
  language_id SMALLINT GENERATED ALWAYS AS IDENTITY,
  name        CHAR(20)  NOT NULL,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

  PRIMARY KEY (language_id),

  -- CHECK 제약조건 (UNSIGNED 대체)
  CONSTRAINT language_id_check CHECK (language_id >= 0)
);

-- last_update 자동 업데이트 트리거 함수 생성
CREATE OR REPLACE FUNCTION update_language_last_update() RETURNS TRIGGER AS
$$
BEGIN
  new.last_update = CURRENT_TIMESTAMP;
  RETURN new;
END;
$$ LANGUAGE plpgsql;

-- 트리거 생성
CREATE TRIGGER language_last_update_trigger
  BEFORE UPDATE
  ON language
  FOR EACH ROW
EXECUTE FUNCTION update_language_last_update();

-------------------------------
-------------------------------

-- film 테이블 생성

-- ENUM 타입 생성 (rating 컬럼용)
CREATE TYPE mpaa_rating AS ENUM ('G','PG','PG-13','R','NC-17');

-- film 테이블 생성
CREATE TABLE film
(
  film_id              SMALLINT GENERATED ALWAYS AS IDENTITY,
  title                VARCHAR(128)  NOT NULL,
  description          TEXT                   DEFAULT NULL,
  release_year         SMALLINT               DEFAULT NULL,
  language_id          SMALLINT      NOT NULL,
  original_language_id SMALLINT               DEFAULT NULL,
  rental_duration      SMALLINT      NOT NULL DEFAULT 3,
  rental_rate          DECIMAL(4, 2) NOT NULL DEFAULT 4.99,
  length               SMALLINT               DEFAULT NULL,
  replacement_cost     DECIMAL(5, 2) NOT NULL DEFAULT 19.99,
  rating               mpaa_rating            DEFAULT 'G',
  special_features     TEXT[]                 DEFAULT NULL,
  last_update          TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,

  PRIMARY KEY (film_id),

  -- CHECK 제약조건 (UNSIGNED 대체)
  CONSTRAINT film_id_check CHECK (film_id >= 0),
  CONSTRAINT release_year_check CHECK (release_year >= 0),
  CONSTRAINT language_id_check CHECK (language_id >= 0),
  CONSTRAINT original_language_id_check CHECK (original_language_id >= 0),
  CONSTRAINT rental_duration_check CHECK (rental_duration >= 0),
  CONSTRAINT length_check CHECK (length >= 0),

  -- special_features 배열 값 검증
  CONSTRAINT special_features_check CHECK ( special_features IS NULL OR special_features <@
                                                                        ARRAY ['Trailers','Commentaries','Deleted Scenes','Behind the Scenes']::TEXT[] )
);

-- 인덱스 생성
CREATE INDEX idx_title ON film (title);
CREATE INDEX idx_fk_language_id ON film (language_id);
CREATE INDEX idx_fk_original_language_id ON film (original_language_id);

-- last_update 자동 업데이트 트리거 함수 생성
CREATE OR REPLACE FUNCTION update_film_last_update() RETURNS TRIGGER AS
$$
BEGIN
  new.last_update = CURRENT_TIMESTAMP;
  RETURN new;
END;
$$ LANGUAGE plpgsql;

-- 트리거 생성
CREATE TRIGGER film_last_update_trigger
  BEFORE UPDATE
  ON film
  FOR EACH ROW
EXECUTE FUNCTION update_film_last_update();

-- 외래키 제약조건
ALTER TABLE film
  ADD CONSTRAINT fk_film_language FOREIGN KEY (language_id) REFERENCES language (language_id) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE film
  ADD CONSTRAINT fk_film_language_original FOREIGN KEY (original_language_id) REFERENCES language (language_id) ON DELETE RESTRICT ON UPDATE CASCADE;

-------------------------------
-------------------------------

-- film_actor 테이블 생성

CREATE TABLE film_actor
(
  actor_id    INTEGER   NOT NULL,
  film_id     INTEGER   NOT NULL,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (actor_id, film_id),
  CONSTRAINT fk_film_actor_actor FOREIGN KEY (actor_id) REFERENCES actor (actor_id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_film_actor_film FOREIGN KEY (film_id) REFERENCES film (film_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- MySQL의 `KEY idx_fk_film_id`에 해당하는 인덱스 생성
CREATE INDEX idx_fk_film_id ON film_actor (film_id);

CREATE OR REPLACE FUNCTION update_last_update_column() RETURNS TRIGGER AS
$$
BEGIN
  new.last_update = CURRENT_TIMESTAMP;
  RETURN new;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_film_actor_last_update
  BEFORE UPDATE
  ON film_actor
  FOR EACH ROW
EXECUTE FUNCTION update_last_update_column();

-------------------------------
-------------------------------

-- film_category 테이블 생성

CREATE TABLE film_category
(
  film_id     INTEGER   NOT NULL,
  category_id SMALLINT  NOT NULL,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (film_id, category_id),
  CONSTRAINT fk_film_category_film FOREIGN KEY (film_id) REFERENCES film (film_id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_film_category_category FOREIGN KEY (category_id) REFERENCES category (category_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TRIGGER trg_film_category_last_update
  BEFORE UPDATE
  ON film_category
  FOR EACH ROW
EXECUTE FUNCTION update_last_update_column();

-------------------------------
-------------------------------

-- film_text 테이블 생성
CREATE TABLE film_text
(
  film_id      INTEGER      NOT NULL,
  title        VARCHAR(255) NOT NULL,
  description  TEXT,
  PRIMARY KEY (film_id),

  -- 1. PostgreSQL의 FULLTEXT 검색을 위한 'tsvector' 생성 컬럼
  -- 'english'는 텍스트 검색 설정(언어)을 의미하며, 필요시 변경 가능합니다.
  -- COALESCE는 title이나 description이 NULL일 경우를 처리합니다.
  fts_document tsvector GENERATED ALWAYS AS ( to_tsvector('english', COALESCE(title, '') || ' ' ||
                                                                     COALESCE(description, '')) ) STORED
);

-- 2. tsvector 컬럼에 GIN 인덱스를 생성하여 검색 속도를 높입니다.
-- 이것이 MySQL의 FULLTEXT KEY에 해당합니다.
CREATE INDEX idx_title_description_fts ON film_text USING gin (fts_document);

-------------------------------
-------------------------------

-- ins_film (INSERT 트리거) film에 데이터가 삽입되면, film_text에도 삽입
-- 1. 트리거 함수 생성
CREATE OR REPLACE FUNCTION func_ins_film() RETURNS TRIGGER AS
$$
BEGIN
  INSERT
    INTO film_text (film_id, title, description)
  VALUES (new.film_id, new.title, new.description);

  RETURN new; -- AFTER 트리거에서는 반환값이 무시되지만, 명시적으로 작성
END;
$$ LANGUAGE plpgsql;

-- 2. 트리거 연결
CREATE TRIGGER ins_film
  AFTER INSERT
  ON film
  FOR EACH ROW
EXECUTE FUNCTION func_ins_film();

-------------------------------
-------------------------------

-- upd_film (UPDATE 트리거) film의 데이터가 변경되면, film_text도 변경합니다.
-- 1. 트리거 함수 생성
CREATE OR REPLACE FUNCTION func_upd_film() RETURNS TRIGGER AS
$$
BEGIN
  -- PostgreSQL에서는 NULL-safe 비교를 위해 'IS DISTINCT FROM'을 사용하는 것이 좋습니다.
  IF (old.film_id IS DISTINCT FROM new.film_id) OR (old.title IS DISTINCT FROM new.title) OR
     (old.description IS DISTINCT FROM new.description) THEN
    UPDATE film_text
       SET title       = new.title
         , description = new.description
         , film_id     = new.film_id
     WHERE film_id = old.film_id;
  END IF;

  RETURN new;
END;
$$ LANGUAGE plpgsql;

-- 2. 트리거 연결
CREATE TRIGGER upd_film
  AFTER UPDATE
  ON film
  FOR EACH ROW
EXECUTE FUNCTION func_upd_film();

-------------------------------
-------------------------------

-- del_film (DELETE 트리거) film에서 데이터가 삭제되면, film_text에서도 삭제합니다.
-- 1. 트리거 함수 생성
CREATE OR REPLACE FUNCTION func_del_film() RETURNS TRIGGER AS
$$
BEGIN
  DELETE
    FROM film_text
   WHERE film_id = old.film_id;

  RETURN old; -- DELETE 트리거에서는 OLD를 반환
END;
$$ LANGUAGE plpgsql;

-- 2. 트리거 연결
CREATE TRIGGER del_film
  AFTER DELETE
  ON film
  FOR EACH ROW
EXECUTE FUNCTION func_del_film();

-------------------------------
-------------------------------

-- inventory 테이블 생성
CREATE TABLE inventory
(
  inventory_id SERIAL    NOT NULL,
  film_id      INTEGER   NOT NULL,
  store_id     SMALLINT  NOT NULL,
  last_update  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (inventory_id),
  CONSTRAINT fk_inventory_store FOREIGN KEY (store_id) REFERENCES store (store_id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_inventory_film FOREIGN KEY (film_id) REFERENCES film (film_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- MySQL의 KEY 구문에 해당하는 인덱스 생성 (중복 제외)
-- CREATE INDEX idx_fk_film_id ON inventory (film_id);
CREATE INDEX idx_store_id_film_id ON inventory (store_id, film_id);

CREATE TRIGGER trg_inventory_last_update
  BEFORE UPDATE
  ON inventory
  FOR EACH ROW
EXECUTE FUNCTION update_last_update_column();

-------------------------------
-------------------------------

-- rental 테이블 생성
CREATE TABLE rental
(
  rental_id    SERIAL    NOT NULL,
  rental_date  TIMESTAMP NOT NULL,
  inventory_id INTEGER   NOT NULL,
  customer_id  INTEGER   NOT NULL,
  return_date  TIMESTAMP          DEFAULT NULL,
  staff_id     SMALLINT  NOT NULL,
  last_update  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

  PRIMARY KEY (rental_id),

  -- MySQL의 UNIQUE KEY에 해당
  UNIQUE (rental_date, inventory_id, customer_id),

  CONSTRAINT fk_rental_staff FOREIGN KEY (staff_id) REFERENCES staff (staff_id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_rental_inventory FOREIGN KEY (inventory_id) REFERENCES inventory (inventory_id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_rental_customer FOREIGN KEY (customer_id) REFERENCES customer (customer_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- MySQL의 KEY 구문에 해당하는 인덱스 생성
CREATE INDEX idx_fk_inventory_id ON rental (inventory_id);
CREATE INDEX idx_fk_customer_id ON rental (customer_id);
CREATE INDEX idx_fk_staff_id ON rental (staff_id);

CREATE OR REPLACE FUNCTION func_set_rental_date_now() RETURNS TRIGGER AS
$$
BEGIN
  -- INSERT 시 rental_date 값을 현재 시간으로 설정
  new.rental_date = CURRENT_TIMESTAMP;
  RETURN new;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_rental_date
  BEFORE INSERT
  ON rental
  FOR EACH ROW
EXECUTE FUNCTION func_set_rental_date_now();

CREATE TRIGGER trg_rental_last_update
  BEFORE UPDATE
  ON rental
  FOR EACH ROW
EXECUTE FUNCTION update_last_update_column();

-------------------------------
-------------------------------

-- payment 테이블 생성

CREATE TABLE payment
(
  payment_id   SERIAL        NOT NULL,
  customer_id  INTEGER       NOT NULL,
  staff_id     SMALLINT      NOT NULL,
  rental_id    INT       DEFAULT NULL,
  amount       DECIMAL(5, 2) NOT NULL,
  payment_date TIMESTAMP     NOT NULL,
  last_update  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

  PRIMARY KEY (payment_id),

  CONSTRAINT fk_payment_rental FOREIGN KEY (rental_id) REFERENCES rental (rental_id) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT fk_payment_customer FOREIGN KEY (customer_id) REFERENCES customer (customer_id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_payment_staff FOREIGN KEY (staff_id) REFERENCES staff (staff_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- MySQL의 KEY 구문에 해당하는 인덱스 생성 (중복 제외)
-- CREATE INDEX idx_fk_staff_id ON payment (staff_id);
-- CREATE INDEX idx_fk_customer_id ON payment (customer_id);

-- ON UPDATE 기능 구현 (Trigger)
CREATE TRIGGER trg_payment_last_update
  BEFORE UPDATE
  ON payment
  FOR EACH ROW
EXECUTE FUNCTION update_last_update_column();

CREATE OR REPLACE FUNCTION func_set_payment_date_now() RETURNS TRIGGER AS
$$
BEGIN
  -- INSERT 시 payment_date 값을 현재 시간으로 설정
  new.payment_date = CURRENT_TIMESTAMP;
  RETURN new;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_payment_date
  BEFORE INSERT
  ON payment
  FOR EACH ROW
EXECUTE FUNCTION func_set_payment_date_now();

-------------------------------
-------------------------------

-- customer_list 뷰 생성

CREATE VIEW customer_list AS
SELECT cu.customer_id                                AS id
     -- 1. CONCAT 및 _utf8mb4 문자열 대신 표준 || 연산자 사용
     , (cu.first_name || ' ' || cu.last_name)        AS name
     , a.address                                     AS address
     -- 2. 백틱(`) 대신 큰따옴표(") 사용
     , a.postal_code                                 AS "zip code"
     , a.phone                                       AS phone
     , city.city                                     AS city
     , country.country                               AS country
     -- 3. IF() 함수 대신 표준 CASE WHEN 사용
     , CASE WHEN cu.active THEN 'active' ELSE '' END AS notes
     , cu.store_id                                   AS sid
  FROM customer AS cu
       JOIN address AS a ON cu.address_id = a.address_id
       JOIN city ON a.city_id = city.city_id
       JOIN country ON city.country_id = country.country_id;

-------------------------------
-------------------------------

-- film_list view 생성

CREATE VIEW film_list AS
SELECT film.film_id                                              AS fid
     , film.title                                                AS title
     , film.description                                          AS description
     , category.name                                             AS category
     , film.rental_rate                                          AS price
     , film.length                                               AS length
     , film.rating                                               AS rating
     ,
     -- 1. GROUP_CONCAT -> STRING_AGG
     -- 2. CONCAT / _utf8mb4 -> ||
  STRING_AGG((actor.first_name || ' ' || actor.last_name), ', ') AS actors
  FROM film
       LEFT JOIN film_category ON film_category.film_id = film.film_id
       LEFT JOIN category ON category.category_id = film_category.category_id
       LEFT JOIN film_actor ON film.film_id = film_actor.film_id
       LEFT JOIN actor ON film_actor.actor_id = actor.actor_id
-- 3. PostgreSQL의 표준 SQL 규격에 맞게 GROUP BY 절 확장
 GROUP BY film.film_id, film.title, film.description, category.name, film.rental_rate, film.length, film.rating;

-------------------------------
-------------------------------

-- nicer_but_slower_film_list view 생성

CREATE VIEW nicer_but_slower_film_list AS
SELECT film.film_id                                                              AS fid
     , film.title                                                                AS title
     , film.description                                                          AS description
     , category.name                                                             AS category
     , film.rental_rate                                                          AS price
     , film.length                                                               AS length
     , film.rating                                                               AS rating
     ,
     -- 1. GROUP_CONCAT -> STRING_AGG
     -- 2. UCASE/LCASE/SUBSTR/CONCAT 콤보 -> INITCAP
  STRING_AGG(INITCAP(actor.first_name) || ' ' || INITCAP(actor.last_name), ', ') AS actors
  FROM film
       LEFT JOIN film_category ON film_category.film_id = film.film_id
       LEFT JOIN category ON category.category_id = film_category.category_id
       LEFT JOIN film_actor ON film.film_id = film_actor.film_id
       LEFT JOIN actor ON film_actor.actor_id = actor.actor_id
-- 3. PostgreSQL 표준에 맞게 GROUP BY 절 확장
 GROUP BY film.film_id, film.title, film.description, category.name, film.rental_rate, film.length, film.rating;

-------------------------------
-------------------------------

-- staff_list view 생성

CREATE VIEW staff_list AS
SELECT s.staff_id                           AS id
     -- 1. CONCAT 및 _utf8mb4 문자열 대신 표준 || 연산자 사용
     , (s.first_name || ' ' || s.last_name) AS name
     , a.address                            AS address
     -- 2. 백틱(`) 대신 큰따옴표(") 사용
     , a.postal_code                        AS "zip code"
     , a.phone                              AS phone
     , city.city                            AS city
     , country.country                      AS country
     , s.store_id                           AS sid
  FROM staff AS s
       JOIN address AS a ON s.address_id = a.address_id
       JOIN city ON a.city_id = city.city_id
       JOIN country ON city.country_id = country.country_id;

-------------------------------
-------------------------------

-- sales_by_store view 생성

CREATE VIEW sales_by_store AS
SELECT
     -- 1. CONCAT 및 _utf8mb4 대신 표준 || 연산자 사용
  (c.city || ',' || cy.country)             AS store
     , (m.first_name || ' ' || m.last_name) AS manager
     , SUM(p.amount)                        AS total_sales
  FROM payment AS p
       INNER JOIN rental AS r ON p.rental_id = r.rental_id
       INNER JOIN inventory AS i ON r.inventory_id = i.inventory_id
       INNER JOIN store AS s ON i.store_id = s.store_id
       INNER JOIN address AS a ON s.address_id = a.address_id
       INNER JOIN city AS c ON a.city_id = c.city_id
       INNER JOIN country AS cy ON c.country_id = cy.country_id
       INNER JOIN staff AS m ON s.manager_staff_id = m.staff_id
-- 2. PostgreSQL 표준에 맞게 GROUP BY 절 확장
 GROUP BY s.store_id, c.city, cy.country, m.first_name, m.last_name
 ORDER BY cy.country, c.city;

-------------------------------
-------------------------------

-- sales_by_film_category view 생성

CREATE VIEW sales_by_film_category AS
SELECT c.name AS category, SUM(p.amount) AS total_sales
  FROM payment AS p
       INNER JOIN rental AS r ON p.rental_id = r.rental_id
       INNER JOIN inventory AS i ON r.inventory_id = i.inventory_id
       INNER JOIN film AS f ON i.film_id = f.film_id
       INNER JOIN film_category AS fc ON f.film_id = fc.film_id
       INNER JOIN category AS c ON fc.category_id = c.category_id
 GROUP BY c.name
 ORDER BY total_sales DESC;

-------------------------------
-------------------------------

-- actor_info view 생성

-- 1. MySQL의 DEFINER...INVOKER 구문 제거
CREATE VIEW actor_info AS
SELECT a.actor_id
     , a.first_name
     , a.last_name
     -- 2. 복잡한 로직을 처리하기 위해 상관 서브쿼리 사용
     , (
  -- 3. 최종적으로 문자열을 '; '로 합침
  SELECT STRING_AGG(t.film_info_string, '; ')
    FROM (
           -- 4. 배우별로, 카테고리별 영화 목록을 DISTINCT하고 c.name으로 정렬
           SELECT DISTINCT
                         -- 5. CONCAT -> ||
             (c.name || ': ' || (
               -- 6. 내부 GROUP_CONCAT -> STRING_AGG
               SELECT STRING_AGG(f.title, ', ' ORDER BY f.title)
-- 7. sakila. 스키마 접두사 제거
                 FROM film f
                      JOIN film_category fc_inner ON f.film_id = fc_inner.film_id
                      JOIN film_actor fa_inner ON f.film_id = fa_inner.film_id
                WHERE fc_inner.category_id = c.category_id
                  AND fa_inner.actor_id = a.actor_id
                                )) AS film_info_string
                         , c.name -- 정렬을 위해 c.name도 SELECT
             FROM film_actor fa
                  JOIN film_category fc ON fa.film_id = fc.film_id
                  JOIN category c ON fc.category_id = c.category_id
-- 8. 외부 쿼리의 actor(a)와 연결
            WHERE fa.actor_id = a.actor_id
              AND c.name IS NOT NULL
  -- 9. 여기서 먼저 정렬
            ORDER BY c.name
         ) AS t
       ) AS film_info
  FROM actor a;
-- 10. 외부 GROUP BY는 상관 서브쿼리 방식으로 대체되었으므로 제거

-------------------------------
-------------------------------

-- rewards_report 함수(Function) 생성

CREATE OR REPLACE FUNCTION rewards_report(
  min_monthly_purchases SMALLINT, -- TINYINT UNSIGNED -> SMALLINT
  min_dollar_amount_purchased DECIMAL(10, 2)
)
  -- 1. OUT 매개변수 대신, 'customer' 테이블과 동일한 구조의 SET을 반환
  RETURNS SETOF customer
  LANGUAGE plpgsql
  SECURITY DEFINER AS
$$
DECLARE
  last_month_start DATE;
  last_month_end   DATE;
BEGIN
  /* 2. Sanity checks: LEAVE -> RAISE EXCEPTION */
  IF min_monthly_purchases <= 0 THEN RAISE EXCEPTION 'Minimum monthly purchases parameter must be > 0'; END IF;
  IF min_dollar_amount_purchased <= 0.00 THEN
    RAISE EXCEPTION 'Minimum monthly dollar amount purchased parameter must be > $0.00';
  END IF;

  /* 3. Date/Time 함수 변경 (MySQL -> PostgreSQL) */
  -- SET last_month_start = DATE_SUB(CURRENT_DATE(), INTERVAL 1 MONTH);
  -- SET last_month_start = STR_TO_DATE(CONCAT(YEAR(last_month_start),'-',MONTH(last_month_start),'-01'),'%Y-%m-%d');
  last_month_start := date_trunc('month', CURRENT_DATE - INTERVAL '1 month');

  -- SET last_month_end = LAST_DAY(last_month_start);
  last_month_end := (last_month_start + INTERVAL '1 month' - INTERVAL '1 day');

  /*
   * 4. 임시 테이블 로직 -> CTE (Common Table Expression)
   * OUT 매개변수 제거
   * RETURN QUERY로 결과 집합을 직접 반환
   */
  RETURN QUERY WITH tmpcustomer AS (
    SELECT p.customer_id
      FROM payment AS p
-- MySQL의 DATE() 함수는 PostgreSQL에서도 동일하게 동작
     WHERE date(p.payment_date) BETWEEN last_month_start AND last_month_end
     GROUP BY customer_id
    HAVING SUM(p.amount) > min_dollar_amount_purchased
       AND COUNT(customer_id) > min_monthly_purchases
                                   )
             SELECT c.*
               FROM tmpcustomer AS t
                    INNER JOIN customer AS c ON t.customer_id = c.customer_id;

  -- 5. 임시 테이블 DROP 및 OUT 변수 설정(count_rewardees) 불필요
END;
$$;

-- 6. 주석(COMMENT)은 별도 구문으로 분리
COMMENT ON FUNCTION rewards_report(SMALLINT, DECIMAL(10, 2)) IS 'Provides a customizable report on best customers';

-------------------------------
-------------------------------

-- get_customer_balance 함수 생성

-- 1. DELIMITER 제거
-- 2. 함수 헤더 변경 (LANGUAGE plpgsql, STABLE, AS $$ ... $$)
CREATE OR REPLACE FUNCTION get_customer_balance(p_customer_id INT, p_effective_date TIMESTAMP) RETURNS DECIMAL(5, 2)
  -- DETERMINISTIC/READS SQL DATA -> STABLE (데이터를 읽지만 변경하지 않음)
  STABLE
  LANGUAGE plpgsql AS
$$
  /* 3. DECLARE 블록을 AS dollar sign과와 BEGIN 사이에 명시적으로 선언 */
DECLARE
  --      OK, WE NEED TO CALCULATE THE CURRENT BALANCE GIVEN A CUSTOMER_ID AND A DATE
  --        THAT WE WANT THE BALANCE TO BE EFFECTIVE FOR. THE BALANCE IS:
  --        1) RENTAL FEES FOR ALL PREVIOUS RENTALS
  --        2) ONE DOLLAR FOR EVERY DAY THE PREVIOUS RENTALS ARE OVERDUE
  --        3) IF A FILM IS MORE THAN RENTAL_DURATION * 2 OVERDUE, CHARGE THE REPLACEMENT_COST
  --        4) SUBTRACT ALL PAYMENTS MADE BEFORE THE DATE SPECIFIED
  --
  --        참고: 원본 MySQL 코드에는 3번 로직(replacement_cost)이 구현되어 있지 않습니다.
  --             이 마이그레이션은 원본 코드의 실행 로직을 그대로 따릅니다
  v_rentfees DECIMAL(5, 2); -- FEES PAID TO RENT THE VIDEOS INITIALLY
  v_overfees INTEGER; -- LATE FEES FOR PRIOR RENTALS
  v_payments DECIMAL(5, 2); -- SUM OF PAYMENTS MADE PREVIOUSLY
BEGIN

  SELECT
    -- 5. IFNULL() -> COALESCE()
    COALESCE(SUM(film.rental_rate), 0)
    INTO v_rentfees
-- 6. 가독성을 위해 암시적 조인을 명시적 JOIN으로 변경
    FROM film
         JOIN inventory ON film.film_id = inventory.film_id
         JOIN rental ON inventory.inventory_id = rental.inventory_id
   WHERE rental.rental_date <= p_effective_date
     AND rental.customer_id = p_customer_id;

  SELECT
    -- 5. IFNULL() -> COALESCE()
    COALESCE(SUM(
               -- 7. IF() 함수 -> CASE WHEN ... END
                 CASE
                   -- 8. TO_DAYS() -> 날짜/타임스탬프 간의 뺄셈 및 형변환
                   WHEN (rental.return_date::DATE - rental.rental_date::DATE) > film.rental_duration THEN (
                     (rental.return_date::DATE - rental.rental_date::DATE) - film.rental_duration)
                   ELSE 0 END), 0)
    INTO v_overfees
    FROM rental
         JOIN inventory ON rental.inventory_id = inventory.inventory_id
         JOIN film ON inventory.film_id = film.film_id
   WHERE rental.rental_date <= p_effective_date
     AND rental.customer_id = p_customer_id;

  SELECT
    -- 5. IFNULL() -> COALESCE()
    COALESCE(SUM(payment.amount), 0)
    INTO v_payments
    FROM payment
   WHERE payment.payment_date <= p_effective_date
     AND payment.customer_id = p_customer_id;

  RETURN v_rentfees + v_overfees - v_payments;
END;
$$;

-------------------------------
-------------------------------


-- inventory_in_stock 함수 생성

CREATE OR REPLACE FUNCTION inventory_in_stock(p_inventory_id INT) RETURNS BOOLEAN
  -- 2. READS SQL DATA -> STABLE
  STABLE
  -- 3. LANGUAGE plpgsql 및 AS $$ ... $$ 구문 사용
  LANGUAGE plpgsql AS
$$
BEGIN
  /* 4. '#' 주석 변경
     AN ITEM IS IN-STOCK IF THERE ARE EITHER NO ROWS IN THE rental TABLE
     FOR THE ITEM OR ALL ROWS HAVE return_date POPULATED

     (최적화된 로직):
     아이템은 'return_date'가 NULL인 대여 기록이 '존재하지 않으면' 재고가 있는 것입니다.
  */

  -- 5. 로직 최적화: 2번의 COUNT() 대신 1번의 EXISTS() 사용
  -- 이 inventory_id에 대해 return_date가 NULL인 레코드가 하나라도 존재하면,
  -- 재고가 없는 것(FALSE)입니다.
  IF EXISTS
    (
      SELECT 1
        FROM rental
       WHERE inventory_id = p_inventory_id
         AND return_date IS NULL
    ) THEN
    RETURN FALSE; -- 재고 없음 (대여 중)
  ELSE
    RETURN TRUE; -- 재고 있음
  END IF;
END;
$$;
--------------------------
-----
-------------------------------


-- film_in_stock 함수 생성

CREATE OR REPLACE FUNCTION film_in_stock(p_film_id INT, p_store_id INT)
  -- 2. OUT 매개변수 대신 RETURNS INT로 변경
  RETURNS INT
  -- 3. READS SQL DATA -> STABLE
  STABLE
  -- 4. LANGUAGE plpgsql 및 AS $$ ... $$ 구문 사용
  LANGUAGE plpgsql AS
$$
DECLARE
  p_film_count INT;
BEGIN
  /*
   * 5. 첫 번째 SELECT 문 제거
   * PostgreSQL 함수는 OUT 매개변수와
   * 별도의 결과 집합을 동시에 반환할 수 없으므로,
   * OUT 매개변수의 목적에 집중합니다.
   */

  SELECT COUNT(*)
    INTO p_film_count
    FROM inventory
   WHERE film_id = p_film_id
     AND store_id = p_store_id
     AND inventory_in_stock(inventory_id); -- inventory_in_stock() 함수가 있다고 가정

  RETURN p_film_count;
END;
$$;

-------------------------------
-------------------------------

-- film_not_in_stock 함수 생성

CREATE OR REPLACE FUNCTION film_not_in_stock(p_film_id INT, p_store_id INT)
  -- 2. OUT 매개변수 대신 RETURNS INT로 변경
  RETURNS INT
  -- 3. READS SQL DATA -> STABLE
  STABLE
  -- 4. LANGUAGE plpgsql 및 AS $$ ... $$ 구문 사용
  LANGUAGE plpgsql AS
$$
DECLARE
  p_film_count INT;
BEGIN
  /*
   * 5. 첫 번째 SELECT 문 제거
   * PostgreSQL 함수는 OUT 매개변수와
   * 별도의 결과 집합을 동시에 반환할 수 없으므로,
   * OUT 매개변수의 목적에 집중합니다.
   */

  SELECT COUNT(*)
    INTO p_film_count
    FROM inventory
   WHERE film_id = p_film_id
     AND store_id = p_store_id
     -- 6. inventory_in_stock 함수의 결과를 반전시킴
     AND NOT inventory_in_stock(inventory_id);

  RETURN p_film_count;
END;
$$;

-------------------------------
-------------------------------

-- inventory_held_by_customer 함수 생성

CREATE OR REPLACE FUNCTION inventory_held_by_customer(p_inventory_id INT) RETURNS INT
  -- 2. READS SQL DATA -> STABLE
  STABLE
  -- 3. LANGUAGE plpgsql 및 AS $$ ... $$ 구문 사용
  LANGUAGE plpgsql AS
$$
DECLARE
  v_customer_id INT;
BEGIN
  /* * 4. EXIT HANDLER 제거
   * MySQL과 달리, PostgreSQL의 SELECT ... INTO는
   * 결과가 0건일 때 오류를 발생시키지 않고
   * 변수(v_customer_id)를 NULL로 설정합니다.
   * 이는 MySQL의 EXIT HANDLER가 하려던 동작과 동일합니다.
   */
  SELECT customer_id
    INTO v_customer_id
    FROM rental
   WHERE return_date IS NULL
     AND inventory_id = p_inventory_id;

  RETURN v_customer_id;
END;
$$;