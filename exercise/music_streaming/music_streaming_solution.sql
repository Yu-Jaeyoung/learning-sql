-- 🎵 음악 스트리밍 서비스 데이터베이스 구축 실습
-- PostgreSQL을 사용하여 완전히 새로운 음악 스트리밍 서비스 데이터베이스를 만들고 학습합니다.

-- 환경 설정

-- 새로운 스키마 생성 (Sakila와 분리)
CREATE SCHEMA music_streaming;

-- 작업 스키마 설정
SET search_path TO music_streaming, public;


-- 1. 테이블 생성
-- 문제 1-1: genre 테이블을 생성하세요.

-- 요구사항:
-- genre_id: SERIAL (기본키)
-- name: VARCHAR(50), NOT NULL
-- description: TEXT
-- created_at: TIMESTAMP, 기본값은 현재 시간

CREATE TABLE genre
(
  genre_id    SERIAL PRIMARY KEY,
  name        VARCHAR(50) NOT NULL,
  description TEXT,
  created_at  TIMESTAMP DEFAULT NOW()
);


-- 문제 1-2: artist 테이블을 생성하세요.

-- 요구사항:
-- artist_id: SERIAL (기본키)
-- name: VARCHAR(100), NOT NULL
-- country: VARCHAR(50)
-- debut_year: INTEGER
-- created_at: TIMESTAMP, 기본값 CURRENT_TIMESTAMP

CREATE TABLE artist
(
  artist_id  SERIAL PRIMARY KEY,
  name       VARCHAR(100) NOT NULL,
  country    VARCHAR(50),
  debut_year INTEGER,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- 문제 1-4: user_account 테이블을 생성하세요.

-- 요구사항:
-- user_id: SERIAL (기본키)
-- email: VARCHAR(100), UNIQUE, NOT NULL
-- username: VARCHAR(50), UNIQUE, NOT NULL
-- birth_date: DATE
-- country: VARCHAR(50)
-- created_at: TIMESTAMP, 기본값 NOW()
-- is_active: BOOLEAN, 기본값 TRUE

CREATE TABLE user_account
(
  user_id    SERIAL PRIMARY KEY,
  email      VARCHAR(100) UNIQUE NOT NULL,
  username   VARCHAR(50) UNIQUE  NOT NULL,
  birth_date DATE,
  country    VARCHAR(50),
  created_at TIMESTAMP DEFAULT NOW(),
  is_active  BOOLEAN   DEFAULT TRUE
);


-- 문제 1-5: subscription_plan 테이블을 생성하세요.

-- 요구사항:
-- plan_id: SERIAL (기본키)
-- plan_name: VARCHAR(20), CHECK ('free', 'basic', 'premium' 중 하나)
-- monthly_price: NUMERIC(5,2), CHECK (>= 0)
-- max_offline_downloads: INTEGER
-- ad_free: BOOLEAN

CREATE TABLE subscription_plan
(
  plan_id               SERIAL PRIMARY KEY,
  plan_name             VARCHAR(20),
  monthly_price         NUMERIC(5, 2),
  max_offline_downloads INTEGER,
  ad_free               BOOLEAN,
  CONSTRAINT plan_name_check CHECK (plan_name IN ('free', 'basic', 'premium')),
  CONSTRAINT monthly_price_check CHECK ( monthly_price >= 0)
);


-- 문제 1-6: album 테이블을 생성하세요.

-- 요구사항:
-- album_id: SERIAL (기본키)
-- title: VARCHAR(200), NOT NULL
-- artist_id: INTEGER (나중에 외래키 추가 예정)
-- release_date: DATE
-- total_tracks: SMALLINT
-- created_at: TIMESTAMP

CREATE TABLE album
(
  album_id     SERIAL PRIMARY KEY,
  title        VARCHAR(200) NOT NULL,
  artist_id    INTEGER,
  release_date DATE,
  total_tracks SMALLINT,
  created_at   TIMESTAMP
);


-- 문제 1-7: album 테이블에 외래키 제약조건을 추가하세요. (album 테이블을 수정)
-- artist_id가 artist 테이블의 artist_id를 참조하도록
-- ON DELETE CASCADE 설정

ALTER TABLE album
  ADD CONSTRAINT album_artist_id_fk FOREIGN KEY (artist_id) REFERENCES artist (artist_id) ON DELETE CASCADE;

-- 문제 1-8: track 테이블을 생성하세요.

-- 요구사항:
-- track_id: SERIAL (기본키)
-- title: VARCHAR(200), NOT NULL
-- album_id: INTEGER, album 테이블 참조 (ON DELETE CASCADE)
-- genre_id: INTEGER, genre 테이블 참조 (ON DELETE SET NULL)
-- duration_seconds: INTEGER, CHECK (> 0)
-- track_number: SMALLINT
-- play_count: BIGINT, 기본값 0
-- created_at: TIMESTAMP

CREATE TABLE track
(
  track_id         SERIAL PRIMARY KEY,
  title            VARCHAR(200) NOT NULL,
  album_id         INTEGER,
  genre_id         INTEGER,
  duration_seconds INTEGER,
  track_number     SMALLINT,
  play_count       BIGINT DEFAULT 0,
  created_at       TIMESTAMP,
  CONSTRAINT track_album_id_fk FOREIGN KEY (album_id) REFERENCES album (album_id) ON DELETE CASCADE,
  CONSTRAINT track_genre_id_fk FOREIGN KEY (genre_id) REFERENCES genre (genre_id) ON DELETE SET NULL,
  CONSTRAINT duration_seconds_check CHECK (duration_seconds > 0)
);

-- 문제 1-9: user_subscription 테이블을 생성하세요.

-- 요구사항:
-- subscription_id: SERIAL (기본키)
-- user_id: INTEGER, user_account 참조 (ON DELETE CASCADE)
-- plan_id: INTEGER, subscription_plan 참조
-- start_date: DATE, NOT NULL
-- end_date: DATE
-- is_active: BOOLEAN, 기본값 TRUE
-- CHECK: end_date > start_date

CREATE TABLE user_subscription
(
  subscription_id SERIAL PRIMARY KEY,
  user_id         INTEGER,
  plan_id         INTEGER,
  start_date      DATE NOT NULL,
  end_date        DATE,
  is_active       BOOLEAN DEFAULT TRUE,
  CONSTRAINT user_sub_user_id_fk FOREIGN KEY (user_id) REFERENCES user_account (user_id) ON DELETE CASCADE,
  CONSTRAINT user_sub_plan_id_fk FOREIGN KEY (plan_id) REFERENCES subscription_plan (plan_id),
  CONSTRAINT start_end_date_check CHECK (end_date > start_date)
);


-- 문제 1-10: playlist 테이블을 생성하세요.

-- 요구사항:
-- playlist_id: SERIAL (기본키)
-- user_id: INTEGER, user_account 참조
-- name: VARCHAR(100), NOT NULL
-- description: TEXT
-- is_public: BOOLEAN, 기본값 FALSE
-- created_at: TIMESTAMP
-- updated_at: TIMESTAMP

CREATE TABLE playlist
(
  playlist_id SERIAL PRIMARY KEY,
  user_id     INTEGER,
  name        VARCHAR(100) NOT NULL,
  description TEXT,
  is_public   BOOLEAN DEFAULT FALSE,
  created_at  TIMESTAMP,
  updated_at  TIMESTAMP,
  CONSTRAINT playlist_user_id_fk FOREIGN KEY (user_id) REFERENCES user_account (user_id)
);


-- 문제 1-11: playlist_track 테이블을 생성하세요. (플레이리스트와 트랙의 다대다 관계)

-- 요구사항:
-- playlist_id: INTEGER, playlist 참조
-- track_id: INTEGER, track 참조
-- added_at: TIMESTAMP, 기본값 NOW()
-- position: INTEGER (플레이리스트 내 순서)
-- 복합 기본키: (playlist_id, track_id)

CREATE TABLE playlist_track
(
  playlist_id INTEGER,
  track_id    INTEGER,
  added_at    TIMESTAMP DEFAULT NOW(),
  position    INTEGER,
  PRIMARY KEY (playlist_id, track_id),
  CONSTRAINT playlist_track_playlist_id_fk FOREIGN KEY (playlist_id) REFERENCES playlist (playlist_id),
  CONSTRAINT playlist_track_track_id_fk FOREIGN KEY (track_id) REFERENCES track (track_id)
);


-- 문제 1-12: listening_history 테이블을 생성하세요.

-- 요구사항:
-- history_id: SERIAL (기본키)
-- user_id: INTEGER, user_account 참조
-- track_id: INTEGER, track 참조
-- played_at: TIMESTAMP, NOT NULL
-- listen_duration_seconds: INTEGER (실제 들은 시간)
-- completed: BOOLEAN (곡을 끝까지 들었는지)

CREATE TABLE listening_history
(
  history_id              SERIAL PRIMARY KEY,
  user_id                 INTEGER,
  track_id                INTEGER,
  played_at               TIMESTAMP NOT NULL,
  listen_duration_seconds INTEGER,
  completed               BOOLEAN,
  CONSTRAINT listening_history_user_id_fk FOREIGN KEY (user_id) REFERENCES user_account (user_id),
  CONSTRAINT listening_history_track_id_fk FOREIGN KEY (track_id) REFERENCES track (track_id)
);


-- 문제 1-13: artist_follower 테이블을 생성하세요.

-- 요구사항:
-- user_id: INTEGER, user_account 참조
-- artist_id: INTEGER, artist 참조
-- followed_at: TIMESTAMP
-- 복합 기본키: (user_id, artist_id)

CREATE TABLE artist_follower
(
  user_id     INTEGER,
  artist_id   INTEGER,
  followed_at TIMESTAMP,
  PRIMARY KEY (user_id, artist_id),
  CONSTRAINT artist_follower_user_id_fk FOREIGN KEY (user_id) REFERENCES user_account (user_id),
  CONSTRAINT artist_follower_artist_id_fk FOREIGN KEY (artist_id) REFERENCES artist (artist_id)
);


-- 2. 데이터 삽입
-- 문제 2-1: 다음 표의 데이터를 genre 테이블에 삽입하세요. (8개 장르)
INSERT
  INTO genre(name, description, created_at)
VALUES ('Pop', 'Popular mainstream music with catchy melodies', '2024-01-01 10:00:00')
     , ('Rock', 'Guitar-driven music with strong beats', '2024-01-01 10:00:00')
     , ('Jazz', 'Improvisational music with complex harmonies', '2024-01-01 10:00:00')
     , ('Classical', 'Traditional orchestral and chamber music', '2024-01-01 10:00:00')
     , ('Hip Hop', 'Rhythmic music with rap vocals', '2024-01-01 10:00:00')
     , ('Electronic', 'Synthesizer and computer-generated music', '2024-01-01 10:00:00')
     , ('R&B', 'Rhythm and blues with soulful vocals', '2024-01-01 10:00:00')
     , ('Country', 'American folk music with storytelling lyrics', '2024-01-01 10:00:00');


-- 문제 2-2: 다음 표의 데이터를 subscription_plan 테이블에 삽입하세요. (3개 요금제)
INSERT
  INTO subscription_plan(plan_name, monthly_price, max_offline_downloads, ad_free)
VALUES ('free', 0.00, 0, FALSE)
     , ('basic', 4.99, 10, FALSE)
     , ('premium', 9.99, 999, TRUE);


-- 문제 2-3: 다음 표의 아티스트 5명을 artist 테이블에 삽입하세요.
INSERT
  INTO artist(name, country, debut_year, created_at)
VALUES ('The Beatles', 'UK', 1960, '2024-01-15 09:00:00')
     , ('BTS', 'South Korea', 2013, '2024-01-15 09:30:00')
     , ('Taylor Swift', 'USA', 2006, '2024-01-15 10:00:00')
     , ('Ed Sheeran', 'UK', 2011, '2024-01-15 10:30:00')
     , ('Billie Eilish', 'USA', 2015, '2024-01-15 11:00:00');


-- 문제 2-4: 다음 표의 사용자 5명을 user_account 테이블에 삽입하세요.
INSERT
  INTO user_account(email, username, birth_date, country, created_at, is_active)
VALUES ('john.doe@gmail.com', 'john_music', '1990-05-15', 'USA', '2024-01-01 08:00:00', TRUE)
     , ('sarah.kim@naver.com', 'sarah_k', '1995-08-22', 'South Korea', '2024-01-05 10:30:00', TRUE)
     , ('mike.wilson@yahoo.com', 'mike_w', '1988-03-10', 'UK', '2024-02-10 14:20:00', TRUE)
     , ('emma.brown@gmail.com', 'emma_b', '1992-11-28', 'Canada', '2024-02-15 09:45:00', TRUE)
     , ('david.lee@outlook.com', 'david_music', '1985-07-03', 'South Korea', '2024-03-01 11:00:00', TRUE);


-- 문제 2-5: 다음 표의 앨범 3개를 album 테이블에 삽입하세요.
INSERT
  INTO album(title, artist_id, release_date, total_tracks, created_at)
VALUES ('Abbey Road', 1, '1969-09-26', 17, '2024-01-20 10:00:00')
     , ('Map of the Soul: 7', 2, '2020-02-21', 20, '2024-01-21 11:00:00')
     , ('1989', 3, '2014-10-27', 13, '2024-01-22 12:00:00');


-- 문제 2-6: 다음 표의 트랙 5개를 track 테이블에 삽입하세요.
INSERT
  INTO track(title, album_id, genre_id, duration_seconds, track_number, play_count, created_at)
VALUES ('Come Together', 1, 2, 259, 1, 15420, '2024-01-20 10:00:00')
     , ('Something', 1, 2, 182, 2, 12350, '2024-01-20 10:05:00')
     , ('ON', 2, 5, 241, 1, 45000, '2024-01-21 11:00:00')
     , ('Shake It Off', 3, 1, 219, 1, 67000, '2024-01-22 12:00:00')
     , ('Blank Space', 3, 1, 231, 2, 71000, '2024-01-22 12:05:00');


-- 문제 2-7: 아래 스크립트를 실행하여 나머지 데이터를 삽입하세요.
-- ============================================
-- 음악 스트리밍 서비스 샘플 데이터
-- ============================================


-- 3. 데이터 조회
-- 문제 3-1: 모든 장르의 이름을 알파벳 순으로 조회하세요.
SELECT name
  FROM genre
 ORDER BY name;


-- 문제 3-2: 한국 출신 아티스트들의 이름과 데뷔 연도를 조회하세요.
SELECT name
     , debut_year
  FROM artist
 WHERE country = 'South Korea';


-- 문제 3-3: 가격이 $5 이상인 구독 요금제를 조회하세요.
SELECT *
  FROM subscription_plan
 WHERE monthly_price >= 5;


-- 문제 3-4: 2020년부터 발매된 앨범의 제목과 발매일을 조회하세요.
SELECT title
     , release_date
  FROM album
 WHERE release_date >= '2020-01-01';

-- 문제 3-5: 재생 시간이 3분(180초) 이상인 트랙들의 제목과 재생 시간을 조회하세요.
-- 힌트: CONCAT() 또는 TO_CHAR() 사용하면 '분:초' 형식으로 표시할 수 있음
SELECT title
     , CONCAT((duration_seconds / 60), ':', (duration_seconds % 60)) AS 재생시간
  FROM track
 WHERE duration_seconds >= 180;

-- TO_CHAR 사용
SELECT title
     , TO_CHAR((duration_seconds || ' seconds')::INTERVAL, 'MI:SS') AS 재생시간
  FROM track
 WHERE duration_seconds >= 180;

-- LPAD 사용
SELECT title
     , CONCAT(duration_seconds / 60, ':', LPAD((duration_seconds % 60)::TEXT, 2, '0')) AS 재생시간
  FROM track
 WHERE duration_seconds >= 180;

-- 조건문으로 포맷 개선
SELECT title
     , CONCAT(duration_seconds / 60, ':', CASE
                                            WHEN duration_seconds % 60 < 10 THEN '0' || (duration_seconds % 60)
                                            ELSE (duration_seconds % 60)::TEXT END) AS 재생시간
  FROM track
 WHERE duration_seconds >= 180;


-- 문제 3-6: 이메일 도메인이 'gmail.com'인 사용자를 찾으세요.
SELECT *
  FROM user_account
 WHERE email LIKE '%@gmail.com';


-- 문제 3-7: 트랙 제목에 'love'가 포함된 모든 곡을 찾으세요. (대소문자 구분 없이)
SELECT *
  FROM track
 WHERE LOWER(title) LIKE LOWER('%love%');

-- PostgreSQL 전용
SELECT *
  FROM track
 WHERE title ILIKE '%love%';


-- 문제 3-8: 1990년대(1990-1999)에 데뷔한 아티스트를 찾으세요.
SELECT *
  FROM artist
 WHERE debut_year BETWEEN 1990 AND 1999;


-- 문제 3-9: 공개 플레이리스트만 조회하되, 최신 생성 순으로 정렬하세요.
SELECT *
  FROM playlist
 WHERE is_public = TRUE
 ORDER BY created_at DESC;


-- 문제 3-10: 구독 상태가 활성화된 유저를 조회하세요.
SELECT *
  FROM user_subscription
 WHERE is_active = TRUE
   AND (end_date IS NULL OR end_date > CURRENT_DATE);


-- 문제 3-11: 2024년 11월에 생성된 플레이리스트를 찾으세요.
SELECT *
  FROM playlist
 WHERE created_at >= '2024-11-01'
   AND created_at < '2024-12-01';


-- 4. 데이터 집계
-- 문제 4-1: 전체 트랙 수를 세세요.
SELECT COUNT(*)
  FROM track;


-- 문제 4-2: 모든 트랙의 평균 재생 시간(초)을 소수점 첫째 자리에서 반올림하여 구하세요.
SELECT ROUND(AVG(duration_seconds))
  FROM track;


-- 문제 4-3: 가장 긴 트랙과 가장 짧은 트랙의 재생 시간을 조회하세요.
SELECT MAX(duration_seconds) AS 가장_긴_트랙
     , MIN(duration_seconds) AS 가장_짧은_트랙
  FROM track;


-- 문제 4-4: 장르별로 트랙 수를 세고, 트랙 수가 많은 순으로 정렬하세요.
SELECT genre_id
     , COUNT(*) AS count
  FROM track
 GROUP BY genre_id
 ORDER BY count DESC;


-- 문제 4-5: 아티스트별로 발매한 앨범 수를 이름을 포함하여 조회하세요.
SELECT ar.artist_id
     , ar.name
     , COUNT(*) AS album_count
  FROM album al
       INNER JOIN artist ar ON al.artist_id = ar.artist_id
 GROUP BY ar.artist_id
        , ar.name
 ORDER BY album_count;


-- 문제 4-6: 사용자별 플레이리스트 수를 세되, 2개 이상 가진 사용자만 표시하세요.
SELECT user_id
     , COUNT(*) AS playlist_count
  FROM playlist
 GROUP BY user_id
HAVING COUNT(*) >= 2;


-- 문제 4-7: 각 아티스트의 총 재생 횟수를 계산하세요.
SELECT a.artist_id
     , SUM(t.play_count)
  FROM album a
       INNER JOIN track t ON a.album_id = t.album_id
 GROUP BY a.artist_id;


-- 문제 4-8: 장르별 평균 트랙 길이를 분 단위로 조회하세요. (소수점 2자리까지 표현)
SELECT genre_id
     , ROUND(AVG(duration_seconds) / 60, 2)
  FROM track
 GROUP BY genre_id;


-- 문제 4-9: 월별 신규 사용자 수를 조회하세요. (2024년 기준)
-- 힌트: TO_CHAR(날짜_컬럼명, 'YYYY-MM') 사용
SELECT TO_CHAR(created_at, 'YYYY-MM') AS 월
     , COUNT(*)                       AS 신규_사용자수
  FROM user_account
 WHERE created_at >= '2024-01-01'
   AND created_at < '2025-01-01'
 GROUP BY TO_CHAR(created_at, 'YYYY-MM')
 ORDER BY 월;


-- 문제 4-10: 아티스트별, 장르별 트랙 수를 조회하되, ROLLUP을 사용하여 소계와 총계를 포함하세요.
SELECT a.artist_id
     , t.genre_id
     , COUNT(*) AS track_count
  FROM track t
       INNER JOIN album a ON t.album_id = a.album_id
 GROUP BY ROLLUP (a.artist_id
     , t.genre_id)
 ORDER BY a.artist_id NULLS LAST
        , t.genre_id NULLS LAST;


-- 문제 4-11: 요금제별, 국가별 구독자 수를 CUBE를 사용하여 조회하세요.
SELECT us.plan_id
     , ua.country
     , COUNT(*)
  FROM user_account ua
       INNER JOIN user_subscription us ON ua.user_id = us.user_id
 WHERE us.is_active = TRUE
 GROUP BY CUBE (us.plan_id
     , ua.country)
 ORDER BY us.plan_id
        , ua.country;


-- 문제 4-12: 각 사용자의 청취 기록에서:
-- 1. 총 청취 시간(초)
-- 2. 들은 곡 수
-- 3. 완주율 (completed = TRUE인 비율)
-- 을 계산하되, 10곡 이상 들은 사용자만 표시하세요.

-- 힌트 1: TRUE를 1, FALSE를 0
-- 힌트 2: PostgreSQL에서는 Boolean을 ::INTEGER 을 사용해 간단히 변환 가능

SELECT user_id
     , SUM(listen_duration_seconds)
     , COUNT(*)
     , ROUND(AVG(completed::INTEGER) * 100, 2)
  FROM listening_history
 GROUP BY user_id
HAVING COUNT(*) >= 10;


-- 5. 테이블 종합
-- 문제 5-1: 트랙 제목과 해당 앨범 제목을 함께 조회하세요.
SELECT t.title AS track_title
     , a.title AS album_title
  FROM track t
       INNER JOIN album a ON t.album_id = a.album_id;


-- 문제 5-2: 앨범 제목, 아티스트 이름, 발매일을 함께 조회하세요.
SELECT al.title AS album_title
     , ar.name  AS artist_name
     , al.release_date
  FROM album al
       INNER JOIN artist ar ON al.artist_id = ar.artist_id
 ORDER BY ar.name
        , al.release_date;


-- 문제 5-3: 플레이리스트 이름과 소유자(사용자) 이름을 함께 조회하세요.
SELECT pl.name     AS playlist_name
     , ua.username AS owner_name
  FROM user_account ua
       INNER JOIN playlist pl ON ua.user_id = pl.user_id;


-- 문제 5-4: 각 트랙의 제목, 장르 이름, 재생 시간을 조회하세요.
SELECT t.title AS track_title
     , g.name  AS genre_name
     , t.duration_seconds
  FROM track t
       INNER JOIN genre g ON t.genre_id = g.genre_id
 ORDER BY t.title;


-- 문제 5-5: 트랙 제목, 앨범 제목, 아티스트 이름, 장르 이름을 모두 함께 조회하세요.
SELECT t.title  AS track_title
     , al.title AS album_title
     , ar.name  AS artist_name
     , g.name   AS genre_name
  FROM track t
       INNER JOIN album al ON t.album_id = al.album_id
       INNER JOIN genre g ON t.genre_id = g.genre_id
       INNER JOIN artist ar ON al.artist_id = ar.artist_id;


-- 문제 5-6: 사용자 이름, 구독 요금제 이름, 월 요금을 함께 조회하세요. (현재 활성 구독만)
SELECT ua.username      AS user_name
     , sp.plan_name
     , sp.monthly_price AS monthly_fee
  FROM user_account ua
       INNER JOIN user_subscription us ON ua.user_id = us.user_id
       INNER JOIN subscription_plan sp ON us.plan_id = sp.plan_id
 WHERE us.is_active = TRUE;


-- 문제 5-7: 플레이리스트에 담긴 트랙 정보를 조회하세요:
-- - 플레이리스트 이름
-- - 트랙 제목
-- - 아티스트 이름
-- - 추가된 날짜

SELECT p.name  AS playlist_name
     , t.title AS track_title
     , ar.name AS artist_name
     , pt.added_at
  FROM playlist p
       INNER JOIN playlist_track pt ON p.playlist_id = pt.playlist_id
       INNER JOIN track t ON pt.track_id = t.track_id
       INNER JOIN album al ON t.album_id = al.album_id
       INNER JOIN artist ar ON al.artist_id = ar.artist_id;


-- 문제 5-8: 각 사용자가 들은 음악의 아티스트 정보를 조회하세요:
-- - 사용자 이름
-- - 트랙 제목
-- - 아티스트 이름
-- - 청취 시간
SELECT ua.username
     , t.title AS track_title
     , ar.name AS artist_name
     , lh.listen_duration_seconds
  FROM user_account ua
       INNER JOIN listening_history lh ON ua.user_id = lh.user_id
       INNER JOIN track t ON lh.track_id = t.track_id
       INNER JOIN album al ON t.album_id = al.album_id
       INNER JOIN artist ar ON al.artist_id = ar.artist_id;


-- 문제 5-9: 모든 앨범과 해당 앨범의 트랙 수를 조회하세요. (트랙이 없는 앨범도 포함)
SELECT al.album_id
     , al.title        AS album_title
     , COUNT(track_id) AS track_count
  FROM album al
       LEFT OUTER JOIN track t ON al.album_id = t.album_id
 GROUP BY al.album_id
        , al.title
 ORDER BY al.album_id;


-- 문제 5-10: 모든 사용자와 그들의 플레이리스트 수를 조회하세요.
SELECT ua.username
     , COUNT(playlist_id) AS playlist_count
  FROM user_account ua
       LEFT OUTER JOIN playlist p ON ua.user_id = p.user_id
 GROUP BY ua.user_id
        , ua.username
 ORDER BY ua.user_id;


-- 문제 5-11: 모든 아티스트와 팔로워 수를 조회하세요.
SELECT ar.name        AS artist_name
     , COUNT(user_id) AS follower_count
  FROM artist ar
       LEFT OUTER JOIN artist_follower af ON ar.artist_id = af.artist_id
 GROUP BY ar.artist_id
        , ar.name
 ORDER BY ar.artist_id;


-- 문제 5-12: 모든 트랙과 플레이리스트 추가 횟수를 조회하세요. (한 번도 플레이리스트에 추가되지 않은 트랙도 포함)
SELECT t.title         AS track_title
     , COUNT(added_at) AS add_count
  FROM track t
       LEFT OUTER JOIN playlist_track pt ON t.track_id = pt.track_id
 GROUP BY t.track_id
        , t.title
 ORDER BY t.track_id;


-- 문제 5-13: 트랙이 하나도 없는 앨범을 찾으세요.
SELECT al.album_id
     , al.title AS album_title
  FROM album al
       LEFT OUTER JOIN track t ON al.album_id = t.album_id
 WHERE t.album_id IS NULL;


-- 문제 5-14: 플레이리스트가 하나도 없는 사용자를 찾으세요.
SELECT ua.user_id
     , ua.username
  FROM user_account ua
       LEFT OUTER JOIN playlist p ON ua.user_id = p.user_id
 WHERE p.playlist_id IS NULL;

-- 문제 5-15: 팔로워가 한 명도 없는 아티스트를 찾으세요.
SELECT ar.artist_id
     , ar.name AS artist_name
  FROM artist ar
       LEFT OUTER JOIN artist_follower af ON ar.artist_id = af.artist_id
 WHERE af.user_id IS NULL;


-- 문제 5-16: 한 번도 재생되지 않은 트랙을 찾으세요.
SELECT t.title
  FROM track t
       LEFT OUTER JOIN listening_history lh ON t.track_id = lh.track_id
 WHERE lh.history_id IS NULL;


-- 문제 5-17: 구독 이력이 없는 사용자를 찾으세요.
SELECT ua.user_id
     , ua.username
  FROM user_account ua
       LEFT OUTER JOIN user_subscription us ON ua.user_id = us.user_id
 WHERE us.user_id IS NULL;


-- 문제 5-18: 모든 아티스트의 앨범 수와 트랙 수를 조회하세요.
SELECT ar.artist_id
     , ar.name                     AS artist_name
     , COUNT(DISTINCT al.album_id) AS album_count
     , COUNT(t.track_id)           AS track_count
  FROM artist ar
       LEFT OUTER JOIN album al ON ar.artist_id = al.artist_id
       LEFT OUTER JOIN track t ON t.album_id = al.album_id
 GROUP BY ar.artist_id
        , ar.name
 ORDER BY ar.artist_id;


-- 문제 5-19: 각 장르의 트랙 수와 총 재생 횟수를 조회하세요. (트랙이 없는 장르도 포함, 0으로 표시)
-- 힌트: COALESCE(값, 대체값) 함수를 사용하면 NULL을 다른 값으로 대체할 수 있습니다.
SELECT g.name                       AS genre_name
     , COUNT(track_id)              AS track_count
     , COALESCE(SUM(play_count), 0) AS total_play_count
  FROM genre g
       LEFT OUTER JOIN track t ON g.genre_id = t.genre_id
 GROUP BY g.genre_id
        , g.name;


-- 문제 5-20: 모든 사용자의 구독 상태를 조회하세요:
-- - 사용자 이름
-- - 현재 구독 요금제 (없으면 'Free')
-- - 구독 시작일 (없으면 NULL)
-- - 월 요금 (없으면 0)
-- 힌트: COALESCE(값, 대체값) 함수를 사용하면 NULL을 다른 값으로 대체할 수 있습니다.
SELECT ua.username
     , COALESCE(sp.plan_name, 'Free') AS current_plan
     , us.start_date
     , COALESCE(sp.monthly_price, 0)  AS monthly_fee
  FROM user_account ua
       LEFT OUTER JOIN user_subscription us ON ua.user_id = us.user_id AND us.is_active = TRUE
       LEFT OUTER JOIN subscription_plan sp ON us.plan_id = sp.plan_id;

-- CASE WHEN THEN 사용
SELECT ua.username
     , CASE WHEN sp.plan_name IS NULL THEN 'Free' ELSE sp.plan_name END    AS current_plan
     , us.start_date
     , CASE WHEN sp.monthly_price IS NULL THEN 0 ELSE sp.monthly_price END AS monthly_fee
  FROM user_account ua
       LEFT OUTER JOIN user_subscription us ON ua.user_id = us.user_id AND us.is_active = TRUE
       LEFT OUTER JOIN subscription_plan sp ON us.plan_id = sp.plan_id;


-- 문제 5-21: 모든 플레이리스트의 상세 정보를 조회하세요:
-- - 플레이리스트 이름
-- - 소유자 이름
-- - 트랙 수 (0개 포함)
-- - 총 재생 시간 (트랙들의 duration 합계)
-- - 트랙이 없으면 0 표시
SELECT pl.name                              AS playlist_name
     , ua.username                          AS owner_name
     , COUNT(t.track_id)                    AS track_count
     , COALESCE(SUM(t.duration_seconds), 0) AS total_duration
  FROM playlist pl
       INNER JOIN user_account ua ON pl.user_id = ua.user_id
       LEFT OUTER JOIN playlist_track pt ON pl.playlist_id = pt.playlist_id
       LEFT OUTER JOIN track t ON pt.track_id = t.track_id
 GROUP BY pl.playlist_id
        , pl.name
        , ua.username;


-- 문제 5-22: 각 사용자와 그들의 최근 청취 날짜를 조회하세요. (한 번도 듣지 않은 사용자는 NULL 표시)
SELECT ua.user_id
     , ua.username
     , MAX(lh.played_at)::DATE AS last_listened_date
  FROM user_account ua
       LEFT OUTER JOIN listening_history lh ON ua.user_id = lh.user_id
 GROUP BY ua.user_id
        , ua.username;


-- 문제 5-23: (구독자가 없는 요금제도 포함하여)모든 구독 요금제와 현재 구독자 수를 RIGHT JOIN으로 조회하세요.
SELECT sp.plan_name
     , COUNT(us.user_id) AS subscriber_count
  FROM user_subscription us
       RIGHT OUTER JOIN subscription_plan sp ON us.plan_id = sp.plan_id AND us.is_active = TRUE
 GROUP BY sp.plan_id
        , sp.plan_name
 ORDER BY sp.plan_id;


-- 문제 5-24: 모든 사용자와 모든 아티스트의 조합을 만들어 팔로우 관계를 확인하세요:
-- - 사용자 이름
-- - 아티스트 이름
-- - 팔로우 날짜 (팔로우하지 않으면 'Not Following' 표시)
-- 힌트: CROSS JOIN으로 모든 조합을 만든 후, COALESCE 함수로 NULL을 대체할 수 있습니다.
SELECT ua.username
     , ar.name                                               AS artist_name
     , COALESCE(af.followed_at::DATE::TEXT, 'Not Following') AS follow_status
  FROM user_account ua
       CROSS JOIN artist ar
       LEFT JOIN artist_follower af ON ua.user_id = af.user_id AND ar.artist_id = af.artist_id
 ORDER BY ua.username
        , ar.name;


-- 6. 서브쿼리
-- 문제 6-1: 가장 많은 트랙을 가진 앨범의 정보를 조회하세요.
-- 문제 6-2: 평균보다 긴 트랙들을 모두 찾으세요.
-- 문제 6-3: 'BTS'의 모든 트랙을 찾으세요.
-- 문제 6-4: Premium 요금제 구독자들만 조회하세요.
-- 문제 6-5: 각 아티스트의 평균 트랙 길이보다 긴 트랙들을 찾으세요.
-- 문제 6-6: 자신의 플레이리스트에 10곡 이상 담은 사용자를 찾으세요.
-- 문제 6-7: 최근 30일간 청취 기록이 있는 사용자를 찾으세요.
-- 문제 6-8: 한 번도 들어본 적 없는 트랙을 찾으세요.
-- 문제 6-9: 각 장르에서 재생 횟수가 가장 많은 트랙을 찾으세요.
-- -- 힌트: 상관 서브쿼리 또는 윈도우 함수
-- 문제 6-10: 모든 장르의 음악을 들어본 사용자를 찾으세요.
-- 힌트: 사용자별로 들어본 장르 수 = 전체 장르 수
-- 문제 6-11: 자기 자신보다 팔로워가 많은 아티스트를 팔로우하는 사용자를 찾으세요.

-- 문제 5-26: 각 아티스트와 그들의 가장 최근 발매 앨범을 조회하세요.
-- 앨범이 없는 아티스트도 포함하여 조회하세요.
SELECT ar.artist_id
     , ar.name  AS artist_name
     , al.title AS latest_album
     , al.release_date
  FROM artist ar
       LEFT OUTER JOIN album al ON ar.artist_id = al.artist_id
 WHERE al.release_date = (
   SELECT MAX(al2.release_date)
     FROM album al2
    WHERE al2.artist_id = ar.artist_id
                         )
    OR al.album_id IS NULL;

-- 문제 5-25: 모든 앨범과 가장 인기 있는 트랙(재생 횟수 기준)을 조회하세요. (트랙이 없는 앨범은 NULL)

-- 상관 서브쿼리 방식 (Correlated Subquery)
SELECT a.album_id
     , a.title  AS album_title
     , t1.title AS top_track
     , t1.play_count
  FROM album a
       LEFT OUTER JOIN track t1 ON a.album_id = t1.album_id
 WHERE t1.play_count = (
   SELECT MAX(t2.play_count)
     FROM track t2
    WHERE t2.album_id = t1.album_id
                       )
    OR t1.track_id IS NULL;

-- CTE 사용
  WITH max_plays AS (
    SELECT album_id
         , MAX(play_count) AS max_count
      FROM track
     GROUP BY album_id
                    )
SELECT a.album_id
     , a.title AS album_title
     , t.title AS top_track
     , t.play_count
  FROM album a
       LEFT OUTER JOIN track t ON a.album_id = t.album_id
       LEFT OUTER JOIN max_plays mp ON t.album_id = mp.album_id
 WHERE t.play_count = mp.max_count
    OR t.track_id IS NULL;


-- 문제 5-9: 사용자가 팔로우하는 아티스트의 신곡을 추천하세요:
-- - 사용자가 팔로우한 각 아티스트별로
-- - 아직 듣지 않은 곡 중
-- - 가장 인기 있는 곡(play_count 기준) 1개만 추천

  WITH ranked_tracks AS (
    SELECT af.user_id
         , ar.artist_id
         , ar.name                                                                          AS artist_name
         , t.title                                                                          AS track_title
         , t.play_count
         , RANK() OVER ( PARTITION BY af.user_id, ar.artist_id ORDER BY t.play_count DESC ) AS rank
      FROM artist_follower af
           INNER JOIN artist ar ON af.artist_id = ar.artist_id
           INNER JOIN album al ON ar.artist_id = al.artist_id
           INNER JOIN track t ON al.album_id = t.album_id
           LEFT JOIN listening_history lh ON lh.track_id = t.track_id AND lh.user_id = af.user_id
     WHERE lh.track_id IS NULL
                        )
SELECT user_id
     , artist_name
     , track_title
     , play_count
  FROM ranked_tracks
 WHERE rank = 1
 ORDER BY user_id
        , artist_id;

SELECT af.user_id
     , ar.name AS artist_name
     , t.title AS track_title
     , t.play_count
  FROM artist_follower af
       INNER JOIN artist ar ON af.artist_id = ar.artist_id
       INNER JOIN album al ON ar.artist_id = al.artist_id
       INNER JOIN track t ON al.album_id = t.album_id
       LEFT JOIN listening_history lh ON lh.track_id = t.track_id AND lh.user_id = af.user_id
 WHERE lh.track_id IS NULL
   AND t.play_count = (
   SELECT MAX(t2.play_count)
     FROM track t2
          INNER JOIN album al2 ON t2.album_id = al2.album_id
          LEFT JOIN listening_history lh2 ON lh2.track_id = t2.track_id AND lh2.user_id = af.user_id
    WHERE al2.artist_id = ar.artist_id
      AND lh2.track_id IS NULL
                      )
 ORDER BY af.user_id
        , ar.artist_id;

-- 7. CTE (Common Table Expressions)
-- 문제 7-1: CTE를 사용하여 각 사용자의 총 청취 시간을 계산하고, 상위 10명을 조회하세요.
-- 문제 7-2: Rock 장르의 인기 트랙 Top 10을 CTE로 정의하고, 이들의 상세 정보를 조회하세요.
-- 문제 7-3: 다음 CTE들을 사용하여 분석하세요:
-- 1. `active_users`: 최근 30일 활성 사용자
-- 2. `popular_tracks`: 재생 횟수 상위 20% 트랙
-- 3. `user_favorites`: 활성 사용자들이 가장 많이 들은 트랙
--
-- 최종: 각 활성 사용자가 인기 트랙 중 몇 곡을 들었는지 조회
--
-- 문제 7-4: 다음을 CTE로 구현하세요:
-- 1. 각 아티스트의 월별 총 재생 시간
-- 2. 전월 대비 재생 시간 증가율
-- 3. 성장률 상위 5명 아티스트
--

-- 문제 5-31: 2024년의 일별 신규 사용자와 신규 아티스트를 함께 조회하세요.
-- 힌트:
-- WITH day AS (
--     SELECT GENERATE_SERIES(
--         '2024-01-01'::DATE,
--         '2024-12-31'::DATE,
--         '1 day'::INTERVAL
--     )::DATE AS day_date
-- ),

  WITH day AS (
    SELECT GENERATE_SERIES('2024-01-01'::DATE, '2024-12-31'::DATE, '1 day'::INTERVAL)::DATE AS day_date
              )
     , new_entities AS (
    SELECT created_at::DATE AS created_date
      FROM user_account
     WHERE created_at >= '2024-01-01'
       AND created_at < '2025-01-01'
     UNION ALL
    SELECT created_at::DATE AS created_date
      FROM artist
     WHERE created_at >= '2024-01-01'
       AND created_at < '2025-01-01'
              )
SELECT d.day_date
     , COUNT(ne.created_date) AS new_count
  FROM day d
       LEFT JOIN new_entities ne ON d.day_date = ne.created_date
 GROUP BY d.day_date
 ORDER BY d.day_date;


-- 문제 5-10: 같은 장르를 좋아하는 사용자를 찾으세요:
-- - 각 사용자가 가장 많이 들은 장르
-- - 같은 장르를 선호하는 다른 사용자
  WITH favorite_genre AS (
    SELECT a.user_id
         , a.genre_id
      FROM (
             SELECT ua.user_id
                  , g.genre_id
                  , ROW_NUMBER() OVER (PARTITION BY ua.user_id ORDER BY COUNT(*) DESC) AS ranking
               FROM user_account ua
                    INNER JOIN listening_history lh ON ua.user_id = lh.user_id
                    INNER JOIN track t ON lh.track_id = t.track_id
                    INNER JOIN genre g ON t.genre_id = g.genre_id
              GROUP BY ua.user_id
                     , g.genre_id
           ) a
     WHERE a.ranking = 1
                         )
SELECT fg1.user_id
     , g.name      AS favorite_genre
     , fg2.user_id AS same_genre_user_id
  FROM favorite_genre fg1
       INNER JOIN favorite_genre fg2 ON fg1.genre_id = fg2.genre_id AND fg1.user_id <> fg2.user_id
       INNER JOIN genre g ON fg1.genre_id = g.genre_id
 WHERE fg1.user_id < fg2.user_id;


-- Part 8: DML -- TRANSACTION 활용 추가하기
-- 문제 8-1: 모든 트랙의 play_count를 10% 증가시키세요.
-- 문제 8-2: 'Free' 요금제 사용자들의 구독을 'Basic'으로 업그레이드하세요.
-- 문제 8-3: 1년 이상 청취 기록이 없는 사용자의 is_active를 FALSE로 변경하세요. (상관 서브쿼리 사용)
-- 문제 8-4: 2023년 이전의 청취 기록을 삭제하세요.
-- 문제 8-5: 트랙이 하나도 없는 플레이리스트를 삭제하세요.
-- 문제 8-6: 만료된 구독 정보를 삭제하세요. (end_date < CURRENT_DATE - INTERVAL '1 year')


---
-- Part 9: Aggregates

-- 문제 9-1: 사용자 이름과 아티스트 이름을 모두 조회하세요. (타입 컬럼 추가)
-- 문제 9-2: 2024년에 생성된 플레이리스트와 2024년에 발매된 앨범의 이름을 모두 조회하세요.
-- 문제 9-3: Premium 구독자이면서 최근 7일간 활동한 사용자를 찾으세요.
-- 문제 9-4: 플레이리스트에는 있지만 아직 한 번도 재생하지 않은 트랙을 찾으세요.

-- 문제 5-28: user_account와 artist 테이블을 사용하여 모든 사용자와 아티스트의 이름을 조회하세요.
SELECT username AS name
  FROM user_account
 UNION
SELECT name AS name
  FROM artist;

-- 문제 5-29: 2024년 10월에 생성된 플레이리스트와 발매된 앨범을 모두 조회하세요. (답이 안나오므로 INSERT 필요함 추후 수정해야함)
SELECT 'Playlist' AS type
     , name
     , created_at
  FROM playlist
 WHERE created_at >= '2024-10-01'
   AND created_at < '2024-11-01'
 UNION ALL
SELECT 'Album' AS type
     , title   AS name
     , created_at
  FROM album
 WHERE created_at >= '2024-10-01'
   AND created_at < '2024-11-01';