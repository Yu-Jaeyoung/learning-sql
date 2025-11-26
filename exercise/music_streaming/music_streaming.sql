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
-- 문제 2-2: 다음 표의 데이터를 subscription_plan 테이블에 삽입하세요. (3개 요금제)
-- 문제 2-3: 다음 표의 아티스트 5명을 artist 테이블에 삽입하세요.
-- 문제 2-4: 다음 표의 사용자 5명을 user_account 테이블에 삽입하세요.
-- 문제 2-5: 다음 표의 앨범 3개를 album 테이블에 삽입하세요.
-- 문제 2-6: 다음 표의 트랙 5개를 track 테이블에 삽입하세요.
-- 문제 2-7: 아래 스크립트를 실행하여 나머지 데이터를 삽입하세요.
-- ============================================
-- 음악 스트리밍 서비스 샘플 데이터
-- ============================================


-- 3. 데이터 조회
-- 문제 3-1: 모든 장르의 이름을 알파벳 순으로 조회하세요.
-- 문제 3-2: 한국 출신 아티스트들의 이름과 데뷔 연도를 조회하세요.
-- 문제 3-3: 가격이 $5 이상인 구독 요금제를 조회하세요.
-- 문제 3-4: 2020년부터 발매된 앨범의 제목과 발매일을 조회하세요.
-- 문제 3-5: 재생 시간이 3분(180초) 이상인 트랙들의 제목과 재생 시간을 조회하세요. 힌트: CONCAT() 또는 TO_CHAR() 사용하면 '분:초' 형식으로 표시할 수 있음
-- 문제 3-6: 이메일 도메인이 'gmail.com'인 사용자를 찾으세요.
-- 문제 3-7: 트랙 제목에 'love'가 포함된 모든 곡을 찾으세요. (대소문자 구분 없이)
-- 문제 3-8: 1990년대(1990-1999)에 데뷔한 아티스트를 찾으세요.
-- 문제 3-9: 공개 플레이리스트만 조회하되, 최신 생성 순으로 정렬하세요.
-- 문제 3-10: 구독 상태가 활성화된 유저를 조회하세요.
-- 문제 3-11: 2024년 11월에 생성된 플레이리스트를 찾으세요.


-- 4. 데이터 집계
-- 문제 4-1: 전체 트랙 수를 세세요.
-- 문제 4-2: 모든 트랙의 평균 재생 시간(초)을 소수점 첫째 자리에서 반올림하여 구하세요.
-- 문제 4-3: 가장 긴 트랙과 가장 짧은 트랙의 재생 시간을 조회하세요.
-- 문제 4-4: 장르별로 트랙 수를 세고, 트랙 수가 많은 순으로 정렬하세요.
-- 문제 4-5: 아티스트별로 발매한 앨범 수를 이름을 포함하여 조회하세요.
-- 문제 4-6: 사용자별 플레이리스트 수를 세되, 2개 이상 가진 사용자만 표시하세요.
-- 문제 4-7: 각 아티스트의 총 재생 횟수를 계산하세요.
-- 문제 4-8: 장르별 평균 트랙 길이를 분 단위로 조회하세요. (소수점 2자리까지 표현)
-- 문제 4-9: 월별 신규 사용자 수를 조회하세요. (2024년 기준) 힌트: TO_CHAR(날짜_컬럼명, 'YYYY-MM') 사용
-- 문제 4-10: 아티스트별, 장르별 트랙 수의 소계와 총계를 조회하세요. 힌트: ROLLUP
-- 문제 4-11: 요금제별, 국가별 구독자 수를 조회하세요. 힌트: CUBE, is_active = TRUE 조건 사용
-- 문제 4-12: 각 사용자의 청취 기록에서:
-- 1. 총 청취 시간(초)
-- 2. 들은 곡 수
-- 3. 완주율 (completed = TRUE인 비율)
-- 을 계산하되, 10곡 이상 들은 사용자만 표시하세요.

-- 힌트 1: TRUE는 1, FALSE는 0 을 나타냄
-- 힌트 2: PostgreSQL에서는 BOOLEAN을 :: INTEGER를 사용해 간단히 변환 가능


-- 5. 테이블 종합
-- 문제 5-1: 트랙 제목과 해당 앨범 제목을 함께 조회하세요.
-- 문제 5-2: 앨범 제목, 아티스트 이름, 발매일을 함께 조회하세요.
-- 문제 5-3: 플레이리스트 이름과 소유자(사용자) 이름을 함께 조회하세요.
-- 문제 5-4: 각 트랙의 제목, 장르 이름, 재생 시간을 조회하세요.
-- 문제 5-5: 트랙 제목, 앨범 제목, 아티스트 이름, 장르 이름을 모두 함께 조회하세요.
-- 문제 5-6: 사용자 이름, 구독 요금제 이름, 월 요금을 함께 조회하세요. (현재 활성 구독만)
-- 문제 5-7: 플레이리스트에 담긴 트랙 정보를 조회하세요:
-- - 플레이리스트 이름
-- - 트랙 제목
-- - 아티스트 이름
-- - 추가된 날짜
--
-- 문제 5-8: 각 사용자가 들은 음악의 아티스트 정보를 조회하세요:
-- - 사용자 이름
-- - 트랙 제목
-- - 아티스트 이름
-- - 청취 시간
--
-- 문제 5-9: 모든 앨범과 해당 앨범의 트랙 수를 조회하세요. (트랙이 없는 앨범도 포함)
-- 문제 5-10: 모든 사용자와 그들의 플레이리스트 수를 조회하세요.
-- 문제 5-11: 모든 아티스트와 팔로워 수를 조회하세요.
-- 문제 5-12: 모든 트랙과 플레이리스트 추가 횟수를 조회하세요. (한 번도 플레이리스트에 추가되지 않은 트랙도 포함)
-- 문제 5-13: 트랙이 하나도 없는 앨범을 찾으세요.
-- 문제 5-14: 플레이리스트가 하나도 없는 사용자를 찾으세요.
-- 문제 5-15: 팔로워가 한 명도 없는 아티스트를 찾으세요.
-- 문제 5-16: 한 번도 재생되지 않은 트랙을 찾으세요.
-- 문제 5-17: 구독 이력이 없는 사용자를 찾으세요.
-- 문제 5-18: 모든 아티스트의 앨범 수와 트랙 수를 조회하세요.
-- 문제 5-19: 각 장르의 트랙 수와 총 재생 횟수를 조회하세요. (트랙이 없는 장르도 포함, 0으로 표시) -- 힌트: COALESCE(값, 대체값) 함수를 사용하면 NULL을 다른 값으로 대체할 수 있습니다.
-- 문제 5-20: 모든 사용자의 구독 상태를 조회하세요:
-- - 사용자 이름
-- - 현재 구독 요금제 (없으면 'Free')
-- - 구독 시작일 (없으면 NULL)
-- - 월 요금 (없으면 0)
-- 힌트: COALESCE(값, 대체값) 함수를 사용하면 NULL을 다른 값으로 대체할 수 있습니다.

-- 문제 5-21: 모든 플레이리스트의 상세 정보를 조회하세요:
-- - 플레이리스트 이름
-- - 소유자 이름
-- - 트랙 수 (0개 포함)
-- - 총 재생 시간 (트랙들의 duration 합계)
-- - 트랙이 없으면 0 표시

-- 문제 5-22: 각 사용자와 그들의 최근 청취 날짜를 조회하세요. (한 번도 듣지 않은 사용자는 NULL 표시)
-- 문제 5-23: (구독자가 없는 요금제도 포함하여)모든 구독 요금제와 현재 구독자 수를 RIGHT JOIN으로 조회하세요.
-- 문제 5-24: 모든 사용자와 모든 아티스트의 조합을 만들어 팔로우 관계를 확인하세요:
-- - 사용자 이름
-- - 아티스트 이름
-- - 팔로우 날짜 (팔로우하지 않으면 'Not Following' 표시)
-- 힌트: CROSS JOIN으로 모든 조합을 만든 후, COALESCE 함수로 NULL을 대체할 수 있습니다.


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

-- Part 8: DML
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
