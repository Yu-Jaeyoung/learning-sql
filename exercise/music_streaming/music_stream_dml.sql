-- ============================================
-- 음악 스트리밍 서비스 샘플 데이터
-- ============================================

-- ============================================
-- 나머지 Artist 데이터 (10명 추가)
-- ============================================
INSERT
  INTO artist (name, country, debut_year, created_at)
VALUES ('Drake', 'Canada', 2006, '2024-01-15 11:30:00')
     , ('Adele', 'UK', 2008, '2024-01-15 12:00:00')
     , ('The Weeknd', 'Canada', 2010, '2024-01-15 12:30:00')
     , ('Ariana Grande', 'USA', 2013, '2024-01-15 13:00:00')
     , ('Bruno Mars', 'USA', 2010, '2024-01-15 13:30:00')
     , ('Coldplay', 'UK', 1996, '2024-01-15 14:00:00')
     , ('Dua Lipa', 'UK', 2015, '2024-01-15 14:30:00')
     , ('Post Malone', 'USA', 2015, '2024-01-15 15:00:00')
     , ('Olivia Rodrigo', 'USA', 2021, '2024-01-15 15:30:00')
     , ('NewBie Artist', 'USA', 2024, '2024-01-15 16:00:00');

-- ============================================
-- 나머지 User Account 데이터 (15명 추가)
-- ============================================
INSERT
  INTO user_account (email, username, birth_date, country, created_at, is_active)
VALUES ('lisa.anderson@gmail.com', 'lisa_a', '1998-01-17', 'USA', '2024-03-10 16:30:00', TRUE)
     , ('james.taylor@gmail.com', 'james_t', '1991-09-25', 'UK', '2024-04-01 10:00:00', TRUE)
     , ('sophia.martinez@yahoo.com', 'sophia_m', '1994-12-08', 'USA', '2024-04-15 13:20:00', TRUE)
     , ('robert.park@naver.com', 'robert_p', '1987-06-14', 'South Korea', '2024-05-01 15:40:00', TRUE)
     , ('olivia.johnson@gmail.com', 'olivia_j', '1996-04-20', 'Canada', '2024-05-20 09:15:00', TRUE)
     , ('william.davis@outlook.com', 'william_d', '1993-10-11', 'USA', '2024-06-01 11:30:00', TRUE)
     , ('ava.garcia@gmail.com', 'ava_g', '1997-02-28', 'USA', '2024-06-15 14:45:00', TRUE)
     , ('daniel.choi@gmail.com', 'daniel_c', '1989-08-05', 'South Korea', '2024-07-01 10:20:00', TRUE)
     , ('mia.rodriguez@yahoo.com', 'mia_r', '1995-03-19', 'Canada', '2024-07-20 16:00:00', TRUE)
     , ('lucas.white@gmail.com', 'lucas_w', '1990-12-30', 'UK', '2024-08-01 09:30:00', TRUE)
     , ('inactive.user@gmail.com', 'inactive_u', '1992-05-10', 'USA', '2023-01-01 10:00:00', FALSE)
     , ('new.user@gmail.com', 'new_user', '2000-01-01', 'USA', '2024-11-01 08:00:00', TRUE)
     , ('premium.lover@gmail.com', 'premium_l', '1991-07-15', 'USA', '2024-01-10 10:00:00', TRUE)
     , ('basic.user@gmail.com', 'basic_u', '1993-09-20', 'UK', '2024-02-01 11:00:00', TRUE)
     , ('free.listener@gmail.com', 'free_l', '1995-11-25', 'Canada', '2024-03-01 12:00:00', TRUE);

-- ============================================
-- 나머지 Album 데이터 (27개 추가)
-- ============================================
INSERT
  INTO album (title, artist_id, release_date, total_tracks, created_at)
VALUES ('Let It Be', 1, '1970-05-08', 12, '2024-01-20 10:30:00')
     , ('BE', 2, '2020-11-20', 8, '2024-01-21 11:30:00')
     , ('Midnights', 3, '2022-10-21', 13, '2024-01-22 12:30:00')
     , ('Folklore', 3, '2020-07-24', 16, '2024-01-22 13:00:00')
     , ('Divide', 4, '2017-03-03', 12, '2024-01-23 14:00:00')
     , ('Equals', 4, '2021-10-29', 14, '2024-01-23 14:30:00')
     , ('Happier Than Ever', 5, '2021-07-30', 16, '2024-01-24 15:00:00')
     , ('When We All Fall Asleep', 5, '2019-03-29', 14, '2024-01-24 15:30:00')
     , ('Certified Lover Boy', 6, '2021-09-03', 21, '2024-01-25 16:00:00')
     , ('Scorpion', 6, '2018-06-29', 25, '2024-01-25 16:30:00')
     , ('30', 7, '2021-11-19', 12, '2024-01-26 17:00:00')
     , ('25', 7, '2015-11-20', 11, '2024-01-26 17:30:00')
     , ('After Hours', 8, '2020-03-20', 14, '2024-01-27 18:00:00')
     , ('Dawn FM', 8, '2022-01-07', 16, '2024-01-27 18:30:00')
     , ('Positions', 9, '2020-10-30', 14, '2024-01-28 10:00:00')
     , ('Thank U Next', 9, '2019-02-08', 12, '2024-01-28 10:30:00')
     , ('24K Magic', 10, '2016-11-18', 9, '2024-01-29 11:00:00')
     , ('Music of the Spheres', 11, '2021-10-15', 12, '2024-01-30 12:00:00')
     , ('A Head Full of Dreams', 11, '2015-12-04', 11, '2024-01-30 12:30:00')
     , ('Future Nostalgia', 12, '2020-03-27', 11, '2024-02-01 13:00:00')
     , ('Hollywood''s Bleeding', 13, '2019-09-06', 17, '2024-02-02 14:00:00')
     , ('Twelve Carat Toothache', 13, '2022-06-03', 14, '2024-02-02 14:30:00')
     , ('SOUR', 14, '2021-05-21', 11, '2024-02-03 15:00:00')
     , ('GUTS', 14, '2023-09-08', 12, '2024-02-03 15:30:00')
     , ('Unreleased Album', 3, '2024-12-01', 0, '2024-11-01 10:00:00')
     , ('Studio Sessions', 7, NULL, 0, '2024-11-15 11:00:00');

-- ============================================
-- 나머지 Track 데이터 (110개 추가)
-- ============================================

-- Album 1: Abbey Road (The Beatles) - 3개 추가
INSERT
  INTO track (title, album_id, genre_id, duration_seconds, track_number, play_count, created_at)
VALUES ('Here Comes The Sun', 1, 2, 185, 3, 18900, '2024-01-20 10:10:00')
     , ('Because', 1, 2, 165, 4, 8500, '2024-01-20 10:15:00')
     , ('Golden Slumbers', 1, 2, 91, 5, 9200, '2024-01-20 10:20:00');

-- Album 2: Let It Be (The Beatles)
INSERT
  INTO track (title, album_id, genre_id, duration_seconds, track_number, play_count, created_at)
VALUES ('Let It Be', 2, 2, 243, 1, 22000, '2024-01-20 11:00:00')
     , ('Get Back', 2, 2, 189, 2, 11000, '2024-01-20 11:05:00')
     , ('The Long and Winding Road', 2, 2, 218, 3, 9800, '2024-01-20 11:10:00');

-- Album 3: Map of the Soul: 7 (BTS) - 4개 추가
INSERT
  INTO track (title, album_id, genre_id, duration_seconds, track_number, play_count, created_at)
VALUES ('Black Swan', 3, 5, 197, 2, 38000, '2024-01-21 11:05:00')
     , ('My Time', 3, 7, 224, 3, 28000, '2024-01-21 11:10:00')
     , ('Louder than bombs', 3, 1, 229, 4, 25000, '2024-01-21 11:15:00')
     , ('UGH!', 3, 5, 228, 5, 22000, '2024-01-21 11:20:00');

-- Album 4: BE (BTS)
INSERT
  INTO track (title, album_id, genre_id, duration_seconds, track_number, play_count, created_at)
VALUES ('Life Goes On', 4, 1, 207, 1, 52000, '2024-01-21 12:00:00')
     , ('Dynamite', 4, 1, 199, 2, 88000, '2024-01-21 12:05:00')
     , ('Blue & Grey', 4, 1, 254, 3, 31000, '2024-01-21 12:10:00');

-- Album 5: 1989 (Taylor Swift) - 3개 추가
INSERT
  INTO track (title, album_id, genre_id, duration_seconds, track_number, play_count, created_at)
VALUES ('Style', 5, 1, 231, 3, 54000, '2024-01-22 12:10:00')
     , ('Bad Blood', 5, 1, 211, 4, 48000, '2024-01-22 12:15:00')
     , ('Wildest Dreams', 5, 1, 220, 5, 59000, '2024-01-22 12:20:00');

-- Album 6: Midnights (Taylor Swift)
INSERT
  INTO track (title, album_id, genre_id, duration_seconds, track_number, play_count, created_at)
VALUES ('Anti-Hero', 6, 1, 200, 1, 95000, '2024-01-22 13:00:00')
     , ('Lavender Haze', 6, 1, 202, 2, 68000, '2024-01-22 13:05:00')
     , ('Midnight Rain', 6, 1, 174, 3, 52000, '2024-01-22 13:10:00')
     , ('Snow On The Beach', 6, 1, 256, 4, 45000, '2024-01-22 13:15:00');

-- Album 7: Folklore (Taylor Swift)
INSERT
  INTO track (title, album_id, genre_id, duration_seconds, track_number, play_count, created_at)
VALUES ('cardigan', 7, 1, 239, 1, 78000, '2024-01-22 14:00:00')
     , ('exile', 7, 1, 284, 2, 64000, '2024-01-22 14:05:00')
     , ('the last great american dynasty', 7, 1, 232, 3, 43000, '2024-01-22 14:10:00')
     , ('august', 7, 1, 261, 4, 71000, '2024-01-22 14:15:00');

-- Album 8: Divide (Ed Sheeran)
INSERT
  INTO track (title, album_id, genre_id, duration_seconds, track_number, play_count, created_at)
VALUES ('Shape of You', 8, 1, 233, 1, 125000, '2024-01-23 14:00:00')
     , ('Perfect', 8, 1, 263, 2, 98000, '2024-01-23 14:05:00')
     , ('Castle on the Hill', 8, 1, 261, 3, 67000, '2024-01-23 14:10:00')
     , ('Galway Girl', 8, 1, 170, 4, 58000, '2024-01-23 14:15:00');

-- Album 9: Equals (Ed Sheeran)
INSERT
  INTO track (title, album_id, genre_id, duration_seconds, track_number, play_count, created_at)
VALUES ('Shivers', 9, 1, 207, 1, 72000, '2024-01-23 15:00:00')
     , ('Bad Habits', 9, 1, 230, 2, 89000, '2024-01-23 15:05:00')
     , ('Overpass Graffiti', 9, 1, 236, 3, 45000, '2024-01-23 15:10:00');

-- Album 10: Happier Than Ever (Billie Eilish)
INSERT
  INTO track (title, album_id, genre_id, duration_seconds, track_number, play_count, created_at)
VALUES ('Happier Than Ever', 10, 1, 298, 1, 82000, '2024-01-24 15:00:00')
     , ('my future', 10, 7, 210, 2, 56000, '2024-01-24 15:05:00')
     , ('Oxytocin', 10, 6, 204, 3, 48000, '2024-01-24 15:10:00')
     , ('Lost Cause', 10, 1, 233, 4, 62000, '2024-01-24 15:15:00');

-- Album 11: When We All Fall Asleep (Billie Eilish)
INSERT
  INTO track (title, album_id, genre_id, duration_seconds, track_number, play_count, created_at)
VALUES ('bad guy', 11, 6, 194, 1, 156000, '2024-01-24 16:00:00')
     , ('bury a friend', 11, 6, 193, 2, 78000, '2024-01-24 16:05:00')
     , ('when the party''s over', 11, 1, 195, 3, 91000, '2024-01-24 16:10:00');

-- Album 12: Certified Lover Boy (Drake)
INSERT
  INTO track (title, album_id, genre_id, duration_seconds, track_number, play_count, created_at)
VALUES ('Champagne Poetry', 12, 5, 334, 1, 65000, '2024-01-25 16:00:00')
     , ('Way 2 Sexy', 12, 5, 262, 2, 98000, '2024-01-25 16:05:00')
     , ('Girls Want Girls', 12, 5, 244, 3, 72000, '2024-01-25 16:10:00')
     , ('Fair Trade', 12, 5, 291, 4, 54000, '2024-01-25 16:15:00');

-- Album 13: Scorpion (Drake)
INSERT
  INTO track (title, album_id, genre_id, duration_seconds, track_number, play_count, created_at)
VALUES ('God''s Plan', 13, 5, 198, 1, 178000, '2024-01-25 17:00:00')
     , ('In My Feelings', 13, 5, 217, 2, 142000, '2024-01-25 17:05:00')
     , ('Nice For What', 13, 5, 210, 3, 98000, '2024-01-25 17:10:00');

-- Album 14: 30 (Adele)
INSERT
  INTO track (title, album_id, genre_id, duration_seconds, track_number, play_count, created_at)
VALUES ('Easy On Me', 14, 1, 224, 1, 112000, '2024-01-26 17:00:00')
     , ('Oh My God', 14, 1, 225, 2, 67000, '2024-01-26 17:05:00')
     , ('I Drink Wine', 14, 1, 384, 3, 58000, '2024-01-26 17:10:00');

-- Album 15: 25 (Adele)
INSERT
  INTO track (title, album_id, genre_id, duration_seconds, track_number, play_count, created_at)
VALUES ('Hello', 15, 1, 295, 1, 198000, '2024-01-26 18:00:00')
     , ('When We Were Young', 15, 1, 291, 2, 125000, '2024-01-26 18:05:00')
     , ('Send My Love', 15, 1, 223, 3, 89000, '2024-01-26 18:10:00');

-- Album 16: After Hours (The Weeknd)
INSERT
  INTO track (title, album_id, genre_id, duration_seconds, track_number, play_count, created_at)
VALUES ('Blinding Lights', 16, 7, 200, 1, 245000, '2024-01-27 18:00:00')
     , ('Save Your Tears', 16, 7, 215, 2, 187000, '2024-01-27 18:05:00')
     , ('In Your Eyes', 16, 7, 237, 3, 98000, '2024-01-27 18:10:00')
     , ('Heartless', 16, 7, 198, 4, 112000, '2024-01-27 18:15:00');

-- Album 17: Dawn FM (The Weeknd)
INSERT
  INTO track (title, album_id, genre_id, duration_seconds, track_number, play_count, created_at)
VALUES ('Take My Breath', 17, 6, 339, 1, 87000, '2024-01-27 19:00:00')
     , ('Sacrifice', 17, 6, 188, 2, 76000, '2024-01-27 19:05:00')
     , ('Out of Time', 17, 7, 214, 3, 68000, '2024-01-27 19:10:00');

-- Album 18: Positions (Ariana Grande)
INSERT
  INTO track (title, album_id, genre_id, duration_seconds, track_number, play_count, created_at)
VALUES ('positions', 18, 7, 172, 1, 145000, '2024-01-28 10:00:00')
     , ('34+35', 18, 1, 173, 2, 128000, '2024-01-28 10:05:00')
     , ('motive', 18, 7, 162, 3, 87000, '2024-01-28 10:10:00');

-- Album 19: Thank U Next (Ariana Grande)
INSERT
  INTO track (title, album_id, genre_id, duration_seconds, track_number, play_count, created_at)
VALUES ('thank u, next', 19, 1, 207, 1, 198000, '2024-01-28 11:00:00')
     , ('7 rings', 19, 5, 178, 2, 215000, '2024-01-28 11:05:00')
     , ('break up with your girlfriend', 19, 1, 190, 3, 112000, '2024-01-28 11:10:00');

-- Album 20: 24K Magic (Bruno Mars)
INSERT
  INTO track (title, album_id, genre_id, duration_seconds, track_number, play_count, created_at)
VALUES ('24K Magic', 20, 7, 226, 1, 132000, '2024-01-29 11:00:00')
     , ('That''s What I Like', 20, 7, 206, 2, 178000, '2024-01-29 11:05:00')
     , ('Finesse', 20, 7, 197, 3, 145000, '2024-01-29 11:10:00');

-- Album 21: Music of the Spheres (Coldplay)
INSERT
  INTO track (title, album_id, genre_id, duration_seconds, track_number, play_count, created_at)
VALUES ('Higher Power', 21, 2, 203, 1, 78000, '2024-01-30 12:00:00')
     , ('My Universe', 21, 1, 227, 2, 112000, '2024-01-30 12:05:00')
     , ('Let Somebody Go', 21, 2, 255, 3, 56000, '2024-01-30 12:10:00');

-- Album 22: A Head Full of Dreams (Coldplay)
INSERT
  INTO track (title, album_id, genre_id, duration_seconds, track_number, play_count, created_at)
VALUES ('Adventure of a Lifetime', 22, 2, 263, 1, 98000, '2024-01-30 13:00:00')
     , ('Hymn for the Weekend', 22, 2, 258, 2, 134000, '2024-01-30 13:05:00')
     , ('Up&Up', 22, 2, 406, 3, 67000, '2024-01-30 13:10:00');

-- Album 23: Future Nostalgia (Dua Lipa)
INSERT
  INTO track (title, album_id, genre_id, duration_seconds, track_number, play_count, created_at)
VALUES ('Don''t Start Now', 23, 1, 183, 1, 198000, '2024-02-01 13:00:00')
     , ('Physical', 23, 1, 193, 2, 145000, '2024-02-01 13:05:00')
     , ('Levitating', 23, 1, 203, 3, 223000, '2024-02-01 13:10:00')
     , ('Break My Heart', 23, 1, 221, 4, 112000, '2024-02-01 13:15:00');

-- Album 24: Hollywood's Bleeding (Post Malone)
INSERT
  INTO track (title, album_id, genre_id, duration_seconds, track_number, play_count, created_at)
VALUES ('Circles', 24, 1, 215, 1, 187000, '2024-02-02 14:00:00')
     , ('Sunflower', 24, 5, 158, 2, 245000, '2024-02-02 14:05:00')
     , ('Wow', 24, 5, 149, 3, 156000, '2024-02-02 14:10:00')
     , ('Goodbyes', 24, 5, 175, 4, 98000, '2024-02-02 14:15:00');

-- Album 25: Twelve Carat Toothache (Post Malone)
INSERT
  INTO track (title, album_id, genre_id, duration_seconds, track_number, play_count, created_at)
VALUES ('Cooped Up', 25, 5, 155, 1, 67000, '2024-02-02 15:00:00')
     , ('I Like You', 25, 1, 193, 2, 78000, '2024-02-02 15:05:00')
     , ('One Right Now', 25, 1, 179, 3, 89000, '2024-02-02 15:10:00');

-- Album 26: SOUR (Olivia Rodrigo)
INSERT
  INTO track (title, album_id, genre_id, duration_seconds, track_number, play_count, created_at)
VALUES ('drivers license', 26, 1, 242, 1, 289000, '2024-02-03 15:00:00')
     , ('good 4 u', 26, 2, 178, 2, 267000, '2024-02-03 15:05:00')
     , ('deja vu', 26, 1, 215, 3, 178000, '2024-02-03 15:10:00')
     , ('traitor', 26, 1, 229, 4, 145000, '2024-02-03 15:15:00');

-- Album 27: GUTS (Olivia Rodrigo)
INSERT
  INTO track (title, album_id, genre_id, duration_seconds, track_number, play_count, created_at)
VALUES ('vampire', 27, 1, 219, 1, 198000, '2024-02-03 16:00:00')
     , ('get him back!', 27, 1, 211, 2, 134000, '2024-02-03 16:05:00')
     , ('all-american bitch', 27, 2, 170, 3, 98000, '2024-02-03 16:10:00')
     , ('ballad of a homeschooled girl', 27, 2, 170, 4, 87000, '2024-02-03 16:15:00');

-- 인기 없는 트랙들 (테스트용)
INSERT
  INTO track (title, album_id, genre_id, duration_seconds, track_number, play_count, created_at)
VALUES ('Hidden Track 1', 1, 2, 180, 10, 50, '2024-01-20 10:30:00')
     , ('Unreleased Demo', 2, 2, 200, 10, 15, '2024-01-20 11:30:00')
     , ('B-side Track', 5, 1, 190, 10, 120, '2024-01-22 12:30:00');

-- ============================================
-- User Subscription 데이터
-- ============================================
INSERT
  INTO user_subscription (user_id, plan_id, start_date, end_date, is_active)
VALUES (1, 3, '2024-01-01', NULL, TRUE)
     , (2, 3, '2024-02-01', NULL, TRUE)
     , (18, 3, '2024-01-10', NULL, TRUE)
     , (3, 2, '2024-03-01', NULL, TRUE)
     , (4, 2, '2024-04-01', NULL, TRUE)
     , (19, 2, '2024-02-01', NULL, TRUE)
     , (5, 3, '2024-01-01', '2024-06-30', FALSE)
     , (6, 2, '2024-02-01', '2024-05-31', FALSE)
     , (7, 3, '2024-01-01', '2024-03-31', FALSE)
     , (7, 2, '2024-04-01', NULL, TRUE)
     , (8, 2, '2024-01-01', '2024-02-28', FALSE)
     , (8, 3, '2024-05-01', NULL, TRUE)
     , (9, 3, '2024-10-01', NULL, TRUE)
     , (10, 2, '2024-10-15', NULL, TRUE);

-- ============================================
-- Playlist 데이터
-- ============================================
INSERT
  INTO playlist (user_id, name, description, is_public, created_at, updated_at)
VALUES (1, 'My Favorites', 'All time favorite songs', TRUE, '2024-01-05 10:00:00', '2024-11-01 14:30:00')
     , (1, 'Workout Mix', 'High energy songs for gym', TRUE, '2024-02-10 11:00:00', '2024-10-15 09:20:00')
     , (1, 'Chill Vibes', 'Relaxing evening playlist', FALSE, '2024-03-01 15:00:00', '2024-09-20 18:45:00')
     , (2, 'K-Pop Hits', 'Best Korean pop music', TRUE, '2024-01-10 09:00:00', '2024-11-05 12:00:00')
     , (2, 'Study Music', 'Concentration playlist', FALSE, '2024-04-01 14:00:00', '2024-10-20 16:30:00')
     , (3, 'Rock Legends', 'Classic rock collection', TRUE, '2024-02-15 10:30:00', '2024-10-10 11:15:00')
     , (3, 'Morning Coffee', 'Perfect songs for morning', FALSE, '2024-05-01 08:00:00', '2024-11-01 07:45:00')
     , (4, 'Pop Party', 'Party time hits', TRUE, '2024-02-20 16:00:00', '2024-10-25 19:30:00')
     , (5, 'R&B Soul', 'Smooth R&B tracks', TRUE, '2024-03-05 12:00:00', '2024-09-15 14:20:00')
     , (5, 'Late Night', 'Midnight listening', FALSE, '2024-06-01 23:00:00', '2024-10-30 22:15:00')
     , (6, 'Summer Hits 2024', 'Hot summer songs', TRUE, '2024-06-01 10:00:00', '2024-10-15 11:30:00')
     , (7, 'UK Chart Toppers', 'British music collection', TRUE, '2024-04-10 13:00:00', '2024-11-02 15:45:00')
     , (8, 'Throwback Playlist', '2010s nostalgia', TRUE, '2024-04-20 11:00:00', '2024-10-18 13:20:00')
     , (8, 'Road Trip Mix', 'Long drive playlist', FALSE, '2024-07-01 09:00:00', '2024-10-22 10:30:00')
     , (9, 'Hip Hop Essentials', 'Must-listen hip hop', TRUE, '2024-05-05 14:00:00', '2024-11-01 16:00:00')
     , (10, 'Indie Discoveries', 'Hidden gems', TRUE, '2024-05-25 10:00:00', '2024-10-28 11:45:00')
     , (10, 'Rainy Day', 'Mood for rainy weather', FALSE, '2024-08-01 16:00:00', '2024-10-20 17:30:00')
     , (11, 'Electronic Beats', 'EDM and electronic', TRUE, '2024-06-05 15:00:00', '2024-10-15 14:20:00')
     , (12, 'Love Songs', 'Romantic collection', TRUE, '2024-06-20 12:00:00', '2024-11-03 13:45:00')
     , (13, 'Motivation', 'Inspiring tracks', FALSE, '2024-07-05 09:00:00', '2024-10-25 10:15:00')
     , (14, 'Acoustic Sessions', 'Unplugged versions', TRUE, '2024-07-25 11:00:00', '2024-10-30 12:30:00')
     , (15, 'Jazz Classics', 'Timeless jazz', TRUE, '2024-08-05 14:00:00', '2024-10-12 15:45:00')
     , (18, 'Premium Collection', 'High quality tracks', TRUE, '2024-01-15 10:00:00', '2024-11-05 11:20:00')
     , (18, 'Discover Weekly', 'New discoveries', FALSE, '2024-05-01 09:00:00', '2024-11-01 10:30:00')
     , (17, 'Empty Playlist', 'Just created', FALSE, '2024-11-05 08:00:00', '2024-11-05 08:00:00');

-- ============================================
-- Playlist_Track 데이터 (샘플만 제공)
-- ============================================
INSERT
  INTO playlist_track (playlist_id, track_id, added_at, position)
VALUES (1, 1, '2024-01-05 10:30:00', 1)
     , (1, 29, '2024-01-10 14:20:00', 2)
     , (1, 46, '2024-02-15 11:45:00', 3)
     , (1, 56, '2024-03-20 16:30:00', 4)
     , (1, 62, '2024-04-10 09:15:00', 5)
     , (1, 70, '2024-05-05 13:40:00', 6)
     , (1, 76, '2024-06-01 10:20:00', 7)
     , (1, 83, '2024-07-15 15:50:00', 8)
     , (1, 97, '2024-08-20 12:30:00', 9)
     , (1, 20, '2024-09-10 14:00:00', 10)
     , (2, 29, '2024-02-10 11:30:00', 1)
     , (2, 30, '2024-02-10 11:35:00', 2)
     , (2, 32, '2024-02-10 11:40:00', 3)
     , (2, 46, '2024-02-10 11:45:00', 4)
     , (2, 50, '2024-02-10 11:50:00', 5)
     , (2, 76, '2024-02-10 11:55:00', 6)
     , (2, 98, '2024-02-10 12:00:00', 7)
     , (2, 95, '2024-02-10 12:05:00', 8)
     , (4, 10, '2024-01-10 09:30:00', 1)
     , (4, 11, '2024-01-10 09:35:00', 2)
     , (4, 12, '2024-01-10 09:40:00', 3)
     , (4, 13, '2024-01-10 09:45:00', 4)
     , (4, 14, '2024-01-10 09:50:00', 5)
     , (4, 15, '2024-01-10 09:55:00', 6)
     , (4, 16, '2024-01-10 10:00:00', 7)
     , (4, 17, '2024-01-10 10:05:00', 8)
     , (4, 90, '2024-02-15 11:20:00', 9);

-- ============================================
-- Listening_History 데이터 (샘플만 제공)
-- ============================================
INSERT
  INTO listening_history (user_id, track_id, played_at, listen_duration_seconds, completed)
VALUES (1, 1, '2024-09-01 08:15:00', 259, TRUE)
     , (1, 29, '2024-09-01 08:20:00', 233, TRUE)
     , (1, 70, '2024-09-02 09:30:00', 200, TRUE)
     , (1, 97, '2024-09-02 10:00:00', 242, TRUE)
     , (1, 56, '2024-09-03 14:20:00', 198, TRUE)
     , (1, 62, '2024-09-03 15:00:00', 224, TRUE)
     , (1, 83, '2024-09-04 11:30:00', 207, TRUE)
     , (1, 86, '2024-09-04 12:00:00', 183, TRUE)
     , (1, 46, '2024-09-05 16:45:00', 194, TRUE)
     , (1, 20, '2024-09-05 17:00:00', 200, TRUE)
     , (1, 3, '2024-11-01 10:00:00', 185, TRUE)
     , (1, 29, '2024-11-02 11:00:00', 233, TRUE)
     , (2, 10, '2024-09-01 09:00:00', 241, TRUE)
     , (2, 11, '2024-09-01 09:30:00', 197, TRUE)
     , (2, 12, '2024-09-01 10:00:00', 224, TRUE)
     , (2, 16, '2024-09-01 10:30:00', 199, TRUE)
     , (2, 10, '2024-11-01 09:00:00', 241, TRUE)
     , (2, 16, '2024-11-02 10:00:00', 199, TRUE)
     , (3, 1, '2024-10-01 10:00:00', 259, TRUE)
     , (3, 3, '2024-10-01 10:30:00', 185, TRUE)
     , (3, 6, '2024-11-01 10:00:00', 243, TRUE)
     , (4, 18, '2024-10-01 16:00:00', 219, TRUE)
     , (4, 19, '2024-10-01 16:30:00', 231, TRUE)
     , (4, 20, '2024-11-01 16:00:00', 200, TRUE)
     , (5, 70, '2024-10-01 20:00:00', 200, TRUE)
     , (5, 71, '2024-10-01 20:30:00', 215, TRUE)
     , (5, 79, '2024-11-01 20:00:00', 172, TRUE);

-- ============================================
-- Artist_Follower 데이터
-- ============================================
INSERT
  INTO artist_follower (user_id, artist_id, followed_at)
VALUES (1, 1, '2024-01-05 10:00:00')
     , (1, 3, '2024-01-05 10:05:00')
     , (1, 4, '2024-01-05 10:10:00')
     , (1, 6, '2024-02-10 11:00:00')
     , (1, 8, '2024-03-15 12:00:00')
     , (2, 2, '2024-01-05 10:30:00')
     , (2, 3, '2024-01-05 10:35:00')
     , (2, 4, '2024-02-10 11:30:00')
     , (2, 9, '2024-03-20 13:00:00')
     , (3, 1, '2024-02-10 14:20:00')
     , (3, 11, '2024-02-10 14:25:00')
     , (3, 14, '2024-03-15 15:00:00')
     , (4, 3, '2024-02-15 09:45:00')
     , (4, 5, '2024-02-15 09:50:00')
     , (4, 9, '2024-03-10 10:30:00')
     , (4, 12, '2024-04-20 11:45:00')
     , (5, 7, '2024-03-01 11:00:00')
     , (5, 8, '2024-03-01 11:05:00')
     , (5, 10, '2024-03-01 11:10:00');

-- ============================================
-- 데이터 확인
-- ============================================
SELECT 'genre'  AS table_name
     , COUNT(*) AS count
  FROM genre
 UNION ALL
SELECT 'artist'
     , COUNT(*)
  FROM artist
 UNION ALL
SELECT 'subscription_plan'
     , COUNT(*)
  FROM subscription_plan
 UNION ALL
SELECT 'user_account'
     , COUNT(*)
  FROM user_account
 UNION ALL
SELECT 'album'
     , COUNT(*)
  FROM album
 UNION ALL
SELECT 'track'
     , COUNT(*)
  FROM track
 UNION ALL
SELECT 'user_subscription'
     , COUNT(*)
  FROM user_subscription
 UNION ALL
SELECT 'playlist'
     , COUNT(*)
  FROM playlist
 UNION ALL
SELECT 'playlist_track'
     , COUNT(*)
  FROM playlist_track
 UNION ALL
SELECT 'listening_history'
     , COUNT(*)
  FROM listening_history
 UNION ALL
SELECT 'artist_follower'
     , COUNT(*)
  FROM artist_follower;
