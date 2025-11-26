### **문제 2-1: Genre 데이터 삽입**

다음 표의 데이터를 `genre` 테이블에 삽입하세요. (8개 장르)

| name | description | created_at |
|------|-------------|------------|
| Pop | Popular mainstream music with catchy melodies | 2024-01-01 10:00:00 |
| Rock | Guitar-driven music with strong beats | 2024-01-01 10:00:00 |
| Jazz | Improvisational music with complex harmonies | 2024-01-01 10:00:00 |
| Classical | Traditional orchestral and chamber music | 2024-01-01 10:00:00 |
| Hip Hop | Rhythmic music with rap vocals | 2024-01-01 10:00:00 |
| Electronic | Synthesizer and computer-generated music | 2024-01-01 10:00:00 |
| R&B | Rhythm and blues with soulful vocals | 2024-01-01 10:00:00 |
| Country | American folk music with storytelling lyrics | 2024-01-01 10:00:00 |

**힌트**: 한 번의 INSERT 문으로 여러 행을 삽입할 수 있습니다.
```sql
INSERT INTO 테이블명 (컬럼1, 컬럼2, ...) VALUES
(값1, 값2, ...),
(값1, 값2, ...),
...;
```

---

### **문제 2-2: Subscription Plan 데이터 삽입**

다음 표의 데이터를 `subscription_plan` 테이블에 삽입하세요. (3개 요금제)

| plan_name | monthly_price | max_offline_downloads | ad_free |
|-----------|---------------|----------------------|---------|
| free | 0.00 | 0 | FALSE |
| basic | 4.99 | 10 | FALSE |
| premium | 9.99 | 999 | TRUE |

---

### **문제 2-3: Artist 데이터 삽입 (일부)**

다음 표의 아티스트 5명을 `artist` 테이블에 삽입하세요.

| name | country | debut_year | created_at |
|------|---------|------------|------------|
| The Beatles | UK | 1960 | 2024-01-15 09:00:00 |
| BTS | South Korea | 2013 | 2024-01-15 09:30:00 |
| Taylor Swift | USA | 2006 | 2024-01-15 10:00:00 |
| Ed Sheeran | UK | 2011 | 2024-01-15 10:30:00 |
| Billie Eilish | USA | 2015 | 2024-01-15 11:00:00 |

---

### **문제 2-4: User Account 데이터 삽입 (일부)**

다음 표의 사용자 5명을 `user_account` 테이블에 삽입하세요.

| email | username | birth_date | country | created_at | is_active |
|-------|----------|------------|---------|------------|-----------|
| john.doe@gmail.com | john_music | 1990-05-15 | USA | 2024-01-01 08:00:00 | TRUE |
| sarah.kim@naver.com | sarah_k | 1995-08-22 | South Korea | 2024-01-05 10:30:00 | TRUE |
| mike.wilson@yahoo.com | mike_w | 1988-03-10 | UK | 2024-02-10 14:20:00 | TRUE |
| emma.brown@gmail.com | emma_b | 1992-11-28 | Canada | 2024-02-15 09:45:00 | TRUE |
| david.lee@outlook.com | david_music | 1985-07-03 | South Korea | 2024-03-01 11:00:00 | TRUE |

---

### **문제 2-5: Album 데이터 삽입 (일부)**

다음 표의 앨범 3개를 `album` 테이블에 삽입하세요.

| title | artist_id | release_date | total_tracks | created_at |
|-------|-----------|--------------|--------------|------------|
| Abbey Road | 1 | 1969-09-26 | 17 | 2024-01-20 10:00:00 |
| Map of the Soul: 7 | 2 | 2020-02-21 | 20 | 2024-01-21 11:00:00 |
| 1989 | 3 | 2014-10-27 | 13 | 2024-01-22 12:00:00 |

---

### **문제 2-6: Track 데이터 삽입 (일부)**

다음 표의 트랙 5개를 `track` 테이블에 삽입하세요.

| title | album_id | genre_id | duration_seconds | track_number | play_count | created_at |
|-------|----------|----------|------------------|--------------|------------|------------|
| Come Together | 1 | 2 | 259 | 1 | 15420 | 2024-01-20 10:00:00 |
| Something | 1 | 2 | 182 | 2 | 12350 | 2024-01-20 10:05:00 |
| ON | 2 | 5 | 241 | 1 | 45000 | 2024-01-21 11:00:00 |
| Shake It Off | 3 | 1 | 219 | 1 | 67000 | 2024-01-22 12:00:00 |
| Blank Space | 3 | 1 | 231 | 2 | 71000 | 2024-01-22 12:05:00 |

---
